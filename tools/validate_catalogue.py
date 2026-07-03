#!/usr/bin/env python3
"""Validate the threat-control catalogue and emit a flattened JSON view.

Reads the two hand-authored source files:
  spec/control-plane-layers.yaml     — 12 architectural enforcement points
  spec/threat-control-catalogue.yaml — 4 tiers -> 24 risks -> 60 controls

Checks internal consistency (IDs, cross-references, enums) and, unless
--check-only, writes a flattened machine-readable view to
  spec/threat-control-catalogue.json

That JSON is the single source consumed by:
  - the OPA workload gate  (gates/workload-controls.rego -> data.catalogue)
  - the platform prototype (docs/prototype.html)

Exit code is non-zero if any check fails, so CI blocks drift.

Usage:
  python3 tools/validate_catalogue.py            # validate + (re)write JSON
  python3 tools/validate_catalogue.py --check-only
"""
import json
import os
import pathlib
import sys

import yaml

ROOT = pathlib.Path(os.environ.get("REPO", ".")).resolve()
LAYERS = ROOT / "spec" / "control-plane-layers.yaml"
CATALOGUE = ROOT / "spec" / "threat-control-catalogue.yaml"
OUT = ROOT / "spec" / "threat-control-catalogue.json"

VALID_DOMAINS = {f"D{i}" for i in range(1, 9)}
VALID_GATES = {"A", "B", "C", "D"}
VALID_SIGNALS = {"build", "emerging", "buy_select", "commodity"}


def main() -> int:
    check_only = "--check-only" in sys.argv
    errors: list[str] = []

    layers_doc = yaml.safe_load(LAYERS.read_text())
    cat = yaml.safe_load(CATALOGUE.read_text())

    layers = {l["id"]: l for l in layers_doc["layers"]}

    # --- layer definitions --------------------------------------------------
    for lid, l in layers.items():
        for d in l["domains"]:
            if d not in VALID_DOMAINS:
                errors.append(f"layer {lid}: domain '{d}' is not D1-D8")
        if l["gate"] not in VALID_GATES:
            errors.append(f"layer {lid}: gate '{l['gate']}' is not A-D")

    # --- flatten controls ---------------------------------------------------
    controls: list[dict] = []
    risks: list[dict] = []
    seen_ids: set[str] = set()
    seen_risks: set[str] = set()

    for tier in cat["tiers"]:
        for risk in tier["risks"]:
            if risk["id"] in seen_risks:
                errors.append(f"duplicate risk id {risk['id']}")
            seen_risks.add(risk["id"])
            risks.append({"id": risk["id"], "name": risk["name"],
                          "tier": tier["id"], "tier_name": tier["name"]})
            if not risk.get("controls"):
                errors.append(f"risk {risk['id']} has no controls")
            for c in risk.get("controls", []):
                cid = c["id"]
                if cid in seen_ids:
                    errors.append(f"duplicate control id {cid}")
                seen_ids.add(cid)
                if c["layer"] not in layers:
                    errors.append(f"{cid}: layer '{c['layer']}' undefined")
                for d in c["domains"]:
                    if d not in VALID_DOMAINS:
                        errors.append(f"{cid}: domain '{d}' is not D1-D8")
                if c["gate"] not in VALID_GATES:
                    errors.append(f"{cid}: gate '{c['gate']}' is not A-D")
                if c["signal"] not in VALID_SIGNALS:
                    errors.append(f"{cid}: signal '{c['signal']}' invalid")
                if not isinstance(c["platforms"], int) or c["platforms"] < 0:
                    errors.append(f"{cid}: platforms must be a non-negative int")
                # signal must agree with the platform count band
                expect = band(c["platforms"])
                if c["signal"] != expect:
                    errors.append(
                        f"{cid}: platforms={c['platforms']} implies signal "
                        f"'{expect}' but is '{c['signal']}'")
                controls.append({
                    "id": cid, "name": c["name"],
                    "risk": risk["id"], "risk_name": risk["name"],
                    "tier": tier["id"], "tier_name": tier["name"],
                    "layer": c["layer"], "layer_name": layers[c["layer"]]["name"],
                    "domains": c["domains"], "gate": c["gate"],
                    "platforms": c["platforms"], "signal": c["signal"],
                })

    # --- IDs must be the contiguous sequence TC-001..TC-0NN -----------------
    expected = [f"TC-{i:03d}" for i in range(1, len(controls) + 1)]
    actual = [c["id"] for c in controls]
    if actual != expected:
        errors.append(f"control ids must be contiguous TC-001..TC-{len(controls):03d}; "
                      f"got {actual[:3]}...{actual[-1:]}")

    if errors:
        print(f"FAIL: {len(errors)} catalogue validation error(s):", file=sys.stderr)
        for e in errors:
            print(f"  - {e}", file=sys.stderr)
        return 1

    # --- rollups for the UI -------------------------------------------------
    signals = {s: 0 for s in VALID_SIGNALS}
    domain_primary = {d: 0 for d in sorted(VALID_DOMAINS)}
    for c in controls:
        signals[c["signal"]] += 1
        domain_primary[c["domains"][0]] += 1

    out = {
        "catalogue": {
            "version": cat.get("version", 1),
            "generated_by": "tools/validate_catalogue.py",
            "counts": {"controls": len(controls), "risks": len(risks),
                       "layers": len(layers)},
            "signals": signals,
            "domain_primary": domain_primary,
            "layers": list(layers.values()),
            "risks": risks,
            "controls": controls,
        }
    }

    if check_only:
        print(f"OK: {len(controls)} controls, {len(risks)} risks, "
              f"{len(layers)} layers — catalogue is valid (JSON not written).")
        return 0

    OUT.write_text(json.dumps(out, indent=2, ensure_ascii=False) + "\n")
    print(f"OK: {len(controls)} controls, {len(risks)} risks, {len(layers)} layers "
          f"-> {OUT.relative_to(ROOT)}")
    return 0


def band(platforms: int) -> str:
    if platforms == 0:
        return "build"
    if platforms <= 5:
        return "emerging"
    if platforms <= 15:
        return "buy_select"
    return "commodity"


if __name__ == "__main__":
    sys.exit(main())

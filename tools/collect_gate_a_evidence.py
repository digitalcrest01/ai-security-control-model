#!/usr/bin/env python3
"""Collect Gate A ("Known estate") evidence.

Combines the declared inventory (estate.yaml) with the set of identities that
are actually provisioned, and emits the JSON shape that gates/gate-a-known-estate.rego
evaluates. This is the IaC -> evidence -> gate bridge: the gate passes only when
every declared AI asset is classified, owned, risk-scored AND provisioned as a
managed non-human identity, with no Shadow AI over the risk threshold.

Provisioned identities come from one of:
  * a `terraform show -json` document (plan or state) — service accounts are
    extracted automatically, OR
  * a plain JSON array of account_ids.

If --provisioned is omitted, every declared asset is assumed provisioned
(declared mode) — useful for checking the classification/ownership controls
before anything is applied.

Usage:
  python3 tools/collect_gate_a_evidence.py \
      --estate environments/sandbox/estate.yaml \
      --provisioned plan.json \
      --out gate-a.evidence.json

Real-run recipe (after `terraform apply` / `plan -out`):
  terraform show -json plan.bin > plan.json
  python3 tools/collect_gate_a_evidence.py --provisioned plan.json > gate-a.evidence.json
"""
import argparse
import json
import sys


def load_yaml(path):
    try:
        import yaml
    except ImportError:
        sys.exit("error: PyYAML is required (pip install pyyaml)")
    with open(path, "r", encoding="utf-8") as fh:
        return yaml.safe_load(fh)


def extract_provisioned(path):
    """Return the set of provisioned service-account account_ids.

    Accepts a plain JSON array of ids, or a `terraform show -json` document
    (any nesting of modules) from which google_service_account.account_id values
    are harvested.
    """
    with open(path, "r", encoding="utf-8") as fh:
        doc = json.load(fh)

    if isinstance(doc, list):
        return {str(x) for x in doc}

    found = set()

    def walk(node):
        if isinstance(node, dict):
            if node.get("type") == "google_service_account":
                acct = (node.get("values") or {}).get("account_id")
                if acct:
                    found.add(acct)
            for v in node.values():
                walk(v)
        elif isinstance(node, list):
            for v in node:
                walk(v)

    walk(doc)
    return found


def build_evidence(estate, provisioned):
    assets_out = []
    non_human = []
    for a in estate.get("assets", []):
        asset_id = a.get("id")
        data_class = a.get("data_class")
        assets_out.append({
            "id": asset_id,
            "classified": bool(data_class),
            "owner": a.get("owner"),
            "risk_score": a.get("risk_score"),
        })
        managed = True if provisioned is None else asset_id in provisioned
        non_human.append({"id": asset_id, "managed": managed})

    return {
        "inventory": {
            "assets": assets_out,
            "shadow_ai": estate.get("shadow_ai", []) or [],
        },
        "identity": {"non_human": non_human},
        "thresholds": estate.get("thresholds", {"shadow_ai_risk": 4}),
    }


def main(argv=None):
    ap = argparse.ArgumentParser(description="Collect Gate A evidence from the estate inventory.")
    ap.add_argument("--estate", default="environments/sandbox/estate.yaml",
                    help="Path to the estate inventory YAML.")
    ap.add_argument("--provisioned", default=None,
                    help="terraform show -json document or JSON array of provisioned account_ids. "
                         "Omit to assume all declared assets are provisioned.")
    ap.add_argument("--out", default="-", help="Output path, or - for stdout.")
    args = ap.parse_args(argv)

    estate = load_yaml(args.estate)
    provisioned = extract_provisioned(args.provisioned) if args.provisioned else None
    evidence = build_evidence(estate, provisioned)

    text = json.dumps(evidence, indent=2) + "\n"
    if args.out == "-":
        sys.stdout.write(text)
    else:
        with open(args.out, "w", encoding="utf-8") as fh:
            fh.write(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

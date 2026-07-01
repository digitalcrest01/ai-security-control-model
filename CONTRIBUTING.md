# Contributing

This repository is the **AI Security Control Model** — a gated operating model
built as code. Contributions keep three things true: the tree matches the spec,
the policies parse and pass, and Terraform is valid and formatted. CI enforces
all three.

> Proprietary — see [`LICENSE`](LICENSE). Contribute only under the applicable
> agreement.

## Prerequisites

| Tool | Used for |
|---|---|
| [OPA](https://www.openpolicyagent.org/docs/latest/#running-opa) ≥ 0.59 | gate & domain policies (`rego.v1`) |
| [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.6 | IaC modules |
| Python ≥ 3.11 | `tools/scaffold.py` |

## The golden rule: `spec/` is the source of truth

Phases, domains, controls, standards and gates are defined in [`spec/`](spec)
and generated into the tree by [`tools/scaffold.py`](tools/scaffold.py).

**Do not hand-edit generated files** (the `domains/<slug>/` READMEs,
`controls.yaml`, Terraform `locals` control lists, or `spec/*.yaml`). Edit the
data in `tools/scaffold.py`, regenerate, and format:

```bash
python3 tools/scaffold.py
terraform fmt -recursive
```

CI's `spec` job re-runs the generator and fails if the result differs from what
you committed.

### Files you *do* hand-edit

- **Control status/owner/evidence** in each `domains/<slug>/controls.yaml`
  (`not_started → in_progress → implemented → verified`).
- **Real implementations** under `domains/<slug>/terraform/` and
  `domains/<slug>/policies/`, and the shared `modules/landing-zone/`.
- **Gate policies** under `gates/*.rego` and their example evidence/tests.

## Common changes

### Advance a control

1. Move its `status` forward in the domain's `controls.yaml`; set an `owner` and
   add `evidence` entries.
2. Implement it in `terraform/` and/or `policies/`.
3. Ensure the relevant assertion is exercised by the domain's phase gate under
   [`gates/`](gates) so the gate can see it.

### Add or change a gate criterion

1. Edit the gate's `.rego` under `gates/`. Each gate documents its expected
   `input` shape at the top of the file.
2. Update the matching `gates/examples/gate-*.input.json` so the example still
   passes (empty `deny`).
3. Add/extend tests (see `gates/gate-b-secure-by-build_test.rego`).

### Add a control, domain, phase or standard

Edit the `PHASES` / `DOMAINS` / `FLOW` data in `tools/scaffold.py`, then
regenerate. Update the control-count and tables in `README.md` and
`docs/` if the totals change. (`docs/index.html` carries its own copy of the
data model — keep it in step by hand.)

## Before you open a PR

Run the same checks CI runs:

```bash
opa check gates domains          # all policies parse
opa fmt --list --fail gates      # policies are formatted
opa test gates -v                # gate unit tests pass
terraform fmt -check -recursive  # terraform is formatted
python3 tools/scaffold.py && terraform fmt -recursive && git diff --exit-code
                                 # tree is in sync with spec (no diff)
```

For each gate you touched, confirm its example still clears:

```bash
opa eval -d gates -i gates/examples/gate-b.input.json 'data.gates.gate_b.deny'
# empty result == pass
```

## Commit & PR conventions

- One logical change per PR; keep generated and hand-authored changes in
  separate commits where practical.
- Reference the affected domain/gate IDs (e.g. `D2`, `Gate B`) in the summary.
- Green CI is required to merge.

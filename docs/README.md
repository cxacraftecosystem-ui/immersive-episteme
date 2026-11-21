<picture>
  <source media="(prefers-color-scheme: dark)" srcset="readme-kit/assets/divider-dark.svg">
  <img src="readme-kit/assets/divider-light.svg" width="100%" alt="">
</picture>

# <img src="readme-kit/assets/icons/book-open.svg" width="32" align="top" alt="">&nbsp; Documentation

Every document in this folder, by what it answers. The front page is the [README](../README.md); the binding design
specification is [DESIGN.md](../DESIGN.md), and the content files' format is [content/FORMAT.md](../content/FORMAT.md).

| Section | Holds |
|---|---|
| [Start here](#start-here) | running it, how it is built, why |
| [Architecture](#architecture) | structure, data model, telemetry, Door 2 |
| [Decisions](#decisions) | engineering ADRs and the design decision records |
| [Deployment](#deployment) | the runbook and the vendor research |
| [Research](#research) | study design, content, scoring, requirements |
| [Design process record](#design-process-record) | how the platform was designed, module by module |
| [Images and permissions](#images-and-permissions) | credits, licence requests and replies |
| [The README kit](#the-readme-kit) | how these pages are styled and checked |

## Start here

| Question | Read |
|---|---|
| How do I run, test and migrate it on my machine? | [development.md](development.md) |
| Which stack, and why? | [decisions/0001-stack-and-foundation.md](decisions/0001-stack-and-foundation.md) |
| How are routes, permissions and participant sessions built? | [architecture/foundation.md](architecture/foundation.md) |
| What is stored? | [architecture/knowledge-schema.md](architecture/knowledge-schema.md) |
| Why is it built the way it is? | [research/design-process/decisions.md](research/design-process/decisions.md) |

## Architecture

| Document | What it covers |
|---|---|
| [foundation.md](architecture/foundation.md) | the application's structure, the permission model and its enforcement layers, the participant-session model |
| [knowledge-schema.md](architecture/knowledge-schema.md) | the knowledge and research data schema, demo isolation, the invariants the database enforces, the import mapping |
| [knowledge-graph-validation.md](architecture/knowledge-graph-validation.md) | the knowledge-graph rules, the validation report and content snapshots |
| [data-and-telemetry-layer.md](architecture/data-and-telemetry-layer.md) | the learning context, the knowledge read model, telemetry ingestion and time accounting, dashboard rollups, content import |
| [spatial-compiler.md](architecture/spatial-compiler.md) | the deterministic knowledge-to-space compiler, its rules and validation |
| [immersive-rendering-quality.md](architecture/immersive-rendering-quality.md) | what Door 2 must meet: defect classes, performance budgets per tier, the verification protocol |
| [immersive-rendering-results.md](architecture/immersive-rendering-results.md) | the measured runs against that specification |
| [design-reuse-catalogue.md](architecture/design-reuse-catalogue.md) | what was taken from `virtual-walkthrough`, and what was not |

## Decisions

| Document | What it records |
|---|---|
| [decisions/0001-stack-and-foundation.md](decisions/0001-stack-and-foundation.md) | ADR 0001: the stack and the project foundation |
| [decisions/0002-feature-dependencies.md](decisions/0002-feature-dependencies.md) | ADR 0002: dependencies for the later waves |
| [decisions/0003-visual-system.md](decisions/0003-visual-system.md) | ADR 0003: the visual system and the choices fixed before data collection |
| [research/design-process/decisions.md](research/design-process/decisions.md) | the design decision records, DR-001 on: problem, options, decision, evidence and what each means for the paper |

## Deployment

| Document | What it covers |
|---|---|
| [deploy/RUNBOOK.md](deploy/RUNBOOK.md) | the step-by-step handover: the data-location decision, accounts, environment, preflight, deploy, production data, first staff account, invite codes, backups |
| [deploy/RESEARCH.md](deploy/RESEARCH.md) | the vendor research behind the runbook, with verbatim quotes |
| [deploy/aws-resources.md](deploy/aws-resources.md) | the AWS account and the resources and costs of Option A |

## Research

| Document | What it covers |
|---|---|
| [research/requirements-digest.md](research/requirements-digest.md) | the research requirements from the concept note |
| [research/technical-requirements.md](research/technical-requirements.md) | technical requirements from the concept note and the reference papers |
| [research/study-decisions.md](research/study-decisions.md) | the open study parameters, decided from the literature |
| [research/concept-map-scoring.md](research/concept-map-scoring.md) | concept-map scoring: definitions, matching rules, open questions |
| [research/content-dataset.md](research/content-dataset.md) | the six block-printing traditions in the dataset, and the study shortlist |
| [research/citation-policy.md](research/citation-policy.md) | how sources are cited |
| [research/photo-anchor-verification-sheet.md](research/photo-anchor-verification-sheet.md) | the photo anchor concepts, for curators to verify |
| [research/proposed-label-corrections.md](research/proposed-label-corrections.md) | label corrections proposed to the curation effort |
| [research/needs-lead-account.md](research/needs-lead-account.md) | items that need the lead's account or payment |

The research folder also holds its data: `substance-looks.json`, which `npm run content:look-rows` turns into
`src/features/process/domain/substance-look-rows.ts`, and `material-references.json`, `asset-candidates.json` and `technical-requirements.json`, the
records the decision log and the module records cite. `research/tools/` holds the Python scripts that check and
summarise them.

## Design process record

How Immersive Episteme was designed and built, written so a paper's methods, system-design and limitations sections
can be drafted from it. Its rules are in [research/design-process/README.md](research/design-process/README.md).

| Document | What it records |
|---|---|
| [timeline.md](research/design-process/timeline.md) | the ordered sequence of milestones and decisions |
| [decisions.md](research/design-process/decisions.md) | the decision records (DR-NNN) |
| [methods-notes.md](research/design-process/methods-notes.md) | draft methods-section material, with verified numbers only |
| [modules/study-engine.md](research/design-process/modules/study-engine.md) | the participant journey |
| [modules/learning-2d.md](research/design-process/modules/learning-2d.md) | the 2D learning pathway |
| [modules/immersive-3d.md](research/design-process/modules/immersive-3d.md) | the immersive 3D condition |
| [modules/condition-equivalence.md](research/design-process/modules/condition-equivalence.md) | equal content, exposure time and citations in both conditions |
| [modules/assessments.md](research/design-process/modules/assessments.md) | concept-map reconstruction, reference maps, scoring |
| [modules/research-console.md](research/design-process/modules/research-console.md) | the research console, the parity engine, derived metrics, exports and analysis |
| [modules/research-dashboard.md](research/design-process/modules/research-dashboard.md) | score visibility, telemetry and data quality on the dashboard |
| [modules/cms-admin.md](research/design-process/modules/cms-admin.md) | the CMS and administration |
| [modules/visual-system.md](research/design-process/modules/visual-system.md) | the visual system's implementation decisions |
| [modules/visual-alignment.md](research/design-process/modules/visual-alignment.md) | visual alignment and the shared chrome |

## Images and permissions

| Document | What it holds |
|---|---|
| [image-credits.md](image-credits.md) | every image's holder, licence and record; generated by `npm run content:image-credits`, never edited by hand |
| [research/public-repo-image-permission-note.md](research/public-repo-image-permission-note.md) | permission to include the study images in this public repository |
| [research/pari-image-permission-request.md](research/pari-image-permission-request.md), [reply](research/pari-image-permission-reply.md) | PARI |
| [research/sahapedia-image-permission-request.md](research/sahapedia-image-permission-request.md), [reply](research/sahapedia-image-permission-reply.md) | Sahapedia |
| [research/va-image-licence-request.md](research/va-image-licence-request.md), [reply](research/va-image-licence-reply.md) | the V&A |

## The README kit

[readme-kit/README_STYLE.md](readme-kit/README_STYLE.md) is the house style these pages follow: the README anatomy,
the generated SVG templates in `readme-kit/assets/` (built from `readme-kit/kit.json`, never edited by hand), the
mermaid theme and the table rules. `.github/workflows/readme-check.yml` checks every Markdown file here on each push.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="readme-kit/assets/footer-dark.svg">
  <img src="readme-kit/assets/footer-light.svg" width="100%" alt="Two ways to learn a craft, measured alike. AI CoE, IIT Kharagpur, Hand Block Printing.">
</picture>

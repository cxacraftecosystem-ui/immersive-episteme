<picture>
  <source media="(prefers-color-scheme: dark)" srcset="readme-kit/assets/divider-dark.svg">
  <img src="readme-kit/assets/divider-light.svg" width="100%" alt="">
</picture>

# <img src="readme-kit/assets/icons/terminal.svg" width="32" align="top" alt="">&nbsp; Local development

How to run Immersive Episteme on your own machine, what every npm script does, how migrations are made and where
the code lives. The short version is the Quick start in the [README](../README.md). Deployment is in
[deploy/RUNBOOK.md](deploy/RUNBOOK.md).

| Section | What it covers |
|---|---|
| [Prerequisites](#prerequisites) | Node, npm, Docker |
| [Setup](#setup) | the environment file, the databases, the first staff account |
| [Staff accounts](#staff-accounts) | `create-admin`, roles, sign-in rules |
| [Development data](#development-data) | `dev:bootstrap` and what it loads |
| [Tests](#tests) | the Vitest projects and Playwright |
| [Scripts](#scripts) | every npm script |
| [Migrations](#migrations) | how a schema change becomes a migration |
| [Layout](#layout) | where the code lives |

## Prerequisites

- Node.js 24 (`.nvmrc`; `package.json` `engines.node` is `24.x`) and npm 11.
- Docker Desktop. `docker-compose.yml` runs PostgreSQL 18 with pgvector (`pgvector/pgvector:pg18`, pinned by digest)
  on `localhost:5433`, and its init script creates `episteme` and `episteme_test`.

Versions are pinned exactly. Do not run `npm install` to change them unless that is the task (see
[ADR 0001](decisions/0001-stack-and-foundation.md)).

## Setup

```bash
npm ci
cp .env.example .env              # then set BETTER_AUTH_SECRET (the generator command is in the file)

docker compose up -d --wait       # or: npm run db:up  (creates episteme and episteme_test)
npm run db:migrate                # main database
npm run db:migrate -- --test      # test database (episteme_test), needed by npm test
npm run db:seed                   # reference data and clearly flagged demo data (idempotent)

# First staff account, a Super Admin. The password comes from ADMIN_PASSWORD (at least 12 characters).
ADMIN_PASSWORD='choose-a-long-password' npm run create-admin -- --email admin@example.org --name "Local Admin"

npm run dev                       # http://localhost:3000 (sign in at /sign-in)
```

## Staff accounts

`create-admin` (`scripts/create-admin.ts`) is idempotent: run again, it keeps the existing password and sets the
account's one role. Without a password it gives the role to an account that already exists, for example one that
signed in with Google and waits at Awaiting Access. `ADMIN_PASSWORD` is the preferred way to pass a password;
`--password` also works but stays in your shell history. Add `--test` to target `TEST_DATABASE_URL`.

| `--role` | Becomes |
|---|---|
| `super_admin` (the default) | Super Admin |
| `admin` | Admin (stored as `platform_admin`) |
| `researcher` | Researcher |
| `principal_investigator` | a Researcher marked as the study's principal investigator |
| `curator` | Curator |

The retired names `platform_admin`, `study_facilitator`, `research_analyst` and `content_editor` still work and map
onto these roles (`parseStaffRole` in `src/lib/permissions/roles.ts`). The script refuses to take Super Admin from
the last active Super Admin (DR-133, DR-134). An account whose verified email is listed in `SUPER_ADMIN_EMAILS`
(local `.env`) becomes Super Admin when it signs in, by Google or by password.

Sign-in must come from the origin in `BETTER_AUTH_URL` (default `http://localhost:3000`); Better Auth refuses other
origins with 403. Email sign-in is rate-limited to 5 attempts a minute per IP, and Google sign-in to 10 a minute
(`src/server/auth/config.ts`).

## Development data

```bash
npm run dev:bootstrap -- --verify-as <local staff email>
```

`dev:bootstrap` (`scripts/dev/bootstrap.ts`) starts the database container, migrates the main and test databases,
seeds reference and demo data, imports `content/` (as `npm run content:import` does), builds the review snapshot and
creates the draft demo study `demo-review-walkthrough`, which is non-experimental and pinned to that snapshot, so
`/explore` and staff previews of `/learn/*` show real content. The review snapshot holds content that is
`under_review` or `needs_evidence`: it is a draft of `kind = review`, never publishable and never usable by a real
study.

With `--verify-as`, it first accepts, as that existing local account, every concept and link the content files
record as `verified`, each file's tradition and every source the file lists, except sources the file itself marks
`kind: "unverified"`. The account must hold `content.verify` (a Curator, the principal investigator or the Super
Admin). Without the flag the doors show "Learning Content Is Not Available" (DR-131, DR-133). The command is
idempotent, prints the row counts, and refuses any database that is not local.

How pages read this content is in [architecture/data-and-telemetry-layer.md](architecture/data-and-telemetry-layer.md).

## Tests

```bash
npm run typecheck
npm run lint
npm test                          # Vitest, the dom and node projects (integration tests use TEST_DATABASE_URL)
npm run test:content              # Vitest, the content project: content/ against content/FORMAT.md
npm run build
npx playwright install chromium   # first time only
npm run test:e2e                  # Playwright; starts next dev on :3000 itself
npm run check                     # typecheck, lint and test
```

| Vitest project | Environment | Files |
|---|---|---|
| `dom` | jsdom | `tests/**/*.test.tsx`, `src/**/*.test.tsx` |
| `node` | node | `tests/unit/**/*.test.ts`, `tests/integration/**/*.test.ts`, `src/**/*.test.ts` |
| `content` | node | `tests/content/**/*.test.ts` |

Integration tests that need their own schema state create and drop throwaway databases on the `TEST_DATABASE_URL`
server; the others expect `episteme_test` to be fully migrated. In CI the same commands run on a PostgreSQL 18 +
pgvector service (`.github/workflows/ci.yml`).

## Scripts

| Script | What it does |
|---|---|
| `dev`, `build`, `start` | Next.js dev server, production build, production server |
| `typecheck` | `next typegen && tsc --noEmit` |
| `lint` | ESLint (flat config `eslint.config.mjs`: `eslint-config-next`, the DESIGN.md token rules, Clean Architecture import rules for `process`, `walkthrough` and `course`) |
| `test`, `test:watch` | Vitest, the `dom` and `node` projects |
| `test:content` | Vitest, the `content` project |
| `test:e2e` | Playwright (starts `next dev` on :3000) |
| `check` | typecheck, lint and test |
| `db:up`, `db:down` | `docker compose up -d --wait`, `docker compose down` |
| `db:generate` | `drizzle-kit generate` from `db/schema/*.ts` into `db/migrations` |
| `db:migrate` | the programmatic migrator (`scripts/db/migrate.ts`); `-- --test` targets `TEST_DATABASE_URL` |
| `db:seed` | reference data and demo data (`is_demo = true`, titles prefixed `Demo:`) |
| `db:seed:reference` | reference data only, as production gets it ([RUNBOOK](deploy/RUNBOOK.md) 5.2) |
| `db:reset` | drops and re-migrates a **local** database (`-- --test` for the test database). Destructive |
| `db:studio` | Drizzle Studio |
| `create-admin` | create a staff account or set its one role (`scripts/create-admin.ts`) |
| `dev:bootstrap` | database up, migrate main and test, seed, content import, review snapshot and demo study |
| `content:import` | import `content/` and build the review snapshot (`-- --test`, `-- --no-snapshot`) |
| `content:bootstrap:remote` | the public demo museum on a deployed database ([RUNBOOK](deploy/RUNBOOK.md) 5.3) |
| `content:stage-template` | write `content/study/<tradition>.template.json` from the tradition files and `content/study/merge-plan.json` |
| `content:test-items` | generate `db/seeds/study-test-items.generated.json` from the stage templates. A form holding a `Sample Text` item is written as a demo assessment (`demo-` code, `Demo:` title), which no real study can include (DR-115) |
| `content:look-rows` | write `src/features/process/domain/substance-look-rows.ts` from `docs/research/substance-looks.json` |
| `content:walkthrough-images` | the cloth states, products and course stills under `public/walkthrough/` |
| `content:image-credits` | write `docs/image-credits.md` from the media proposals in `content/review/` |
| `content:study-photos` | write the study-photo set in `scripts/content/study-photos/` from the same proposals |
| `study:seed-demo` | create an active demo study with the generated test battery (`-- --slug=demo-x --cap-minutes=30`; the slug must start with `demo-`) |
| `walkthrough:lab` | serve the Door 2 lab (`tools/walkthrough-lab/serve.cjs`) |
| `walkthrough:check`, `walkthrough:overlap` | the lab's scene check (`check.cjs`) |
| `walkthrough:route`, `walkthrough:tearing`, `walkthrough:density` | the lab's walk-route, tearing and surface-density checks |

## Migrations

`db/migrations` starts with `0000` (the pg_trgm, pgvector and pgcrypto extensions, and `uuidv7()` where the server
lacks it), `0001` (hand-written SQL helper functions), `0002` (every table, generated by drizzle-kit) and `0003`
(hand-written integrity triggers). Each later migration is either generated from a change to `db/schema/*.ts` or
hand-written for triggers and guards, and `db/migrations/meta/_journal.json` lists them in order.

After editing `db/schema/*.ts`, run `npm run db:generate` to add the next migration, and check that the triggers in
`0003` and later still match any renamed tables or columns. On a clean tree `npm run db:generate` reports
"No schema changes". The migrator checks the server and extension versions after migrating
(`assertDbVersions` in `scripts/db/_shared.ts`).

## Layout

```
src/app/(public|learning|study|cms|research|admin)/   route groups
src/app/api/{auth,telemetry,study,research}/          Better Auth handler and route handlers
src/proxy.ts                                          Next 16 proxy (formerly middleware)
src/components/                                       shared UI: shell and gates, knowledge, learning, study, assessment, analytics, cms, admin
src/features/{course,walkthrough,process}/            the two doors and the stage template, each in domain, application, infrastructure and ui
src/features/{knowledge,study,assessment,telemetry,cms,media,research,learning}/   contracts and client code per domain
src/server/                                           server-only code: auth, db, study engine, telemetry, cms, research, access, admin
src/lib/{env.ts,permissions,validation,security,a11y,...}
db/{schema,migrations,seeds}
scripts/{db,content,deploy,dev,research,walkthrough}/ migrate, seed, import, deploy kit, bootstrap
scripts/create-admin.ts, scripts/unlock-account.ts
tests/{unit,integration,e2e,content}
tools/walkthrough-lab/                                the Door 2 lab and its checks
analysis/episteme_stats/                              statistical analysis of research exports (Python)
content/                                              curated craft content (a separate effort)
docs/{architecture,decisions,deploy,research}
```

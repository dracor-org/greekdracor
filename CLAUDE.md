# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

GreekDraCor is a corpus of ancient Greek dramatic texts in TEI P5 XML format for the [DraCor](https://dracor.org) project. It contains ~40 plays by Aeschylus, Sophocles, Euripides, and Aristophanes, plus Menander's *Dyskolos*.

## Project History and "Reboot"

The corpus was originally created by transforming TEI files from the Perseus Digital Library (PDL). Over time, the files in `tei/` were edited and enriched independently — adding character identifications (`particDesc`), Wikidata links, speaker markup, and other DraCor-specific data — while Perseus continued to improve their own source files separately.

The 2026 "reboot" **reconnected** the corpus to the current Perseus source (tracked as the `perseusdl` Git submodule). All DraCor enrichment (multilingual titles, `particDesc`, Wikidata IDs, `listEvent`, `textclass`) now lives in `index.xml`, and the plays in `tei/` are regenerated from Perseus with that enrichment applied on top. This makes it repeatable: periodically update the submodule and re-run the transformation to pick up Perseus improvements.

## Transformation Pipeline

```bash
./perseus2dracor.sh
```

`perseus2dracor.sh` removes any `tei/*.xml` whose slug is no longer in `index.xml`, then runs Saxon (XSLT 2.0) on `index.xml` with `perseus2dracor.xsl`, writing generated plays directly into `tei/` and embedding the current `perseusdl` submodule SHA in each `<sourceDesc>`.

Plays not derived from Perseus (currently `tei/menander-dyskolos.xml`, sourced from Wikisource; more may be added over time) are maintained by hand. Their `<play>` entries in `index.xml` omit the `@source` attribute, so the transformation skips them and the files are not touched by re-runs.

```bash
# Load into a local DraCor instance (http://localhost:8080)
./load.sh
```

## Key Files

| File | Purpose |
|---|---|
| `index.xml` | Authoritative source of DraCor enrichment: play IDs, slugs, Perseus source paths, Wikidata IDs, and per-play `titleStmt` / `particDesc` / `listEvent` / `textclass` |
| `corpus.xml` | TEI corpus header |
| `perseus2dracor.xsl` | Main transformation: Perseus TEI → DraCor TEI, applying enrichment from `index.xml` |
| `perseus2dracor.sh` | Wrapper that runs the full transformation from `index.xml` into `tei/` |
| `tei/` | Generated (and version-controlled) DraCor TEI files |
| `load.sh` | PUTs `tei/*.xml` into a local DraCor REST API |

## Validation

Validation runs automatically on PRs and pushes to `main` (for changes to `tei/*.xml`) via GitHub Actions (`.github/workflows/validation.yml`). It uses `dracor-org/dracor-validate-action` against TEI-All and DraCor schemas.

There is no local validation command — trigger via GitHub Actions or push/PR.

## TEI Structure

DraCor TEI files follow this structure:

- `teiHeader/fileDesc`: bibliographic metadata (title, author, editor, publication info)
- `teiHeader/profileDesc/particDesc`: character list with roles, genders, Wikidata IDs
- `teiHeader/profileDesc/textClass/keywords`: relations between characters (lover_of, related_with, etc.)
- `text/body`: the play text with `<sp>` (speech), `<stage>` (stage directions), `<l>` (verse lines)

Plays use the TEI namespace `http://www.tei-c.org/ns/1.0`. Greek text uses Unicode (not betacode).

## Submodule

`perseusdl` tracks `https://github.com/PerseusDL/canonical-greekLit.git`. Update with:

```bash
git submodule update --remote perseusdl
```

After updating, re-run `./perseus2dracor.sh` to regenerate `tei/`.

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

GreekDraCor is a corpus of ancient Greek dramatic texts in TEI P5 XML format for the [DraCor](https://dracor.org) project. It contains ~40 plays by Aeschylus, Sophocles, Euripides, and Aristophanes, plus Menander's *Dyskolos*.

## Project History and "Reboot"

The corpus was originally created by transforming TEI files from the Perseus Digital Library (PDL). Since then, the files in `tei/` have been edited and enriched independently — adding character identifications (`particDesc`), Wikidata links, speaker markup, and other DraCor-specific data — while Perseus has continued to improve their own source files separately.

The current work ("reboot") is about **reconnecting** the corpus to the current Perseus source (tracked as the `perseusdl` Git submodule) so that Perseus improvements can be integrated periodically going forward. The strategy is:

- **Extract** the enrichment work from `tei/` (especially `particDesc` and header data) and consolidate it into `index.xml`
- **Retransform** the current Perseus source files using that extracted data
- **Establish** a repeatable workflow: periodically regenerate from Perseus and apply the index data on top

During this transition, `index-enriched.xml` is the working file that is continuously updated as the `tei/` files are still being refined. Once that work is complete, `index-enriched.xml` will replace `index.xml`. The `reboot/` output directory is also temporary — once the workflow is validated, generated files will go directly into `tei/`.

## Transformation Pipeline

```bash
# Enrich index with metadata extracted from current tei/ files
saxon -s:index.xml -xsl:extract-metadata.xsl -o:index-enriched.xml

# Regenerate all plays from Perseus sources (output to reboot/)
mkdir -p reboot
rm -v reboot/*.xml && saxon -s:index-enriched.xml -xsl:perseus2dracor.xsl \
  perseus-sha=$(git -C perseusdl rev-parse HEAD)

# Load into a local DraCor instance (http://localhost:8080)
./load.sh
```

The XSLT processor is Saxon (XSLT 2.0). The `perseus-sha` parameter embeds the submodule commit SHA into generated files' `<sourceDesc>`.

## Key Files

| File | Purpose |
|---|---|
| `index.xml` | Base map: Perseus file paths → DraCor slugs, Wikidata IDs |
| `index-enriched.xml` | Working file — `index.xml` plus character/title data extracted from `tei/`; will eventually replace `index.xml` |
| `corpus.xml` | TEI corpus header |
| `perseus2dracor.xsl` | Main transformation: Perseus TEI → DraCor TEI |
| `extract-metadata.xsl` | Extracts `particDesc` and metadata from existing `tei/` files into the index |
| `tei/` | Authoritative published plays (hand-edited and enriched) |
| `reboot/` | Intermediary output from the current transformation run |
| `load.sh` | PUTs `reboot/*.xml` into a local DraCor REST API |

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

After updating, re-run the enrichment and transformation steps to regenerate `reboot/`.

## Current Branch: `reboot`

The `reboot` branch is an active effort to regenerate all plays from their Perseus sources using the current XSLT pipeline. The `reboot/` directory contains freshly generated files; `tei/` contains the previously published versions. Changes reconcile these two sets.

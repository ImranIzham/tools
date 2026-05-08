# tools/

Standalone tools used in the GTM workflow. Some are upstream clones (gitignored — re-clone as needed), some are custom.

## Upstream clones (gitignored)

These are NOT tracked in this repo. Re-clone them inside `tools/` as needed:

| Folder | Origin |
|--------|--------|
| `auto-prompt-creator/` | https://github.com/MitchellkellerLG/auto-prompt-creator |
| `reddit-find/` | https://github.com/LeadGrowGTM/reddit-find |
| `research-process-builder/` | https://github.com/MitchellkellerLG/research-process-builder |
| `techsight-cli/` | https://github.com/MitchellkellerLG/techsight-cli |

Setup:
```bash
cd ~/workspace/tools
git clone https://github.com/MitchellkellerLG/auto-prompt-creator.git
git clone https://github.com/LeadGrowGTM/reddit-find.git
git clone https://github.com/MitchellkellerLG/research-process-builder.git
git clone https://github.com/MitchellkellerLG/techsight-cli.git
```

## Custom

Anything else in this folder is custom workflow tooling and IS tracked.

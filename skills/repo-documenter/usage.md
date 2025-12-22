````markdown
# Usage

## Recommended

Provide a single, recommended command that gets new users started quickly. This should be the simplest, most reliable way to run the app with sensible defaults.

Example (recommended):

```bash
# run with defaults
./run.sh
# or, if a Python module
python -m app
```

If the project requires a configuration file, include a minimal example here so users can copy and adapt it.

## Quick Start

1. Install dependencies:

```bash
pip install -r requirements.txt
```

2. Create or copy a config file if required (see `Example Configuration` below).

3. Run the recommended command from the `Recommended` section.

## Example Configuration

Provide a minimal example that's intentionally small and focused.

```yaml
# config.example.yaml
server:
  host: 0.0.0.0
  port: 8080
database:
  url: postgres://user:pass@localhost:5432/dbname
```

## Detailed Usage

- Command-line options: describe key flags and short examples
- Environment variables: list important env vars and defaults
- Configuration file: explain where it should live and how it's loaded
- Development vs Production: any differences in workflow

## Troubleshooting

- Common error messages and quick fixes
- How to collect logs and report useful information

````

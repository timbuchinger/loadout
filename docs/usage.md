````markdown
# Usage

## Recommended

The recommended, simple way to run the application is to use the provided entrypoint with default configuration. This gives new users a fast, predictable starting point.

Example (recommended):

```bash
# run with defaults
./run.sh
# or, if Python app
python -m app
```

If the project exposes many parameters, provide a single minimal command here that works for most developers.

## Quick Start

1. Install dependencies:

```bash
# example using pip
pip install -r requirements.txt
```

2. Create or copy a config file if required (see example below).

3. Run the recommended command from the `Recommended` section.

## Example Configuration

If the app requires a configuration file, include a minimal example here that is intentionally small and focused.

```yaml
# config.example.yaml
server:
  host: 0.0.0.0
  port: 8080
database:
  url: postgres://user:pass@localhost:5432/dbname
```

## Detailed Usage

- Command-line options: describe key flags and examples
- Environment variables: list important env vars and defaults
- Configuration file: explain where it should live and how it's loaded
- Development vs Production notes: any differences in standard workflow

## Troubleshooting

- Common error messages and quick fixes
- How to collect logs and report useful information

````

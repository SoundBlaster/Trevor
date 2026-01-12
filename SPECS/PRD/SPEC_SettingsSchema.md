# Spec — Settings Schema

## Storage
- Location: `~/Library/Application Support/<AppName>/settings.json`
- Versioned schema.

## Schema v1
```json
{
  "version": 1,
  "enabled": true,
  "preset": "Balanced",
  "stability_slider": 0.55,
  "precision_hold": {
    "enabled": true,
    "key": "Option",
    "multiplier": 1.6
  }
}
```

## Migration Rules
- Unknown fields are ignored.
- Missing fields use defaults.

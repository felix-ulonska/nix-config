# My NixOS Setup

## Structure

```
.
├── data # Configs and Pubkeys
│   └── pubkeys.nix # My Pubkeys
├── flake.lock # Lockfile
├── flake.nix # Flake file
├── hm-imports # Homemanager configs
├── hosts # My Hosts
├── lib # Some functions
├── modules # Modules
│   ├── applications
│   ├── home
│   └── services
├── README.md
└── secrets # My Secrets
    └── secrets.nix
└── secret-nix-config # Settings which I do not want to have public. Think E-Mail addresses. Nothing of intreset
```

### Flake

This Repo uses Flakes. Inside the `flake.nix` are the hosted definied.

### modules

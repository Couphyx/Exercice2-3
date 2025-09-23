# Création des dossiers
New-Item -ItemType Directory -Force -Path ".github/workflows" | Out-Null
New-Item -ItemType Directory -Force -Path "scripts" | Out-Null

# Fichier workflow GitHub Actions
@'
name: CI

on:
  push:
    branches: [ "dev" ]
  pull_request:
    branches: [ "dev" ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm install

      - name: Run tests
        run: npm test

      - name: Notify Discord on success
        if: success()
        run: |
          curl -H "Content-Type: application/json" `
               -d "{\"content\": \"✅ Build SUCCESS for $GITHUB_REPOSITORY ($GITHUB_REF)\"}" `
               ${{ secrets.DISCORD_WEBHOOK_URL }}

      - name: Notify Discord on failure
        if: failure()
        run: |
          curl -H "Content-Type: application/json" `
               -d "{\"content\": \"❌ Build FAILED for $GITHUB_REPOSITORY ($GITHUB_REF)\"}" `
               ${{ secrets.DISCORD_WEBHOOK_URL }}
'@ | Set-Content .github/workflows/ci.yml -Encoding UTF8

# Ajout badge fixe dans README.md
$badge = "[![CI](https://github.com/Couphyx/Exercice2-3/actions/workflows/ci.yml/badge.svg?branch=dev)](https://github.com/Couphyx/Exercice2-3/actions/workflows/ci.yml)"

if (Test-Path README.md) {
    $content = Get-Content README.md -Raw
    if ($content -notmatch "actions/workflows/ci.yml") {
        Set-Content README.md "$badge`r`n$content"
    }
} else {
    Set-Content README.md $badge
}

# Scripts de test
"exit 0" | Set-Content scripts/test-success.sh -Encoding UTF8
"exit 1" | Set-Content scripts/test-fail.sh -Encoding UTF8

Write-Host "✅ Setup terminé pour Couphyx/Exercice2-3 ! Pense à créer le secret DISCORD_WEBHOOK_URL dans ton dépôt GitHub."

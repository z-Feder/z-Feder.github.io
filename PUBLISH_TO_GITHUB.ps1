$ErrorActionPreference = "Stop"

function Write-Info { param([string]$Message) Write-Host $Message -ForegroundColor Cyan }
function Write-Ok { param([string]$Message) Write-Host ("[OK] {0}" -f $Message) -ForegroundColor Green }
function Write-Warn { param([string]$Message) Write-Host ("[WARNUNG] {0}" -f $Message) -ForegroundColor Yellow }

$repoUrl = "https://github.com/z-Feder/z-Feder.github.io.git"

Write-Info "Publishing zFeder GitHub Pages"
Write-Host "This script does not create the GitHub account."
Write-Host "Before running it, create and verify the GitHub account z-Feder, then create the repository z-Feder.github.io."
Write-Host ""

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not installed or not available in PATH."
}

git config user.name "z-Feder"
git config user.email "waerter542@gmail.com"

git add index.html styles.css README.md GITHUB_SETUP.md PUBLISH_TO_GITHUB.ps1 .nojekyll .gitignore .env.example assets/Logo_eso_addons_transparent.png assets/zfeder-icon-transparent.png assets/interface-preview.svg

$status = git status --short
if ($status) {
    git commit -m "Create zFeder ESO Addons GitHub Pages site"
    Write-Ok "Committed local site files."
} else {
    Write-Ok "No local changes to commit."
}

$remote = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0 -or -not $remote) {
    git remote add origin $repoUrl
    Write-Ok ("Added origin: {0}" -f $repoUrl)
} elseif ($remote -ne $repoUrl) {
    Write-Warn ("Origin already exists: {0}" -f $remote)
    Write-Warn ("Expected: {0}" -f $repoUrl)
}

git branch -M main
git push -u origin main

Write-Ok "Published. GitHub Pages should become available shortly at https://z-feder.github.io"


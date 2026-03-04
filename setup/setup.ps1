# setup.ps1
param (
    [switch]$InstallForce = $false
)

Write-Host "Checking for prerequisites for Kubernetes Practice Environment..."

# Function to check if a command exists
function Test-CommandExists {
    param ($command)
    return $null -NE (Get-Command $command -ErrorAction SilentlyContinue)
}

# 1. Check WSL
$wslInstalled = Test-CommandExists "wsl"
if (-not $wslInstalled) {
    Write-Host "WSL is not installed. Installing WSL..." -ForegroundColor Yellow
    wsl --install --no-distribution
} else {
    Write-Host "WSL is installed." -ForegroundColor Green
}

# 2. Check Debian in WSL
$debianInstalled = $false
if ($wslInstalled) {
    $wslList = wsl -l -q
    if ($wslList -match "Debian") {
        $debianInstalled = $true
    }
}

if (-not $debianInstalled) {
    Write-Host "Debian WSL distribution is not installed. Installing Debian..." -ForegroundColor Yellow
    wsl --install -d Debian
} else {
    Write-Host "Debian WSL distribution is installed." -ForegroundColor Green
}

# 3. Check Docker Desktop
$dockerInstalled = Test-CommandExists "docker"
if (-not $dockerInstalled) {
    Write-Host "Docker Desktop is not installed. Installing using winget..." -ForegroundColor Yellow
    winget install Docker.DockerDesktop
    Write-Host "Please restart your terminal or computer after Docker Desktop installation to ensure PATH is updated."
} else {
    Write-Host "Docker is installed." -ForegroundColor Green
}

Write-Host ""
Write-Host "Windows setup complete. Next steps:" -ForegroundColor Cyan
Write-Host "1. Open WSL Debian by running 'wsl -d Debian'"
Write-Host "2. In Debian, run './setup/setup.sh' to install Linux specific tools like kind, kubectl, and Python."
Write-Host "   (Make sure you enable Docker Desktop WSL integration for Debian in Docker Desktop Settings -> Resources -> WSL Integration)"

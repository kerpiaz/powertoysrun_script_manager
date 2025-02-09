# PowerShell script to install PowerToys Run Third-Party Plugins
# Usage: .\powertoys_extension_github.ps1
#        .\powertoys_extension_github.ps1 -list
# This script installs PowerToys Run Third-Party Plugins from the official list.
# Run without parameters to start interactive installation, or use -list to show installed plugins.

Write-Host "--------------------------------------------------------------------"
Write-Host "# PowerShell script to install PowerToys Run Third-Party Plugins"
Write-Host "# Usage: .\\powertoys_extension_github.ps1"
Write-Host "#        .\\powertoys_extension_github.ps1 -list"
Write-Host "# This script installs PowerToys Run Third-Party Plugins from the official list."
Write-Host "# Run without parameters to start interactive installation, or use -list to show installed plugins."
Write-Host "--------------------------------------------------------------------"
Write-Host ""

# Check if Git is installed and display status
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host -ForegroundColor Green "Git is installed."
} else {
    Write-Host -ForegroundColor Red "Git is NOT installed."
    Write-Error "Git is required to install plugins. Please install Git and try again."
    exit
}
Write-Host ""


# Prompt for action: list or install
Write-Host "Choose an action:"
Write-Host "1. List installed extensions (1)"
Write-Host "2. Install extensions (2 or press Enter)"
$actionChoice = Read-Host "Enter 1 to list, 2 to install (or press Enter to install)"

if ($actionChoice -eq "1") {
    Write-Host "Listing installed extensions..."

    # Set the plugin installation path
    $pluginPath = Join-Path -Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)) -ChildPath "Microsoft\\PowerToys\\PowerToys Run\\Plugins"

    # List installed extensions
    Write-Host ""
    Write-Host "-------------------- Installed Extensions --------------------"
    Get-ChildItem -Path $pluginPath -Directory | ForEach-Object {
        Write-Host $_.Name
    }
    Write-Host "------------------------------------------------------------"

    # Exit the script
    exit

} elseif ($actionChoice -eq "2" -or $actionChoice -notmatch '\d') {

    # URL to the third-party plugins markdown document on GitHub
    $PluginsDocumentUrl = "https://raw.githubusercontent.com/microsoft/PowerToys/main/doc/thirdPartyRunPlugins.md"

    # Set the plugin installation path
    $pluginPath = Join-Path -Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)) -ChildPath "Microsoft\\PowerToys\\PowerToys Run\\Plugins"


    try {
        $content = Invoke-WebRequest -Uri $PluginsDocumentUrl -UseBasicParsing -ErrorAction Stop | Select-Object -ExpandProperty Content
    }
    catch {
        Write-Error "Failed to fetch plugin list from $($PluginsDocumentUrl). Check your internet connection and URL. Error: $_"
        return
    }

    # Extract plugin details for each extension under "General plugins"
    $generalPlugins = $content -split '\r?\n' | Where-Object { $_ -match '\| \[.*\]\(.*\) \|' }
    foreach ($plugin in $generalPlugins) {
        if ($plugin -match '\| \[(.*?)\]\((.*?)\) \| (.*?) \| (.*?) \|') {
            $pluginName = $Matches[1]
            $gitHubUrl = $Matches[2]
            $author = $Matches[3]
            $description = $Matches[4]

            Write-Host ""
            Write-Host "--------------------------------------------------------------------"
            Write-Host "Plugin Name: $($pluginName)" -ForegroundColor Cyan
            Write-Host "GitHub URL: $($gitHubUrl)"
            Write-Host "Description: $($description)"
            Write-Host "--------------------------------------------------------------------"
            Write-Host ""

            # Prompt for details or skip
            $detailsPrompt = Read-Host "Do you want to see more details of extension $($pluginName) before installing or skip it? (y/n)"

            if ($detailsPrompt -ceq "y") {
                # Read the README file
                $cloneDir = Join-Path -Path $pluginPath -ChildPath "$($pluginName)-plugin-temp" #temp clone dir to read readme
                try {
                    Write-Host "Cloning temporary directory to read README..."
                    git clone --depth 1 $gitHubUrl $cloneDir 2>$null #clone just to read readme
                    $readmePath = Join-Path -Path $cloneDir -ChildPath "README.md"


                    if (Test-Path -Path $readmePath) {
                        Write-Host "-------------------- README.md --------------------"
                        $readmeContent = Get-Content -Path $readmePath
                        $readmeContent -split "`n" | ForEach-Object { Write-Host $_ }
                        Write-Host "--------------------------------------------------"
                    } else {
                        Write-Warning "README.md not found."
                    }
                }
                catch {
                    Write-Warning "Failed to clone temp dir to read README. Error: $_"
                } finally {
                    if (Test-Path $cloneDir) { Remove-Item -Path $cloneDir -Recurse -Force } #cleanup temp dir
                }


                # Ask for confirmation after showing details
                $confirmationPrompt = Read-Host "Are you sure you want to install $($pluginName)? (y/n)"
                if ($confirmationPrompt -ceq "y") {
                    Write-Host -ForegroundColor Green "Installing $($pluginName)..."

                    # Use git clone to download the repository
                    $cloneUrl = "$($gitHubUrl).git"
                    $pluginInstallPath = "$($pluginPath)\$($pluginName)-plugin"
                    try {
                        git clone $cloneUrl $pluginInstallPath 2>$null
                        Write-Host -ForegroundColor Green "$($pluginName) installed successfully!"
                    }
                    catch {
                        Write-Error "Failed to clone $($pluginName)."
                    }
                } else {
                    Write-Host -ForegroundColor Red "Skipping installation of $($pluginName)."
                }


            } else {
                Write-Host -ForegroundColor Red "Skipping installation of $($pluginName)."
            }
        }

        # List installed extensions
        Write-Host ""
        Write-Host "######################## Installed Extensions ########################"
        Get-ChildItem -Path $pluginPath -Directory | ForEach-Object {
            Write-Host $_.Name
        }
        Write-Host "#############################################################"
    }
}
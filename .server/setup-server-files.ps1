if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
    Exit
}

# Push location to the current script directory
Push-Location $PSScriptRoot

# Source directory and target link directory for each folder
$folders = @{
    "config" = @{
        "source" = "..\config"
        "ignoreNames" = @() # Add file or folder names to ignore
    }
    "defaultconfigs" = @{
        "source" = "..\defaultconfigs"
        "ignoreNames" = @()
    }
    "libraries" = @{
        "source" = "..\..\libraries"
        "target" = "libraries"
        "ignoreNames" = @()
        "link" = $true
    }
    "mods" = @{
        "source" = "..\mods"
        "ignoreNames" = @(
            "BetterAdvancements-1.19.2-0.3.0.148.jar",
            "BetterModsButton-v4.2.4-1.19.2-Forge.jar",
            "BHMenu-Forge-1.19.2-2.4.1.jar",
            "bocchium-1.19.2-0.0.2.jar",
            "ConfiguredDefaults-v8.0.1-1.20.1-Forge.jar",
            "connectedness-2.0.1a.jar",
            "Controlling-forge-1.19.2-10.0+7.jar",
            "CTM-1.19.2-1.1.6+8.jar",
            "CullLessLeaves-Reforged-1.0.5.jar",
            "drippyloadingscreen_forge_2.2.2_MC_1.19.1-1.19.2.jar",
            "embeddium-0.2.18+mc1.19.2.jar",
            "EnchantmentDescriptions-Forge-1.19.2-13.0.14.jar",
            "Entity_Collision_FPS_Fix-forge-1.19-2.0.0.0.jar",
            "entity_model_features_forge_1.19.2-0.2.13.jar",
            "entity_texture_features_forge_1.19.2-5.2.1.jar",
            "entityculling-forge-1.6.1-mc1.19.2.jar",
            "EuphoriaPatcher-0.3.0-forge.jar",
            "Fallingleaves-1.19.1-1.3.1.jar",
            "fancymenu_forge_2.14.13_MC_1.19-1.19.2.jar",
            "gpumemleakfix-1.19.2-1.6.jar",
            "ImmediatelyFast-Forge-1.2.8+1.19.2.jar",
            "JustEnoughProfessions-forge-1.19.2-2.0.2.jar",
            "lazydfu-1.19-1.0.2.jar",
            "LegendaryTooltips-1.19.2-forge-1.4.0.jar",
            "lightspeed-1.19.2-1.0.5.jar",
            "loot_journal-2.1.jar",
            "Luna-FORGE-MC1.19.X-1.0.1.jar",
            "MouseTweaks-forge-mc1.19-2.23.jar",
            "Neat-1.19-32.jar",
            "NekosEnchantedBooks-1.19-1.8.0.jar",
            "notenoughanimations-forge-1.7.0-mc1.19.2.jar",
            "oculus-flywheel-compat-1.19.2-0.2.1.jar",
            "oculus-mc1.19.2-1.6.9.jar",
            "OverflowingBars-v4.0.1-1.19.2-Forge.jar",
            "PresenceFootsteps-1.19.2-1.6.4.1-forge.jar",
            "reforgium-1.0.12a.jar",
            "rubidium-extra-0.4.19+mc1.19.2-build.105.jar",
            "Ryoamiclights-0.1.5+1.19.2.jar",
            "servercountryflags-1.9.3-1.19.2-FORGE.jar",
            "SimpleDiscordRichPresence-forge-3.0.6-build.39+mc1.19.2.jar",
            "textrues_embeddium_options-0.1.1+mc1.19.2.jar",
            "TravelersTitles-1.19.2-Forge-3.1.2.jar",
            "yeetusexperimentus-1.0.1-build.2+mc1.19.1.jar"
        )
    }
    "modernfix" = @{
        "source" = "..\modernfix"
        "ignoreNames" = @()
    }
    "schematics" = @{
        "source" = "..\schematics"
        "ignoreNames" = @()
    }
}

# Function to copy files from source to target directory
function Copy-Files {
    param(
        [string]$sourceDirectory,
        [string]$targetDirectory,
        [string[]]$ignoreNames
    )

    # Get files and folders in the source directory
    $items = Get-ChildItem -Path $sourceDirectory

    # Loop through each item and copy it to the target directory
    foreach ($item in $items) {
        # Check if item is not in the ignore list
        if ($ignoreNames -notcontains $item.Name) {
            # Check if item is a directory or file
            if ($item.PSIsContainer) {
                # Copy directory to target directory
                Write-Host "Copying directory: Copy-Item -Path `"$($item.FullName)`" -Destination `"$targetDirectory\$($item.Name)`" -Recurse -Force"
                Copy-Item -Path $item.FullName -Destination "$targetDirectory\$($item.Name)" -Recurse -Force
            } else {
                # Copy file to target directory
                Write-Host "Copying file: Copy-Item -Path `"$($item.FullName)`" -Destination `"$targetDirectory`" -Force"
                Copy-Item -Path $item.FullName -Destination $targetDirectory -Force
            }
        }
    }
}

# Loop through each folder and create symbolic links or copy files
foreach ($folderName in $folders.Keys) {
    $folder = $folders[$folderName]
    $sourceDirectory = $folder["source"]
    $targetDirectory = $folderName
    $ignoreNames = $folder["ignoreNames"]

    # Remove previous symbolic link and folder if they exist
    if (Test-Path -Path $targetDirectory) {
        Write-Host "Removing previous symbolic link and folder: rmdir `"$targetDirectory`" /s /q"
        git rm --cached -r "$targetDirectory"
        # Check if item is a directory or file
        if (Test-Path -Path $targetDirectory -PathType Container) {
            cmd /c rmdir "$targetDirectory" /s /q
        } else {
            cmd /c del "$targetDirectory" /q
        }
    }

    # Check if symbolic link should be created
    if ($folder["link"]) {
        # Create symbolic link for directory
        Write-Host "Creating symbolic link for folder: mklink /D `"$targetDirectory`" `"$sourceDirectory`""
        cmd /c mklink /D "$targetDirectory" "$sourceDirectory"
        git reset HEAD -- "$targetDirectory"
    } else {
        # Create new target directory
        Write-Host "Creating target directory: New-Item -Path `"$targetDirectory`" -ItemType Directory"
        New-Item -Path $targetDirectory -ItemType Directory | Out-Null
        # Copy files from source to target directory
        Write-Host "Copying files to target directory..."
        Copy-Files -sourceDirectory $sourceDirectory -targetDirectory $targetDirectory -ignoreNames $ignoreNames
    }
}

# Pop back to the previous location
Pop-Location

pause

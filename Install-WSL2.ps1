
function Get-CurrentSecurityPrincipal {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (Get-CurrentSecurityPrincipal)
{
    # Step 1 - Enable the Windows Subsystem for Linux (https://docs.microsoft.com/en-us/windows/wsl/install-win10)
    Write-Host "Step 1 - Enable the Windows Subsystem for Linux"
    try { dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart }
    catch { "Failed to enable Windows Subsystem for linux. Please check documentation here: https://docs.microsoft.com/en-us/windows/wsl/install-win10" }
    
    # Step 3 - Enable Virtual Machine feature (https://docs.microsoft.com/en-us/windows/wsl/install-win10)
    Write-Host "Step 3 - Enable Virtual Machine feature"
    try { dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart }
    catch { "Failed to Enable Virtual Machine feature!" }

    # Step 4 - Download the Linux kernel update package
    mkdir ./tmp
    $WSL_UPDATE_URL="https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
    Write-Host "Step 4 - Download the Linux kernel update package"
    try { Invoke-WebRequest -Uri $WSL_UPDATE_URL -OutFile ./tmp/wsl_update_x64.msi -UseBasicParsing }
    catch { "Failed to Download WSL Update Package from $WSL_UPDATE_URL" }

    # Step 5 - Install Linux kernal update package
    Write-Host "Step 5 - Install Linux kernal update package"
    try 
    {
        cd tmp/
        msiexec /a wsl_update_x64.msi
    }
    catch { "Failed to install the WSL Kernel package. Please check installation window for error!" }
    

    wsl --set-default-version 2
    Write-Host "WSL Package installed! Please reboot your system, then issue the following command!"
    Write-Host ""
    Write-Host "wsl --set-default-version 2"
    rm ./tmp
}
else
{
    Write-Error "Current Powershell session doesn't have elevated privileges. Please run Powershell as Administrator!"
}

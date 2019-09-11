################################################################################
##  File:  Install-OpenPolicyAgent.ps1
##  Desc:  Install OpenPolicyAgent
################################################################################

$latestOpaUri = "https://github.com/open-policy-agent/opa/releases/latest"
$stableOpaTag = "v0.13.5"
$tagToUse = $stableOpaTag;
$destFilePath = "C:\ProgramData\opa"
$outFilePath = "C:\ProgramData\opa\opa.exe"

try
{
    $request = Invoke-WebRequest -Method Head -Uri $latestOpaUri
    if ($request.BaseResponse.ResponseUri -ne $null) {
        # This is for Powershell 5
        $redirectUri = $request.BaseResponse.ResponseUri.AbsoluteUri
        $tagToUse = $redirectUri.Split('/')[7];
    }
    elseif ($request.BaseResponse.RequestMessage.RequestUri -ne $null) {
        # This is for Powershell core
        $redirectUri = $request.BaseResponse.RequestMessage.RequestUri.AbsoluteUri
        $tagToUse = $redirectUri.Split('/')[7];
    }

    Write-Host "Downloading open policy agent version $tagToUse"
}
catch {
    Write-Host "Downloading stable open policy agent version $tagToUse"
    $tagToUse = $stableOpaTag;
    #do nothing, use stable version
}

try
{
    $getOpaUri =  "https://github.com/open-policy-agent/opa/releases/download/$tagToUse/opa_windows_amd64.exe"
    Write-Host "Downloading opa.exe..."
    New-Item -Path $destFilePath -ItemType Directory -Force

    Invoke-WebRequest -Uri $getOpaUri -OutFile $outFilePath

    Write-Host "Starting Install opa.exe..."
    $process = Start-Process -FilePath $outFilePath -Wait -PassThru
    $exitCode = $process.ExitCode

    if ($exitCode -eq 0 -or $exitCode -eq 3010)
    {
        Write-Host -Object 'Installation successful'
        Add-MachinePathItem $destFilePath
        exit $exitCode
    }
    else
    {
        Write-Host -Object "Non zero exit code returned by the installation process : $exitCode."
        exit $exitCode
    }
}
catch
{
    Write-Host -Object "Failed to install the Executable opa.exe"
    Write-Host -Object $_.Exception.Message
    exit -1
}

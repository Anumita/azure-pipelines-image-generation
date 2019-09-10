################################################################################
##  File:  Validate-OpenPolicyAgent.ps1
##  Team:  CI-Platform
##  Desc:  Validate OpenPolicyAgent.
################################################################################


if((Get-Command -Name 'opa'))
{
    Write-Host "opa $(opa version) in path"
}
else
{
    Write-Host "opa is not in path"
    exit 1
}

# Adding description of the software to Markdown
$SoftwareName = "OpenPolicyAgent"

$version = $(opa version)

$Description = @"
_Version:_ $version<br/>
_Environment:_
* PATH: contains location of opa.exe
"@

Add-SoftwareDetailsToMarkdown -SoftwareName $SoftwareName -DescriptionMarkdown $Description

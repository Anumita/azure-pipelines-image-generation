################################################################################
##  File:  Validate-Terraform.ps1
##  Team:  CI-Platform
##  Desc:  Validate Terraform.
################################################################################


if((Get-Command -Name 'terraform'))
{
    Write-Host "terraform $(terraform version) in path"
}
else
{
    Write-Host "terraform is not in path"
    exit 1
}

# Adding description of the software to Markdown
$SoftwareName = "Terraform"

$version = $(terraform version)

$Description = @"
_Version:_ $version<br/>
_Environment:_
* PATH: contains location of terraform.exe
"@

Add-SoftwareDetailsToMarkdown -SoftwareName $SoftwareName -DescriptionMarkdown $Description

function Get-SecSoftwareInstalled {
	<#
		.SYNOPSIS
			Enumerates the installed software on a machine.
	
		.DESCRIPTION
			Enumerates the installed software on a machine.
	
		.PARAMETER  Baseline
			Triggers the creation of a baseline.
	
		.PARAMETER  BaselinePath
			Designates a location for the baseline to be saved.
	
		.EXAMPLE
			PS C:\> Get-SecSoftwareInstalled
	
		.EXAMPLE
			PS C:\> Get-SecSoftwareInstalled -Baseline -BaselinePath "C:\temp"
	
		.INPUTS
			System.String,System.Boolean
	
		.OUTPUTS
			PSObject
	
		.NOTES
			CSIS 20 Critical Security Controls for Effective Cyber Defense excerpt:
			Devise a list of authorized software that is required in the enterprise for each type of system, including servers, workstations, and laptops of various kinds and uses. This list should be tied to file integrity checking software to validate that the software 
		
			AUTHOR: Nick Jacob, Matt Johnson
			This is a part of the PoshSec Software-Management module.
	
		.LINK
			www.poshsec.com
	
		.LINK
			github.com/poshsec
	
	#>
	[CmdletBinding()]
	param(
        ## Baseline Parmerter Set
        [Parameter(ParameterSetName='Baseline')]
		[switch]$Baseline,
		[Parameter(ParameterSetName='Baseline')]
		[string]$BaselinePath
	)
    
    begin{
        ## Script Variables
        $local:BaselinePrefix = "$env:computername-Installed-Software"
        $local:BaselineFileErrorMessage = "The path specified does not exist. The baseline was not saved."
    }
    process{
        $local:object = Get-ItemProperty  HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |Select @{name="ComputerName";expression={"$env:computername"}}, DisplayName, DisplayVersion, Publisher, InstallDate, HelpLink, UninstallString

    }
    end{
        if($Baseline) {
            $local:Filename = Get-DateISO8601 -Prefix $local:BaselinePrefix -Suffix ".xml"
             
    	    if ($BaselinePath) {
                if (Test-Path -Path $BaselinePath) {
                    $local:FilePath = Join-Path -Path $BaselinePath -ChildPath $local:Filename 
                } else {
                    Write-Warning -Message $local:BaselineFileErrorMessage
                    break
                }
    	    } elseif ($global:PoshSecBaselinePath) {
                if (Test-Path -Path $global:PoshSecBaselinePath) {
                    $local:FilePath = Join-Path -Path $global:PoshSecBaselinePath -ChildPath $local:Filename 
                } else {
                    Write-Warning -Message $local:BaselineFileErrorMessage
                    break
                }
    	    } else {
                if ([System.Environment]::OSVersion.Version.Major -le 5){
					$local:FilePath = Join-Path -Path "$env:USERPROFILE\My Documents" -ChildPath $local:Filename
				} else {
					$local:FilePath = Join-Path -Path $env:USERPROFILE\Documents -ChildPath $local:Filename
				} 
            } 

           $local:object | Export-Clixml $local:FilePath
            
        } else {
            Write-Output $local:object
        }
    }
}
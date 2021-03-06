function Get-SecDriver {
	<#
		.SYNOPSIS
			Gets list of currently used drivers.
	
		.DESCRIPTION
			Gets list of currently used drivers utilizing Windows 8 and above functionality.
	
		.PARAMETER  Baseline
			Triggers the creation of a baseline.
	
		.PARAMETER  BaselinePath
			Designates a location for the baseline to be saved.
	
		.EXAMPLE
			PS C:\> Get-SecDriver
	
		.EXAMPLE
			PS C:\> Get-SecDriver -Baseline -BaselinePath "C:\Baselines"
	
		.INPUTS
			System.String,System.Boolean
	
		.OUTPUTS
			PSObject
	
		.NOTES
			AUTHOR: Nick Jacob, Matt Johnson
			This is a function in the PoshSec Software-Management module.
	
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
        $local:BaselinePrefix = "$computer-Drivers"
        $local:BaselineFileErrorMessage = "The path specified does not exist. The baseline was not saved."

		if(([System.Environment]::OSVersion.Version.Major -le 6) -and ([System.Environment]::OSVersion.Version.Minor -lt 2) ) {
			Write-Error -Message "This feature requires Windows 8 or higher."
			break
		}
    }
    process{
        $local:object = Get-WindowsDriver -Online -All

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


function Get-RemoteProcess {
	<#    
		.SYNOPSIS
  			Gets the process WMI object for a remote system.
		.DESCRIPTION
			This function will return a WMI object of the Win32_Process for a remote system.
		.PARAMETER computer
  			The remote system on which to run the command.
		.EXAMPLE
  			PS> $process = Get-RemoteProcess -computer REMOTEPC
		.EXAMPLE
  			PS> $process = Get-RemoteProcess REMOTEPC
		.LINK
   			www.poshsec.com
		.NOTES
			AUTHOR: Ben0xA
  			This function is a utility function for the PoshSec module.
	#>
  	Param(
  		[Parameter(Mandatory=$true,Position=1)]
    	[string]$computer
  	)
	
  	$processes = Get-WmiObject -Class Win32_Process -List -Namespace root\cimv2 -ComputerName $computer -ErrorAction SilentlyContinue
  	return $processes
}
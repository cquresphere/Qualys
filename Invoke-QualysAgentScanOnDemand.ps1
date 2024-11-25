# https://cdn2.qualys.com/docs/qualys-cloud-agent-windows-install-guide.pdf
function Invoke-QualysAgentScanOnDemand {
    [CmdletBinding()]
    #[OutputType([bool])]
    Param
    (
        [Parameter(Mandatory = $false)]
        [ValidateSet("Inventory", "PolicyCompliance", "SCA", "SWCA", "UDC", "Vulnerability")]
        [String] $Scan="Vulnerability"
    )
    Begin{
        Write-Host $Scan
        try{
            $Value = Get-ItemProperty -Path "registry::HKEY_LOCAL_MACHINE\SOFTWARE\Qualys\QualysAgent\ScanOnDemand\$Scan" -Name ScanOnDemand
            $Value
        }
        catch{
            Write-Host "The Qualys agent could not be detected on this host!" -ForegroundColor Red
        }
    }

    Process {
        if($Value -eq 2) {
            Write-Host "The $Scan scan is in progress already!" -ForegroundColor Yellow
        }
        Elseif($Value -eq 1){
            Write-Host "The $Scan scan has been queued already!" -ForegroundColor Green 
        }
        Else{
            try{
                Set-ItemProperty -Path "registry::HKEY_LOCAL_MACHINE\SOFTWARE\Qualys\QualysAgent\ScanOnDemand\$Scan" -Name ScanOnDemand -Value 1
                Write-Host "The $Scan scan has been queued now!" -ForegroundColor Green 
            }
            catch{
                Write-Host "The $Scan scan could not be queued!" -ForegroundColor Red
            }
        }
    }
}

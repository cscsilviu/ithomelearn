
function PNP-Connection{
    param (
        $SiteURL
    )

    Connect-PnPOnline $SiteURL -Credentials $credentials

}

$ListName = "AccessRequestFinal"

$credentials = Get-PnPStoredCredential -Name AccessRequest -Type PSCredential

$AccessRequestUrl = "https://ithomelearn.sharepoint.com/sites/AccessRequest"

#Connect-PnPOnline https://ithomelearn.sharepoint.com/sites/AccessRequest -Credentials $credentials

PNP-Connection -SiteUrl $AccessRequestUrl

$valori = Get-PnPListItem -List $ListName

$valori_clare = $valori.fieldvalues

write-host $valori_clare.count


   
    foreach($valoare in $valori_clare | ? {$_.AccessStatus -eq "Granted"}){

        if($valoare.SiteCollectionURL -like "*space*") {
                 
                Write-Host $valoare.ValidUntil

                $actualDate = Get-Date -Format "MM/dd/yyyy HH:mm:ss"

                write-host $actualDate

                if($actualDate -lt $valoare.ValidUntil ) {
                    write-host "True"    
                } else {
                    
                    $siteURL 

                    $siteURL = Get-SPSite $valoare.SiteCollectionURL

                    $siteURL = $SiteURL.Url

                    $userBrenda = "homelearn\brenda.mutascu"

                    $web = Get-SPWeb $siteURL
 
                    $user = $web.EnsureUser($userBrenda)
  
                    $user.IsSiteAdmin = $false
 
                    $user.Update()

                }
                          

      

        } 

    }
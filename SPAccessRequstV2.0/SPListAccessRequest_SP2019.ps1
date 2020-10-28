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


    if(($valori_clare | ? {$_.AccessStatus -eq "Pending"}).count -eq 0){
        write-host "There are no new access requests"
    } else {

    foreach($valoare in $valori_clare | ? {$_.AccessStatus -eq "Pending"}){

        if($valoare.SiteCollectionURL -like "*space*") {
           
            Connect-PnPOnline $valoare.SiteCollectionURL -Credentials $credentials
            if($valoare.ValidUntil -eq ""){
                Start-Sleep -Seconds 10
            } else {
            
                                
                
                $siteURL 

                $siteURL = Get-SPSite $valoare.SiteCollectionURL

                $siteURL = $SiteURL.Url

                $userBrenda = "homelearn\brenda.mutascu"

                $web = Get-SPWeb $siteURL
 
                $user = $web.EnsureUser($userBrenda)
  
                $user.IsSiteAdmin = $true
 
                $user.Update()

                               
                Connect-PnPOnline https://ithomelearn.sharepoint.com/sites/AccessRequest -Credentials $credentials
    
                Set-PnPListItem -List $ListName -Identity $valoare.ID -Values @{"AccessStatus" = "Granted"}
            
                write-host "Access granted for $valoare.SiteCollectionURL "
                     
               
                }

            } 

        }
    }



    

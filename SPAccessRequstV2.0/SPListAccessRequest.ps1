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

        if($valoare.SiteCollectionURL -like "*ithomelearn*") {
           
            Connect-PnPOnline $valoare.SiteCollectionURL -Credentials $credentials
            if($valoare.ValidUntil -eq ""){
                Start-Sleep -Seconds 10
            } else {
                Add-PnPSiteCollectionAdmin -Owners $valoare.Author.Email
                
                Write-Host $valoare.ValidUntil

                Disconnect-PnPOnline

                Connect-PnPOnline https://ithomelearn.sharepoint.com/sites/AccessRequest -Credentials $credentials
        
                Set-PnPListItem -List $ListName -Identity $valoare.ID -Values @{"AccessStatus" = "Granted"}
                
                $siteCollection = $valoare.SiteCollectionURL

                $Author = $valoare.Author.Email

                write-host "Access granted for $Author on site collection: $siteCollection"
            }            
               
        } else {
            Set-PnPListItem -List $ListName -Identity $valoare.ID -Values @{"RequestScope" = "SPACE"}
        }

    } 

    }



    

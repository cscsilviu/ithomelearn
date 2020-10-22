function PNP-Connection{
    param (
        $SiteURL
    )

    Connect-PnPOnline $SiteURL -Credentials $credentials

}

$credentials = Get-PnPStoredCredential -Name AccessRequest -Type PSCredential

$AccessRequestUrl = "https://ithomelearn.sharepoint.com/sites/AccessRequest"

#Connect-PnPOnline https://ithomelearn.sharepoint.com/sites/AccessRequest -Credentials $credentials

PNP-Connection -SiteUrl $AccessRequestUrl

$valori = Get-PnPListItem -List "AccessRequest"

$valori_clare = $valori.fieldvalues

write-host $valori_clare.count


    if(($valori_clare | ? {$_.AccessStatus -eq "Pending"}).count -eq 0){
        write-host "There are no new access requests"
    } else {

        foreach($valoare in $valori_clare | ? {$_.AccessStatus -eq "Pending"}){
    
            Connect-PnPOnline $valoare.SiteCollectionURL -Credentials $credentials
        
            Add-PnPSiteCollectionAdmin -Owners $valoare.Author.Email
        
            Connect-PnPOnline https://ithomelearn.sharepoint.com/sites/AccessRequest -Credentials $credentials

            Set-PnPListItem -List "AccessRequest" -Identity $valoare.ID -Values @{"AccessStatus" = "Granted"}
        
            write-host "Access granted for $valoare.SiteCollectionURL"

            Disconnect-PnPOnline

            write-host "test"
        
        }

    }



    

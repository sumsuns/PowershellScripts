# Load VM data from CSV file
$vmData = Import-Csv -Path "C:\Users\user1\vul-report.csv"

$subscriptions = @("sub1", "sub3", "sub2")
#$vmData = $vmData | Select-Object *,@{Name="VMStatus";
# Iterate through VM data
foreach ($vm in $vmData) {
    $vmNametomodify = $vm."asset.name"
    # Use -replace to modify the string
 
    $originalString = $vmName
    $parts = $originalString -split "-"
    $vmResourcegrp = $vmName-rg
   
    foreach ($subscriptionId in $subscriptions) {
        if (Get-AzContext -ListAvailable | Where-Object { $_.Subscription.Id -eq $subscriptionId }) {
            Set-AzContext -SubscriptionId $subscriptionId
            $vm = Get-AzVM -ResourceGroupName $vmResourcegrp -Name $vmName -ErrorAction SilentlyContinue
            if ($vm) {
                Write-Host "VM '$VMName' exists in subscription '$subscriptionId'."
                $vm | Add-Member -MemberType NoteProperty -Name "VMStatus" -Value "Running" -Force
                break  
             
            }
          
        }
    }  

     Write-Host "VM '$VMName' does not exist in any of the specified subscriptions."
     $vm | Add-Member -MemberType NoteProperty -Name "VMStatus" -Value "Deleted" -Force
}
$vmData = $vm | Select-Object * -ExcludeProperty PSObject
$vmData | Export-Csv "C:\Users\user1\output_statusupdate.csv" -NoTypeInformation

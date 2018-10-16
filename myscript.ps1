$original_path =  "C:\result.log"
$newpath = "C:\result.log.back"
$testing =  Test-Path  $original_path
$pathSearch = "C:\users\Public";
$ScriptPath = "C:\myscript.ps1"
$testingScript = Test-Path $ScriptPath
$max_size = 512000 #(1 ko = 1024 bits => 5Mo = (5120)ko * 10e3 = 512000ko)
$sourcename_eventlog = "MyGreatPsScript"
$sourcename_eventlogDate = "MyDateCompareLog"


$dateOfLastAccess = Get-ChildItem $original_path | Select LastAccessTime
$dateOfLastAccess | Out-File $original_path 


$dateOfLastAccess






if($testing = 1){

Copy-Item $original_path $newpath


}else{

fsutil file createnew $original_path 1024


}

function Get-FriendlySize {
    param($Bytes)
    $sizes='Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
    for($i=0; ($Bytes -ge 1kb) -and 
        ($i -lt $sizes.Count); $i++) {$Bytes/=1kb}
    $N=2; if($i -eq 0) {$N=0}
    "{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
}


$theDate =  (Get-Date).ToString("yyyy-MM-dd"+ " a hh-mm-ss") | Out-File  $original_path -Append





$numberOfFiles =  ( Get-ChildItem C:\users\Public -Recurse |  ? {$_.length -gt $max_size} | Measure-Object).Count;

$damn_var =  Get-ChildItem $pathSearch -Recurse | ? {$_.length -gt $max_size} | select  Name , @{N='size';E={Get-FriendlySize -Bytes $_.Length}} , FullName






foreach($damn_item in $damn_var){
    
     
        $message01 = "the number of file foud that have more than 5 Mo are $numberOfFiles"
        $message ="the name of found file is :"     

        #writing messages into log file located in c:\result.log 
   
        $message |Out-File $original_path -Append
        $message01 | Out-file $original_path -Append
        $damn_item| Out-File $original_path -Append
        

    


}



function createlog($sourcename_eventlog){

 New-EventLog -LogName  Application -Source $sourcename_eventlog
    

}


try{
    

        createlog

}catch{

#do nothing 
# it's just avoid the critic message of an already exesting record in the name of source event you want to add 


}






function DateLogcreatelog($sourcename_eventlogDate){

 New-EventLog -LogName  Application -Source $sourcename_eventlogDate
    

}


try{
    

        DateLogcreatelog

}catch{

#do nothing 
# it's just avoid the critic message of an already exesting record in the name of source event you want to add 


}



$parameters = @{

  'LogName'  = 'Application'

  'Source'  = $sourcename_eventlog

  }




if ($testingScript = 1) {

  $parameters  += @{

  'EventId'  = 1111

  'EntryType'  = 'Information'

  'Message'  = "the script $sourcename_eventlog has been executed on $dateOfLog  and the number of found files that have more than 5 MO are $numberOfFiles" 


  
  }

  Write-EventLog  @parameters

  } else { $parameters  += @{

  'EventId'  = 1112

  'EntryType'  = 'Error'

  'Message'  = 'The file does not exist'
  

  }

  Write-EventLog @parameters

  }



  #store in registry key the time of the last access

  
$dayofaccess = get-date -Format yyyy-MM-dd
$dayinRegistry = get-date -Format yyyy-MM-dd
$dayy_diff= New-TimeSpan -Start $dayofaccess -End $dayinRegistry


  function createRegistryItem(){

   
   set-ItemProperty -Path "HKLM:\Software\$sourcename_eventlog" -Name "newImportantRecord" -Value $dayinRegistry
  
  }
  
  createRegistryItem





if($day_diff -eq 5){
    
    

    Write-Warning "the file has been not been executed for 5 days"| Out-File $original_path[0] 

   


    $parameters2 = @{

  'LogName'  = 'Application'

  'Source'  = $sourcename_eventlogDate

  }




if ($testingScript = 1) {

  $parameters2  += @{

  'EventId'  = 666

  'EntryType'  = 'Warning'

  'Message'  = "this script was executed   " 


  
  }

  Write-EventLog  @parameters2

  } else { $parameters2  += @{

  'EventId'  = 1089

  'EntryType'  = 'Error'

  'Message'  = 'error when trying to write to event log'
  

  }

  Write-EventLog @parameters2

  }


}







  
 







*
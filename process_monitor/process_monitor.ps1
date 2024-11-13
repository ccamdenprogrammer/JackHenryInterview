#This is the filepath to the txt file where the script logs every new process. 
#I concsidered making it dynamic, but I think having everything always packaged into one folder is so much more organized.
$outputFile = "/Users/camdencrace/Desktop/interview scripts/process_monitor/processes.txt"

#This is a hash table to store all of the known PIDs so that the script doesn't repeatedly add processes.
#I had some trouble with this and initially got the idea to use a hash table from chatGPT (thanks-)
#The implementation was further aided by this documentation: "https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-hashtable?view=powershell-7.4"
$knownIDs = @{}

#This is the meat and potatoes of the script and what actually gets each new process, checks if it exists and if it doesn't, adds it to the file.
function newProcesses{
    Get-Process | ForEach-Object{   #Get-process gets every current process and ForEach-Object iterates through each.
        if(!$knownIDs.ContainsKey($_.Id)){      #If it doesn't have a known PID...
            $processInfo = "Name: $($_.ProcessName), PID: $($_.Id), Start Time: $($_.StartTime)"       #The process data is organized in this format
            $processInfo | Out-File -FilePath $outputFile -Append       #Data is output to txt file for logging.
            $knownIDs[$_.Id] = $true        #PID is set to true, making it a known PID in the table.


            Write-Host "New Process Detected: " $processInfo
        }
    }
}

#All this does is make the above function run until the user decides to turn it off.
while($true){
    newProcesses
}
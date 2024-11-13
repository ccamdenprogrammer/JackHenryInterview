#Import the sqlserver module to connect and work with the database
Import-Module SqlServer

#global variable instantiation.
#$serverName = "localhost"
#$databaseName = "SampleDB"
$containerBackupDirectory = "/var/opt/mssql/backups"
$timeStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$fileName = "${databaseName}_${timeStamp}.bak"
$containerBackupFilePath = "$containerBackupDirectory/$fileName"
$localBackupDirectory = "/Users/camdencrace/Desktop/backups"
$localBackupFilePath = "$localBackupDirectory/$fileName"


#User credential input
$serverName = Read-Host "Enter server name"
$databaseName = Read-Host "Enter database name"
$userName = Read-Host "Enter username"
$passWord = Read-Host -MaskInput "Enter Password"  #---> thank you....https://stackoverflow.com/questions/40503240/is-it-possible-to-hide-the-user-input-from-read-host-in-powershell

#Because integrated security isn't an option here, we are assuming that we trust the SSL certificate by
#default given "TrustServerCertificate=True"
try {
    #This is the connection string to connect to the database.
    $connectionString = "Server=$serverName;Database=$databaseName;User Id=$userName;Password=$passWord;TrustServerCertificate=True;"
    $query = "SELECT 1"
    Invoke-Sqlcmd -ConnectionString $connectionString -Query $query -ErrorAction Stop
    Write-Host "CONNECTION TO DATABASE SUCCSSFUL"  
}
catch 
{
    Write-Output "CONNECTION TO DATABASE UNSUCCESSFUL"
    exit
}

#If the backup directory doesn't exist we force a creation of a folder in path it is supposed to be in.
if(!(Test-Path -Path $localBackupDirectory))
{
    New-Item -ItemType Directory -Path $localBackupDirectory -Force
}

#This is the instantiation of the backup query that will be used to trigger a backup of the specified databse. 
#NOFORMAT and NOINIT is used because I don't want all of the previous backups to be overwritten. I want a history.
#I used SKIP to skip checking for any existing backups since I'm not overwritting it doesn't matter.
#STATS=1 will just show the process in increments of 1%
$backupQuery = "BACKUP DATABASE [$databaseName] TO DISK = N'$containerBackupFilePath' WITH NOFORMAT, NOINIT, NAME = N'$databaseName-Full Database Backup', SKIP, STATS = 1"


try 
{
    Invoke-Sqlcmd -ConnectionString $connectionString -Query $backupQuery
    Write-Output "Database backup successful. Backup file created at: " $backupFilePath "Completed at: " $timeStamp
    $progress = 0
    while ($progress -lt 100) 
    {
        #help for getting this progress bar was found in the offical powershell documentation: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/write-progress?view=powershell-7.4
        $progress += 10
        Write-Progress -PercentComplete $progress -Status "Backing up $databaseName" -Activity "Backup in progress"
        Start-Sleep -Seconds 1
    }

}
catch 
{
    Write-Output "---!ERROR!---"
    Write-Output "BACKUP UNSUCCESSFUL"
    exit
}


#These three lines about made me go bald. Since I am on a Mac system, I am running my database on a Docker container.
#Because it is inside a docker container, the database could not be copied locally. 
#The only way I could figure out how to do this was to backup the database to the container and then copy the 
#.bak file from the container to my local directory as seen here....
$containerName = "sqlserver" 
docker cp "${containerName}:$containerBackupFilePath" "$localBackupFilePath"
Write-Output "Backup file copied to local system at: $localBackupFilePath"


$zipFilePath = "$localBackupDirectory/$databaseName_$timeStamp.zip"
Compress-Archive -Path $localBackupFilePath -DestinationPath $zipFilePath
Write-Host "Backup compressed: $zipFilePath"

<# 
.SYNOPSIS
    Runs queries against SQLite databases and exports tables to csv
.DESCRIPTION
    .
.PARAMETER Query
    Use this parameter to indicate that you would like to run a query against the database
.PARAMETER Export
    Use this parameter to indicate that you would like to export a specified table to csv
.PARAMETER sqliteDB
    The absolute path to the SQLite database (i.e. C:\database\sqlite.db3).
.PARAMETER sqliteTable
    The name of the SQLite table to be used in the export process
.PARAMETER sqliteQuery
    The query to run against the SQLite database
.EXAMPLE
    Query -> Invoke-SQLiteCmd /Query /sqliteDB C:\SqliteDB\database.db3 /sqliteQuery "SELECT * FROM ThisTable"
    Export -> Invoke-SQLiteCmd /Export /sqliteDB C:\SqliteDB\database.db /sqliteTable ThisTable
.NOTES 
    SQLite Binaries are REQUIRED for using this script.  Download the Precompiled Binary for .Net
    from https://www.sqlite.org/download.html

    The script will assume that you have placed the SQLite binary file "System.Data.SQLite.dll"
    in this location: "C:\SQLite\System.Data.SQLite.dll".  If you binary will be located somewhere
    else, update the $sqlitebin variable accordingly

    Author: David Nite
    Date: 08/28/2018
#>

[CmdletBinding()]
param (
    [parameter(ParameterSetName='Query')][Switch]$Query,
    [parameter(ParameterSetName='Export')][Switch]$Export,
    [parameter(ParameterSetName='Query',Mandatory=$true)]
    [parameter(ParameterSetName='Export',Mandatory=$true)]
    [String]$sqliteDB,
    [parameter(ParameterSetName='Export',Mandatory=$true)]
    [String]$sqliteTable,
    [parameter(ParameterSetName='Query',Mandatory=$true)]
    [String]$sqliteQuery
)

# Location of the SQLite binary file "System.Data.SQLite.dll"
$sqlitebin = "C:\SQLite\System.Data.SQLite.dll"

# Create the SQLite connection
$slcon = New-Object -TypeName System.Data.SQLite.SQLiteConnection
$slcon.ConnectionString = "Data Source=$sqliteDB"
$slcon.Open()

# Function to run a powershell SQLite query
function Query {
    #Check to see if the database exists yet
    $dbTest = Test-Path -Path $sqliteDB
    if ($dbTest -eq "False") {
        Read-Host "Please rerun the script and specify and existing SQLite database`nPress any key to continue"
        Exit     
    }
    elseif ($dbTest -eq "True") {
        Write-Host "Found SQLite database at $sqliteDB"

        # Run the query
        $slquery = $slcon.CreateCommand()
        $slquery.CommandText = "'$sqliteQuery'"
        try { $slquery.ExecuteNonQuery() }
        catch {
            Write-Host "Unable to run the query"
        }
    }
}

# Function to export SQLite table to CSV file
function Export {
    $slExport = $slcon.CreateCommand()
    $slExport.CommandText = "SELECT * FROM '$sqliteTable'"
            $adapter = New-Object -TypeName System.Data.SQLite.SQLiteDataAdapter $slExport
            $export = New-Object System.Data.DataTable
            # Dump the SQLite table into a powershell DataTable
            try { [void]$adapter.Fill($export) }
            catch {
                Write-Log "Unable to get data from the SQLite table '$sqliteTable'" "ERROR"
                Break
            }

        #Export the DataTable to csv
        $export | Export-Csv "$PSScriptRoot\SQLiteDatabaseExport.csv" -NoTypeInformation
}

if ($Query.IsPresent) { Query }

if ($Export.IsPresent) { Export }
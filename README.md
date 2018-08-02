# Invoke-SQLiteCMD
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

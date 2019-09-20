# Process_Migration

### Setting up Top
* Run ``` top ```
* Press f to Edit the columns shown by Top
* Select Column P and Quit
* After returning to the "Top Screen", Hit Shift + w" to save these columns as Defualt in "~/.toprc"
* ``` chmod a+x ThreadMigration.sh ```
* Set Up Complete


### Usage

```./ThreadMigration.sh <PID> <Number of Iterations of Top>```

### Description

Given a Process, This script gives the following details
* Number of Threads of the Process
* The PIDs of the Threads that Migrate and that of Threads that do not Migrate 

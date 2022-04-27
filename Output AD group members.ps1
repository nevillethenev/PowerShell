
##Author: Neville Charles 
##get all users in the group "R&D Global" and output specific properties of the user 
##then output to a csv file

##Note 1: adds a column to mark user as enabled / disabled 

##Note 2: checks to see if Manager property is empty 

##Note 3: Edits the Manager value in the hastable to make it human readable 

##Note 4: Makes the name of the csv file = AD group name 

##Note 5: checks if AD group exists 


## Removes all variables 
Remove-Variable -Name * -ErrorAction SilentlyContinue

##Prompt for user to input an AD Group 
$ADgroup = Read-Host "Enter an Active Directory group"

##check if AD group exists 
$GroupExists = Get-ADGroup -Identity $ADgroup
if($GroupExists){

##get all the users in a specific AD group 
$Users = Get-ADGroupMember -Identity $ADgroup -Recursive 

$arraygoblin = @()

foreach($User in $Users){

    ##get the user SAM Account Name 
    $dragon = $User.SamAccountName

    ##Get specific user information and put into hash table
    $goblin = Get-AdUser -Filter "SamAccountName -eq '$dragon'" -Properties GivenName, Surname, EmailAddress, Title, Country, City, Name, Department, Company, Manager, Enabled| select GivenName, Surname, EmailAddress, Title, Country, City, Name, Department, Company, Manager, Enabled
    
    ##get the Manager information of a user 
    $mangoblin = Get-AdUser -Filter "SamAccountName -eq '$dragon'" -Property Manager
    
    if($mangoblin.Manager){ 

        ##if user has a manager then edit the Manager hastable value 
        ##get the Manager property of user
        $namegoblin = $mangoblin.Manager
        ##Get the manager's information 
        $Manager = Get-ADUser $namegoblin
        $ManagerName = $Manager.Name
        ##edit manager key value in goblin hash table 
        $goblin.Manager = $ManagerName
    }
    ##if user has no manager then do nothing
    else{ 
    } 
   
    ##append the array with user properties 
    $objectgoblin = $goblin | ForEach-Object { [pscustomobject] $_ }
    $arraygoblin += , $objectgoblin  
}

##export array to csv to the current users directory
$arraygoblin | Export-CSV -Path "C:\Users\$env:UserName\Documents\$ADgroup.csv"
##print message to screen
"$ADgroup.csv exported to C:\Users\$env:UserName\Documents\"
Read-Host -Prompt "Press Enter to exit"

 }

##if AD group does not exist then exit the script 
else{
"AD group does not exist"
Read-Host -Prompt "Press Enter to exit"
exit(1)
} 

/*1. Provide a SQL script that initializes the database for the Pet Adoption Platform ”PetPals”.
2. Create tables for pets, shelters, donations, adoption events, and participants. 
4. Ensure the script handles potential errors, such as if the database or tables already exist.
*/

create database PetPals

--Creating tables

create table Pets(
PetID int identity(1,1) not null primary key,
[name] varchar(20) not null,
age int not null,
breed varchar(20) not null,
[type] varchar(20) not null,
AvailableForAdoption bit not null,
)

create table Shelters(
ShelterID int not null primary key,
[Name] varchar(20) not null,
[Location] varchar(30) not null
)

create table Donations(
DonationID int Identity(101,1) not null primary key,
DonarName varchar(20) not null,
DonationType varchar(10) not null,
DonationAmount decimal(10,2) ,
DonationItem varchar(20) ,
DonationDate datetime not null
)

create table AdoptionEvents(
EventID int identity(200,1) not null primary key,
EventName varchar(50) not null,
EventDate datetime not null,
[Location] varchar(20) not null
)

create table Participants(
ParticipantID int identity(1,1) not null primary key,
ParticipantName varchar(20) not null,
ParticipantType varchar(10) not null,
EventID int,
foreign key(EventID) references AdoptionEvents(EventID) on delete cascade on update cascade)

--3. Define appropriate primary keys, foreign keys, and constraints. 

alter table Pets
add constraint CK_Pets
check([AvailableForAdoption]in('0','1'))


--inserting records

insert into Pets values('Tom',5,'Labrador','Dog',1),
				('Jack',2,'Indian Billi','Cat',0)

insert into Shelters values(301,'Sasi','Chennai'),
							(302,'Priya','Karur')

insert into Donations values('Pradeepa','Cash',50000,null,'2024-04-12 12:00:00'),
							('Saran','Item',null,'Food','2024-05-01 05:00:00')

insert into AdoptionEvents values('Pets adoption','2024-01-12 12:00:00','Chennai'),
								('Awareness program','2024-02-03 08:00:00','Mumbai')

insert into Participants values('Divya','Adopter',200),
								('Sasi','Shelter',201)


select * from Pets
select * from Shelters
select * from Donations
select * from AdoptionEvents
select * from Participants

/*5. Write an SQL query that retrieves a list of available pets (those marked as available for adoption) 
from the "Pets" table. Include the pet's name, age, breed, and type in the result set. Ensure that 
the query filters out pets that are not available for adoption.
*/

select * from Pets
where AvailableForAdoption=1

/*6. Write an SQL query that retrieves the names of participants (shelters and adopters) registered 
for a specific adoption event. Use a parameter to specify the event ID. Ensure that the query 
joins the necessary tables to retrieve the participant names and types.*/

declare @eventid int
set @eventid=200

select p.ParticipantName,a.EventName
from Participants p
join AdoptionEvents a
on p.EventID=a.EventID
where p.EventID=@eventid

/*7. Create a stored procedure in SQL that allows a shelter to update its information (name and 
location) in the "Shelters" table. Use parameters to pass the shelter ID and the new information. 
Ensure that the procedure performs the update and handles potential errors, such as an invalid 
shelter ID.*/

declare @shelterid int
set @shelterid=301
declare @sheltername varchar(20)
set @sheltername='Sheela'
declare @shelter_loc varchar(30)
set @shelter_loc='Delhi'

update Shelters set [name]=@sheltername,[Location]=@shelter_loc
where ShelterID=@shelterid


/*8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (by 
shelter name) from the "Donations" table. The result should include the shelter name and the 
total donation amount. Ensure that the query handles cases where a shelter has received no 
donations.*/

select DonarName,sum(donationamount) as Total_donation_amount
from Donations
where DonationAmount>0
group by DonarName


/*9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an 
owner (i.e., where "OwnerID" is null). Include the pet's name, age, breed, and type in the result 
set.*/

alter table pets add owner_id int

update Pets set owner_id = 1
where name='Tom'

select*from Pets
where owner_id is null

--10. Write an SQL query that retrieves the total donation amount for each month and year (e.g., 
--January 2023) from the "Donations" table. The result should include the month-year and the 
--corresponding total donation amount. Ensure that the query handles cases where no donations 
--were made in a specific month-year.

   select month(Donationdate) as [month],year(Donationdate) as [year],sum(donationamount) as Total_donation_amount
   from Donations
   where donationamount>0
   group by month(Donationdate),year(Donationdate)


--11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older
--than 5 years.

select distinct breed from pets
where (age between 1 and 3) or (age >5)


--12. Retrieve a list of pets and their respective shelters where the pets are currently available for 
--adoption.

alter table shelters add PetID int--adding a pet id to shelters

alter table shelters
add foreign key (PetID) references Pets(PetID);--adding foreign constraint

update Shelters set petid=1 where ShelterID=301--updating shelter

select p.[name],s.[name] from Pets p
join Shelters s
on p.PetID=s.petid
where p.AvailableForAdoption =1--result query

--13. Find the total number of participants in events organized by shelters located in specific city.
--Example: City=Chennai

select [location] ,count(participantname)
from AdoptionEvents
join participants
on AdoptionEvents.eventid=participants.EventID
group by [location]

--14. Retrieve a list of unique breeds for pets with ages between 1 and 5 years.

select distinct breed from pets
where age between 1 and 5

--15. Find the pets that have not been adopted by selecting their information from the 'Pet' table.

select * from Pets
where owner_id is null

--16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 
--'User' tables.

alter table pets 
add foreign key(owner_id) references participants(participantid)--connecting owner name to participant table


select [name],participantname from Pets
join Participants
on owner_id=ParticipantID

--17. Retrieve a list of all shelters along with the count of pets currently available for adoption in each 
--shelter.

select s.[name],count(s.petid) as available_count 
from Pets p
join Shelters s
on p.PetID=s.petid
where p.AvailableForAdoption =1
group by s.[name]


--18. Find pairs of pets from the same shelter that have the same breed.

select p.[name]
from Pets p
join Shelters s
on p.PetID=s.petid


--19. List all possible combinations of shelters and adoption events. 


--20. Determine the shelter that has the highest number of adopted pets

select top 1 [name] ,count(petid) as pet_count from Shelters
group by [name]
order by count(petid) desc

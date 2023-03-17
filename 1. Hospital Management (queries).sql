                             -- Hospital Management DataBase --

-- Creating Tables -- 

-- Patients Table --
create table patients(
patient_id int not null primary key,
first_name text,
last_name text,
gender char(1),
birth_date date,
city text,
province_id char(2),
allergies text,
height int,
weight int 
);


-- Admissions Table --
create table admissions(
patient_id int not null,
admission_date date,
discharge_date date,
diagnosis text,
attending_doctor_id int,
foreign key(patient_id) references patients(patient_id) on update cascade on delete cascade,
foreign key(attending_doctor_id) references doctors(doctor_id) on update cascade on delete cascade
);

-- Doctors Table --
create table doctors(
doctor_id int not null primary key,
first_name text,
last_name text,
specialty text
);

-- Province Table --
create table province_names(
province_id char(2) not null primary key,
province_name text
); 



# Queries :- 

 #1. Show first name, last name, and gender of patients who's gender is 'M' ?
 select first_name,last_name,gender from patients 
 where gender = "M";
 
 #2. Show first name and last name of patients who does not have allergies ?
select first_name,last_name,allergies from patients
where allergies is null;

#3. Show first name and last name of patients that weight within the range of 100 to 120 ?
select first_name,last_name,weight from patients
where weight between 100 and 120;

#4. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA' ?
update patients
set allergies = "NKA"
where allergies is null;

#5. Show first name and last name concatinated into one column to show their full name ?
select concat(first_name,' ',last_name) as 'Full Name' from patients; 

#6. Show first name, last name, and the full province name of each patient.
# Example: 'Ontario' instead of 'ON' ?
select first_name,last_name,province_name from patients as p
inner join province_names as pn
on p.province_id = pn.province_id;

#7. Show the first_name, last_name, and height of the patient with the greatest height ?
select first_name,last_name,max(height) as height from patients;

#8. Show the total number of admissions ?
select count(patient_id) as 'No of admissions' from admissions;

#9. Show all the columns from admissions where the patient was admitted and discharged on the same day ?
select * from admissions 
where admission_date = discharge_date;

#10. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select distinct city from patients
where province_id = "NS";

#11. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70 ?
select first_name,last_name,birth_date from patients
where height >160 and weight >70; 

#12. Based on cities where our patient lives in, write a query to display the list of unique city starting with a vowel (a, e, i, o, u). Show the result order in ascending by city ?
select distinct city from patients
where substr(city,1,1) in ('a','e','i','o','u')
order by city asc;

#13. Show unique first names from the patients table which only occurs once in the list ?
select distinct first_name from patients
group by first_name
having count(first_name) = 1;

#14. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia' ?
select p.patient_id,p.first_name,p.last_name from patients as p
inner join admissions as a
on p.patient_id = a.patient_id 
where diagnosis = 'Dementia';

#15. Show the total amount of male patients and the total amount of female patients in the patients table.
#Display the two results in the same row ?
select 
count(case when gender = 'M' then 1 else null end) as 'no of Male Patients',
count(case when gender = 'F' then 1 else null end) as 'no of Female Patients'
from patients;

#16. Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name ?
select first_name,last_name,allergies from patients
where allergies  in ('Penicillin','Morphine')
order by allergies,first_name,last_name asc;

#17. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis ?
select patient_id,diagnosis from admissions
group by patient_id,diagnosis
having count(patient_id) >1;

#18. Show the city and the total number of patients in the city.
# Order from most to least patients and then by city name ascending ?
select city, count(patient_id) as 'no of patients' from patients
group by city 
order by count(patient_id) desc ,city asc;

#19. Show first name, last name and role of every person that is either patient or doctor,The roles are either "Patient" or "Doctor" ?
select first_name,last_name,'patient' as role from patients
union all
select first_name,last_name,'doctor' as role from doctors;

#20. Show all allergies ordered by popularity. Remove NULL values from query ?
select allergies,count(*) as popularity from patients
where allergies != 'NKA'
group by allergies
order by popularity desc;
-- Here NKA mean null values, bcoz we have set null values as NKA.

/*21. We want to display each patient's full name in a single column. 
Their last_name in all upper letters must appear first, then first_name in all lower case letters. 
Separate the last_name and first_name with a comma. Order the list by the first_name in decending order ? */
select concat(upper(last_name),',',lower(first_name)) as 'Full Name' from patients
order by first_name desc;
 
#22. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000 ?
select province_id,sum(height) as patients_height from patients
group by province_id
having patients_height >= 7000; 

#23. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions ?
select day(admission_date) as day_no,
count(*) as no_of_admission 
from admissions
group by day_no
order by no_of_admission desc;

#24. Show all columns for patient_id 117's most recent admission_date ?
select * from admissions
where patient_id = 117 
group by patient_id
having admission_date = max(admission_date);

/*25. Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.*/
select patient_id,attending_doctor_id,diagnosis from admissions
where patient_id %2 != 0 and attending_doctor_id in (1,5,19)
or 
attending_doctor_id like '%2%'
and 
length(patient_id) = 3;

#26. Show first_name, last_name, and the total number of admissions attended for each doctor. Every admission has been attended by a doctor ?
select d.first_name,d.last_name,count(*) as no_of_admissions from doctors as d
inner join admissions as a
on d.doctor_id = a.attending_doctor_id
group by a.attending_doctor_id;

#27. For each doctor, display their id, full name, and the first and last admission date they attended ?
select doctor_id,concat(d.first_name,' ',d.last_name) as full_name,
min(admission_date) as first_admission_date,
max(admission_date) as last_admission_date
from doctors d
inner join admissions a
on d.doctor_id = a.attending_doctor_id
group by attending_doctor_id;

#28. Display the total amount of patients for each province. Order by descending ?
select province_name, count(*) as no_of_patients from patients as p
inner join province_names as pn
on p.province_id = pn.province_id
group by province_name
order by no_of_patients desc;

#29. For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem ?
select concat(p.first_name,' ',p.last_name) as patients_full_name,
a.diagnosis,concat(d.first_name,' ',d.last_name) as doctors_full_name
from patients as p
inner join admissions as a
on p.patient_id = a.patient_id
inner join doctors as d
on d.doctor_id = a.attending_doctor_id;

/* 30.Display patient's full name,
height in the units feet rounded to 1 decimal,
weight in the unit pounds rounded to 0 decimals,
birth_date,
gender non abbreviated.
Convert CM to feet by dividing by 30.48.
Convert KG to pounds by multiplying by 2.205. */ 

select concat(first_name,' ',last_name) as full_name,
round(height/ 30.48,1) as  feet,
round(weight* 2.205,0) as pounds,
birth_date,
case when gender = "M" then 'Male' Else 'Female' 
end as gender
from patients;

/*31.Show all of the patients grouped into weight groups.
Show the total amount of patients in each weight group.
Order the list by the weight group decending.
For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.*/ 
select
  count(patient_id) as patient_group,
  weight - weight % 10 AS weight_group
from patients
group by weight_group
order by weight_group desc;

# 32.Show patient_id, first_name, last_name, and attending doctor's specialty.
#Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa' ?
select p.patient_id,p.first_name,p.last_name,d.specialty from patients as p
inner join admissions as a
on p.patient_id = a.patient_id
inner join doctors as d
on d.doctor_id = a.attending_doctor_id
where a.diagnosis = 'Epilepsy' and d.first_name = 'Lisa';


/*33. All patients who have gone through admissions, can see their medical documents on our site. 
Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
The password must be the following, in order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date*/
select a.patient_id,
concat(a.patient_id,length(p.last_name),year(birth_date)) as temp_pass
from patients as p
inner join admissions as a
on p.patient_id = a.patient_id;



/*34. Each admission costs $50 for patients without insurance,
and $10 for patients with insurance. All patients with an even patient_id have insurance.
Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance.
 Add up the admission_total cost for each has_insurance group.*/
select 
case 
when patient_id % 2 = 0 then 'YES' else 'No' end as Has_Insurance,
sum(case when patient_id % 2 != 0 then 10 else 50 end) as total_admissions
from admissions
group by Has_Insurance;

#35. Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name ?
select pn.province_name from province_names as pn
inner join patients as p 
on pn.province_id = p.province_id
where gender = 'M' > gender = 'F'
group by pn.province_name;

#36. For each day display the total amount of admissions on that day. 
#Display the amount changed from the previous date ?
select admission_date, count(admission_date) as total_amount_of_admissions ,
count(admission_date) - lag(count(admission_date)) 
over(order by admission_date) as admissions_count
from admissions 
group by admission_date;

#37. Sort the province names in ascending order in such a way that the province 'Ontario' is always on top ?
select province_name
from province_names
order by
  (case when province_name = 'Ontario' then 0 else 1 end);







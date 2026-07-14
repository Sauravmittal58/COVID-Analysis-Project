SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000112')

UPDATE COVID_19_deaths
SET LA_code = ('E07000112'), LA_name = ('Folkestone and Hythe')
WHERE COVID_19_deaths.LA_name in ('Shepway')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000190', 'E07000191')

UPDATE COVID_19_deaths
SET LA_name = 'Somerset West and Taunton', LA_code = 'E07000246'
WHERE COVID_19_deaths.LA_code in ('E07000190', 'E07000191')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000201', 'E07000204')
 
UPDATE COVID_19_deaths
SET LA_name = 'West Suffolk', LA_code = 'E07000245'
WHERE COVID_19_deaths.LA_code in ('E07000201', 'E07000204')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000006')

UPDATE COVID_19_deaths
SET LA_code = ('E07000006')
WHERE COVID_19_deaths.LA_name = ('South Bucks')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000205', 'E07000206')
 
UPDATE COVID_19_deaths
SET LA_name = 'East Suffolk', LA_code = 'E07000244'
WHERE COVID_19_deaths.LA_code in ('E07000205', 'E07000206')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000049', 'E07000050', 'E07000053', 'E07000051', 'E07000052')

UPDATE COVID_19_deaths
SET LA_name = 'Dorset', LA_code = 'E06000059'
WHERE COVID_19_deaths.LA_code in ('E07000049', 'E07000050', 'E07000053', 'E07000051', 'E07000052')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E06000028', 'E06000029', 'E07000048')

UPDATE COVID_19_deaths
SET LA_name = 'Bournemouth, Christchurch and Poole', LA_code = 'E06000058'
WHERE COVID_19_deaths.LA_code in ('E06000028', 'E06000029', 'E07000048')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000004', 'E07000005', 'E07000006', 'E07000007')

UPDATE COVID_19_deaths
SET LA_name = 'Buckinghamshire', LA_code = 'E06000060'
WHERE COVID_19_deaths.LA_code in ('E07000004', 'E07000005', 'E07000006', 'E07000007')

UPDATE COVID_19_deaths
SET LA_code = 'E07000154'
WHERE COVID_19_deaths.LA_name = 'Northampton'

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000151','E07000154','E07000155')

UPDATE COVID_19_deaths
SET LA_name = 'West Northamptonshire', LA_code = 'E06000062'
WHERE COVID_19_deaths.LA_code in ('E07000151','E07000154','E07000155')

UPDATE COVID_19_deaths
SET la_code = 'E07000152'
WHERE COVID_19_deaths.LA_name = 'East Northamptonshire'

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000150','E07000152','E07000153','E07000156')

UPDATE COVID_19_deaths
SET LA_name = 'North Northamptonshire', LA_code = 'E06000061'
WHERE COVID_19_deaths.LA_code in ('E07000150','E07000152','E07000153','E07000156')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000187','E07000188','E07000189','E07000246')

UPDATE COVID_19_deaths
SET LA_name = 'Somerset', LA_code = 'E06000066'
WHERE COVID_19_deaths.LA_code in ('E07000187','E07000188','E07000189','E07000246')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000163','E07000164','E07000165','E07000166','E07000167','E07000168','E07000169')

UPDATE COVID_19_deaths
SET LA_name = 'North Yorkshire', LA_code = 'E06000065'
WHERE COVID_19_deaths.LA_code in ('E07000163','E07000164','E07000165','E07000166','E07000167','E07000168','E07000169')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000027','E07000030','E07000031')

UPDATE COVID_19_deaths
SET LA_name = 'Westmorland and Furness', LA_code = 'E06000064'
WHERE COVID_19_deaths.LA_code in ('E07000027','E07000030','E07000031')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code
FROM COVID_19_deaths
WHERE COVID_19_deaths.LA_code in ('E07000026','E07000028','E07000029')

UPDATE COVID_19_deaths
SET LA_name = 'Cumbria', LA_code = 'E06000063'
WHERE COVID_19_deaths.LA_code in ('E07000026','E07000028','E07000029')

SELECT COVID_19_deaths.LA_name, COVID_19_deaths.LA_code, sum(total) AS total
FROM COVID_19_deaths
group by LA_name, LA_code

select LA_name, la_code, total, (Aged_4_years_and_under+Aged_5_to_9_years+Aged_10_to_14_years+Aged_15_to_19_years) age_0_19_years,
(Aged_20_to_24_years+Aged_25_to_29_years+Aged_30_to_34_years+Aged_35_to_39_years)age_20_39_years,
(Aged_40_to_44_years+Aged_45_to_49_years+Aged_50_to_54_years+Aged_55_to_59_years) age_40_59_years,
(Aged_60_to_64_years+Aged_65_to_69_years+Aged_70_to_74_years+Aged_75_to_79_years) age_60_79_years,
(Aged_80_to_84_years+Aged_85_years_and_over) age_80_and_above
from age_1;

SELECT *
FROM Covid_deaths
JOIN Age_joined
on Covid_deaths.La_code = Age_joined.La_code
JOIN Ethnic_group
on Covid_deaths.LA_code = Ethnic_group.LA_code
JOIN Health_1
on Covid_deaths.LA_code = Health_1.LA_code
JOIN Travel_Method
on Covid_deaths.LA_code = Travel_Method.LA_code
order by Covid_deaths.LA_name ASC;

SELECT
	LA_name AS LA_Name,
    LA_code AS LA_Code,
    
    ROUND(COVID_Deaths * 1000.0 / Total, 2) AS Covid_Deaths,
    ROUND(age_0_19_years * 1000.0 / Total, 2) AS Age_0_19,
    ROUND(age_20_39_years * 1000.0 / Total, 2) AS Age_20_39,
    ROUND(age_40_59_years * 1000.0 / Total, 2) AS Age_40_59,
    ROUND(age_60_79_years * 1000.0 / Total, 2) AS Age_60_79,
    ROUND(age_80_and_above * 1000.0 / Total, 2) AS Age_80_Plus,
    ROUND(Asian_AsianBritish_or_Asian_Welsh * 1000.0 / Total, 2) AS Asian,
    ROUND(Black_BlackBritish_Black_Welsh_Caribbean_or_African * 1000.0 / Total, 2) AS Black,
    ROUND(Mixed_or_Multiple_ethnic_groups * 1000.0 / Total, 2) AS Mixed_Ethnic,
    ROUND(White * 1000.0 / Total, 2) AS White,
    ROUND(Other_ethnic_group * 1000.0 / Total, 2) AS Other_Ethnic,
    ROUND(Very_good_health * 1000.0 / Total, 2) AS Health_VGood,
    ROUND(Good_health * 1000.0 / Total, 2) AS Health_Good,
    ROUND(Fair_health * 1000.0 / Total, 2) AS Health_Fair,
    ROUND(Bad_health * 1000.0 / Total, 2) AS Health_Bad,
    ROUND(Very_bad_health * 1000.0 / Total, 2) AS Health_VBad,
    ROUND(Work_mainly_at_or_from_home * 1000.0 / Total, 2) AS Work_Home,
    ROUND(Underground_metro_light_rail_tram * 1000.0 / Total, 2) AS Metro_Rail,
    ROUND(Train * 1000.0 / Total, 2) AS Train,
    ROUND(Bus_minibus_or_coach * 1000.0 / Total, 2) AS Bus_Coach,
    ROUND(Taxi * 1000.0 / Total, 2) AS Taxi,
    ROUND(Motorcycle_scooter_or_moped * 1000.0 / Total, 2) AS Motorcycle,
    ROUND(Driving_a_car_or_van * 1000.0 / Total, 2) AS Driving_Car,
    ROUND(Passenger_in_a_car_or_van * 1000.0 / Total, 2) AS Passenger_Car,
    ROUND(Bicycle * 1000.0 / Total, 2) AS Bicycle,
    ROUND(On_foot * 1000.0 / Total, 2) AS On_Foot,
    ROUND(Other_method_of_travel_to_work * 1000.0 / Total, 2) AS Other_Travel
FROM COVID_Join_Latest;

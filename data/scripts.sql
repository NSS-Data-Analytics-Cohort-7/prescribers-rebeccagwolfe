-- Medicare Prescriptions Data
-- In this exercise, you will be working with a database created from the 2017 Medicare Part D Prescriber Public Use File, available at https://data.cms.gov/provider-summary-by-type-of-service/medicare-part-d-prescribers/medicare-part-d-prescribers-by-provider-and-drug.
-- 1. a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims. 

SELECT *
FROM prescription
ORDER BY total_claim_count DESC;
-- NPI: 1912011792 with 4538 claims

SELECT npi, COUNT (npi) AS npi_count
FROM prescription
GROUP BY npi
ORDER BY npi_count DESC
-- NPI: 1356305197 with 379 times

SELECT SUM (total_claim_count) AS total_claim, npi
FROM prescription
GROUP BY npi
ORDER BY total_claim DESC
--NPI: 1881634483 with 99707 claims

--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

SELECT SUM (prescription.total_claim_count) AS total_claim, nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description
FROM prescription
INNER JOIN prescriber
USING (npi)
GROUP BY nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description
ORDER BY total_claim DESC
-- Bruce Pendley, Family Practice

-- 2. a. Which specialty had the most total number of claims (totaled over all drugs)?

SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claims
FROM prescriber
INNER JOIN prescription
USING (npi)
GROUP BY prescriber.specialty_description
ORDER BY total_claims DESC;
-- Family Practice wtih 9732357 claims

-- b. Which specialty had the most total number of claims for opioids?

SELECT SUM(total_claim_count) AS total_claims, specialty_description, COUNT (opioid_drug_flag) AS opioid_count
FROM prescription
INNER JOIN drug
USING (drug_name)
INNER JOIN prescriber 
USING (npi)
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description
ORDER BY opioid_count DESC;
-- Nurse Practitioner with 9551 claims

--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- 3. a. Which drug (generic_name) had the highest total drug cost?
SELECT SUM(total_drug_cost) AS drug_cost, generic_name
FROM prescription
INNER JOIN drug
USING (drug_name)
GROUP BY generic_name
ORDER BY drug_cost DESC
-- Drug that the most money's been spent on:Insulin Glargine at $104,264,066.35

SELECT total_drug_cost, drug_name, generic_name
FROM prescription
INNER JOIN drug
USING (drug_name)
ORDER BY total_drug_cost DESC
-- Most expensive drug: Pirfenidone (Esbriet) at $2,829,174.30

-- b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.

SELECT drug_name, generic_name, ROUND((total_drug_cost/total_day_supply),2) AS cost_per_day
FROM prescription
INNER JOIN drug
USING (drug_name)
ORDER BY cost_per_day DESC

-- IMMUN GLOB G(IGG)/GLY/IGA OV50 (Gammagard Liquid) at $7141.11/day

-- 4. a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

SELECT drug_name, opioid_drug_flag
FROM drug
WHERE opioid_drug_flag = 'Y'



--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

-- 5. a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management') in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.


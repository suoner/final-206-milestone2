# Milestone 2: Concept Extraction from Clinical Notes

## Name: Su Oner

## Project Summary

This milestone focuses on using unstructured data to identify a cohort of patients prescribed Ruxolitinib (Opzelura) for Vitiligo. The core of the project involves extracting a random sample of clinical notes, applying pattern-matching techniques to search for drug mentions, and generating a demographic profile ("Table 1") for the resulting cohort. This profile is then compared against a baseline cohort derived from structured EHR data in Milestone 1 to evaluate the reliability and challenges of using clinical notes for this purpose.

## Files in This Repository

| File Name | Description |
| :--- | :--- |
| `initial_cohort_query.sql` | SQL script to generate the initial, full cohort of all patients with a Vitiligo diagnosis (5,209 patients). |
| `final_analysis.sql` | The primary SQL script for this milestone. It takes a random sample of 200 patients from the full cohort, performs pattern matching on their notes, and generates the final comparative demographic table. |
| `cohort_results.csv` | A CSV file containing the `person_id`s for the 5,209 patients in the full Vitiligo cohort. |
| `notes.csv` | A CSV file containing the random sample of 200 clinical notes used for the analysis. |
| `README.md` | This documentation file. |

## Clinical Notes & Subset Justification

* **Total Notes Analyzed**: A random sample of 200 notes was used for this analysis.
* **Patient Sample**: The notes were drawn from a random sample of 200 patients from the full cohort of 5,209 patients with Vitiligo.
* **Justification**: A subset was used for two primary reasons. First, analyzing the complete note history for over 5,000 patients is computationally intensive and not feasible for the scope of this project. Second, using a random sample of patients and notes provides a broad, unbiased snapshot of the clinical language used across the population, which is sufficient to demonstrate the methodological differences between structured and unstructured data analysis. All note types were included to capture the widest possible range of clinical documentation.

## Pattern Matching Results

The analysis was performed on the notes from a random sample of 200 patients.

* **Patients Identified**: The pattern-matching search for "Opzelura" or "Ruxolitinib" identified a cohort of **17 unique patients**.

## Table 1 Comparison: Milestone 1 vs. Milestone 2

The demographic profile of the cohort found in the notes was compared to the "gold standard" cohort of 317 patients from Milestone 1 who had a structured prescription record for the drug.

The most significant finding is a **dramatic difference in the age distribution** between the two cohorts. The cohort identified from clinical notes is substantially older than the cohort identified from structured prescription data, which aligns more closely with the expected patient population for this treatment.

**Table 1: Age Distribution Comparison (% of Cohort)**

| Age Range | Milestone 1 Cohort (n=317) | Milestone 2 Cohort (n=17) |
| :-------- | :------------------------- | :------------------------ |
| 0-9       | 7.33%                      | 9.52%                     |
| 10-19     | 29.66%                     | 38.10%                    |
| 20-29     | 27.97%                     | 9.52%                     |
| 30-39     | 22.56%                     | 0.00%                     |
| 40-49     | 24.86%                     | 9.52%                     |
| 50-59     | 24.82%                     | 38.10%                    |
| 60-69     | 24.55%                     | 47.62%                    |
| 70+       | 38.25%                     | 19.05%                    |

## Which source is more reliable for Ruxolitinib?

For identifying patients who have definitively **received a prescription** for Ruxolitinib, the **structured EHR data is more reliable**.

The significant discrepancy in both cohort size (317 vs. 17) and age distribution strongly suggests that pattern matching on notes captures a different clinical reality. The notes likely contain mentions of the drug in contexts other than a direct prescription, such as ruling out the drug for older patients or discussing it as a future possibility. While notes provide invaluable context—and may even capture prescriptions missed by the structured system—they are a "noisier" signal for this specific research question. The structured data, while lacking context, provides a more accurate record of the prescription event itself.

## How to Reproduce Results

1.  **Prerequisites**: Access to the UCSF RAE environment and a SQL client (e.g., Microsoft Azure Data Studio) are required.
2.  **Step 1: Create the Full Cohort Table**: Execute the code in `initial_cohort_query.sql`. This will create a permanent table in your database named `dbo.my_vitiligo_cohort` containing all 5,209 patients.
3.  **Step 2: Run the Final Analysis**: Execute the code in `final_analysis.sql`. This single query will perform the patient sampling, pattern matching, and generation of the final demographic comparison table.
4.  **Step 3: Export Results**: Once the query from Step 2 is complete, save the results from the output panel directly to a CSV file.

## Dependencies

* Microsoft Azure Data Studio (or a similar SQL client).
* Access to the UCSF Research Data Assets (RAE) SQL Server

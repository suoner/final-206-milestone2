-- CTE 1: Select a random sample of 200 patients to analyze.
WITH PatientSample AS (
    SELECT TOP 200
        person_id
    FROM
        dbo.my_vitiligo_cohort
    ORDER BY
        NEWID()
),

-- CTE 2: Gather all notes for ONLY the sampled patients into a temporary set.
SampledNotes AS (
    SELECT
        c.person_id,
        txt.note_text
    FROM
        PatientSample c
    JOIN
        OMOP_DEID.ucsf.person p ON c.person_id = p.person_id
    JOIN
        CDW_NEW.deid_uf.note_metadata meta ON p.person_source_value = meta.patientepicid
    JOIN
        CDW_NEW.deid_uf.note_text txt ON meta.deid_note_key = txt.deid_note_key
),

-- CTE 3: Perform pattern matching on the small set of notes to find the drug mentions.
PatientsWithDrugMentions AS (
    SELECT DISTINCT
        person_id
    FROM
        SampledNotes
    WHERE
        (note_text LIKE '%opzelura%' OR note_text LIKE '%ruxolitinib%')
),

-- CTE 4: Create a combined list of all patients for the final demographic analysis,
-- labeling each patient with their cohort type.
all_patients_for_analysis AS (
    SELECT person_id, 'Full Cohort' as cohort_name FROM dbo.my_vitiligo_cohort
    UNION ALL
    SELECT person_id, 'Pattern Match Cohort' as cohort_name FROM PatientsWithDrugMentions
),

-- CTE 5: Calculate the total size of each cohort, to be used as the denominator for percentages.
CohortTotals AS (
    SELECT
        cohort_name,
        COUNT(person_id) as total_patients
    FROM all_patients_for_analysis
    GROUP BY cohort_name
)

-- Final Output: Generate the pivoted table for Age demographics, showing percentages.
SELECT
    CASE
        WHEN (2025 - p.year_of_birth) BETWEEN 0 AND 9 THEN '0-9'
        WHEN (2025 - p.year_of_birth) BETWEEN 10 AND 19 THEN '10-19'
        WHEN (2025 - p.year_of_birth) BETWEEN 20 AND 29 THEN '20-29'
        WHEN (2025 - p.year_of_birth) BETWEEN 30 AND 39 THEN '30-39'
        WHEN (2025 - p.year_of_birth) BETWEEN 40 AND 49 THEN '40-49'
        WHEN (2025 - p.year_of_birth) BETWEEN 50 AND 59 THEN '50-59'
        WHEN (2025 - p.year_of_birth) BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70+'
    END as "Age Range",
    -- Calculate percentage for the 'Full Cohort'
    CAST(100.0 * COUNT(CASE WHEN a.cohort_name = 'Full Cohort' THEN a.person_id END) / MIN(CASE WHEN ct.cohort_name = 'Full Cohort' THEN ct.total_patients END) AS decimal(5, 2)) AS "Full Cohort (%)",
    -- Calculate percentage for the 'Pattern Match Cohort'
    CAST(100.0 * COUNT(CASE WHEN a.cohort_name = 'Pattern Match Cohort' THEN a.person_id END) / MIN(CASE WHEN ct.cohort_name = 'Pattern Match Cohort' THEN ct.total_patients END) AS decimal(5, 2)) AS "Pattern Match Cohort (%)"
FROM
    all_patients_for_analysis a
JOIN
    OMOP_DEID.ucsf.person p ON a.person_id = p.person_id
CROSS JOIN
    CohortTotals ct
GROUP BY
    CASE
        WHEN (2025 - p.year_of_birth) BETWEEN 0 AND 9 THEN '0-9'
        WHEN (2025 - p.year_of_birth) BETWEEN 10 AND 19 THEN '10-19'
        WHEN (2025 - p.year_of_birth) BETWEEN 20 AND 29 THEN '20-29'
        WHEN (2025 - p.year_of_birth) BETWEEN 30 AND 39 THEN '30-39'
        WHEN (2025 - p.year_of_birth) BETWEEN 40 AND 49 THEN '40-49'
        WHEN (2025 - p.year_of_birth) BETWEEN 50 AND 59 THEN '50-59'
        WHEN (2025 - p.year_of_birth) BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70+'
    END
ORDER BY
    "Age Range";

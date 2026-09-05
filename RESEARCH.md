# Pharmacy Plus — Research & source policy

Date prepared: 2026-09-03

## Why the structure uses ATC
WHO's Anatomical Therapeutic Chemical (ATC) system groups active substances by the organ/system they act on plus therapeutic, pharmacological and chemical properties. The first level contains 14 main groups and the full system has five levels. Pharmacy Plus uses those 14 groups as its top-level navigation.

## Primary data sources to connect in production
- WHO ATC/DDD: https://www.who.int/tools/atc-ddd-toolkit/atc-classification
- FDA openFDA drug labeling: https://open.fda.gov/apis/drug/label/
- FDA Drugs@FDA: https://open.fda.gov/apis/drug/drugsfda/
- EMA medicines data: https://www.ema.europa.eu/en/medicines/download-medicine-data
- NLM RxNorm/RxNav APIs: https://lhncbc.nlm.nih.gov/RxNav/APIs/index.html
- NLM DailyMed: https://dailymed.nlm.nih.gov/dailymed/

## How to treat the 212 entries
The bundled 212 records are an educational starter library, not a claim of global completeness. Every drug card is deliberately written as a concise learning summary. Exact dosing, contraindications, interactions, pediatric use, pregnancy/lactation, renal/hepatic adjustments and country-specific availability should be verified against current product labeling and local guidelines before clinical use.

## Production content model
The database separates systems, drugs, interactions, clinical guides, cases and MCQs. This makes it possible to add new entries without changing the UI code. The admin role is enforced in PostgreSQL with Row Level Security rather than by hiding a password in front-end JavaScript.

## Update strategy
A production deployment should add a reviewed_at field and source URL(s) for each clinical record, then run a scheduled review workflow. openFDA says its downloaded labeling dataset can change old records and was updated 2026-08-31; EMA states its published medicine tables are automatically updated overnight. Therefore a medical education site should show a last-reviewed date and keep source links visible.

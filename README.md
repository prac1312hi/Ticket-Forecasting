# Ticket Volume Forecast

Forecasts monthly support-ticket volume and picks the most accurate method using walk-forward testing.

## Files
| File | What it does |
|---|---|
| `monthly_cases.sql` | SQL (MySQL) to get monthly ticket counts from a cases table |
| `prepare_data.py` | Turns a Salesforce case export (.xlsx) into `monthly_tickets.csv` (month + count only) |
| `forecast.py` | Tests 4 methods (naive, 3-month moving average, exponential smoothing, Holt trend), reports MAPE, forecasts the next 3 months and saves a chart |

## How to run
```bash
pip install pandas numpy matplotlib statsmodels openpyxl
python prepare_data.py "your_salesforce_export.xlsx"   # or export the SQL result as monthly_tickets.csv
python forecast.py
```

## Method
- **Walk-forward test:** each of the last 3 months is forecast using only the data before it, then compared with the actual value.
- **Metric:** MAPE (mean absolute percentage error), where lower is better.
- The method with the lowest MAPE is retrained on all data and used for the 3-month forecast.

## Findings
- A trend model (Holt) over-reacted to a sharp mid-2026 drop and was the least accurate.
- Year-over-year comparison ruled out seasonality: the same months rose in 2025.
- The drop matched a period when case ownership shifted to new joiners during mentoring, so the model was chosen to follow the current level rather than the trend.

## Data privacy
Only monthly counts are stored in this repo. No customer, contact or employee data is included.

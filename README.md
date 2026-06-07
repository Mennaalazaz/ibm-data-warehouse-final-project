# IBM Data Warehouse Final Project

## Overview

This project implements a Data Warehouse solution for a solid waste management company operating across major cities in Brazil.

The company collects, transports, and recycles waste using different truck types and collection stations. The goal of the warehouse is to support analytical reporting and business intelligence operations.

## Business Requirements

The data warehouse enables reporting such as:

* Total waste collected per year per city
* Total waste collected per month per city
* Total waste collected per quarter per city
* Total waste collected per truck type
* Total waste collected per truck type and city
* Total waste collected per truck type, station, and city

---

## Data Warehouse Schema

The project follows a Star Schema design consisting of:

### Dimension Tables

#### MyDimDate

Stores calendar information:

* DateID
* DateValue
* Year
* Quarter
* QuarterName
* Month
* MonthName
* Day
* Weekday
* WeekdayName

#### DimTruck

Stores truck information:

* TruckID
* TruckType

#### DimStation

Stores station information:

* StationID
* City

### Fact Table

#### FactTrips

Stores waste collection transactions:

* TripID
* DateID
* StationID
* TruckID
* WasteCollected

Foreign keys connect the fact table to the corresponding dimension tables.

---

## Technologies Used

* PostgreSQL
* SQL
* Data Warehouse Modeling
* Star Schema Design
* Materialized Views
* Aggregation Techniques

---

## Analytical Queries

### GROUPING SETS

Used to generate multiple custom aggregation levels in a single query.

Examples:

* Waste collected by Station and Truck Type
* Waste collected by Station
* Waste collected by Truck Type
* Grand Total

### ROLLUP

Used to generate hierarchical summaries.

Hierarchy:

Station → City → Year → Grand Total

### CUBE

Used to generate all possible aggregation combinations for:

* Year
* City
* Station

### Materialized View

A materialized view named:

```sql
max_waste_stats
```

stores the maximum waste collected grouped by:

* City
* Station
* Truck Type

and can be refreshed when new data is loaded.

---

## Project Structure

```text
.
├── SQL/
│   ├── create_tables.sql
│   ├── load_data.sql
│   ├── grouping_sets.sql
│   ├── rollup.sql
│   ├── cube.sql
│   └── materialized_view.sql
│
├── data/
│   ├── DimDate.csv
│   ├── DimTruck.csv
│   ├── DimStation.csv
│   └── FactTrips.csv
│
└── README.md
```

---

## Learning Outcomes

This project demonstrates:

* Data Warehouse design
* Star Schema implementation
* Fact and Dimension modeling
* PostgreSQL data loading
* Aggregation techniques
* Business intelligence reporting
* Materialized views optimization

---

## Author

Menna
Data Engineering Student

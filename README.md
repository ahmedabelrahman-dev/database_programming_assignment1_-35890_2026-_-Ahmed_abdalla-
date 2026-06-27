# Advanced SQL Project: CTEs & Window Functions

**Course:** C11665 - DPR400210: Database Programming  
**Instructor:** Eric Maniraguha  
**Institution:** University of Lay Adventists of Kigali (UNILAK)  
**Student Name:** Ahmed Abdalla Mohamed Abdelrahman  
**Student ID:** 35890/2026

---

GitHub profile: [https://github.com/ahmedabelrahman-dev]
Github Repository: []

---

## 🏬 Business Scenario

This project implements a backend database system for an **E-Commerce Platform**. The system tracks product categories hierarchically, manages user profile demographics, records standalone transactional order weights, and evaluates granular item sales distributions.

### Database Schema & Relationship Blueprint

The relational database utilizes four primary core tables designed with explicit structural constraints to maintain optimal data integrity:

1. **Categories:** Hierarchical table tracking product categories and sub-categories using a self-referencing foreign key constraint.
2. **Customers:** Operational master registry holding unique user details, localized locations, and explicit sign-up timestamps.
3. **Orders:** Central transactional header document capturing total financial aggregates grouped by customer.
4. **Order_Items:** Detailed line-item breakdown linking singular product purchases back to physical categories and parent orders.

---

### Entity Relationship Diagram (ERD)

[Categories] ◄─── (Self-References via parent_category_id)
▲
│ (category_id)
│
[Order_Items] ────(order_id)────► [Orders] ────(customer_id)────► [Customers]

---

## 📈 Analysis and Findings

Descriptive Analysis (What Happened?):
Based on the running aggregate outputs, platform revenue metrics show clear variation between categories. High-ticket computing electronics drive the highest individual basket weights, whereas general fashion items contribute steady, high-volume transactions.

Diagnostic Analysis (Why Did It Happen?):
Window function ranking outputs reveal that top-tier spend classifications are linked to localized customer hubs within Kigali. This pattern appears to be driven by demographic access to premium hardware and professional computer models.

Prescriptive Analysis (What Actions Should Be Taken?):
The platform should implement automated cross-selling recommendation models for technical accessories (such as cases and peripherals) targeting customers purchasing high-end laptops. This approach aims to maximize average order value (AOV).

# Hospital Management System – ERD Design
 
Database design assignment simulating a real-world hospital system. The goal is to analyze requirements, classify all components, and produce a structured data design ready for implementation.
 
---
 
## Folder Structure
 
```
Hospital-System-ERD/
│
├── 01-Analysis/          # Entity identification, attributes, relationships
├── 02-Logical-Design/    # Keys, cardinality, participation, FK summary
├── 03-ERD/               # Final ERD diagram (PNG/JPG/PDF)
├── 04-Scenarios/         # Real-world behavior analysis
├── 05-Required-Thinking/ # Classification table
└── README.md
```
 
---
 
## System Scope
 
| Entity | Description |
|---|---|
| Patient | A person registered in the hospital |
| Doctor | A medical professional who treats patients |
| Department | A hospital division that groups doctors and offers services |
| Appointment | A scheduled visit between a patient and a doctor |
| Service | A test or treatment provided during an appointment |
| Medical Record | A clinical document created per appointment |
| Billing | A financial record tied to an appointment |
| Schedule | A table for the working hours and days |
| Payment | A financial record for amounts paid with specific method |
| Insurance | A list of insurance of patients |
 
---
 
## Key Design Decisions
 
**1. Appointment ↔ Service: Junction Table**  
The M:M relationship is resolved via an `Appointment_Service` junction table. `Quantity` lives here because it only exists in the context of a specific service being used in a specific appointment. This is a relationship attribute by definition.
 
**2. Age is Derived**  
`Age` is not stored. It is calculated from `DOB` at query time. Storing it would require updates to every patient record over time.
 
**3. Department Head is Nullable**  
`Head_Doctor_ID` in `Department` is optional. This handles a department with no assigned head yet and prevents a circular dependency from blocking doctor inserts.
 
**4. Billing Supports Partial Payments**  
`Billing` stores `Total_Amount`, `Paid_Amount`, and `Remaining_Amount` (derived). `Insurance_Covered_Amount` is also stored to track what the insurance provider covered.
 
**5. Payment is a Separate Entity**  
A bill can be paid using more than one method. `Payment` is a separate entity linked to `Billing` (1:M), storing the amount, method, and date per transaction.
 
**6. Doctor Availability via Schedule**  
`Schedule` is a separate entity linked to `Doctor` (1:M), storing `Day_of_Week`, `Start`, and `End` hours. A doctor can have multiple schedule entries across the week.
 
**7. Is_Active on Doctor**  
Instead of deleting a doctor record when they leave, `Is_Active` flags them as inactive. This preserves all historical appointments and medical records.
 
**8. Service Category as Attribute**  
Services are grouped by a `Category` attribute. Since categories do not require their own properties at this stage, an attribute is sufficient.
 
---
 
## Relationships Summary
 
| Relationship | Entities | Cardinality |
|---|---|---|
| has | Patient - Appointment | 1:M |
| handles | Doctor - Appointment | 1:M |
| work | Doctor - Department | M:1 |
| head | Doctor - Department | 1:1 |
| create | Doctor - Medical Record | 1:M |
| has | Patient - Medical Record | 1:M |
| result | Appointment - Medical Record | 1:1 |
| has | Patient - Billing | 1:M |
| has | Appointment - Billing | 1:1 |
| offer | Department - Service | M:M |
| include | Appointment - Service | M:M |
| based on | Billing - Service | M:M |
| has | Doctor - Schedule | 1:M |
| has | Patient - Insurance | 1:M |
| has | Billing - Payment | 1:M |
| pay | Insurance - Billing | 1:M |
 
---
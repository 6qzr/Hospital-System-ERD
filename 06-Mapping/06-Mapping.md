# Hospital Management System – Relational Mapping
 
Derived from the final ERD and logical design. Each entity is mapped to a relational table with its attributes, primary keys, and foreign keys.
 
---
 
## Patient
```
Patient(Patient_ID, F_Name, L_Name, DOB, Age*, Blood_Group, Gender, Phone_Number)
```
- PK: `Patient_ID`
- `Age` is derived from `DOB` — not stored
---
 
## Doctor
```
Doctor(Doctor_ID, F_Name, L_Name, Specialization, Gender, Is_Active, Dept_ID)
```
- PK: `Doctor_ID`
- FK: `Dept_ID` → Department(Dept_ID)
---
 
## Department
```
Department(Dept_ID, Dept_Name, Location, Head_Doctor_ID)
```
- PK: `Dept_ID`
- FK: `Head_Doctor_ID` → Doctor(Doctor_ID) — nullable
---
 
## Schedule
```
Schedule(Schedule_ID, Day_of_Week, Start, End, Doctor_ID)
```
- PK: `Schedule_ID`
- FK: `Doctor_ID` → Doctor(Doctor_ID)
---
 
## Appointment
```
Appointment(Appointment_ID, Date, Time, Status, Type, Patient_ID, Doctor_ID)
```
- PK: `Appointment_ID`
- FK: `Patient_ID` → Patient(Patient_ID)
- FK: `Doctor_ID` → Doctor(Doctor_ID)
- `Status` values: Scheduled / Completed / Cancelled / No-show
---
 
## Service
```
Service(Service_ID, Name, Type, Price, Category)
```
- PK: `Service_ID`
---
 
## Appointment_Service *(junction table)*
```
Appointment_Service(Appointment_ID, Service_ID, Quantity)
```
- PK: `Appointment_ID` + `Service_ID` (composite)
- FK: `Appointment_ID` → Appointment(Appointment_ID)
- FK: `Service_ID` → Service(Service_ID)
- `Quantity` is a relationship attribute
---
 
## Medical Record
```
Medical_Record(Record_ID, Diagnosis, Treatment, Appointment_ID, Patient_ID, Doctor_ID)
```
- PK: `Record_ID`
- FK: `Appointment_ID` → Appointment(Appointment_ID)
- FK: `Patient_ID` → Patient(Patient_ID)
- FK: `Doctor_ID` → Doctor(Doctor_ID)
---
 
## Insurance
```
Insurance(Insurance_ID, Provider_Name, Coverage_Type, Patient_ID)
```
- PK: `Insurance_ID`
- FK: `Patient_ID` → Patient(Patient_ID)
---
 
## Billing
```
Billing(Bill_ID, Total_Amount, Paid_Amount, Remaining_Amount*, Date, Insurance_Covered_Amount, Appointment_ID, Insurance_ID)
```
- PK: `Bill_ID`
- FK: `Appointment_ID` → Appointment(Appointment_ID)
- FK: `Insurance_ID` → Insurance(Insurance_ID) — nullable
- `Remaining_Amount` is derived: Total_Amount − Paid_Amount
---
 
## Payment
```
Payment(Payment_ID, Amount, Method, Date, Bill_ID)
```
- PK: `Payment_ID`
- FK: `Bill_ID` → Billing(Bill_ID)
---
 
## Notes
- `*` marks derived attributes — computed at query time, not stored
- Nullable FKs: `Head_Doctor_ID` in Department, `Insurance_ID` in Billing
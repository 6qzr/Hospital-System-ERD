\# Hospital Management System – ERD Design



Database design assignment simulating a real-world hospital system. The goal is to analyze requirements, classify all components, and produce a structured data design ready for implementation.



\---



\## Folder Structure



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



\---



\## Key Design Decisions



\*\*1. Appointment ↔ Service: Junction Table\*\*  

The M:M relationship is resolved via an `Appointment\_Service` junction table. `Quantity` lives here — not in `Appointment` or `Service` — because it only exists in the context of a specific service being used in a specific appointment. This is a relationship attribute by definition.



\*\*2. Age is Derived\*\*  

`Age` is not stored. It is calculated from `Date\_Of\_Birth` at query time. Storing it would require annual updates to every patient record, introducing update anomalies.



\*\*3. Department Head is Nullable\*\*  

`Head\_Doctor\_ID` in `Department` is optional. This handles two cases: a department with no assigned head yet, and a department whose head recently left. It also prevents a circular dependency from blocking doctor inserts.



\*\*4. Billing Supports Partial Payments\*\*  

`Billing` stores both `Paid\_Amount` and `Total\_Amount`. `Remaining\_Amount` is derived. This tracks outstanding balances without requiring a separate payments table.



\*\*5. Soft Deletes Over Hard Deletes\*\*  

Appointments use a `Status` attribute (Scheduled / Completed / Cancelled). Doctors use an `Is\_Active` flag. No rows are deleted — historical data and audit trails are fully preserved.



\---



\## Challenges Faced



\- Client requirements were intentionally vague on several points (head mandatory? partial payments? price changes?). These were treated as design decisions to justify rather than gaps to leave open.

\- The Appointment-Service M:M relationship required careful thought on where `Quantity` belongs. The junction table is the only normalized answer.

\- The circular dependency risk between `Doctor` and `Department` (a doctor heads a department that contains doctors) was resolved by making `Head\_Doctor\_ID` nullable and inserting departments before assigning heads.

\- Derived attributes (`Age`, `Remaining\_Amount`) required explicit decisions on what to store vs. compute to avoid update anomalies.



\---



\## System Scope



| Entity | Description |

|---|---|

| Patient | Personal and contact information, DOB, blood group, gender |

| Doctor | Specialization, works in a department, creates medical records |

| Department | Groups doctors, has an optional head, offers services |

| Appointment | Links patient and doctor, stores date/time/status/type |

| Service | Name, type, unit price — used during appointments |

| Medical Record | Diagnosis and treatment, linked to appointment and doctor |

| Billing | Payment details, linked to appointment, supports partial payments |



\---



\*Codeline by Rihal – Real Company Simulation\*


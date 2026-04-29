-- ============================================================
-- Hospital Management System
-- SQL Implementation (SQL Server)
-- ============================================================
 
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'HMSDB')
    CREATE DATABASE HMSDB;
GO

USE HMSDB;
GO

-- Department (created before Doctor due to FK dependency)
CREATE TABLE Department (
    Dept_ID         INT             PRIMARY KEY IDENTITY(1,1),
    Dept_Name       VARCHAR(100)    NOT NULL,
    Location        VARCHAR(100),
    Head_Doctor_ID  INT                         -- nullable, assigned after Doctor insert
);
 
-- Doctor
CREATE TABLE Doctor (
    Doctor_ID       INT             PRIMARY KEY IDENTITY(1,1),
    F_Name          VARCHAR(50)     NOT NULL,
    L_Name          VARCHAR(50)     NOT NULL,
    Specialization  VARCHAR(100),
    Gender          VARCHAR(10),
    Is_Active       BIT             NOT NULL DEFAULT 1,
    Dept_ID         INT             NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);
 
-- Add Head_Doctor_ID FK after Doctor table exists
ALTER TABLE Department
    ADD CONSTRAINT fk_head_doctor
    FOREIGN KEY (Head_Doctor_ID) REFERENCES Doctor(Doctor_ID);
 
-- Patient
CREATE TABLE Patient (
    Patient_ID      INT             PRIMARY KEY IDENTITY(1,1),
    F_Name          VARCHAR(50)     NOT NULL,
    L_Name          VARCHAR(50)     NOT NULL,
    DOB             DATE            NOT NULL,
    Blood_Group     VARCHAR(5),
    Gender          VARCHAR(10),
    Phone_Number    VARCHAR(20)
    -- Age is derived: DATEDIFF(YEAR, DOB, GETDATE())
);
 
-- Schedule
CREATE TABLE Schedule (
    Schedule_ID     INT             PRIMARY KEY IDENTITY(1,1),
    Day_of_Week     VARCHAR(10)     NOT NULL,
    Start_Time      TIME            NOT NULL,
    End_Time        TIME            NOT NULL,
    Doctor_ID       INT             NOT NULL,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);
 
-- Insurance
CREATE TABLE Insurance (
    Insurance_ID    INT             PRIMARY KEY IDENTITY(1,1),
    Provider_Name   VARCHAR(100)    NOT NULL,
    Coverage_Type   VARCHAR(10)     NOT NULL CHECK (Coverage_Type IN ('Full', 'Partial')),
    Patient_ID      INT             NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
);
 
-- Appointment
CREATE TABLE Appointment (
    Appointment_ID  INT             PRIMARY KEY IDENTITY(1,1),
    Date            DATE            NOT NULL,
    Time            TIME            NOT NULL,
    Status          VARCHAR(15)     NOT NULL CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled', 'No-show')),
    Type            VARCHAR(20),
    Patient_ID      INT             NOT NULL,
    Doctor_ID       INT             NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Doctor_ID)  REFERENCES Doctor(Doctor_ID)
);
 
-- Service
CREATE TABLE Service (
    Service_ID      INT             PRIMARY KEY IDENTITY(1,1),
    Name            VARCHAR(100)    NOT NULL,
    Type            VARCHAR(50),
    Price           DECIMAL(10, 2)  NOT NULL,
    Category        VARCHAR(50)
);
 
-- Appointment_Service (junction table)
CREATE TABLE Appointment_Service (
    Appointment_ID  INT             NOT NULL,
    Service_ID      INT             NOT NULL,
    Quantity        INT             NOT NULL DEFAULT 1,
    PRIMARY KEY (Appointment_ID, Service_ID),
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID),
    FOREIGN KEY (Service_ID)     REFERENCES Service(Service_ID)
);
 
-- Medical_Record
CREATE TABLE Medical_Record (
    Record_ID       INT             PRIMARY KEY IDENTITY(1,1),
    Diagnosis       VARCHAR(MAX),
    Treatment       VARCHAR(MAX),
    Appointment_ID  INT             NOT NULL,
    Patient_ID      INT             NOT NULL,
    Doctor_ID       INT             NOT NULL,
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID),
    FOREIGN KEY (Patient_ID)     REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Doctor_ID)      REFERENCES Doctor(Doctor_ID)
);
 
-- Billing
CREATE TABLE Billing (
    Bill_ID                  INT             PRIMARY KEY IDENTITY(1,1),
    Total_Amount             DECIMAL(10, 2)  NOT NULL,
    Paid_Amount              DECIMAL(10, 2)  NOT NULL DEFAULT 0,
    Date                     DATE            NOT NULL,
    Insurance_Covered_Amount DECIMAL(10, 2)           DEFAULT 0,
    Appointment_ID           INT             NOT NULL,
    Insurance_ID             INT,            -- nullable
    -- Remaining_Amount is derived: Total_Amount - Paid_Amount
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID),
    FOREIGN KEY (Insurance_ID)   REFERENCES Insurance(Insurance_ID)
);
 
-- Payment
CREATE TABLE Payment (
    Payment_ID      INT             PRIMARY KEY IDENTITY(1,1),
    Amount          DECIMAL(10, 2)  NOT NULL,
    Method          VARCHAR(30)     NOT NULL,
    Date            DATE            NOT NULL,
    Bill_ID         INT             NOT NULL,
    FOREIGN KEY (Bill_ID) REFERENCES Billing(Bill_ID)
);
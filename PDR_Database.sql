CREATE TABLE [Customers] (
    [cust_id] int IDENTITY(1,1) NOT NULL ,
    [first_name] varchar(50)  NOT NULL ,
    [last_name] varchar(50)  NOT NULL ,
    [phone_num] varchar(15)  NOT NULL ,
    [email] varchar(100)  NOT NULL ,
    [home_address] varchar(255)  NOT NULL ,
    CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED (
        [cust_id] ASC
    )
)

CREATE TABLE [Vehicles] (
    [vehicle_id] int IDENTITY(1,1) NOT NULL ,
    [cust_id] int  NOT NULL ,
    [make] varchar(50)  NOT NULL ,
    [model] varchar(50)  NOT NULL ,
    [year] int  NOT NULL ,
    [license_plate] varchar(20)  NOT NULL ,
    [vin] varchar(20)  NOT NULL ,
    CONSTRAINT [PK_Vehicles] PRIMARY KEY CLUSTERED (
        [vehicle_id] ASC
    )
)

CREATE TABLE [Appointments] (
    [appt_id] int IDENTITY(1,1) NOT NULL ,
    [vehicle_id] int  NOT NULL ,
    [appt_date] date  NOT NULL ,
    [memo] text  NOT NULL ,
    CONSTRAINT [PK_Appointments] PRIMARY KEY CLUSTERED (
        [appt_id] ASC
    )
)

CREATE TABLE [Repairs] (
    [repair_id] int IDENTITY(1,1) NOT NULL ,
    [appt_id] int  NOT NULL ,
    [quoted_price] decimal(5,2)  NOT NULL ,
    [estimated_hours] decimal(4,2)  NOT NULL ,
    [actual_hours] decimal(4,2)  NOT NULL ,
    CONSTRAINT [PK_Repairs] PRIMARY KEY CLUSTERED (
        [repair_id] ASC
    )
)

CREATE TABLE [Invoices] (
    [invoice_id] int IDENTITY(1,1) NOT NULL ,
    [repair_id] int  NOT NULL ,
    [quoted_price] decimal(5,2)  NOT NULL ,
    [payment_date] date  NOT NULL ,
    [invoice_date] date  NOT NULL ,
    CONSTRAINT [PK_Invoices] PRIMARY KEY CLUSTERED (
        [invoice_id] ASC
    )
)


SELECT * FROM Customers




--CHAT GPT DERIVED SAMPLE DATA!! NOT REAL!!--

-- Insert sample data into the Customers table
INSERT INTO [Customers] ([first_name], [last_name], [phone_num], [email], [home_address])
VALUES 
('John', 'Doe', '555-1234', 'john.doe@email.com', '123 Main St, Springfield, IL'),
('Jane', 'Smith', '555-5678', 'jane.smith@email.com', '456 Oak St, Springfield, IL'),
('Michael', 'Johnson', '555-8765', 'michael.johnson@email.com', '789 Pine St, Springfield, IL');

-- Insert sample data into the Vehicles table
INSERT INTO [Vehicles] ([cust_id], [make], [model], [year], [license_plate], [vin])
VALUES 
(1, 'Toyota', 'Corolla', 2015, 'ABC123', '1HGBH41JXMN109186'),
(2, 'Honda', 'Civic', 2018, 'XYZ789', '2HGFG1B50JH537947'),
(3, 'Ford', 'F-150', 2020, 'LMN456', '1FTEW1C52LFA12345');

-- Insert sample data into the Appointments table
INSERT INTO [Appointments] ([vehicle_id], [appt_date], [memo])
VALUES 
(1, '2024-11-10', 'Dent repair on rear door'),
(2, '2024-11-12', 'Paintless dent repair for fender'),
(3, '2024-11-15', 'Fix dent on tailgate');

-- Insert sample data into the Repairs table
INSERT INTO [Repairs] ([appt_id], [quoted_price], [estimated_hours], [actual_hours])
VALUES 
(1, 300.00, 3.00, 2.50),
(2, 150.00, 2.00, 1.75),
(3, 500.00, 5.00, 4.50);

-- Insert sample data into the Invoices table
INSERT INTO [Invoices] ([repair_id], [quoted_price], [payment_date], [invoice_date])
VALUES 
(1, 300.00, '2024-11-15', '2024-11-10'),
(2, 150.00, '2024-11-16', '2024-11-12'),
(3, 500.00, '2024-11-18', '2024-11-15');

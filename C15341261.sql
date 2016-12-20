/*
	Student Number: C15341261
	Student Name: Robert Vaughan
	Programme Code: DT228
	Lab Group: E
*/

/*
  Dropping of tables
*/
DROP TABLE nonPrescribeSale_Product;
DROP TABLE nonPrescribeSale;
DROP TABLE packSize_Product;
DROP TABLE packSize;
DROP TABLE Prescription_Product;
DROP TABLE Product;
DROP TABLE drugType;
DROP TABLE Supplier;
DROP TABLE Brand;
DROP TABLE Prescription;
DROP TABLE Staff;
DROP TABLE Role;
DROP TABLE Customer;
DROP TABLE Doctor;
DROP TABLE Surgery;

/*
  Table to track pack sizes of each product
*/

CREATE TABLE packSize
(
	packSizeID           NUMBER(6) NOT NULL ,
	packSizeDesc         VARCHAR2(50) NOT NULL ,
	
	CONSTRAINT packSize_pk PRIMARY KEY (packSizeID)
);

/*
  Table that tracks the brands 
*/

CREATE TABLE Brand
(
	brandID              NUMBER(6) NOT NULL ,
	brandName            VARCHAR2(30) NOT NULL ,
	
	CONSTRAINT Brand_pk PRIMARY KEY (brandID)
);

/*
  Table that keeps track of suppliers
*/

CREATE TABLE Supplier
(
	supplierID           NUMBER(6) NOT NULL ,
	supplierDesc         VARCHAR2(50) NOT NULL ,
	
	CONSTRAINT Supplier_pk PRIMARY KEY (supplierID)
);

/*
  Table that stores unique drug types with their name as the
  Primary Key
*/

CREATE TABLE drugType
(
	drugTypeName         VARCHAR2(50) NOT NULL ,
	dosage               VARCHAR2(30) NULL ,
	prescribe            VARCHAR2(1) NOT NULL ,
	dispenseInstruct     VARCHAR2(100) NOT NULL ,
	custInstruct         VARCHAR2(100) NOT NULL ,

	CONSTRAINT drugType_pk PRIMARY KEY (drugTypeName)
);

/*
  Table that stores all products within the pharmacy with an ID
*/

CREATE TABLE Product
(
	productID            NUMBER(6) NOT NULL ,
	productDesc          VARCHAR2(50) NOT NULL ,
	prodCost             NUMBER(5,2) NOT NULL ,
	branchID             NUMBER(6) NULL ,
	prodRetail           NUMBER(5,2) NOT NULL ,
	brandID              NUMBER(6) NULL ,
	supplierID           NUMBER(6) NULL ,
	drugTypeName         VARCHAR2(50) NULL ,
	
	CONSTRAINT  Product_pk PRIMARY KEY (productID),
	
	CONSTRAINT Product_Brand_fk FOREIGN KEY (brandID) REFERENCES Brand (brandID),
	CONSTRAINT Product_Supplier_fk FOREIGN KEY (supplierID) REFERENCES Supplier (supplierID),
	CONSTRAINT Product_drugType_fk FOREIGN KEY (drugTypeName) REFERENCES drugType (drugTypeName)
);

/*
  A table that allows many products to have many pack sizes
  and a pack size to be assoicated with many products
*/

CREATE TABLE packSize_Product
(
	packSizeID           NUMBER(6) NOT NULL ,
	productID            NUMBER(6) NOT NULL ,
	
	CONSTRAINT  packSize_Product_pk PRIMARY KEY (packSizeID,productID),
	CONSTRAINT pack_Product_packSize_fk FOREIGN KEY (packSizeID) REFERENCES packSize (packSizeID),
	CONSTRAINT pack_Product_Product_fk FOREIGN KEY (productID) REFERENCES Product (productID)
);

/*
  Table that keeps track of doctors surgeries
*/

CREATE TABLE Surgery
(
	surgeryID            VARCHAR2(6) NOT NULL ,
	surgeryAddress       VARCHAR2(100) NOT NULL ,
	
	CONSTRAINT Surgery_pk PRIMARY KEY (surgeryID)
);

/*
  Table that logs all doctors and their details
*/

CREATE TABLE Doctor
(
	doctorID             NUMBER(6) NOT NULL ,
	doctorName           VARCHAR2(50) NOT NULL ,
	doctorEmail          VARCHAR2(30) NOT NULL ,
	doctorPhone          VARCHAR2(20) NOT NULL ,
	surgeryID            VARCHAR2(6) NULL ,
	
	CONSTRAINT Doctor_pk PRIMARY KEY (doctorID),
	CONSTRAINT Doctor_Surgery_fk FOREIGN KEY (surgeryID) REFERENCES Surgery (surgeryID),
	
	CONSTRAINT doctorEmail_chk CHECK (doctorEmail LIKE '%@%')
);

/*
  Table that stores all customer information
*/

CREATE TABLE Customer
(
	custID               NUMBER(6) NOT NULL ,
	custName             VARCHAR2(50) NOT NULL ,
	custAddress          VARCHAR2(100) NOT NULL ,
	custEmail            VARCHAR2(50) NOT NULL ,
	medCardNum           VARCHAR2(10) NULL ,
	custPhone            VARCHAR2(20) NOT NULL ,
	
	CONSTRAINT Customer_pk PRIMARY KEY (custID),
	
	CONSTRAINT custEmail_chk CHECK (custEmail LIKE '%@%')
);

/*
  A table that hosts the different roles an employee may have
*/

CREATE TABLE Role
(
	roleID               NUMBER(6) NOT NULL ,
	roleDesc             VARCHAR2(50) NOT NULL ,
	
	CONSTRAINT Role_pk PRIMARY KEY (roleID)
);

/*
  A table that stores all staff information with an ID
  One could have used PPS as the PK but staff may complain
*/

CREATE TABLE Staff
(
	staffID              NUMBER(6) NOT NULL ,
	staffName            VARCHAR2(50) NOT NULL ,
	staffAddress         VARCHAR2(100) NOT NULL ,
	staffPhone           VARCHAR2(20) NOT NULL ,
	staffEmail           VARCHAR2(50) NOT NULL ,
	staffPPS             VARCHAR2(9) NOT NULL ,
	roleID               NUMBER(6) NULL ,
	
	CONSTRAINT Staff_pk PRIMARY KEY (staffID),
	CONSTRAINT Staff_Role_fk FOREIGN KEY (roleID) REFERENCES Role (roleID),
	
	CONSTRAINT staffEmail_chk CHECK (staffEmail LIKE '%@%')
);

/*
  Table that hosts a perscriptions details and it's information when related
  to a sale
*/

CREATE TABLE Prescription
(
	prescriptionID       NUMBER(6) NOT NULL ,
	saleDateTime         DATE NULL ,
	payCheck             VARCHAR2(1) NULL ,
	creditCheck          CHAR(18) NULL ,
	doctorID             NUMBER(6) NULL ,
	custID               NUMBER(6) NULL ,
	desStaffID           NUMBER(6) NULL ,
	saleStaffID          NUMBER(6) NULL ,
	
	CONSTRAINT Prescription_pk PRIMARY KEY (prescriptionID),
	CONSTRAINT Pres_Doctor_fk FOREIGN KEY (doctorID) REFERENCES Doctor (doctorID),
	CONSTRAINT Pres_Customer_fk FOREIGN KEY (custID) REFERENCES Customer (custID),
	CONSTRAINT Pres_Staff_fk FOREIGN KEY (desStaffID) REFERENCES Staff (staffID),
	CONSTRAINT Pres_Staff_Des_fk FOREIGN KEY (saleStaffID) REFERENCES Staff (staffID)
);

/*
  Table that allows many prescriptions to have many products
  and many products to be apart of a prescription
*/

CREATE TABLE Prescription_Product
(
	prescriptionID       NUMBER(6) NOT NULL ,
	productID            NUMBER(6) NOT NULL ,
	dosage               VARCHAR2(20) NULL ,
	numOfDays            NUMBER(2) NOT NULL ,
	
	CONSTRAINT Pres_Product_pk PRIMARY KEY (prescriptionID,productID),
	CONSTRAINT Pres_Prod_Pres_fk FOREIGN KEY (prescriptionID) REFERENCES Prescription (prescriptionID),
	CONSTRAINT Pres_Prod_Product_fk FOREIGN KEY (productID) REFERENCES Product (productID)
);

/*
  Table that tracks a non-prescription based sale
*/

CREATE TABLE nonPrescribeSale
(
	saleID               NUMBER(6) NOT NULL ,
	saleDateTime         DATE NOT NULL ,
	creditSale           VARCHAR2(1) NOT NULL ,
	staffID              NUMBER(6) NULL ,
	
	CONSTRAINT nonPrescribeSale_pk PRIMARY KEY (saleID),
	CONSTRAINT nonPresSale_Staff_fk FOREIGN KEY (staffID) REFERENCES Staff (staffID)
);

/*
  Table that allows a sale to have many products and a product to be apart 
  of many sales
*/

CREATE TABLE nonPrescribeSale_Product
(
	productID            NUMBER(6) NOT NULL ,
	saleID               NUMBER(6) NOT NULL ,
	amount               NUMBER(2) NOT NULL ,
	
	CONSTRAINT nonPres_Prod_pk PRIMARY KEY (productID,saleID,amount),
	CONSTRAINT nonPresSale_Prod_Product_fk FOREIGN KEY (productID) REFERENCES Product (productID),
	CONSTRAINT nonPres_Prod_nonPresSale_fk FOREIGN KEY (saleID) REFERENCES nonPrescribeSale (saleID)
);

--Instering Pack Size Information
INSERT INTO packSize(packSizeID, packSizeDesc) VALUES(1, '1');
INSERT INTO packSize(packSizeID, packSizeDesc) VALUES(2, '2');
INSERT INTO packSize(packSizeID, packSizeDesc) VALUES(3, '3');
INSERT INTO packSize(packSizeID, packSizeDesc) VALUES(4, '4');
INSERT INTO packSize(packSizeID, packSizeDesc) VALUES(5, '5');
INSERT INTO packSize(packSizeID, packSizeDesc) VALUES(6, '6');
INSERT INTO packSize(packSizeID, packSizeDesc) VALUES(16, '16');

--Inserting Brand information
INSERT INTO Brand(brandID, brandName) VALUES(1, 'Panadol');
INSERT INTO Brand(brandID, brandName) VALUES(2, 'Tamoxifen');
INSERT INTO Brand(brandID, brandName) VALUES(3, 'Ketalar');
INSERT INTO Brand(brandID, brandName) VALUES(4, 'Ventavis');
INSERT INTO Brand(brandID, brandName) VALUES(5, 'Lynx');
INSERT INTO Brand(brandID, brandName) VALUES(6, 'Gillette');
INSERT INTO Brand(brandID, brandName) VALUES(7, 'Colgate');

--Inserting supplier information
INSERT INTO Supplier(supplierID, supplierDesc) VALUES(1, 'DrugInc');
INSERT INTO Supplier(supplierID, supplierDesc) VALUES(2, 'Happy Supplies');
INSERT INTO Supplier(supplierID, supplierDesc) VALUES(3, 'Restore Suppliers');
INSERT INTO Supplier(supplierID, supplierDesc) VALUES(4, 'URCare');
INSERT INTO Supplier(supplierID, supplierDesc) VALUES(5, 'Life Line');
INSERT INTO Supplier(supplierID, supplierDesc) VALUES(6, 'Simple Care');

--Inserting drug type information
INSERT INTO drugType(drugTypeName, dosage, prescribe, dispenseInstruct, custInstruct) VALUES('Paracetamol', '1 g', 'B', 'Place in sealed bag', 'ID customers');
INSERT INTO drugType(drugTypeName, dosage, prescribe, dispenseInstruct, custInstruct) VALUES('Ritalin', '30 mg', 'Y', 'Seal in tube', 'Advise customers when to take');
INSERT INTO drugType(drugTypeName, dosage, prescribe, dispenseInstruct, custInstruct) VALUES('Alprazolam', '4 mg', 'Y', 'Seal in tube', 'Warn customers of effects');
INSERT INTO drugType(drugTypeName, dosage, prescribe, dispenseInstruct, custInstruct) VALUES('THC', '1 g', 'Y', 'Seal in tube', 'Warn customers of effects');

--Inserting Product information
INSERT INTO Product(productID, productDesc, prodCost, prodRetail, brandID, supplierID, drugTypeName) VALUES(1, 'Super Panadol', 32.50, 42.50, 1, 1, 'Paracetamol');
INSERT INTO Product(productID, productDesc, prodCost, prodRetail, brandID, supplierID, drugTypeName) VALUES(2, 'Xanax', 43, 52.50, 2, 5, 'Alprazolam');
INSERT INTO Product(productID, productDesc, prodCost, prodRetail, brandID, supplierID, drugTypeName) VALUES(3, 'Attention Help', 12.50, 16.50, 3, 5, 'Ritalin');
INSERT INTO Product(productID, productDesc, prodCost, prodRetail, brandID, supplierID, drugTypeName) VALUES(4, 'Weak Panadol', 12.50, 16.50, 1, 2, 'Paracetamol');
INSERT INTO Product(productID, productDesc, prodCost, prodRetail, brandID, supplierID, drugTypeName) VALUES(5, 'Loose Goose', 20.05, 40.35, 3, 4, 'THC');
INSERT INTO Product(productID, productDesc, prodCost, prodRetail, brandID, supplierID) VALUES(6, 'Body Spray', 12.50, 16.50, 5, 4);
INSERT INTO Product(productID, productDesc, prodCost, prodRetail, brandID, supplierID) VALUES(7, 'Razors', 3.25, 5.00, 6, 6);
INSERT INTO Product(productID, productDesc, prodCost, prodRetail, brandID, supplierID) VALUES(8, 'Toothpaste', 1.25, 5.00, 7, 6);
INSERT INTO Product(productID, productDesc, prodCost, prodRetail, brandID, supplierID) VALUES(9, 'Superpaste', 2.00, 6.00, 7, 6);

--Inserting pack size to product information
INSERT INTO packSize_Product(packSizeID, productID) VALUES(16, 1);
INSERT INTO packSize_Product(packSizeID, productID) VALUES(5, 2);
INSERT INTO packSize_Product(packSizeID, productID) VALUES(4, 4);
INSERT INTO packSize_Product(packSizeID, productID) VALUES(1, 5);
INSERT INTO packSize_Product(packSizeID, productID) VALUES(16, 3);
INSERT INTO packSize_Product(packSizeID, productID) VALUES(1, 6);
INSERT INTO packSize_Product(packSizeID, productID) VALUES(1, 7);
INSERT INTO packSize_Product(packSizeID, productID) VALUES(1, 8);

--Inserting surgery information
INSERT INTO Surgery(surgeryID, surgeryAddress) VALUES(1,'5 Strand Street, Skerries, Dublin');
INSERT INTO Surgery(surgeryID, surgeryAddress) VALUES(2,'4, Holy Street, Rush, Dublin');
INSERT INTO Surgery(surgeryID, surgeryAddress) VALUES(3,'19, St. Matthews St, Lusk, Dublin');
INSERT INTO Surgery(surgeryID, surgeryAddress) VALUES(4,'30, Town Center, Balbriggan, Dublin');
INSERT INTO Surgery(surgeryID, surgeryAddress) VALUES(5,'5, Sea Street, Hoth, Dublin');

--Inserting Doctor information
INSERT INTO Doctor(doctorID, doctorName, doctorEmail, doctorPhone, surgeryID) VALUES(0, 'Dr. Bryan Duggan', 'bduggan@gamil.com', '0869999999', 1);
INSERT INTO Doctor(doctorID, doctorName, doctorEmail, doctorPhone, surgeryID) VALUES(1, 'Dr. Scott Man', 'sman@gamil.com', '0868888888', 1);
INSERT INTO Doctor(doctorID, doctorName, doctorEmail, doctorPhone, surgeryID) VALUES(2, 'Dr. Richard Stallman', 'rstallman@gamil.com', '0867777777', 4);
INSERT INTO Doctor(doctorID, doctorName, doctorEmail, doctorPhone, surgeryID) VALUES(3, 'Dr. Steve Jobs', 'sjobs@gamil.com', '0', 5);
INSERT INTO Doctor(doctorID, doctorName, doctorEmail, doctorPhone, surgeryID) VALUES(4, 'Dr. Paddy Power', 'ppower@gamil.com', '0865555555', 5);

--Inserting Customer information
INSERT INTO Customer(custID, custName, custAddress, custEmail, medCardNum, custPhone) VALUES (1, 'John Player', '9 Lane Drive, Lusk, Dublin', 'jplayer@gmail.com', NULL, '0859994455');
INSERT INTO Customer(custID, custName, custAddress, custEmail, medCardNum, custPhone) VALUES (2, 'Mary Lynn', '18 Silver Heights, Lusk, Dublin', '@mlynngmail.com', NULL,'0844567891');
INSERT INTO Customer(custID, custName, custAddress, custEmail, medCardNum, custPhone) VALUES (3, 'Steve Martin', '4 Strand Street, Skerries, Dublin', 'smartain@gmail.com', '123456','084456444');
INSERT INTO Customer(custID, custName, custAddress, custEmail, medCardNum, custPhone) VALUES (4, 'David Smith', '4 Church Street, Skerries, Dublin', 'dsmith@gmail.com', '645123','084411122');
INSERT INTO Customer(custID, custName, custAddress, custEmail, medCardNum, custPhone) VALUES (5, 'John Smith', '4 Mary Lane, Skerries, Dublin', 'jsmith@gmail.com', '465145','0854456331');
INSERT INTO Customer(custID, custName, custAddress, custEmail, medCardNum, custPhone) VALUES (6, 'John Smith', '4 Mary Lane, Skerries, Dublin', 'jsmith@gmail.com', '465145','0854456331');

--Inserting Role information
INSERT INTO Role(roleID, roleDesc) VALUES(0, 'Despencer');
INSERT INTO Role(roleID, roleDesc) VALUES(1, 'Cashier');
INSERT INTO Role(roleID, roleDesc) VALUES(2, 'Accountant');
INSERT INTO Role(roleID, roleDesc) VALUES(3, 'Inventory Manager');
INSERT INTO Role(roleID, roleDesc) VALUES(4, 'IT');

--Inserting Staff information
INSERT INTO Staff(staffID, staffName, staffAddress, staffPhone, staffEmail, staffPPS, roleID) VALUES(1, 'George Pharm', '9 Strand Street, Skerries, Dublin', '0872349827', 'klies@gamil.com', '1234567E9', 0);
INSERT INTO Staff(staffID, staffName, staffAddress, staffPhone, staffEmail, staffPPS, roleID) VALUES(2, 'Kevin Lies', ', Skerries, Dublin', '087', 'klies@gamil.com', '1234567F9', 1);
INSERT INTO Staff(staffID, staffName, staffAddress, staffPhone, staffEmail, staffPPS, roleID) VALUES(3, 'George Brown', '1 Haven Heights, Balbriggan, Dublin', '0879872467', 'gbrown@gamil.com', '1234564A5', 2);
INSERT INTO Staff(staffID, staffName, staffAddress, staffPhone, staffEmail, staffPPS, roleID) VALUES(4, 'Ria Stubbs', '31 Kellys Bay Rocks, Skerries, Dublin', '0854445566', 'rstubbs@gamil.com', '1234975C1', 3);
INSERT INTO Staff(staffID, staffName, staffAddress, staffPhone, staffEmail, staffPPS, roleID) VALUES(5, 'Steve Shea', '5 Church Street, Skerries, Dublin', '0871234544', 'sshea@gamil.com', '3244567E9', 4);

--Inserting Prescription information
INSERT INTO Prescription (prescriptionID, saleDateTime, payCheck, creditCheck, doctorID, custID, desStaffID, saleStaffID) VALUES(1, NULL, NULL, NULL, 0, 3, 1, NULL);
INSERT INTO Prescription (prescriptionID, saleDateTime, payCheck, creditCheck, doctorID, custID, desStaffID, saleStaffID) VALUES(2, NULL, NULL, NULL, 2, 1, 1, NULL);
INSERT INTO Prescription (prescriptionID, saleDateTime, payCheck, creditCheck, doctorID, custID, desStaffID, saleStaffID) VALUES(3, NULL, NULL, NULL, 1, 4, 1, NULL);
INSERT INTO Prescription (prescriptionID, saleDateTime, payCheck, creditCheck, doctorID, custID, desStaffID, saleStaffID) VALUES(4, NULL, NULL, NULL, 3, 2, 1, NULL);
INSERT INTO Prescription (prescriptionID, saleDateTime, payCheck, creditCheck, doctorID, custID, desStaffID, saleStaffID) VALUES(5, NULL, NULL, NULL, 1, 5, 1, NULL);

--Inserting Prescription_Product information
INSERT INTO Prescription_Product(prescriptionID, productID, numOfDays) VALUES(1, 1, 30);
INSERT INTO Prescription_Product(prescriptionID, productID, dosage, numOfDays) VALUES(1, 2, '11 g', 30);
INSERT INTO Prescription_Product(prescriptionID, productID, dosage, numOfDays) VALUES(2, 2, '11 g', 30);
INSERT INTO Prescription_Product(prescriptionID, productID, dosage, numOfDays) VALUES(3, 3, '12 g', 30);
INSERT INTO Prescription_Product(prescriptionID, productID, dosage,numOfDays) VALUES(4, 4, '8 g', 30);
INSERT INTO Prescription_Product(prescriptionID, productID, dosage, numOfDays) VALUES(5, 5, '10 g', 20);

--Inserting information with regards to a sale that is not prescription based
INSERT INTO nonPrescribeSale(saleID, saleDateTime, creditSale, staffID) VALUES(1, TO_DATE('2016/05/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 'N', 2);
INSERT INTO nonPrescribeSale(saleID, saleDateTime, creditSale, staffID) VALUES(2, TO_DATE('2016/06/02 15:46:19', 'yyyy/mm/dd hh24:mi:ss'), 'N', 2);
INSERT INTO nonPrescribeSale(saleID, saleDateTime, creditSale, staffID) VALUES(3, TO_DATE('2016/06/02 17:06:02', 'yyyy/mm/dd hh24:mi:ss'), 'N', 2);
INSERT INTO nonPrescribeSale(saleID, saleDateTime, creditSale, staffID) VALUES(4, TO_DATE('2016/06/04 12:12:46', 'yyyy/mm/dd hh24:mi:ss'), 'Y', 2);
INSERT INTO nonPrescribeSale(saleID, saleDateTime, creditSale, staffID) VALUES(5, TO_DATE('2016/06/07 11:10:24', 'yyyy/mm/dd hh24:mi:ss'), 'N', 2);

--Inserting the number of products in each sale
INSERT INTO nonPrescribeSale_Product(saleID, productID, amount) VALUES(1, 7, 1);
INSERT INTO nonPrescribeSale_Product(saleID, productID, amount) VALUES(2, 7, 1);
INSERT INTO nonPrescribeSale_Product(saleID, productID, amount) VALUES(3, 6, 1);
INSERT INTO nonPrescribeSale_Product(saleID, productID, amount) VALUES(4, 6, 1);
INSERT INTO nonPrescribeSale_Product(saleID, productID, amount) VALUES(4, 8, 2);
INSERT INTO nonPrescribeSale_Product(saleID, productID, amount) VALUES(5, 6, 1);

/*
  Takes a product from a prescription and gets the number of days that one must take each drug
*/

SELECT saleID AS "Non-Prescribe Sale ID", productDesc AS "Product", UPPER(brandName) AS "Brand"
FROM nonPrescribeSale_Product
INNER JOIN Product
USING (productID)
INNER JOIN Brand
USING (brandID)
ORDER BY saleID ASC;

/*
  Query that displays each brand and shows what how much their highest profit is on a product
*/

SELECT brandName AS "Brand", TO_CHAR(MAX(prodRetail - prodCost), 'fmU9990.00') AS "Highest Product Markup"
FROM Brand
INNER JOIN Product
USING (brandID)
GROUP BY brandName;

/*
  A query that will get the number of prescriptions a doctor has
*/

SELECT doctorName AS "Doctor", COUNT(prescriptionID) AS "Number Prescriptions"
FROM Prescription
INNER JOIN Doctor
USING (doctorID)
GROUP BY doctorName
HAVING COUNT(prescriptionID) >= 0;

/*
	All prodcuts with their with their drug types, brand name, whether they are prescribeable their dtug type
	A case is used to check for whether they are prescribale or not. NVL returns a message whether it is NULL
	or not. LEFT join is used so the drug type is shown whether or not the drug name is NULL
*/

SELECT productDesc AS "Name", NVL(Product.drugTypeName,'Not a drug') AS "Drug Type", brandName AS "Brand", 
CASE drugType.prescribe 
  WHEN 'Y' THEN 'YES' 
  WHEN 'N' THEN 'NO' 
  WHEN 'B' THEN 'Dependent on quantity' 
  ELSE 'Not a drug' 
END AS "Prescribe?"
FROM Product
LEFT JOIN drugType 
ON Product.drugTypeName=drugType.drugTypeName
INNER JOIN Brand
USING (brandID);

/*
	A RIGHT OUTTER JOIN that displays the name of a doctor and all their patients by
  alphebetical order
*/

SELECT doctorName AS "Doctor", custName AS "Patients"
FROM Prescription
INNER JOIN Customer
ON PRESCRIPTION.custID = Customer.custID
LEFT OUTER JOIN Doctor
ON Prescription.DOCTORID = Doctor.DOCTORID
ORDER BY doctorName ASC;

/*
  A DELETE with a sub-query that deletes any doctors on the system that do not
  have a perscription
*/

DELETE FROM Doctor
WHERE doctorID NOT IN
(
  SELECT doctorID
  FROM Prescription
);

/*
Updates the prescription table so items are 
*/

UPDATE Prescription
SET saleDateTime = SYSDATE, payCheck = 'Y', creditCheck = 'N', saleStaffID = 2;

SELECT * FROM Prescription;


/*
	Adds a payTier column
*/

ALTER TABLE Staff 
ADD (payTier VARCHAR(8));

/*
	Modifies the new column
*/

ALTER TABLE Staff
MODIFY (payTier NUMBER(8,2));

UPDATE Staff 
SET payTier = 67595.00 
WHERE staffID = 1;

UPDATE Staff 
SET payTier = 40000.00 
WHERE staffID = 2;

--Modifying column by adding a contraint
ALTER TABLE Staff
ADD CONSTRAINT payTier_chk CHECK (payTier > 10000);

/*
	Displays contraints of the table
*/

SELECT * 
FROM user_cons_columns
WHERE table_name = 'STAFF';

SELECT * FROM Staff;

/*
	Staff memebers with those ids are giveen a default wage
*/

UPDATE Staff 
SET payTier = '40000.00' 
WHERE staffID >= 2 AND staffID <= (SELECT COUNT(*) FROM Staff);

SELECT staffName AS "Staff Name", TO_CHAR(payTier, 'fmU999990.00') AS "Pay" 
FROM Staff;

/*
VIOLATION CHECK

UPDATE Staff 
SET payTier = 5000.00 
WHERE staffID = 3;
*/

/*
	Drops the contraint that checks and employee recieves above
	a certain wage
*/

ALTER TABLE Staff
DROP CONSTRAINT payTier_chk;

/*
	Displays contraints of the table
*/

SELECT * 
FROM user_cons_columns
WHERE table_name = 'STAFF';

COMMIT;
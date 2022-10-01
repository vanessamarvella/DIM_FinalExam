CREATE DATABASE FinalExamDIM

USE FinalExamDIM

CREATE TABLE SalesRep(
SalesRepNo CHAR (5) PRIMARY KEY,
SalesRepName VARCHAR(255) NOT NULL,

CONSTRAINT check_SalesRepNo CHECK(SalesRepNo LIKE 'SR[0-9][0-9][0-9]'),
CONSTRAINT check_SalesRepName CHECK(LEN(SalesRepName) > 3)
) 

CREATE TABLE Customer(
CustNo CHAR(5) PRIMARY KEY,
SalesRepNo CHAR(5) NOT NULL,
[Name] VARCHAR(255) NOT NULL,
PhoneNo CHAR(12) NOT NULL,
Email VARCHAR(255) NOT NULL,

FOREIGN KEY (SalesRepNo) REFERENCES SalesRep ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT check_CustNo CHECK(CustNo LIKE 'CS[0-9][0-9][0-9]'),
CONSTRAINT check_CustomerName CHECK(LEN([Name]) > 5),
CONSTRAINT check_CustomerEmail CHECK (Email LIKE '%@gmail.com')
)

CREATE TABLE Store(
StoreID CHAR(5) PRIMARY KEY,
StoreLocation VARCHAR(255) NOT NULL,

CONSTRAINT check_StoreID CHECK(StoreID LIKE 'ST[0-9][0-9][0-9]'),
CONSTRAINT check_StoreLocation CHECK(LEN(StoreLocation) > 3)
)

CREATE TABLE Purchase(
PurchaseID CHAR(5) PRIMARY KEY,
StoreID CHAR(5) NOT NULL,
CustNo CHAR(5) NOT NULL,
[Date] DATE NOT NULL,

FOREIGN KEY (StoreID) REFERENCES Store ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (CustNo) REFERENCES Customer ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT check_PurchaseID CHECK(PurchaseID LIKE 'PR[0-9][0-9][0-9]')
)

CREATE TABLE Category(
CategoryID CHAR(5) PRIMARY KEY,
CategoryName VARCHAR(255) NOT NULL,
CategoryType VARCHAR(255) NOT NULL,
CategoryDescription VARCHAR(255) NOT NULL,

CONSTRAINT check_CategoryID CHECK(CategoryID LIKE 'CT[0-9][0-9][0-9]'),
CONSTRAINT check_CategoryName CHECK(LEN(CategoryName) > 3)
)

CREATE TABLE Item(
ItemID CHAR(5) PRIMARY KEY,
CategoryID CHAR(5) NOT NULL,
ItemName VARCHAR(255) NOT NULL,
Size INT NOT NULL,
Price INT NOT NULL,

FOREIGN KEY (CategoryID) REFERENCES Category ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT check_ItemID CHECK(ItemID LIKE 'IT[0-9][0-9][0-9]'),
CONSTRAINT check_ItemName CHECK(LEN(ItemName) > 3)
)

CREATE TABLE PurchaseDetail (
PurchaseID CHAR(5),
ItemID CHAR(5),
Quantity INT NOT NULL,

PRIMARY KEY (PurchaseID, ItemID),
FOREIGN KEY (PurchaseID) REFERENCES Purchase ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (ItemID) REFERENCES Item ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT check_Quantity CHECK(Quantity > 0)
)

CREATE TABLE Warehouse (
WarehouseID CHAR(5) PRIMARY KEY,
WarehouseAddress VARCHAR(255) NOT NULL,
WarehouseCity VARCHAR(255) NOT NULL,

CONSTRAINT check_WarehouseID CHECK(WarehouseID LIKE 'WR[0-9][0-9][0-9]'),
)

CREATE TABLE Inventory(
ItemID CHAR(5),
WarehouseID CHAR(5),
CostOfUnit INT NOT NULL,
UnitsOnHand INT NOT NULL,

PRIMARY KEY (ItemID, WarehouseID),
FOREIGN KEY (ItemID) REFERENCES Item ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (WarehouseID) REFERENCES Warehouse ON UPDATE CASCADE ON DELETE CASCADE
)


INSERT INTO SalesRep VALUES
('SR001', 'Jeremy'),
('SR002', 'Reynaldo'),
('SR003', 'Christina')


INSERT INTO Customer VALUES
('CS001', 'SR002', 'Vanessa', '081288776537', 'blue@gmail.com'),
('CS002', 'SR001', 'Michelle', '081388758811', 'yellow@gmail.com'),
('CS003', 'SR003', 'Nathanael', '081256348374', 'green@gmail.com')


INSERT INTO Store VALUES
('ST001', 'Jakarta'),
('ST002', 'Bandung'),
('ST003', 'Tangerang')

INSERT INTO Purchase VALUES 
('PR001', 'ST003', 'CS001', '2021-06-01'),
('PR002', 'ST001', 'CS003', '2021-05-24'),
('PR003', 'ST002', 'CS002', '2021-04-16')


INSERT INTO Category VALUES
('CT001', 'Sepatu sekolah', 'Skets', 'Sepatu khusus untuk sekolah'),
('CT002', 'Sepatu kerja', 'Pantofel', 'Sepatu khusus untuk kerja'),
('CT003', 'Sepatu musim dingin', 'Boots', 'Sepatu khusus untuk musim dingin')

INSERT INTO Item VALUES
('IT001', 'CT002', 'Kerry Pantofel', 39, 500000),
('IT002', 'CT003', 'Reddy Boots', 41, 950000),
('IT003', 'CT001', 'Skechers', 40, 730000)

INSERT INTO PurchaseDetail VALUES
('PR002', 'IT002', 3),
('PR001', 'IT003', 1),
('PR003', 'IT001', 5)

INSERT INTO Warehouse VALUES
('WR001', 'Happy Street', 'Jogja'),
('WR002', 'Sad Street', 'Malang'),
('WR003', 'Sesame Street', 'Papua')


INSERT INTO Inventory VALUES
('IT003', 'WR002', 300000, 50),
('IT002', 'WR001', 700000, 30),
('IT001', 'WR003', 500000, 15)

GO
CREATE VIEW Invoice AS
SELECT p.PurchaseID, p.ItemID, (i.Price * p.Quantity) AS [TotalPrice] FROM PurchaseDetail p JOIN Item i ON i.ItemID = p.ItemID
GO

CONSTRAINT CheckSalesRepOnCust
CHECK(NOT EXISTS(
	SELECT CustNo, COUNT(CustNo) AS [Number Of Customer], s.SalesRepNo FROM Customer c JOIN SalesRep s ON c.SalesRepNo = s.SalesRepNo
	GROUP BY s.SalesRepNo, CustNo
	HAVING COUNT (CustNo) > 0
))

CONSTRAINT CheckSalesRepOnCustomer
CHECK(NOT EXISTS(
	SELECT COUNT(CustNo) AS [Number Of Customer], s.SalesRepNo FROM Customer c JOIN SalesRep s ON c.SalesRepNo = s.SalesRepNo
	GROUP BY s.SalesRepNo
	HAVING COUNT (CustNo) > 55
))
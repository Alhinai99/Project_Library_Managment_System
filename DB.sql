-- Database Implementation for Library Management System

-- DROP existing tables if they exist
DROP TABLE IF EXISTS Reviews, Payments, Loans, Books, Members, Staff, Library;

-- Create Library table
CREATE TABLE Library (
    ID INT IDENTITY PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL,
    EstablishYear INT CHECK (EstablishYear > 1800)
);

-- Create Staff table
CREATE TABLE Staff (
    ID INT IDENTITY PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    LibraryID INT NOT NULL,
    FOREIGN KEY (LibraryID) REFERENCES Library(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create Members table
CREATE TABLE Members (
    ID INT IDENTITY PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    MembershipDateStart DATE NOT NULL
);

-- Create Books table
CREATE TABLE Books (
    ID INT IDENTITY PRIMARY KEY,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Title VARCHAR(200) NOT NULL,
    Genre VARCHAR(50) CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')),
    Price DECIMAL(8,2) CHECK (Price > 0),
    ShelfLoc VARCHAR(20),
    Availability BIT DEFAULT 1
);

-- Create Loans table
CREATE TABLE Loans (
    ID INT IDENTITY PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    Status VARCHAR(20) DEFAULT 'Issued' CHECK (Status IN ('Issued', 'Returned', 'Overdue')),
    FOREIGN KEY (MemberID) REFERENCES Members(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create Payments table
CREATE TABLE Payments (
    ID INT IDENTITY PRIMARY KEY,
    LoanID INT NOT NULL,
    Amount DECIMAL(8,2) CHECK (Amount > 0),
    Method VARCHAR(30) NOT NULL,
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES Loans(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create Reviews table
CREATE TABLE Reviews (
    ID INT IDENTITY PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments VARCHAR(255) DEFAULT 'No comments',
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Insert Data

-- Libraries
INSERT INTO Library (Name, ContactNumber, EstablishYear) VALUES
('Central Library', '912345678', 1995),
('Eastside Library', '912345679', 2001),
('Westside Library', '912345680', 2010);

-- Staff
INSERT INTO Staff (FullName, ContactNumber, Position, LibraryID) VALUES
('Alice Ahmed', '912300001', 'Manager', 1),
('Bob Said', '912300002', 'Librarian', 1),
('Carol Nasser', '912300003', 'Assistant', 2),
('David Zayed', '912300004', 'Clerk', 3);

-- Members
INSERT INTO Members (FullName, Email, Phone, MembershipDateStart) VALUES
('Emma Stone', 'emma@example.com', '912400001', '2024-01-10'),
('Liam Ali', 'liam@example.com', '912400002', '2024-02-15'),
('Olivia Khan', 'olivia@example.com', '912400003', '2024-03-20'),
('Noah Omar', 'noah@example.com', '912400004', '2024-04-01'),
('Ava Salim', 'ava@example.com', '912400005', '2024-04-10'),
('Mason Tariq', 'mason@example.com', '912400006', '2024-05-01');

-- Books
INSERT INTO Books (ISBN, Title, Genre, Price, ShelfLoc) VALUES
('9781234567890', 'The Great Escape', 'Fiction', 15.50, 'A1'),
('9781234567891', 'Python Programming', 'Reference', 40.00, 'B1'),
('9781234567892', 'Children Stories', 'Children', 10.00, 'C2'),
('9781234567893', 'History of Oman', 'Non-fiction', 25.00, 'D3'),
('9781234567894', 'Math Essentials', 'Reference', 30.00, 'B2'),
('9781234567895', 'Science for Kids', 'Children', 20.00, 'C3'),
('9781234567896', 'Mystery Island', 'Fiction', 18.75, 'A2'),
('9781234567897', 'Biography of a Leader', 'Non-fiction', 22.00, 'D4'),
('9781234567898', 'Coding 101', 'Reference', 35.00, 'B4'),
('9781234567899', 'Fantasy World', 'Fiction', 19.99, 'A3');

-- Loans
INSERT INTO Loans (MemberID, BookID, LoanDate, DueDate, ReturnDate, Status) VALUES
(1, 1, '2024-05-01', '2024-05-15', NULL, 'Issued'),
(2, 2, '2024-05-02', '2024-05-16', '2024-05-10', 'Returned'),
(3, 3, '2024-05-03', '2024-05-17', NULL, 'Overdue'),
(4, 4, '2024-05-04', '2024-05-18', NULL, 'Issued'),
(5, 5, '2024-05-05', '2024-05-19', NULL, 'Issued'),
(6, 6, '2024-05-06', '2024-05-20', NULL, 'Issued'),
(1, 7, '2024-05-07', '2024-05-21', NULL, 'Issued'),
(2, 8, '2024-05-08', '2024-05-22', NULL, 'Issued'),
(3, 9, '2024-05-09', '2024-05-23', NULL, 'Issued'),
(4, 10, '2024-05-10', '2024-05-24', NULL, 'Issued');

-- Payments
INSERT INTO Payments (LoanID, Amount, Method, PaymentDate) VALUES
(2, 5.00, 'Cash', '2024-05-10'),
(3, 10.00, 'Credit Card', '2024-05-17'),
(5, 7.50, 'Debit Card', '2024-05-20'),
(6, 8.00, 'Online', '2024-05-21');

-- Reviews
INSERT INTO Reviews (MemberID, BookID, Rating, Comments, ReviewDate) VALUES
(1, 1, 5, 'Excellent read!', '2024-05-10'),
(2, 2, 4, 'Very helpful.', '2024-05-11'),
(3, 3, 3, 'Good for kids.', '2024-05-12'),
(4, 4, 2, 'Could be better.', '2024-05-13'),
(5, 5, 5, DEFAULT, '2024-05-14'),
(6, 6, 4, 'Nice illustrations.', '2024-05-15');

-- Simulate application behavior

-- Mark a book as returned
UPDATE Loans SET ReturnDate = '2024-05-16', Status = 'Returned' WHERE ID = 1;

-- Update a loan to Overdue
UPDATE Loans SET Status = 'Overdue' WHERE ID = 4;

-- Delete a review
DELETE FROM Reviews WHERE ID = 4;

-- Delete a payment
DELETE FROM Payments WHERE ID = 2;


-- SELECT statements to view data
SELECT * FROM Library;
SELECT * FROM Staff;
SELECT * FROM Members;
SELECT * FROM Books;
SELECT * FROM Loans;
SELECT * FROM Payments;
SELECT * FROM Reviews;
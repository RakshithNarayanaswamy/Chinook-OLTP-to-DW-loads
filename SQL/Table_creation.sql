
CREATE OR REPLACE TABLE CHINOOK_STAGE.Artist(
ArtistId INTEGER,
Name STRING(120),
Created_By STRING(100),
Created_Dt date
);


CREATE OR REPLACE TABLE CHINOOK_STAGE.Genre(
GenreId INTEGER,
Name STRING(120),
Created_By STRING(100),
Created_Dt date);


CREATE OR REPLACE TABLE CHINOOK_STAGE.Album(
AlbumId INTEGER,
Title STRING(160),
ArtistId INTEGER,
Created_By STRING(100),
Created_Dt DATE);


CREATE OR REPLACE TABLE Chinook_STAGE.Customer(
CustomerId INTEGER,
FirstName STRING(40) ,
LastName STRING(20) ,
Company STRING(80),
Address STRING(70),
City STRING(40),
State STRING(40),
Country STRING(40),
PostalCode STRING(10),
Phone STRING(24),
Fax STRING(24),
Email STRING(60),
SupportRepId INTEGER,
Created_By STRING(100),
Created_Dt DATE
);


CREATE OR REPLACE TABLE Chinook_STAGE.Invoice(
InvoiceId INTEGER ,
CustomerId INTEGER ,
InvoiceDate DATETIME ,
BillingAddress STRING(70),
BillingCity STRING(40),
BillingState STRING(40),
BillingCountry STRING(40),
BillingPostalCode STRING(10),
Total NUMBER(10, 2) ,
Created_By STRING(100),
Created_Dt DATE
);

CREATE OR REPLACE TABLE Chinook_STAGE.InvoiceLine(
InvoiceLineId INTEGER,
InvoiceId INTEGER ,
TrackId INTEGER ,
UnitPrice NUMBER(10, 2) ,
Quantity INTEGER ,
Created_By STRING(100),
Created_Dt DATE
);
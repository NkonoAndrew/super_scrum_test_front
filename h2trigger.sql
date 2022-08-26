-- db2 -td"@" -f h2trigger.sql

-- deny duplicate entry 
CREATE OR REPLACE TRIGGER h2_insert_name
BEFORE INSERT ON h2.customer
REFERENCING 
    NEW ROW as newRow 
FOR EACH ROW MODE DB2SQL
WHEN ( (SELECT COUNT(*)
              FROM h2.customer 
              WHERE h2.customer.ID = newrow.ID ) >= 1 ) 
BEGIN 
    DECLARE ID_count int;
    DECLARE prereq_pass int;

    SET ID_count = (SELECT COUNT(*)
                            FROM h2.customer 
                            WHERE h2.customer.ID = newrow.ID );

       IF ( ID_count >= 1 ) 
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Duplicate Customer ID';
       END IF;
END@

-- deny duplicate entry update
CREATE OR REPLACE TRIGGER h2_insert_nameupdate
BEFORE UPDATE OF ID ON h2.customer
REFERENCING 
    NEW ROW as newRow 
FOR EACH ROW MODE DB2SQL
WHEN ( (SELECT COUNT(*)
              FROM h2.customer 
              WHERE h2.customer.ID = newrow.ID ) >= 1 ) 
BEGIN 
    DECLARE ID_count int;
    DECLARE prereq_pass int;

    SET ID_count = (SELECT COUNT(*)
                            FROM h2.customer 
                            WHERE h2.customer.ID = newrow.ID );

       IF ( ID_count >= 1 ) 
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Duplicate Customer ID';
       END IF;
END@



-- Gender has to be M or F
CREATE OR REPLACE TRIGGER h2.andro
NO CASCADE BEFORE INSERT ON h2.customer
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Gender <> 'M' AND newRow.Gender <> 'F')
BEGIN 
    IF(newRow.Gender <> 'M' AND newRow.Gender <> 'F')
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Gender has to be M or F';
    END IF;   
END@

-- Gender has to be M or F Update 
CREATE OR REPLACE TRIGGER h2.androUpdate
NO CASCADE BEFORE UPDATE OF Gender ON h2.customer
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Gender <> 'M' AND newRow.Gender <> 'F')
BEGIN 
    IF(newRow.Gender <> 'M' AND newRow.Gender <> 'F')
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Gender has to be M or F';
    END IF;   
END@

-- ID cannot be null
CREATE OR REPLACE TRIGGER h2.not_null_id
NO CASCADE BEFORE INSERT ON h2.customer
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.ID IS  NULL) 
BEGIN 
    IF(newRow.ID IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'ID Cannot be NULL';
        SET newRow.ID = NOT NULL;
    END IF;   
END@

-- ID cannot be null Update
CREATE OR REPLACE TRIGGER h2.not_null_idUpdate
NO CASCADE BEFORE UPDATE OF ID ON h2.customer
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.ID IS  NULL) 
BEGIN 
    IF(newRow.ID IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'ID Cannot be NULL';
        SET newRow.ID = NOT NULL;
    END IF;   
END@


-- Name cannot be null
CREATE OR REPLACE TRIGGER h2.not_null_name
NO CASCADE BEFORE INSERT ON h2.customer
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Name IS  NULL) 
BEGIN 
    IF(newRow.Name IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Name Cannot be NULL';
        SET newRow.Name = NOT NULL;
    END IF;   
END@


-- Name cannot be null ON Update
CREATE OR REPLACE TRIGGER h2.not_null_nameUpdate
NO CASCADE BEFORE UPDATE OF Name ON h2.customer
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Name IS  NULL) 
BEGIN 
    IF(newRow.Name IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Name Cannot be NULL';
        SET newRow.Name = NOT NULL;
    END IF;   
END@

-- Gender cannot be null
CREATE OR REPLACE TRIGGER h2.not_null_gender
NO CASCADE BEFORE INSERT ON h2.customer
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Gender IS  NULL) 
BEGIN 
    IF(newRow.Gender IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Gender Cannot be NULL';
    END IF;   
END@

-- Gender cannot be nullUpdate
CREATE OR REPLACE TRIGGER h2.not_null_genderUpdate
NO CASCADE BEFORE UPDATE OF Gender ON h2.customer
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Gender IS  NULL) 
BEGIN 
    IF(newRow.Gender IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Gender Cannot be NULL';
    END IF;   
END@


-- BLOCK the parent row of DELETE or UPDATE if there is at least 1 child row which depends on it
CREATE OR REPLACE TRIGGER deleteofChildWith
BEFORE DELETE ON h2.customer
FOR EACH ROW MODE DB2SQL
WHEN ((SELECT count(h2.customer.ID)
        FROM h2.customer
        WHERE EXISTS
        (SELECT h2.account.cust_ID FROM h2.account WHERE h2.account.cust_ID = h2.customer.ID )) > 0) 
        
BEGIN 
        IF EXISTS (SELECT h2.customer.ID
                        FROM h2.customer
                        WHERE EXISTS
                        (SELECT h2.account.cust_ID FROM h2.account WHERE h2.account.cust_ID = h2.customer.ID  )) 
            THEN SIGNAL SQLSTATE '88888' 
            SET MESSAGE_TEXT = 'ID Belongs to Account';
       END IF;     
END@


------------------- account triggers -----------------------

-- Number Cannot be null
CREATE OR REPLACE TRIGGER accountNumberNotNull
NO CASCADE BEFORE INSERT ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Number IS  NULL) 
BEGIN 
    IF(newRow.Number IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Number Cannot be NULL';
        SET newRow.Number = NOT NULL;
    END IF;   
END@

-- Update Trigger Number cannot be null
CREATE OR REPLACE TRIGGER accountNumberNotNullUpdate
NO CASCADE BEFORE UPDATE OF Number ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Number IS  NULL) 
BEGIN 
    IF(newRow.Number IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Number Cannot be NULL';
        SET newRow.Number = NOT NULL;
    END IF;   
END@



-- cust_ID Cannot be null
CREATE OR REPLACE TRIGGER custIDNotNull
NO CASCADE BEFORE INSERT ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.cust_ID IS  NULL) 
BEGIN 
    IF(newRow.cust_ID IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'cust_ID Cannot be NULL';
        SET newRow.cust_ID = NOT NULL;
    END IF;   
END@

-- cust_ID Cannot be null Update
CREATE OR REPLACE TRIGGER custIDNotNullUpdate
NO CASCADE BEFORE UPDATE OF cust_ID ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.cust_ID IS  NULL) 
BEGIN 
    IF(newRow.cust_ID IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'cust_ID Cannot be NULL';
        SET newRow.cust_ID = NOT NULL;
    END IF;   
END@



-- Balance Cannot be null and default has to be 0 if null
CREATE OR REPLACE TRIGGER balanceNotNull
NO CASCADE BEFORE INSERT ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Balance IS  NULL) 
BEGIN 
    IF(newRow.Balance IS NULL)
        THEN SET newRow.Balance = 0;
    END IF;   
END@


-- Balance Cannot be null and default has to be 0 if null on Update
CREATE OR REPLACE TRIGGER balanceNotNullONUpdate
NO CASCADE BEFORE UPDATE OF Balance ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Balance IS  NULL) 
BEGIN 
    IF(newRow.Balance IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Balance Cannot be NULL so it was defaulted to 0';
        SET newRow.Balance = 0;
        
    END IF;   
END@


-- Type Cannot be null
CREATE OR REPLACE TRIGGER TypeNotNull
NO CASCADE BEFORE INSERT ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Type IS  NULL) 
BEGIN 
    IF(newRow.Type IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Type Cannot be NULL';
        SET newRow.Type = NOT NULL;
    END IF;   
END@

-- Type Cannot be null on Update
CREATE OR REPLACE TRIGGER TypeNotNullUpdate
NO CASCADE BEFORE UPDATE OF Type ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Type IS  NULL) 
BEGIN 
    IF(newRow.Type IS NULL)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Type Cannot be NULL';
        SET newRow.Type = NOT NULL;
    END IF;   
END@



-- Type has to be S or C
CREATE OR REPLACE TRIGGER typeIsSorC
NO CASCADE BEFORE INSERT ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Type <> 'S' AND newRow.Type <> 'C')
BEGIN 
    IF(newRow.Type <> 'S' AND newRow.Type <> 'C')
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Type has to be S or C';
    END IF;   
END@

-- Type has to be S or C on Update
CREATE OR REPLACE TRIGGER typeIsSorConUpdate
NO CASCADE BEFORE UPDATE OF Type ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN (newRow.Type <> 'S' AND newRow.Type <> 'C')
BEGIN 
    IF(newRow.Type <> 'S' AND newRow.Type <> 'C')
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Type has to be S or C';
    END IF;   
END@


-- cust_ID refferences h2.customer(ID)
CREATE OR REPLACE TRIGGER foreignKey
BEFORE INSERT ON h2.account
REFERENCING 
    NEW ROW as newrow
FOR EACH ROW MODE DB2SQL
WHEN ((SELECT COUNT(*)
              FROM h2.customer 
              WHERE h2.customer.ID = newrow.cust_ID ) = 0 ) 
BEGIN 
    DECLARE ID_count int;
    
    SET ID_count = (SELECT COUNT(*)
                            FROM h2.customer 
                            WHERE h2.customer.ID = newrow.cust_ID );

       IF ( ID_count = 0 ) 
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Customer does not exist';
       END IF;
END@

-- cust_ID refferences h2.customer(ID) ON Update
CREATE OR REPLACE TRIGGER foreignKeyUpdate
BEFORE UPDATE OF cust_ID ON h2.account
REFERENCING 
    NEW ROW as newrow
FOR EACH ROW MODE DB2SQL
WHEN ((SELECT COUNT(*)
              FROM h2.customer 
              WHERE h2.customer.ID = newrow.cust_ID ) = 0 ) 
BEGIN 
    DECLARE ID_count int;
    
    SET ID_count = (SELECT COUNT(*)
                            FROM h2.customer 
                            WHERE h2.customer.ID = newrow.cust_ID );

       IF ( ID_count = 0 ) 
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Customer does not exist';
       END IF;
END@

-- Creating trigger for checking duplicate key value h2.account
CREATE OR REPLACE TRIGGER accountNumberPrimary
BEFORE INSERT ON h2.account
REFERENCING NEW AS newrow  
FOR EACH ROW MODE DB2SQL
WHEN ((SELECT COUNT(*)
              FROM h2.account
              WHERE h2.account.Number = newrow.Number ) >= 1 ) 
BEGIN ATOMIC
       DECLARE Number_Count int;
    
       SET Number_Count = (SELECT COUNT(*)
                            FROM h2.account
                            WHERE h2.account.Number = newrow.Number );

       IF ( Number_Count >= 1 ) 
       THEN   SIGNAL SQLSTATE '88888' ( 'Duplicate Account Number' );
       END IF;
END@


-- Creating trigger for checking duplicate key value h2.account on Update
CREATE OR REPLACE TRIGGER accountNumberPrimaryUpdate
BEFORE UPDATE OF Number ON h2.account
REFERENCING NEW AS newrow  
FOR EACH ROW MODE DB2SQL
WHEN ((SELECT COUNT(*)
              FROM h2.account
              WHERE h2.account.Number = newrow.Number ) >= 1 ) 
BEGIN ATOMIC
       DECLARE Number_Count int;
    
       SET Number_Count = (SELECT COUNT(*)
                            FROM h2.account
                            WHERE h2.account.Number = newrow.Number );

       IF ( Number_Count >= 1 ) 
       THEN   SIGNAL SQLSTATE '88888' ( 'Duplicate Account Number' );
       END IF;
END@

-- Negative Balance
-- Allows an  initial overdraft if the balance is greater than 0 but subsequent over drafts are denied 
CREATE OR REPLACE TRIGGER NegativeBalance
NO CASCADE BEFORE INSERT ON h2.account
REFERENCING 
    NEW ROW AS newRow  
FOR EACH ROW MODE DB2SQL
WHEN ((SELECT SUM(Balance)
      FROM h2.account
      GROUP BY h2.account.cust_ID
      HAVING SUM(Balance) <= 0 AND h2.account.cust_ID = newRow.cust_ID) <= 0)
BEGIN 
    DECLARE Balance int;

    SET Balance = (SELECT SUM(Balance)
                    FROM h2.account
                    GROUP BY h2.account.cust_ID
                    HAVING SUM(Balance) <= 0 AND h2.account.cust_ID = newRow.cust_ID);

    IF(Balance <= 0)
        THEN SIGNAL SQLSTATE '88888' 
        SET MESSAGE_TEXT = 'Insufficient funds from other accounts to over draw your account';
    END IF;
 
END@

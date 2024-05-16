USE VL;
GO

CREATE TABLE containers (
	id uniqueidentifier NOT NULL,
	number int IDENTITY NOT NULL,
	type varchar(100) NULL,
	length float NULL,
	width float NULL,
	height float NULL,
	weight float NULL,
	filled bit NULL,
	receipt_date datetime NULL,
    CONSTRAINT PK_containers PRIMARY KEY (id)
)

CREATE TABLE operations (
	id uniqueidentifier NOT NULL,
	container_id uniqueidentifier NOT NULL,
	start_date datetime NULL,
	end_date datetime NULL,
	type varchar(100) NULL,
	operators_full_name varchar(200) NULL,
	inspection_place varchar(200) NULL,
    CONSTRAINT PK_operations PRIMARY KEY (id),
    CONSTRAINT FK_operations_container
        FOREIGN KEY(container_id) REFERENCES containers (id) 
        ON DELETE CASCADE
)

GO
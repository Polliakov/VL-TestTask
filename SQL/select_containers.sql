USE VL;
GO

CREATE OR ALTER PROCEDURE containers_json
AS
BEGIN
    DECLARE row_cursor CURSOR LOCAL FAST_FORWARD FOR 
    SELECT * FROM containers;
    OPEN row_cursor;

    DECLARE
        @id uniqueidentifier,
	    @number int,
	    @type varchar(100),
	    @length float,
	    @width float,
	    @height float,
	    @weight float,
	    @filled bit,
	    @receipt_date datetime;

    DECLARE @json NVARCHAR(MAX) = '[';
    WHILE 1=1
    BEGIN
        FETCH NEXT FROM row_cursor INTO 
            @id, @number, @type, @length,
	        @width, @height, @weight,
	        @filled, @receipt_date;

        IF @@FETCH_STATUS <> 0
            BREAK;

        SET @json += 
            '{"id":' + dbo.to_json_value(@id) + ',' +
            '"number":' + dbo.to_json_value(@number) + ',' +
            '"type":' + dbo.to_json_value(@type) + ',' +
            '"length":' + dbo.to_json_value(@length) + ',' +
            '"width":' + dbo.to_json_value(@width) + ',' +
            '"height":' + dbo.to_json_value(@height) + ',' +
            '"weight":' + dbo.to_json_value(@weight) + ',' +
            '"filled":' + dbo.to_json_value(@filled) + ',' +
            '"receipt_date":' + dbo.to_json_value(@receipt_date) + '},'
    END
    IF RIGHT(@json, 1) = ','
        SET @json = SUBSTRING(@json, 0, LEN(@json));
    SET @json += ']'

    CLOSE row_cursor;
    DEALLOCATE row_cursor;

    SELECT @json AS json_result;

END
GO

EXEC containers_json;

GO
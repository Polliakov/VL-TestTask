USE VL;
GO

CREATE OR ALTER PROCEDURE operations_by_container_json (@container_id_param uniqueidentifier)
AS
BEGIN
    DECLARE row_cursor CURSOR LOCAL FAST_FORWARD FOR 
    SELECT * FROM operations 
    WHERE container_id = @container_id_param;

    OPEN row_cursor;

    DECLARE
    @id uniqueidentifier,
	@container_id uniqueidentifier,
	@start_date datetime,
	@end_date datetime,
	@type varchar(100),
	@operators_full_name varchar(200),
	@inspection_place varchar(200);

    DECLARE @json NVARCHAR(MAX) = '[';
    WHILE 1=1
    BEGIN
        FETCH NEXT FROM row_cursor INTO 
        @id, @container_id, @start_date, @end_date,
        @type, @operators_full_name, @inspection_place;

        IF @@FETCH_STATUS <> 0
            BREAK;

        SET @json += 
            '{"id":' + dbo.to_json_value(@id) + ',' +
            '"container_id":' + dbo.to_json_value(@container_id) + ',' +
            '"start_date":' + dbo.to_json_value(@start_date) + ',' +
            '"end_date":' + dbo.to_json_value(@end_date) + ',' +
            '"type":' + dbo.to_json_value(@type) + ',' +
            '"operators_full_name":' + dbo.to_json_value(@operators_full_name) + ',' +
            '"inspection_place":' + dbo.to_json_value(@inspection_place) + '},'
    END
    IF RIGHT(@json, 1) = ','
        SET @json = SUBSTRING(@json, 0, LEN(@json));
    SET @json += ']';

    CLOSE row_cursor;
    DEALLOCATE row_cursor;

    SELECT @json AS json_result;
END
GO

DECLARE @param UNIQUEIDENTIFIER;
SELECT @param = FIRST_VALUE(id) OVER (ORDER BY id DESC) FROM containers;

EXEC operations_by_container_json @param;

GO
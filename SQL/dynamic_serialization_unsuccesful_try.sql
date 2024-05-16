/*
    Попытка реализовать динамическую сериализацию.
*/

USE VL;
GO

DECLARE @colums_metadata TABLE(
    column_name VARCHAR(128)
);

INSERT INTO @colums_metadata
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'containers';

DECLARE @iterator INT = 0;
DECLARE @count INT;
    SELECT @count = COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE table_name='containers';

DECLARE @values_declaration VARCHAR(1024) = '';
DECLARE @values VARCHAR(512) = '';
DECLARE @json_statement NVARCHAR(2048) = '''[{';

DECLARE column_names_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE table_name = 'containers';
OPEN column_names_cursor;

WHILE @iterator < @count
BEGIN
    DECLARE @val_decl VARCHAR(16) = CONCAT('@v', @iterator, ' sql_variant');
    DECLARE @val VARCHAR(8) = CONCAT('@v', @iterator);
    SET @values_declaration = CONCAT(@values_declaration, '@v', @iterator, ' sql_variant', ',');
    SET @values = CONCAT(@values, @val, ',');

    DECLARE @column_name VARCHAR(128);
    SELECT @column_name = column_name FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY (SELECT '1')) AS row_num, *
        FROM @colums_metadata) AS V 
    WHERE row_num = @iterator + 1; 

    SET @json_statement = 
        CONCAT(@json_statement, '"', @column_name, '": dbo.to_json_value(''', ' + ', @val, ' + ', '''),'); 
    SET @iterator += 1;
END
SET @json_statement += '},''';
SET @values_declaration = SUBSTRING(@values_declaration, 0, LEN(@values_declaration));
SET @values = SUBSTRING(@values, 0, LEN(@values));

CLOSE column_names_cursor;
DEALLOCATE column_names_cursor;

EXEC('
DECLARE row_cursor CURSOR LOCAL FAST_FORWARD FOR 
SELECT * FROM containers;
OPEN row_cursor;

DECLARE ' + @values_declaration + ';

DECLARE @iterator INT = 0;
DECLARE @count INT = ' + @count + ';

DECLARE @json_statement VARCHAR(MAX) = ' + @json_statement + ';

WHILE @iterator < @count
BEGIN
    FETCH NEXT FROM row_cursor INTO ' + @values + ';
    SELECT @json_statment;
    EXEC sp_executesql 
        N''SELECT * @json_statement;'',
        N''@json_statement VARCHAR(2048)'',
        @json_statement = @json_statement;  
    SET @iterator += 1;
END


CLOSE row_cursor;
DEALLOCATE row_cursor;
');

GO

USE VL;
GO

CREATE OR ALTER FUNCTION to_json_value (@value sql_variant)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @type NVARCHAR(20)
    SET @type = CAST(sql_variant_property(@value, 'baseType') AS NVARCHAR(20));

    RETURN CASE @type
        WHEN 'int' THEN CAST(@value AS NVARCHAR(MAX))
        WHEN 'float' THEN CAST(@value AS NVARCHAR(MAX))
        /*Other numeric types...*/
        WHEN 'bit' THEN IIF(@value = 0, 'false', 'true')
        WHEN 'datetime' THEN '"' + CONVERT(VARCHAR, @value, 126) + '"'
        ELSE CONCAT('"', CAST(@value AS NVARCHAR(MAX)), '"')
        END
END;
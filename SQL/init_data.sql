USE VL;
GO

INSERT INTO containers
VALUES 
    (NEWID(), 'type name 1', 2.5, 1.2, 1.4, 100, 0, '2024-05-11 12:00:00.000'),
    (NEWID(), 'type name 1', 2.5, 1.2, 1.4, 500, 1, '2024-05-12 12:00:00.000'),
    (NEWID(), 'type name 2', 2.5, 1.2, 1.4, 600, 1, '2024-05-13 12:00:00.000');

INSERT INTO operations
VALUES 
    (NEWID(), (SELECT id FROM containers WHERE number = 1), 
        '2024-05-11 13:00:00.000', '2024-05-11 16:00:00.000', 'type name 1', 'Ivanov Ivan Ivanovich', 'some place 1'),
    (NEWID(), (SELECT id FROM containers WHERE number = 2), 
        '2024-05-12 13:00:00.000', '2024-05-12 16:00:00.000', 'type name 1', 'Ivanov Ivan Ivanovich', 'some place 2'),
    (NEWID(), (SELECT id FROM containers WHERE number = 3), 
        '2024-05-13 13:00:00.000', '2024-05-13 16:00:00.000', 'type name 1', 'Ivanov Ivan Ivanovich', 'some place 3'),
    (NEWID(), (SELECT id FROM containers WHERE number = 3), 
        '2024-05-13 17:00:00.000', '2024-05-13 18:00:00.000', 'type name 2', 'Ivanov Ivan Ivanovich', 'some place 3');

GO  
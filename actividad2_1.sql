Use MonkeyUniv;
Set Dateformat 'DMY';
 
-- TP
-- 1    Listado de todos los idiomas.
SELECT * FROM Idiomas;
 
-- 2    Listado de todos los cursos.
SELECT * FROM Cursos;
 
-- 3    Listado con nombre, costo de inscripción, costo de certificación y fecha de estreno de todos los cursos.
SELECT Nombre, CostoCurso, CostoCertificacion, Estreno
FROM Cursos;
 
-- 4    Listado con ID, nombre, costo de inscripción e ID de nivel de todos los cursos cuyo costo de certificación sea menor a $ 5000.
SELECT ID, Nombre, CostoCurso, IDNivel FROM Cursos
WHERE CostoCertificacion < 5000;
 
-- 5    Listado con ID, nombre, costo de inscripción e ID de nivel de todos los cursos cuyo costo de certificación sea mayor a $ 1200.
Select ID, Nombre, CostoCurso, IDNivel From Cursos 
Where CostoCertificacion > 1200;
 
-- 6    Listado con nombre, número y duración de todas las clases del curso con ID número 6.
SELECT ID, Nombre, Numero, Duracion FROM Clases WHERE IDCurso = 6;
 
SELECT ID, Nombre, Numero, Duracion FROM Clases WHERE IDCurso IN(6);
-- 7    Listado con nombre, número y duración de todas las clases del curso con ID número 10.
SELECT Nombre, Numero, Duracion FROM Clases WHERE IDCurso = 10;
 
-- 8    Listado con nombre y duración de todas las clases con ID número 4. Ordenado por duración de mayor a menor.
SELECT Nombre, Duracion FROM Clases
WHERE ID = 4 
ORDER BY Duracion DESC;
 
-- 9    Listado con nombre, fecha de estreno, costo del curso, costo de certificación ordenados por fecha de estreno de manera creciente.
SELECT Nombre, Estreno, CostoCurso, CostoCertificacion
FROM Cursos
ORDER BY Estreno ASC, Nombre ASC;
 
-- 10   Listado con nombre, fecha de estreno y costo del curso de todos aquellos cuyo ID de nivel sea 1, 5, 6 o 7.
 
Select Nombre, Estreno, CostoCurso, IDNivel From Cursos
Where IDNivel = 1 or IDNivel = 5 or IDNivel = 6 or IDNivel = 7 ;
 
SELECT Nombre, Estreno, CostoCurso FROM Cursos
WHERE IDNivel IN(1, 5, 6, 7);
 
--  Listado con nombre, fecha de estreno e ID de curso de todos los cursos cuyo número de clase sea 1, 4, o 5
 
 
-- 12   Listado con nombre, duración y costo del curso de todos aquellos cuyo ID de nivel no sean 1, 5, 9 y 10.
SELECT Nombre, Estreno, CostoCurso FROM Cursos
WHERE IDNivel NOT IN(1, 5, 9, 10);
 
SELECT Nombre, Estreno, CostoCurso FROM Cursos
WHERE IDNivel <> 1 AND IDNivel <> 5 AND IDNivel <> 9 AND IDNivel <> 10;
 
-- 13   Listado con nombre y fecha de estreno de todos los cursos cuya fecha de estreno haya sido en el primer semestre del año 2019.
SELECT Nombre, Estreno FROM Cursos
WHERE YEAR(Estreno) = 2019 AND MONTH(Estreno) <= 6;
 
SELECT Nombre, Estreno FROM Cursos
WHERE Estreno >= '01/01/2019' AND Estreno <= '30/06/2019';
 
SELECT Nombre, Estreno FROM Cursos
WHERE Estreno BETWEEN '01/01/2019' AND '30/06/2019';
 
-- 14   Listado de cursos cuya fecha de estreno haya sido en el año 2020.
 
SELECT * FROM Cursos
WHERE YEAR(Estreno) = 2020;
 
SELECT * FROM Cursos
WHERE Estreno >= '01/01/2020' AND Estreno <= '31/12/2020';
 
SELECT * FROM Cursos
WHERE Estreno BETWEEN '01/01/2020' AND '31/12/2020';
 
-- Investigar:
------------------
-- DATEPART
-- DATEDIFF y DATEADD
 
-- 15   Listado de cursos cuya mes de estreno haya sido entre el 1 y el 4.
SELECT * FROM Cursos
WHERE MONTH(Estreno) >= 1 AND MONTH(Estreno) <= 4;
 
SELECT * FROM Cursos
WHERE MONTH(Estreno) BETWEEN 1 AND 4;
 
-- 16   Listado de clases cuya duración se encuentre entre 15 y 90 minutos.
SELECT * FROM  Clases
WHERE Duracion BETWEEN 15 AND 90;
 
SELECT * FROM Clases
WHERE Duracion >= 15 AND Duracion <= 90;
 
-- 17   Listado de contenidos cuyo tamaño supere los 5000MB y sean de tipo 4 o sean menores a 400MB y sean de tipo 1.
SELECT * FROM Contenidos
WHERE Tamaño > 5000 AND IDTipo = 4 OR Tamaño < 400 AND IDTipo = 1;
 
-- 18   Listado de cursos que no posean ID de nivel.
Select * From Cursos
Where IDNivel IS NULL;
 
-- 19   Listado de cursos cuyo costo de certificación corresponda al 20% o más del costo del curso.
SELECT * FROM Cursos
WHERE CostoCurso * 0.2 <= CostoCertificacion;
 
-- 20   Listado de costos de cursado de todos los cursos sin repetir y ordenados de mayor a menor.
SELECT DISTINCT CostoCurso
FROM Cursos
ORDER BY CostoCurso DESC;
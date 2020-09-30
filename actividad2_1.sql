Use MonkeyUniv;
Set Dateformat 'DMY'
 
-- TP
-- 1    Listado de todos los idiomas.
Select * From Idiomas
 
-- 2    Listado de todos los cursos.
Select * From Cursos
 
-- 3    Listado con nombre, costo de inscripción, costo de certificación y fecha de estreno de todos los cursos.
Select Nombre, CostoCurso, CostoCertificacion, Estreno
From Cursos
 
-- 4    Listado con ID, nombre, costo de inscripción e ID de nivel de todos los cursos cuyo costo de certificación sea menor a $ 5000.
Select ID, Nombre, CostoCurso, IDNivel From Cursos
Where CostoCertificacion < 5000
 
-- 5    Listado con ID, nombre, costo de inscripción e ID de nivel de todos los cursos cuyo costo de certificación sea mayor a $ 1200.
Select ID, Nombre, CostoCurso, IDNivel From Cursos 
Where CostoCertificacion > 1200
 
-- 6    Listado con nombre, número y duración de todas las clases del curso con ID número 6.
Select ID, Nombre, Numero, Duracion From Clases Where IDCurso = 6
 
Select ID, Nombre, Numero, Duracion From Clases Where IDCurso IN(6)
-- 7    Listado con nombre, número y duración de todas las clases del curso con ID número 10.
Select Nombre, Numero, Duracion From Clases Where IDCurso = 10
 
-- 8    Listado con nombre y duración de todas las clases con ID número 4. Ordenado por duración de mayor a menor.
Select Nombre, Duracion From Clases
Where ID = 4 
Order by Duracion desc
 
-- 9    Listado con nombre, fecha de estreno, costo del curso, costo de certificación ordenados por fecha de estreno de manera creciente.
Select Nombre, Estreno, CostoCurso, CostoCertificacion
From Cursos
Order by Estreno asc, Nombre asc
 
-- 10   Listado con nombre, fecha de estreno y costo del curso de todos aquellos cuyo ID de nivel sea 1, 5, 6 o 7.
 
Select Nombre, Estreno, CostoCurso, IDNivel From Cursos
Where IDNivel = 1 or IDNivel = 5 or IDNivel = 6 or IDNivel = 7
 
Select Nombre, Estreno, CostoCurso From Cursos
Where IDNivel IN(1, 5, 6, 7)
 
--  Listado con nombre, fecha de estreno e ID de curso de todos los cursos cuyo número de clase sea 1, 4, o 5
 
 
-- 12   Listado con nombre, duración y costo del curso de todos aquellos cuyo ID de nivel no sean 1, 5, 9 y 10.
Select Nombre, Estreno, CostoCurso From Cursos
Where IDNivel NOT IN(1, 5, 9, 10)
 
Select Nombre, Estreno, CostoCurso From Cursos
Where IDNivel <> 1 and IDNivel <> 5 and IDNivel <> 9 and IDNivel <> 10
 
-- 13   Listado con nombre y fecha de estreno de todos los cursos cuya fecha de estreno haya sido en el primer semestre del año 2019.
Select Nombre, Estreno From Cursos
Where year(Estreno) = 2019 and month(Estreno) <= 6
 
Select Nombre, Estreno From Cursos
Where Estreno >= '01/01/2019' and Estreno <= '30/06/2019'
 
Select Nombre, Estreno From Cursos
Where Estreno between '01/01/2019' and '30/06/2019'
 
-- 14   Listado de cursos cuya fecha de estreno haya sido en el año 2020.
 
Select * From Cursos
Where year(Estreno) = 2020
 
Select * From Cursos
Where Estreno >= '01/01/2020' and Estreno <= '31/12/2020'
 
Select * From Cursos
Where Estreno between '01/01/2020' and '31/12/2020'
 
-- Investigar:
------------------
-- DATEPART
-- DATEDIFF y DATEADD
 
-- 15   Listado de cursos cuya mes de estreno haya sido entre el 1 y el 4.
Select * From Cursos
Where month(Estreno) >= 1 and month(Estreno) <= 4
 
Select * From Cursos
Where month(Estreno) between 1 and 4
 
-- 16   Listado de clases cuya duración se encuentre entre 15 y 90 minutos.
Select * From  Clases
Where Duracion between 15 and 90
 
Select * From Clases
WHERE Duracion >= 15 and Duracion <= 90
 
-- 17   Listado de contenidos cuyo tamaño supere los 5000MB y sean de tipo 4 o sean menores a 400MB y sean de tipo 1.
Select * From Contenidos
Where Tamaño > 5000 and IDTipo = 4 or Tamaño < 400 and IDTipo = 1
 
-- 18   Listado de cursos que no posean ID de nivel.
Select * From Cursos
Where IDNivel IS NULL
 
-- 19   Listado de cursos cuyo costo de certificación corresponda al 20% o más del costo del curso.
Select * From Cursos
Where CostoCurso * 0.2 <= CostoCertificacion
 
-- 20   Listado de costos de cursado de todos los cursos sin repetir y ordenados de mayor a menor.
Select Distinct CostoCurso
From Cursos
Order by 1 desc
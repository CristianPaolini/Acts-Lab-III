--# Ejercicio

USE MonkeyUniv;

--1 Listado con nombre de usuario de todos los usuarios y sus respectivos
--nombres y apellidos.
-- SELECT Usuarios.NombreUsuario, //Forma sin alias, menos conveniente
-- Datos_Personales.Apellidos,
-- Datos_Personales.Nombres
-- FROM Usuarios
-- INNER JOIN Datos_Personales ON Usuarios.ID = Datos_Personales.ID;

SELECT U.NombreUsuario, DAT.Apellidos, DAT.Nombres, Dat.Email
FROM Usuarios AS U
INNER JOIN Datos_Personales AS DAT ON U.ID = DAT.ID;


--2 Listado con apellidos, nombres, fecha de nacimiento y nombre del país de
--nacimiento.

SELECT DAT.Apellidos, DAT.Nombres, DAT.Nacimiento AS FechaNac, P.Nombre AS PaisNac
FROM Datos_Personales AS DAT
INNER JOIN Paises AS P ON DAT.IDPais = P.ID;

--3 Listado con nombre de usuario, apellidos, nombres, email o celular de todos
--los usuarios que vivan en una domicilio cuyo nombre contenga el término
--'Presidente' o 'General'.
--NOTA: Si no tiene email, obtener el celular.

SELECT U.NombreUsuario, DAT.Apellidos, DAT.Nombres,
ISNULL(DAT.Email, DAT.Celular) AS InfoContacto
FROM Usuarios AS U
INNER JOIN Datos_Personales AS DAT
ON U.ID = DAT.ID
WHERE DAT.Domicilio LIKE '%Presidente%' OR DAT.Domicilio LIKE '%General%';

--4 Listado con nombre de usuario, apellidos, nombres, email o celular o domicilio
--como 'Información de contacto'.
--NOTA: Si no tiene email, obtener el celular y si no posee celular obtener el
--domicilio.

SELECT U.NombreUsuario, DAT.Apellidos, DAT.Nombres,
COALESCE(DAT.Email, DAT.Celular, DAT.Domicilio) AS InfoContacto
FROM Usuarios AS U
INNER JOIN Datos_Personales AS DAT ON U.ID = DAT.ID;

--5 Listado con apellido y nombres, nombre del curso y costo de la inscripción de
--todos los usuarios inscriptos a cursos.
--NOTA: No deben figurar los usuarios que no se inscribieron a ningún curso.

SELECT  C.Nombre AS NombreCurso, DAT.Apellidos, DAT.Nombres, I.Costo AS CostoInsc
FROM Cursos AS C
INNER JOIN Inscripciones AS I ON C.ID = I.IDCurso
INNER JOIN Usuarios AS U ON I.IDUsuario = U.ID
INNER JOIN Datos_Personales AS DAT ON U.ID = DAT.ID;

--6 Listado con nombre de curso, nombre de usuario y mail de todos los
--inscriptos a cursos que se hayan estrenado en el año 2020.
SELECT C.Nombre AS NombreCurso, U.NombreUsuario, DAT.Email
FROM Cursos AS C
INNER JOIN Inscripciones AS I ON C.ID = I.ID
INNER JOIN Usuarios AS U ON I.ID = U.ID
INNER JOIN Datos_Personales AS DAT ON U.ID = DAT.ID
WHERE YEAR(C.Estreno) = 2020;


--7 Listado con nombre de curso, nombre de usuario, apellidos y nombres, fecha
--de inscripción, costo de inscripción, fecha de pago e importe de pago. Sólo
--listar información de aquellos que hayan pagado.

SELECT C.Nombre AS NombreCurso, U.NombreUsuario AS Usuario, DAT.Apellidos, DAT.Nombres, I.Fecha AS FechaInsc, I.Costo AS CostoInsc, P.Fecha AS FechaPago, P.Importe AS ImportePago
FROM Cursos AS C
INNER JOIN Inscripciones AS I ON C.ID = I.ID
INNER JOIN Pagos AS P ON I.ID = P.ID
INNER JOIN Usuarios AS U ON I.IDUsuario = U.ID
INNER JOIN Datos_Personales AS DAT ON U.ID = DAT.ID
WHERE P.Importe > 0;

--8 Listado con nombre y apellidos, genero, fecha de nacimiento, mail, nombre del
--curso y fecha de certificación de todos aquellos usuarios que se hayan
--certificado.

SELECT DAT.Nombres, DAT.Apellidos, DAT.Genero, DAT.Nacimiento AS FechaNac, DAT.Email, C.Nombre AS NombreCurso, Cert.Fecha AS FechaCertific
FROM Datos_Personales AS DAT
INNER JOIN Usuarios AS U ON DAT.ID = U.ID
INNER JOIN Inscripciones AS I ON U.ID = I.IDUsuario
INNER JOIN Certificaciones AS Cert ON I.ID = Cert.IDInscripcion
INNER JOIN Cursos AS C ON I.IDCurso = C.ID;

--9 Listado de cursos con nombre, costo de cursado y certificación, costo total
--(cursado + certificación) con 10% de todos los cursos de nivel Principiante.


--10 Listado con nombre y apellido y mail de todos los instructores. Sin repetir.

SELECT DISTINCT DAT.Nombres, DAT.Apellidos, DAT.Email
FROM Instructores_X_Curso AS IxC
INNER JOIN Usuarios AS U ON IxC.IDUsuario = U.ID
INNER JOIN Datos_Personales AS DAT ON U.ID = DAT.ID
ORDER BY DAT.Apellidos;


--11 Listado con nombre y apellido de todos los usuarios que hayan cursado algún
--curso cuya categoría sea 'Historia'.

SELECT DISTINCT DAT.Apellidos, DAT.Nombres
FROM Datos_Personales AS DAT
INNER JOIN Usuarios AS U ON DAT.ID = U.ID
INNER JOIN Inscripciones AS I ON U.ID = I.IDUsuario
INNER JOIN Cursos AS C ON I.IDCurso = C.ID
INNER JOIN Categorias_x_Curso AS CxC ON C.ID = CxC.IDCurso
INNER JOIN Categorias AS CAT ON CxC.IDCategoria = CAT.ID
WHERE CAT.Nombre LIKE 'Historia'
ORDER BY DAT.Apellidos;

--12 Listado con nombre de idioma, código de curso y código de tipo de idioma.
--Listar todos los idiomas indistintamente si no tiene cursos relacionados.

SELECT I.Nombre AS Idioma, C.ID AS CodigoCurso, IxC.IDTipo AS CodigoTipo
FROM Idiomas AS I
LEFT JOIN Idiomas_x_Curso AS IxC ON I.ID = IxC.IDIdioma
LEFT JOIN Cursos AS C ON IxC.IDCurso = C.ID;

--13 Listado con nombre de idioma de todos los idiomas que no tienen cursos
--relacionados.

SELECT I.Nombre
FROM Idiomas AS I
LEFT JOIN Idiomas_x_Curso AS IxC ON I.ID = IxC.IDIdioma
WHERE IxC.IDIdioma IS NULL;

--14 Listado con nombres de idioma que figuren como audio de algún curso. Sin
--repeticiones.

SELECT DISTINCT I.Nombre AS NombreIdioma, Tipos.Nombre AS Tipo
FROM Idiomas AS I
LEFT JOIN Idiomas_x_Curso AS IxC ON I.ID = IxC.IDIdioma
INNER JOIN Clases AS Cl ON IxC.IDCurso = Cl.IDCurso 
INNER JOIN Contenidos AS Cont ON Cl.ID = Cont.IDClase 
INNER JOIN TiposContenido AS Tipos ON Cont.ID = Tipos.ID
WHERE Tipos.Nombre LIKE '%audio%';

--15 Listado con nombres y apellidos de todos los usuarios y el nombre del país en
--el que nacieron. Listar todos los países indistintamente si no tiene usuarios
--relacionados

SELECT DAT.Nombres, DAT.Apellidos, P.Nombre AS Pais
FROM Datos_Personales AS DAT
LEFT JOIN Paises AS P ON DAT.IDPais = P.ID;

--16 Listado con nombre de curso, fecha de estreno y nombres de usuario de todos
--los inscriptos. Listar todos los nombres de usuario indistintamente si no se
--inscribieron a ningún curso.

SELECT C.Nombre, C.Estreno, U.NombreUsuario
FROM Cursos AS C
RIGHT JOIN Inscripciones AS I ON C.ID = I.IDCurso
RIGHT JOIN Usuarios AS U ON I.IDUsuario = U.ID; 

--17 Listado con nombre de usuario, apellido, nombres, género, fecha de
--nacimiento y mail de todos los usuarios que no cursaron ningún curso.

SELECT U.NombreUsuario AS NombreUsuario, DAT.Apellidos, DAT.Nombres, DAT.Genero, DAT.Nacimiento AS FechaNac, DAT.Email AS Email
FROM Datos_Personales AS DAT
LEFT JOIN Usuarios AS U ON DAT.ID = U.ID
LEFT JOIN Inscripciones AS I ON U.ID = I.IDUsuario
WHERE I.IDCurso IS NULL;

--18 Listado con nombre y apellido, nombre del curso, puntaje otorgado y texto de
--la reseña. Sólo de aquellos usuarios que hayan realizado una reseña
--inapropiada.

SELECT DAT.Nombres, DAT.Apellidos, C.Nombre, R.Puntaje, R.Observaciones
FROM Usuarios AS U
INNER JOIN Datos_Personales AS DAT ON U.ID = DAT.ID
INNER JOIN Inscripciones AS I ON DAT.ID = I.IDUsuario
INNER JOIN Cursos AS C ON I.IDCurso = C.ID
INNER JOIN Reseñas AS R ON I.ID = R.IDInscripcion
WHERE R.Inapropiada = 1;

--19 Listado con nombre del curso, costo de cursado, costo de certificación,
--nombre del idioma y nombre del tipo de idioma de todos los cursos cuya
--fecha de estreno haya sido antes del año actual. Ordenado por nombre del
--curso y luego por nombre de tipo de idioma. Ambos ascendentemente.

SELECT C.Nombre, C.CostoCurso, C.CostoCertificacion, I.Nombre, TI.Nombre
FROM Cursos AS C 
INNER JOIN Idiomas_x_Curso AS IxC ON C.ID = IxC.IDIdioma
INNER JOIN Idiomas AS I ON IxC.IDIdioma = I.ID
INNER JOIN TiposIdioma AS TI ON IxC.IDTipo = TI.ID 
WHERE YEAR(C.Estreno) < GETDATE()
ORDER BY C.Nombre, TI.Nombre ASC;

--20 Listado con nombre del curso y todos los importes de los pagos relacionados.

SELECT C.Nombre, P.Importe
FROM Pagos AS P
LEFT JOIN Inscripciones AS I ON P.IDInscripcion = I.ID
INNER JOIN Cursos AS C ON I.IDCurso = C.ID
ORDER BY C.Nombre;

--21 Listado con nombre de curso, costo de cursado y una leyenda que indique
--"Costoso" si el costo de cursado es mayor a $ 15000, "Accesible" si el costo
--de cursado está entre $2500 y $15000, "Barato" si el costo está entre $1 y
--$2499 y "Gratis" si el costo es $0.

SELECT C.Nombre, C.CostoCurso,
    CASE 
    WHEN C.CostoCurso > 15000 THEN 'Costoso'
    WHEN C.CostoCurso >= 2500 THEN 'Accesible'
    WHEN C.CostoCurso >= 1 THEN 'Barato'
    ELSE 'Gratis'
    END AS 'Costo Descriptivo'
FROM Cursos AS C;




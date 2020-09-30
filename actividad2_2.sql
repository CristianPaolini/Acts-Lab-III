--# Ejercicio

Use MonkeyUniv;

--1 Listado con nombre de usuario de todos los usuarios y sus respectivos nombres y apellidos.
Select U.NombreUsuario 'Username', DAT.Apellidos, DAT.Nombres
From Usuarios U
Inner Join Datos_Personales DAT on U.ID = DAT.ID

--2 Listado con apellidos, nombres, fecha de nacimiento y nombre del país de
--nacimiento.
Select DAT.Apellidos, DAT.Nombres, DAT.Nacimiento 'Fecha de nacimiento', P.Nombre 'País de nacimiento'
From Datos_Personales DAT
Inner Join Paises P on DAT.IDPais = P.ID

--3 Listado con nombre de usuario, apellidos, nombres, email o celular de todos
--los usuarios que vivan en una domicilio cuyo nombre contenga el término
--'Presidente' o 'General'.
--NOTA: Si no tiene email, obtener el celular.
Select U.NombreUsuario 'Username', DAT.Apellidos, DAT.Nombres, isnull(DAT.Email, DAT.Celular) 'Info contacto'
From Usuarios U
Inner Join Datos_Personales DAT on U.ID = DAT.ID
Where DAT.Domicilio Like '%Presidente%' or DAT.Domicilio Like '%General%'

--4 Listado con nombre de usuario, apellidos, nombres, email o celular o domicilio
--como 'Información de contacto'.
--NOTA: Si no tiene email, obtener el celular y si no posee celular obtener el
--domicilio.
Select U.NombreUsuario 'Username', DAT.Apellidos, DAT.Nombres,
Coalesce(DAT.Email, DAT.Celular, DAT.Domicilio) as 'Info contacto'
From Usuarios as U
Inner Join Datos_Personales as DAT on U.ID = DAT.ID

--5 Listado con apellido y nombres, nombre del curso y costo de la inscripción de
--todos los usuarios inscriptos a cursos.
--NOTA: No deben figurar los usuarios que no se inscribieron a ningún curso.
Select DAT.Apellidos, DAT.Nombres, C.Nombre, I.Costo 'Costo inscripción'
From Datos_Personales DAT
Inner Join Inscripciones I on DAT.ID = I.IDUsuario
Inner Join Cursos C on I.IDCurso = C.ID

--6 Listado con nombre de curso, nombre de usuario y mail de todos los
--inscriptos a cursos que se hayan estrenado en el año 2020.
Select C.Nombre 'Nombre del curso', U.NombreUsuario 'Username', DAT.Email
From Cursos C
Inner Join Inscripciones I on C.ID = I.IDCurso
Inner Join Usuarios U on I.IDUsuario = U.ID
Inner Join Datos_Personales DAT on U.ID = DAT.ID
Where year(C.Estreno) = 2020

--7 Listado con nombre de curso, nombre de usuario, apellidos y nombres, fecha
--de inscripción, costo de inscripción, fecha de pago e importe de pago. Sólo
--listar información de aquellos que hayan pagado.
Select C.Nombre 'Nombre del curso', U.NombreUsuario 'Username', DAT.Apellidos, DAT.Nombres,
I.Fecha 'Fecha insc.', I.Costo 'Costo insc.', P.Fecha 'Fecha de pago', P.Importe 'Importe de pago'
From Cursos C
Inner Join Inscripciones I on C.ID = I.IDCurso
Inner Join Pagos P on I.ID = P.IDInscripcion
Inner Join Usuarios U on I.IDUsuario = U.ID
Inner Join Datos_Personales DAT on U.ID = DAT.ID

--8 Listado con nombre y apellidos, genero, fecha de nacimiento, mail, nombre del
--curso y fecha de certificación de todos aquellos usuarios que se hayan
--certificado.
Select DAT.Nombres, DAT.Apellidos,
DAT.Genero, DAT.Nacimiento 'Fecha de nacimiento', DAT.Email,
C.Nombre 'Nombre del curso', CER.Fecha 'Fecha de certificación'
From Datos_Personales DAT
Inner Join Inscripciones I on DAT.ID = I.IDUsuario
Inner Join Certificaciones CER on I.ID = CER.IDInscripcion
Inner Join Cursos C on I.IDCurso = C.ID

--9 Listado de cursos con nombre, costo de cursado y certificación, costo total
--(cursado + certificación) con 10% de todos los cursos de nivel Principiante.
Select C.Nombre 'Nombre del curso', C.CostoCurso 'Costo cursado',
C.CostoCertificacion 'Costo certificación', (c.CostoCurso + c.CostoCertificacion) * 0.9 as 'Costo total' 
From Cursos C 
Inner Join Niveles N on N.ID = C.IDNivel
where N.Nombre Like 'Principiante' 

--10 Listado con nombre y apellido y mail de todos los instructores. Sin repetir.
Select DAT.Nombres, DAT.Apellidos, DAT.Email
From Datos_Personales DAT
Where DAT.ID in(
	Select Distinct IxC.IDUsuario
	From Instructores_x_Curso IxC
)

Select Distinct DAT.Nombres, DAT.Apellidos, DAT.Email --Otra forma de resolver
From Datos_Personales DAT
Inner Join Usuarios U on DAT.ID = U.ID
Inner Join Instructores_x_Curso IxC on U.ID = IxC.IDUsuario
Order by DAT.Apellidos

--11 Listado con nombre y apellido de todos los usuarios que hayan cursado algún
--curso cuya categoría sea 'Historia'.
Select distinct DAT.Nombres, DAT.Apellidos
From Datos_Personales DAT
Inner Join Inscripciones I on DAT.ID = I.IDUsuario
Inner Join Cursos C on I.IDCurso = C.ID
Inner Join Categorias_x_Curso CxC on C.ID = CxC.IDCurso
Inner Join Categorias CAT on CxC.IDCategoria = CAT.ID
Where CAT.Nombre = 'Historia'
Order by 2

--12 Listado con nombre de idioma, código de curso y código de tipo de idioma.
--Listar todos los idiomas indistintamente si no tiene cursos relacionados.
Select I.Nombre 'Nombre del idioma', C.ID 'Código curso', IxC.IDTipo 'Código tipo idioma'
From Idiomas I
Left Join Idiomas_x_Curso IxC on I.ID = IxC.IDIdioma
Left Join Cursos C on IxC.IDCurso = C.ID

--13 Listado con nombre de idioma de todos los idiomas que no tienen cursos
--relacionados.
Select I.Nombre From Idiomas I
Where I.ID not in(
	Select distinct IxC.IDIdioma
	From Idiomas_x_Curso IxC
)

Select I.Nombre From Idiomas I
Left Join Idiomas_x_Curso IxC on I.ID = IxC.IDIdioma
Where IxC.IDIdioma is null

--14 Listado con nombres de idioma que figuren como audio de algún curso. Sin
--repeticiones.
Select distinct I.Nombre
From Idiomas I
Inner Join Idiomas_x_Curso IxC on I.ID = IxC.IDIdioma
Inner Join TiposIdioma TI on IxC.IDTipo = TI.ID
Where TI.Nombre Like '%Audio%'

--15 Listado con nombres y apellidos de todos los usuarios y el nombre del país en
--el que nacieron. Listar todos los países indistintamente si no tiene usuarios
--relacionados
Select DAT.Apellidos+ ', ' +DAT.Nombres as 'Apellidos y nombres', P.Nombre 'País de nacimiento'
From Datos_Personales DAT
Right Join Paises P on DAT.IDPais = P.ID

--16 Listado con nombre de curso, fecha de estreno y nombres de usuario de todos
--los inscriptos. Listar todos los nombres de usuario indistintamente si no se
--inscribieron a ningún curso.
Select C.Nombre 'Nombre del curso', C.Estreno 'Fecha de estreno', U.NombreUsuario 'Username'
From Cursos C
Inner Join Inscripciones I on C.ID = I.IDCurso
Right Join Usuarios U on I.IDUsuario = U.ID
Order by 3

--17 Listado con nombre de usuario, apellido, nombres, género, fecha de
--nacimiento y mail de todos los usuarios que no cursaron ningún curso.
Select U.NombreUsuario 'Username', DAT.Apellidos+ ', ' +DAT.Nombres as 'Apellido y Nombre',
DAT.Genero, DAT.Nacimiento 'Fecha de nacimiento', DAT.Email
From Datos_Personales DAT
Inner Join Usuarios U on DAT.ID = U.ID
Where DAT.ID not in(
	Select distinct I.IDUsuario
	From Inscripciones I
)

Select U.NombreUsuario 'Username', DAT.Apellidos, DAT.Nombres, DAT.Genero, DAT.Nacimiento 'Fecha de nacimiento', DAT.Email
From Datos_Personales DAT
Left Join Usuarios U on DAT.ID = U.ID
Left Join Inscripciones I on U.ID = I.IDUsuario
WHERE I.IDCurso is null

--18 Listado con nombre y apellido, nombre del curso, puntaje otorgado y texto de
--la reseña. Sólo de aquellos usuarios que hayan realizado una reseña
--inapropiada.
Select DAT.Apellidos+ ', ' +DAT.Nombres 'Apellido y nombre',
C.Nombre 'Nombre del curso', R.Puntaje 'Puntaje', R.Observaciones 'Texto de la reseña'
From Datos_Personales DAT
Inner Join Inscripciones I on DAT.ID = I.IDUsuario
Inner Join Cursos C on I.IDCurso = C.ID
Inner Join Reseñas R on I.ID = R.IDInscripcion
Where R.Inapropiada = 1

--19 Listado con nombre del curso, costo de cursado, costo de certificación,
--nombre del idioma y nombre del tipo de idioma de todos los cursos cuya
--fecha de estreno haya sido antes del año actual. Ordenado por nombre del
--curso y luego por nombre de tipo de idioma. Ambos ascendentemente.
Select C.Nombre 'Nombre del curso', C.CostoCurso 'Costo de cursado',
C.CostoCertificacion 'Costo de certificación',
I.Nombre 'Nombre del idioma', TI.Nombre 'Nombre del tipo de idioma'
From Cursos C
Inner Join Idiomas_x_Curso IxC on C.ID = IxC.IDCurso
Inner Join Idiomas I on IxC.IDIdioma = I.ID
Inner Join TiposIdioma TI on IxC.IDTipo = TI.ID
Where year(C.Estreno) < year(getdate())
Order by 1, 5

--20 Listado con nombre del curso y todos los importes de los pagos relacionados.
Select C.Nombre, P.Importe
From Cursos C
Left Join Inscripciones I on C.ID = I.IDCurso
Inner Join Pagos P on I.ID = P.IDInscripcion
Order by C.Nombre

--21 Listado con nombre de curso, costo de cursado y una leyenda que indique
--"Costoso" si el costo de cursado es mayor a $ 15000, "Accesible" si el costo
--de cursado está entre $2500 y $15000, "Barato" si el costo está entre $1 y
--$2499 y "Gratis" si el costo es $0.
Select C.Nombre 'Nombre del curso', C.CostoCurso 'Costo de cursado',
	Case
	When C.CostoCurso > 15000 then 'Costoso'
	When C.CostoCurso >= 2500 then 'Accesible'
	When C.CostoCurso >= 1 then 'Barato'
	Else 'Gratis'
	End as 'Costo descriptivo'
From Cursos C





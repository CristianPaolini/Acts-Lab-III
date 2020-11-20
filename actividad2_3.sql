-- (1)  Listado con la cantidad de cursos.
Select count(*) as Cantidad from Cursos

-- 2  Listado con la cantidad de usuarios.
Select count(*) as Cantidad from Usuarios

-- (3)  Listado con el promedio de costo de certificación de los cursos.
Select avg(C.CostoCertificacion) as Promedio From Cursos C

-- 4  Listado con el promedio general de calificación de reseñas.
Select avg(R.Puntaje) as 'Promedio Reseñas' From Reseñas R

-- (5)  Listado con la fecha de estreno de curso más antigua.
Select top 1 (C.Estreno) From Cursos C
Order by C.Estreno asc

Select min(C.Estreno) From Cursos C

-- 6  Listado con el costo de certificación menos costoso.
Select min(C.CostoCertificacion) From Cursos C

-- (7)  Listado con el costo total de todos los cursos.
Select sum(C.CostoCurso) as 'Costo Total' From Cursos C

-- 8  Listado con la suma total de todos los pagos.
Select sum(P.Importe) as 'Suma Total' From Pagos P

-- 9  Listado con la cantidad de cursos de nivel principiante.
Select count(*) 'Cantidad de nivel Principiante' From Cursos C
Inner Join Niveles N on C.IDNivel = N.ID
Where N.Nombre = 'Principiante'

-- 10  Listado con la suma total de todos los pagos realizados en 2019.
Select sum(P.Importe) 'Pagos 2019'
From Pagos P
Where year(P.Fecha) = 2019

-- (11)  Listado con la cantidad de usuarios que son instructores.
Select count(Distinct IxC.IDUsuario) 'Total Instructores'
From Instructores_x_Curso IxC

Select count(*)'Cantidad instructores'
From Usuarios U
Where U.ID in(
	Select distinct IxC.IDUsuario
	From Instructores_x_Curso IxC
)

-- Listado de usuarios distintos de Instructores_x_curso
Select distinct U.NombreUsuario
From Usuarios U
Inner Join Instructores_x_Curso IxC on U.ID = IxC.IDUsuario

-- 12  Listado con la cantidad de usuarios distintos que se hayan certificado
Select count(distinct U.ID) 'Total Certificados'
From Usuarios U
Inner Join Inscripciones I on U.ID = I.IDUsuario
Inner Join Certificaciones CER on I.ID = CER.IDInscripcion

Select count(*)'Cantidad certificados'
From Usuarios U
Where U.ID in(
	Select distinct I.IDUsuario
	From Inscripciones I
	Inner Join Certificaciones CER on I.ID = CER.IDInscripcion
)

-- (13)  Listado con el nombre del país y la cantidad de usuarios de cada país.
Select P.Nombre, count(DAT.ID) as Cantidad from Paises P
Left join Datos_Personales DAT
on P.ID = DAT.IDPais
Group by P.Nombre
Order by 2 desc

-- (14)  Listado con el apellido y nombres del usuario y el importe más costoso abonado como pago. Sólo listar aquellos que hayan abonado más de $7500.
Select DAT.Apellidos, DAT.Nombres, max(P.Importe) 'Mayor pago'
From Datos_Personales DAT
Inner Join Inscripciones I on DAT.ID = I.IDUsuario
Inner Join Pagos P on I.ID = P.IDInscripcion
Group by DAT.Apellidos, DAT.Nombres
Having max(P.Importe) > 7500

-- 15  Listado con el apellido y nombres de usuario y el importe más costoso de curso al cual se haya inscripto.
Select DAT.Apellidos, U.NombreUsuario, isnull(max(I.Costo),0)'Importe más costoso de inscripción'
From Datos_Personales DAT
Left Join Usuarios U on DAT.ID = U.ID
Left Join Inscripciones i on U.ID = I.IDUsuario
Group by DAT.Apellidos, U.NombreUsuario

-- 16  Listado con el nombre del curso, nombre del nivel, cantidad total de clases y duración total del curso en minutos.
Select C.Nombre, N.Nombre, count(CL.ID) 'Cantidad de clases', Sum(CL.Duracion) 'Duración total'
From Cursos C
Left Join Niveles N on C.IDNivel = N.ID
Left Join Clases CL on C.ID = CL.IDCurso
Group by C.Nombre, N.Nombre

-- 17  Listado con el nombre del curso y cantidad de contenidos registrados. Sólo listar aquellos cursos que tengan más de 10 contenidos registrados.
Select C.Nombre, count(CONT.ID) as 'Cantidad de contenidos'
From Cursos C
Inner Join Clases CL on C.ID = CL.IDCurso
Inner Join Contenidos CONT on CL.ID = CONT.IDClase
Group by C.Nombre
Having count(CONT.ID) > 10

-- 18  Listado con nombre del curso, nombre del idioma y cantidad de tipos de idiomas.
Select isnull(C.Nombre,'N/A') as 'Nombre del curso', I.Nombre as 'Nombre del idioma', count(distinct IxC.IDTipo) as 'Cantidad de tipos de idiomas'
From Cursos C
Inner Join Idiomas_x_Curso IxC on C.ID = IxC.IDCurso
Right Join Idiomas I on IxC.IDIdioma = I.ID
Group by C.Nombre, I.Nombre
Order by 1

-- 19  Listado con el nombre del curso y cantidad de idiomas distintos disponibles.
Select C.Nombre as 'Nombre del curso', count(distinct IxC.IDIdioma) as 'Cantidad de idiomas distintos disponibles'
From Cursos C
Inner Join Idiomas_x_Curso IxC on C.ID = IxC.IDCurso 
Group by C.Nombre
Order by 1

-- 20  Listado de categorías de curso y cantidad de cursos asociadas a cada categoría. Sólo mostrar las categorías con más de 5 cursos.
Select CAT.Nombre as 'Nombre categoría', count(CxC.IDCurso) as 'Cantidad de cursos asociados'
From Categorias CAT
Inner Join Categorias_x_Curso CxC on CAT.ID = CxC.IDCategoria
Group by CAT.Nombre
Having count(CxC.IDCurso) > 5
Order by 1 desc

-- 21  Listado con tipos de contenido y la cantidad de contenidos asociados a cada tipo. Mostrar aquellos tipos que no hayan registrado contenidos con cantidad 0.
Select TI.Nombre as 'Tipo de contenido', count(CONT.IDTipo) as 'Cantidad de contenidos asociados'
From TiposContenido TI
Right Join Contenidos CONT on TI.ID = CONT.IDTipo
Group by TI.Nombre
Having count(CONT.IDTipo) <> 0
Order by 1 desc

-- 22  Listado con Nombre del curso, nivel, año de estreno y el total recaudado en concepto de inscripciones. Listar aquellos cursos sin inscripciones con total igual a $0.
Select isnull(C.Nombre,'N/A') as 'Nombre del curso', N.Nombre, year(C.Estreno) as 'Año de estreno', sum(I.Costo) as 'Recaudación por inscripciones'
From Cursos C
Left Join Inscripciones I on C.ID = I.IDCurso
Left Join Niveles N on C.IDNivel = N.ID
Group by C.Nombre, N.Nombre, C.Estreno

-- 23  Listado con Nombre del curso, costo de cursado y certificación y cantidad de usuarios distintos inscriptos cuyo costo de cursado sea menor a $10000 y cuya cantidad de usuarios inscriptos sea menor a 5. Listar aquellos cursos sin inscripciones con cantidad 0.
Select C.Nombre 'Nombre del curso', C.CostoCurso 'Costo de cursado',
C.CostoCertificacion 'Costo de certificación', count(distinct I.IDUsuario)'Cantidad de usuarios distintos inscriptos'
From Cursos C
Left Join Inscripciones I on C.ID = I.IDCurso
Group by C.Nombre, C.CostoCurso, C.CostoCertificacion
Having C.CostoCurso < 10000 and count(distinct I.IDUsuario) < 5

-- 24  Listado con Nombre del curso, fecha de estreno y nombre del nivel del curso que más recaudó en concepto de certificaciones.
Select Top 1 C.Nombre, C.Estreno, isnull(N.Nombre,'N/A') as 'Nivel con mayor rec. en concepto de certificaciones'
From Cursos C
Left Join Inscripciones I on C.ID = I.IDCurso
Left Join Certificaciones CER on I.ID = CER.IDInscripcion
Left Join Niveles N on C.IDNivel = N.ID
Group by C.Nombre, C.Estreno, N.Nombre
Order by sum(CER.Costo) desc

-- 25  Listado con Nombre del idioma del idioma más utilizado como subtítulo.
Select top 1 I.Nombre as 'Idioma más usado como subtítulo'
From Idiomas I
Inner Join Idiomas_x_Curso IxC on I.ID = IxC.IDIdioma
Inner Join TiposIdioma TI on IxC.IDTipo = TI.ID
Where TI.Nombre Like '%subtítulo%'

-- 26  Listado con Nombre del curso y promedio de puntaje de reseñas apropiadas.
Select C.Nombre as 'Nombre del curso', avg(R.Puntaje) as 'Promedio reseñas apropiadas'
From Cursos C
Inner Join Inscripciones I on C.ID = I.IDCurso
Inner Join Reseñas R on I.ID = R.IDInscripcion
Where R.Inapropiada = 0
Group by C.Nombre

-- 27  Listado con Nombre de usuario y la cantidad de reseñas inapropiadas que registró.
Select U.NombreUsuario as 'Username', count(*) as 'Cantidad de reseñas inapropiadas'
From Usuarios U
Inner Join Inscripciones I on U.ID = I.IDUsuario
Inner Join Reseñas R on I.ID = R.IDInscripcion
Where R.Inapropiada = 1
Group by U.NombreUsuario

-- 28  Listado con Nombre del curso, nombre y apellidos de usuarios y la cantidad de veces que dicho usuario realizó dicho curso. No mostrar cursos y usuarios que contabilicen cero.
Select C.Nombre as 'Nombre del curso', DAT.Nombres, DAT.Apellidos,
count(I.IDUsuario) as 'Cantidad de veces realizado'
From Cursos C
Inner Join Inscripciones I on C.ID = I.IDCurso
Inner Join Datos_Personales DAT on I.IDUsuario = DAT.ID
Group by C.Nombre, DAT.Nombres, DAT.Apellidos
Having count(I.IDUsuario) != 0
Order by count(I.IDUsuario) desc

-- 29  Listado con Apellidos y nombres, mail y duración total en concepto de clases de cursos a los que se haya inscripto. Sólo listar información de aquellos registros cuya duración total supere los 400 minutos.
Select DAT.Apellidos, DAT.Nombres, isnull(DAT.Email, '-') as 'Email', sum(CL.Duracion) as 'Duración total'
From Datos_Personales DAT
Inner Join Inscripciones I on DAT.ID = I.IDUsuario
Inner Join Cursos CUR on I.IDCurso = CUR.ID
Inner Join Clases CL on CUR.ID = CL.IDCurso
Group by DAT.Apellidos, DAT.Nombres, DAT.Email
Having sum(CL.Duracion) > 400

-- 30  Listado con nombre del curso y recaudación total. La recaudación total consiste en la sumatoria de costos de inscripción y de certificación. Listarlos ordenados de mayor a menor por recaudación.
Select C.Nombre, isnull(sum(I.Costo + CER.Costo),0)'Recaudación total'
From Cursos C
Left Join Inscripciones I ON c.ID = i.IDCurso
Left join Certificaciones CER on I.ID = CER.IDInscripcion
Group by C.Nombre
Order by [Recaudación total] desc

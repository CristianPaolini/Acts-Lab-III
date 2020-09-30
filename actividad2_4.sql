-- (1)  Listado con apellidos y nombres de los usuarios que no se hayan inscripto a cursos durante el año 2019.
Select DAT.Apellidos, DAT.Nombres
From Datos_Personales DAT
Where DAT.ID not in(
	Select I.IDUsuario
	From Inscripciones I
	Where Year(I.Fecha) = 2019
)

-- 2  Listado con apellidos y nombres de los usuarios que se hayan inscripto a cursos pero no hayan realizado ningún pago.
Select DAT.Apellidos, DAT.Nombres
From Datos_Personales DAT
Where DAT.ID not in(
	Select Distinct I.IDUsuario
	From Inscripciones I
	Inner Join Pagos P on I.ID = P.IDInscripcion
)

-- 3  Listado de países que no tengan usuarios relacionados.
Select P.Nombre From Paises P
Where P.ID not in(
	Select distinct DAT.IDPais
	From Datos_Personales DAT
)

-- (4)  Listado de clases cuya duración sea mayor a la duración promedio.
Select CL.Nombre, CL.Duracion From Clases CL
Where CL.Duracion > (
	Select avg(CL.Duracion)
	From Clases CL
)

-- (5)  Listado de contenidos cuyo tamaño sea mayor al tamaño de todos los contenidos de tipo 'Audio de alta calidad'.
Select * From Contenidos CONT
Where CONT.Tamaño > all (
	Select CONT.Tamaño From Contenidos CONT
	Inner Join TiposContenido TI on CONT.IDTipo = TI.ID
	Where TI.Nombre = 'Audio de alta calidad'
)

Select * From Contenidos CONT
Where CONT.Tamaño > (
	Select max(CONT.Tamaño) From Contenidos CONT
	Inner Join TiposContenido TI on CONT.IDTipo = TI.ID
	Where TI.Nombre = 'Audio de alta calidad'
)

-- 6  Listado de contenidos cuyo tamaño sea menor al tamaño de algún contenido de tipo 'Audio de alta calidad'.
Select * From Contenidos CONT
Where CONT.Tamaño < Any (
	Select CONT.Tamaño From Contenidos CONT
	Inner Join TiposContenido TI on CONT.IDTipo = TI.ID
	Where TI.Nombre Like 'Audio de alta calidad'
)

Select * From Contenidos CONT
Where CONT.Tamaño < (
	Select max(CONT.Tamaño) From Contenidos CONT
	Inner Join TiposContenido TI on CONT.IDTipo = TI.ID
	Where TI.Nombre = 'Audio de alta calidad'
)

-- (7)  Listado con nombre de país y la cantidad de usuarios de género masculino y la cantidad de usuarios de género femenino que haya registrado.
Select AUX.Nombre as País, AUX.[Cantidad género M], AUX.[Cantidad género F] From(
	Select P.Nombre,
	(
		Select count(*) From Datos_Personales DAT
		Where DAT.Genero Like 'M' and DAT.IDPais = P.ID
	) as 'Cantidad género M',
	(
		Select count(*) From Datos_Personales DAT
		Where DAT.Genero Like 'F' and DAT.IDPais = P.ID
	) as 'Cantidad género F'
	From Paises P
) as AUX

-- 8  Listado con apellidos y nombres de los usuarios y la cantidad de inscripciones realizadas en el 2019 y la cantidad de inscripciones realizadas en el 2020.
Select AUX.Apellidos, AUX.Nombres, AUX.[Cant. Insc. 2019], AUX.[Cant. Insc. 2020] From(
	Select DAT.Apellidos, DAT.Nombres,
	(
		Select count(*) From Inscripciones I
		Where YEAR(I.Fecha) = 2019 and I.IDUsuario = DAT.ID
	) as 'Cant. Insc. 2019',
	(
		Select count(*) From Inscripciones I
		Where YEAR(I.Fecha) = 2020 and I.IDUsuario = DAT.ID
	) as 'Cant. Insc. 2020'
	From Datos_Personales DAT
) as AUX

-- 9  Listado con nombres de los cursos y la cantidad de idiomas de cada tipo. Es decir, la cantidad de idiomas de audio, la cantidad de subtítulos y la cantidad de texto de video.
Select C.Nombre,
(
	Select count(*) From Idiomas_x_Curso IxC
	Inner Join TiposIdioma TI on IxC.IDTipo = TI.ID
	Where TI.Nombre Like '%audio%' and C.ID = IxC.IDCurso
) as 'Cantidad de Audio',
(
	Select count(*) From Idiomas_x_Curso IxC
	Inner Join TiposIdioma TI on IxC.IDTipo = TI.ID
	Where TI.Nombre Like '%subtítulo%' and C.ID = IxC.IDCurso
) as 'Cantidad de Subtítulo',
(
	Select count(*) From Idiomas_x_Curso IxC
	Inner Join TiposIdioma TI on IxC.IDTipo = TI.ID
	Where TI.Nombre Like '%texto%' and C.ID = IxC.IDCurso
) as 'Texto del Video'
From Cursos C

-- 10  Listado con apellidos y nombres de los usuarios, nombre de usuario y cantidad de cursos de nivel 'Principiante' que realizó y cantidad de cursos de nivel 'Avanzado' que realizó.
Select AUX.Apellidos, AUX.Nombres, AUX.[Cantidad Principiantes], AUX.[Cantidad Avanzados]
From(
	Select DAT.Apellidos, DAT.Nombres,
	(
		Select count(*) From Cursos C
		Inner Join Niveles N on C.IDNivel = N.ID
		Inner Join Inscripciones I on C.ID = I.IDCurso
		Where N.Nombre = 'Principiante' and I.IDUsuario = DAT.ID
	) as 'Cantidad Principiantes',
	(
		Select count(*) From Cursos C
		Inner Join Niveles N on C.IDNivel = N.ID
		Inner Join Inscripciones I on C.ID = I.IDCurso
		Where N.Nombre = 'Avanzado' and I.IDUsuario = DAT.ID
	) as 'Cantidad Avanzados'
	From Datos_Personales DAT
) as AUX

-- 11  Listado con nombre de los cursos y la recaudación de inscripciones de usuarios de género femenino que se inscribieron y la recaudación de inscripciones de usuarios de género masculino.
Select AUX.Nombre 'Nombre del curso', AUX.[Recaudación F], AUX.[Recaudación M] From(
	Select C.Nombre,
	(
		Select isnull(sum(I.Costo),0)
		From Inscripciones I
		Inner Join Datos_Personales DAT on I.IDUsuario = DAT.ID
		Where DAT.Genero Like 'F' and C.ID = I.IDCurso

	) as 'Recaudación F',
	(
		Select isnull(sum(I.Costo),0)
		From Inscripciones I
		Inner Join Datos_Personales DAT on I.IDUsuario = DAT.ID
		Where DAT.Genero Like 'M' and C.ID = I.IDCurso
	) as 'Recaudación M'
	From Cursos C
) as AUX

-- 12  Listado con nombre de país de aquellos que hayan registrado más usuarios de género masculino que de género femenino.
Select AUX.Nombre 'Países con más género M que F' From(
	Select P.Nombre,
	(
		Select count(*) From Datos_Personales DAT
		Where DAT.Genero = 'M' and P.ID = DAT.IDPais
	) as 'Cantidad M',
	(
Select count(*) From Datos_Personales DAT
		Where DAT.Genero = 'F' and P.ID = DAT.IDPais
		) as 'Cantidad F'
	From Paises P
)as AUX
Where AUX.[Cantidad M] > AUX.[Cantidad F]

-- 13  Listado con nombre de país de aquellos que hayan registrado más usuarios de género masculino que de género femenino pero que haya registrado al menos un usuario de género femenino.
Select AUX.Nombre 'Nombre del País' From(
	Select P.Nombre,
	(
		Select Count(*) From Datos_Personales DAT
		Where DAT.Genero Like 'M' and P.ID = DAT.IDPais
	) as 'Cant.M',
	(
		Select Count(*) From Datos_Personales DAT
		Where DAT.Genero Like 'F' and P.ID = DAT.IDPais
	) as 'Cant.F'
	From Paises P
) as AUX
Where AUX.[Cant.M] > AUX.[Cant.F] and AUX.[Cant.F] > 0

-- 14  Listado de cursos que hayan registrado la misma cantidad de idiomas de audio que de subtítulos.
Select * From(
	Select C.Nombre,
	(
		Select count(*) from Idiomas_x_Curso IxC
		Inner Join TiposIdioma TI on IxC.IDTipo = TI.ID
		Where TI.Nombre = 'audio' and C.ID = IxC.IDCurso
	) as 'Cant. Audio',
	(
		Select count(*) from Idiomas_x_Curso IxC
		Inner Join TiposIdioma TI on IxC.IDTipo = TI.ID
		Where TI.Nombre = 'subtítulo' and C.ID = IxC.IDCurso
	) as 'Cant. Sub'
	From Cursos C
) as AUX
Where AUX.[Cant. Audio] = AUX.[Cant. Sub]

-- 15  Listado de usuarios que hayan realizado más cursos en el año 2018 que en el 2019 y a su vez más cursos en el año 2019 que en el 2020.
Select AUX.NombreUsuario From(
	Select U.NombreUsuario,
	(
		Select count(*) From Inscripciones I
		Where year(I.Fecha) = 2018 and U.ID = I.IDUsuario
	) as 'Cant. 2018',
	(
		Select count(*) From Inscripciones I
		Where year(I.Fecha) = 2019 and U.ID = I.IDUsuario
	) as 'Cant. 2019',
	(
		Select count(*) From Inscripciones I
		Where year(I.Fecha) = 2020 and U.ID = I.IDUsuario
	) as 'Cant. 2020'
	From Usuarios U
)as AUX
Where AUX.[Cant. 2018] > AUX.[Cant. 2019] and AUX.[Cant. 2019] > AUX.[Cant. 2020]

-- 16  Listado de apellido y nombres de usuarios que hayan realizado cursos pero nunca se hayan certificado.
Select DAT.Apellidos, U.NombreUsuario 'Username'
From Datos_Personales DAT
Inner Join Usuarios U on DAT.ID = U.ID
Where DAT.ID in(
	Select distinct I.IDUsuario
	From Inscripciones I
)and DAT.ID not in(
	Select distinct I.IDUsuario
	From Inscripciones I
	Inner Join Certificaciones CER on I.ID = CER.IDInscripcion
)

Select AUX.Apellidos, AUX.NombreUsuario From(
	Select DAT.Apellidos, U.NombreUsuario,
	(
		Select Count(*) From Inscripciones I
		Where DAT.ID = I.IDUsuario
	) as 'Cantidad cursados',
	(
		Select Count(*) From Inscripciones I, Certificaciones CER
		Where DAT.ID = I.IDUsuario and CER.IDInscripcion = I.ID
	) as 'Cantidad Certificados'
	From Datos_Personales DAT
	inner join Usuarios U on DAT.ID = U.ID
) as AUX
Where AUX.[Cantidad cursados] > 0 and AUX.[Cantidad Certificados] = 0

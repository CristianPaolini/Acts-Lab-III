-- (1)  Listado con apellidos y nombres de los usuarios que no se hayan inscripto a cursos durante el año 2019.
Select DAT.Apellidos+ ', ' +DAT.Nombres [Apellido y Nombre]
From Datos_Personales DAT
Where DAT.ID Not in(
	Select distinct I.IdUsuario From Inscripciones I
	Where Year(Fecha) = 2019
)

-- 2  Listado con apellidos y nombres de los usuarios que se hayan inscripto a cursos pero no hayan realizado ningún pago.
Select DAT.Apellidos+ ', ' +DAT.Nombres [Apellido y Nombre]
From Datos_Personales DAT
Where DAT.ID not in(
	Select Distinct I.IDUsuario
	From Inscripciones I
	Inner Join Pagos P on P.ID = I.ID
)

-- 3  Listado de países que no tengan usuarios relacionados.
Select * From Paises P
Where P.ID Not In(
	Select Distinct P.ID
	From Paises
	Join Datos_Personales DAT on P.ID = DAT.IDPais
)

-- (4)  Listado de clases cuya duración sea mayor a la duración promedio.
Select C.Nombre, C.Duracion
From Clases C Where C.Duracion >(
	Select avg(C.Duracion)
	From Clases C
)

-- (5)  Listado de contenidos cuyo tamaño sea mayor al tamaño de todos los contenidos de tipo 'Audio de alta calidad'.
Select * From Contenidos
Where Tamaño > (
    Select Max(Tamaño) From Contenidos as C
    Inner Join TiposContenido as TC ON TC.ID = C.IDTipo
    Where TC.Nombre = 'Audio de alta calidad'
)

Select * From Contenidos
Where Tamaño > ALL (
    Select Tamaño From Contenidos as C
    Inner Join TiposContenido as TC ON TC.ID = C.IDTipo
    Where TC.Nombre = 'Audio de alta calidad'
)

-- 6  Listado de contenidos cuyo tamaño sea menor al tamaño de algún contenido de tipo 'Audio de alta calidad'.
Select * From Contenidos
Where Tamaño < (
	Select MAX(Tamaño) From Contenidos C
	Inner join TiposContenido TC on TC.ID = C.IDTipo
	Where TC.Nombre = 'Audio de alta calidad'
)

Select * From Contenidos
Where Tamaño < SOME(
	Select Tamaño From Contenidos C
	Inner Join TiposContenido TC on TC.ID = C.IDTipo
	Where TC.Nombre = 'Audio de alta calidad'
)

-- (7)  Listado con nombre de país y la cantidad de usuarios de género masculino y la cantidad de usuarios de género femenino que haya registrado.
Select P.Nombre, 
(
    Select Count(*) From Datos_Personales Where Genero = 'F' And IDPais = P.ID
) As CantF, 
(
    Select Count(*) From Datos_Personales Where Genero = 'M' And IDPais = P.ID
) as CantM
From Paises as P

Select P.Nombre,
(
	Select Count(*) From Datos_Personales DAT Where DAT.Genero = 'M' And DAT.IDPais = P.ID
)As CantM,
(
	Select Count(*) From Datos_Personales DAT Where DAT.Genero = 'F' And DAT.IDPais = P.ID
)As CantF
From Paises P

-- 8  Listado con apellidos y nombres de los usuarios y la cantidad de inscripciones realizadas en el 2019 y la cantidad de inscripciones realizadas en el 2020.
Select DAT.Apellidos+ ', ' +DAT.Nombres [Apellido y Nombre],
(
	Select Count(I.IdUsuario)
	From Inscripciones I Where YEAR(I.Fecha) = 2019 and DAT.ID = I.IDUsuario
	) As [Inscripciones 2019],
(
	Select Count(I.IdUsuario)
	From Inscripciones I Where YEAR(I.Fecha) = 2020 and DAT.ID = I.IDUsuario
	) As [Inscripciones 2020]
	From Datos_Personales DAT

-- 9  Listado con nombres de los cursos y la cantidad de idiomas de cada tipo. Es decir, la cantidad de idiomas de audio, la cantidad de subtítulos y la cantidad de texto de video.
Select C.Nombre,
(
	Select Count(TC.ID)
	From TiposContenido TC
	Inner Join Contenidos CONT on CONT.IDTipo = TC.ID
	Inner Join Clases CLA on CLA.ID = CONT.IDClase
	Where TC.Nombre Like '%audio%' and C.ID = CLA.IDCurso
) [Cantidad Idiomas Audio],
(
	Select Count(TC.ID)
	From TiposContenido TC
	Inner Join Contenidos CONT on CONT.IDTipo = TC.ID
	Inner Join Clases CLA on CLA.ID = CONT.IDClase
	Where TC.Nombre Like '%texto%' and C.ID = CLA.IDCurso
) [Cantidad Idiomas Subtítulo],
(
	Select Count(TC.ID)
	From TiposContenido TC
	Inner Join Contenidos CONT on CONT.IDTipo = TC.ID
	Inner Join Clases CLA ON CLA.ID = CONT.IDClase
	Where TC.Nombre Like '%video%' and C.ID = CLA.IDCurso
) [Cantidad Idiomas Video]
From Cursos C

-- 10  Listado con apellidos y nombres de los usuarios, nombre de usuario y cantidad de cursos de nivel 'Principiante' que realizó y cantidad de cursos de nivel 'Avanzado' que realizó.
Select DAT.Apellidos+ ', ' +DAT.Nombres as [Apellido y Nombre],
U.NombreUsuario,
(
	Select Count(C.ID)
	From Cursos C
	Inner Join Niveles N on N.ID = C.IDNivel
	Inner Join Inscripciones I on I.IDCurso = C.ID
	Where N.Nombre Like '%Principiante%' and I.IDUsuario = U.ID)[Cantidad de Principiantes],
(
	Select Count(C.ID)
	From Cursos C
	Inner Join Niveles N on N.ID = C.IDNivel
	Inner Join Inscripciones I on I.IDCurso = C.ID
	Where N.Nombre Like '%Avanzado%' and I.IDUsuario = U.ID)[Cantidad de Avanzados]
From Usuarios U
Inner Join Datos_Personales DAT on DAT.ID = U.ID

-- 11  Listado con nombre de los cursos y la recaudación de inscripciones de usuarios de género femenino que se inscribieron y la recaudación de inscripciones de usuarios de género masculino.
Select C.Nombre,
(
	Select IsNull(Sum(I.Costo),0)
	From Inscripciones I
	Inner Join Usuarios U on I.IDUsuario = U.ID
	Inner Join Datos_Personales DAT on DAT.ID = U.ID
	Where DAT.Genero Like '%F%' and C.ID = I.IDCurso)[Cant. Rec. Usuarios F],
(
	Select IsNull(Sum(I.Costo),0)
	From Inscripciones I
	Inner Join Usuarios U on I.IDUsuario = U.ID
	Inner Join Datos_Personales DAT on DAT.ID = U.ID
	Where DAT.Genero Like '%M%' and C.ID = I.IDCurso)[Cant. Rec. Usuarios M]
From Cursos C

-- 12  Listado con nombre de país de aquellos que hayan registrado más usuarios de género masculino que de género femenino.
Select * From (
    Select P.Nombre, 
    (
        Select Count(*) From Datos_Personales Where Genero = 'F' And IDPais = P.ID
    ) As CantF, 
    (
        Select Count(*) From Datos_Personales Where Genero = 'M' And IDPais = P.ID
    ) as CantM
    From Paises as P
) as AUX
Where AUX.CantM > Aux.CantF

-- 13  Listado con nombre de país de aquellos que hayan registrado más usuarios de género masculino que de género femenino pero que haya registrado al menos un usuario de género femenino.
Select AUX.Nombre From (
	Select P.Nombre,
	(
		Select Count(*) From Datos_Personales DAT Where Genero Like '%M%' And P.ID = DAT.IDPais
	)[Cantidad Masculinos],
	(
		Select Count(*) From Datos_Personales DAT Where Genero Like '%F%' And P.Id = DAT.IDPais
	)[Cantidad Femeninos]
	From Paises P
) as AUX
  Where AUX.[Cantidad Masculinos] > AUX.[Cantidad Femeninos] And AUX.[Cantidad Femeninos] >= 1

-- 14  Listado de cursos que hayan registrado la misma cantidad de idiomas de audio que de subtítulos.
Select AUX.Nombre From (
	Select C.Nombre,
	(
		Select Count(CONT.IDTipo) 
		from Contenidos CONT
		Inner Join Clases CL on CONT.IDClase = CL.ID
		Inner Join TiposContenido TC on CONT.IDTipo = TC.ID
		Where TC.Nombre Like '%audio%' and CL.IDCurso = C.ID
		)[Cantidad de Audio],

		(
		Select Count(CONT.IDTipo)
		FROM Contenidos CONT
		Inner Join Clases CL on Cont.IDClase = CL.ID
		Inner Join TiposContenido TC on Cont.IDTipo = TC.ID
		Where TC.Nombre Like '%texto%' and CL.IDCurso = C.ID
		)[Cantidad de Subtítulos]
		From Cursos C
) as AUX
Where AUX.[Cantidad de Audio] = AUX.[Cantidad de Subtítulos]

-- 15  Listado de usuarios que hayan realizado más cursos en el año 2018 que en el 2019 y a su vez más cursos en el año 2019 que en el 2020.
Select AUX.NombreUsuario Usuario From (
	Select U.NombreUsuario,
	(
		Select Count(I.Fecha)
		From Inscripciones I
		Where Year(I.Fecha) = 2018 and I.IDUsuario = U.ID 
		)[Cantidad 2018],

		(
		Select Count(I.Fecha)
		From Inscripciones I
		Where Year(Fecha) = 2019 and I.IDUsuario = U.ID
		)[Cantidad 2019],
		
		(
		Select Count(I.Fecha)
		From Inscripciones I
		Where Year(Fecha) = 2020 and I.IDUsuario = U.ID
		)[Cantidad 2020]
		From Usuarios U
)as AUX
Where AUX.[Cantidad 2018] > AUX.[Cantidad 2019] and AUX.[Cantidad 2019] > AUX.[Cantidad 2020]

-- 16  Listado de apellido y nombres de usuarios que hayan realizado cursos pero nunca se hayan certificado.
Select AUX.[Apellido y Nombre]
From (
		Select DAT.Apellidos+ ', ' +DAT.Nombres [Apellido y Nombre],
	(
		Select Count(I.IDUsuario)
		From Inscripciones I
		Where I.IDUsuario = DAT.ID 
		)[Cantidad de Inscripciones],
	(
		Select Count(C.IDInscripcion)
		From Certificaciones C
		Inner Join Inscripciones I on C.IDInscripcion = I.ID
		Where I.IDUsuario = DAT.ID 
		)[Cantidad de Certificaciones]
		From Datos_Personales DAT
	) as AUX
Where AUX.[Cantidad de Inscripciones] > AUX.[Cantidad de Certificaciones]

-- (1)  Listado con la cantidad de cursos.
Select count(*) as [Cantidad de Cursos] From Cursos

-- 2  Listado con la cantidad de usuarios.
Select count(*) as [Cantidad de Usuarios] From Usuarios

-- (3)  Listado con el promedio de costo de certificación de los cursos.
Select avg(CostoCertificacion) as [Prom. Costo Certificación] From Cursos

-- 4  Listado con el promedio general de calificación de reseñas.
Select avg(Puntaje) as [Promedio Reseñas] From Reseñas

-- (5)  Listado con la fecha de estreno de curso más antigua.
Select min(Estreno) as [Fecha Estreno más Antigua] From Cursos

-- 6  Listado con el costo de certificación menos costoso.
Select min(CostoCertificacion) as [Certificado menos costoso] 
From Cursos

-- (7)  Listado con el costo total de todos los cursos.
Select sum(CostoCurso) as [Costo Total] From Cursos

-- 8  Listado con la suma total de todos los pagos.
Select sum(Importe) as [Suma de todos los Pagos] From Pagos

-- 9  Listado con la cantidad de cursos de nivel principiante.
Select count(C.ID) as [Cantidad de Cursos Nivel Principiante]
From Cursos as C
Inner join Niveles as N on C.IDNivel = N.ID
Where N.Nombre Like 'Principiante'

-- 10  Listado con la suma total de todos los pagos realizados en 2019.
Select sum(P.Importe) as [Total Pagos 2019]
From Pagos as P Where Year(Fecha) = 2019

-- (11)  Listado con la cantidad de usuarios que son instructores.
Select count(Distinct I.IDUsuario) as [Total Usuarios Instructores]
From Instructores_x_Curso as I

-- 12  Listado con la cantidad de usuarios distintos que se hayan certificado.
Select count(Distinct I.IDUsuario) as [Total Certificados] 
From Inscripciones as I
Inner join Certificaciones as C on I.ID = C.IDInscripcion


-- (13)  Listado con el nombre del país y la cantidad de usuarios de cada país.
select P.Nombre, count(DAT.ID) as Cantidad from Paises as P
left join Datos_Personales as DAT
on P.ID = DAT.IDPais
group by P.Nombre
order by 2 desc

-- (14)  Listado con el apellido y nombres del usuario y el importe más costoso abonado como pago. Sólo listar aquellos que hayan abonado más de $7500.
Select DAT.Apellidos, Dat.Nombres, max(P.Importe) as [Mayor Importe]
From Datos_Personales as DAT
Inner join Usuarios as U on DAT.ID = U.ID
Inner join Inscripciones as I on U.ID = I.IDUsuario
Inner join Pagos as P on I.ID = P.IDInscripcion
Group by DAT.Apellidos, DAT.Nombres
Having max(P.Importe) > 7500


-- 15  Listado con el apellido y nombres de usuario y el importe más costoso de curso al cual se haya inscripto.
SELECT DAT.Apellidos, DAT.Nombres, MAX(I.Costo) AS [Curso más Costoso]
From Datos_Personales as DAT
inner join Usuarios as U ON DAT.ID = U.ID
inner join Inscripciones as I ON U.ID = I.IDUsuario
inner join Pagos as P ON I.ID = p.IDInscripcion
Group by DAT.Apellidos, DAT.Nombres

-- 16  Listado con el nombre del curso, nombre del nivel, cantidad total de clases y duración total del curso en minutos.
Select C.Nombre as [Nombre Curso], N.Nombre as Nivel, Count(CL.ID) as [Cantidad de Clases], SUM(CL.Duracion) as [Duración Total en Mins]
From Cursos as C
left join Niveles as N ON C.IDNivel = N.ID
left join Clases as CL ON C.ID = CL.IDCurso
group by C.Nombre, n.Nombre

-- 17  Listado con el nombre del curso y cantidad de contenidos registrados. Sólo listar aquellos cursos que tengan más de 10 contenidos registrados.
Select C.Nombre, Count(Contenidos.ID) as [Contenidos Registrados]
From Cursos AS C
Inner join Clases on C.ID = Clases.IDCurso
Inner join Contenidos on Clases.ID = Contenidos.IDClase
Group by C.Nombre
Having Count(Contenidos.ID) > 10

-- 18  Listado con nombre del curso, nombre del idioma y cantidad de tipos de idiomas.
Select C.Nombre, I.Nombre, Count(IxC.IDTipo) as [Cantidad de Tipos]
From Cursos AS C
Inner join Idiomas_x_Curso as IxC ON C.ID = IxC.IDCurso
Inner join Idiomas as I ON Ixc.IDIdioma = I.ID
Group by C.Nombre, I.Nombre

-- 19  Listado con el nombre del curso y cantidad de idiomas distintos disponibles.
Select C.Nombre as [Nombre del Curso], Count(Distinct I.ID) AS [Cantidad de Idiomas]
FROM Cursos as C
Inner join Idiomas_x_Curso as IxC ON C.ID = IxC.IDCurso
Inner join Idiomas as I ON IxC.IDIdioma = I.ID
Group By C.Nombre

-- 20  Listado de categorías de curso y cantidad de cursos asociadas a cada categoría. Sólo mostrar las categorías con más de 5 cursos.
Select CAT.Nombre as [Nombre Categoría], Count(CxC.IDCategoria) as [Cantidad de Cursos Asociados]
From Categorias as CAT
Join Categorias_x_Curso as CxC ON cat.ID = CxC.IDCategoria
Group By CAT.Nombre
Having Count(CxC.IDCategoria) > 5

-- 21  Listado con tipos de contenido y la cantidad de contenidos asociados a cada tipo. Mostrar aquellos tipos que no hayan registrado contenidos con cantidad 0.
Select TC.Nombre as [Nombre Categoría], Count(C.ID) as [Contenidos Asociados]
from TiposContenido as TC
join Contenidos as C ON TC.ID=C.IDTipo
Group by TC.Nombre

-- 22  Listado con Nombre del curso, nivel, año de estreno y el total recaudado en concepto de inscripciones. Listar aquellos cursos sin inscripciones con total igual a $0.
Select C.Nombre as [Nombre Curso], N.Nombre as Nivel, year(C.Estreno) as [Año Estreno], sum(I.Costo) as [Total Inscripciones]
From Cursos as C
left join Niveles as N ON C.IDNivel = N.ID
left join Inscripciones as I ON C.ID = I.IDCurso
Group By C.Nombre, N.Nombre, c.Estreno

Select C.Nombre as Curso,N.Nombre as Nivel,year(C.Estreno) as AñoEstreno,sum(case when p.importe is null then 0 else p.Importe end) as TotalRecaudado
From Cursos as c
left join Niveles as N on C.IDNivel=n.ID
left join Inscripciones as i on c.ID=i.IDCurso
Left join Pagos as p on i.ID=p.IDInscripcion
group by C.Nombre,n.Nombre,c.Estreno

-- 23  Listado con Nombre del curso, costo de cursado y certificación y cantidad de usuarios distintos inscriptos cuyo costo de cursado sea menor a $10000 y cuya cantidad de usuarios inscriptos sea menor a 5. Listar aquellos cursos sin inscripciones con cantidad 0.
Select C.Nombre, C.costocurso, C.costocertificacion, count (distinct I.IDUsuario)as CantInscrip From Cursos as C
Inner Join Inscripciones as I
On C.ID= I.IDCurso
Where C.costocurso <10000
Group by C.Nombre, C.costocurso, C.costocertificacion
having count (I.IDUsuario) <5 

-- 24  Listado con Nombre del curso, fecha de estreno y nombre del nivel del curso que más recaudó en concepto de certificaciones.
Select top(1) C.Nombre as Curso, C.Estreno as [Fecha Estreno], N.Nombre as [Nombre Nivel]
From Cursos AS C
JOIN Niveles as N on C.IDNivel = N.ID
JOIN Inscripciones as I on C.ID = i.IDCurso
join Certificaciones as CER ON I.ID = CER.IDInscripcion
Group BY C.Nombre, C.Estreno, N.Nombre
Order by sum(CER.Costo) 

-- 25  Listado con Nombre del idioma del idioma más utilizado como subtítulo.
Select top(1) I.Nombre as [Más usado como Subtítulo]
From Idiomas as I
join Idiomas_x_Curso as IxC on I.ID = IxC.IDIdioma
join TiposIdioma as TI on IxC.IDTipo = TI.ID
Where TI.Nombre LIKE 'Subtítulo'

-- 26  Listado con Nombre del curso y promedio de puntaje de reseñas apropiadas.
Select C.Nombre, avg(R.Puntaje) as [Promedio de Puntaje]
From Cursos as C
Join Inscripciones as I on C.ID = I.IDCurso
join Reseñas as R on I.ID=R.IDInscripcion
Where R.Inapropiada = 0
Group by C.Nombre

-- 27  Listado con Nombre de usuario y la cantidad de reseñas inapropiadas que registró.
Select U.NombreUsuario, Count(R.Inapropiada) as [Cantidad Inapropiadas]
From Usuarios as U
join Inscripciones as I on U.ID = I.IDUsuario
join Reseñas as R on I.ID=R.IDInscripcion
Where R.Inapropiada=1
Group by U.NombreUsuario

-- 28  Listado con Nombre del curso, nombre y apellidos de usuarios y la cantidad de veces que dicho usuario realizó dicho curso. No mostrar cursos y usuarios que contabilicen cero.
Select C.Nombre, DAT.Nombres, DAT.Apellidos, count(I.ID) as [Cantidad de veces realizado]
From Cursos as C
Inner join Inscripciones as I on C.ID=I.IDCurso
Inner join Usuarios as U on I.IDUsuario=U.ID
Inner join Datos_Personales as DAT on U.ID=DAT.ID
group by C.Nombre, DAT.Nombres, DAT.Apellidos
order by COUNT(I.ID) desc;


-- 29  Listado con Apellidos y nombres, mail y duración total en concepto de clases de cursos a los que se haya inscripto. Sólo listar información de aquellos registros cuya duración total supere los 400 minutos.
Select DAT.Apellidos, DAT.Nombres, sum(CL.Duracion) as [Duración Total]
From Datos_Personales as DAT
join Usuarios as U on DAT.ID=U.ID
join Inscripciones as I on U.ID=I.IDUsuario
join Cursos as C on I.IDCurso=C.ID
join Clases as CL on C.ID=CL.IDCurso
Group by DAT.Apellidos, DAT.Nombres
Having sum(CL.Duracion)>1200
Order by(DAT.Apellidos)

-- 30  Listado con nombre del curso y recaudación total. La recaudación total consiste en la sumatoria de costos de inscripción y de certificación. Listarlos ordenados de mayor a menor por recaudación.
Select C.Nombre as [Nombre del Curso], sum(I.Costo + Cer.Costo) as [Recaudación Total]
From Cursos as C
Inner join Inscripciones as I on C.ID=I.IDCurso
Inner join Certificaciones as Cer on I.ID=Cer.IDInscripcion
Group by C.Nombre
Order by [Recaudación Total] desc

#Proyecto SQL

#Script Crear Base de Datos:
CREATE SCHEMA `proyecto_sql` ;

#Script Crear las tablas:
#Tabla Estudiante
CREATE TABLE `proyecto_sql`.`estudiantes` (
  `id_estudiantes` INT NOT NULL AUTO_INCREMENT,
  `nombres_estudiantes` VARCHAR(45) NOT NULL,
  `apellidos_estudiantes` VARCHAR(45) NOT NULL,
  `email_estudiantes` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_estudiantes`),
  UNIQUE INDEX `id_estudiantes_UNIQUE` (`id_estudiantes` ASC) VISIBLE);

#Tabla Profesores:
CREATE TABLE `proyecto_sql`.`profesores` (
  `id_profesores` INT NOT NULL AUTO_INCREMENT,
  `nombres_profesores` VARCHAR(45) NOT NULL,
  `apellidos_profesores` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_profesores`),
  UNIQUE INDEX `id_profesores_UNIQUE` (`id_profesores` ASC) VISIBLE);


#Tabla cursos:
CREATE TABLE `proyecto_sql`.`cursos` (
  `id_cursos` INT NOT NULL AUTO_INCREMENT,
  `nombre_cursos` VARCHAR(45) NOT NULL,
  `id_profesor_cursos` INT NOT NULL,
  PRIMARY KEY (`id_cursos`),
  UNIQUE INDEX `id_cursos_UNIQUE` (`id_cursos` ASC) VISIBLE,
  INDEX `id_profesor_cursos_idx` (`id_profesor_cursos` ASC) VISIBLE,
  CONSTRAINT `id_profesor_cursos`
    FOREIGN KEY (`id_profesor_cursos`)
    REFERENCES `proyecto_sql`.`profesores` (`id_profesores`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT);


#Tabla calificaciones:
CREATE TABLE `proyecto_sql`.`calificaciones` (
  `id_calificaciones` INT NOT NULL AUTO_INCREMENT,
  `calificacion_obtenida` DECIMAL NOT NULL,
  `id_curso_calificacion` INT NOT NULL,
  `id_estudiante_calificacion` INT NOT NULL,
  PRIMARY KEY (`id_calificaciones`),
  UNIQUE INDEX `id_calificaciones_UNIQUE` (`id_calificaciones` ASC) VISIBLE,
  INDEX `id_estudiante_calificacion_idx` (`id_estudiante_calificacion` ASC) VISIBLE,
  CONSTRAINT `id_estudiante_calificacion`
    FOREIGN KEY (`id_estudiante_calificacion`)
    REFERENCES `proyecto_sql`.`estudiantes` (`id_estudiantes`)
    ON DELETE CASCADE
  ON UPDATE RESTRICT);

ALTER TABLE `proyecto_sql`.`calificaciones` 
ADD INDEX `id_curso_calificacion_idx` (`id_curso_calificacion` ASC) VISIBLE;
ALTER TABLE `proyecto_sql`.`calificaciones` 
ADD CONSTRAINT `id_curso_calificacion`
  FOREIGN KEY (`id_curso_calificacion`)
  REFERENCES `proyecto_sql`.`cursos` (`id_cursos`)
  ON DELETE CASCADE
  ON UPDATE RESTRICT;



#Scripts de Consultas

#Script Nota Media de cada Profesor (Metodo 1):
SELECT nombres_profesores AS Nombre, apellidos_profesores AS Apellido, AVG(calificacion_obtenida) AS Nota_Media
FROM profesores p, cursos cu, calificaciones ca
WHERE p.id_profesores = cu.id_profesor_cursos 
AND ca.id_curso_calificacion = cu.id_cursos
GROUP BY nombres_profesores, apellidos_profesores;

#Metodo 2:
SELECT nombres_profesores AS Nombre , apellidos_profesores AS Apellido , AVG(calificacion_obtenida) AS Nota_media
FROM profesores p
JOIN cursos cu
ON p.id_profesores = cu.id_profesor_cursos
JOIN calificaciones ca
ON ca.id_curso_calificacion = cu.id_cursos
GROUP BY nombres_profesores, apellidos_profesores;



#Script Mejores calificaciones de cada estudiante (Metodo 1):
SELECT nombres_estudiantes AS Nombre, apellidos_estudiantes AS Apellido, MAX(calificacion_obtenida) AS Maxima_nota
FROM estudiantes e,  calificaciones ca
WHERE e.id_estudiantes = ca.id_estudiante_calificacion
GROUP BY nombres_estudiantes, apellidos_estudiantes;

#Metodo 2:
SELECT nombres_estudiantes AS Nombre, apellidos_estudiantes AS apellido, MAX(calificacion_obtenida) AS Maxima_nota
FROM estudiantes e
JOIN calificaciones ca
ON e.id_estudiantes = ca.id_estudiante_calificacion
GROUP BY nombres_estudiantes, apellidos_estudiantes;



#Script Ordenar a los estudiantes por los cursos que estan inscritos (Metodo 1):
SELECT nombres_estudiantes AS Nombre, apellidos_estudiantes AS Apellido, nombre_cursos AS Curso
FROM estudiantes e,  calificaciones ca, cursos cu
WHERE e.id_estudiantes = ca.id_estudiante_calificacion
AND ca.id_curso_calificacion = cu.id_cursos
GROUP BY nombres_estudiantes, apellidos_estudiantes, nombre_cursos
ORDER BY nombre_cursos ASC;

#Metodo 2:
SELECT nombres_estudiantes AS Nombre, apellidos_estudiantes AS Apellido, nombre_cursos AS curso
FROM estudiantes e
JOIN calificaciones ca
ON e.id_estudiantes = ca.id_estudiante_calificacion
JOIN cursos cu
ON ca.id_curso_calificacion = cu.id_cursos
GROUP BY nombres_estudiantes, apellidos_estudiantes, nombre_cursos
ORDER BY nombre_cursos ASC;



-- Script Crear un informe resumido de los cursos y sus calificaciones, ordenados desde el curso mas dificil (curso con la 
-- 	calificacion promedio mas baja) hasta el curso mas facil:
SELECT nombre_cursos AS Cursos, AVG(calificacion_obtenida) AS Nota_media
FROM cursos cu, calificaciones ca
WHERE ca.id_curso_calificacion = cu.id_cursos
GROUP BY nombre_cursos
ORDER BY Nota_media ASC;



#Script Saber que estudiante y que profesor tienen mas cursos en comun:
SELECT nombres_estudiantes AS Nombre_estudiante, nombres_profesores AS Nombre_profesor, COUNT(*) AS Clases_comun
FROM calificaciones ca
JOIN estudiantes e
ON ca.id_estudiante_calificacion = e.id_estudiantes
JOIN cursos cu
ON ca.id_curso_calificacion = cu.id_cursos
JOIN profesores p
ON cu.id_profesor_cursos = p.id_profesores
GROUP BY Nombre_estudiante, Nombre_profesor
ORDER BY Clases_comun DESC;

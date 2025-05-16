CREATE SCHEMA teste;

CREATE TABLE teste.cursos_de_programacao(
 id_curso INTEGER PRIMARY KEY,
 nome_curso VARCHAR(255) NOT NULL
); 

INSERT INTO teste.cursos_de_programacao

SELECT academico.curso.id,
		academico.curso.nome
FROM academico.curso
JOIN academico.categoria ON academico.categoria.id = academico.curso.categoria_id
WHERE categoria_id = 2;

SELECT * FROM teste.cursos_de_programacao;

BEGIN;
DELETE  FROM teste.cursos_de_programacao;
ROLLBACK;

BEGIN;
DELETE  FROM teste.cursos_de_programacao;
COMMIT;

SELECT * FROM teste.cursos_de_programacao;


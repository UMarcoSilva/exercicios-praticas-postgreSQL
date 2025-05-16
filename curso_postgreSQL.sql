--- CRIANDO TABELAS E ALIMENTANDO ELAS, MUITOS PARA MUITOS

CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);

INSERT INTO aluno (primeiro_nome, ultimo_nome, data_nascimento) VALUES (
	'Vinicius', 'Dias', '1997-10-15'
), (
	'Patricia', 'Freitas', '1986-10-25'
), (
	'Diogo', 'Oliveira', '1984-08-27'
), (
	'Maria', 'Rosa', '1985-01-01'
);

INSERT INTO categoria (nome) VALUES ('Front-end'), ('Programação'), ('Bancos de dados'), ('Data Science');


INSERT INTO curso (nome, categoria_id) VALUES
	('HTML', 1),
	('CSS', 1),
	('JS', 1),
	('PHP', 2),
	('Java', 2),
	('C++', 2),
	('PostgreSQL', 3),
	('MySQL', 3),
	('Oracle', 3),
	('SQL Server', 3),
	('SQLite', 3),
	('Pandas', 4),
	('Machine Learning', 4),
	('Power BI', 4);INSERT INTO curso (nome, categoria_id) VALUES
	('HTML', 1),
	('CSS', 1),
	('JS', 1),
	('PHP', 2),
	('Java', 2),
	('C++', 2),
	('PostgreSQL', 3),
	('MySQL', 3),
	('Oracle', 3),
	('SQL Server', 3),
	('SQLite', 3),
	('Pandas', 4),
	('Machine Learning', 4),
	('Power BI', 4);

INSERT INTO aluno_curso VALUES (1, 4), (1, 11), (2, 1), (2, 2), (3, 4), (3, 3), (4, 4), (4, 6), (4, 5);

  SELECT aluno.primeiro_nome,
         aluno.ultimo_nome,
		 COUNT(aluno_curso.curso_id) numero_cursos
    FROM aluno
	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
GROUP BY 1, 2
ORDER BY numero_cursos DESC
   LIMIT 1;
   
   SELECT curso.nome,
      COUNT (aluno_curso.curso_id) AS numero_alunos
   FROM curso
   JOIN aluno_curso ON aluno_curso.curso_id = curso.id
   GROUP BY (id)
   ORDER BY numero_alunos DESC;

   SELECT categoria.nome,
      COUNT (aluno_curso.curso_id) AS numero_alunos
   FROM categoria
   JOIN aluno_curso ON aluno_curso.curso_id = categoria.id
   GROUP BY (id)
   ORDER BY numero_alunos DESC;

-- ANINHANDO FILTROS

SELECT curso.nome FROM curso WHERE categoria_id IN (
	SELECT id FROM categoria WHERE nome NOT LIKE ('% %')
);


  SELECT curso.nome,
         COUNT(aluno_curso.aluno_id) numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
     HAVING COUNT(aluno_curso.aluno_id) > 2
ORDER BY numero_alunos DESC;


SELECT curso.nome,
COUNT (aluno_curso.aluno_id) AS  numero_alunos
FROM curso
JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1;

  SELECT t.curso,
         t.numero_alunos
    FROM (
        SELECT curso.nome AS curso,
               COUNT(aluno_curso.aluno_id) numero_alunos
          FROM curso
          JOIN aluno_curso ON aluno_curso.curso_id = curso.id
      GROUP BY 1
    ) AS t
    WHERE t.numero_alunos > 2
  ORDER BY t.numero_alunos DESC;

--APRENDENDO FUNCOES E VIEW'S

SELECT CONCAT(primeiro_nome, ' ', ultimo_nome) AS nome_completo,
EXTRACT (YEAR FROM AGE(data_nascimento)) as idade
FROM aluno;

SELECT categoria.id, vw_cursos_por_categoria.*
FROM vw_cursos_por_categoria
JOIN categoria ON categoria.nome = vw_cursos_por_categoria.categoria;

CREATE VIEW vw_cursos_por_categoria AS SELECT categoria.nome AS categoria,
						COUNT(curso.id) AS numero_cursos
					FROM categoria
					JOIN curso ON curso.categoria_id = categoria.id
					GROUP BY categoria


SELECT * FROM aluno_curso;

SELECT * FROM vw_cursos_por_categoria;

CREATE VIEW vw_cursos_programacao AS SELECT nome FROM curso WHERE categoria_id = 2;
SELECT * FROM vw_cursos_programacao;
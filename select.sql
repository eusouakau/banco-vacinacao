/* 1 - Consulta quais cidadãos ainda não tomaram a segunda dose da vacina */
SELECT 
    c.nome,
    c.cpf,
    c.idade,
    d.data_aplicacao,
    d.data_retorno
FROM cidadao c
INNER JOIN dose d
ON c.id_cidadao = d.id_cidadao
WHERE d.data_retorno > SYSDATE;

/* 2 - Consulta quantas pessoas foram vacinadas, separadas pela idade e vacina*/
SELECT
    c.idade,
    v.id_vacina,
    COUNT(c.id_cidadao) as quant
FROM cidadao c
INNER JOIN dose d
ON c.id_cidadao = d.id_cidadao
INNER JOIN vacina v
ON d.id_vacina = v.id_vacina
WHERE d.data_aplicacao < SYSDATE
GROUP BY 
    c.idade,
    v.id_vacina
ORDER BY c.idade DESC;

/* 3 - Consulta quantas doses foram aplicadas, separados por posto e vacina */
SELECT
    p.nome,
    v.id_vacina,
    v.nome_fabricante,
    COUNT(d.id_cidadao) as quant
FROM possui ps
INNER JOIN posto p
ON ps.id_posto = p.id_posto
INNER JOIN vacina v
ON ps.id_vacina = v.id_vacina
INNER JOIN dose d
ON v.id_vacina = d.id_vacina
GROUP BY
    p.nome,
    v.id_vacina,
    v.nome_fabricante
HAVING COUNT(d.id_cidadao) > 1;

/* 4 - Consulta quais vacinas não utilizaram todas as doses, sendo que cada lote tenha 10 doses */
SELECT
    v.id_vacina,
    v.lote,
    COUNT(d.id_dose) as quant
FROM vacina v
INNER JOIN dose d
ON v.id_vacina = d.id_vacina
GROUP BY
    v.id_vacina,
    v.lote
HAVING COUNT(d.id_dose) < 10;

/* 5 - Consulta qual posto que vacinou cidadãos com idade maior que 60 anos, vacina do fabricante c */
SELECT
    p.nome,
    v.id_vacina,
    v.lote,
    c.nome,
    c.cpf,
    c.idade
FROM posto p
INNER JOIN possui ps
ON p.id_posto = ps.id_posto
INNER JOIN vacina v
ON v.id_vacina = ps.id_vacina
INNER JOIN dose d
ON d.id_vacina = v.id_vacina
INNER JOIN cidadao c
ON c.id_cidadao = d.id_cidadao
WHERE UPPER( v.nome_fabricante ) = 'FABRICANTE C' and c.idade >= 60;

/* 6 - Consulta a media de idade das pessoas que receberam vacina de um determinado lote */
SELECT
    v.lote,
    AVG(c.idade) as media_idade
FROM vacina v
INNER JOIN dose d
ON v.id_vacina = d.id_vacina
INNER JOIN cidadao c
ON c.id_cidadao = d.id_cidadao
GROUP BY v.lote
HAVING AVG(c.idade) > 40;

/* 7 - Consulta qual posto vacinou cidadãos com a media de idade acima de 60 anos */
SELECT
    p.nome,
    COUNT(c.id_cidadao) as quant,
    AVG(c.idade) as media_idade
FROM posto p
INNER JOIN possui ps
ON p.id_posto = ps.id_posto
INNER JOIN vacina v
ON v.id_vacina = ps.id_vacina
INNER JOIN dose d
ON d.id_vacina = v.id_vacina
INNER JOIN cidadao c
ON c.id_cidadao = d.id_cidadao
GROUP BY p.nome
HAVING AVG(c.idade) >= 60;
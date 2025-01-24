CREATE TABLE Operadora_ativas (
    registro_ans SERIAL PRIMARY KEY,
    cnpj VARCHAR(18) NOT NULL,
    razao_social VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(100),
    logradouro VARCHAR(255),
    numero VARCHAR(20),
    complemento VARCHAR(255),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2),
    cep VARCHAR(10),
    ddd CHAR(2),
    telefone VARCHAR(20),
    fax VARCHAR(20),
    endereco_eletronico VARCHAR(255),
    representante VARCHAR(255),
    cargo_representante VARCHAR(255),
    data_registro_ans DATE
);


CREATE TABLE conta_contabil (
    data_referencia DATE,
    reg_ans INT NOT NULL,
    cd_conta_contabil VARCHAR(50),
    descricao VARCHAR(255),
    vl_saldo_inicial NUMERIC(15, 2),
    vl_saldo_final NUMERIC(15, 2)
);

CREATE TEMPORARY TABLE conta_contabil_temporaria (
    data_referencia DATE,
    reg_ans INT NOT NULL,
    cd_conta_contabil VARCHAR(50),
    descricao VARCHAR(255),
    vl_saldo_inicial VARCHAR(100),
    vl_saldo_final VARCHAR(100)
);

COPY Operadora_ativas FROM 'C:/Program Files/PostgreSQL/17/Dados/Relatorio_cadop.csv' DELIMITER ';' CSV HEADER ENCODING 'ISO-8859-1'
COPY conta_contabil_temporaria FROM 'C:\Program Files\PostgreSQL\17\Dados\1T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'ISO-8859-1'
COPY conta_contabil_temporaria FROM 'C:\Program Files\PostgreSQL\17\Dados\1T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'ISO-8859-1'
COPY conta_contabil_temporaria FROM 'C:\Program Files\PostgreSQL\17\Dados\2T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'ISO-8859-1'
COPY conta_contabil_temporaria FROM 'C:\Program Files\PostgreSQL\17\Dados\2T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'ISO-8859-1'
COPY conta_contabil_temporaria FROM 'C:\Program Files\PostgreSQL\17\Dados\3T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'ISO-8859-1'
COPY conta_contabil_temporaria FROM 'C:\Program Files\PostgreSQL\17\Dados\3T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'ISO-8859-1'
COPY conta_contabil_temporaria FROM 'C:\Program Files\PostgreSQL\17\Dados\4T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'ISO-8859-1'

UPDATE conta_contabil_temporaria 
SET vl_saldo_inicial = REPLACE(vl_saldo_inicial :: TEXT, ',', '.') ::NUMERIC,
	vl_saldo_final = REPLACE(vl_saldo_final :: TEXT, ',', '.') :: NUMERIC;

INSERT INTO conta_contabil (data_referencia, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
SELECT
data_referencia, reg_ans, cd_conta_contabil, descricao, CAST (vl_saldo_inicial AS NUMERIC),CAST (vl_saldo_final AS NUMERIC)
FROM conta_contabil_temporaria;

SELECT * FROM conta_contabil

ALTER TABLE conta_contabil ADD COLUMN despesas NUMERIC;

UPDATE conta_contabil SET despesas = vl_saldo_final - vl_saldo_inicial;

SELECT oa.razao_social, SUM(cc.despesas)
FROM Operadora_ativas oa 
INNER JOIN conta_contabil cc ON oa.registro_ans = cc.reg_ans
WHERE cc.descricao LIKE 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSIST%' 
AND cc.data_referencia BETWEEN '2024-10-01' AND '2024-12-31'
GROUP BY oa.razao_social
ORDER BY SUM(cc.despesas)
LIMIT 10


SELECT oa.razao_social, SUM(cc.despesas)
FROM Operadora_ativas oa 
INNER JOIN conta_contabil cc ON oa.registro_ans = cc.reg_ans
WHERE cc.descricao LIKE 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSIST%' 
AND cc.data_referencia BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY oa.razao_social
ORDER BY SUM(cc.despesas)
LIMIT 10

SELECT descricao FROM conta_contabil

SELECT descricao FROM conta_contabil WHERE descricao LIKE 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSIST%' 
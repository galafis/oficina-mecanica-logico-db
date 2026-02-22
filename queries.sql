-- =============================================
-- Consultas SQL - Oficina Mecanica
-- Formacao SQL DB Specialist - DIO
-- Autor: Gabriel Demetrios Lafis
-- =============================================

USE oficina_mecanica;

-- =============================================
-- 1. Recuperacoes simples com SELECT Statement
-- =============================================

-- 1.1 Listar todos os clientes cadastrados
SELECT idCliente, Nome, CPF, Telefone, Email, Endereco
FROM Cliente;

-- 1.2 Listar todos os servicos disponiveis com seus valores
SELECT idServico, Descricao, ValorMaoDeObra
FROM Servico;

-- 1.3 Listar todas as pecas com seus valores unitarios
SELECT idPeca, Descricao, ValorUnitario
FROM Peca;

-- =============================================
-- 2. Filtros com WHERE Statement
-- =============================================

-- 2.1 Ordens de servico concluidas
SELECT idOS, idVeiculo, DataEmissao, DataConclusao, ValorTotal, TipoServico
FROM OrdemDeServico
WHERE Status = 'Concluida';

-- 2.2 Veiculos de uma marca especifica
SELECT v.Placa, v.Modelo, v.Marca, v.Ano, c.Nome AS Proprietario
FROM Veiculo v
INNER JOIN Cliente c ON v.idCliente = c.idCliente
WHERE v.Marca = 'Fiat';

-- 2.3 Ordens de servico com valor acima de 500
SELECT os.idOS, c.Nome AS Cliente, v.Modelo AS Veiculo,
       os.ValorTotal, os.Status, os.TipoServico
FROM OrdemDeServico os
INNER JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
INNER JOIN Cliente c ON v.idCliente = c.idCliente
WHERE os.ValorTotal > 500.00;

-- 2.4 Mecanicos com especialidade em Motor
SELECT idMecanico, Nome, Especialidade
FROM Mecanico
WHERE Especialidade LIKE '%Motor%';

-- =============================================
-- 3. Expressoes para gerar atributos derivados
-- =============================================

-- 3.1 Calcular tempo de execucao das OS (em dias)
SELECT os.idOS, c.Nome AS Cliente, v.Modelo AS Veiculo,
       os.DataEmissao, os.DataConclusao,
       DATEDIFF(os.DataConclusao, os.DataEmissao) AS DiasExecucao,
       os.ValorTotal
FROM OrdemDeServico os
INNER JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
INNER JOIN Cliente c ON v.idCliente = c.idCliente
WHERE os.DataConclusao IS NOT NULL;

-- 3.2 Calcular custo total de pecas e servicos por OS
SELECT os.idOS,
       COALESCE(SUM(sos.SubtotalServico), 0) AS TotalServicos,
       COALESCE((SELECT SUM(pos.SubtotalPeca) FROM PecaOS pos WHERE pos.idOS = os.idOS), 0) AS TotalPecas,
       os.ValorTotal,
       CONCAT(ROUND((COALESCE(SUM(sos.SubtotalServico), 0) / NULLIF(os.ValorTotal, 0)) * 100, 1), '%') AS PercentualMaoDeObra
FROM OrdemDeServico os
LEFT JOIN ServicoOS sos ON os.idOS = sos.idOS
GROUP BY os.idOS, os.ValorTotal;

-- 3.3 Classificar OS por faixa de valor
SELECT idOS, ValorTotal,
       CASE
           WHEN ValorTotal <= 200 THEN 'Baixo'
           WHEN ValorTotal <= 600 THEN 'Medio'
           WHEN ValorTotal <= 1000 THEN 'Alto'
           ELSE 'Muito Alto'
       END AS FaixaValor,
       Status, TipoServico
FROM OrdemDeServico;

-- =============================================
-- 4. Ordenacoes com ORDER BY
-- =============================================

-- 4.1 Ordens de servico ordenadas por valor total (maior para menor)
SELECT os.idOS, c.Nome AS Cliente, v.Modelo AS Veiculo,
       os.ValorTotal, os.Status, os.TipoServico
FROM OrdemDeServico os
INNER JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
INNER JOIN Cliente c ON v.idCliente = c.idCliente
ORDER BY os.ValorTotal DESC;

-- 4.2 Clientes e seus veiculos ordenados por nome do cliente e ano do veiculo
SELECT c.Nome AS Cliente, v.Placa, v.Modelo, v.Marca, v.Ano
FROM Cliente c
INNER JOIN Veiculo v ON c.idCliente = v.idCliente
ORDER BY c.Nome ASC, v.Ano DESC;

-- 4.3 Servicos mais caros (mao de obra) em ordem decrescente
SELECT Descricao, ValorMaoDeObra
FROM Servico
ORDER BY ValorMaoDeObra DESC
LIMIT 5;

-- =============================================
-- 5. Condicoes de filtros aos grupos - HAVING
-- =============================================

-- 5.1 Clientes com mais de 1 ordem de servico
SELECT c.Nome AS Cliente, COUNT(os.idOS) AS TotalOS,
       SUM(os.ValorTotal) AS ValorTotalGasto
FROM Cliente c
INNER JOIN Veiculo v ON c.idCliente = v.idCliente
INNER JOIN OrdemDeServico os ON v.idVeiculo = os.idVeiculo
GROUP BY c.idCliente, c.Nome
HAVING COUNT(os.idOS) > 1
ORDER BY TotalOS DESC;

-- 5.2 Equipes com valor medio de OS superior a 500
SELECT e.NomeEquipe, COUNT(os.idOS) AS TotalOS,
       AVG(os.ValorTotal) AS MediaValor,
       SUM(os.ValorTotal) AS SomaTotal
FROM Equipe e
INNER JOIN OrdemDeServico os ON e.idEquipe = os.idEquipe
GROUP BY e.idEquipe, e.NomeEquipe
HAVING AVG(os.ValorTotal) > 500
ORDER BY MediaValor DESC;

-- 5.3 Pecas utilizadas em mais de 2 ordens de servico
SELECT p.Descricao AS Peca, COUNT(pos.idOS) AS VezesUtilizada,
       SUM(pos.Quantidade) AS QuantidadeTotal,
       SUM(pos.SubtotalPeca) AS ValorTotal
FROM Peca p
INNER JOIN PecaOS pos ON p.idPeca = pos.idPeca
GROUP BY p.idPeca, p.Descricao
HAVING COUNT(pos.idOS) > 2
ORDER BY VezesUtilizada DESC;

-- =============================================
-- 6. Juncoes entre tabelas (JOINs)
-- =============================================

-- 6.1 Relatorio completo de OS com cliente, veiculo e equipe
SELECT os.idOS, c.Nome AS Cliente, c.CPF,
       v.Placa, v.Modelo, v.Marca,
       e.NomeEquipe AS Equipe,
       os.DataEmissao, os.DataConclusao,
       os.ValorTotal, os.Status, os.TipoServico,
       os.AutorizacaoCliente
FROM OrdemDeServico os
INNER JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
INNER JOIN Cliente c ON v.idCliente = c.idCliente
INNER JOIN Equipe e ON os.idEquipe = e.idEquipe
ORDER BY os.DataEmissao DESC;

-- 6.2 Detalhamento de servicos realizados por OS
SELECT os.idOS, s.Descricao AS Servico,
       s.ValorMaoDeObra, sos.Quantidade,
       sos.SubtotalServico
FROM OrdemDeServico os
INNER JOIN ServicoOS sos ON os.idOS = sos.idOS
INNER JOIN Servico s ON sos.idServico = s.idServico
ORDER BY os.idOS, s.Descricao;

-- 6.3 Detalhamento de pecas utilizadas por OS
SELECT os.idOS, p.Descricao AS Peca,
       p.ValorUnitario, pos.Quantidade,
       pos.SubtotalPeca
FROM OrdemDeServico os
INNER JOIN PecaOS pos ON os.idOS = pos.idOS
INNER JOIN Peca p ON pos.idPeca = p.idPeca
ORDER BY os.idOS, p.Descricao;

-- 6.4 Mecanicos e suas respectivas equipes
SELECT m.Nome AS Mecanico, m.Especialidade,
       e.NomeEquipe AS Equipe, e.AreaAtuacao
FROM Mecanico m
INNER JOIN EquipeMecanico em ON m.idMecanico = em.idMecanico
INNER JOIN Equipe e ON em.idEquipe = e.idEquipe
ORDER BY e.NomeEquipe, m.Nome;

-- 6.5 Clientes que possuem OS canceladas ou nao autorizadas
SELECT DISTINCT c.Nome AS Cliente, c.Telefone, c.Email,
       os.idOS, os.Status, os.AutorizacaoCliente
FROM Cliente c
INNER JOIN Veiculo v ON c.idCliente = v.idCliente
INNER JOIN OrdemDeServico os ON v.idVeiculo = os.idVeiculo
WHERE os.Status = 'Cancelada' OR os.AutorizacaoCliente = FALSE
ORDER BY c.Nome;

-- =============================================
-- 7. Subconsultas e consultas avancadas
-- =============================================

-- 7.1 OS com valor acima da media geral
SELECT os.idOS, c.Nome AS Cliente, v.Modelo AS Veiculo,
       os.ValorTotal, os.Status
FROM OrdemDeServico os
INNER JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
INNER JOIN Cliente c ON v.idCliente = c.idCliente
WHERE os.ValorTotal > (SELECT AVG(ValorTotal) FROM OrdemDeServico)
ORDER BY os.ValorTotal DESC;

-- 7.2 Cliente que mais gastou na oficina
SELECT c.Nome AS Cliente, c.CPF,
       SUM(os.ValorTotal) AS TotalGasto,
       COUNT(os.idOS) AS TotalOS
FROM Cliente c
INNER JOIN Veiculo v ON c.idCliente = v.idCliente
INNER JOIN OrdemDeServico os ON v.idVeiculo = os.idVeiculo
GROUP BY c.idCliente, c.Nome, c.CPF
ORDER BY TotalGasto DESC
LIMIT 1;

-- 7.3 Servicos que nunca foram utilizados em nenhuma OS
SELECT s.idServico, s.Descricao, s.ValorMaoDeObra
FROM Servico s
WHERE s.idServico NOT IN (
    SELECT DISTINCT idServico FROM ServicoOS
);

-- 7.4 Equipe com maior numero de OS concluidas
SELECT e.NomeEquipe, e.AreaAtuacao,
       COUNT(os.idOS) AS OSConcluidas
FROM Equipe e
INNER JOIN OrdemDeServico os ON e.idEquipe = os.idEquipe
WHERE os.Status = 'Concluida'
GROUP BY e.idEquipe, e.NomeEquipe, e.AreaAtuacao
HAVING COUNT(os.idOS) = (
    SELECT MAX(cnt) FROM (
        SELECT COUNT(idOS) AS cnt
        FROM OrdemDeServico
        WHERE Status = 'Concluida'
        GROUP BY idEquipe
    ) AS sub
);

-- 7.5 Resumo geral do faturamento por tipo de servico
SELECT TipoServico,
       COUNT(*) AS TotalOS,
       SUM(ValorTotal) AS Faturamento,
       AVG(ValorTotal) AS TicketMedio,
       MIN(ValorTotal) AS MenorValor,
       MAX(ValorTotal) AS MaiorValor
FROM OrdemDeServico
WHERE Status != 'Cancelada'
GROUP BY TipoServico
ORDER BY Faturamento DESC;

-- 7.6 Ranking de mecanicos por quantidade de OS atendidas
SELECT m.Nome AS Mecanico, m.Especialidade,
       COUNT(DISTINCT os.idOS) AS TotalOS
FROM Mecanico m
INNER JOIN EquipeMecanico em ON m.idMecanico = em.idMecanico
INNER JOIN Equipe e ON em.idEquipe = e.idEquipe
INNER JOIN OrdemDeServico os ON e.idEquipe = os.idEquipe
GROUP BY m.idMecanico, m.Nome, m.Especialidade
ORDER BY TotalOS DESC;

-- 7.7 Relatorio mensal de faturamento
SELECT DATE_FORMAT(DataEmissao, '%Y-%m') AS MesAno,
       COUNT(*) AS TotalOS,
       SUM(ValorTotal) AS FaturamentoMensal,
       AVG(ValorTotal) AS MediaMensal
FROM OrdemDeServico
WHERE Status NOT IN ('Cancelada')
GROUP BY DATE_FORMAT(DataEmissao, '%Y-%m')
ORDER BY MesAno;

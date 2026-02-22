-- =============================================
-- Dados de Teste - Oficina Mecanica
-- Formacao SQL DB Specialist - DIO
-- =============================================

USE oficina_mecanica;

-- Clientes
INSERT INTO Cliente (Nome, CPF, Telefone, Email, Endereco) VALUES
('Maria Silva', '12345678901', '41999001001', 'maria@email.com', 'Rua das Flores 100, Curitiba-PR'),
('Joao Santos', '23456789012', '41998002002', 'joao@email.com', 'Av Brasil 500, Curitiba-PR'),
('Ana Oliveira', '34567890123', '41997003003', 'ana@email.com', 'Rua XV de Novembro 200, Curitiba-PR'),
('Carlos Souza', '45678901234', '41996004004', 'carlos@email.com', 'Rua Marechal Deodoro 300, Curitiba-PR'),
('Fernanda Lima', '56789012345', '41995005005', 'fernanda@email.com', 'Av Sete de Setembro 800, Curitiba-PR');

-- Veiculos
INSERT INTO Veiculo (idCliente, Placa, Modelo, Marca, Ano, Cor) VALUES
(1, 'ABC1D23', 'Civic', 'Honda', 2020, 'Prata'),
(1, 'DEF4G56', 'HR-V', 'Honda', 2022, 'Branco'),
(2, 'GHI7J89', 'Corolla', 'Toyota', 2019, 'Preto'),
(3, 'JKL0M12', 'Onix', 'Chevrolet', 2021, 'Vermelho'),
(4, 'MNO3P45', 'Gol', 'Volkswagen', 2018, 'Azul'),
(4, 'QRS6T78', 'T-Cross', 'Volkswagen', 2023, 'Cinza'),
(5, 'UVW9X01', 'Kicks', 'Nissan', 2022, 'Branco');

-- Mecanicos
INSERT INTO Mecanico (Nome, Endereco, Especialidade) VALUES
('Pedro Alves', 'Rua Alferes Poli 50, Curitiba-PR', 'Motor'),
('Lucas Ferreira', 'Rua Comendador Araujo 120, Curitiba-PR', 'Eletrica'),
('Roberto Costa', 'Av Republica Argentina 300, Curitiba-PR', 'Funilaria'),
('Marcos Ribeiro', 'Rua Visconde de Nacar 80, Curitiba-PR', 'Suspensao'),
('Thiago Mendes', 'Rua Emiliano Perneta 150, Curitiba-PR', 'Motor'),
('Andre Gomes', 'Rua Marechal Floriano 200, Curitiba-PR', 'Eletrica');

-- Equipes
INSERT INTO Equipe (NomeEquipe, AreaAtuacao) VALUES
('Equipe Motor', 'Reparos de motor e transmissao'),
('Equipe Eletrica', 'Sistema eletrico e eletronico'),
('Equipe Funilaria', 'Funilaria e pintura'),
('Equipe Geral', 'Revisoes e manutencao preventiva');

-- EquipeMecanico
INSERT INTO EquipeMecanico (idEquipe, idMecanico) VALUES
(1, 1), (1, 5),
(2, 2), (2, 6),
(3, 3),
(4, 1), (4, 2), (4, 4);

-- Servicos (tabela de referencia de mao de obra)
INSERT INTO Servico (Descricao, ValorMaoDeObra) VALUES
('Troca de oleo e filtro', 80.00),
('Revisao completa', 350.00),
('Alinhamento e balanceamento', 120.00),
('Troca de pastilhas de freio', 150.00),
('Retifica de motor', 2500.00),
('Troca de correia dentada', 300.00),
('Revisao eletrica completa', 250.00),
('Troca de bateria', 60.00),
('Reparo no ar condicionado', 200.00),
('Funilaria e pintura parcial', 800.00),
('Troca de amortecedores', 280.00),
('Diagnostico eletronico', 100.00);

-- Pecas
INSERT INTO Peca (Descricao, ValorUnitario) VALUES
('Filtro de oleo', 35.00),
('Oleo Motor 5W30 1L', 42.00),
('Pastilha de freio dianteira', 120.00),
('Correia dentada', 180.00),
('Bateria 60Ah', 450.00),
('Amortecedor dianteiro', 320.00),
('Vela de ignicao', 45.00),
('Filtro de ar', 55.00),
('Fluido de freio 500ml', 28.00),
('Lampada farol H7', 35.00),
('Jogo de palhetas', 65.00),
('Filtro de combustivel', 70.00);

-- Ordens de Servico
INSERT INTO OrdemDeServico (idVeiculo, idEquipe, DataEmissao, DataConclusao, DataEntrega, ValorTotal, Status, AutorizacaoCliente, TipoServico) VALUES
(1, 4, '2026-01-15', '2026-01-16', '2026-01-16', 612.00, 'Concluida', TRUE, 'Revisao'),
(3, 1, '2026-01-20', '2026-01-25', '2026-01-25', 3180.00, 'Concluida', TRUE, 'Conserto'),
(4, 2, '2026-02-01', '2026-02-02', '2026-02-02', 560.00, 'Concluida', TRUE, 'Conserto'),
(5, 4, '2026-02-05', '2026-02-06', '2026-02-06', 417.00, 'Concluida', TRUE, 'Revisao'),
(2, 3, '2026-02-10', NULL, NULL, 1200.00, 'Em Execucao', TRUE, 'Conserto'),
(6, 4, '2026-02-12', NULL, NULL, 540.00, 'Aprovada', TRUE, 'Revisao'),
(7, 2, '2026-02-15', NULL, NULL, 410.00, 'Em Avaliacao', FALSE, 'Conserto'),
(1, 1, '2026-02-18', NULL, NULL, 0.00, 'Cancelada', FALSE, 'Conserto'),
(3, 4, '2026-02-20', NULL, NULL, 375.00, 'Em Execucao', TRUE, 'Revisao'),
(5, 1, '2026-02-21', NULL, NULL, 680.00, 'Aprovada', TRUE, 'Conserto');

-- ServicoOS
INSERT INTO ServicoOS (idOS, idServico, Quantidade, SubtotalServico) VALUES
(1, 1, 1, 80.00), (1, 3, 1, 120.00),
(2, 5, 1, 2500.00), (2, 6, 1, 300.00),
(3, 7, 1, 250.00), (3, 8, 1, 60.00),
(4, 1, 1, 80.00), (4, 2, 1, 350.00),
(5, 10, 1, 800.00),
(6, 2, 1, 350.00), (6, 3, 1, 120.00),
(7, 9, 1, 200.00), (7, 12, 1, 100.00),
(9, 1, 1, 80.00), (9, 4, 1, 150.00),
(10, 6, 1, 300.00), (10, 11, 1, 280.00);

-- PecaOS
INSERT INTO PecaOS (idOS, idPeca, Quantidade, SubtotalPeca) VALUES
(1, 1, 1, 35.00), (1, 2, 4, 168.00), (1, 8, 1, 55.00), (1, 11, 1, 65.00),
(2, 4, 1, 180.00), (2, 7, 4, 180.00),
(3, 5, 1, 450.00),
(4, 1, 1, 35.00), (4, 2, 4, 168.00), (4, 9, 1, 28.00),
(5, 10, 2, 70.00),
(6, 1, 1, 35.00), (6, 2, 4, 168.00), (6, 8, 1, 55.00),
(7, 10, 2, 70.00),
(9, 1, 1, 35.00), (9, 3, 1, 120.00),
(10, 4, 1, 180.00), (10, 6, 2, 640.00);

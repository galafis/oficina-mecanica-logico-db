-- =============================================
-- Projeto Logico - Oficina Mecanica
-- Formacao SQL DB Specialist - DIO
-- Autor: Gabriel Demetrios Lafis
-- =============================================

CREATE DATABASE IF NOT EXISTS oficina_mecanica;
USE oficina_mecanica;

-- Tabela: Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF CHAR(11) NOT NULL UNIQUE,
    Telefone VARCHAR(20),
    Email VARCHAR(100),
    Endereco VARCHAR(255)
);

-- Tabela: Veiculo
CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    Placa CHAR(7) NOT NULL UNIQUE,
    Modelo VARCHAR(100) NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Ano INT,
    Cor VARCHAR(30),
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela: Mecanico
CREATE TABLE Mecanico (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(255),
    Especialidade VARCHAR(100) NOT NULL
);

-- Tabela: Equipe
CREATE TABLE Equipe (
    idEquipe INT AUTO_INCREMENT PRIMARY KEY,
    NomeEquipe VARCHAR(100) NOT NULL,
    AreaAtuacao VARCHAR(100)
);

-- Tabela: EquipeMecanico (N:M)
CREATE TABLE EquipeMecanico (
    idEquipe INT,
    idMecanico INT,
    PRIMARY KEY (idEquipe, idMecanico),
    CONSTRAINT fk_em_equipe FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe),
    CONSTRAINT fk_em_mecanico FOREIGN KEY (idMecanico) REFERENCES Mecanico(idMecanico)
);

-- Tabela: OrdemDeServico
CREATE TABLE OrdemDeServico (
    idOS INT AUTO_INCREMENT PRIMARY KEY,
    idVeiculo INT NOT NULL,
    idEquipe INT NOT NULL,
    DataEmissao DATE NOT NULL,
    DataConclusao DATE,
    DataEntrega DATE,
    ValorTotal DECIMAL(10,2) DEFAULT 0,
    Status ENUM('Em Avaliacao', 'Aprovada', 'Em Execucao', 'Concluida', 'Cancelada') DEFAULT 'Em Avaliacao',
    AutorizacaoCliente BOOLEAN DEFAULT FALSE,
    TipoServico ENUM('Conserto', 'Revisao') NOT NULL,
    CONSTRAINT fk_os_veiculo FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo),
    CONSTRAINT fk_os_equipe FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
);

-- Tabela: Servico (referencia de mao de obra)
CREATE TABLE Servico (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(200) NOT NULL,
    ValorMaoDeObra DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_valor_mdo CHECK (ValorMaoDeObra >= 0)
);

-- Tabela: ServicoOS (N:M entre OS e Servico)
CREATE TABLE ServicoOS (
    idOS INT,
    idServico INT,
    Quantidade INT NOT NULL DEFAULT 1,
    SubtotalServico DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idOS, idServico),
    CONSTRAINT fk_sos_os FOREIGN KEY (idOS) REFERENCES OrdemDeServico(idOS),
    CONSTRAINT fk_sos_servico FOREIGN KEY (idServico) REFERENCES Servico(idServico)
);

-- Tabela: Peca
CREATE TABLE Peca (
    idPeca INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(200) NOT NULL,
    ValorUnitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_valor_peca CHECK (ValorUnitario >= 0)
);

-- Tabela: PecaOS (N:M entre OS e Peca)
CREATE TABLE PecaOS (
    idOS INT,
    idPeca INT,
    Quantidade INT NOT NULL DEFAULT 1,
    SubtotalPeca DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idOS, idPeca),
    CONSTRAINT fk_pos_os FOREIGN KEY (idOS) REFERENCES OrdemDeServico(idOS),
    CONSTRAINT fk_pos_peca FOREIGN KEY (idPeca) REFERENCES Peca(idPeca)
);

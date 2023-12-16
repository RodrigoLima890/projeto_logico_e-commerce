create database ecommerce;
use ecommerce;

#fornecedor
CREATE TABLE IF NOT EXISTS Fornecedor (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `razao_social` VARCHAR(45) NULL,
  `CNPJ` CHAR(15) NOT NULL,
  `contato` VARCHAR(45) NULL,
  PRIMARY KEY (`idFornecedor`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC) VISIBLE)
ENGINE = InnoDB;

#produto
CREATE TABLE IF NOT EXISTS Produto (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `valor` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idProduto`))
ENGINE = InnoDB;

#endereços
CREATE TABLE IF NOT EXISTS Enderecos (
  `idEnderecos` INT NOT NULL AUTO_INCREMENT,
  `Cidade` VARCHAR(45) NOT NULL,
  `UF` VARCHAR(4) NOT NULL,
  `Logradouro` VARCHAR(45) NOT NULL,
  `Complemento` VARCHAR(45) NULL,
  `Numero` VARCHAR(10) NOT NULL,
  `CEP` VARCHAR(8) NOT NULL,
  PRIMARY KEY (`idEnderecos`))
ENGINE = InnoDB;

#estoque
CREATE TABLE IF NOT EXISTS Estoque (
  `idEstoque` INT NOT NULL AUTO_INCREMENT,
  `codEndereco` INT NOT NULL,
  `quantidade` INT NULL,
  PRIMARY KEY (`idEstoque`),
  INDEX `Fk_estoque_enreco_idx` (`codEndereco` ASC) VISIBLE,
  CONSTRAINT `Fk_estoque_enreco`
    FOREIGN KEY (`codEndereco`)
    REFERENCES `Enderecos` (`idEnderecos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



#Pessoa
CREATE TABLE IF NOT EXISTS Pessoa (
  `idPessoa` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `TipoPessoa` CHAR(1) NOT NULL,
  `CPF` VARCHAR(11) NULL,
  `CNPJ` VARCHAR(20) NULL,
  PRIMARY KEY (`idPessoa`))
ENGINE = InnoDB;

#Cliente
CREATE TABLE IF NOT EXISTS Cliente (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Data de nascimento` DATE NOT NULL,
  `codEndereco` INT NULL,
  `CodPessoa` INT NOT NULL,
  PRIMARY KEY (`idCliente`),
  INDEX `Fk_enreco_cliente_idx` (`codEndereco` ASC) VISIBLE,
  INDEX `Fk_cliente_pessoa_idx` (`CodPessoa` ASC) VISIBLE,
  CONSTRAINT `Fk_enreco_cliente`
    FOREIGN KEY (`codEndereco`)
    REFERENCES `Enderecos` (`idEnderecos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Fk_cliente_pessoa`
    FOREIGN KEY (`CodPessoa`)
    REFERENCES `Pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Pedido (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `status` ENUM('Em andamento', 'Processando', 'Enviado', 'Entregue') NULL DEFAULT 'Processando',
  `descricao` VARCHAR(45) NULL,
  `frete` FLOAT NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idPedido`, `Cliente_idCliente`),
  INDEX `fk_Pedido_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


#Entrega
CREATE TABLE IF NOT EXISTS Entrega (
  `idEntrega` INT NOT NULL AUTO_INCREMENT,
  `Status` ENUM('Entregue', 'Em Processamento', 'Cancelado', 'A Caminho') NOT NULL DEFAULT 'Em Processamento',
  `idPedido` INT NOT NULL,
  PRIMARY KEY (`idEntrega`),
  INDEX `Fk_entrega_pedido_idx` (`idPedido` ASC) VISIBLE,
  CONSTRAINT `Fk_entrega_pedido`
    FOREIGN KEY (`idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

#formas de pagamento
CREATE TABLE IF NOT EXISTS Forma_Pagamento (
  `idForma_Pagamento` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idForma_Pagamento`))
ENGINE = InnoDB;

#Vendedor Terceiro
CREATE TABLE IF NOT EXISTS Terceiro_Vendedor (
  `idTerceiro_Vendedor` INT NOT NULL,
  `razao_social` VARCHAR(45) NOT NULL,
  `local` VARCHAR(45) NULL,
  `CNPJ` VARCHAR(45) NULL,
  `NomeFantasia` VARCHAR(45) NULL,
  PRIMARY KEY (`idTerceiro_Vendedor`),
  UNIQUE INDEX `razao_social_UNIQUE` (`razao_social` ASC) VISIBLE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Fornecedor_produto (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Produto_idProduto`),
  INDEX `fk_Fornecedor_has_Produto_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  INDEX `fk_Fornecedor_has_Produto_Fornecedor_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_Fornecedor_has_Produto_Fornecedor`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Produtos_Vendedor_terceiro (
  `Terceiro_Vendedor_idTerceiro_Vendedor` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `quantidade` INT NULL,
  PRIMARY KEY (`Terceiro_Vendedor_idTerceiro_Vendedor`, `Pedido_idPedido`),
  INDEX `fk_Terceiro_Vendedor_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Terceiro_Vendedor_has_Pedido_Terceiro_Vendedor1_idx` (`Terceiro_Vendedor_idTerceiro_Vendedor` ASC) VISIBLE,
  CONSTRAINT `fk_Terceiro_Vendedor_has_Pedido_Terceiro_Vendedor1`
    FOREIGN KEY (`Terceiro_Vendedor_idTerceiro_Vendedor`)
    REFERENCES `Terceiro_Vendedor` (`idTerceiro_Vendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Terceiro_Vendedor_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Formas_Pagamento_Pedido (
  `Forma_Pagamento_idForma_Pagamento` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  PRIMARY KEY (`Forma_Pagamento_idForma_Pagamento`, `Pedido_idPedido`),
  INDEX `fk_Forma_Pagamento_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Forma_Pagamento_has_Pedido_Forma_Pagamento1_idx` (`Forma_Pagamento_idForma_Pagamento` ASC) VISIBLE,
  CONSTRAINT `fk_Forma_Pagamento_has_Pedido_Forma_Pagamento1`
    FOREIGN KEY (`Forma_Pagamento_idForma_Pagamento`)
    REFERENCES `Forma_Pagamento` (`idForma_Pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Forma_Pagamento_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Relacao_Produto_Pedido (
  `Produto_idProduto` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `quantidade` INT NOT NULL,
  `Status` ENUM('Disponivel', 'Sem Estoque') NOT NULL DEFAULT 'Disponivel',
  PRIMARY KEY (`Produto_idProduto`, `Pedido_idPedido`),
  INDEX `fk_Produto_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Produto_has_Pedido_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Pedido_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Produtos_Estoque (
  `Produto_idProduto` INT NOT NULL,
  `Estoque_idEstoque` INT NOT NULL,
  `quantidade` INT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Estoque_idEstoque`),
  INDEX `fk_Produto_has_Estoque_Estoque1_idx` (`Estoque_idEstoque` ASC) VISIBLE,
  INDEX `fk_Produto_has_Estoque_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`Estoque_idEstoque`)
    REFERENCES `Estoque` (`idEstoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Inserir dados na tabela Fornecedor
INSERT INTO Fornecedor (razao_social, CNPJ, contato) VALUES
('Fornecedor 1', '12345678901234', 'Contato 1'),
('Fornecedor 2', '56789012345678', 'Contato 2'),
('Fornecedor 3', '90123456781234', 'Contato 3'),
('Fornecedor 4', '34567890123456', 'Contato 4'),
('Fornecedor 5', '78901234561234', 'Contato 5');

-- Inserir dados na tabela Produto
INSERT INTO Produto (categoria, descricao, valor) VALUES
('Eletrônicos', 'Produto 1', '100.00'),
('Roupas', 'Produto 2', '50.00'),
('Alimentos', 'Produto 3', '10.00'),
('Livros', 'Produto 4', '20.00'),
('Cosméticos', 'Produto 5', '30.00');

-- Inserir dados na tabela Enderecos
INSERT INTO Enderecos (Cidade, UF, Logradouro, Complemento, Numero, CEP) VALUES
('Cidade 1', 'UF1', 'Rua 1', 'Complemento 1', '123', '12345678'),
('Cidade 2', 'UF2', 'Rua 2', 'Complemento 2', '456', '23456789'),
('Cidade 3', 'UF3', 'Rua 3', 'Complemento 3', '789', '34567890'),
('Cidade 4', 'UF4', 'Rua 4', 'Complemento 4', '012', '45678901'),
('Cidade 5', 'UF5', 'Rua 5', 'Complemento 5', '345', '56789012');
select * from enderecos;
-- Inserir dados na tabela Estoque
INSERT INTO Estoque (codEndereco, quantidade) VALUES
(1, 50),
(2, 30),
(3, 20),
(4, 10),
(5, 40);

-- Inserir dados na tabela Pessoa
INSERT INTO Pessoa (Nome, TipoPessoa, CPF, CNPJ) VALUES
('Pessoa 1', 'F', '12345678901', NULL),
('Pessoa 2', 'J', NULL, '12345678901234'),
('Pessoa 3', 'F', '23456789012', NULL),
('Pessoa 4', 'J', NULL, '23456789012345'),
('Pessoa 5', 'F', '34567890123', NULL);

-- Inserir dados na tabela Cliente
INSERT INTO Cliente (`Data de nascimento`, codEndereco, CodPessoa) VALUES
('2000-01-01', 1, 1),
('1995-05-15', 2, 2),
('1988-11-30', 3, 3),
('1976-07-20', 4, 4),
('1990-03-10', 5, 5);

-- Inserir dados na tabela Pedido
INSERT INTO Pedido (status, descricao, frete, Cliente_idCliente) VALUES
('Em andamento', 'Pedido 1', 5.00, 1),
('Processando', 'Pedido 2', 7.50, 2),
('Enviado', 'Pedido 3', 10.00, 3),
('Entregue', 'Pedido 4', 8.50, 4),
('Processando', 'Pedido 5', 6.00, 5);

-- Inserir dados na tabela Entrega
INSERT INTO Entrega (Status, idPedido) VALUES
('Entregue', 1),
('Em Processamento', 2),
('Cancelado', 3),
('A Caminho', 4),
('Em Processamento', 5);

-- Inserir dados na tabela Forma_Pagamento
INSERT INTO Forma_Pagamento (idForma_Pagamento,nome) VALUES
(1,'Cartão de Crédito'),
(2,'Boleto Bancário'),
(3,'Transferência Bancária'),
(4,'Dinheiro'),
(5,'PIX');

-- Inserir dados na tabela Terceiro_Vendedor
INSERT INTO Terceiro_Vendedor (idTerceiro_Vendedor,razao_social, local, CNPJ, NomeFantasia) VALUES
(1,'Vendedor 1', 'Local 1', '12345678901234', 'Fantasia 1'),
(2,'Vendedor 2', 'Local 2', '56789012345678', 'Fantasia 2'),
(3,'Vendedor 3', 'Local 3', '90123456781234', 'Fantasia 3'),
(4,'Vendedor 4', 'Local 4', '34567890123456', 'Fantasia 4'),
(5,'Vendedor 5', 'Local 5', '78901234561234', 'Fantasia 5');

INSERT INTO Relacao_Produto_Pedido (Produto_idProduto, Pedido_idPedido, quantidade, Status) VALUES
(1, 1, 5, 'Disponivel'),
(2, 2, 3, 'Disponivel'),
(3, 3, 2, 'Sem Estoque'),
(4, 4, 4, 'Disponivel'),
(5, 5, 1, 'Sem Estoque');

select * from Relacao_Produto_Pedido;
select * from produto;
select * from enderecos;
select * from pedido;

select concat(p.nome,' - ' ,p.CPF) cliente,
concat(en.cidade,' - ',en.logradouro,' - ',en.numero) endereco,
concat(pe.descricao,' - ',pe.status,' - ',pr.descricao,' - ',pr.valor) pedido
from pessoa p 
join Cliente cl on (cl.CodPessoa = p.idPessoa)
join enderecos en on (cl.codEndereco = idEnderecos)
join pedido pe on (pe.Cliente_idCliente = cl.idCliente)
join Relacao_Produto_Pedido rpp on (rpp.pedido_idPedido = pe.idPedido)
join produto pr on (pr.idProduto = rpp.produto_idproduto)
where TipoPessoa = 'F';

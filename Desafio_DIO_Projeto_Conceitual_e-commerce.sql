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
CREATE TABLE IF NOT EXISTS `Entrega` (
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
CREATE TABLE IF NOT EXISTS `mydb`.`Terceiro_Vendedor` (
  `idTerceiro_Vendedor` INT NOT NULL,
  `razao_social` VARCHAR(45) NOT NULL,
  `local` VARCHAR(45) NULL,
  `CNPJ` VARCHAR(45) NULL,
  `NomeFantasia` VARCHAR(45) NULL,
  PRIMARY KEY (`idTerceiro_Vendedor`),
  UNIQUE INDEX `razao_social_UNIQUE` (`razao_social` ASC) VISIBLE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `mydb`.`Fornecedor_produto` (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Produto_idProduto`),
  INDEX `fk_Fornecedor_has_Produto_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  INDEX `fk_Fornecedor_has_Produto_Fornecedor_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_Fornecedor_has_Produto_Fornecedor`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `mydb`.`Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `mydb`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Produtos_Vendedor-terceiro` (
  `Terceiro_Vendedor_idTerceiro_Vendedor` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `quantidade` INT NULL,
  PRIMARY KEY (`Terceiro_Vendedor_idTerceiro_Vendedor`, `Pedido_idPedido`),
  INDEX `fk_Terceiro_Vendedor_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Terceiro_Vendedor_has_Pedido_Terceiro_Vendedor1_idx` (`Terceiro_Vendedor_idTerceiro_Vendedor` ASC) VISIBLE,
  CONSTRAINT `fk_Terceiro_Vendedor_has_Pedido_Terceiro_Vendedor1`
    FOREIGN KEY (`Terceiro_Vendedor_idTerceiro_Vendedor`)
    REFERENCES `mydb`.`Terceiro_Vendedor` (`idTerceiro_Vendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Terceiro_Vendedor_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `mydb`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Formas_Pagamento_Pedido` (
  `Forma_Pagamento_idForma_Pagamento` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  PRIMARY KEY (`Forma_Pagamento_idForma_Pagamento`, `Pedido_idPedido`),
  INDEX `fk_Forma_Pagamento_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Forma_Pagamento_has_Pedido_Forma_Pagamento1_idx` (`Forma_Pagamento_idForma_Pagamento` ASC) VISIBLE,
  CONSTRAINT `fk_Forma_Pagamento_has_Pedido_Forma_Pagamento1`
    FOREIGN KEY (`Forma_Pagamento_idForma_Pagamento`)
    REFERENCES `mydb`.`Forma_Pagamento` (`idForma_Pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Forma_Pagamento_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `mydb`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Relacao_Produto/Pedido` (
  `Produto_idProduto` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `quantidade` INT NOT NULL,
  `Status` ENUM('Disponivel', 'Sem Estoque') NOT NULL DEFAULT 'Disponivel',
  PRIMARY KEY (`Produto_idProduto`, `Pedido_idPedido`),
  INDEX `fk_Produto_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Produto_has_Pedido_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Pedido_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `mydb`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `mydb`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Produtos_Estoque` (
  `Produto_idProduto` INT NOT NULL,
  `Estoque_idEstoque` INT NOT NULL,
  `quantidade` INT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Estoque_idEstoque`),
  INDEX `fk_Produto_has_Estoque_Estoque1_idx` (`Estoque_idEstoque` ASC) VISIBLE,
  INDEX `fk_Produto_has_Estoque_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `mydb`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`Estoque_idEstoque`)
    REFERENCES `mydb`.`Estoque` (`idEstoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Produtos_Vendedor-terceiro` (
  `Terceiro_Vendedor_idTerceiro_Vendedor` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `quantidade` INT NULL,
  PRIMARY KEY (`Terceiro_Vendedor_idTerceiro_Vendedor`, `Pedido_idPedido`),
  INDEX `fk_Terceiro_Vendedor_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Terceiro_Vendedor_has_Pedido_Terceiro_Vendedor1_idx` (`Terceiro_Vendedor_idTerceiro_Vendedor` ASC) VISIBLE,
  CONSTRAINT `fk_Terceiro_Vendedor_has_Pedido_Terceiro_Vendedor1`
    FOREIGN KEY (`Terceiro_Vendedor_idTerceiro_Vendedor`)
    REFERENCES `mydb`.`Terceiro_Vendedor` (`idTerceiro_Vendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Terceiro_Vendedor_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `mydb`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `mydb`.`Formas_Pagamento_Pedido` (
  `Forma_Pagamento_idForma_Pagamento` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  PRIMARY KEY (`Forma_Pagamento_idForma_Pagamento`, `Pedido_idPedido`),
  INDEX `fk_Forma_Pagamento_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Forma_Pagamento_has_Pedido_Forma_Pagamento1_idx` (`Forma_Pagamento_idForma_Pagamento` ASC) VISIBLE,
  CONSTRAINT `fk_Forma_Pagamento_has_Pedido_Forma_Pagamento1`
    FOREIGN KEY (`Forma_Pagamento_idForma_Pagamento`)
    REFERENCES `mydb`.`Forma_Pagamento` (`idForma_Pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Forma_Pagamento_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `mydb`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;




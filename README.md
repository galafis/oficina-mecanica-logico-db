# Projeto Logico de Banco de Dados - Oficina Mecanica

## Descricao

Este projeto implementa o **esquema logico** de banco de dados para o cenario de uma **Oficina Mecanica**, desenvolvido como parte da Formacao SQL DB Specialist da [DIO](https://www.dio.me/).

O projeto parte do [esquema conceitual](https://github.com/galafis/oficina-mecanica-conceitual-db) previamente criado e implementa o mapeamento para o modelo relacional, incluindo scripts DDL, dados de teste e consultas SQL complexas.

## Contexto do Negocio

O sistema gerencia o controle e execucao de ordens de servico em uma oficina mecanica:

- **Clientes** levam seus **veiculos** para conserto ou revisao
- Cada veiculo e designado a uma **equipe de mecanicos**
- A equipe preenche uma **Ordem de Servico (OS)** com servicos e pecas necessarios
- O **cliente autoriza** a execucao dos servicos
- A OS possui **status**, **valor total** e **datas** de controle

## Esquema Logico

### Entidades Principais

- **Cliente**: Dados cadastrais dos clientes
- **Veiculo**: Veiculos dos clientes (relacao 1:N com Cliente)
- **Mecanico**: Profissionais com codigo, nome, endereco e especialidade
- **Equipe**: Equipes de mecanicos (relacao N:M com Mecanico)
- **OrdemDeServico**: OS com numero, datas, valor, status e autorizacao
- **Servico**: Tabela de referencia de servicos e valores de mao de obra
- **Peca**: Catalogo de pecas com valores unitarios

### Tabelas Associativas

- **EquipeMecanico**: Associacao N:M entre Equipe e Mecanico
- **ServicoOS**: Servicos executados em cada OS (N:M)
- **PecaOS**: Pecas utilizadas em cada OS (N:M)

## Estrutura do Projeto

```
oficina-mecanica-logico-db/
|-- README.md
|-- schema.sql          # Script DDL - Criacao do esquema
|-- data.sql            # Script DML - Dados de teste
|-- queries.sql         # Consultas SQL complexas
```

## Consultas Implementadas

- **SELECT**: Recuperacoes simples de dados
- **WHERE**: Filtros condicionais
- **Expressoes**: Atributos derivados (valor total, dias em aberto)
- **ORDER BY**: Ordenacao de resultados
- **HAVING**: Filtros sobre grupos agregados
- **JOIN**: Juncoes entre tabelas

### Perguntas Respondidas

1. Quantas OS cada cliente possui?
2. Qual o valor total gasto por cliente?
3. Quais mecanicos pertencem a mais de uma equipe?
4. Quais OS estao em aberto ha mais de 7 dias?
5. Qual a receita total por tipo de servico?
6. Quais pecas foram mais utilizadas?
7. Qual equipe gerou mais receita?
8. Quais veiculos tiveram mais de 2 OS?

## Tecnologias

- MySQL 8.0+
- SQL (DDL, DML, DQL)

## Como Executar

1. Execute `schema.sql` para criar o banco e as tabelas
2. Execute `data.sql` para popular com dados de teste
3. Execute `queries.sql` para analisar os dados

## Autor

**Gabriel Demetrios Lafis** - [GitHub](https://github.com/galafis)

---

Desenvolvido como parte da **Formacao SQL DB Specialist** - [DIO](https://www.dio.me/)

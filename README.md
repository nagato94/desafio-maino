# DesafioBlogMaino

Este projeto é um blog desenvolvido com Ruby on Rails, que permite aos usuários criar, editar, e deletar posts, bem como adicionar comentários e fazer o upload de arquivos de texto. Este blog também suporta autenticação de usuários e filtragem de posts por tags.

## Funcionalidades

- Criação, edição e exclusão de posts
- Upload de arquivos de texto nos posts
- Adição de comentários aos posts
- Filtragem de posts por tags
- Autenticação de usuários
- Internacionalização com suporte para inglês e português

## Tecnologias Utilizadas

- Ruby on Rails
- PostgreSQL
- Bootstrap para estilização
- Devise para autenticação de usuários

## Configuração Inicial

Para executar este projeto localmente, siga estas etapas:

1. Clone o repositório:
  - git clone https://github.com/seu-usuario/DesafioBlogMaino.git
2. Instale as dependências:
  - bundle install
3. Crie e configure o arquivo `config/database.yml` com suas credenciais PostgreSQL.

4. Crie e migre o banco de dados:
  - rails db:create db:migrate

5. Execute o projeto:
  - rails server


## Uso

Após iniciar o servidor, acesse `http://localhost:3000` para começar a utilizar o blog. Você pode se registrar como um novo usuário ou entrar com um usuário existente para criar posts e interagir com outros conteúdos.

## Autores

- Kaique Costa e Silva (@nagato94)- *Desenvolvimento inicial*

---

Espero que você encontre este projeto útil e inspirador!

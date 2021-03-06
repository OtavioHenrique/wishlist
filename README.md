# Wishlist

Este repositorio contem uma aplicacao Rails responsavel por administrar um sistema de usuarios simples para um ecomerce.

A aplicacao e capaz de:

* Adicionar usuarios
* Autenticar/Autorizar usuarios
* Adicionar produtos a wishlist dos usuarios

## Como rodar

Para rodar a aplicacao para desenvolvimento e bem simples, basta executar o seguinte comando:

```
docker-compose up -d
```

E apos alguns segundos a aplicacao ja estara disponivel na porta `3000` do seu `localhost`.

O compose dessa aplicacao esta preparado para desenvolvimento, mapeando o volume para seu codigo local, toda alteracao feita no codigo ja estara rodando dentro do container! Esse compose sobe a aplicacao e seu banco de dados (Mysql)

Caso queira ver os logs da aplicacao basta executar o seguinte comando:

```
docker-compose logs -f app
```

Caso queira rodar os testes no container que esta rodando basta executar:

```
docker-compose exec app rspec
```

Caso queira debugar a aplicacao usando ferramentas de debugging como o `byebug`, basta adicionar o `byebug` onde deseja que seja o breakpoint, e em seguida dar um `attach` no container:

```
docker attach $(docker ps -qf name=app)
```

### Testes

Esse projeto conta com 100% de cobertura de testes automatizados(relatorio pela gem `coverage`), todo codigo escrito tem um teste para ele, para rodar os testes existem duas formas:

* Se ja estiver com a aplicacao rodando local como descrito no step [Como Rodar](#Como-rodar), basta executar `docker-compose app rspec`

```
Finished in 0.74843 seconds (files took 4.46 seconds to load)
30 examples, 0 failures

Coverage report generated for RSpec to /app/coverage. 367 / 367 LOC (100.0%) covered.
```

Apos rodar o primeiro teste, a gem `coverage` ira criar uma pasta chamada `coverage` onde tem um arquivo html com o relatorio de todos os testes.

### Lint

Esse projeto usa a gem `rubocop` para estabelecer os padroes de codigo da comunidade Ruby e a consistencia dele, para rodar, apenas digite:

* `docker-compose exec app rubocop` caso tenha o container ja rodando.

```
Inspecting 43 files
...........................................

43 files inspected, no offenses detected
```

Nao existe nenhuma infracao nesse projeto.

## Como usar

Esse projeto conta com alguns endpoints, veja como usar:

### healthcheck

Esse projeto possui uma rota de `healthcheck` no `/healthcheck`, basta dar um GET nela e voce deve obter como resposta uma mensagem de status 200 e um "OK"

GET `/healthcheck`

```
OK
```

### Criar usuario

Para criar um usuario, basta mandar um `POST /api/users`, no caso de estar rodando local um `localhost:3000/api/users` com o seguinte json:


POST `localhost:3000/api/users`

```json
{
    "user": {
        "name": "John Doe",
        "email": "john.doe@gmail.com",
        "password": "12345qwert"
    }
}
```

O json precisa conter a chave `user` e dentro dela os campos `name`, `email` e `password`. Apos a chamada voce deve obter como resposta o HTTP status 201 e um json contendo o registro criado:

```
{
    "id": 2,
    "name": "John Doe",
    "email": "john.doe@gmail.com",
    "created_at": "2020-07-13T16:53:18.595Z",
    "updated_at": "2020-07-13T16:53:18.595Z",
    "password_digest": "$2a$12$gfFXum9G8K3luxrwg/pcMue77P9asIepEu6UVLGIGQNFfKJcs2/qK",
    "wishlist": []
}
```

### Autenticar usuario / Obter token

Para obter um token de autenticacao, basta bater com um `POST /api/authentication/login` passando os campos `email` e `password` do usuario:

_Seguindo o contexto do usuario criado no exemplo de cima_

POST `localhost:3000/api/authentication/login`
```
{
    "email": "john.doe@gmail.com",
    "password": "12345qwert"
}
```

E como resposta voce vai receber um status HTTP 200, e no corpo um campo chamado `token` com o token que deve ser usado nas chamadas posteriores e um campo `expiration` com a duracao do token ate ser necessario criar um novo:

_No caso a duracao default de cada token e 24h_

```
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHBpcmF0aW9uIjoiMjAyMC0wNy0xNCAxNjo1Njo1NCBVVEMifQ.tATOr6Vf03Omp8SZRV-dFg8fPr-kyQzLkZpjuVOxFgU",
    "expiration": "07-14-2020 16:56"
}
```

### Atualizar usuario

Agora que temos o token, podemos fazer alteracoes diretamente no usuario, como por exemplo atualizar um nome, para essas acoes utilize o endpoint `PUT /api/users/<ID_DO_USUARIO>`, por se tratar de um endpoint que requer autorizacao, e necessario passar no header `Authorization` o token que foi obtido no step anterior.


PUT `localhost:3000/api/users/2`
```
{
    "name": "John Doe Jr"
}
```

E voce vai obter como resposta, o registro atualizado:

```json
{
    "id": 2,
    "name": "John Doe Jr",
    "password_digest": "$2a$12$gfFXum9G8K3luxrwg/pcMue77P9asIepEu6UVLGIGQNFfKJcs2/qK",
    "email": "john.doe@gmail.com",
    "created_at": "2020-07-13T16:53:18.595Z",
    "updated_at": "2020-07-13T16:59:07.308Z",
    "wishlist": []
}
```

### Adicionar produtos a lista de desejos

Para adicionar um produto na wishlist basta mandar um POST no endpoint `/api/users/wishlist` no corpo passando `product_id` o ID do produto, por se tratar de um endpoint que requer autorizacao, e necessario passar no header `Authorization` o token que foi obtido no step anterior.

POST `localhost:3000/api/users/wishlist`
```json
{
    "product_id": "29c33ade-906e-2b39-ccf1-856283e1bd22"
}
```

E como resposta voce vai obter um codigo de resposta HTTP 200

### Vendo o usuario

Se quiser ver o usuario, basta dar um GET no endpoint `/api/users/<ID_DO_USER>`, por se tratar de um endpoint que requer autorizacao, e necessario passar no header `Authorization` o token que foi obtido no step anterior.

GET `localhost:3000/api/users/2`
```json
{
  "id": 2,
  "name": "John Doe Jr",
  "email": "john.doe@gmail.com",
  "created_at": "2020-07-13T16:53:18.595Z",
  "updated_at": "2020-07-13T20:38:18.487Z",
  "password_digest": "$2a$12$gfFXum9G8K3luxrwg/pcMue77P9asIepEu6UVLGIGQNFfKJcs2/qK",
  "wishlist": [
      {
          "price": 799.0,
          "image": "http://challenge-api.luizalabs.com/images/29c33ade-906e-2b39-ccf1-856283e1bd22.jpg",
          "brand": "jbl",
          "id": "29c33ade-906e-2b39-ccf1-856283e1bd22",
          "title": "Caixa de Som Bluetooth JBL Flip 3 2X8W"
      }
  ]
}
```

_Aqui a renderizacao da wishlist ja e feita convertendo os IDs nos produtos_

### Vendo apenas a wishlist do usuario

Para ver apenas a lista de desejo do usuario, pode usar o endpoint `/api/users/wishlist/render`, por se tratar de um endpoint que requer autorizacao, e necessario passar no header `Authorization` o token que foi obtido no step anterior.


GET `localhost:3000/api/users/wishlist/render`
```
[
    {
        "price": 799.0,
        "image": "http://challenge-api.luizalabs.com/images/29c33ade-906e-2b39-ccf1-856283e1bd22.jpg",
        "brand": "jbl",
        "id": "29c33ade-906e-2b39-ccf1-856283e1bd22",
        "title": "Caixa de Som Bluetooth JBL Flip 3 2X8W"
    }
]
```

Vai ser devolvido um array contendo os produtos adicionados.

### Excluindo usuario

Para deletar o usuario basta mandar um DELETE `/api/users/<ID_USUARIO>`, por se tratar de um endpoint que requer autorizacao, e necessario passar no header `Authorization` o token que foi obtido no step anterior.

DELETE `localhost:3000/api/users/<ID_USUARIO>`

E deve ser retornado um HTTP status 204 com uma resposta vazia.

*Nota: Nao utilizei soft delete para ficar mais compliance com as leis da LGPD*

## Pontos importantes

### Arquitetura geral da aplicacao

Para fazer essa aplicacao eu considerei o cenario onde existe uma aplicacao (Client) que no caso pode ser um aplicativo ou um front-end, que conhece o ID dos produtos que esta sendo listado ao usuario, e quando o usuario clicar no botao de adicionar a wishlist, o client envia apenas o ID desse produto ao back-end (Essa aplicacao) responsavel por administrar a lista de desejo dos usuarios.

### Soft delete vs Hard delete

Optei por deletar o usuario completamente para ficar de acordo coma LGPD.

### Renderizar produtos no endpoint de SHOW do user

Optei por renderizar os produtos no endpoint de SHOW do user, sei que isso nao e muito performatico sem um cache de produtos (Igual falei na parte de TODOS), porem achei que assim fica melhor, porem ali poderia ser mostrado so os IDs tambem.

### Utilizar JWT para Authorization/Authentication

Optei por utilizar o JWT pois precisava de uma maneira rapida e aceitavel de fazer isso (Sem ser tokens infinitos), porem como falei na parte de TODOs o ideal era ter um servico de autenticacao separado baseado em OAuth2

### 100% Cobertura de testes

Esse projeto conta com 100% cobertura de testes automatizados

### Rubocop

Esse projeto esta de acordo com as regras da comunidade para consistencia e design de codigo.

### ENVs

Esse projeto utiliza ENVs seguindo o padrao 12-factor app.

## TODOS (O que faltaria fazer)

### Colocar em um CI

Colocar o projeto em um CI

### Dockerfile multistage

Ter dois stages no dockerfile, um para development e outro para production.

### Otimizar Dockerfile

Hoje a imagem tem 207MB, daria para diminuir um pouco mais ela

### Circuit Breakers

Eu colocaria um circuit breaker em torno das chamadas para procurar produtos (Nunca se sabe quando a API pode cair), e com base nesse circuito tomar decisoes como "Tirar o botao de wishlist da tela do usuario", porem nao tive tempo. Se considerar um sistema que rode em um Service Mesh como Envoy, ele ja teria circuit breaker no sidecar. Tambem poderia ser exposto no `healthcheck` o status dos circuitos (Tenho um post falando sobre isso no meu blog)

### Colocar produtos na wishlist de maneira assincrona

A minha ideia inicial era colocar os produtos na wishlist de maneira async, utilizando o Sidekiq(Equivalente ao Celery do Python), dessa maneira o sistema se tornaria mais escalavel e teria uma fila para adicionar produtos na wishlist (ficando mais resiliente), nao acredito que os produtos precisam ser colocados de maneira sincrona igual foi feito, porem nao tive tempo de adicionar isso.

### Colocar um cache nos produtos

Cheguei a cogitar fazer um cache de produtos em um Redis, primeiro procurar no cache e se nao estiver um la, procurar na API e adicionar no cache, dessa maneira ficaria mais escalavel e mais rapido, o problema e que nao saberia com qual frequencia precisaria invalidar um cache (produto saiu do catalogo), entao preferi por nao fazer cache por hora (tambem nao tinha muito tempo), mas fica como uma sugestao de algum TODO que poderia ser feito.

### Consertar BUG no resource de Users

Os resources de `SHOW`, `UPDATE` e `DESTROY` do user, seguindo o padrao REST pegam o ID do usuario passado como parametro na URL, exemplo `/api/users/<ID_USER>`, porem hoje a aplicacao esta com um bug que independente do ID passado ela so vai realizar a operacao no usuario correspondente ao Token passado, ou seja, se voce fazer um `PUT /api/users/3` passando um token do usuario 2, ele vai realizar a operacao no usuario 2 sempre, enquanto o correto seria enviar um status 401 (Unauthorized), isso e um problema existente porem apenas uma quebra de padrao, um usuario nao conseguiria (nao teria autorizacao) para mexer em outro registro que nao fosse o dele.

### Colocar I18n

Hoje varias mensagens estao hardcoded, seria necessario adicionar I18n na aplicacao.

### Criar uma Postman Collection do projeto

Falta criar uma Postman collection do projeto, com todos endpoints e exemplos de uso.

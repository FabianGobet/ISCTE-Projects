drop table if exists Publicacao ;
drop table if exists Editora ;
drop table if exists Livro_Edicao ;
drop table if exists Periodico ;
drop table if exists Periodicidade ;
drop table if exists AreaTematica ;
drop table if exists PublicacaoTema ;
drop table if exists PalavrasChave ;
drop table if exists Capitulo ;
drop table if exists TagNoLivro ;
drop table if exists Artigo ;
drop table if exists Feed ;
drop table if exists Endereço ;
 
create table Publicacao
(
   NumeroInterno   integer   not null,
   Titulo   varchar(100)   null,
   Subtitulo   varchar(100)   null,
   TituloAbreviado   varchar(50)   null,
   ImagemAmpliadaLink   varchar(150)   null,
   ImagemMiniaturaLink   varchar(150)   null,
   Descricao   varchar(200)   null,
   Autores   varchar(150)   null,
   NumeroPaginas   integer   null,
   DataPublicacao   date   null,
   DataAquisicao   date   null,
 
   constraint PK_Publicacao primary key (NumeroInterno)
);
 
create table Editora
(
   IDEditora   integer   not null,
   Nome   varchar(100)   null,
 
   constraint PK_Editora primary key (IDEditora)
);
 
create table Livro_Edicao
(
   Publicacao_NumeroInterno   integer   not null,
   ISBN   integer   not null,
   Edicao   integer   not null,
 
   constraint PK_Livro_Edicao primary key (ISBN, Edicao)
);
 
create table Periodico
(
   ISSN   integer   not null,
 
   constraint PK_Periodico primary key (ISSN)
);
 
create table Periodicidade
(
   IDPeriodo   integer   not null,
   Designacao   varchar(100)   null,
 
   constraint PK_Periodicidade primary key (IDPeriodo)
);
 
create table AreaTematica
(
   AreaID   integer   not null,
   Designacao   varchar(150)   null,
 
   constraint PK_AreaTematica primary key (AreaID)
);
 
create table PublicacaoTema
(
   PublicacaoTema_ID   integer   not null,
   Relevancia   integer   null,
 
   constraint PK_PublicacaoTema primary key (PublicacaoTema_ID)
);
 
create table PalavrasChave
(
   PalavrasChave_ID   integer   not null,
   Tag   varchar(50)   null,
 
   constraint PK_PalavrasChave primary key (PalavrasChave_ID)
);
 
create table Capitulo
(
   Capitulo_ID   integer   not null,
   Nome   varchar(100)   null,
 
   constraint PK_Capitulo primary key (Capitulo_ID)
);
 
create table TagNoLivro
(
   TagNoLivro_ID   integer   not null,
 
   constraint PK_TagNoLivro primary key (TagNoLivro_ID)
);
 
create table Artigo
(
   Artigo_ID   integer   not null,
   Nome   varchar(100)   null,
 
   constraint PK_Artigo primary key (Artigo_ID)
);
 
create table Feed
(
   Feed_ID   integer   not null,
   URL   varchar(150)   null,
 
   constraint PK_Feed primary key (Feed_ID)
);
 
create table Endereço
(
   Endereço_ID   integer   not null,
   Link   varchar(100)   null,
 
   constraint PK_Endereço primary key (Endereço_ID)
);
 
 
 
alter table Livro_Edicao
   add constraint FK_Livro_Edicao_Publicacao foreign key (Publicacao_NumeroInterno)
   references Publicacao(NumeroInterno)
   on delete cascade
   on update cascade
;
 
 
 
 
 
 
 
 
 
 
 

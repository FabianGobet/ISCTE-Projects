drop table if exists Area ;
 
create table Area
(
   Area_Area_ID   integer   null,
   Area_ID   integer   not null,
   Designacao   varchar(100)   null,
 
   constraint PK_Area primary key (Area_ID)
);
 
alter table Area
   add constraint FK_Area_noname_Area foreign key (Area_Area_ID)
   references Area(Area_ID)
   on delete set null
   on update cascade
;
 

create table person
(
    id          bigint primary key unique not null,
    first_name  varchar(200),
    last_name   varchar(200),
    birth_day   TIMESTAMP,
    education     varchar(200),
    address     varchar(100),
    phone       bigint,
    estekhdam_date date
);

create table deputy_role
(
    id               bigint primary key unique not null,
    deputy_role_name varchar(200)
);

create table management_role
(
    id                   bigint primary key unique not null,
    management_role_name varchar(200)
);

create table role
(
    id                 bigint primary key unique not null,
    deputy_role_id     bigint,
    foreign key (deputy_role_id) references deputy_role (id),
    management_role_id bigint,
    foreign key (management_role_id) references management_role (id)
);

create table person_role
(
    id       bigint primary key unique not null,
    peron_id bigint,
    foreign key (peron_id) references person (id),
    role_id  bigint,
    foreign key (role_id) references role (id)
);

create table base
(
    id             bigint primary key unique not null,
    person_role_id bigint,
    foreign key (person_role_id) references person_role (id),
    start_date     date,
    end_date       date
);
/*insert into person values (120,'ali','ahmadi','1990/02/04','master','tehran,valiasr',1234567,'2018/07/05'),
                          (130,'hasan','hasani','1995/03/14','diplom','tehran,tajrish',70584,'2019/08/12'),
                          (140,'sara','hoseini','1998/05/23','doctora','tehran,sadeghiyeh',54635,'2019/05/05');
insert into deputy_role values (1,'moavenat Toseae'),
                               (2,'moavenat Pajoohesh'),
                               (3,'moavenat Amoozesh');
insert into management_role values (11,'modiriyat Fani'),(12,'modiriyat IT'),(13,'modiriyat mali'),(14,'modiriyat Edari'),
                                   (21,'modiriyat takmuli'),(22,'modiriyat Amoozeshi'),
                                   (31,'modiriyat benol melal'),(32,'modiriyat Omoor pajooheshi');
insert into role values (1,1,11),(2,1,12),(3,1,13),(4,1,14),
                        (5,2,21),(6,2,22),
                        (7,3,31),(8,3,32);
insert into  person_role values (1,120,1),(2,130,2),(3,140,3);
insert into base values (1400,1,'2018/07/05','2020/07/05'),
                        (1401,2,'2019/08/12','2022/08/13'),
                        (1402,3,'2019/05/05','2020/03/02');*/
/*4.1*/
select * from person p
where p.id in (select pr.peron_id
               from person_role pr
               where pr.peron_id in (select b.person_role_id from base b)
                 and pr.role_id in (select r.id from role r where r.deputy_role_id = 1 or r.deputy_role_id = 2));
/*4.2*/
select TIMESTAMP (avg(p.birth_day))
from person p
where p.id in (select pr.peron_id
               from person_role pr
               where pr.id in (select b.person_role_id from base b)
                 and pr.role_id in (select r.id from role r group by r.deputy_role_id, r.id));
/*4.3*/
select count(p.id)
from person p
where p.id in (select pr.peron_id
               from person_role pr
               where pr.id in (select b.person_role_id from base b)
                 and pr.role_id in (select r.id from role r where r.management_role_id = 31))
                   and p.education = 'master' or p.education = 'doctora';

/*4.4*/
/*4.5*/
select *
from person p
         left join person_role pr on p.id = pr.peron_id left join base b on pr.id = b.person_role_id where pr.role_id is null;
/*4.6*/
Select p.id
from person p Where p.last_name in (select o.last_name
                      From person o
                      group by o.last_name
                      having count(o.last_name) > 1);
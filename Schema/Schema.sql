create table pizza_types(
	pizza_type_id varchar(64) primary key,
    name varchar(64),
    category varchar(16),
    ingredients varchar(225)
);

create table pizzas(
	pizza_id varchar(64) primary key,
    pizza_type_id varchar(64),
    size varchar(2),
    price decimal(5,2),
    foreign key (pizza_type_id) references pizza_types(pizza_type_id)
);

create table orders(
	order_id int auto_increment primary key,
    `date` date,
    `time` time
);

DELIMITER //

create trigger set_date_time
before insert on orders
for each row
begin
	if new.`date` is null or new.`time` is null then
		set new.`date` = COALESCE(new.`date`, curdate());
		set new.`time` = COALESCE(new.`time`, curdate());
	end if;
end;
//

DELIMITER ;

create table order_details(
	order_details_id int auto_increment primary key,
    order_id int not null,
    pizza_id varchar(64) not null,
    quantity int,
    foreign key (order_id) references orders(order_id),
    foreign key (pizza_id) references pizzas(pizza_id)
);
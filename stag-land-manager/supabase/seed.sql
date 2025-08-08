-- Optional: sample data
insert into public.projects (name, area, progress) values
('North Area Buildout','North',72),
('Central Area Buildout','Central',48),
('South Area Buildout','South',23);

insert into public.lessors (name, address, email, phone) values
('Jane Doe','123 County Rd, TX','jane@example.com','555-1111'),
('Acme Ranch LLC','County Rd 44, OK','contact@acmeranch.com','555-2222');

insert into public.tracts (project_id, name) 
select id, 'Tract A' from public.projects where name='North Area Buildout';
insert into public.tracts (project_id, name) 
select id, 'Tract B' from public.projects where name='Central Area Buildout';

/* Database schema to keep the structure of entire database. */

/*******************************************
Project 1: create animals table
*******************************************/

CREATE TABLE animals(
    id int GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100),
    date_of_birth DATE,
    escape_attemps INT,
    neutered BOOLEAN,
    weight_kg DECIMAL
);

/*******************************************
Project 2: query and update animals table
*******************************************/

ALTER TABLE animals ADD species VARCHAR(100);

/*******************************************
Project 3: query multiple tables
*******************************************/

CREATE TABLE owners(
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(100),
    age INT,
    PRIMARY KEY(id)
);

CREATE TABLE species(
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100),
    PRIMARY KEY(id)
);

ALTER TABLE animals ADD CONSTRAINT id PRIMARY KEY(ID);
ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD species_id INT, ADD CONSTRAINT fk_species FOREIGN KEY(species_id) REFERENCES species(id);
ALTER TABLE animals ADD owner_id INT, ADD CONSTRAINT fk_owner FOREIGN KEY(owner_id) REFERENCES owners(id);

/*******************************************
Project 4: add join table for visits
*******************************************/

CREATE TABLE vets(
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100),
    age INT,
    date_of_graduation DATE,
    PRIMARY KEY(id)
);

CREATE TABLE specializations(
    vet_id INT,
    species_id INT,
    PRIMARY KEY(vet_id, species_id),
    CONSTRAINT fk_vet FOREIGN KEY(vet_id) REFERENCES vets(id),
    CONSTRAINT fk_species FOREIGN KEY(species_id) REFERENCES species(id)
);

CREATE TABLE visits(
    animal_id INT,
    vet_id INT,
    date_of_visit Date,
    PRIMARY KEY(animal_id, vet_id, date_of_visit),
    CONSTRAINT fk_animal FOREIGN KEY(animal_id) REFERENCES animals(id),
    CONSTRAINT fk_vet FOREIGN KEY(vet_id) REFERENCES vets(id)
);

/*database performance audit*/
create index animals_id_index on visits(animal_id);
create index vet_id_index on visits(vet_id);

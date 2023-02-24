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

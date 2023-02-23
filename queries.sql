/*Queries that provide answers to the questions from all projects.*/

/*******************************
Project 1: create animals table
********************************/
SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attemps < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon','Pikachu');
SELECT (name, escape_attemps) FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/*****************************************
Project 2: query and update animals table
******************************************/

/*Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.*/
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

/*
Inside a transaction:
Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
Commit the transaction.
Verify that change was made and persists after commit.
*/
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;

/*
Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction.
After the rollback verify if all records in the animals table still exists. After that, you can start breathing as usual ;)
*/
BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

/*
Inside a transaction:
Delete all animals born after Jan 1st, 2022.
Create a savepoint for the transaction.
Update all animals' weight to be their weight multiplied by -1.
Rollback to the savepoint
Update all animals' weights that are negative to be their weight multiplied by -1.
Commit transaction
*/
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT SP_1;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals;
ROLLBACK TO SP_1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;

/*
Write queries to answer the following questions:
How many animals are there?
How many animals have never tried to escape?
What is the average weight of animals?
Who escapes the most, neutered or not neutered animals?
What is the minimum and maximum weight of each type of animal?
What is the average number of escape attempts per animal type of those born between 1990 and 2000?
*/

SELECT COUNT(name) FROM animals;
SELECT COUNT(name) FROM animals WHERE escape_attemps = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, SUM(escape_attemps) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP by species;
SELECT species, AVG(escape_attemps) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

/********************************
Project 3: query multiple tables
*********************************/

/*
Write queries (using JOIN) to answer the following questions:
What animals belong to Melody Pond?
List of all animals that are pokemon (their type is Pokemon).
List all owners and their animals, remember to include those that don't own any animal.
How many animals are there per species?
List all Digimon owned by Jennifer Orwell.
List all animals owned by Dean Winchester that haven't tried to escape.
Who owns the most animals?
*/
SELECT name, full_name FROM animals JOIN owners ON owners.id = owner_id WHERE full_name = 'Melody Pond';
SELECT animals.name, species.name FROM animals JOIN species ON species.id = species_id WHERE species.name = 'Pokemon';
SELECT name, full_name FROM animals RIGHT JOIN owners ON owners.id = owner_id;
SELECT species.name, COUNT(animals.name) FROM animals JOIN species ON species.id = species_id GROUP BY species.name;
SELECT animals.name, species.name, full_name FROM animals JOIN owners ON owners.id = owner_id JOIN species ON species.id = species_id WHERE full_name = 'Jennifer Orwell' AND species.name = 'Digimon';
SELECT name, escape_attemps, full_name FROM animals JOIN owners ON owners.id = owner_id WHERE escape_attemps = 0 and full_name = 'Dean Winchester';
SELECT COUNT(name), full_name from animals JOIN owners ON owners.id = owner_id GROUP BY full_name ORDER BY COUNT(name) DESC;

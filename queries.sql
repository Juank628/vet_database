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
SELECT name, full_name FROM animals JOIN owners ON owners.id = animals.owner_id WHERE full_name = 'Melody Pond';
SELECT animals.name, species.name FROM animals JOIN species ON species.id = animals.species_id WHERE species.name = 'Pokemon';
SELECT name, full_name FROM animals RIGHT JOIN owners ON owners.id = animals.owner_id;
SELECT species.name, COUNT(animals.name) FROM animals JOIN species ON species.id = animals.species_id GROUP BY species.name;
SELECT animals.*, species.name, full_name FROM animals JOIN owners ON owners.id = animals.owner_id JOIN species ON species.id = animals.species_id WHERE full_name = 'Jennifer Orwell' AND species.name = 'Digimon';
SELECT name, escape_attemps, full_name FROM animals JOIN owners ON owners.id = animals.owner_id WHERE escape_attemps = 0 and full_name = 'Dean Winchester';
SELECT COUNT(name), full_name from animals JOIN owners ON owners.id = animals.owner_id GROUP BY full_name ORDER BY COUNT(name) DESC;


/*******************************************
Project 4: add join table for visits
*******************************************/
SELECT animals.id, animals.name, vets.name, visits.date_of_visit FROM animals JOIN visits ON animals.id = visits.animal_id JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'William Tatcher' ORDER BY date_of_visit DESC;
SELECT count(animals.name), vets.name FROM visits JOIN vets ON vets.id = visits.vet_id JOIN animals ON animals.id = visits.animal_id WHERE vets.name = 'Stephanie Mendez' GROUP BY vets.name;
SELECT vets.name, species.name FROM vets LEFT JOIN specializations ON vets.id = specializations.vet_id LEFT JOIN species ON species.id = specializations.species_id;
SELECT animals.name, vets.name, visits.date_of_visit FROM visits JOIN vets ON vets.id = visits.vet_id JOIN animals ON animals.id = visits.animal_id WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit > '2020-04-01' AND date_of_visit < '2020-08-30';
SELECT count(animals.name), animals.name FROM visits JOIN animals ON animals.id = visits.animal_id GROUP BY animals.name ORDER BY count(animals.name) DESC;
SELECT animals.name, vets.name, visits.date_of_visit FROM visits JOIN vets ON vets.id = visits.vet_id JOIN animals ON animals.id = visits.animal_id WHERE vets.name = 'Maisy Smith' ORDER BY visits.date_of_visit;
SELECT animals.*, species.name AS species, owners.full_name AS owner_name, vets.name as vet_name, visits.date_of_visit FROM visits JOIN vets ON vets.id = visits.vet_id JOIN animals ON animals.id = visits.animal_id JOIN owners ON owners.id = animals.owner_id JOIN species ON species.id = animals.species_id ORDER BY visits.date_of_visit DESC LIMIT 1;
SELECT COUNT(vets.name) FROM visits JOIN vets ON visits.vet_id=vets.id LEFT JOIN specializations ON vets.id=specializations.vet_id WHERE species_id IS NULL;
SELECT species.name, COUNT(species.name) FROM visits JOIN vets ON visits.vet_id=vets.id JOIN animals ON visits.animal_id=animals.id JOIN species ON animals.species_id=species.id WHERE vets.name='Maisy Smith' GROUP BY species.name ORDER BY COUNT(species.name) DESC LIMIT 1;

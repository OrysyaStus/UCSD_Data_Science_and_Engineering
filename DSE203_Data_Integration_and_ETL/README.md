## DSE-203

This is the official github repository of DSE 203 (Fall 2017).

### Useful links for Git

* [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
* [Git for Beginners](https://www.sitepoint.com/git-for-beginners/)

### Installations

For the purpose of this class, we will be using three data sources extensively.
* [Postgres DB](https://www.postgresql.org/download/)
* Asterix DB
* SOLR DB 

More details regarding installations are available under the "Lectures/Lecture_1/HandsOn" section of this repository.

Condensed version of the book reviews JSON data can now be found in the data folder of this repository.

#### Update Products table in postgres

* Pull the latest changes from GitHub
* Replace the Products table being used by Postgress with the updated one
* Run the following query in Postgres to alter the schema of the Products table
```
ALTER TABLE Products ADD Category varchar(100);
DELETE FROM Products;
COPY Products FROM '$loaddir$Products.txt'
    WITH HEADER NULL 'NULL' DELIMITER '	' CSV;
```
* Don't forget to replace $loaddir$ with the correct path

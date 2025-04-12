# Bookstore Database Schema Documentation

## Overview

This document outlines the database schema for the Online Bookstore Database System, explaining the purpose of each table, its columns, and relationships.

## Core Tables

### Books

The central table that stores information about books available for sale.

| Column | Type | Description |
|--------|------|-------------|
| BookID | INT | Primary key |
| ISBN | NVARCHAR(20) | International Standard Book Number |
| Title | NVARCHAR(255) | Book title |
| PublisherID | INT | Foreign key to Publishers table |
| PublicationDate | DATE | Date the book was published |
| Price | DECIMAL(10,2) | Current selling price |
| Description | NVARCHAR(MAX) | Book description/summary |
| CoverImageURL | NVARCHAR(255) | URL to book cover image |
| InStock | INT | Current inventory count |
| PageCount | INT | Number of pages |
| LanguageCode | NVARCHAR(5) | Language code (e.g., 'en', 'es') |
| DateAdded | DATETIME2 | When the book was added to inventory |

### Authors

Stores information about book authors.

| Column | Type | Description |
|--------|------|-------------|
| AuthorID | INT | Primary key |
| FirstName | NVARCHAR(50) | Author's first name |
| LastName | NVARCHAR(50) | Author's last name |
| Biography | NVARCHAR(MAX) | Author's biographical information |
| BirthDate | DATE | Author's date of birth |
| DateAdded | DATETIME2 | When the author was added to the system |

...

[Continue with details for all tables]

## Relationships

### Book-Author Relationship

Books can have multiple authors, and authors can write multiple books, creating a many-to-many relationship handled by the Book_Authors table.

### Book-Category Relationship

Books can belong to multiple categories, and categories can contain multiple books, creating a many-to-many relationship handled by the Book_Categories table.

...

[Continue with all relationship explanations]

## Views

The database includes several views to simplify common queries:

### vw_BookDetails

Provides comprehensive book information including authors and categories.

### vw_OrderSummary

Summarizes order information with customer details and items purchased.

...

[Continue with all view explanations]

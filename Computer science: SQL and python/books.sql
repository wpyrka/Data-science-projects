ALTER TABLE books_data
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE books_data DROP COLUMN isbn10, DROP COLUMN subtitle, DROP COLUMN thumbnail, DROP COLUMN ratings_count;

ALTER TABLE books_data RENAME COLUMN categories TO genre;
ALTER TABLE books_data RENAME COLUMN isbn13 TO ISBN;

CREATE TABLE authors AS
SELECT authors, genre
FROM books_data;

CREATE TABLE books AS
SELECT id, ISBN, title, description, published_year, average_rating, num_pages
FROM books_data;

ALTER TABLE authors
ADD COLUMN book_id INT AUTO_INCREMENT PRIMARY KEY;

UPDATE authors a
JOIN books b ON a.authors = b.title
SET a.book_id = b.id
WHERE a.book_id IS NULL;


-- Find the average number of pages for each book genre.
SELECT genre, AVG(num_pages) AS avg_pages
FROM authors a
JOIN books b ON a.book_id = b.id
GROUP BY genre;

 -- Select books which are fictions.
SELECT authors, title 
FROM authors
JOIN books ON authors.book_id = books.id
WHERE genre ='Fiction';

-- Find authors who have written books in more than one genre.
SELECT DISTINCT a.authors
FROM authors a
JOIN (
    SELECT authors, COUNT(DISTINCT genre) AS genre_count
    FROM authors
    GROUP BY authors
    HAVING COUNT(DISTINCT genre) > 1
) AS authors_multi_genre ON a.authors = authors_multi_genre.authors;

-- Find books whose average rating is higher than the average rating of all books.
SELECT title, average_rating
FROM books
WHERE average_rating > (
    SELECT AVG(average_rating)
    FROM books
);

-- Display books based on the number of pages, in order from the thickest, but only those with over 500 pages.
SELECT title, authors, MAX(num_pages) AS number_of_pages
FROM books b
JOIN authors a ON b.id = a.book_id
GROUP BY title, authors
HAVING number_of_pages > 500
ORDER BY number_of_pages DESC;

-- Select authors and their books written between 2000 and 2005.
SELECT authors, title, published_year
FROM books b
JOIN authors a ON b.id = a.book_id
WHERE published_year BETWEEN 2000 AND 2005;

-- Find authors who have written books in at least two different genres and whose books have an average rating above 4.5.
SELECT DISTINCT a.authors
FROM authors a
JOIN (
    SELECT authors, COUNT(DISTINCT genre) AS genre_count
    FROM authors
    GROUP BY authors
    HAVING COUNT(DISTINCT genre) >= 2
) AS authors_multi_genre ON a.authors = authors_multi_genre.authors
JOIN books b ON a.book_id = b.id
GROUP BY a.authors
HAVING AVG(b.average_rating) > 4.5;

-- Find all authors whose first name begins with 'P' and the third letter is 't'.
SELECT DISTINCT authors 
FROM authors 
WHERE authors LIKE 'P_t%';

-- Compute the number of books for each genre.
SELECT genre, COUNT(*) AS number_books
FROM authors
GROUP BY genre;

-- Display titles and their genres, which have an average rating greater than 4, starting with the one with the highest average rating.
SELECT title, genre, MAX(average_rating) avg_rating
FROM books b
JOIN authors a ON b.id = a.book_id
GROUP BY title, genre
HAVING avg_rating > 4
ORDER BY avg_rating DESC;

-- Select books which ISBN ends with 5.
SELECT title, ISBN
FROM books
WHERE ISBN like '%5';

-- Find authors who write in a variety of genres, but have an average rating above the average rating of all books.
SELECT DISTINCT a.authors
FROM authors a
JOIN books b ON a.book_id = b.id
LEFT JOIN (
    SELECT authors
    FROM authors
    GROUP BY authors
    HAVING COUNT(DISTINCT genre) > 1
) authors_multi_genre ON a.authors = authors_multi_genre.authors
WHERE authors_multi_genre.authors IS NULL
AND b.average_rating > (SELECT AVG(average_rating) FROM books);

-- Find two authors who have written the most juvenile fiction books.
SELECT authors, COUNT(*) AS number_books
FROM authors
WHERE genre = 'juvenile fiction'
GROUP BY authors
ORDER BY number_books DESC
LIMIT 2;

-- Select the author who wrote the thickest book.
SELECT authors, title, num_pages AS number_of_pages
FROM books b
JOIN authors a ON b.id = a.book_id
WHERE num_pages = (SELECT MAX(num_pages) FROM books);

-- Select these authors whose books have average rating greater than 4.5.
SELECT DISTINCT authors, average_rating
FROM authors AS a
JOIN books AS b ON a.book_id = b.id
WHERE average_rating > 4.5;

-- Select titles about love (in other words these titles described with love).
SELECT title, description 
FROM books 
WHERE description LIKE '%love%';

-- Find genres in which the average number of pages is above the average number of pages of all books.
SELECT genre, AVG(num_pages) AS avg_pages
FROM authors a
JOIN books b ON a.book_id = b.id
GROUP BY genre
HAVING AVG(num_pages) > (SELECT AVG(num_pages) FROM books);

-- Display the title with the highest average rating.
SELECT title, average_rating AS highest_avg_rating
FROM books
WHERE average_rating = (SELECT MAX(average_rating) FROM books);

-- Select books which title has 20 characters and which ISBN number ends with 6.
SELECT authors, title, ISBN
FROM authors AS a 
JOIN books AS b ON a.book_id = b.id
WHERE CHAR_LENGTH(title) = 20 AND ISBN LIKE '%6';

-- Find authors who have written books in all genres.
SELECT authors
FROM (
    SELECT authors, COUNT(DISTINCT genre) AS distinct_genres
    FROM authors
    GROUP BY authors
) AS sub
WHERE distinct_genres = (SELECT COUNT(DISTINCT genre) FROM authors);

-- Display books (their title, genre, description, year) written by Sidney Sheldon.
SELECT authors, genre, title, description, published_year
FROM authors a
JOIN books b ON a.book_id = b.id
WHERE authors = 'Sidney Sheldon';

-- Select the book published at the earliest.
SELECT authors, title, published_year
FROM authors a 
JOIN books b ON a.book_id = b.id
WHERE published_year = (SELECT MIN(published_year) FROM books);


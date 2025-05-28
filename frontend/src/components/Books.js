import React, { useState } from 'react';
import axios from 'axios';
import './Books.css';

const Books = () => {
  const [books, setBooks] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [hasSearched, setHasSearched] = useState(false);

  const fetchBooks = async () => {
    try {
      setLoading(true);
      setError(null);
      setHasSearched(true);
      const response = await axios.get('http://localhost:3000/api/books');
      setBooks(response.data);
    } catch (err) {
      setError('Failed to fetch books. Make sure the backend API is running on port 3000.');
      console.error('Error fetching books:', err);
    } finally {
      setLoading(false);
    }
  };

  const refreshBooks = () => {
    fetchBooks();
  };

  if (loading) {
    return (
      <div className="books-container">
        <div className="loading">
          <div className="spinner"></div>
          <p>Loading books...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="books-container">
        <div className="error">
          <h2>Error</h2>
          <p>{error}</p>
          <button onClick={refreshBooks} className="retry-btn">
            Try Again
          </button>
        </div>
      </div>
    );
  }

  if (!hasSearched) {
    return (
      <div className="books-container">
        <div className="books-header">
          <h1>Books Library - Frontend</h1>
        </div>
        
        <div className="get-books-section">
          <div className="get-books-content">
            <h2>Welcome to the Books Library</h2>
            <p>Click the button below to fetch and display all available books from the API.</p>
            <button onClick={fetchBooks} className="get-books-btn">
              📚 Get Books
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="books-container">
      <div className="books-header">
        <h1>Books Store</h1>
        <button onClick={refreshBooks} className="refresh-btn">
          Refresh
        </button>
      </div>
      
      {books.length === 0 ? (
        <div className="no-books">
          <h2>No books found</h2>
          <p>The library is empty. Add some books to get started!</p>
        </div>
      ) : (
        <div className="books-grid">
          {books.map((book) => (
            <div key={book.id} className="book-card">
              <div className="book-icon">📚</div>
              <h3 className="book-title">{book.title}</h3>
              <div className="book-meta">
                <span className="book-id">ID: {book.id}</span>
              </div>
            </div>
          ))}
        </div>
      )}
      
      <div className="books-footer">
        <p>Total books: {books.length}</p>
      </div>
    </div>
  );
};

export default Books; 
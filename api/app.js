require('dotenv').config();
const express = require('express');
const cors = require('cors');
const booksRouter = require('./routes/books');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/books', booksRouter);

app.get('/', (req, res) => {
  res.json({
    message: 'Books API is running!',
    version: '1.0.0',
    endpoints: {
      'GET /api/books': 'Fetch all books',
      'GET /api/books/:id': 'Fetch a specific book',
      'POST /api/books': 'Create a new book'
    }
  });
});

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    error: 'Something went wrong!',
    message: err.message
  });
});

app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    error: 'Route not found'
  });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`API available at: http://localhost:${PORT}`);
  console.log(`Books endpoint: http://localhost:${PORT}/api/books`);
});

module.exports = app; 
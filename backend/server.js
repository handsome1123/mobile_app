const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(bodyParser.json());

// MySQL connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root', // replace with your MySQL user
    password: '', // replace with your MySQL password
    database: 'flutter_crud'
});

db.connect((err) => {
    if (err) {
        throw err;
    }
    console.log('MySQL Connected...');
});

// Get all items
app.get('/items', (req, res) => {
    let sql = 'SELECT * FROM items';
    db.query(sql, (err, results) => {
        if (err) throw err;
        res.send(results);
    });
});

// Get a single item
app.get('/items/:id', (req, res) => {
    let sql = `SELECT * FROM items WHERE id = ${req.params.id}`;
    db.query(sql, (err, result) => {
        if (err) throw err;
        res.send(result);
    });
});

// Create a new item
app.post('/items', (req, res) => {
    let item = { name: req.body.name, description: req.body.description, price: req.body.price };
    let sql = 'INSERT INTO items SET ?';
    db.query(sql, item, (err, result) => {
        if (err) throw err;
        res.send('Item added...');
    });
});

// Update an item
app.put('/items/:id', (req, res) => {
    let sql = `UPDATE items SET name='${req.body.name}', description='${req.body.description}', price=${req.body.price} WHERE id=${req.params.id}`;
    db.query(sql, (err, result) => {
        if (err) throw err;
        res.send('Item updated...');
    });
});

// Delete an item
app.delete('/items/:id', (req, res) => {
    let sql = `DELETE FROM items WHERE id=${req.params.id}`;
    db.query(sql, (err, result) => {
        if (err) throw err;
        res.send('Item deleted...');
    });
});

app.listen(3000, () => {
    console.log('Server started on port 3000');
});

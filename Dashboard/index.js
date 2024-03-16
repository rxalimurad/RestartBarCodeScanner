const express = require('express');
const { MongoClient, ObjectId } = require('mongodb');
const ejs = require('ejs');
const app = express();
require('dotenv').config();
const port = process.env.PORT || 3000;
const uri = process.env.MONGODB_URI;
const dbName = process.env.DATABASE_NAME;

app.set('view engine', 'ejs');
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
app.get('/', async (req, res) => {
    try {
        await client.connect();
        const db = client.db(dbName);
        const collection = db.collection('Users'); // Replace with your collection name
        const data = await collection.find({}).toArray();
        res.render('index', { data });
    } catch (err) {
        console.error('Error retrieving data:', err);
        res.status(500).json({ error: 'Internal server error' });
    } finally {
        // Close the connection
        await client.close();

    }
});
app.get('/reports', async (req, res) => {
    try {
        await client.connect();
        const db = client.db(dbName);
        const collection = db.collection('Products'); // Replace with your collection name
        const data = await collection.find({ barcode: { $ne: null } }).toArray();
        res.render('reports', { data });
    } catch (err) {
        console.error('Error retrieving data:', err);
        res.status(500).json({ error: 'Internal server error' });
    } finally {
        // Close the connection
        await client.close();
    }
});

app.delete('/delete-product/:id', async (req, res) => {
    try {
        await client.connect();
        const db = client.db(dbName);
        const collection = db.collection('Products'); // Replace with your collection name
        console.log(req.params.id);
        const objectId = new ObjectId(req.params.id);

        const result = await collection.updateOne(
            { _id: objectId }, // Filter criteria
            { $set: { barcode: null, user: null } } // Update fields
        );

        if (result.modifiedCount === 1) {
            res.status(200).end();
        } else {
            res.status(404).json({ error: 'Document not found' });
        }
    } catch (err) {
        console.error('Error updating data:', err);
        res.status(500).json({ error: 'Internal server error' });
    } finally {
        // Close the connection
        await client.close();
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});

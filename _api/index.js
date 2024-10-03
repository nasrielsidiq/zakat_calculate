const express = require('express')
const mysql = require('mysql')
const app = express()
const port = 8040

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'db_zakat_hub'
})

db.connect((err) => {
    if (err) {
        throw err
    }
    console.log('DB Connected');
})

function checkHargaEmas(callback) {
    const query = 'SELECT COUNT(*) AS count FROM harga_emas';
    db.query(query, (err, results) => {
        if (err) throw err;
        const hasData = results[0].count > 0;
        callback(hasData);
    });
}

app.use(express.json())

app.get('/', (req, res) => {
    const sql = "SELECT*FROM harga_emas"
    db.query(sql, (err, results) => {
        if (err) throw err
        res.json(results[0]);
        // res.send('p')
        console.log('get success');
    })
});

app.post('/', (req, res) => {
    const item = req.body
    // const sqlGet = "SELECT COUNT(*) AS count FROM harga_emas"
    const sqlUpdate = 'UPDATE harga_emas SET ?'
    const sqlInsert = 'INSERT INTO harga_emas SET ?'
    // db.query(sqlGet, (err, results) => {
    //     if (err) throw err
    //     data = results[0].count > 0;
    //     console.log(data);
    //     console.log(results);
    // })
    checkHargaEmas((hasData)=> {
        if (hasData) {
            db.query(sqlUpdate, item, (err, results) => {
                if (err) throw err
                res.json(results)
                console.log('Update success');
    
            })
        } else {
            db.query(sqlInsert, item, (err, results) => {
                if (err) throw err
                res.json(results)
                console.log("Insert success");
            })
        }
    })
})

app.post('/xi-xBar', (req, res) => {
    const item = req.body
    const result = item['xi'] * item['xi']
    res.json(result)
})
app.listen(port, () => {
    console.log(`Server runing at ${port}`);
})
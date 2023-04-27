const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql");
const cors = require("cors");
const path = require("path")
const fs = require('fs');
const qs = require('qs')

const app = express();
app.use(express.json())
app.use(express.static(path.join(__dirname, 'public'))) //设置静态文件目录
app.use(cors());
app.use(bodyParser.urlencoded({extended: true}));

app.engine('html', function (filePath, options, callback) {
  fs.readFile(filePath, function (err, content) {
    if (err) return callback(err);

    const {settings, _locals, cache, ...params} = options;

    let rendered = content.toString()
    for (let p in params) {
      rendered = rendered.toString().replace(`#${p}#`, '' + params[p] + '')
    }

    return callback(null, rendered)
  })
})

app.set('views', './views');
app.set('view engine', 'html');

// Connect to the DataBase
var db = mysql.createConnection({
  host:'35.224.110.224',
  user: 'root',         // root
  password: 'Gmancs411',  // Gmancs411
  database: 'Gman_Open_Flight',
})

db.connect(function (err) {
    if (err) throw err;
    console.log("mysql successfully connected")
})

app.get("/", (request, response) => {
  response.render('index')
})

app.get("/advanced", (request, response) => {
  response.render('advanced')
})

// Get all the airline
app.get("/airlines", (request, response) => {
  const params = qs.parse(request.query);
  let sql = "SELECT * FROM Airline where 1=1";
  if (params.name) {
      sql += ` and name like '%${params.name}%'`
  }
  if (params.active) {
      sql +=` and active = '${params.active}'`
    }
  sql += ' limit 20'
  db.query(sql, function (err, result, fields) {
    response.send(result);
    if (err) throw err;
  });
});

// Get all the Routes
app.get("/routes", (request, response) => {
  const params = qs.parse(request.query);
  let sql = "SELECT * FROM Route";
  
  if (params.id) {
      sql += ` WHERE Airline_ID = ${params.id}`
  }

  sql += ' limit 20'
  db.query(sql, function (err, result, fields) {
    response.send(result);
    if (err) throw err;
  });
});

// Insert new records (rows) to the database
app.post("/airline/add", (request, response) => {
  const row = [
    request.body.Airline_ID,
    request.body.Name,
    request.body.IATA,
    request.body.ICAO,
    request.body.Callsign,
    request.body.Country,
    request.body.Active,
  ]

  const sql = "insert into Airline(Airline_ID, Name, IATA, ICAO, Callsign,Country,Active) values(?,?,?,?,?,?,?)";
  db.query(sql, row, function (err, result) {
    console.log(err)
    if (err) {
      console.log(error);
      error(response, err.sqlMessage)
    } else {
      success(response)
    }
  });
});

// Update records on the database
app.post("/airline/update", (request, response) => {
    const row = [
        request.body.Name,
        request.body.IATA,
        request.body.ICAO,
        request.body.Callsign,
        request.body.Country,
        request.body.Active,
        request.body.Airline_ID,
    ]
  var sqlDelete = "update Airline set Name=?, IATA=?, ICAO=?, Callsign=?,Country=?,Active=? WHERE Airline_ID = ?";
  db.query(sqlDelete, row, (err) => {
    if (err) {
      console.log(error);
      error(response)
    } else {
      success(response)
    }
  })
});


// Delete rows from the database
app.delete("/airline/:id", (request, response) => {
  const sql = "delete from Airline WHERE Airline_ID = ?";
  db.query(sql, request.params.id, (err, result) => {
    if (err) {
      console.log(error);
      error(response)
    } else {
      success(response)
    }
  })
});

function success(res) {
  res.send({
    code: 200
  })
}

function error(res, msg) {
  res.send({
    code: -1,
    msg
  })
}

//  Integrate into your application both of the advanced SQL queries you developed in stage 3
app.get("/airport/name/:airlineId", (request, response) => {
  const airlineId = request.params.airlineId

  let sql = `select distinct a.Name
             from Airport a join Route r on a.Airport_ID = r.Destination_Airport_ID
             where r.Source_Airport_ID in (select Source_Airport_ID from Route 
             where Airline_ID = ${airlineId})`

  db.query(sql, function (err, result, fields) {
    response.send(result);
    if (err) throw err;
  });
});

app.get("/city/name/:cityName", (request, response) => {
  const cityName = request.params.cityName

  let sql = `select c.Name, count(r.Source_Airport_ID) as num
             from City c join Route r on c.City_ID = r.Source_Airport_ID
             where c.Name like "${cityName}%"
             group by c.Name
             order by num desc`
  console.log(sql)
  db.query(sql, function (err, result, fields) {
    response.send(result);
    if (err) throw err;
  });
});

app.listen(3002, () => {
  console.log("running on port 3002");
})

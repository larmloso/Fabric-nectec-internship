const app = require('./app');
const PORT = process.env.port || 3000;

app.listen(PORT, (req, res) => {
  console.log("server",PORT);
});



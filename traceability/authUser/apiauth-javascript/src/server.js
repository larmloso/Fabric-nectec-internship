require('dotenv').config({
  path: `${__dirname}/.env`
})

const PORT = process.env.PORT || 3000;
const app = require('./app');

app.listen(PORT, (req, res) => {
  console.log("server ", PORT);
});

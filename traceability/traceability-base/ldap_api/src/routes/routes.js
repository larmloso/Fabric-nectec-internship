const router = require("express").Router();
const jwt = require("jsonwebtoken");
require("../app");
var passport = require("passport");

const { veriffyToken } = require("../functions/veriffyToken");
const clinet = require('../helpers/init_redis')

let refreshTokens = [];

router.delete('/api/logout',veriffyToken,(req, res, next) => {
  // @ts-ignore
    const refreshToken = req.token
    // console.log(refreshToken, "refreshTokens");
    clinet.DEL(refreshToken,(err, val) => {
      if (err) return res.send({ status: 500, data: "No token" });
      else return res.send({ message: "Delete Done" });
    })
})

router.post("/api/login", (req, res, next) => {
  passport.authenticate(
    "ldapauth",
    { session: false },
    function (err, user, info) {
      var error = err || info;
      const users = user;
      // console.log(users);
    
      // token
      jwt.sign({ user: users}, "secrekey", (err, token) => {
          
        // refresh Tokens  
        refreshTokens = [];
        refreshTokens.push(token);
        // console.log(refreshTokens);

        if (error) return res.send({ status: 500, data: error });

        if (!user) {
            res.send({ status: 404, data: "User Not Found" });            
        } else {
          clinet.SET(token, refreshTokens, (err, value) => {
            if(err) console.log(err.message)
            return
          })
          res.send({ status: 200, data: user, token: token });
        }
      });
    }
  )(req, res, next);
});

router.get("/api/posts/:token", (req, res, next) => {
  // @ts-ignore
  const refreshToken = req.params.token;
  // const refreshToken = req.token;
    jwt.verify(refreshToken, "secrekey", (err, data) => {
      clinet.exists(refreshToken, (err, reply) => {
        // console.log(reply, "reply");
        if (refreshToken == null) return res.send({ status: 401, data: "No token" });
           if (reply === 1) {
            // console.log('Exists!');
            res.json({ message: "information lists", data });
          } else {
            // console.log('Doesn\'t exist!');
            return res.send({ status: 500, data: "No token" });
          }
      })
    });
});

module.exports = router;

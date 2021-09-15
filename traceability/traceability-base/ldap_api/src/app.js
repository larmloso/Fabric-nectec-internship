
var express = require("express"),
passport = require("passport"),
LdapStrategy = require("passport-ldapauth");
var fs = require("fs");
var app = express();
var basicAuth = require("basic-auth");
require('./helpers/init_redis')

var cors = require('cors')
require('dotenv').config()
const helmet = require("helmet");

const DOMAINS = process.env.domain || `none`;
const PORTLDAP = process.env.portldap || 389;
// console.log(DOMAINS);
// console.log(PORTLDAP);

var getLDAPConfiguration = function (req, callback) {
  process.nextTick(function () {
    const OPTS = {
      server: {
        url: `ldap://${DOMAINS}:${PORTLDAP}`,
        bindDN: "cn=admin,dc=ramhlocal,dc=com",
        bindCredentials: "password",
        searchBase: "dc=ramhlocal,dc=com",
        searchFilter: "(uid={{username}})",
        credentialsLookup: basicAuth,
      },
    };
    callback(null, OPTS);
  });
};

// passport.use(new LdapStrategy(OPTS));


app.use(helmet());
app.use(cors());

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(passport.initialize());

passport.use(
  new LdapStrategy(getLDAPConfiguration, function (username, done) {
    return done(null, username);
  })
);

app.use(require('./routes/routes'));
module.exports = app;
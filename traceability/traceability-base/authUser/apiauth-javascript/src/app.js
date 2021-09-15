const express = require("express");
const passport = require("passport");
const LdapStrategy = require("passport-ldapauth");
const app = express();
const basicAuth = require("basic-auth");

const cors = require('cors')
const helmet = require("helmet");

require('dotenv').config({
    path: `${__dirname}/.env`
})

const DOMAIN = process.env.DOMAIN || `localhost`;
const LDAP_PORT = process.env.LDAP_PORT || 389;
const ADMINUSER = process.env.ADMINUSER;
const PASSWORD = process.env.PASSWORD;
const DC1 = process.env.DC1;
const DC2 = process.env.DC2;



var getLDAPConfiguration = function (req, callback) {
    process.nextTick(function () {
        const OPTS = {
            server: {
                url: `ldap://${DOMAIN}:${LDAP_PORT}`,
                bindDN: `cn=${ADMINUSER},dc=${DC1},dc=${DC2}`,
                bindCredentials: `${PASSWORD}`,
                searchBase: `dc=${DC1},dc=${DC2}`,
                searchFilter: "(uid={{username}})",
                credentialsLookup: basicAuth,
            },
        };
        callback(null, OPTS);
    });
};

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
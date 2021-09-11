const express = require("express");
const passport = require("passport");
const LdapStrategy = require("passport-ldapauth");
const app = express();
const basicAuth = require("basic-auth");

const cors = require('cors')
require('dotenv').config()
const helmet = require("helmet");

const DOMAIN = process.env.DOMAIN || `none`;
const LDAP_PORT = process.env.LDAP_PORT || 389;

console.log(DOMAIN);
console.log(LDAP_PORT);

var getLDAPConfiguration = function (req, callback) {
    process.nextTick(function () {
        const OPTS = {
            server: {
                url: `ldap://${DOMAIN}:${LDAP_PORT}`,
                bindDN: "cn=admin,dc=example,dc=com",
                bindCredentials: "admin_pass",
                searchBase: "dc=example,dc=com",
                searchFilter: "(uid={{username}})",
                credentialsLookup: basicAuth,
            },
        };
        callback(null, OPTS);
    });
};

// passport.use(new LdapStrategy(OPTS));
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
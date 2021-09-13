function veriffyToken(req, res, next) {

    const bearerHeader = req.headers["authorization"];
    
    if (typeof bearerHeader !== "undefined") {
        const bearerToken = bearerHeader.split(" ")[1];
        req.token = bearerToken;
        next();
    } else {
        res.send({ status: 500, data: "Error" });
    }
}

module.exports = { veriffyToken };
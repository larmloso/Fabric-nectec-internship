import express, { Request, Response, NextFunction } from 'express';
import cors from "cors";

import { Gateway, GatewayOptions } from 'fabric-network';
import * as path from 'path';
import { buildCCPOrg, buildWallet, prettyJSONString } from './utils//AppUtil';
import { buildCAClient, enrollAdmin, registerAndEnrollUser } from './utils/CAUtil';
import * as dotenv from "dotenv";

dotenv.config();
const PORT: number = parseInt(process.env.PORT as string, 10);

const channelName = process.env.ChannelName;
const chaincodeName = process.env.ChaincodeName;
const mspOrg = process.env.MSPOrg;
const walletPath = path.join(__dirname, 'wallet');
const org2UserId = 'admin';
const CA = process.env.CAorg;
const department = process.env.Department;
const CCP = buildCCPOrg();

const app = express();
const port = PORT;
app.use(cors());
app.use(express.json());

import { VerifyToken } from './utils/VerifyToken';

app.get('/api/ReadAsset/:id', async (req: Request, res: Response) => {

    /// check auth user
    try {
        await VerifyToken(res.req.headers.authorization);
    } catch (e) {
        return res.status(403).send('Forbidden : token not found');
    }

    const id: string = req.params.id;
    try {
        let item;
        try {
            const ccp = CCP;
            const caClient = buildCAClient(ccp, CA);
            const wallet = await buildWallet(walletPath);
            await enrollAdmin(caClient, wallet, mspOrg);
            await registerAndEnrollUser(caClient, wallet, mspOrg, org2UserId, department);
            const gateway = new Gateway();
            const gatewayOpts: GatewayOptions = {
                wallet,
                identity: org2UserId,
                discovery: { enabled: true, asLocalhost: false },
            };
            try {
                await gateway.connect(ccp, gatewayOpts);
                const network = await gateway.getNetwork(channelName);
                const contract = network.getContract(chaincodeName);
                let result = await contract.evaluateTransaction('ReadAsset', id);
                item = JSON.parse(result.toString());
                console.log(item);

            } finally {
                gateway.disconnect();
            }
        } catch (error) {
            console.error(`******** FAILED to run the application: ${error}`);
        }
        if (item) {
            return res.status(200).send(item);
        }
        res.status(404).send("item not found");
    } catch (e) {
        res.status(500).send(e.message);
    }

});

app.get('/api/GetAllAssets', async (req: Request, res: Response) => {

    /// check auth user
    try {
        await VerifyToken(res.req.headers.authorization);
    } catch (e) {
        return res.status(403).send('Forbidden : token not found');
    }


    try {
        let item;
        try {
            const ccp = CCP;
            const caClient = buildCAClient(ccp, CA);
            const wallet = await buildWallet(walletPath);
            await enrollAdmin(caClient, wallet, mspOrg);
            await registerAndEnrollUser(caClient, wallet, mspOrg, org2UserId, department);
            const gateway = new Gateway();
            const gatewayOpts: GatewayOptions = {
                wallet,
                identity: org2UserId,
                discovery: { enabled: true, asLocalhost: false },
            };
            try {
                await gateway.connect(ccp, gatewayOpts);
                const network = await gateway.getNetwork(channelName);
                const contract = network.getContract(chaincodeName);
                let result = await contract.evaluateTransaction('GetAllAssets');
                item = JSON.parse(result.toString());
            } finally {
                gateway.disconnect();
            }
        } catch (error) {
            console.error(`******** FAILED to run the application: ${error}`);
        }
        if (item) {
            return res.status(200).send(item);
        }
        res.status(404).send("item not found");
    } catch (e) {
        res.status(500).send(e.message);
    }

});

app.get('/api/filters/:filter/:method/:pageSize/:bookmark', async (req: Request, res: Response) => {

    /// check auth user
    try {
        await VerifyToken(res.req.headers.authorization);
    } catch (e) {
        return res.status(403).send('Forbidden : token not found');
    }


    const filter: string = req.params.filter;
    const method: string = req.params.method;
    const pageSize: string = req.params.pageSize;
    const bookmark: string = req.params.bookmark;
    let bm;
    if (bookmark == "start") {
        bm = "";
    } else {
        bm = bookmark;
    }
    try {
        let item;
        try {
            const ccp = CCP;
            const caClient = buildCAClient(ccp, CA);
            const wallet = await buildWallet(walletPath);
            await enrollAdmin(caClient, wallet, mspOrg);
            await registerAndEnrollUser(caClient, wallet, mspOrg, org2UserId, department);
            const gateway = new Gateway();
            const gatewayOpts: GatewayOptions = {
                wallet,
                identity: org2UserId,
                discovery: { enabled: true, asLocalhost: false },
            };
            try {
                await gateway.connect(ccp, gatewayOpts);
                const network = await gateway.getNetwork(channelName);
                const contract = network.getContract(chaincodeName);
                const query = {
                    selector: {},
                    sort: [{}]
                }
                if (filter != "filter" && method != "method") {
                    if (filter == "transferredStatus" || filter == "transferringStatus") {
                        var boolValue = JSON.parse(method);
                        query.selector[filter] = boolValue;
                    } else {
                        query.selector[filter] = { $regex: '(?i)' + method + '+' }
                    }

                }
                query.sort[0]["datetime"] = "desc"
                let result = await contract.evaluateTransaction("QueryAssetsWithPagination", JSON.stringify(query), pageSize, bm);
                item = JSON.parse(result.toString());
            } finally {
                gateway.disconnect();
            }
        } catch (error) {
            console.error(`******** FAILED to run the application: ${error}`);
        }
        if (item) {
            return res.status(200).send(item);
        }
        res.status(404).send("item not found");
    } catch (e) {
        res.status(500).send(e.message);
    }

});

app.post("/api/CreateAsset", async (req: Request, res: Response) => {

    /// check auth user
    try {
        await VerifyToken(res.req.headers.authorization);
    } catch (e) {
        return res.status(403).send('Forbidden : token not found');
    }


    try {
        const item = req.body;
        const amount = item.amount;
        const datetime = item.datetime;
        const note = item.note;
        const type = item.type;
        const user = item.user;

        try {
            const ccp = CCP;
            const caClient = buildCAClient(ccp, CA);
            const wallet = await buildWallet(walletPath);
            await enrollAdmin(caClient, wallet, mspOrg);
            await registerAndEnrollUser(caClient, wallet, mspOrg, org2UserId, department);
            const gateway = new Gateway();
            const gatewayOpts: GatewayOptions = {
                wallet,
                identity: org2UserId,
                discovery: { enabled: true, asLocalhost: false },
            };
            try {
                await gateway.connect(ccp, gatewayOpts);
                const network = await gateway.getNetwork(channelName);
                const contract = network.getContract(chaincodeName);
                await contract.submitTransaction('CreateAsset', type, amount.toString(), note, user, datetime);
                // console.log('*** Result: committed');
            } finally {
                gateway.disconnect();
            }
        } catch (error) {
            console.error(`******** FAILED to run the application: ${error}`);
        }
        res.status(201).json(item);
    } catch (e) {
        res.status(500).send(e.message);
    }
});

app.post("/api/CreateProcess", async (req: Request, res: Response) => {

    /// check auth user
    try {
        await VerifyToken(res.req.headers.authorization);
    } catch (e) {
        return res.status(403).send('Forbidden : token not found');
    }


    try {
        const item = req.body;
        let amount = 0;
        const datetime = item.datetime;
        const note = item.note;
        const type = item.type;
        const user = item.user;
        const referrence = JSON.stringify(item.referrenceProductList);
        let Status = true;
        let text = item;
        try {
            const ccp = CCP;
            const caClient = buildCAClient(ccp, CA);
            const wallet = await buildWallet(walletPath);
            await enrollAdmin(caClient, wallet, mspOrg);
            await registerAndEnrollUser(caClient, wallet, mspOrg, org2UserId, department);
            const gateway = new Gateway();
            const gatewayOpts: GatewayOptions = {
                wallet,
                identity: org2UserId,
                discovery: { enabled: true, asLocalhost: false },
            };
            try {
                await gateway.connect(ccp, gatewayOpts);
                const network = await gateway.getNetwork(channelName);
                const contract = network.getContract(chaincodeName);
                for (let key of item.referrenceProductList) {
                    let result = await contract.evaluateTransaction("ReadAsset", key.token);
                    const ReadAsset = JSON.parse(result.toString());
                    if (ReadAsset.amount >= key.amount) {
                        if (ReadAsset.transferringStatus == false && ReadAsset.transferredStatus == false) {
                            continue;
                        } else {
                            text = "transferringStatus and transferredStatus is false"
                            Status = false;
                            break;
                        }
                    } else {
                        text = "amount not enough "
                        Status = false;
                        break;
                    }
                }
                if (Status == true) {
                    let token = await contract.submitTransaction('CreateNewProduct', type, note, user, referrence, datetime);
                    console.log(token.toString());
                    for (let key of item.referrenceProductList) {
                        let result = await contract.evaluateTransaction("ReadAsset", key.token);
                        const ReadAsset = JSON.parse(result.toString());
                        amount = ReadAsset.amount - key.amount;
                        let rf = {
                            "token": key.token,
                            "amount": amount
                        }
                        await contract.submitTransaction('CreateProduct', ReadAsset.type, amount.toString(), ReadAsset.note, ReadAsset.user, JSON.stringify(rf), ReadAsset.datetime, token.toString());
                    }
                } else {
                    console.error(text);
                }

            } finally {
                gateway.disconnect();
            }
        } catch (error) {
            console.error(`******** FAILED to run the application: ${error}`);
        }
        res.status(201).json(text);
    } catch (e) {
        res.status(500).send(e.message);
    }
});

app.post("/api/TransferAsset", async (req: Request, res: Response) => {

    /// check auth user
    try {
        await VerifyToken(res.req.headers.authorization);
    } catch (e) {
        return res.status(403).send('Forbidden : token not found');
    }

    try {
        const item = req.body;
        const token = item.token;
        try {
            const ccp = CCP;
            const caClient = buildCAClient(ccp, CA);
            const wallet = await buildWallet(walletPath);
            await enrollAdmin(caClient, wallet, mspOrg);
            await registerAndEnrollUser(caClient, wallet, mspOrg, org2UserId, department);
            const gateway = new Gateway();
            const gatewayOpts: GatewayOptions = {
                wallet,
                identity: org2UserId,
                discovery: { enabled: true, asLocalhost: false },
            };
            try {
                await gateway.connect(ccp, gatewayOpts);
                const network = await gateway.getNetwork(channelName);
                const contract = network.getContract(chaincodeName);
                await contract.submitTransaction('TransferAsset', token);
                console.log('*** Result: committed');
            } finally {
                gateway.disconnect();
            }
        } catch (error) {
            console.error(`******** FAILED to run the application: ${error}`);
        }
        res.status(201).json(item);
    } catch (e) {
        res.status(500).send(e.message);
    }
});

app.post("/api/Receive", async (req: Request, res: Response) => {

    /// check auth user
    try {
        await VerifyToken(res.req.headers.authorization);
    } catch (e) {
        return res.status(403).send('Forbidden : token not found');
    }


    try {
        const item = req.body;
        // console.log(item.token);
        let text;

        try {
            const ccp = CCP;
            const caClient = buildCAClient(ccp, CA);
            const wallet = await buildWallet(walletPath);
            await enrollAdmin(caClient, wallet, mspOrg);
            await registerAndEnrollUser(caClient, wallet, mspOrg, org2UserId, department);
            const gateway = new Gateway();
            const gatewayOpts: GatewayOptions = {
                wallet,
                identity: org2UserId,
                discovery: { enabled: true, asLocalhost: false },
            };
            try {
                await gateway.connect(ccp, gatewayOpts);
                const network = await gateway.getNetwork(channelName);
                const contract = network.getContract(chaincodeName);

                await contract.submitTransaction('Receive', item.token);
                // let result = await contract.evaluateTransaction("Receive", item.token);
                // console.log(result.toString());
                console.log("Receive");
                console.log('*** Result: committed');

            } finally {
                gateway.disconnect();
            }
        } catch (error) {
            console.error(`******** FAILED to run the application: ${error}`);
        }
        res.status(201).json(item);
    } catch (e) {
        res.status(500).send(e.message);
    }
});

app.listen(port, () => {
    console.log(`location application is running on port ${port}.`);
});
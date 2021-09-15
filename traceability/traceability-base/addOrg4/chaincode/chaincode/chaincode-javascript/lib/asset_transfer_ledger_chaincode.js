
'use strict';

const { Contract } = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;

class Chaincode extends Contract {

	// CreateAsset - create a new asset, store into chaincode state
	async CreateAsset(ctx, type, amount, note, user, datetime) {

		let txID = ctx.stub.getTxID();
		// let creator = ctx.stub.getCreator()
		let TxTimestamp = ctx.stub.getTxTimestamp();
		let cid = new ClientIdentity(ctx.stub);
		let creator = cid.getMSPID();

		let date = datetime;
		if (date == "default") {
			date = TxTimestamp.seconds.low.toString()
		}

		const exists = await this.AssetExists(ctx, txID);
		if (exists) {
			throw new Error(`The asset ${txID} already exists`);
		}

		// ==== Create asset object and marshal to JSON ====	
		let asset = {
			token: txID,
			type: type,
			datetime: date,
			creator: creator,
			amount: Number(amount),
			note: note,
			transferringStatus: false,
			transferredStatus: false,
			transferringtime: null,
			transferredtime: null,
			target: null,
			user: user,
			timestamp: TxTimestamp.seconds.low.toString()
		};

		// === Save asset to state ===
		await ctx.stub.putState(txID, Buffer.from(JSON.stringify(asset)));
		let indexdatetime = 'datetime~name';
		let NameIndexKey = await ctx.stub.createCompositeKey(indexdatetime, [asset.datetime, asset.token]);

		//  Save index entry to state. Only the key name is needed, no need to store a duplicate copy of the marble.
		//  Note - passing a 'nil' value will effectively delete the key from state, therefore we pass null character as value
		await ctx.stub.putState(NameIndexKey, Buffer.from('\u0000'));
	}

	async CreateProcess(ctx, token, target) {
		let TxTimestamp = ctx.stub.getTxTimestamp();
		const assetString = await this.ReadAsset(ctx, token);
		const asset = JSON.parse(assetString);
		asset.transferredStatus = true; //change the transferredStatus
		asset.transferredtime = TxTimestamp.seconds.low.toString(); //change the transferredtime
		asset.target = target; //change the target
		return ctx.stub.putState(token, Buffer.from(JSON.stringify(asset)));
	}

	async CreateProduct(ctx, type, amount, note, user, referrence, datetime, token) {
		let txID = ctx.stub.getTxID()
		let TxTimestamp = ctx.stub.getTxTimestamp()
		// let DateTimestamp = ctx.stub.getDateTimestamp()
		let date = datetime;
		let cid = new ClientIdentity(ctx.stub);
		let creator = cid.getMSPID();
		let referrenceProduct = JSON.parse(referrence);
		if (date == "default") {
			date = TxTimestamp.seconds.low.toString()
		}

		const exists = await this.AssetExists(ctx, txID);
		if (exists) {
			throw new Error(`The asset ${txID} already exists`);
		}

		await this.CreateProcess(ctx, referrenceProduct.token, token);

		// ==== Create asset object and marshal to JSON ====	
		let asset = {
			token: txID,
			type: type,
			datetime: date,
			amount: Number(amount),
			creator: creator,
			note: note,
			transferringStatus: false,
			transferredStatus: false,
			transferringtime: null,
			transferredtime: null,
			referrenceProductList: [referrenceProduct],
			target: null,
			user: user,
			timestamp: TxTimestamp.seconds.low.toString()
		};

		// === Save asset to state ===
		await ctx.stub.putState(txID, Buffer.from(JSON.stringify(asset)));
	}

	async CreateNewProduct(ctx, type, note, user, referrenceProductList, datetime) {
		let txID = ctx.stub.getTxID();
		let TxTimestamp = ctx.stub.getTxTimestamp();
		let cid = new ClientIdentity(ctx.stub);
		let creator = cid.getMSPID();
		let referrence = JSON.parse(referrenceProductList);
		let amount = 0;

		for (let key of referrence) {
			amount += key.amount;
		}

		let date = datetime;
		if (date == "default") {
			date = TxTimestamp.seconds.low.toString()
		}
		const exists = await this.AssetExists(ctx, txID);
		if (exists) {
			throw new Error(`The asset ${txID} already exists`);
		}
		// ==== Create asset object and marshal to JSON ====	
		let asset = {
			token: txID,
			type: type,
			datetime: date,
			creator: creator,
			amount: Number(amount),
			note: note,
			transferringStatus: false,
			transferredStatus: false,
			transferringtime: null,
			transferredtime: null,
			referrenceProductList: referrence,
			target: null,
			user: user,
			timestamp: TxTimestamp.seconds.low.toString(),
			target: null
		};

		// === Save asset to state ===
		await ctx.stub.putState(txID, Buffer.from(JSON.stringify(asset)));
		return txID;
	}

	// ReadAsset returns the asset stored in the world state with given id.
	async ReadAsset(ctx, id) {
		const assetJSON = await ctx.stub.getState(id); // get the asset from chaincode state
		if (!assetJSON || assetJSON.length === 0) {
			throw new Error(`Asset ${id} does not exist`);
		}

		return assetJSON.toString();
	}

	async GetAllAssets(ctx) {
		const allResults = [];
		// range query with empty string for startKey and endKey does an open-ended query of all assets in the chaincode namespace.
		const iterator = await ctx.stub.getStateByRange('', '');
		let result = await iterator.next();
		while (!result.done) {
			const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
			let record;
			try {
				record = JSON.parse(strValue);
			} catch (err) {
				console.log(err);
				record = strValue;
			}
			allResults.push({ Key: result.value.key, Record: record });
			result = await iterator.next();
		}
		return JSON.stringify(allResults);
	}

	async TransferProduct(ctx, token) {
		const assetString = await this.ReadAsset(ctx, token);
		const asset = JSON.parse(assetString);

		let txID = ctx.stub.getTxID()
		let TxTimestamp = ctx.stub.getTxTimestamp()
		let cid = new ClientIdentity(ctx.stub);
		let creator = cid.getMSPID();
		let referrenceProduct = {
			"token": token,
			"amount": asset.amount
		}
		const exists = await this.AssetExists(ctx, txID);
		if (exists) {
			throw new Error(`The asset ${txID} already exists`);
		}

		// ==== Create asset object and marshal to JSON ====	
		let data = {
			token: txID,
			type: asset.type,
			datetime: asset.datetime,
			amount: Number(asset.amount),
			creator: creator,
			note: asset.note,
			transferringStatus: false,
			transferredStatus: false,
			transferringtime: null,
			transferredtime: null,
			referrenceProductList: [referrenceProduct],
			target: null,
			user: asset.user,
			timestamp: TxTimestamp.seconds.low.toString()
		};

		// === Save data to state ===
		await ctx.stub.putState(txID, Buffer.from(JSON.stringify(data)));
		asset.target = txID; //change the target
		asset.transferredStatus = true; //change the transferredStatus
		asset.transferringStatus = false; //change the transferringStatus
		asset.transferredtime = TxTimestamp.seconds.low.toString(); //change the transferredtime
		return ctx.stub.putState(token, Buffer.from(JSON.stringify(asset)));
	}

	async Receive(ctx, token) {
		const assetString = await this.ReadAsset(ctx, token);
		const asset = JSON.parse(assetString);
		if (asset.transferringStatus === true && asset.transferredStatus === false) {
			await this.TransferProduct(ctx, token);
		} else {
			throw new Error(`Asset ${id} transfer already`);
		}
	}

	async TransferAsset(ctx, token) {

		const assetString = await this.ReadAsset(ctx, token);
		const asset = JSON.parse(assetString);
		if (asset.transferredStatus === false && asset.transferringStatus === false) {
			asset.transferringStatus = true; //change the transferringStatus
			const datetransfer = ctx.stub.getTxTimestamp().seconds.low.toString();
			asset.transferringtime = datetransfer;
			return ctx.stub.putState(token, Buffer.from(JSON.stringify(asset))); //rewrite the asset
		} else {
			throw new Error(`Asset ${id} transfer already`);
		}
	}

	async QueryAssetsWithPagination(ctx, queryString, pageSize, bookmark) {
		let cid = new ClientIdentity(ctx.stub);
		let creator = cid.getMSPID();
		let queryStr = JSON.parse(queryString);
		queryStr.selector["creator"] = creator

		const { iterator, metadata } = await ctx.stub.getQueryResultWithPagination(JSON.stringify(queryStr), pageSize, bookmark);
		const results = await this.GetAllResults(iterator, false);

		results.ResponseMetadata = metadata;

		return JSON.stringify(results);
	}

	// GetAssetHistory returns the chain of custody for an asset since issuance.
	async GetAssetHistory(ctx, assetName) {

		let resultsIterator = await ctx.stub.getHistoryForKey(assetName);
		let results = await this.GetAllResults(resultsIterator, true);

		return JSON.stringify(results);
	}

	// AssetExists returns true when asset with given ID exists in world state
	async AssetExists(ctx, assetName) {
		// ==== Check if asset already exists ====
		let assetState = await ctx.stub.getState(assetName);
		return assetState && assetState.length > 0;
	}

	async GetAllResults(iterator, isHistory) {
		const results = {};
		results.data = [];
		let res = await iterator.next();
		while (!res.done) {
			if (res.value && res.value.value.toString()) {
				let jsonRes = {};
				console.log(res.value.value.toString('utf8'));
				if (isHistory && isHistory === true) {
					jsonRes.TxId = res.value.tx_id;
					jsonRes.Timestamp = res.value.timestamp;
					try {
						jsonRes.Value = JSON.parse(res.value.value.toString('utf8'));
					} catch (err) {
						console.log(err);
						jsonRes.Value = res.value.value.toString('utf8');
					}
				} else {
					jsonRes.Key = res.value.key;
					try {
						jsonRes.Record = JSON.parse(res.value.value.toString('utf8'));
					} catch (err) {
						console.log(err);
						jsonRes.Record = res.value.value.toString('utf8');
					}
				}
				results.data.push(jsonRes);
			}
			res = await iterator.next();
		}
		iterator.close();
		return results;
	}

}

module.exports = Chaincode;
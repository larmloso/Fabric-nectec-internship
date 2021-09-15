import axios, { AxiosResponse } from 'axios';
import * as dotenv from "dotenv";

dotenv.config();

const VerifyToken = async (token: String) => {

    let result: AxiosResponse = await axios.get(`${process.env.ENDPOINT}/api/auth/me`, {
        headers: { 'Authorization': token }
    });

    return result
};

export {
    VerifyToken,
};
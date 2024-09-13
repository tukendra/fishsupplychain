import React, { useState, useEffect } from 'react';
import Web3 from 'web3';
import FishSupplyChain from './contracts/FishSupplyChain.json';
import './App.css';

const App = () => {
    const [account, setAccount] = useState('');
    const [contract, setContract] = useState(null);
    const [web3, setWeb3] = useState(null);
    const [fishIndustryKey, setFishIndustryKey] = useState('');
    const [distributorKey, setDistributorKey] = useState('');
    const [retailerKey, setRetailerKey] = useState('');
    const [customerKey, setCustomerKey] = useState('');

    useEffect(() => {
        const initWeb3 = async () => {
            if (window.ethereum) {
                const web3Instance = new Web3(window.ethereum);
                try {
                    await window.ethereum.enable();
                    setWeb3(web3Instance);
                } catch (error) {
                    console.error("User permission denied for account access", error);
                }
            } else if (window.web3) {
                const web3Instance = new Web3(window.web3.currentProvider);
                setWeb3(web3Instance);
            } else {
                console.log("Non-Ethereum browser detected. You should consider trying MetaMask!");
            }
        };

        const loadBlockchainData = async () => {
            if (web3) {
                const accounts = await web3.eth.getAccounts();
                setAccount(accounts[0]);

                const networkId = await web3.eth.net.getId();
                const networkData = FishSupplyChain.networks[networkId];
                if (networkData) {
                    const contractInstance = new web3.eth.Contract(FishSupplyChain.abi, networkData.address);
                    setContract(contractInstance);
                } else {
                    alert("Fish Supply Chain contract not deployed to detected network.");
                }
            }
        };

        initWeb3();
        if (web3) {
            loadBlockchainData();
        }
    }, [web3]);

    const addFishIndustry = async () => {
        if (contract) {
            try {
                await contract.methods.addFishIndustry(account, fishIndustryKey).send({ from: account });
                alert("Fish Industry added");
            } catch (error) {
                console.error("Error adding fish industry:", error);
            }
        }
    };

    const addDistributor = async () => {
        if (contract) {
            try {
                await contract.methods.addDistributor(account, distributorKey).send({ from: account });
                alert("Distributor added");
            } catch (error) {
                console.error("Error adding distributor:", error);
            }
        }
    };

    const addRetailer = async () => {
        if (contract) {
            try {
                await contract.methods.addRetailer(account, retailerKey).send({ from: account });
                alert("Retailer added");
            } catch (error) {
                console.error("Error adding retailer:", error);
            }
        }
    };

    const addCustomer = async () => {
        if (contract) {
            try {
                await contract.methods.addCustomer(account, customerKey).send({ from: account });
                alert("Customer added");
            } catch (error) {
                console.error("Error adding customer:", error);
            }
        }
    };

    return (
        <div className='container'>
            <h1>Fish Supply Chain Through DApp</h1>
            <p>Your account: {account}</p>
            <div>
                <h2>Add Fish Industry</h2>
                <input type="text" value={fishIndustryKey} onChange={e => setFishIndustryKey(e.target.value)} placeholder="Fish Industry Key" />
                <button onClick={addFishIndustry}>Add FishIndustry</button>
            </div>
            <div>
                <h2>Add Distributor</h2>
                <input type="text" value={distributorKey} onChange={e => setDistributorKey(e.target.value)} placeholder="Distributor Key" />
                <button onClick={addDistributor}>Add Distributor</button>
            </div>
            <div>
                <h2>Add Retailer</h2>
                <input type="text" value={retailerKey} onChange={e => setRetailerKey(e.target.value)} placeholder="Retailer Key" />
                <button onClick={addRetailer}>Add Retailer</button>
            </div>
            <div>
                <h2>Add Customer</h2>
                <input type="text" value={customerKey} onChange={e => setCustomerKey(e.target.value)} placeholder="Customer Key" />
                <button onClick={addCustomer}>Add Customer</button>
            </div>
        </div>
    );
};

export default App;
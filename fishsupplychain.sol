// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract FishSupplyChain {
    //using struct for defining my own types of data's
    struct QualityReport {
        address customer;
        int256 quantity; 
        int256 sampleSize;
        int256 defective;
        string remarks;
    }
    struct DistributorReport {
        string remarks;
        string receivedShipment;
        QualityReport qualityReport;
    }
    struct RetailerReport {
        string productName;
        string rawMaterial; 
        string remarks;
        string manufacturedDate;
        int256 quantityProduced;
        DistributorReport distributedReport;
    }

    // Mapping address for all respective stakeholders to true
    mapping(address => bool) isFishIndustry;
    mapping(address => bool) isDistributor; 
    mapping(address => bool) isRetailer;
    mapping(address => bool) isCustomer;

    // Mapping to all stakeholders address to key
    mapping(address => string) fishIndustryMapping;
    mapping(address => string) distributorMapping;
    mapping(address => string) retailerMapping;
    mapping(address => string) customerMapping;

    // Events for all stakeholders
    event FishIndustryAddition(address fishIndustryAddress, string fishIndustryKey); 
    event DistributorAddition(address distributorAddress, string distributorKey);
    event RetailerAddition(address retailerAddress, string retailerKey);
    event CustomerAddition(address customerAddress, string customerKey);

    // all Modifiers 
    modifier onlyFishIndustry(address fishIndustry) {  
        require(isFishIndustry[fishIndustry], "Not a fish industry");
        _;
    }

    modifier onlyRetailer(address retailer) {
        require(isRetailer[retailer], "Not a retailer");
        _;
    }

    modifier onlyCustomer(address customer) {
        require(isCustomer[customer], "Not a customer");
        _;
    }

    // Mappings for all reporters
    mapping(address => mapping(string => QualityReport)) qualityReports;
    mapping(address => mapping(address => mapping(string => DistributorReport))) distributorReports;
    mapping(string => string) lotToBatch;
    mapping(address => mapping(string => RetailerReport)) retailerReports;

    // Functions to add FishIndustry stakeholder
    function addFishIndustry(address _fishIndustry, string memory _fishIndustryKey) public {
        isFishIndustry[_fishIndustry] = true;
        fishIndustryMapping[_fishIndustry] = _fishIndustryKey; 
        emit FishIndustryAddition(_fishIndustry, _fishIndustryKey);
    }
    
    //Function for adding to Distributor stakeholder
    function addDistributor(address _distributor, string memory _distributorKey) public {
        isDistributor[_distributor] = true;
        distributorMapping[_distributor] = _distributorKey;
        emit DistributorAddition(_distributor, _distributorKey);
    }

    //Function for adding to Retailer stakeholder
    function addRetailer(address _retailer, string memory _retailerKey) public {
        isRetailer[_retailer] = true;
        retailerMapping[_retailer] = _retailerKey;
        emit RetailerAddition(_retailer, _retailerKey);
    }

    //Function for adding to Customer as stakeholder
    function addCustomer(address _customer, string memory _customerKey) public {
        isCustomer[_customer] = true;
        customerMapping[_customer] = _customerKey;
        emit CustomerAddition(_customer, _customerKey);
    }

    // Function to get Distributor report
    function getDistributorReport(address _distributor, address _fishIndustry, string memory _lotNumber) public view returns(
        string memory _remarks,
        string memory _receivedShipment
    ) {
        _remarks = distributorReports[_distributor][_fishIndustry][_lotNumber].remarks;
        _receivedShipment = distributorReports[_distributor][_fishIndustry][_lotNumber].receivedShipment;
    }

    // Function to map batch to lot
    function batchToLot(string memory _batchNumber, string memory _lotNumber) public {
        lotToBatch[_batchNumber] = _lotNumber;
    }

    // Function to add retailer report
    function addRetailerReport(
        address _retailer,
        address _distributor,
        address _fishIndustry,
        string memory _remarks,
        string memory _rawMaterial,
        string memory _productName,
        string memory _manufacturedDate,
        int256 _quantityProduced,
        string memory _batchNumber
    ) public {
        retailerReports[_retailer][_batchNumber].productName = _productName;
        retailerReports[_retailer][_batchNumber].remarks = _remarks;
        retailerReports[_retailer][_batchNumber].rawMaterial = _rawMaterial;
        retailerReports[_retailer][_batchNumber].manufacturedDate = _manufacturedDate;
        retailerReports[_retailer][_batchNumber].quantityProduced = _quantityProduced;
        retailerReports[_retailer][_batchNumber].distributedReport = distributorReports[_distributor][_fishIndustry][lotToBatch[_batchNumber]];
    }

    // Function to add quality report
    function addQualityReport(
        address _fishIndustry,
        address _customer,
        string memory _lotNumber,
        string memory _remarks,
        int256 _sampleSize,
        int256 _defective,
        int256 _quantity
    ) public {
        qualityReports[_fishIndustry][_lotNumber].customer = _customer;
        qualityReports[_fishIndustry][_lotNumber].remarks = _remarks;
        qualityReports[_fishIndustry][_lotNumber].sampleSize = _sampleSize;
        qualityReports[_fishIndustry][_lotNumber].defective = _defective;
        qualityReports[_fishIndustry][_lotNumber].quantity = _quantity;
    }

    // Function to get quality report
    function getQualityReport(address _fishIndustry, string memory _lotNumber) public view returns(
        string memory _remarks,
        address _customer, 
        int256 _sampleSize,
        int256 _defective,
        int256 _quantity
    ) {
        _remarks = qualityReports[_fishIndustry][_lotNumber].remarks;
        _customer = qualityReports[_fishIndustry][_lotNumber].customer;
        _sampleSize = qualityReports[_fishIndustry][_lotNumber].sampleSize;
        _defective = qualityReports[_fishIndustry][_lotNumber].defective;
        _quantity = qualityReports[_fishIndustry][_lotNumber].quantity;
    }
}
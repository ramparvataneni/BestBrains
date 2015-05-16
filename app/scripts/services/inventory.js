// Ram Parvatini - service for inventory operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('InventoryService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getInventory = function( stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/inventory.cfc?method=read',
                data: {
					stUserData: stUserData,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};	
        
        this.generate = function( stRequestData, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/inventory.cfc?method=generate',
                data: {
					stRequestData: stRequestData,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.createExcel = function( inventoryRequestId, stUserData ) {
            console.log(inventoryRequestId);
			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/inventory.cfc?method=createExcel',
                data: {
					inventoryRequestId: inventoryRequestId,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.sendEmail = function( stEmail, inventoryRequestId, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/inventory.cfc?method=sendMail',
                data: {
                    stEmail: stEmail,
					stInventoryData: stInventoryData,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
	}]);
	
})();
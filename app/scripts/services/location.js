// Ram Parvatini - service for location operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('LocationService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getLocations = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/location.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.create = function( stLocation, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/location.cfc?method=create',
                data: {
					stLocation: stLocation,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.update = function( stLocation, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/location.cfc?method=update',
                data: {
					stLocation: stLocation,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.delete = function( stLocation, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/location.cfc?method=delete',
                data: {
					stLocation: stLocation,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
    }]);
	
})();
// Ram Parvatini - service for key operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('KeyService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getKeys = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/key.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.create = function( stKey ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/key.cfc?method=create',
                data: {
					stKey: stKey,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.update = function( stKey ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/key.cfc?method=update',
                data: {
					stKey: stKey,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.delete = function( stKey ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/key.cfc?method=delete',
                data: {
					stKey: stKey,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
    }]);
	
})();
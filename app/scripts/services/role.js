// Ram Parvatini - service for role operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('RoleService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getRoles = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/role.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.create = function( stRole, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/role.cfc?method=create',
                data: {
					stRole: stRole,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.update = function( stRole, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/role.cfc?method=update',
                data: {
					stRole: stRole,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.delete = function( stRole, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/role.cfc?method=delete',
                data: {
					stRole: stRole,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
    }]);
	
})();
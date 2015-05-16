// Ram Parvatini - service for user tasks
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('UserService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
        this.getUsers = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/user.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.create = function( stUser ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/user.cfc?method=create',
                data: {
					stUser: stUser
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.update = function( stUser ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/user.cfc?method=update',
                data: {
					stUser: stUser
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.delete = function( stUser ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/user.cfc?method=delete',
                data: {
					stUser: stUser
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
	}]);
	
})();
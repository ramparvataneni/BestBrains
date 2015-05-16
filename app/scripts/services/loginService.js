// Ram Parvatini - service for login tasks
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('LoginService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.validateUser = function( sUsername, sPassword ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/user.cfc?method=ValidateLogin',
                data: {
					username: sUsername,
					password: sPassword
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
	}]);
	
})();
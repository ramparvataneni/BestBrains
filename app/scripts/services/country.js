// Ram Parvatini - service for country  data
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('CountryService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getCountries = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/country.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
    }]);
	
})();
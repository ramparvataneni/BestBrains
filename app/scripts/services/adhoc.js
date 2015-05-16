// Ram Parvatini - service for adhoc report operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('AdhocService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {
        
        var servicesPath = tAPPCONFIG.suROOTSERVER;

        //var servicesPath = 'http://127.0.0.1/~ram/BestBrains/';
        
		this.getColumns = function( stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/adhoc.cfc?method=getColumns',
                data: {
					stUserData: stUserData,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
    }]);
	
})();
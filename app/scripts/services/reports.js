// Ram Parvatini - service for report operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('ReportService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getReports = function( stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/report.cfc?method=getReports',
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
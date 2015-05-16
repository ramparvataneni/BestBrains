// Ram Parvatini - service for state  data
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('StateService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getStates = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/state.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
    }]);
	
})();
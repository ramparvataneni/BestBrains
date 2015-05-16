// Ram Parvatini - service for level operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('LevelService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getLevels = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/level.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
    }]);
	
})();
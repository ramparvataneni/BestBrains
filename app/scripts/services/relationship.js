// Ram Parvatini - service for relationship data
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('RelationshipService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getRelationships = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/relationship.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
    }]);
	
})();
// Ram Parvatini - service for grade operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('GradeService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getGrades = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/grade.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
    }]);
	
})();
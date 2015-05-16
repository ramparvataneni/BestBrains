// Ram Parvatini - service for subject operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('SubjectService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getSubjects = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/subject.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
    }]);
	
})();

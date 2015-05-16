// Ram Parvatini - service for teacher operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('TeacherService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getTeachers = function( stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/teacher.cfc?method=read',
                data: {
					stUserData: stUserData,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.create = function( stTeacher, stUserData ) {
			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/teacher.cfc?method=create',
                data: {
					stTeacher: stTeacher,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.update = function( stTeacher, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/teacher.cfc?method=update',
                data: {
					stTeacher: stTeacher,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.delete = function( stTeacher, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/teacher.cfc?method=delete',
                data: {
					stTeacher: stTeacher,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
	}]);
	
})();
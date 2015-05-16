// Ram Parvatini - service for student operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('StudentService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getStudents = function( stUserData, stSearchParams ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/student.cfc?method=read',
                data: {
					stUserData: stUserData,
					stSearchParams: stSearchParams
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.getStudent = function( studentId ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/student.cfc?method=getStudentData',
                data: {
					studentId: studentId
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.excelStudentLog = function( locationId ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/student.cfc?method=excelStudentLog',
                data: {
					locationId: locationId
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.generateStudentLog = function( studentId ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/student.cfc?method=generateStudentLog',
                data: {
					studentId: studentId
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.create = function( stStudent, stUserData ) {
            console.log(stStudent);
			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/student.cfc?method=create',
                data: {
					stStudent: stStudent,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.update = function( stStudent, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/student.cfc?method=update',
                data: {
					stStudent: stStudent,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.delete = function( stStudent, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/student.cfc?method=delete',
                data: {
					stStudent: stStudent,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
	}]);
	
})();
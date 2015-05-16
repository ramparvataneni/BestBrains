// Ram Parvatini - service for class operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('ClassService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;;
        
		this.getClasses = function( stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=read',
                data: {
					stUserData: stUserData,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.getStudentsData = function( classId ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=getStudentData',
                data: {
					classId: classId
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.generateMaterialSheet = function( week, locationId ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=generateMaterialSheet',
                data: {
					week: week,
                    locationId: locationId
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.createExcel = function( stMaterialData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=createExcel',
                data: {
					stMaterialData: stMaterialData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.saveClassData = function( stClass, userId ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=saveClassData',
                data: {
					stClass: stClass,
                    userId: userId
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.create = function( stClass, stUserData ) {
            console.log('in service');
            console.log(stClass);
			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=create',
                data: {
					stClass: stClass,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.update = function( stClass, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=update',
                data: {
					stClass: stClass,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.delete = function( stClass, stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=delete',
                data: {
					stClass: stClass,
                    stUserData: stUserData
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
	}]);
	
})();
/**
 * @ngdoc function
 * @name bestBrains.controller:DashboardCtrl
 * @description
 * # DashboardCtrl
 * Controller for the Dashboard
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('DashboardCtrl', ['$scope', '$rootScope', '$location', 'LocationService', 'StudentService', '$modal', function ($scope, 
        $rootScope, $location, LocationService, StudentService, $modal) {
        
        $scope.stStudentData = [];
        $scope.stLocationData = [];
        $scope.stNewTeacher = {};
        
        $scope.gridOptionsSm = {  data: 'stStudentData', 
            columnDefs: [
            { field: 'FULLNAME', displayName: 'Name', width: '**' },
            { field: 'FORMATTEDPHONE', displayName: 'Phone', width: '*' },
            { field: 'LOCATION', displayName: 'Location', width: '*' },
            { field: 'ENROLLMENTDATE', displayName: 'Date', width: '*' },
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            filterOptions: $rootScope.stSearchParams
         };
 
        StudentService.getStudents($rootScope.stUserData, $rootScope.stSearchParams).then(function (response) {

            $scope.stStudentData = response.data;

        });
        
        LocationService.getLocations($rootScope.stUserData).then(function (response) {

            $scope.stLocationData = response.data;

        });
    }]);
})();
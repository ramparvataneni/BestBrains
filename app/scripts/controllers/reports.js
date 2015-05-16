/**
 * @ngdoc function
 * @name bestBrains.controller:ReportCtrl
 * @description
 * # ReportCtrl
 * Controller of the bestBrains
 */

(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('ReportCtrl', ['$scope', 'LocationService', function ($scope,  LocationService, $modal) {        
        $scope.stLocationData = [];
        
        LocationService.getLocations().then(function (response) {
                $scope.stLocationData = response.data;
        });
    }]);
})();
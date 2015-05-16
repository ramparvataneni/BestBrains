/**
 * @ngdoc function
 * @name bestBrains.controller:ContactCtrl
 * @description
 * # ContactCtrl
 * Controller of the bestBrains
 */

(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('ContactCtrl', ['$scope', 'LocationService', function ($scope,  LocationService, $modal) {        
        $scope.stLocationData = [];
        
        LocationService.getLocations().then(function (response) {
                $scope.stLocationData = response.data;
        });
    }]);
})();
/**
 * @ngdoc function
 * @name bestBrains.controller:AdhocCtrl
 * @description
 * # AdhocCtrl
 * Controller of the bestBrains
 */

(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('AdhocCtrl', ['$scope', 'LocationService', 'SubjectService', 'LevelService', 'PacketService', 
        function ($scope,  LocationService, SubjectService, LevelService, PacketService, $modal) {        
        $scope.stLocationData = [];
        $scope.stPacketData = [];
        $scope.stSubjectData = [];
        $scope.stLevelData = [];
        
        LocationService.getLocations().then(function (response) {
                $scope.stLocationData = response.data;
        });
            
        SubjectService.getSubjects().then(function (response) {
            $scope.stSubjectData = response.data;
        });
            
        PacketService.getLevels().then(function (response) {
            $scope.stLevelData = response.data;
        });

        PacketService.getPackets().then(function (response) {
            $scope.stPacketData = response.data;
        });
            
    }]);
})();
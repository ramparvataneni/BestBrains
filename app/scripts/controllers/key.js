/**
 * @ngdoc function
 * @name bestBrains.controller:KeyCtrl
 * @description
 * # KeyCtrl
 * Controller of the key (answers)
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('KeyCtrl', ['$scope', '$location', '$rootScope', 'KeyService', 'SubjectService', 'LevelService', 'PacketService', '$modal', 
        function ($scope, $location, $rootScope, KeyService, SubjectService, LevelService, PacketService, $modal) {
        
        $scope.stKeyData = [];
        $scope.stPacketData = [];
        $scope.stSubjectData = [];
        $scope.stLevelData = [];
        
        $scope.subjectFilter = {
            filterText: ''
        };
        
        KeyService.getKeys().then(function (response) {
                $scope.stKeyData = response.data;
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
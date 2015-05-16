/**
 * @ngdoc function
 * @name bestBrains.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the bestBrains
 */
(function () {
    'use strict';
    
    angular.module('bestBrains').controller('MainCtrl', ['$scope', '$location', function ($scope, $location) {
        $scope.location = $location;
        
        $scope.takeToStudent = function(){
            $location.path('/student');   
        }
    }]);
    
    
})();

/**
 * @ngdoc function
 * @name bestBrains.controller:AboutCtrl
 * @description
 * # AboutCtrl
 * Controller of the bestBrains
 */
(function () {
	'use strict';
    angular.module('bestBrains').controller('AboutCtrl', function ($scope) {
        $scope.awesomeThings = [
            'HTML5 Boilerplate',
            'AngularJS',
            'Karma'
        ];
    });
})();

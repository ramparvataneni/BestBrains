/**
 * @ngdoc function
 * @name bestBrains.controller:LoginCtrl
 * @description
 * # LoginCtrl
 * Controller of the bestBrains
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('LoginCtrl', ['$scope', '$location', '$rootScope', 'LoginService', function ($scope, $location, $rootScope, LoginService) {

		$scope.valid = false;
		$scope.displayInvalid = false;
		$scope.username = "";
		$scope.password = "";
        $scope.loginMessage = "";
        
        $scope.validateLogin = function (form) {

            LoginService.validateUser($scope.username, $scope.password).then(function (response) {
                //console.log(response.data.user);
                if (response.data.AUTHENTICATION === 'pass') {
                    $rootScope.stUserData = response.data;
                    $rootScope.loggedIn = true;
                    $location.path('/dashboard');
                }
                else {
                    $scope.loginMessage = response.data.AUTHENTICATION;
                    $scope.displayInvalid = true;
                }		    						
			});
            //$rootScope.loggedIn = true;
            //$location.path('/main');
        };
    }]);
})();
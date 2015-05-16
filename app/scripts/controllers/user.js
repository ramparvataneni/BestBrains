/**
 * @ngdoc function
 * @name bestBrains.controller:UserCtrl
 * @description
 * # UserCtrl
 * Controller of the Users
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('UserCtrl', ['$scope', '$location', '$rootScope', 'UserService', '$modal', function ($scope, $location, 
        $rootScope, UserService, $modal) {
        
        $scope.stUserData = [];
        
        UserService.getUsers().then(function (response) {
                $scope.stUserData = response.data;
        });
        
        var cellTmpl = '<div style="text-align:center;" class="ngCellText" data-ng-class="col.colIndex()"><span ng-cell-text="" class="ng-binding">' +
            '<button type="button" class="btn btn-default btn-xs" data-ng-click="update(row.entity);">' +
            '<span class="glyphicon glyphicon-pencil"></span></button>' +
            '<button type="button" class="btn btn-default btn-xs" data-ng-click="delete(row.entity);">' +
            '<span class="glyphicon glyphicon-remove"></span></button>' +
            '</span></div>';

        var col0HeaderCellTemplate = '<div style="text-align:center;" class="ngCellText {{col.headerClass}}">' +
            '<span ng-cell-text="" class="ng-binding"><div>' +
            '<button type="button" class="btn btn-default btn-xs" data-ng-click="create();">' +
            '<span class="glyphicon glyphicon-plus"></span></button>' +
            '</div></span></div>';
        
        $scope.gridOptions = {  data: 'stUserData', 
            columnDefs: [
            { field: 'FULLNAME', displayName: 'Name', width: '**' },
            { field: 'LOCATION', displayName: 'Location', width: '**' },
            { field: 'ROLENAME', displayName: 'Role', width: '**' },
            { field: 'EMAIL', displayName: 'Email', width: '***' },
            { field: 'FORMATTEDPHONE', displayName: 'Phone', width: '**' },  
            {field:'', displayName: '', width: '75px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
            resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            filterOptions: $scope.dayFilter
         };
        
        $scope.stNewUser = { "LOCATIONID": $rootScope.stUserData.LOCATIONID, "ROLEID": "", 
                               "FIRSTNAME": "", "LASTNAME": "", "USERNAME": "", "PASSWORD": "", "EMAIL": "", "PHONE": "", "CELLPHONE": ""};
        
        $scope.create = function() {

            var modalInstance = $modal.open({
                templateUrl: 'updateUser.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, LocationService, RoleService, stNewUser) {
                    $scope.stLocationData = [];
                    $scope.stNewUser = stNewUser;
                    
                    LocationService.getLocations().then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    RoleService.getRoles().then(function (response) {
                        $scope.stRoleData = response.data;
                    });
                    
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewUser);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewUser: function () {
                        return $scope.stNewUser;
                    }
                }
            });
            
            modalInstance.result.then(function (stUser) {
                UserService.create(stUser).then(function (response) {
                    $scope.stUserData = response.data;
                    $scope.gridOptions.data = 'stUserData';
                });
            });
        }
        
        $scope.update = function(row) {

            var modalInstance = $modal.open({
                templateUrl: 'updateUser.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, LocationService, RoleService, stNewUser) {
                    $scope.stLocationData = [];
    
                    $scope.stNewUser = stNewUser;
    
                    LocationService.getLocations().then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    RoleService.getRoles().then(function (response) {
                        $scope.stRoleData = response.data;
                    });
            
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewUser);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewUser: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stUser) {
                UserService.update(stUser).then(function (response) {
                    $scope.stUserData = response.data;
                    $scope.gridOptions.data = 'stUserData';
                });
            });
        }
        
        $scope.delete = function(row) {
            var modalInstance = $modal.open({
                templateUrl: 'deleteUser.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $modalInstance, stNewUser) {
 
                    $scope.stNewUser = stNewUser;                    
                   
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewUser);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewUser: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stUser) {
                UserService.delete(stUser).then(function (response) {
                    $scope.stUserData = response.data;
                    $scope.gridOptions.data = 'stUserData';
                });
            });
        }
        
        
  }]);
    
})();
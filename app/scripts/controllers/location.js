/**
 * @ngdoc function
 * @name bestBrains.controller:LocationCtrl
 * @description
 * # LocationCtrl
 * Controller of the locations
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('LocationCtrl', ['$scope', '$location', '$rootScope', 'LocationService', '$modal', function ($scope, $location, 
        $rootScope,  LocationService, $modal) {
        
        $scope.stLocationData = [];
        
        $scope.locationFilter = {
            filterText: ''
        };
        //$scope.showModal = false;
        
        LocationService.getLocations($rootScope.stUserData).then(function (response) {
                $scope.stLocationData = response.data;
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
        
        $scope.gridOptionsSm = {  data: 'stLocationData', 
            columnDefs: [
            { field: 'LOCATION', displayName: 'Locatioin', width: '**' },
            { field: 'FULLADDRESS', displayName: 'Address', width: '***' },
            { field: 'EMAIL1', displayName: 'Email', width: '***' },
            { field: 'FORMATTEDPHONE', displayName: 'Phone', width: '**' },
            {field:'', displayName: '', width: '100px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
            resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            filterOptions: $scope.dayFilter
         };
        
        $scope.gridOptionsXs = {  data: 'stLocationData', 
            columnDefs: [
            { field: 'LOCATION', displayName: 'Locatioin', width: '**' },
            { field: 'EMAIL1', displayName: 'Email', width: '***' },
            { field: 'FORMATTEDPHONE', displayName: 'Phone', width: '**' },
            {field:'', displayName: '', width: '100px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
            resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            filterOptions: $scope.dayFilter
         };
              
        $scope.stNewLocation = { "LOCATIONID": 0, "STATEID": $rootScope.stUserData.STATEID, 
                               "ADDRESS1": "", "ADDRESS2": "", "CITY": "", "ZIPCODE": "", "EMAIL1": "", "PHONE1": "", "WEBSITE": ""};
        
        $scope.create = function() {
            var modalInstance = $modal.open({
                templateUrl: 'updateLocation.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, StateService, CountryService, stNewLocation) {

                    $scope.stNewLocation = stNewLocation;
                    
                    StateService.getStates().then(function (response) {
                        $scope.stStateData = response.data;
                    });
                    
                    CountryService.getCountries().then(function (response) {
                        $scope.stCountryData = response.data;
                    });
                    
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewLocation);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewLocation: function () {
                        return $scope.stNewLocation;
                    }
                }
            });
            
            modalInstance.result.then(function (stLocation) {
                LocationService.create(stLocation, stUserData).then(function (response) {
                    $scope.stLocationData = response.data;
                    $scope.gridOptionsSm.data = 'stLocationData';
                    $scope.gridOptionsXs.data = 'stLocationData';
                });
            });
        }
        
        $scope.update = function(row) {

            var modalInstance = $modal.open({
                templateUrl: 'updateLocation.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, StateService, CountryService, stNewLocation) {
                    
                    $scope.stNewLocation = stNewLocation;
                    
                    StateService.getStates().then(function (response) {
                        $scope.stStateData = response.data;
                    });
                    
                    CountryService.getCountries().then(function (response) {
                        $scope.stCountryData = response.data;
                    });
            
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewLocation);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewLocation: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stLocation) {
                LocationService.update(stLocation, stUserData).then(function (response) {
                    $scope.stLocationData = response.data;
                    $scope.gridOptionsSm.data = 'stLocationData';
                    $scope.gridOptionsXs.data = 'stLocationData';
                });
            });
        }
        
        $scope.delete = function(row) {
            var modalInstance = $modal.open({
                templateUrl: 'deleteLocation.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $modalInstance, stNewLocation) {
 
                    $scope.stNewLocation = stNewLocation;                    
                   
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewLocation);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewLocation: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stLocation) {
                LocationService.delete(stLocation, stUserData).then(function (response) {
                    $scope.stLocationData = response.data;
                    $scope.gridOptionsSm.data = 'stLocationData';
                    $scope.gridOptionsXs.data = 'stLocationData';
                });
            });
        }
        
        
  }]);
    
})();
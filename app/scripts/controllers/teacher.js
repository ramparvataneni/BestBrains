/**
 * @ngdoc function
 * @name bestBrains.controller:TeacherCtrl
 * @description
 * # TeacherCtrl
 * Controller of the Teachers
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('TeacherCtrl', ['$scope', '$rootScope', '$location', 'TeacherService', 'LocationService', '$modal', function ($scope, $rootScope, $location, TeacherService, LocationService, $modal) {
        
        $scope.stTeacherData = [];
        $scope.stLocationData = [];
        $scope.stNewTeacher = {};
        
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
        
        $scope.gridOptionsSm = {  data: 'stTeacherData', 
                                columnDefs: [
                                { field: 'FULLNAME', displayName: 'Name', width: '****' },
                                { field: 'EMAIL', displayName: 'Email', width: '****' },
                                { field: 'FORMATTEDPHONE', displayName: 'Phone', width: '**' },
                                { field: 'LOCATION', displayName: 'Location', width: '**' },
                                {field:'', displayName: '', width: '64px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
                                resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
                                ],
                                excludeProperties: ['id', '$$hashKey'],
                                selectedItems: $scope.selectedRow
                             };
        
        $scope.gridOptionsXs = {  data: 'stTeacherData', 
                                columnDefs: [
                                { field: 'FULLNAME', displayName: 'Name', width: '***' },
                                { field: 'FORMATTEDPHONE', displayName: 'Phone', width: '**' },
                                {field:'', displayName: '', width: '64px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
                                resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
                                ],
                                excludeProperties: ['id', '$$hashKey'],
                                selectedItems: $scope.selectedRow
                             };

        TeacherService.getTeachers($rootScope.stUserData).then(function (response) {

            $scope.stTeacherData = response.data;

        });
        
        $scope.stNewTeacher = { "LOCATIONID": $rootScope.stUserData.LOCATIONID, "STATEID": $rootScope.stUserData.STATEID, 
                               "ADDRESS1": "", "ADDRESS2": "", "CITY": "", "ZIPCODE": "" };
        
        $scope.create = function() {
            var modalInstance = $modal.open({
                templateUrl: 'updateTeacher.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, TeacherService, LocationService, StateService, stNewTeacher) {

                    $scope.stNewTeacher = stNewTeacher;
                    
                    LocationService.getLocations().then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    StateService.getStates().then(function (response) {
                        $scope.stStateData = response.data;
                    });
                    
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewTeacher);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewTeacher: function () {
                        return $scope.stNewTeacher;
                    }
                }
            });
            
            modalInstance.result.then(function (stTeacher) {
                TeacherService.create(stTeacher, $rootScope.stUserData).then(function (response) {
                    $scope.stTeacherData = response.data;
                    $scope.gridOptionsSm.data = 'stTeacherData';
                    $scope.gridOptionsXs.data = 'stTeacherData';
                }); 
            });
        }
        
        $scope.update = function(row) {

            var modalInstance = $modal.open({
                templateUrl: 'updateTeacher.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, TeacherService, LocationService, StateService, stNewTeacher) {
                    
                    $scope.stNewTeacher = stNewTeacher;
                    
                    LocationService.getLocations().then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    StateService.getStates().then(function (response) {
                        $scope.stStateData = response.data;
                    });
                           
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewTeacher);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewTeacher: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stTeacher) {
                TeacherService.update(stTeacher, $rootScope.stUserData).then(function (response) {
                    $scope.stTeacherData = response.data;
                    $scope.gridOptionsSm.data = 'stTeacherData';
                    $scope.gridOptionsXs.data = 'stTeacherData';
                }); 
            });
        }
        
        $scope.delete = function(row) {
            var modalInstance = $modal.open({
                templateUrl: 'deleteTeacher.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $modalInstance, stNewTeacher ) {
 
                    $scope.stNewTeacher = stNewTeacher;                    
                   
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewTeacher);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewTeacher: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stClass) {
                TeacherService.delete(stTeacher, $rootScope.stUserData).then(function (response) {
                    $scope.stTeacherData = response.data;
                    $scope.gridOptionsSm.data = 'stTeacherData';
                    $scope.gridOptionsXs.data = 'stTeacherData';
                }); 
            });
        }
            
    }]);
})();
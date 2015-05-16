/**
 * @ngdoc function
 * @name bestBrains.controller:RoleCtrl
 * @description
 * # RoleCtrl
 * Controller of the Roles
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('RoleCtrl', ['$scope', '$location', '$rootScope', 'RoleService', '$modal', function ($scope, $location, 
        $rootScope, RoleService, $modal) {
        
        $scope.stRoleData = [];
        
        RoleService.getRoles().then(function (response) {
                $scope.stRoleData = response.data;
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
        
        $scope.gridOptions = {  data: 'stRoleData', 
            columnDefs: [
            { field: 'ROLENAME', displayName: 'Role', width: '**' },
            { field: 'DESCRIPTION', displayName: 'Description', width: '***' },
            {field:'', displayName: '', width: '100px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
            resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            filterOptions: $scope.dayFilter
         };
        
        $scope.stNewClass = { "TEACHERID": 1, "FULLNAME": "Sonali Sonali", "DAY": "Monday", "STARTTIME": "04:30", "STARTAMPM": "PM", "ENDTIME": "05:30", 
                            "ENDAMPM": "PM", LOCATIONID: $rootScope.stUserData.LOCATIONID, ROOMNUMBER: "", SUBJECTID1: 1, SUBJECTID2: 0 };
        
        $scope.create = function() {
            var modalInstance = $modal.open({
                templateUrl: 'updateClass.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, TeacherService, LocationService, SubjectService, stNewClass) {
                    $scope.stTeacherData = [];
                    $scope.stNewClass = stNewClass;
                    //console.log($scope.stNewClass);

                    $scope.weekdays = [{ name: 'Monday' }, { name: 'Tuesday' }, { name: 'Wednesday' }, 
                                    { name: 'Thursday' }, { name: 'Friday' }, { name: 'Saturday' }, { name: 'Sunday' }];
                    $scope.timings = [{ name: '00:30' }, { name: '01:00' }, { name: '01:30' }, { name: '02:00' }, 
                                      { name: '02:30' }, { name: '03:00' }, { name: '03:30' }, { name: '04:00' }, 
                                      { name: '04:30' }, { name: '05:00' }, { name: '05:30' }, { name: '06:00' },
                                      { name: '06:30' }, { name: '07:00' }, { name: '07:30' }, { name: '08:00' }, 
                                      { name: '08:30' }, { name: '09:00' }, { name: '09:30' }, { name: '10:00' }, 
                                      { name: '10:30' }, { name: '11:00' }, { name: '11:30' }, { name: '12:00' }];
                    $scope.amPm = [{ name: 'AM' }, {  name: 'PM' }];
                    
                    TeacherService.getTeachers($rootScope.stUserData).then(function (response) {
                        $scope.stTeacherData = response.data;
                    });
                    
                    LocationService.getLocations($rootScope.stUserData).then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    SubjectService.getSubjects().then(function (response) {
                        $scope.stSubjectData = response.data;
                    });
                    
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewClass);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewClass: function () {
                        return $scope.stNewClass;
                    }
                }
            });
            
            modalInstance.result.then(function (stRole) {
                RoleService.create(stRole, stUserData).then(function (response) {
                    $scope.stRoleData = response.data;
                    $scope.gridOptions.data = 'stClassData';
                });
            });
        }
        
        $scope.update = function(row) {

            var modalInstance = $modal.open({
                templateUrl: 'updateClass.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, TeacherService, LocationService, SubjectService, stNewClass) {
                    $scope.stTeacherData = [];

                    
                    $scope.stNewClass = stNewClass;
                    console.log($scope.stNewClass);


                    $scope.weekdays = [{ name: 'Monday' }, { name: 'Tuesday' }, { name: 'Wednesday' }, 
                                    { name: 'Thursday' }, { name: 'Friday' }, { name: 'Saturday' }, { name: 'Sunday' }];
                    $scope.timings = [{ name: '00:30' }, { name: '01:00' }, { name: '01:30' }, { name: '02:00' }, 
                                      { name: '02:30' }, { name: '03:00' }, { name: '03:30' }, { name: '04:00' }, 
                                      { name: '04:30' }, { name: '05:00' }, { name: '05:30' }, { name: '06:00' },
                                      { name: '06:30' }, { name: '07:00' }, { name: '07:30' }, { name: '08:00' }, 
                                      { name: '08:30' }, { name: '09:00' }, { name: '09:30' }, { name: '10:00' }, 
                                      { name: '10:30' }, { name: '11:00' }, { name: '11:30' }, { name: '12:00' }];
                    $scope.amPm = [{ name: 'AM' }, {  name: 'PM' }];
                    
                    TeacherService.getTeachers($rootScope.stUserData).then(function (response) {
                        $scope.stTeacherData = response.data;
                    });
                    
                    LocationService.getLocations($rootScope.stUserData).then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    SubjectService.getSubjects().then(function (response) {
                        $scope.stSubjectData = response.data;
                    });
            
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewClass);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewClass: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stRole) {
                RoleService.update(stRole, stUserData).then(function (response) {
                    $scope.stRoleData = response.data;
                    $scope.gridOptions.data = 'stClassData';
                });
            });
        }
        
        $scope.delete = function(row) {
            var modalInstance = $modal.open({
                templateUrl: 'deleteClass.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $modalInstance, stNewClass) {
 
                    $scope.stNewClass = stNewClass;                    
                   
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewClass);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewClass: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stRole) {
                RoleService.delete(stRole, stUserData).then(function (response) {
                    $scope.stRoleData = response.data;
                    $scope.gridOptions.data = 'stClassData';
                });
            });
        }
        
  }]);
    
})();
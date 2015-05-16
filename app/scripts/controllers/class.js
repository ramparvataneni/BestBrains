/**
 * @ngdoc function
 * @name bestBrains.controller:ClassCtrl
 * @description
 * # ClassCtrl
 * Controller of the Classes
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('ClassCtrl', ['$scope', '$location', '$rootScope', 'ClassService', 'TeacherService', 'LocationService', 'SubjectService', 'tAPPCONFIG', '$modal', '$window', function ($scope, $location, $rootScope, ClassService, TeacherService, LocationService, SubjectService, tAPPCONFIG, $modal, $window){
        
        $scope.stClassData = [];
        $scope.stTeacherData = [];
        $scope.stSubjectData = [];
        
        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
        $scope.dayFilter = {
            filterText: ''
        };
        
        ClassService.getClasses($rootScope.stUserData).then(function (response) {
                $scope.stClassData = response.data;
        });
        
        var cellTmpl = '<div style="text-align:center;" class="ngCellText" data-ng-class="col.colIndex()">' +
            '<span ng-cell-text="" class="ng-binding">' +
            '<button type="button" class="btn btn-default btn-xs" data-ng-click="classSheet(row.entity);">' +
            '<span class="glyphicon glyphicon-list"></span></button>' +
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
        
        $scope.gridOptionsSm = {  data: 'stClassData', 
            columnDefs: [
            { field: 'DAY', displayName: 'Day', width: '**' },
            { field: 'CLASSTIME', displayName: 'Time', width: '***' },
            { field: 'TEACHER', displayName: 'Teacher', width: '**' },
            { field: 'ALLSUBJECTS', displayName: 'Subject(s)', width: '***' },    
            {field:'', displayName: '', width: '100px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
            resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            filterOptions: $scope.dayFilter
         };
        
        $scope.gridOptionsXs = {  data: 'stClassData', 
            columnDefs: [
            { field: 'DAY', displayName: 'Day', width: '**' },
            { field: 'CLASSTIME', displayName: 'Time', width: '***' },
            { field: 'TEACHER', displayName: 'Teacher', width: '**' },
            { field: 'CLASSSUBJECT', displayName: 'Subject(s)', width: '***' },  
            { field:'', displayName: '', width: '100px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
                resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            filterOptions: $scope.dayFilter
         };
        
        $scope.generateMaterialSheet = function() {

            var modalInstance = $modal.open({
                templateUrl: 'materialSheet.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, TeacherService, SubjectService, LevelService, 
                                       PacketService, week) {
                    
                    $scope.stMaterialData = [];
                    
                    $scope.week = week;
                    
                    ClassService.generateMaterialSheet(week, $rootScope.stUserData.LOCATIONID).then(function (response) {
                        $scope.stMaterialData = response.data;
                        console.log($scope.stMaterialData);
                    });

                    TeacherService.getTeachers($rootScope.stUserData).then(function (response) {
                        $scope.stTeacherData = response.data;
                    });
                    
                    LocationService.getLocations($rootScope.stUserData).then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    SubjectService.getSubjects().then(function (response) {
                        $scope.stSubjectData = response.data;
                    });
                    
                    LevelService.getLevels().then(function (response) {
                        $scope.stLevelData = response.data;
                    });
                    
                    PacketService.getPackets().then(function (response) {
                        $scope.stPacketData = response.data;
                    });
                    
                    $scope.gridOptionsMat = {  data: 'stMaterialData', 
                        columnDefs: [
                        { field: 'fullName', displayName: 'Name', width: '***' },
                        { field: 'Math', displayName: 'Math', width: '**' },
                        { field: 'English', displayName: 'English', width: '**' },
                        { field: 'Abacus', displayName: 'Abacus', width: '**' },
                        { field: 'GK', displayName: 'GK', width: '**' },
                        { field: 'teacher', displayName: 'Teacher', width: '**' }//,
                        //{ field: 'classTime', displayName: 'Time', width: '**' }
                        ],
                        excludeProperties: ['id', '$$hashKey'],
                        selectedItems: $scope.selectedRow,
                        filterOptions: $scope.dayFilter
                     };
            
                    $scope.submit = function () {
                        $modalInstance.close($scope.stMaterialData);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    week: function () {
                        return $scope.dayFilter.filterText;
                    }
                }
            });
            
            modalInstance.result.then(function (stMaterialData) {
                
                ClassService.createExcel(stMaterialData).then(function (response) {
                    var excelFile = servicesPath + 'server/services/excels/' + response.data;
                    //console.log(excelFile);
                    $window.open(excelFile, '_system');
                });
 
            });
        } 
   
        $scope.classSheet = function(row) {

            var modalInstance = $modal.open({
                templateUrl: 'classSheet.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, TeacherService, LocationService, SubjectService, LevelService, 
                                       PacketService, stNewClass) {
                    $scope.stTeacherData = [];
                
                    $scope.stNewClass = stNewClass;
                    
                    ClassService.getStudentsData($scope.stNewClass.CLASSID).then(function (response) {
                        $scope.stNewClass.stStudent = response.data;
                        console.log($scope.stNewClass.stStudent);
                    });

                    TeacherService.getTeachers($rootScope.stUserData).then(function (response) {
                        $scope.stTeacherData = response.data;
                    });
                    
                    LocationService.getLocations($rootScope.stUserData).then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    SubjectService.getSubjects().then(function (response) {
                        $scope.stSubjectData = response.data;
                    });
                    
                    LevelService.getLevels().then(function (response) {
                        $scope.stLevelData = response.data;
                    });
                    
                    PacketService.getPackets().then(function (response) {
                        $scope.stPacketData = response.data;
                    });
            
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
            
            modalInstance.result.then(function (stClass) {
                ClassService.saveClassData(stClass, $rootScope.stUserData.USERID);
                ClassService.getClasses($rootScope.stUserData).then(function (response) {
                    $scope.stClassData = response.data;
                });
            });
        } 
               
        $scope.stNewClass = { "TEACHERID": 1, "FULLNAME": "Sonali Sonali", "DAY": "Monday", "STARTTIME": "04:30", "STARTAMPM": "PM", "ENDTIME": "05:30", 
                            "ENDAMPM": "PM", LOCATIONID: $rootScope.stUserData.LOCATIONID, ROOMNUMBER: "", 
                            "Subjects":[{"CLASSSUBJECT":"","CLASSSUBJECTID":0}, {"CLASSSUBJECT":"","CLASSSUBJECTID":0}] };
        
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
            
            modalInstance.result.then(function (stClass) {
                ClassService.create(stClass, $rootScope.stUserData).then(function (response) {
                    $scope.stClassData = response.data;
                    $scope.gridOptionsSm.data = 'stClassData';
                    $scope.gridOptionsXs.data = 'stClassData';
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
            
            modalInstance.result.then(function (stClass) {
                ClassService.update(stClass, $rootScope.stUserData).then(function (response) {
                    $scope.stClassData = response.data;
                    $scope.gridOptionsSm.data = 'stClassData';
                    $scope.gridOptionsXs.data = 'stClassData';
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
            
            modalInstance.result.then(function (stClass) {
                ClassService.delete(stClass, $rootScope.stUserData).then(function (response) {
                    $scope.stClassData = response.data;
                    $scope.gridOptionsSm.data = 'stClassData';
                    $scope.gridOptionsXs.data = 'stClassData';
                });
            });
        }

    }]);
    
    /*app.controller('AddClassCtrl', ['$scope', '$modalInstance', function ($scope, $modalInstance) {

        $scope.ok = function () {
            alert($scope.text);
        };

        $scope.cancel = function () {
            $modalInstance.dismiss('cancel');
        };
    }]);
                
    app.controller('EditClassCtrl', ['$scope', '$modalInstance', 'classObj', function ($scope, $modalInstance, classObj) {
        $scope.classObj = classObj;
        $scope.ok = function () {
            alert($scope.text);
        };

        $scope.cancel = function () {
            $modalInstance.dismiss('cancel');
        };
    }]);
                
    app.controller('DeleteClassCtrl', ['$scope', '$modalInstance', 'classObj', function ($scope, $modalInstance, classObj) {
        $scope.classObj = classObj;
        $scope.ok = function () {
            alert($scope.text);
        };

        $scope.cancel = function () {
            $modalInstance.dismiss('cancel');
        };
    }]);
    
    app.directive('modal', function () {
        
        return {
          template: '<div class="modal fade">' + 
              '<div class="modal-dialog">' + 
                '<div class="modal-content">' + 
                  '<div class="modal-header">' + 
                    '<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' + 
                    '<h4 class="modal-title">{{ title }}</h4>' + 
                  '</div>' + 
                  '<div class="modal-body" ng-transclude></div>' + 
                '</div>' + 
              '</div>' + 
            '</div>',
          restrict: 'E',
          transclude: true,
          replace:true,
          scope:true,
          link: function postLink(scope, element, attrs) {
            scope.title = attrs.title;

            scope.$watch(attrs.visible, function(value){
              if(value == true)
                $(element).modal('show');
              else
                $(element).modal('hide');
            });

            $(element).on('shown.bs.modal', function(){
              scope.$apply(function(){
                scope.$parent[attrs.visible] = true;
              });
            });

            $(element).on('hidden.bs.modal', function(){
              scope.$apply(function(){
                scope.$parent[attrs.visible] = false;
              });
            });
          }
        };
      });*/
                
    
})();
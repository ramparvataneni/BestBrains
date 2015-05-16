/**
 * @ngdoc function
 * @name bestBrains.controller:StudentCtrl
 * @description
 * # StudentCtrl
 * Controller of the Students
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('StudentCtrl', ['$scope', '$location', '$rootScope', 'StudentService', 'GradeService', 'LevelService', 'PacketService', 'ClassService',
    'PaymentService', '$modal', function ($scope, $location, $rootScope, StudentService, GradeService, LevelService, PacketService, ClassService,
    PaymentService, $modal) {
        
        $rootScope.stSearchParams = {
            filterText: ''  
        };
        $scope.stStudentData = {};
        
        $scope.stNewStudent = {};
        $scope.stNewStudent.PARENT1 = {};
        
        $scope.stClassData = [];
        $scope.stLevelData = [];
        $scope.stPacketData = [];
        $scope.stGradeData = [];
        $scope.stPaymentData = [];
        
        var cellTmpl = '<div style="text-align:center;" class="ngCellText" data-ng-class="col.colIndex()">' +
            '<span ng-cell-text="" class="ng-binding">' +
            '<button type="button" class="btn btn-default btn-xs" data-ng-click="update(row.entity);">' +
            '<span class="glyphicon glyphicon-pencil"></span></button>' +
            '<button type="button" class="btn btn-default btn-xs" data-ng-click="delete(row.entity);">' +
            '<span class="glyphicon glyphicon-remove"></span></button>' +
            '</span></div>';

        var col0HeaderCellTemplate = '<div style="text-align:center;" class="ngCellText {{col.headerClass}}">' +
            '<span ng-cell-text="" class="ng-binding"><div>' +
            '<button type="button"  class="btn btn-default btn-xs" data-ng-click="create();">' +
            '<span class="glyphicon glyphicon-plus"></span></button>' +
            '</div></span></div>';
        
        $scope.gridOptionsSm = {  data: 'stStudentData', 
            columnDefs: [
            { field: 'FULLNAME', displayName: 'Name', width: '**' },
            { field: 'EMAIL', displayName: 'Email', width: '**' },
            { field: 'FORMATTEDPHONE', displayName: 'Phone', width: '**' },
            { field: 'STATUS', displayName: 'Status', width: '*' },
            {field:'', displayName: '', width: '100px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
            resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            filterOptions: $rootScope.stSearchParams
         };
        
        $scope.gridOptionsXs = {  data: 'stStudentData', 
            columnDefs: [
            { field: 'FULLNAME', displayName: 'Name', width: '***' },
            { field: 'FORMATTEDPHONE', displayName: 'Phone', width: '**' },
            {field:'', displayName: '', width: '64px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
            resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            filterOptions: $rootScope.stSearchParams         
         };
 
        StudentService.getStudents($rootScope.stUserData, $rootScope.stSearchParams).then(function (response) {

            $scope.stStudentData = response.data;

        });
        
        $scope.stNewStudent = { "LOCATIONID": $rootScope.stUserData.LOCATIONID, "STATEID": $rootScope.stUserData.STATEID, 
                               "ACTIVE": 1, "ADDRESS1": "", "ADDRESS2": "", "CITY": "", "ZIPCODE": "", GRADEID: 1, "MIDDLENAME":"",
                              "SCHOOL": "", "MATH": false, "ENGLISH": false, "ABACUS": false, "GK": false, "MATHPACKETID": 0, "ENGLISHPACKETID": 0,
                              "ABACUSPACKETID": 0, "GKPACKETID": 0, "CLASS1ID": 0, "CLASS2ID": 0, "ENROLLMENTDATE": "", "PAYMENTMETHODID": 0,
                              "PARENT1": { "ADDRESS1": "", "ADDRESS2": "", 
                               "CITY": "", "STATEID": "", "ZIPCODE": "", "EMAIL": "", "PHONE": "", "SAMEASABOVE":""}
                              };
        
        $scope.create = function() {
            var modalInstance = $modal.open({
                templateUrl: 'updateStudent.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, StudentService, LocationService, StateService, GradeService, 
                                       LevelService, PacketService, ClassService, PaymentService, stNewStudent) {
                    
                    $scope.stNewStudent = stNewStudent;
                    $scope.stStudentClasses = [];
                    $scope.stStudentSubjects = [];
                             
                    $scope.stStudentSubjects = { "MATH": false, "ENGLISH": false, "ABACUS": false, "GK": false, 
                        "MATHLEVELID": 0, "MATHPACKETID": 0, "ENGLISHPACKETID": 0, "ENGLISHLEVELID": 0, 
                        "ABACUSLEVELID": 0, "ABACUSPACKETID": 0, "GKLEVELID": 0, "GKPACKETID": 0
                    };
                    
                    $scope.stStudentClasses = { "CLASS1ID": 0, "CLASS2ID": 0};
                    
                    $scope.open = function($event) {
                        $event.preventDefault();
                        $event.stopPropagation();

                        $scope.opened = true;
                    };
                    
                    
                    LocationService.getLocations($rootScope.stUserData).then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    LocationService.getLocations().then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    StateService.getStates().then(function (response) {
                        $scope.stStateData = response.data;
                    });
                    
                    GradeService.getGrades().then(function (response) {
                        $scope.stGradeData = response.data;
                    });
                    
                    LevelService.getLevels().then(function (response) {
                        $scope.stLevelData = response.data;
                    });
                    
                    PacketService.getPackets().then(function (response) {
                        $scope.stPacketData = response.data;
                    });
                    
                    ClassService.getClasses($rootScope.stUserData).then(function (response) {
                        $scope.stClassData = response.data;
                    });
                    
                    PaymentService.getPaymentMethods().then(function (response) {
                        $scope.stPaymentData = response.data;
                    });
                    
                    $scope.getAboveAddress = function () {
  
                        if($scope.stNewStudent.PARENT1.SAMEASABOVE === true){
                            $scope.stNewStudent.PARENT1.ADDRESS1 =  $scope.stNewStudent.ADDRESS1;
                            $scope.stNewStudent.PARENT1.ADDRESS2 =  $scope.stNewStudent.ADDRESS2;
                            $scope.stNewStudent.PARENT1.CITY =  $scope.stNewStudent.CITY;
                            $scope.stNewStudent.PARENT1.STATEID =  $scope.stNewStudent.STATEID;
                            $scope.stNewStudent.PARENT1.ZIPCODE =  $scope.stNewStudent.ZIPCODE;
                            $scope.stNewStudent.PARENT1.EMAIL =  $scope.stNewStudent.EMAIL;
                            $scope.stNewStudent.PARENT1.PHONE =  $scope.stNewStudent.PHONE;
                        }
                        else {
                            $scope.stNewStudent.PARENT1.ADDRESS1 =  "";
                            $scope.stNewStudent.PARENT1.ADDRESS2 =  "";
                            $scope.stNewStudent.PARENT1.CITY =  "";
                            $scope.stNewStudent.PARENT1.STATEID =  "";
                            $scope.stNewStudent.PARENT1.ZIPCODE =  "";
                            $scope.stNewStudent.PARENT1.EMAIL =  "";
                            $scope.stNewStudent.PARENT1.PHONE =  "";
                        }
                    }
                    
                    //$scope.user = user;
                    $scope.submit = function () {
                        if((typeof(stStudentSubjects.MATH) == 'undefined' || stStudentSubjects.MATH == 'false') && 
                            (typeof(stStudentSubjects.ENGLISH) == 'undefined' || stStudentSubjects.ENGLISH == 'false') 
                            && (typeof(stStudentSubjects.ABACUS) == 'undefined' || stStudentSubjects.ABACUS == 'false')
                            && (typeof(stStudentSubjects.GK) == 'undefined' || stStudentSubjects.GK == 'false')){
                            alert('Please choose at least one subject');
                            return false;
                        }
                        if(stStudentSubjects.MATH === true){
                            if(typeof(stStudentSubjects.MATHLEVELID)=='undefined' || typeof(stStudentSubjects.MATHPACKETID)=='undefined'){
                                alert('please select Math level, packet');
                                return false;
                            }
                        }
                        if(stStudentSubjects.ENGLISH === true){
                            if(typeof(stStudentSubjects.ENGLISHLEVELID)=='undefined' || typeof(stStudentSubjects.ENGLISHPACKETID)=='undefined'){
                                alert('please select English level, packet');
                                return false;
                            }
                        }
                        if(stStudentSubjects.ABACUS === true){
                            if(typeof(stStudentSubjects.ABACUSLEVELID)=='undefined' || typeof(stStudentSubjects.ABACUSPACKETID)=='undefined'){
                                alert('please select Abacus level, packet');
                                return false;
                            }
                        }
                        if(stStudentSubjects.GK === true){
                            if(typeof(stStudentSubjects.GKLEVELID)=='undefined' || typeof(stStudentSubjects.GKPACKETID)=='undefined'){
                                alert('please select GK level, packet');
                                return false;
                            }
                        }
                        $modalInstance.close($scope.stNewStudent, $scope.stStudentSubjects, $scope.stStudentClasses);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewStudent: function () {
                        return $scope.stNewStudent;
                    }
                }
            });
            
            modalInstance.result.then(function (stStudent, stStudentSubjects, stStudentClasses) {
                
                StudentService.create(stStudent, stStudentSubjects, stStudentClasses, $rootScope.stUserData).then(function (response) {
                    $scope.stStudentData = response.data;
                    $scope.gridOptionsSm.data = 'stStudentData';
                    $scope.gridOptionsXs.data = 'stStudentData';
                });
            });
        }
        
        $scope.update = function(row) {

            var modalInstance = $modal.open({
                templateUrl: 'updateStudent.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, StudentService, LocationService, StateService, GradeService, 
                                       LevelService, PacketService, ClassService, PaymentService, stNewStudent) {

                    $scope.stNewStudent = stNewStudent;

                    $scope.open = function($event) {
                        $event.preventDefault();
                        $event.stopPropagation();

                        $scope.opened = true;
                    };
                    
                    StudentService.getStudent(row.STUDENTID).then(function (response) {
                        $scope.stStudentSubjects = response.data.STSTUDENTSUBJECTS;
                        $scope.stStudentClasses = response.data.STSTUDENTCLASSES;
                    });
                    
                    LocationService.getLocations().then(function (response) {
                        $scope.stLocationData = response.data;
                    });
                    
                    StateService.getStates().then(function (response) {
                        $scope.stStateData = response.data;
                    });
                    
                    GradeService.getGrades().then(function (response) {
                        $scope.stGradeData = response.data;
                    });
                    
                    LevelService.getLevels().then(function (response) {
                        $scope.stLevelData = response.data;
                    });
                    
                    PacketService.getPackets().then(function (response) {
                        $scope.stPacketData = response.data;
                    });
                    
                    ClassService.getClasses($rootScope.stUserData).then(function (response) {
                        $scope.stClassData = response.data;
                    });
                    
                    PaymentService.getPaymentMethods().then(function (response) {
                        $scope.stPaymentData = response.data;
                    });

                    $scope.getAboveAddress = function () {

                        if($scope.sameAsAbove === true){
                            $scope.stNewStudent.PARENT1.ADDRESS1 =  $scope.stNewStudent.ADDRESS1;
                            $scope.stNewStudent.PARENT1.ADDRESS2 =  $scope.stNewStudent.ADDRESS2;
                            $scope.stNewStudent.PARENT1.CITY =  $scope.stNewStudent.CITY;
                            $scope.stNewStudent.PARENT1.STATEID =  $scope.stNewStudent.STATEID;
                            $scope.stNewStudent.PARENT1.ZIPCODE =  $scope.stNewStudent.ZIPCODE;
                            $scope.stNewStudent.PARENT1.EMAIL =  $scope.stNewStudent.EMAIL;
                            $scope.stNewStudent.PARENT1.PHONE =  $scope.stNewStudent.PHONE;
                        }
                        else {
                            $scope.stNewStudent.PARENT1.ADDRESS1 =  "";
                            $scope.stNewStudent.PARENT1.ADDRESS2 =  "";
                            $scope.stNewStudent.PARENT1.CITY =  "";
                            $scope.stNewStudent.PARENT1.STATEID =  "";
                            $scope.stNewStudent.PARENT1.ZIPCODE =  "";
                            $scope.stNewStudent.PARENT1.EMAIL =  "";
                            $scope.stNewStudent.PARENT1.PHONE =  "";
                        }
                    }
                   
                    //$scope.user = user;
                    $scope.submit = function () {
                        if((typeof(stStudentSubjects.MATH) == 'undefined' || stStudentSubjects.MATH == 'false') && 
                            (typeof(stStudentSubjects.ENGLISH) == 'undefined' || stStudentSubjects.ENGLISH == 'false') 
                            && (typeof(stStudentSubjects.ABACUS) == 'undefined' || stStudentSubjects.ABACUS == 'false')
                            && (typeof(stStudentSubjects.GK) == 'undefined' || stStudentSubjects.GK == 'false')){
                            alert('Please choose at least one subject');
                            return false;
                        }
                        if(stStudentSubjects.MATH === true){
                            if(typeof(stStudentSubjects.MATHLEVELID)=='undefined' || typeof(stStudentSubjects.MATHPACKETID)=='undefined'){
                                alert('please select Math level, packet');
                                return false;
                            }
                        }
                        if(stStudentSubjects.ENGLISH === true){
                            if(typeof(stStudentSubjects.ENGLISHLEVELID)=='undefined' || typeof(stStudentSubjects.ENGLISHPACKETID)=='undefined'){
                                alert('please select English level, packet');
                                return false;
                            }
                        }
                        if(stStudentSubjects.ABACUS === true){
                            if(typeof(stStudentSubjects.ABACUSLEVELID)=='undefined' || typeof(stStudentSubjects.ABACUSPACKETID)=='undefined'){
                                alert('please select Abacus level, packet');
                                return false;
                            }
                        }
                        if(stStudentSubjects.GK === true){
                            if(typeof(stStudentSubjects.GKLEVELID)=='undefined' || typeof(stStudentSubjects.GKPACKETID)=='undefined'){
                                alert('please select GK level, packet');
                                return false;
                            }
                        }
                        $modalInstance.close($scope.stNewStudent, $scope.stStudentSubjects, $scope.stStudentClasses);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewStudent: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stStudent, stStudentSubjects, stStudentClasses) {
                
                StudentService.update(stStudent, stStudentSubjects, stStudentClasses, $rootScope.stUserData).then(function (response) {
                    $scope.stStudentData = response.data;
                    $scope.gridOptionsSm.data = 'stStudentData';
                    $scope.gridOptionsXs.data = 'stStudentData';
                });
            });
        }
        
        $scope.delete = function(row) {
            var modalInstance = $modal.open({
                templateUrl: 'deleteStudent.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $modalInstance, TeacherService, stNewStudent) {
 
                    $scope.stNewStudent = stNewStudent;                    
                   
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewStudent);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewStudent: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stStudent) {
                StudentService.delete(stStudent, $rootScope.stUserData).then(function (response) {
                    $scope.stStudentData = response.data;
                    $scope.gridOptionsSm.data = 'stStudentData';
                    $scope.gridOptionsXs.data = 'stStudentData';
                });
            });
        }
                 
    }]);
})();
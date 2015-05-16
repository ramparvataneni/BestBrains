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
    'PaymentService', 'tAPPCONFIG', '$modal', '$window', function ($scope, $location, $rootScope, StudentService, GradeService, LevelService,
    PacketService, ClassService, PaymentService, tAPPCONFIG, $modal, $window) {
        
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
        
        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
        var cellTmpl = '<div style="text-align:center;" class="ngCellText" data-ng-class="col.colIndex()">' +
            '<span ng-cell-text="" class="ng-binding">' +
            '<button type="button"  class="btn btn-default btn-xs" data-ng-click="studentLog(row.entity);">' +
            '<span class="glyphicon glyphicon-list"></span></button>' +
            '<button type="button" class="btn btn-default btn-xs" data-ng-click="update(row.entity);">' +
            '<span class="glyphicon glyphicon-pencil"></span></button>' +
            '<button type="button" class="btn btn-default btn-xs" data-ng-click="delete(row.entity);">' +
            '<span class="glyphicon glyphicon-remove"></span></button>' +
            '</span></div>';

        var col0HeaderCellTemplate = '<div style="text-align:center;" class="ngCellText {{col.headerClass}}">' +
            '<span ng-cell-text="" class="ng-binding"><div>' +
            //'<button type="button"  class="btn btn-default btn-xs" data-ng-click="studentLog();">' +
           // '<span class="glyphicon glyphicon-list"></span></button>' +
            '<button type="button"  class="btn btn-default btn-xs" data-ng-click="create();">' +
            '<span class="glyphicon glyphicon-plus"></span></button>' +
            '</div></span></div>';
        
        $scope.totalServerItems = 0;
        $scope.pagingOptions = {
            pageSizes: [15, 25, 50, 100],
            pageSize: 15,
            currentPage: 1
        };
        
        $scope.setPagingData = function(data, page, pageSize){	
            var pagedData = data.slice((page - 1) * pageSize, page * pageSize);
            $scope.myData = pagedData;
            $scope.totalServerItems = data.length;
            if (!$scope.$$phase) {
                $scope.$apply();
            }
        };
        
        $scope.getPagedDataAsync = function (pageSize, page) {
            setTimeout(function () {
                var data;
                StudentService.getStudents($rootScope.stUserData, $rootScope.stSearchParams).then(function (response) {
                    $scope.stStudentData = response.data;
                    $scope.setPagingData($scope.stStudentData,page,pageSize);
                });
            }, 100);
        };
        
        $scope.getPagedDataAsync($scope.pagingOptions.pageSize, $scope.pagingOptions.currentPage);
	
        $scope.$watch('pagingOptions', function (newVal, oldVal) {
            if (newVal !== oldVal && newVal.currentPage !== oldVal.currentPage) {
              $scope.getPagedDataAsync($scope.pagingOptions.pageSize, $scope.pagingOptions.currentPage);
            }
        }, true);
        
        $scope.gridOptionsSm = {  data: 'myData', 
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
            enablePaging: true,
            showFooter: true,
            totalServerItems:'totalServerItems',
            pagingOptions: $scope.pagingOptions,
            filterOptions: $rootScope.stSearchParams
         };
        
        $scope.gridOptionsXs = {  data: 'myData', 
            columnDefs: [
            { field: 'FULLNAME', displayName: 'Name', width: '***' },
            { field: 'FORMATTEDPHONE', displayName: 'Phone', width: '**' },
            {field:'', displayName: '', width: '100px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
            resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            enablePaging: true,
            showFooter: true,
            totalServerItems:'totalServerItems',
            pagingOptions: $scope.pagingOptions,
            filterOptions: $rootScope.stSearchParams         
         };
 
        /*StudentService.getStudents($rootScope.stUserData, $rootScope.stSearchParams).then(function (response) {

            $scope.stStudentData = response.data;

        });*/
        
        $scope.stNewStudent = { "LOCATIONID": $rootScope.stUserData.LOCATIONID, "STATEID": $rootScope.stUserData.STATEID, 
            "ACTIVE": 1, "ADDRESS1": "", "ADDRESS2": "", "CITY": "", "ZIPCODE": "", GRADEID: 1, "MIDDLENAME":"",
            "SCHOOL": "", "ENROLLMENTDATE": "", "PAYMENTMETHODID": 0,
            "PARENT1": { "ADDRESS1": "", "ADDRESS2": "", "CITY": "", "STATEID": "", "ZIPCODE": "", "EMAIL": "", "PHONE": "", "SAMEASABOVE":""},
            "PARENT2": { "ADDRESS1": "", "ADDRESS2": "", "CITY": "", "STATEID": "", "ZIPCODE": "", "EMAIL": "", "PHONE": "", "SAMEASABOVE":""},
            "stStudentSubjects": [{"SUBJECTID":1,"STUDENTSUBJECTID":0,"STUDENTID":0,"PACKETID":0,"LEVELID":0,"SUBJECTNAME":"Math"},
                                 {"SUBJECTID":2,"STUDENTSUBJECTID":0,"STUDENTID":0,"PACKETID":0,"LEVELID":0,"SUBJECTNAME":"English"},
                                 {"SUBJECTID":3,"STUDENTSUBJECTID":0,"STUDENTID":0,"PACKETID":0,"LEVELID":0,"SUBJECTNAME":"Abacus"},
                                 {"SUBJECTID":4,"STUDENTSUBJECTID":0,"STUDENTID":0,"PACKETID":0,"LEVELID":0,"SUBJECTNAME":"GK"}],
            "stStudentClasses": [{ "CLASSID": 0}, {"CLASSID": 0}] 
        };
        
        $scope.studentLog = function(row) {
            var modalInstance = $modal.open({
                templateUrl: 'studentLog.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, LocationService, StudentService, stNewStudent) {
                    $scope.stNewStudent = stNewStudent;         
                    $scope.stStudentLog = [];
                    
                    StudentService.generateStudentLog($scope.stNewStudent.STUDENTID).then(function (response) {
                        $scope.stStudentLog = response.data;
                        console.log($scope.stStudentLog);

                    });
                    
                    $scope.gridOptions = {  data: 'stStudentLog[0].Dates', 
                        columnDefs: [
                        { field: 'Date', displayName: 'Date', width: '**' },
                        { field: 'subject', displayName: 'Subject', width: '*' },
                        { field: 'packet', displayName: 'Packet', width: '*' },
                        { field: 'comments', displayName: 'Comments', width: '**' }
                        ],
                        excludeProperties: ['id', '$$hashKey'],
                        selectedItems: $scope.selectedRow,
                        filterOptions: $rootScope.stSearchParams
                     };

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
                if(stStudent.stStudentSubjects.length===0){
                    alert('Please select at least one subject');
                    return false; 
                }
                
                angular.forEach(stStudent.stStudentSubjects, function(subjectObj, subjectIndex) {
                    if (subjectObj.STUDENTSUBJECTID != '' && (subjectObj.PACKETID == '' || subjectObj.PACKETID == null)) {
                        alert(subjectObj.STUDENTSUBJECTID);
                        return false;
                    }
                });
                
                StudentService.create(stStudent, $rootScope.stUserData).then(function (response) {
                    $scope.stStudentData = response.data;
                    $scope.gridOptionsSm.data = 'stStudentData';
                    $scope.gridOptionsXs.data = 'stStudentData';
                });
            });
        }

        $scope.excelStudentLog = function() { 
            StudentService.excelStudentLog($rootScope.stUserData.LOCATIONID).then(function (response) {
                var excelFile = servicesPath + 'server/services/excels/' + response.data;
                //console.log(excelFile);
                $window.open(excelFile, '_system');
                //window.open(excelFile);
                //window.open(response.data);
            });
        }
        
        $scope.create = function() {
            var modalInstance = $modal.open({
                templateUrl: 'updateStudent.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, StudentService, LocationService, StateService, GradeService, SubjectService,
                                       LevelService, PacketService, ClassService, PaymentService, stNewStudent) {
                    
                    $scope.stNewStudent = stNewStudent;
                             
                    //console.log($scope.stNewStudent.LOCATIONID);
                    
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
                    
                    SubjectService.getSubjects().then(function (response) {
                        $scope.stSubjectData = response.data;
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
                    
                    $scope.getAboveAddress = function (parent) {
                        if (parent == 'parent1'){
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
                        if (parent == 'parent2') {   
                            if($scope.stNewStudent.PARENT2.SAMEASABOVE === true){
                                $scope.stNewStudent.PARENT2.ADDRESS1 =  $scope.stNewStudent.ADDRESS1;
                                $scope.stNewStudent.PARENT2.ADDRESS2 =  $scope.stNewStudent.ADDRESS2;
                                $scope.stNewStudent.PARENT2.CITY =  $scope.stNewStudent.CITY;
                                $scope.stNewStudent.PARENT2.STATEID =  $scope.stNewStudent.STATEID;
                                $scope.stNewStudent.PARENT2.ZIPCODE =  $scope.stNewStudent.ZIPCODE;
                                $scope.stNewStudent.PARENT2.EMAIL =  $scope.stNewStudent.EMAIL;
                                $scope.stNewStudent.PARENT2.PHONE =  $scope.stNewStudent.PHONE;
                            }
                            else {
                                $scope.stNewStudent.PARENT2.ADDRESS1 =  "";
                                $scope.stNewStudent.PARENT2.ADDRESS2 =  "";
                                $scope.stNewStudent.PARENT2.CITY =  "";
                                $scope.stNewStudent.PARENT2.STATEID =  "";
                                $scope.stNewStudent.PARENT2.ZIPCODE =  "";
                                $scope.stNewStudent.PARENT2.EMAIL =  "";
                                $scope.stNewStudent.PARENT2.PHONE =  "";
                            }
                        }
                    }
                    
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
                        return $scope.stNewStudent;
                    }
                }
            });
            
            modalInstance.result.then(function (stStudent) {
                if(stStudent.stStudentSubjects.length===0){
                    alert('Please select at least one subject');
                    return false; 
                }
                
                angular.forEach(stStudent.stStudentSubjects, function(subjectObj, subjectIndex) {
                    if (subjectObj.STUDENTSUBJECTID != '' && (subjectObj.PACKETID == '' || subjectObj.PACKETID == null)) {
                        alert(subjectObj.STUDENTSUBJECTID);
                        return false;
                    }
                });
                
                StudentService.create(stStudent, $rootScope.stUserData).then(function (response) {
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
                controller: function ($scope, $rootScope, $modalInstance, StudentService, LocationService, StateService, GradeService, SubjectService,
                                       LevelService, PacketService, ClassService, PaymentService, stNewStudent) {

                    $scope.stNewStudent = stNewStudent;

                    $scope.open = function($event) {
                        $event.preventDefault();
                        $event.stopPropagation();

                        $scope.opened = true;
                    };
                    
                    StudentService.getStudent($scope.stNewStudent.STUDENTID).then(function (response) {
                        $scope.stNewStudent.stStudentSubjects = response.data.STSTUDENTSUBJECTS;
                        $scope.stNewStudent.stStudentClasses = response.data.STSTUDENTCLASSES;
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
                    
                    SubjectService.getSubjects().then(function (response) {
                        $scope.stSubjectData = response.data;
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

                    /*$scope.getAboveAddress = function () {

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
                    }*/
                   
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
                console.log(stStudent.stStudentSubjects);
                
                if(stStudent.stStudentSubjects.length===0){
                    alert('Please select at least one subject');
                    return false; 
                }
                
                angular.forEach(stStudent.stStudentSubjects, function(subjectObj, subjectIndex) {
                    if (subjectObj.STUDENTSUBJECTID != '' && (subjectObj.PACKETID == '' || subjectObj.PACKETID == null)) {
                        alert(subjectObj.STUDENTSUBJECTID);
                        return false;
                    }
                });
                
                StudentService.update(stStudent, $rootScope.stUserData).then(function (response) {
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
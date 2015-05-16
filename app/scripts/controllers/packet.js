/**
 * @ngdoc function
 * @name bestBrains.controller:PacketCtrl
 * @description
 * # PacketCtrl
 * Controller of the Packets
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('PacketCtrl', ['$scope', '$location', '$rootScope', 'PacketService', '$modal', 'SubjectService', 'LevelService', 
                                  function ($scope, $location, $rootScope, PacketService, $modal, SubjectService, LevelService) {
        
        $scope.stPacketData = [];
                                      
        $scope.subjectFilter = {
            filterText: ''
        };
        
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
        
        $scope.gridOptions = {  data: 'stPacketData', 
                                columnDefs: [
                                { field: 'SUBJECTNAME', displayName: 'SUBJECT', width: '*' },
                                { field: 'PACKET', displayName: 'Packet', width: '*' },
                                { field:'', displayName: '', width: '64px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
                                resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},
                                ],
                                excludeProperties: ['id', '$$hashKey'],
                                selectedItems: $scope.selectedRow,
                                filterOptions: $scope.subjectFilter
                             };

        PacketService.getPackets($rootScope.stUserData).then(function (response) {
            $scope.stPacketData = response.data;
        });
        
        $scope.stNewPacket = { "SUBJECTID": 1, "SUBJECTNAME": "Math", "LEVELID": 1, "LEVELNAME": "LOA", "PACKET": "A" };
        
        $scope.create = function() {
            var modalInstance = $modal.open({
                templateUrl: 'updatePacket.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $modalInstance, stNewPacket, SubjectService, LevelService) {
                    $scope.stNewPacket = stNewPacket;
                    
                    SubjectService.getSubjects().then(function (response) {
                        $scope.stSubjects = response.data;
                    });
                    
                    LevelService.getLevels().then(function (response) {
                        $scope.stLevels = response.data;
                    });

                    $scope.subjects = [{ name: 'Math' }, { name: 'English' }, { name: 'Abacus' }, 
                                    { name: 'General Knowledge' }];
                    
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewPacket);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewPacket: function () {
                        return $scope.stNewPacket;
                    }
                }
            });
            
            modalInstance.result.then(function (stPacket) {
                ClassService.create(stPacket);
                ClassService.getPackets($rootScope.stUserData).then(function (response) {
                    $scope.stPacketData = response.data;
                    $scope.gridOptions.data = 'stPacketData';
                });
            });
        }
        
        $scope.update = function(row) {

            var modalInstance = $modal.open({
                templateUrl: 'updatePacket.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $modalInstance, stNewPacket, SubjectService, LevelService) {
                    $scope.stNewPacket = stNewPacket;
                    
                    SubjectService.getSubjects().then(function (response) {
                        $scope.stSubjects = response.data;
                    });
                    
                    LevelService.getLevels().then(function (response) {
                        $scope.stLevels = response.data;
                    });

                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewPacket);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewPacket: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stPacket) {
                ClassService.update(stPacket);
                ClassService.getPackets($rootScope.stUserData).then(function (response) {
                    $scope.stPacketData = response.data;
                    $scope.gridOptions.data = 'stPacketData';
                });
            });
        }
        
        $scope.delete = function(row) {
            var modalInstance = $modal.open({
                templateUrl: 'deletePacket.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $modalInstance, stNewPacket) {
 
                    $scope.stNewPacket = stNewPacket;                    
                   
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewPacket);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewPacket: function () {
                        return row;
                    }
                }
            });
            
            modalInstance.result.then(function (stPacket) {
                ClassService.delete(stPacket);
                ClassService.getPackets($rootScope.stUserData).then(function (response) {
                    $scope.stPacketData = response.data;
                    $scope.gridOptions.data = 'stPacketData';
                });
            });
        }

    }]);
})();
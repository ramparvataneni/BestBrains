/**
 * @ngdoc function
 * @name bestBrains.controller:InventoryCtrl
 * @description
 * # InventoryCtrl
 * Controller of the Inventory
 */
(function () {
	'use strict';
	
	var app = angular.module('bestBrains');    // get module

    app.controller('InventoryCtrl', ['$scope', '$location', '$rootScope', 'InventoryService', '$modal', '$window', '$filter', 'tAPPCONFIG', function ($scope, $location, $rootScope, InventoryService, $modal, $window, $filter, tAPPCONFIG) {
        
        $scope.stInventoryData = [];
        $scope.stRequestData = [];
        $scope.stInventoryRequest = [];
        $scope.stEmail = [];
        $scope.inventoryRequest = {};
        
        $scope.subjectFilter = {
            filterText: ''
        };
        
        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
        InventoryService.getInventory($rootScope.stUserData).then(function (response) {
            $scope.stInventoryData = response.data.STINVENTORYDATA;
            $scope.stInventoryRequest = response.data.STINVENTORYREQUEST;
        });
        
        var cellTmpl = '<div style="text-align:center;" class="ngCellText ng-scope col0 colt0" ng-class="col.colIndex()">' +
            '<span ng-cell-text="" class="ng-binding">' +
            '<input type="text" class="form-control input-xs" />' +
            '</span></div>';

        var col0HeaderCellTemplate = '<div style="text-align:center;" class="ngCellText {{col.headerClass}}">' +
            '<span ng-cell-text="" class="ng-binding"><div>' +
            '<button type="button" class="btn btn-default btn-xs" ng-click="generate();">' +
            '<span class="glyphicon glyphicon-search">Generate</span></button>' +
            '</div></span></div>';
        
        $scope.gridOptions = {  data: 'stInventoryData', 
            columnDefs: [
            { field: 'SUBJECTNAME', displayName: 'SUBJECT', width: '**' },
            { field: 'PACKET', displayName: 'Packet', width: '**' },
            {field:'EXISTINGQUANTITY', displayName: '# Available', width: '*', sortable: false, enableCellEdit: true, resizable: false},
            {field:'REQUESTEDQUANTITY', displayName: '# Requested', width: '*', sortable: false, enableCellEdit: true, resizable: false},
            /*{field:'', displayName: '', width: '100px', cellClass:'gridCellCenter', sortable: false, enableCellEdit: false,
            resizable: false, cellTemplate: cellTmpl, headerCellTemplate: col0HeaderCellTemplate},*/
            ],
            excludeProperties: ['id', '$$hashKey'],
            selectedItems: $scope.selectedRow,
            filterOptions: $scope.subjectFilter
        };
        
        $scope.stNewRequest = { "LOCATIONID": $rootScope.stUserData.LOCATIONID, "FROMDATE": "", "TODATE": "", "INCLUDEEXISTING": true, "ISMATH": true,
                               "ISENGLISH": true, "ISABACUS": true, "ISGK": true };
            
        $scope.generate = function() {
            
            var modalInstance = $modal.open({
                templateUrl: 'generateRequest.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, InventoryService, stNewRequest) {
                    $scope.stNewRequest = stNewRequest;
                    
                    $scope.open = function($event) {
                        $event.preventDefault();
                        $event.stopPropagation();

                        $scope.opened = true;
                    };
                    
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stNewRequest);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stNewRequest: function () {
                        return $scope.stNewRequest;
                    }
                }
            });
            
            modalInstance.result.then(function (stNewRequest) {
                //console.log(stNewRequest);
                InventoryService.generate(stNewRequest, $rootScope.stUserData).then(function (response) {
                    $scope.stInventoryData = response.data.STINVENTORYDATA;
                    $scope.stInventoryRequest = response.data.STINVENTORYREQUEST;
                    $scope.gridOptions.data = 'stInventoryData';
                    //$scope.stInventoryData = response.data;
                    //$scope.gridOptions.data = 'stInventoryData';
                    //$scope.$apply();
                });
            });
        }
        
        $scope.createExcel = function(inventoryRequestId) { 
            console.log(inventoryRequestId);
            InventoryService.createExcel(inventoryRequestId).then(function (response) {
                var excelFile = servicesPath + 'server/services/excels/' + response.data;
                $window.open(excelFile);
                    //$scope.stInventoryData = response.data;
                    //$scope.gridOptions.data = 'stInventoryData';
                    //$scope.$apply();
            });
        }
        
        $scope.stEmail = { "FROM": $rootScope.stUserData.EMAIL, "TO": "", "CC": "", "SUBJECT": "", "MESSAGE": "", INVENTORYREQUESTID: ""};
                             
        $scope.sendEmail = function() {
            
            var modalInstance = $modal.open({
                templateUrl: 'sendEmail.html',
                backdrop: true,
                windowClass: 'modal',
                controller: function ($scope, $rootScope, $modalInstance, stEmail) {
                    $scope.stEmail = stEmail;
                    $scope.open = function($event) {
                        $event.preventDefault();
                        $event.stopPropagation();

                        $scope.opened = true;
                    };
                    
                    //$scope.user = user;
                    $scope.submit = function () {
                        $modalInstance.close($scope.stEmail);
                    }
                    $scope.cancel = function () {
                        $modalInstance.dismiss('cancel');
                    };
                },
                resolve: {
                    stEmail: function () {
                        return $scope.stEmail;
                    }
                }
            });
            
            modalInstance.result.then(function (stEmail) {
                //console.log(stNewRequest);
                InventoryService.sendEmail(stEmail, 14, $rootScope.stUserData).then(function (response) {
                    $scope.stInventoryData = response.data;
                    $scope.gridOptions.data = 'stInventoryData';
                    //$scope.$apply();
                });
            });
        }

    }]);
})();
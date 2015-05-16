// Ram Parvatini - service for packet operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('PacketService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getPackets = function( stUserData ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/packet.cfc?method=read',
                data: {
					stUserData: stUserData,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
        
        this.create = function( stPacket ) {
			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=create',
                data: {
					stPacket: stPacket,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.update = function( stPacket ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=update',
                data: {
					stPacket: stPacket,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
        
        this.delete = function( stPacket ) {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/class.cfc?method=delete',
                data: {
					stPacket: stPacket,
				}
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;
		};
	}]);
	
})();
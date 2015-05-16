// Ram Parvatini - service for paymentMethod operations
(function() {
    'use strict';
	var app = angular.module('bestBrains');    // get module	
	
	app.service('PaymentService', ['$http', '$location', 'tAPPCONFIG',  function($http, $location, tAPPCONFIG) {

        var servicesPath = tAPPCONFIG.suROOTSERVER;
        
		this.getPaymentMethods = function() {

			var promise = $http({
                method : 'POST',
                url : servicesPath + 'server/services/payment.cfc?method=read'
            }).success(function(data, status, headers, config){
					return data;
            });
			
			return promise;

		};
    }]);
	
})();
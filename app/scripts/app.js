// Ram Parvatini, application page for BestBrains application, creates BB module and configures routing.

/**
 * @ngdoc overview
 * @name bestBrains App
 * @description
 * # bestBrains App
 *
 * Main module of the application.
 */
angular.module('bestBrains', ['ngRoute', 'ui.bootstrap', 'ngGrid', 'ui.utils']);

(function () {
    
    // Set application global values
    //  Inject any CONSTANT/VALUE into a controller or service
    angular.module('bestBrains')
        .constant('tAPPCONFIG',
        {
            // Any string for a version number. Rewritten during build process.
            slVERSION: '1.0.0',    // THIS LINE CAN BE REWRITTEN BY GRUNT
            // Provide an absolute path to the server code, because we have no context as a mobile app
            suROOTSERVER: 'http://127.0.0.1/~ram/BestBrains/',    // THIS LINE CAN BE REWRITTEN BY GRUNT
            //suROOTSERVER: 'http://neighbuyr-com.securec77.ezhostingserver.com/BestBrains/',
            end          : {}
        })
    ;

    'use strict';
    var app = angular.module('bestBrains').config(['$routeProvider', function ($routeProvider) {
        $routeProvider
            .when('/login', {
                templateUrl: 'views/login.html',
                controller: 'LoginCtrl'
            })
            .when('/about', {
                templateUrl: 'views/about.html',
                controller: 'AboutCtrl'
            })
            .when('/contact', {
                templateUrl: 'views/contact.html',
                controller: 'ContactCtrl'
            })
            .when('/dashboard', {
                templateUrl: 'views/dashboard.html',
                controller: 'DashboardCtrl'
            })
            .when('/student', {
                templateUrl: 'views/student.html',
                controller: 'StudentCtrl'
            })
            .when('/teacher', {
                templateUrl: 'views/teacher.html',
                controller: 'TeacherCtrl'
            })
            .when('/class', {
                templateUrl: 'views/class.html',
                controller: 'ClassCtrl'
            })
            .when('/packets', {
                templateUrl: 'views/packet.html',
                controller: 'PacketCtrl'
            })
            .when('/inventory', {
                templateUrl: 'views/inventory.html',
                controller: 'InventoryCtrl'
            })
            .when('/admin', {
                templateUrl: 'views/location.html',
                controller: 'LocationCtrl'
            })
            .when('/reports', {
                templateUrl: 'views/reports.html',
                controller: 'ReportCtrl'
            })
            .when('/adhoc', {
                templateUrl: 'views/adhoc.html',
                controller: 'AdhocCtrl'
            })
            .when('/location', {
                templateUrl: 'views/location.html',
                controller: 'LocationCtrl'
            })
            .when('/user', {
                templateUrl: 'views/user.html',
                controller: 'UserCtrl'
            })
            .when('/role', {
                templateUrl: 'views/role.html',
                controller: 'RoleCtrl'
            })
            .when('/key', {
                templateUrl: 'views/key.html',
                controller: 'KeyCtrl'
            })
            .when('/logout', {
                templateUrl: 'views/logout.html'
            })
            .otherwise({
                redirectTo: '/login'
            });
    }]).run(function ($rootScope, $location) {
		// register listener to watch route changes
		$rootScope.$on("$routeChangeStart", function (event, next, current) {
			$rootScope.showMessage = false;

    		// no logged user, and redirect to #login
			if (typeof (next.templateUrl) !== "undefined") {
	    		if (($rootScope.loggedIn === undefined || $rootScope.loggedIn === false) && next.templateUrl !== 'views/login.html' 
                    && next.templateUrl !== 'views/tabsample.html' && next.templateUrl !== 'views/contact.html' 
                    && next.templateUrl !== 'views/about.html') {				
					$location.path("/login");
                }
                else if($rootScope.loggedIn === true & next.templateUrl == 'views/dashboard.html') {
                    if(!$rootScope.stUserData.ISSYSTEMADMIN && !$rootScope.ISSUPERUSER){
                        if($rootScope.stUserData.ISLOCATIONADMIN || $rootScope.stUserData.ISSTUDENTADMIN) {
                            $location.path("/student");
                        }
                        else if($rootScope.stUserData.ISKEYADMIN || $rootScope.stUserData.ISKEYREADONLY)  {
                            $location.path("/key");
                        }
                        else if($rootScope.stUserData.ISCLASSADMIN)  {
                            $location.path("/class");
                        }
                           
                    }
				}
                if (next.templateUrl == 'views/logout.html') {
                    $rootScope.loggedIn = false;
                    $location.path("/login");
                }
                
            }				   
		});
	});
})();

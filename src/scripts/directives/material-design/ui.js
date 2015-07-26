angular.module('app') 

    // =========================================================================
    // NICE SCROLL
    // =========================================================================
    
    //Html

    .directive('html', ['nicescrollService', '$rootScope', 'eventConst', 'messageService', '$window', function(nicescrollService, $rootScope, eventConst, messageService, $window){
        return {
            restrict: 'E',
            link: function(scope, element) {
        
                if (!element.hasClass('ismobile')) {
                    if (!$('.login-content')[0]) {
                        var nicescroll = nicescrollService.niceScroll(element, 'rgba(0,0,0,0.3)', '5px');

                        // infinite scroll
                        nicescroll.onscrollend = function (data) {
                            if (data.end.y >= this.page.maxh) {
                                if ($rootScope.infiniteScroll) {
                                    messageService.publish(eventConst.SCROLL_BOTTOM);
                                }
                            }
                            if (data.end.y <= 0) {
                                if ($rootScope.infiniteScroll) {
                                    messageService.publish(eventConst.SCROLL_TOP);
                                }
                            }
                        };

                    }
                }

                // infiniteScroll ,,
                /*
                $rootScope.infiniteScroll = true;
                var e = $window.document.body,
                    offset = 100; // px
                $($window).bind('scroll', function() {
                    console.log('scroll ' + $rootScope.infiniteScroll + ' ' + e.scrollTop + ' ' + e.offsetHeight + ' ' + e.scrollHeight);
                    if ($rootScope.infiniteScroll && e.scrollTop + e.offsetHeight >= e.scrollHeight - offset) {
                        console.log('load more');
                        //messageService.publish(eventConst.SCROLL_BOTTOM);
                    }
                });
                 */
            }
        }
    }])


    //Table 

    .directive('tableResponsive', ['nicescrollService', function(nicescrollService){
        return {
            restrict: 'C',
            link: function(scope, element) {
        
                if (!$('html').hasClass('ismobile')) {                    
                    nicescrollService.niceScroll(element, 'rgba(0,0,0,0.3)', '5px');
                }
            }
        }
    }])


    //Chosen 

    .directive('chosenResults', ['nicescrollService', function(nicescrollService){
        return {
            restrict: 'C',
            link: function(scope, element) {
        
                if (!$('html').hasClass('ismobile')) {                    
                    nicescrollService.niceScroll(element, 'rgba(0,0,0,0.3)', '5px');
                }
            }
        }
    }])

    
    //Chosen 

    .directive('tabNav', ['nicescrollService', function(nicescrollService){
        return {
            restrict: 'C',
            link: function(scope, element) {
        
                if (!$('html').hasClass('ismobile')) {                    
                    nicescrollService.niceScroll(element, 'rgba(0,0,0,0.3)', '1px');
                }
            }
        }
    }])

    
    //For custom class

    .directive('cOverflow', ['nicescrollService', function(nicescrollService){
        return {
            restrict: 'C',
            link: function(scope, element) {
        
                if (!$('html').hasClass('ismobile')) {                    
                    nicescrollService.niceScroll(element, 'rgba(0,0,0,0.4)', '5px');
                }
            }
        }
    }])


    // =========================================================================
    // WAVES
    // =========================================================================

    
    // For .btn classes
    .directive('btn', ['Waves', function(Waves){
        return {
            restrict: 'C',
            link: function(scope, element) {
                Waves.attach(element);
                Waves.init();
            }
        }
    }])
    
    //Wave buttons for .btn-wave class
    .directive('btnWave', ['Waves', function(Waves){
        return {
            restrict: 'C',
            link: function(scope, element) {
                Waves.attach(element);
                Waves.init();
            }
        }
    }]);

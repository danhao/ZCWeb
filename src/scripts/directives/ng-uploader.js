/*
 * Author: Remy Alain Ticona Carbajal http://realtica.org
 * Description: The main objective of ng-uploader is to have a user control,
 * clean, simple, customizable, and above all very easy to implement.
 * Licence: GNU version 3
 */

;(function() {

var uploader=angular.module('app')
        .directive('ngUploader', ['uploaderFactory','$log','$timeout',function (uploaderFactory,$log,$timeout) {
            return {
                data:uploaderFactory.data,
                restrict: 'AEC',
                scope: {
                    modelField: '=',
                    formField: '@formField',
                    amount: '=',
                    filesizeLimit: '=',
                    singleImage: '='
                }, 
	            templateUrl: function(element, attrs) {
                    if(attrs.singleImage) {
                        return '/views/directives/ngUploader-image.html';
                    } else {
                        return '/views/directives/ngUploader.html';
                    }
                },
                // compile: function(element, attrs) {
                //     if (!attrs.filesizeLimit) {
                //         attrs.filesizeLimit = 5*1024*1024;
                //     }
                // },
	            link: function($scope, element, attrs) {
	                $scope.fileList= [];
	                $scope.concurrency=(typeof attrs.concurrency=="undefined")?2:attrs.concurrency;
                    $scope.concurrency=parseInt($scope.concurrency);
	                $scope.parameter=(typeof attrs.name=="undefined")?"file":attrs.name;
                    $scope.title = attrs.formTitle;
                    $scope.require = attrs.formRequire;
                    $scope.transport=(typeof attrs.transport=="undefined")?"xhr":attrs.transport; //iframe, xhr
	                $scope.activeUploads=0;	
	                $scope.getSize=function(bytes) {
                        var sizes = [ 'n/a', 'bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EiB', 'ZiB', 'YiB' ];
                        var i = +Math.floor(Math.log(bytes) / Math.log(1024));
                        return (bytes / Math.pow(1024, i)).toFixed(i ? 1 : 0) + ' ' + sizes[isNaN(bytes) ? 0 : i + 1];
                    };
                    $scope.url=(attrs.ngUploader=="")?uploaderFactory.url:attrs.ngUploader;
                    $scope.filesizeLimit = $scope.filesizeLimit || 5*1024*1024;

                    var initFlag = true;
                    var pid = uploaderFactory.pid;
                    var input = element.find("input");

                    if($scope.singleImage) {

                        $('.fileinput', element).on("change.bs.fileinput", function(e, file) {
                            if($scope.fileList.length > 0) {
                                $scope.reset();
                            }
                            $scope.fileList.push({
				                parameter:$scope.parameter,
				                active:false,
				                filename:file.name,
				                file:file,
				                value:(0/file.size)*100,
				                size:0,
                                key:pid+"/"+createguidfilename(file.name),
				                total:$scope.getSize(file.size)
			                });
                            $scope.$apply();
			                $scope.startUpload();
                        })
                            .on("clear.bs.fileinput", function(e) {
                                $scope.erase(0);
                                $scope.$apply();
                            })
                            .on("reset.bs.fileinput", function() {
                                $scope.erase(0);
                                $scope.$apply();
                            });
                        
                    } else {
	                    element.bind("change", function(e) {
                            var target = e.target;
                            if(target.tagName == "INPUT" && target.type == "file") {
                                $scope.error = ''; // reset error
                                
		                        var files=e.target.files;
		                        for ( var i = 0; i < files.length; i++) {
                                    // $log.log(files[i].size);
                                    if($scope.filesizeLimit && $scope.filesizeLimit != -1 && files[i].size > $scope.filesizeLimit) {
                                        $scope.error = '上传文件大小超过限制';
                                        $scope.$apply();
                                        return;
                                    }
                                    
                                    $scope.aliyunfile =pid+"/"+createguidfilename(files[i].name);
			                        $scope.fileList.push({
				                        parameter:$scope.parameter,
				                        active:false,
				                        filename:files[i].name,
				                        file:files[i],
				                        value:(0/files[i].size)*100,
				                        size:0,
                                        key:$scope.aliyunfile ,
				                        total:$scope.getSize(files[i].size)
			                        });
		                        }
                                
		                        $scope.$apply();
			                    $scope.startUpload();
                            }
	                    });

                        element.bind("click", function(e) {
                            if($scope.amount && $scope.amount != -1 && $scope.fileList.length >= $scope.amount) {
                                e.preventDefault();
                            }
                        });
                    }

                    // reset
                    $scope.$watch("modelField", function(newVal, oldVal) {
                        
                        // console.log( 'modelField: --------------------' );
                        // console.log(newVal);

                        if(!newVal) {
                            $scope.fileList = [];
                        }
                        else if(newVal !== oldVal && initFlag) { // init fileList
                            initFlag = false;

                            if(angular.isArray(newVal)) {
                                angular.forEach(newVal, function(m) {
                                    $scope.fileList.push({
                                        filename: m.name,
                                        url: m.url,
                                        key: m.id
                                    });
                                });
                            }
                            else if(angular.isObject(newVal)) {
                                $scope.fileList.push({
                                    filename: newVal.name,
                                    url: newVal.url,
                                    key: newVal.id
                                });
                            }

                            // single image
                            if($scope.singleImage) {
                                var url;
                                if ($scope.fileList.length > 0) {
                                    url = $scope.fileList[0].url;
                                } else if(angular.isString(newVal)) {
                                    url = newVal;
                                }
                                if(url) {
                                    $('.fileinput-preview', element).html($('<img>').attr("src", url));
                                    $('.fileinput', element).addClass('fileinput-exists').removeClass('fileinput-new');
                                }
                            }
                        }
                    });
                    $scope.$watch("formField", function(newVal, oldVal) {
                        if(!newVal) {
                            $scope.fileList = [];
                        }
                    });

                    $scope.reset = function() {
                        $scope.fileList = [];
                        if($scope.modelField) {
                            $scope.modelField = [];
                        }
                        if($scope.formField) {
                            angular.element(document.getElementById($scope.formField)).val('');
                        }
                    };
                    
	                $scope.erase=function(ele){
		                // $log.info("file erased=");
		                $scope.fileList.splice( angular.isNumber(ele)? ele: $scope.fileList.indexOf(ele), 1 );
                        $scope.updateCallbackValue();
                        
	                };
	                $scope.onProgress=function(upload, loaded){
		                $log.info("progress="+loaded);
		                upload.value=(loaded/upload.size)*100; //upload.file.size
		                upload.size=$scope.getSize(loaded);
		                $scope.$apply();
	                };	
		            
	                $scope.onCompleted=function(upload){
		                $log.info("file uploaded="+upload.filename);
		                $scope.activeUploads-=1;
		                // $scope.fileList.splice( $scope.fileList.indexOf(upload), 1 );
		                $scope.$apply();
                        
		                // $scope.startUpload();
	                };
                    
                    $scope.onStartUpload=function(){
                        
                    };
                    
	                $scope.startUpload=function(){
		                // $log.info("URL="+$scope.url+" ;parameter="+$scope.parameter);
		                //$log.info("Init Upload");

                        var transportFun = {'xhr': $scope.xhrTransport, 'iframe': $scope.iframeTransport}[$scope.transport];
		                // $scope.concurrency=($scope.concurrency==undefined)?2:$scope.concurrency;
                        
		                for(var i in $scope.fileList){		  
			                // if ($scope.activeUploads == $scope.concurrency) {
                            //     break;
                            // }
			                
			                if($scope.fileList[i].active)
				                continue;
			                // $scope.ajaxUpload($scope.fileList[i]);

                            transportFun($scope.fileList[i]);
			                
		                }
		                $scope.onStartUpload();
	                };
	                
	                $scope.ajaxUpload=function(upload) {
                        
                        var xhr, formData, prop, key = "" || 'file', index,
                            data = uploaderFactory.data;
                        
                        //index = upload.count;
                        console.log('Beging upload: ' + upload.filename);
                        $scope.activeUploads+=1;
			            upload.active=true;
                        xhr = new window.XMLHttpRequest();
                        formData = new window.FormData();
                        xhr.open('POST', $scope.url);

                        // Triggered when upload starts:
                        xhr.upload.onloadstart = function() {
                            // File size is not reported during start!
                            console.log('Upload started: ' + upload.filename);
                            //methods.OnStart(upload.newname);
                        };

                        // Triggered many times during upload:
                        xhr.upload.onprogress = function(event) {
                            // console.dir(event);
                            if (!event.lengthComputable) { return; }

                            // Update file size because it might be bigger than reported by
                            // the fileSize:
                            console.log("File: " + upload.filename);
                            //methods.OnProgress(xhr,event.total, event.loaded, index, upload.newname,upload);
				            $scope.onProgress(upload, event.loaded);
                        };

                        // Triggered when upload is completed:
                        xhr.onload = function(event) {
                            console.log('Upload completed: ' + upload.filename);

                            // 回传文件名
                            $scope.updateCallbackValue();
                            
				            $scope.onCompleted(upload);
                            
                        };

                        // Triggered when upload fails:
                        xhr.onerror = function() {
                            console.log('Upload failed: ', upload.filename);
                        };

                        // Append additional data if provided:
                        if (data) {
                            for (prop in data) {
                                if (data.hasOwnProperty(prop)) {
                                    console.log('Adding data: ' + prop + ' = ' + data[prop]);
                                    formData.append(prop, data[prop]);
                                }
                            }
                        }
                        // aliyun
                        if(upload.hasOwnProperty("key")) {
                            formData.append("key", upload.key);
                        }

                        // Append file data:
                        formData.append(key, upload.file, upload.parameter);

                        // Initiate upload:
                        xhr.send(formData);
                        
                        return xhr;
                    };


                    /*
                    var upload_form_name = "__file_upload_form__",
                        ajax_iframe_name = "__ajax_iframe__";

                    function getUploadForm() {
                        var form = document.getElementById(upload_form_name);
                        if(!form) {
                            form = angular.element('<form id="'+upload_form_name+'" name="'+upload_form_name+'" style="display: none;" />');

                            // append oss data
                            if (uploaderFactory.ossData) {
                                angular.forEach(uploaderFactory.ossData, function(value, key) {
                                    var element = angular.element('<input type="hidden" name="' + key + '" />');
                                    element.val(value);
                                    form.append(element);
                                });
                            }
                            
                            angular.element(document.body).append(form);
                        } else {
                            form = angular.element(form);
                        }
                        return form;
                    };

                    function getAjaxIframe() {
                        var iframe = document.getElementById(ajax_iframe_name);
                        if(!iframe) {
                            iframe = angular.element('<iframe id="'+ajax_iframe_name+'" name="'+ajax_iframe_name+'" style="height:0;border:none;">');
                            angular.element(document.body).append(iframe);
                        } else {
                            iframe = angular.element(iframe);
                        }
                        return iframe;
                    };
                     */
                    
                    var createguidfilename = function(filename) {
                        var S4 = function () {
                            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
                        };
                        var guid = (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
                        return guid + "." + filename.split('.')[1];
                    };

                    var removeFormAndIframe = function(formName, iframeName) {
                        $timeout(function() {
                            angular.element(document.getElementById(formName)).remove();
                            angular.element(document.getElementById(iframeName)).remove();
                            // $log.log("remove "+formName+", "+iframeName);
                        }, 3000);
                    };

                    $scope.updateCallbackValue = function() {
                        initFlag = false;
                        var fileList = $scope.fileList;
                        var fieldId = $scope.formField;
                        var names = [];
                        $scope.modelField = [];
                        angular.forEach(fileList, function(v, k) {
                            names.push(v.filename+";"+v.key);
                            $scope.modelField.push({
                                name: v.filename,
                                id: v.key,
                                url: v.url
                            });
                        });
                        if(fieldId) {
                            var formField = angular.element(document.getElementById(fieldId));
                            formField.val(names.length > 0 ? names.join("|") : "");
                        }

                        // $scope.modelField = names.join("|");
                    };

                    $scope.xhrTransport = $scope.ajaxUpload;

                    $scope.iframeTransport = function(upload) {
                        var data = uploaderFactory.data,
                            postfix = Date.now() + Math.round(Math.random()*1000), 
                            form_name = "__file_upload_form__" +""+ postfix,
                            iframe_name = "__ajax__iframe__" +""+ postfix, 
                            form = angular.element('<form id="'+form_name+'" name="'+form_name+'" style="display: none;" />'),
                            iframe = angular.element('<iframe id="'+iframe_name+'" name="'+iframe_name+'" style="height:0;border:none;">');

                        angular.forEach(data, function(value, key) {
                            var element = angular.element('<input type="hidden" name="' + key + '" />');
                            // if(key=='key')
                            //     value=$scope.aliyunfile;
                            element.val(value);
                            form.append(element);
                        });
                        // aliyun
                        if(upload.hasOwnProperty("key")) {
                            form.append(angular.element('<input type="hidden" name="key" value="'+ upload.key +'" />'));
                        }
                        
                        form.prop({
                            action: $scope.url,
                            method: 'POST',
                            target: iframe_name,
                            enctype: 'multipart/form-data',
                            encoding: 'multipart/form-data' // old IE
                        });

                        iframe.on('load', function() {
                            // $log.log("iframe load");
                            try {
                                var html = iframe[0].contentDocument.body.innerHTML;
                            } catch(e) {}

                            // upload.completed = true;
                            
                            var xhr = {responseText: html, status: 200, dummy: true};
                            $scope.onCompleted(upload, xhr.responseText);

                            removeFormAndIframe(form_name, iframe_name);
                        });
                        
                        form.abort = function() {
                            var xhr = {status: 0, dummy: true};
                            var headers = {};
                            var response;

                            iframe.unbind('load').prop('src', 'javascript:false;');

                            $scope.onCancel(upload, response);
                            $scope.onCompleted(upload, response);
                        };

                        /*
                        var clone = input.clone(true);
                        input.after(clone);
                         */

                        var clone = $('<input>',{type:input.attr('type'), name:input.attr('name'), class:input.attr('class')});
                        input.after(clone);
                        
                        form.append(input);
                        form.find("input[name='key']").val(upload.key);

                        // angular.element(document.body).append(form).append(iframe);
                        element.append(form).append(iframe);

                        input = clone;
                        
                        $scope.activeUploads+=1;
			            upload.active=true;

                        form[0].submit();

                        
                        // 回传文件名
                        $scope.updateCallbackValue();

                    };
		            
	            }
            };
        }]
                  ).factory('uploaderFactory',['$log', '$rootScope', function($log, $rootScope){
                      /*
                      $log.log("uploader factory");
                      $log.log($rootScope.ossInfo);
                      return{
                          ossData_daniel: {
                              OSSAccessKeyId: "1P160AxzpPoOG6Ej", 
				              policy: "ewoiZXhwaXJhdGlvbiI6ICIyMTIwLTAxLTAxVDEyOjAwOjAwLjAwMFoiLAoiY29uZGl0aW9ucyI6IFsKWyJjb250ZW50LWxlbmd0aC1yYW5nZSIsIDAsIDEwNDg1NzYwMF0KXQp9Cg==", 
				              signature: "FFiEl/wNWyS/SeemjtZmD2nTps8=", 
				              key: "test.jpg"
                          },
                          url_daniel: 'http://zichan.oss-cn-shenzhen.aliyuncs.com',
                          
                          data: {
                              OSSAccessKeyId: "PHpoJkXBSQQslYos", 
				              policy: "ewoiZXhwaXJhdGlvbiI6ICIyMTIwLTAxLTAxVDEyOjAwOjAwLjAwMFoiLAoiY29uZGl0aW9ucyI6IFsKWyJjb250ZW50LWxlbmd0aC1yYW5nZSIsIDAsIDEwNDg1NzYwMF0KXQp9Cg==", 
				              signature: "dSp3ADf7Q1fEKMGaaet/Jdzz2N8=", 
				              key: "test.jpg"
                          },
                          url: "http://yonger1983.oss-cn-shenzhen.aliyuncs.com"
                      };
                       */

                      var ossInfo = $rootScope.ossInfo,
                          pid = $rootScope.user.pid;
                      return {
                          data: {
                              OSSAccessKeyId: ossInfo.ossId, 
                              policy: ossInfo.policy,
                              signature: ossInfo.signature
                              // key: 'test.png'
                          },
                          url: ossInfo.url, 
                          pid: pid
                      };

                  }]);

})();

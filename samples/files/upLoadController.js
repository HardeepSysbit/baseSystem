//Dependency  Upload required


$scope.progress = '';


$scope.fileImg = function () {

    if ($scope.local.file != undefined) {

        var fileName = $scope.local.file.name;

        if (fileName != undefined && fileName != '') {


            $scope.fileName = fileName;

            var fileExtn = fileName.substring(fileName.length - 4);

            $scope.btnLoadText = "\u2713 Load Image";


            return "myLib/icons/" + fileExtn.substring(1) + ".png";



        }


    }
}


var bytFile = { file: $scope.local.file };

var objFile = new Object();
objFile.docLib = "xxxx";
objFile.docSet = "yyyy";
objFile.title = "zzzz";
objFile.fileName = bytFile.file.name;



sysBitApi.upLoadFile($scope, objFile, bytFile)
  .then(
                function (strResponse) {

                  

                },

                function (strErrMsg) {
                    sysBitApi.showMsg($scope.form.msgError, "UpLoad File Error", strErrMsg);
                }
            )
;
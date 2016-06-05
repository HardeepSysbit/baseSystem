var promises = [];


    promises.push(XXXX);


$q.all(promises).then(
function () {
    

},
function () {
    
}
).finally(function () {

   
});

function XXXX(q) {
 

    var objXXXX = {}
    objXXXX.data = {};
    objXXXX.dbAction = "" // execSp, find, findOne, remove, aggregate, update, insert

    // for MonogDb
    objXXXX.collectionName = ""  // name of MongoDb collection

    // for Sql
    //objXXXX.dbSp =  ""  // stored procedure to execute


    var deferred = q.defer();

    sysBitApi.webApi(objXXXX).then(

                                        function (objResponse) {

                                            deferred.resolve(objResponse.data);


                                        },
                                        function (objErr) {

                                            sysBitApi.showHttpErr(objErr);
                                            deferred.reject(objErr);
                                        }
                                );

    return deferred.promise;

    

   

}




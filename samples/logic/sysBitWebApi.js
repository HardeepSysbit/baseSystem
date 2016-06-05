var objXXXX = {}
objXXXX.dbAction = "" // execSp, find, findOne, remove, aggregate, update, insert

objXXXX.data = {};

// if MongoDb for find and findOne
//objXXXX.data.filter = {};
//objXXXX.data.project = {};

// if MongoDb for AggreGate
//objXXXX.data = [];
//objXXXX.data.push({$match {}});
//objXXXX.data.push({$project {}});


// for MonogDb
objXXXX.collectionName =  ""  // name of MongoDb collection

// for Sql
//objXXXX.dbSp =  ""  // stored procedure to execute


sysBitApi.webApi(objXXXX).then(

                                    function (objResponse) {


                                    },
                                    function (objErr) {

                                        sysBitApi.showHttpErr(objErr);

                                    }
                            );


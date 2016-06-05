function downLoadImg(url, appName, docLib, docSet, fileName, title) {

    objFile = new Object();
    objFile.appName = appName;
    objFile.docLib = docLib;
    objFile.docSet = docSet ;
    objFile.fileName = fileName;


    var metaData = JSON.stringify(objFile);

    window.open(url + '/downLoad/?metaData=' + metaData, '',title, "width=200, height=100");   // Opens a new window




}
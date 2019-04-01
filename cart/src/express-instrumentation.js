/**
 * Instruments the express library
 *
 * @param  {Object} shim
 * @param  {Object} express
 * @param  {Object} moduleName
 */

function instrumentExpress(shim, express, moduleName) {
    console.log("Custom Extension instrumenting module: " + moduleName);
    originalInit = express.application.init;

    express.application.init = function() {
        originalInit.apply(this, arguments);
        console.log("Custom Extension adding middleware to express");
        var labelsMap = {};

        var ymlLabels = shim.agent.config.labels;
        var labelArray = [];
        for (var ymlLabel in ymlLabels) {
            labelArray.push(ymlLabel);
        }

        var confPath = shim.agent.config.config_file_path;
        var otherLabels = require(confPath).config.transaction_listener_service_labels;
        for (var otherLabel in otherLabels) {
            labelArray.push(otherLabels[otherLabel]);
        }

        var addDeploymentVersionLabel = true;
        for (var i = 0; i <labelArray.length; i++) {
            if (labelArray[i].toLowerCase() === "deployment_version") {
                addDeploymentVersionLabel = false;
            }
        }
        if (addDeploymentVersionLabel === true) {
            labelArray.push("deployment_version");
        }

        console.log("\nCustom Extension will process these labels:")
        console.log(labelArray);

        for (var i = 0; i < labelArray.length; i++) {
            var uKey = labelArray[i].toUpperCase();
            var value = process.env[uKey];
            if ((value == null) || (value.isEmpty)) {
                value = ymlLabels[labelArray[i]];
            }
            if ((value != null) && (!value.isEmpty)) {
                labelsMap[labelArray[i]] = value;
            }
        }

        console.log("\nCustom Extension will add these labels to transactions as parameters");
        console.log(labelsMap);
        this.use(function(req, res, next) {
            for (var label in labelsMap) {
                shim.agent.getTransaction().trace.addParameter(label, labelsMap[label]);
            }
            next();
        });

    }
}

exports = module.exports = {
    instrumentExpress: instrumentExpress
};

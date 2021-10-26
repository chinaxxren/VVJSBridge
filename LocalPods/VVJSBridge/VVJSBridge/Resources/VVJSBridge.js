var VVJSBridge = {

    exec: function (plugin, funcName, params, successCallback, failureCallback) {
        var message;
        var timeStamp = new Date().getTime();
        var successCallbackId = plugin + '_' + funcName + '_' + timeStamp + '_' + 'successCallback';
        var failureCallbackId = plugin + '_' + funcName + '_' + timeStamp + '_' + 'failureCallback';
        if (successCallback) {
            if (!VVBridgeEvent._listeners[successCallbackId]) {
                VVBridgeEvent.addEvent(successCallbackId, function (data) {
                    successCallback(data);
                });
            }
        }

        if (failureCallback) {
            if (!VVBridgeEvent._listeners[failureCallbackId]) {
                VVBridgeEvent.addEvent(failureCallbackId, function (data) {
                    failureCallback(data);
                });
            }
        }

        if (successCallback && failureCallback) {
            message = {
                'plugin': plugin,
                'func': funcName,
                'params': params,
                'successCallbackId': successCallbackId,
                'failureCallbackId': failureCallbackId
            };

        } else if (successCallback && !failureCallback) {
            message = {'plugin': plugin, 'func': funcName, 'params': params, 'successCallbackId': successCallbackId};
        } else if (failureCallback && !successCallback) {
            message = {'plugin': plugin, 'func': funcName, 'params': params, 'failureCallbackId': failureCallbackId};
        } else {
            message = {'plugin': plugin, 'func': funcName, 'params': params};
        }
        
        window.webkit.messageHandlers.VVJSBridge.postMessage(message);
    },

    callback: function (callbackId, data) {
        VVBridgeEvent.fireEvent(callbackId, data);
        VVBridgeEvent.removeEvent(callbackId);
    },

    removeAllCallbacks: function (data) {
        VVBridgeEvent._listeners = {};
    }
};


var VVBridgeEvent = {

    _listeners: {},

    addEvent: function (callbackId, fn) {
        this._listeners[callbackId] = fn;
        return this;
    },

    fireEvent: function (callbackId, param) {
        var fn = this._listeners[callbackId];
        if (typeof callbackId === "string" && typeof fn === "function") {
            fn(param);
        } else {
            delete this._listeners[callbackId];
        }
        return this;
    },

    removeEvent: function (callbackId) {
        delete this._listeners[callbackId];
        return this;
    }
};



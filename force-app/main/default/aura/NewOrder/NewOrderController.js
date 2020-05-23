({
    onSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Order Created",
            "message": "Order Created!"
        });
        helper.navigateTo(component, event.getParam("id"));
    },
    onCancel : function(component, event, helper) {
		var homeEvt = $A.get("e.force:navigateToObjectHome");
		homeEvt.setParams({
    		"scope": "Order"
		});
		homeEvt.fire();
    },
    onSubmit : function(component, event, helper) {
    	
    },
    onError : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "error",
            "title": "Error",
            "message": "Error!"
        });
        toastEvent.fire();
    }    
})
/*({
	doInit : function(component, event, helper) {
		component.find("forceRecord").getNewRecord(
        "Order",
        null,
        false,
        $A.getCallback(function() {
            var rec = component.get("v.orderRecord");
            var error = component.get("v.recordError");
            if (error || (rec === null)) {
                console.log("Error initializing record template: " + error);
                return;
            }
        })
    	);
	},
    saveRecord : function(component, event, helper) {
		/*var propBeds = parseInt(component.find('propBeds').get("v.value"), 10);
		var propBaths = parseInt(component.find('propBaths').get("v.value"), 10);
		var propPrice = parseInt(component.find('propPrice').get("v.value"), 10);
		component.set("v.orderRecord.Name", component.find('propName').get("v.value"));    
		component.set("v.orderRecord.Beds__c", propBeds);
		component.set("v.orderRecord.Baths__c", propBaths);
		component.set("v.orderRecord.Price__c", propPrice);
		component.set("v.orderRecord.Status__c", component.find('propStatus').get("v.value"));//
        var shippingAddress = component.find('shippingAddress');
        component.set("v.orderRecord.EffectiveDate",component.find('orderDate').get("v.value"));
		component.set("v.orderRecord.AccountId",'0012w000006sVfZAAU');
        component.set("v.orderRecord.ContractId",'8002w000000TjtoAAC');
		component.set("v.orderRecord.Status",'Draft');
        component.set("v.orderRecord.ShippingStreet",shippingAddress.get("v.street"));
        component.set("v.orderRecord.ShippingCountry",shippingAddress.get("v.country"));
        component.set("v.orderRecord.ShippingPostalCode",shippingAddress.get("v.postalCode"));
        component.set("v.orderRecord.ShippingCity",shippingAddress.get("v.city"));
        component.set("v.orderRecord.ShippingProvince",shippingAddress.get("v.province"));
        var tempRec = component.find("forceRecord");
		tempRec.saveRecord($A.getCallback(function(result) {
    		console.log(result.state);
    		var resultsToast = $A.get("e.force:showToast");
    		if (result.state === "SUCCESS") {
        		resultsToast.setParams({
            		"title": "Saved",
            		"message": "The record was saved."
        		});
        		resultsToast.fire();
                var recId = result.recordId;
				helper.navigateTo(component, recId);
    		} else if (result.state === "ERROR") {
        		console.log('Error: ' + JSON.stringify(result.error));
        		resultsToast.setParams({
            		"title": "Error",
            		"message": "There was an error saving the record: " + JSON.stringify(result.error)
        		});
        		resultsToast.fire();
    		} else {
        		console.log('Unknown problem, state: ' + result.state + ', error: ' + JSON.stringify(result.error));
    		}
		}));
    },
    cancelDialog : function(component, helper) {
        var homeEvt = $A.get("e.force:navigateToObjectHome");
		homeEvt.setParams({
    		"scope": "Order"
		});
		homeEvt.fire();
	}
})*/
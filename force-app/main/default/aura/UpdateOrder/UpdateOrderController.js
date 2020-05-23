({
    onSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Order Updated",
            "message": "Order Updated!"
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
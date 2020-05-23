public with sharing class OrderItemController {
    @AuraEnabled
    public static void insertOrderItems(List<OrderItem> li){
        insert li;
    }
}

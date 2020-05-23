public with sharing class PricebookEntryController {
    public class Product {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String code { get; set; }
        @AuraEnabled public Decimal price { get; set; }
        @AuraEnabled public String brand { get; set; }
        @AuraEnabled public Decimal qty { get; set; }
        @AuraEnabled public Id pbid { get; set; }
        
        public Product(Id pbid,String name, String code, Id id, Decimal price, String brand, Decimal qty) {
            this.id = Id;
            this.name = name;
            this.code = code;
            this.price = price;
            this.brand = brand;
            this.qty = qty;
            this.pbid = pbid;
        }
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<Product> searchProducts(String searchTerm) {
        List<Product> products = new List<Product>();
        List<Id> ids = new List<Id>();
        List<PricebookEntry> pb = [SELECT Id,Name,Product2Id,ProductCode,UnitPrice FROM PricebookEntry WHERE Pricebook2Id = '01s2w000005otEMAAY' ORDER BY Name LIMIT 50];
        for(PricebookEntry pbe : pb)
            ids.add(pbe.Product2Id);
        List<Product2> prod = [SELECT Brand__c,Stock_Quantity__c FROM Product2 WHERE Id IN:ids];
        for(PricebookEntry pbe : pb){
            for(Product2 p:prod){
                if(p.Id!=pbe.Product2Id)
                    continue;
                else{
                    products.add(new Product(pbe.Id,pbe.Name,pbe.ProductCode,pbe.Product2Id,pbe.UnitPrice,p.Brand__c,p.Stock_Quantity__c));
                    break;
                }
            }
        }
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return products;
        }
        List<Product> mylist = new List<Product>();
        for(Product pr: products){
            if(pr.brand.containsIgnoreCase(searchTerm)||pr.code.containsIgnoreCase(searchTerm)||pr.name.containsIgnoreCase(searchTerm))
                mylist.add(pr);
        }
        if(searchTerm.isNumeric()){
            for(Product pr: products){
                if(pr.price<Integer.valueof(searchTerm)&&(!mylist.contains(pr)))
                    mylist.add(pr);
            }
        }
        return mylist;
    }
}
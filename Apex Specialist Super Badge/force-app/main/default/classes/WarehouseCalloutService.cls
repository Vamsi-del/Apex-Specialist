public with sharing class WarehouseCalloutService implements Queueable{
    public String id;
    public Boolean replacement;
    public Double quantity;
    public String name;
    public Integer maintenanceperiod;
    public Integer Lifespan;
    public Double cost;
    public String sku;
    
    @future(callout=true)
    public static void getWarehouseData(){
        List<WarehouseCalloutService> data = new List<WarehouseCalloutService>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        HttpResponse response = http.send(request);
        if(response.getStatusCode()==200){
        	System.debug(response.getBody());
            data = (List<WarehouseCalloutService>)JSON.deserialize(response.getBody(), WarehouseCalloutService[].class);
            List<Product2> products = [SELECT Name,Replacement_Part__c,Cost__c,Current_Inventory__c,Lifespan_Months__c,Maintenance_Cycle__c,Warehouse_SKU__c FROM Product2];
            Map<String,WarehouseCalloutService> mapWithName = new Map<String,WarehouseCalloutService>();
            List<Product2> productToUpsert = new List<Product2>();
            for(WarehouseCalloutService w : data){
                mapWithName.put(w.name,w);
            }
            for(Product2 product : products){
                WarehouseCalloutService storedResponse = mapWithName.get(product.Name);
                if(storedResponse != null){
                    product.Cost__c = storedResponse.cost;
                    product.Lifespan_Months__c = storedResponse.Lifespan;
                    product.Maintenance_Cycle__c = storedResponse.maintenanceperiod;
                    product.Replacement_Part__c = storedResponse.replacement;
                    product.Warehouse_SKU__c = storedResponse.sku;
                    product.Current_Inventory__c = storedResponse.quantity;
                    productToUpsert.add(product);
                    mapWithName.remove(product.Name);
                }
            }
            for(String a : mapWithName.keySet()){
                WarehouseCalloutService storedResponse = mapWithName.get(a);
                productToUpsert.add(new Product2(Cost__c = storedResponse.cost,
                                                Lifespan_Months__c = storedResponse.Lifespan,
                                                Maintenance_Cycle__c = storedResponse.maintenanceperiod,
                                                Replacement_Part__c = storedResponse.replacement,
                                                Warehouse_SKU__c = storedResponse.sku,
                                                Current_Inventory__c = storedResponse.quantity,
                                                Name=storedResponse.name));
            }
            upsert productToUpsert;
        }
        
    }
    public static void execute(QueueableContext qc){
        getWarehouseData();
    }
    
}
@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @isTest
    private static void getWarehouseDataTest(){
        Test.startTest();
        Product2 p = new Product2(Name='Test Product',Cost__c=100,Maintenance_Cycle__c=13,Replacement_Part__c=true);
        insert p;
        System.enqueueJob(new WarehouseCalloutService());
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService.getWarehouseData();
        Test.stopTest();
        List<Product2> ps = [SELECT Id,Name,Maintenance_Cycle__c FROM Product2];
        System.assertEquals(2, ps.size());
        System.assertEquals(365, ps[0].Name=='Test Product'?ps[0].Maintenance_Cycle__c:ps[1].Maintenance_Cycle__c);
    }
}
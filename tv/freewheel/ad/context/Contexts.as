package tv.freewheel.ad.context
{
   import tv.freewheel.ad.manager.AdManager;
   
   public class Contexts
   {
       
      
      public var requestContext:RequestContext;
      
      public var adManagerContext:AdManagerContext;
      
      public function Contexts(param1:AdManager)
      {
         super();
         this.adManagerContext = new AdManagerContext(param1,this);
         this.requestContext = new RequestContext(this);
      }
      
      public function refresh() : void
      {
         if(this.requestContext)
         {
            this.requestContext.dispose();
         }
         this.requestContext = new RequestContext(this);
         if(this.adManagerContext)
         {
            this.adManagerContext.selectedBundleId = null;
            this.adManagerContext.adRequestBase = "http://g1.v.fwmrm.net";
         }
      }
      
      public function dispose() : void
      {
         if(this.requestContext)
         {
            this.requestContext.dispose();
            this.requestContext = null;
         }
         if(this.adManagerContext)
         {
            this.adManagerContext.dispose();
            this.adManagerContext = null;
         }
      }
   }
}

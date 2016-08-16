From: Sean McGinnis <sean.mcginnis@gmx.com>
Subject: [PATCH 1/1] multipath-tools: Add Dell SC name and
	maintainer
Date: Tue, 16 Aug 2016 07:58:06 -0500
Message-ID: <20160816125806.GA14609@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Compellent Storage Center is now Dell SC Series storage. Added                  
contact name for maintenance.                                                   
                                                                                
Signed-off-by: Sean McGinnis <sean_mcginnis@dell.com>                           
---                                                                             
 libmultipath/hwtable.c | 6 ++++++                                              
 1 file changed, 6 insertions(+)                                                
                                                                                
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c                    
index 1bc6f2c..d25f937 100644                                                   
--- a/libmultipath/hwtable.c                                                    
+++ b/libmultipath/hwtable.c                                                    
@@ -211,6 +211,12 @@ static struct hwentry default_hw[] = {                     
         * DELL                                                                 
         */                                                                     
        {                                                                       
+                /*                                                             
+                 * Dell SC Series, formerly Compellent                         
+                 *                                                             
+                 * Maintainer : Sean McGinnis                                  
+                 * Mail: sean_mcginnis@dell.com                                
+                 * */                                                          
                .vendor        = "COMPELNT",                                    
                .product       = "Compellent Vol",                              
                .pgpolicy      = MULTIBUS,                                      
--                                                                              
1.9.1                                                                           

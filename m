From: Jonathan Brassow <jbrassow@redhat.com>
Subject: dm-raid1:  Fix to commit pending clear region requests
Date: Thu, 05 Apr 2007 10:12:31 -0500
Message-ID: <1175785951.23622.1.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

 brassow

With the code as it is, it is possible for clear region request to never get flushed at the
end of the life of a mirror.  When deactivating or suspending, the mirror may have issued
clear region requests to the log, but it will never flush them.  This means there will
always be some resync work required when a mirror is activated - even though it may very
well be in-sync.

Always performing the flush doesn't hurt us.  This is because the log keeps track of
any changes that occur.  If there are no changes, the log does not flush to disk.

Index: linux-2.6.21-rc5-mm4/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/drivers/md/dm-raid1.c
+++ linux-2.6.21-rc5-mm4/drivers/md/dm-raid1.c
@@ -405,8 +405,7 @@ static void rh_update_states(struct regi
 		mempool_free(reg, rh->region_pool);
 	}
 
-	if (!list_empty(&recovered))
-		rh->log->type->flush(rh->log);
+	rh->log->type->flush(rh->log);
 
 	list_for_each_entry_safe (reg, next, &clean, list)
 		mempool_free(reg, rh->region_pool);

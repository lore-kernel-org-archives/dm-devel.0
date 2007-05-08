From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 24/26] dm raid1: fix to commit pending
	clear region requests
Date: Tue, 8 May 2007 20:49:09 +0100
Message-ID: <20070508194909.GE24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Jonathan Brassow <jbrassow@redhat.com>

With the code as it is, it is possible for oustanding clear region
requests never to get flushed when a mirror is deactivated or suspended.
This means there will always be some resync work required when a mirror
is activated, even though it may very well be in-sync.

Always requesting the flush doesn't hurt us.  This is because the log
tracks whether any changes occurred and, if not, no flush is performed.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.21/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-raid1.c	2007-05-01 19:20:13.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-raid1.c	2007-05-01 19:20:17.000000000 +0100
@@ -405,8 +405,7 @@ static void rh_update_states(struct regi
 		mempool_free(reg, rh->region_pool);
 	}
 
-	if (!list_empty(&recovered))
-		rh->log->type->flush(rh->log);
+	rh->log->type->flush(rh->log);
 
 	list_for_each_entry_safe (reg, next, &clean, list)
 		mempool_free(reg, rh->region_pool);

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-thin: fix a race in thin_dtr
Date: Wed, 5 Nov 2014 17:00:13 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1411051658290.19828@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Note that as long as struct thin_c is in the list, anyone can grab a
reference of it. Consequently, we must wait for the reference count to
drop to zero *after* we remove the structure from the list, not before.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-thin.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-3.18-rc3/drivers/md/dm-thin.c
===================================================================
--- linux-3.18-rc3.orig/drivers/md/dm-thin.c	2014-11-05 21:08:06.000000000 +0100
+++ linux-3.18-rc3/drivers/md/dm-thin.c	2014-11-05 21:08:57.000000000 +0100
@@ -3247,14 +3247,14 @@ static void thin_dtr(struct dm_target *t
 	struct thin_c *tc = ti->private;
 	unsigned long flags;
 
-	thin_put(tc);
-	wait_for_completion(&tc->can_destroy);
-
 	spin_lock_irqsave(&tc->pool->lock, flags);
 	list_del_rcu(&tc->list);
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
 	synchronize_rcu();
 
+	thin_put(tc);
+	wait_for_completion(&tc->can_destroy);
+
 	mutex_lock(&dm_thin_pool_table.mutex);
 
 	__pool_dec(tc->pool);

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3.15-3.18] dm thin: fix a race in thin_dtr
Date: Fri, 2 Jan 2015 16:23:50 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1501021528310.23461@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

Hi

Here I'm sending backport of patch 
17181fb7a0c3a279196c0eeb2caba65a1519614b. It is suitable for stable 
branches 3.15 to 3.18.

Mikulas


commit 17181fb7a0c3a279196c0eeb2caba65a1519614b
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Wed Nov 5 17:00:13 2014 -0500

    dm thin: fix a race in thin_dtr
    
    As long as struct thin_c is in the list, anyone can grab a reference of
    it.  Consequently, we must wait for the reference count to drop to zero
    *after* we remove the structure from the list, not before.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 8c5504c..767417a 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3622,14 +3622,14 @@ static void thin_dtr(struct dm_target *ti)
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

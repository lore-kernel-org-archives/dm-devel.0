From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] backing-dev: use synchronize_rcu_expedited instead of
 synchronize_rcu
Date: Wed, 20 Jul 2011 20:29:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens

Please would you consider taking this into the block tree? It seems to 
speed up device deletion enormously.

Mikulas

---

backing-dev: use synchronize_rcu_expedited instead of synchronize_rcu

synchronize_rcu sleeps several timer ticks. synchronize_rcu_expedited is 
much faster.

With 100Hz timer frequency, when we remove 10000 block devices with 
"dmsetup remove_all" command, it takes 27 minutes. With this patch, 
removing 10000 block devices takes only 15 seconds.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.0-rc7-fast/mm/backing-dev.c
===================================================================
--- linux-3.0-rc7-fast.orig/mm/backing-dev.c	2011-07-19 18:01:00.000000000 +0200
+++ linux-3.0-rc7-fast/mm/backing-dev.c	2011-07-19 18:01:07.000000000 +0200
@@ -505,7 +505,7 @@ static void bdi_remove_from_list(struct 
 	list_del_rcu(&bdi->bdi_list);
 	spin_unlock_bh(&bdi_lock);
 
-	synchronize_rcu();
+	synchronize_rcu_expedited();
 }
 
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,

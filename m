From: Pranith Kumar <bobby.prani@gmail.com>
Subject: [PATCH] dm: sparse: Annotate field with __rcu for checking
Date: Thu, 25 Sep 2014 14:50:43 -0400
Message-ID: <1411671049-20441-1-git-send-email-bobby.prani@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Cc: paulmck@linux.vnet.ibm.com, josh@joshtriplett.org
List-Id: dm-devel.ids

Annotate the map field with __rcu since this is a rcu pointer which is checked
by sparse.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 32b958d..746411b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -140,7 +140,7 @@ struct mapped_device {
 	 * Use dm_get_live_table{_fast} or take suspend_lock for
 	 * dereference.
 	 */
-	struct dm_table *map;
+	struct dm_table __rcu *map;
 
 	unsigned long flags;
 
-- 
2.1.0

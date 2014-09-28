From: Pranith Kumar <bobby.prani@gmail.com>
Subject: [PATCH] drivers/md: Use rcu_dereference() for accessing rcu pointer
Date: Sun, 28 Sep 2014 11:01:29 -0400
Message-ID: <1411916497-17071-1-git-send-email-bobby.prani@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Cc: paulmck@vger.kernel.org
List-Id: dm-devel.ids

The map field in 'struct mapped_device' is an rcu pointer. Use rcu_dereference()
while accessing it.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 746411b..fbdf0bb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2211,7 +2211,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 
 	merge_is_optional = dm_table_merge_is_optional(t);
 
-	old_map = md->map;
+	old_map = rcu_dereference(md->map);
 	rcu_assign_pointer(md->map, t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
 
@@ -2230,7 +2230,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
  */
 static struct dm_table *__unbind(struct mapped_device *md)
 {
-	struct dm_table *map = md->map;
+	struct dm_table *map = rcu_dereference(md->map);
 
 	if (!map)
 		return NULL;
@@ -2624,7 +2624,7 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 		goto out_unlock;
 	}
 
-	map = md->map;
+	map = rcu_dereference(md->map);
 
 	/*
 	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
@@ -2718,7 +2718,7 @@ int dm_resume(struct mapped_device *md)
 	if (!dm_suspended_md(md))
 		goto out;
 
-	map = md->map;
+	map = rcu_dereference(md->map);
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
-- 
1.9.1

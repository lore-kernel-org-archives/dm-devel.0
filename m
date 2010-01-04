From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH] dm: Remove dm_get() from dm_table_get_md()
Date: Mon, 04 Jan 2010 17:28:09 +0900
Message-ID: <4B41A699.5080802@ct.jp.nec.com>
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
To: Alasdair Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair and all,

I'd like to remove dm_get() in dm_table_get_md() because
dm_table_get_md() could be called from presuspend/postsuspend,
which are called while mapped_device is in DMF_FREEING state,
where dm_get() is not allowed.
Please give me your opinion if you object this change.


Justification for that is the lifetime of both objects:
As far as the current dm design/implementation, mapped_device is
never freed while targets are doing something, because dm core waits
for targets to become quiet in dm_put() using presuspend/postsuspend.
So targets should be able to touch mapped_device without holding
reference count of the mapped_device, and we should allow targets
to touch mapped_device even if it is in DMF_FREEING state.


Backgrounds:
I'm trying to remove the multipath internal queue, since dm core
now has a generic queue for request-based dm.
In the patch-set, the multipath target wants to request dm core
to start/stop queue.  One of such start/stop requests can happen
during postsuspend() while the target waits for pg-init to complete,
because the target stops queue when starting pg-init and tries to
restart it when completing pg-init.  Since queue belongs to
mapped_device, it involves calling dm_table_get_md() and dm_put().
On the other hand, postsuspend() is called in dm_put() for mapped_device
which is in DMF_FREEING state, and that triggers BUG_ON(DMF_FREEING)
in the 2nd dm_put().

I had tried to solve this problem by changing only multipath not to
touch mapped_device which is in DMF_FREEING state, but I couldn't and
I came up with a question why we need dm_get() in dm_table_get_md().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-table.c  |    2 --
 drivers/md/dm-uevent.c |    7 ++-----
 drivers/md/dm.c        |   14 ++------------
 3 files changed, 4 insertions(+), 19 deletions(-)

Index: 2.6.33-rc2/drivers/md/dm-table.c
===================================================================
--- 2.6.33-rc2.orig/drivers/md/dm-table.c
+++ 2.6.33-rc2/drivers/md/dm-table.c
@@ -1241,8 +1241,6 @@ void dm_table_unplug_all(struct dm_table
 
 struct mapped_device *dm_table_get_md(struct dm_table *t)
 {
-	dm_get(t->md);
-
 	return t->md;
 }
 
Index: 2.6.33-rc2/drivers/md/dm-uevent.c
===================================================================
--- 2.6.33-rc2.orig/drivers/md/dm-uevent.c
+++ 2.6.33-rc2/drivers/md/dm-uevent.c
@@ -187,7 +187,7 @@ void dm_path_uevent(enum dm_uevent_type 
 
 	if (event_type >= ARRAY_SIZE(_dm_uevent_type_names)) {
 		DMERR("%s: Invalid event_type %d", __func__, event_type);
-		goto out;
+		return;
 	}
 
 	event = dm_build_path_uevent(md, ti,
@@ -195,12 +195,9 @@ void dm_path_uevent(enum dm_uevent_type 
 				     _dm_uevent_type_names[event_type].name,
 				     path, nr_valid_paths);
 	if (IS_ERR(event))
-		goto out;
+		return;
 
 	dm_uevent_add(md, &event->elist);
-
-out:
-	dm_put(md);
 }
 EXPORT_SYMBOL_GPL(dm_path_uevent);
 
Index: 2.6.33-rc2/drivers/md/dm.c
===================================================================
--- 2.6.33-rc2.orig/drivers/md/dm.c
+++ 2.6.33-rc2/drivers/md/dm.c
@@ -2686,23 +2686,13 @@ int dm_suspended_md(struct mapped_device
 
 int dm_suspended(struct dm_target *ti)
 {
-	struct mapped_device *md = dm_table_get_md(ti->table);
-	int r = dm_suspended_md(md);
-
-	dm_put(md);
-
-	return r;
+	return dm_suspended_md(dm_table_get_md(ti->table));
 }
 EXPORT_SYMBOL_GPL(dm_suspended);
 
 int dm_noflush_suspending(struct dm_target *ti)
 {
-	struct mapped_device *md = dm_table_get_md(ti->table);
-	int r = __noflush_suspending(md);
-
-	dm_put(md);
-
-	return r;
+	return __noflush_suspending(dm_table_get_md(ti->table));
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 

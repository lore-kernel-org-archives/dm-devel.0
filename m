From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] a deadlock bug in the kernel-side device mapper
	code
Date: Thu, 5 Nov 2009 21:58:26 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911052157170.18661@hs20-bc2-1.build.redhat.com>
References: <4AF2D176.4010000@actcom.co.il>
	<20091105142435.GQ13375@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091105142435.GQ13375@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 5 Nov 2009, Alasdair G Kergon wrote:

> On Thu, Nov 05, 2009 at 03:21:58PM +0200, guy keren wrote:
> > below is the stack trace of the self-deadlocking code. this is one of  
> > the threads of multipathd, that attempts to remove a dm device using a  
> > ioctl to the dm driver:
> 
> Yes, thanks for reporting this.
> 
> This only happens if there are some uevents still waiting to be sent
> when the device is being destroyed, but it does need to be fixed.
> 
> Alasdair
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Hi

This is the patch that uses two locks to avoid the deadlock.

Mikulas

---
 
Fix deadlock due to _hash_lock recursion

This patch fixes the following deadlock:
 #0 [ffff8106298dfb48] schedule at ffffffff80063035
 #1 [ffff8106298dfc20] __down_read at ffffffff8006475d
 #2 [ffff8106298dfc60] dm_copy_name_and_uuid at ffffffff8824f740
 #3 [ffff8106298dfc90] dm_send_uevents at ffffffff88252685
 #4 [ffff8106298dfcd0] event_callback at ffffffff8824c678
 #5 [ffff8106298dfd00] dm_table_event at ffffffff8824dd01
 #6 [ffff8106298dfd10] __hash_remove at ffffffff882507ad
 #7 [ffff8106298dfd30] dev_remove at ffffffff88250865
 #8 [ffff8106298dfd60] ctl_ioctl at ffffffff88250d80
 #9 [ffff8106298dfee0] do_ioctl at ffffffff800418c4
#10 [ffff8106298dff00] vfs_ioctl at ffffffff8002fab9
#11 [ffff8106298dff40] sys_ioctl at ffffffff8004bdaf
#12 [ffff8106298dff80] tracesys at ffffffff8005d28d (via system_call)

_hash_lock is taken in dev_remove and then again in dm_copy_name_and_uuid.

This patch introduces a new lock, _name_read_lock, that is placed around
regions that modify pointer to the hash with dm_set_mdptr or that modify
hc->name or hc->uuid. When this lock is taken, the caller can safely read
the name and uuid.

This lock has much smaller span than _hash_lock and thus lock recursion
can't happen.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

Index: linux-2.6.31.5-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.31.5-fast.orig/drivers/md/dm-ioctl.c	2009-10-28 19:49:13.000000000 +0100
+++ linux-2.6.31.5-fast/drivers/md/dm-ioctl.c	2009-11-06 03:46:04.000000000 +0100
@@ -56,6 +56,13 @@ static void dm_hash_remove_all(int keep_
  */
 static DECLARE_RWSEM(_hash_lock);
 
+/*
+ * Enables calling dm_get_mdptr and reading name and uuid from the hash table.
+ * This may be called from dm events when _hash_lock is held, so a separate
+ * lock is needed to avoid deadlock.
+ */
+static DEFINE_MUTEX(_name_read_lock);
+
 static void init_buckets(struct list_head *buckets)
 {
 	unsigned int i;
@@ -206,7 +213,9 @@ static int dm_hash_insert(const char *na
 		list_add(&cell->uuid_list, _uuid_buckets + hash_str(uuid));
 	}
 	dm_get(md);
+	mutex_lock(&_name_read_lock);
 	dm_set_mdptr(md, cell);
+	mutex_unlock(&_name_read_lock);
 	up_write(&_hash_lock);
 
 	return 0;
@@ -224,7 +233,9 @@ static void __hash_remove(struct hash_ce
 	/* remove from the dev hash */
 	list_del(&hc->uuid_list);
 	list_del(&hc->name_list);
+	mutex_lock(&_name_read_lock);
 	dm_set_mdptr(hc->md, NULL);
+	mutex_unlock(&_name_read_lock);
 
 	table = dm_get_table(hc->md);
 	if (table) {
@@ -321,7 +332,9 @@ static int dm_hash_rename(uint32_t cooki
 	 */
 	list_del(&hc->name_list);
 	old_name = hc->name;
+	mutex_lock(&_name_read_lock);
 	hc->name = new_name;
+	mutex_unlock(&_name_read_lock);
 	list_add(&hc->name_list, _name_buckets + hash_str(new_name));
 
 	/*
@@ -1583,7 +1596,7 @@ int dm_copy_name_and_uuid(struct mapped_
 		return -ENXIO;
 
 	dm_get(md);
-	down_read(&_hash_lock);
+	mutex_lock(&_name_read_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
 		r = -ENXIO;
@@ -1596,7 +1609,7 @@ int dm_copy_name_and_uuid(struct mapped_
 		strcpy(uuid, hc->uuid ? : "");
 
 out:
-	up_read(&_hash_lock);
+	mutex_unlock(&_name_read_lock);
 	dm_put(md);
 
 	return r;

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 3/3] dm: separate device deletion
	from	dm_put()
Date: Tue, 03 Aug 2010 16:19:38 +0900
Message-ID: <4C57C30A.20101@ct.jp.nec.com>
References: <4C0E19A0.1040804@ct.jp.nec.com> <4C0E1B08.7060201@ct.jp.nec.com>
	<20100723175901.GO19063@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100723175901.GO19063@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

Sorry for the long delay, I was on vacation.

On 07/24/2010 02:59 AM +0900, Alasdair G Kergon wrote:
> On Tue, Jun 08, 2010 at 07:27:20PM +0900, Kiyoshi Ueda wrote:
>> For the unlikely case of the forced module unload, dm_destroy_nowait(),
>> which doesn't wait and forcibly deletes the mapped_device, is also
>> introduced and used in dm_hash_remove_all().  Otherwise, "rmmod -f"
>> may be stuck and never return.
> 
>> And now, because the mapped_device is deleted at this point, subsequent
>> accesses to the mapped_device may cause NULL pointer references.
> 
> Do we get a warning message logged when this situation occurs
> and md->holders is still set or should we add one?
> 
>> +	if (wait) {
>> +		while (atomic_read(&md->holders))
>> +			msleep(1);

OK, since there was no warning message, I added one as below:
	if (wait) {
		while (atomic_read(&md->holders))
			msleep(1);
	} else if (atomic_read(&md->holders))
		DMWARN("%s: Deleting mapped_device still in use! (%d users)",
		       dm_device_name(md), atomic_read(&md->holders));

Here is the refreshed patch which can be applied on your editing tree.
Please review and apply.

Thanks,
Kiyoshi Ueda


Subject: [PATCH 3/3] dm: separate device deletion from dm_put()

This patch separates the device deletion code from dm_put()
to make sure the deletion happens in the process context.

By this patch, device deletion always occurs in an ioctl (process)
context and dm_put() can be called in interrupt context.
As a result, the request-based dm's bad dm_put() usage pointed out
by Mikulas below disappears.
    http://marc.info/?l=dm-devel&m=126699981019735&w=2

Without this patch, I confirmed there is a case to crash the system:
    dm_put() => dm_table_destroy() => vfree() => BUG_ON(in_interrupt())


Some more backgrounds and details:
In request-based dm, a device opener can remove a mapped_device
while the last request is still completing, because bios in the last
request complete first and then the device opener can close and remove
the mapped_device before the last request completes:
  CPU0                                          CPU1
  =================================================================
  <<INTERRUPT>>
  blk_end_request_all(clone_rq)
    blk_update_request(clone_rq)
      bio_endio(clone_bio) == end_clone_bio
        blk_update_request(orig_rq)
          bio_endio(orig_bio)
                                                <<I/O completed>>
                                                dm_blk_close()
                                                dev_remove()
                                                  dm_put(md)
                                                    <<Free md>>
   blk_finish_request(clone_rq)
     ....
     dm_end_request(clone_rq)
       free_rq_clone(clone_rq)
       blk_end_request_all(orig_rq)
       rq_completed(md)

So request-based dm used dm_get()/dm_put() to hold md for each I/O
until its request completion handling is fully done.
However, the final dm_put() can call the device deletion code which
must not be run in interrupt context and may cause kernel panic.

To solve the problem, this patch moves the device deletion code,
dm_destroy(), to predetermined places that is actually deleting
the mapped_device in ioctl (process) context, and changes dm_put()
just to decrement the reference count of the mapped_device.
By this change, dm_put() can be used in any context and the symmetric
model below is introduced:
    dm_create():  create a mapped_device
    dm_destroy(): destroy a mapped_device
    dm_get():     increment the reference count of a mapped_device
    dm_put():     decrement the reference count of a mapped_device

dm_destroy() waits for all references of the mapped_device to disappear,
then deletes the mapped_device.

dm_destroy() uses active waiting with msleep(1), since deleting
the mapped_device isn't performance-critical task.
And since at this point, nobody opens the mapped_device and no new
reference will be taken, the pending counts are just for racing
completing activity and will eventually decrease to zero.

For the unlikely case of the forced module unload, dm_destroy_nowait(),
which doesn't wait and forcibly deletes the mapped_device, is also
introduced and used in dm_hash_remove_all().  Otherwise, "rmmod -f"
may be stuck and never return.
And now, because the mapped_device is deleted at this point, subsequent
accesses to the mapped_device may cause NULL pointer references.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c |   15 +++++++++---
 drivers/md/dm.c       |   61 ++++++++++++++++++++++++++++++++++++--------------
 drivers/md/dm.h       |    5 ++++
 3 files changed, 61 insertions(+), 20 deletions(-)

Index: 2.6.35/drivers/md/dm-ioctl.c
===================================================================
--- 2.6.35.orig/drivers/md/dm-ioctl.c
+++ 2.6.35/drivers/md/dm-ioctl.c
@@ -270,6 +270,10 @@ retry:
 			up_write(&_hash_lock);
 
 			dm_put(md);
+			if (likely(keep_open_devices))
+				dm_destroy(md);
+			else
+				dm_destroy_nowait(md);
 
 			/*
 			 * Some mapped devices may be using other mapped
@@ -640,17 +644,19 @@ static int dev_create(struct dm_ioctl *p
 		return r;
 
 	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
-	if (r)
-		goto out;
+	if (r) {
+		dm_put(md);
+		dm_destroy(md);
+		return r;
+	}
 
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
 	__dev_status(md, param);
 
-out:
 	dm_put(md);
 
-	return r;
+	return 0;
 }
 
 /*
@@ -744,6 +750,7 @@ static int dev_remove(struct dm_ioctl *p
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	dm_put(md);
+	dm_destroy(md);
 	return 0;
 }
 
Index: 2.6.35/drivers/md/dm.c
===================================================================
--- 2.6.35.orig/drivers/md/dm.c
+++ 2.6.35/drivers/md/dm.c
@@ -2176,6 +2176,7 @@ void dm_set_mdptr(struct mapped_device *
 void dm_get(struct mapped_device *md)
 {
 	atomic_inc(&md->holders);
+	BUG_ON(test_bit(DMF_FREEING, &md->flags));
 }
 
 const char *dm_device_name(struct mapped_device *md)
@@ -2184,27 +2185,55 @@ const char *dm_device_name(struct mapped
 }
 EXPORT_SYMBOL_GPL(dm_device_name);
 
-void dm_put(struct mapped_device *md)
+static void __dm_destroy(struct mapped_device *md, bool wait)
 {
 	struct dm_table *map;
 
-	BUG_ON(test_bit(DMF_FREEING, &md->flags));
+	might_sleep();
 
-	if (atomic_dec_and_lock(&md->holders, &_minor_lock)) {
-		map = dm_get_live_table(md);
-		idr_replace(&_minor_idr, MINOR_ALLOCED,
-			    MINOR(disk_devt(dm_disk(md))));
-		set_bit(DMF_FREEING, &md->flags);
-		spin_unlock(&_minor_lock);
-		if (!dm_suspended_md(md)) {
-			dm_table_presuspend_targets(map);
-			dm_table_postsuspend_targets(map);
-		}
-		dm_sysfs_exit(md);
-		dm_table_put(map);
-		dm_table_destroy(__unbind(md));
-		free_dev(md);
+	spin_lock(&_minor_lock);
+	map = dm_get_live_table(md);
+	idr_replace(&_minor_idr, MINOR_ALLOCED, MINOR(disk_devt(dm_disk(md))));
+	set_bit(DMF_FREEING, &md->flags);
+	spin_unlock(&_minor_lock);
+
+	if (!dm_suspended_md(md)) {
+		dm_table_presuspend_targets(map);
+		dm_table_postsuspend_targets(map);
 	}
+
+	/*
+	 * Rare but there may be I/O requests still going to complete,
+	 * for example.  Wait for all references to disappear.
+	 * No one shouldn't increment the reference count of the mapped_device,
+	 * after the mapped_device becomes DMF_FREEING state.
+	 */
+	if (wait) {
+		while (atomic_read(&md->holders))
+			msleep(1);
+	} else if (atomic_read(&md->holders))
+		DMWARN("%s: Deleting mapped_device still in use! (%d users)",
+		       dm_device_name(md), atomic_read(&md->holders));
+
+	dm_sysfs_exit(md);
+	dm_table_put(map);
+	dm_table_destroy(__unbind(md));
+	free_dev(md);
+}
+
+void dm_destroy(struct mapped_device *md)
+{
+	__dm_destroy(md, true);
+}
+
+void dm_destroy_nowait(struct mapped_device *md)
+{
+	__dm_destroy(md, false);
+}
+
+void dm_put(struct mapped_device *md)
+{
+	atomic_dec(&md->holders);
 }
 EXPORT_SYMBOL_GPL(dm_put);
 
Index: 2.6.35/drivers/md/dm.h
===================================================================
--- 2.6.35.orig/drivers/md/dm.h
+++ 2.6.35/drivers/md/dm.h
@@ -122,6 +122,11 @@ void dm_linear_exit(void);
 int dm_stripe_init(void);
 void dm_stripe_exit(void);
 
+/*
+ * mapped_device operations
+ */
+void dm_destroy(struct mapped_device *md);
+void dm_destroy_nowait(struct mapped_device *md);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 

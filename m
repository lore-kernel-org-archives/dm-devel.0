From: Dmitry Kushak <Dmitry.Kushak@citrix.com>
Subject: Re: dm-devel Digest, Vol 75, Issue 12
Date: Sun, 16 May 2010 10:21:51 +1000
Message-ID: <EBA89672E22ABB44A7601070DA0A2359F9B7E62172@SYDPMAILBOX01.citrite.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Uk

----- Original Message -----
From: dm-devel-bounces@redhat.com <dm-devel-bounces@redhat.com>
To: dm-devel@redhat.com <dm-devel@redhat.com>
Sent: Sun May 16 02:00:12 2010
Subject: dm-devel Digest, Vol 75, Issue 12

Send dm-devel mailing list submissions to
        dm-devel@redhat.com

To subscribe or unsubscribe via the World Wide Web, visit
        https://www.redhat.com/mailman/listinfo/dm-devel
or, via email, send a message with subject or body 'help' to
        dm-devel-request@redhat.com

You can reach the person managing the list at
        dm-devel-owner@redhat.com

When replying, please edit your Subject line so it is more specific
than "Re: Contents of dm-devel digest..."


Today's Topics:

   1. [PATCH v3] dm: only initialize full request_queue for
      request-based device (Mike Snitzer)
   2. [PATCH 9/10] drivers/md: Use kstrdup (Julia Lawall)
   3. [RFC PATCH v2 1/2] dm: allow a dm-fs-style device to be
      shared via dm-ioctl (Will Drewry)
   4. [RFC PATCH v2 2/2] init: boot to device-mapper targets
      without an initr* (Will Drewry)


----------------------------------------------------------------------

Message: 1
Date: Fri, 14 May 2010 14:29:41 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Nikanth Karthikesan
        <knikanth@suse.de>,     Alasdair Kergon <agk@redhat.com>, Jens Axboe
        <jens.axboe@oracle.com>,        Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [dm-devel] [PATCH v3] dm: only initialize full request_queue
        for     request-based device
Message-ID: <1273861781-3280-1-git-send-email-snitzer@redhat.com>

Allocate a minimalist request_queue structure initially (needed for both
bio and request-based DM).  A bio-based DM device no longer defaults to
having a fully initialized request_queue (request_fn, elevator, etc).
So bio-based DM devices no longer register elevator sysfs attributes
('iosched/' tree or 'scheduler' other than "none").

Initialization of a full request_queue (request_fn, elevator, etc) is
deferred until it is known that the DM device is request-based -- at the
end of the table load sequence.

Factor DM device's request_queue initialization:
- common to both request-based and bio-based into dm_init_md_queue().
- specific to request-based into dm_init_request_based_queue().

Adjust elv_iosched_show() to return "none" if !blk_queue_stackable.
This allows the block layer to take bio-based DM into consideration.

NOTE: It is still possible, albeit unlikely, for a bio-based device to
have a full request_queue.  But in this case the unused elevator will
not be registered with sysfs.  A table switch from request-based to
bio-based would be required, e.g.:

   # dmsetup create --notable bio-based
   # echo "0 100 multipath ..." | dmsetup load bio-based
   # echo "0 100 linear ..."    | dmsetup load bio-based
   # dmsetup resume bio-based

Future work, in conjunction with userspace changes, could allow DM to
fix this by knowing which type of request_queue to initialize a priori
(instead of waiting until the end of the table load sequence).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/elevator.c      |    2 +-
 drivers/md/dm-table.c |    6 +++
 drivers/md/dm.c       |  101 +++++++++++++++++++++++++++++++++++++------------
 drivers/md/dm.h       |    3 +
 4 files changed, 86 insertions(+), 26 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 76e3702..e986e4c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1086,7 +1086,7 @@ ssize_t elv_iosched_show(struct request_queue *q, char *name)
        struct elevator_type *__e;
        int len = 0;

-       if (!q->elevator)
+       if (!q->elevator || !blk_queue_stackable(q))
                return sprintf(name, "none\n");

        elv = e->elevator_type;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9924ea2..dec8295 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -803,6 +803,7 @@ int dm_table_set_type(struct dm_table *t)
        if (bio_based) {
                /* We must use this table as bio-based */
                t->type = DM_TYPE_BIO_BASED;
+               dm_clear_request_based_queue(t->md);
                return 0;
        }

@@ -829,6 +830,11 @@ int dm_table_set_type(struct dm_table *t)
                return -EINVAL;
        }

+       if (!dm_init_request_based_queue(t->md)) {
+               DMWARN("Cannot initialize queue for Request-based dm");
+               return -EINVAL;
+       }
+
        t->type = DM_TYPE_REQUEST_BASED;

        return 0;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d21e128..143082c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1445,6 +1445,11 @@ static int dm_request_based(struct mapped_device *md)
        return blk_queue_stackable(md->queue);
 }

+static int dm_bio_based_md(struct mapped_device *md)
+{
+       return (md->queue->request_fn) ? 0 : 1;
+}
+
 static int dm_request(struct request_queue *q, struct bio *bio)
 {
        struct mapped_device *md = q->queuedata;
@@ -1849,6 +1854,17 @@ static const struct block_device_operations dm_blk_dops;
 static void dm_wq_work(struct work_struct *work);
 static void dm_rq_barrier_work(struct work_struct *work);

+static void dm_init_md_queue(struct mapped_device *md)
+{
+       md->queue->queuedata = md;
+       md->queue->backing_dev_info.congested_fn = dm_any_congested;
+       md->queue->backing_dev_info.congested_data = md;
+       blk_queue_make_request(md->queue, dm_request);
+       blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
+       md->queue->unplug_fn = dm_unplug_all;
+       blk_queue_merge_bvec(md->queue, dm_merge_bvec);
+}
+
 /*
  * Allocate and initialise a blank device with a given minor.
  */
@@ -1886,34 +1902,11 @@ static struct mapped_device *alloc_dev(int minor)
        INIT_LIST_HEAD(&md->uevent_list);
        spin_lock_init(&md->uevent_lock);

-       md->queue = blk_init_queue(dm_request_fn, NULL);
+       md->queue = blk_alloc_queue(GFP_KERNEL);
        if (!md->queue)
                goto bad_queue;

-       /*
-        * Request-based dm devices cannot be stacked on top of bio-based dm
-        * devices.  The type of this dm device has not been decided yet,
-        * although we initialized the queue using blk_init_queue().
-        * The type is decided at the first table loading time.
-        * To prevent problematic device stacking, clear the queue flag
-        * for request stacking support until then.
-        *
-        * This queue is new, so no concurrency on the queue_flags.
-        */
-       queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
-       md->saved_make_request_fn = md->queue->make_request_fn;
-       md->queue->queuedata = md;
-       md->queue->backing_dev_info.congested_fn = dm_any_congested;
-       md->queue->backing_dev_info.congested_data = md;
-       blk_queue_make_request(md->queue, dm_request);
-       blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
-       md->queue->unplug_fn = dm_unplug_all;
-       blk_queue_merge_bvec(md->queue, dm_merge_bvec);
-       blk_queue_softirq_done(md->queue, dm_softirq_done);
-       blk_queue_prep_rq(md->queue, dm_prep_fn);
-       blk_queue_lld_busy(md->queue, dm_lld_busy);
-       blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
-                         dm_rq_prepare_flush);
+       dm_init_md_queue(md);

        md->disk = alloc_disk(1);
        if (!md->disk)
@@ -1968,6 +1961,64 @@ bad_module_get:
        return NULL;
 }

+/*
+ * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
+ */
+int dm_init_request_based_queue(struct mapped_device *md)
+{
+       struct request_queue *q = NULL;
+
+       /* Avoid re-initializing the queue if already fully initialized */
+       if (!md->queue->elevator) {
+               /* Fully initialize the queue */
+               q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
+               if (!q)
+                       return 0;
+               md->queue = q;
+               md->saved_make_request_fn = md->queue->make_request_fn;
+               dm_init_md_queue(md);
+       } else if (dm_bio_based_md(md)) {
+               /*
+                * Queue was fully initialized on behalf of a previous
+                * request-based table load.  Table is now switching from
+                * bio-based back to request-based, e.g.: rq -> bio -> rq
+                */
+               md->queue->request_fn = dm_request_fn;
+       } else
+               return 1; /* already request-based */
+
+       elv_register_queue(md->queue);
+
+       /*
+        * Request-based dm devices cannot be stacked on top of bio-based dm
+        * devices.  The type of this dm device has not been decided yet.
+        * The type is decided at the first table loading time.
+        * To prevent problematic device stacking, clear the queue flag
+        * for request stacking support until then.
+        *
+        * This queue is new, so no concurrency on the queue_flags.
+        */
+       queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
+
+       blk_queue_softirq_done(md->queue, dm_softirq_done);
+       blk_queue_prep_rq(md->queue, dm_prep_fn);
+       blk_queue_lld_busy(md->queue, dm_lld_busy);
+       blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
+                         dm_rq_prepare_flush);
+
+       return 1;
+}
+
+void dm_clear_request_based_queue(struct mapped_device *md)
+{
+       if (dm_bio_based_md(md))
+               return; /* already bio-based */
+
+       /* Unregister elevator from sysfs and clear ->request_fn */
+       elv_unregister_queue(md->queue);
+       md->queue->request_fn = NULL;
+}
+
 static void unlock_fs(struct mapped_device *md);

 static void free_dev(struct mapped_device *md)
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index bad1724..95aec64 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -113,6 +113,9 @@ void dm_sysfs_exit(struct mapped_device *md);
 struct kobject *dm_kobject(struct mapped_device *md);
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);

+int dm_init_request_based_queue(struct mapped_device *md);
+void dm_clear_request_based_queue(struct mapped_device *md);
+
 /*
  * Targets for linear and striped mappings
  */



------------------------------

Message: 2
Date: Fri, 14 May 2010 21:31:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Neil Brown <neilb@suse.de>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [dm-devel] [PATCH 9/10] drivers/md: Use kstrdup
Message-ID: <Pine.LNX.4.64.1005142130490.28935@ask.diku.dk>
Content-Type: TEXT/PLAIN; charset=US-ASCII

From: Julia Lawall <julia@diku.dk>

Use kstrdup when the goal of an allocation is copy a string into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to;
expression flag,E1,E2;
statement S;
@@

-  to = kmalloc(strlen(from) + 1,flag);
+  to = kstrdup(from, flag);
   ... when != \(from = E1 \| to = E1 \)
   if (to==NULL || ...) S
   ... when != \(from = E2 \| to = E2 \)
-  strcpy(to, from);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/md/dm-crypt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1168,12 +1168,11 @@ static int crypt_ctr(struct dm_target *t
        if (ivmode && cc->iv_gen_ops) {
                if (ivopts)
                        *(ivopts - 1) = ':';
-               cc->iv_mode = kmalloc(strlen(ivmode) + 1, GFP_KERNEL);
+               cc->iv_mode = kstrdup(ivmode, GFP_KERNEL);
                if (!cc->iv_mode) {
                        ti->error = "Error kmallocing iv_mode string";
                        goto bad_ivmode_string;
                }
-               strcpy(cc->iv_mode, ivmode);
        } else
                cc->iv_mode = NULL;




------------------------------

Message: 3
Date: Fri, 14 May 2010 20:41:40 -0500
From: Will Drewry <wad@chromium.org>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, snitzer@redhat.com, agk@redhat.com
Subject: [dm-devel] [RFC PATCH v2 1/2] dm: allow a dm-fs-style device
        to be   shared via dm-ioctl
Message-ID: <1273887701-2152-1-git-send-email-wad@chromium.org>

This change adds one function which is used for binding
a given mapped device to a name+uuid in the dm-ioctl hash table.
In addition, it ensures that public functions are available that
allow mapped devices and tables to be created and associated
with the shared code paths with dm-ioctl:
- suspend flags are available
- dm_table_complete() now prepares a table for use completely

Signed-off-by: Will Drewry <wad@chromium.org>
---
 drivers/md/dm-ioctl.c         |   72 +++++++++++++++++++++-------------------
 drivers/md/dm-table.c         |   50 ++++++++++++++++++++++++++++-
 drivers/md/dm.h               |    6 ---
 include/linux/device-mapper.h |   12 +++++++
 4 files changed, 99 insertions(+), 41 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..006be9d 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1112,28 +1112,9 @@ static int populate_table(struct dm_table *table,
                next = spec->next;
        }

-       r = dm_table_set_type(table);
-       if (r) {
-               DMWARN("unable to set table type");
-               return r;
-       }
-
        return dm_table_complete(table);
 }

-static int table_prealloc_integrity(struct dm_table *t,
-                                   struct mapped_device *md)
-{
-       struct list_head *devices = dm_table_get_devices(t);
-       struct dm_dev_internal *dd;
-
-       list_for_each_entry(dd, devices, list)
-               if (bdev_get_integrity(dd->dm_dev.bdev))
-                       return blk_integrity_register(dm_disk(md), NULL);
-
-       return 0;
-}
-
 static int table_load(struct dm_ioctl *param, size_t param_size)
 {
        int r;
@@ -1155,21 +1136,6 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
                goto out;
        }

-       r = table_prealloc_integrity(t, md);
-       if (r) {
-               DMERR("%s: could not register integrity profile.",
-                     dm_device_name(md));
-               dm_table_destroy(t);
-               goto out;
-       }
-
-       r = dm_table_alloc_md_mempools(t);
-       if (r) {
-               DMWARN("unable to allocate mempools for this table");
-               dm_table_destroy(t);
-               goto out;
-       }
-
        down_write(&_hash_lock);
        hc = dm_get_mdptr(md);
        if (!hc || hc->md != md) {
@@ -1637,6 +1603,44 @@ void dm_interface_exit(void)
        dm_hash_exit();
 }

+
+/**
+ * dm_ioctl_export - Permanently export a mapped device via the ioctl interface
+ * @md: Pointer to mapped_device
+ * @name: Buffer (size DM_NAME_LEN) for name
+ * @uuid: Buffer (size DM_UUID_LEN) for uuid or NULL if not desired
+ */
+int dm_ioctl_export(struct mapped_device *md, const char *name, const char *uuid)
+{
+       int r = 0;
+       struct hash_cell *hc;
+
+       if (!md) {
+               r = -ENXIO;
+               goto out;
+       }
+
+       /* The name and uuid can only be set once. */
+       mutex_lock(&dm_hash_cells_mutex);
+       hc = dm_get_mdptr(md);
+       mutex_unlock(&dm_hash_cells_mutex);
+       if (hc) {
+               DMERR("%s: already exported", dm_device_name(md));
+               r = -ENXIO;
+               goto out;
+       }
+
+       r = dm_hash_insert(name, uuid, md);
+       if (r) {
+               DMERR("%s: could not bind to '%s'", dm_device_name(md), name);
+               goto out;
+       }
+
+       /* Let udev know we've changed. */
+       dm_kobject_uevent(md, KOBJ_CHANGE, dm_get_event_nr(md));
+out:
+       return r;
+}
 /**
  * dm_copy_name_and_uuid - Copy mapped device name & uuid into supplied buffers
  * @md: Pointer to mapped_device
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9924ea2..ef6a3ab 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -900,7 +900,7 @@ static int setup_indexes(struct dm_table *t)
 /*
  * Builds the btree to index the map.
  */
-int dm_table_complete(struct dm_table *t)
+int dm_table_build_index(struct dm_table *t)
 {
        int r = 0;
        unsigned int leaf_nodes;
@@ -919,6 +919,54 @@ int dm_table_complete(struct dm_table *t)
        return r;
 }

+/*
+ * Register the mapped device for blk_integrity support if
+ * the underlying devices support it.
+ */
+static int dm_table_prealloc_integrity(struct dm_table *t, struct mapped_device *md)
+{
+       struct list_head *devices = dm_table_get_devices(t);
+       struct dm_dev_internal *dd;
+
+       list_for_each_entry(dd, devices, list)
+               if (bdev_get_integrity(dd->dm_dev.bdev))
+                       return blk_integrity_register(dm_disk(md), NULL);
+
+       return 0;
+}
+
+/*
+ * Prepares the table for use by building the indices,
+ * setting the type, and allocating mempools.
+ */
+int dm_table_complete(struct dm_table *t)
+{
+       int r = 0;
+       r = dm_table_set_type(t);
+       if (r) {
+               DMERR("unable to set table type");
+               return r;
+       }
+
+       r = dm_table_build_index(t);
+       if (r) {
+               DMERR("unable to build btrees");
+               return r;
+       }
+
+       r = dm_table_prealloc_integrity(t, t->md);
+       if (r) {
+               DMERR("could not register integrity profile.");
+               return r;
+       }
+
+       r = dm_table_alloc_md_mempools(t);
+       if (r) {
+               DMERR("unable to allocate mempools");
+       }
+       return r;
+}
+
 static DEFINE_MUTEX(_event_lock);
 void dm_table_event_callback(struct dm_table *t,
                             void (*fn)(void *), void *context)
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index bad1724..782d867 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -17,12 +17,6 @@
 #include <linux/hdreg.h>

 /*
- * Suspend feature flags
- */
-#define DM_SUSPEND_LOCKFS_FLAG         (1 << 0)
-#define DM_SUSPEND_NOFLUSH_FLAG                (1 << 1)
-
-/*
  * Type of table and mapped_device's mempool
  */
 #define DM_TYPE_NONE           0
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1381cd9..6c1c230 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -215,6 +215,18 @@ void dm_set_mdptr(struct mapped_device *md, void *ptr);
 void *dm_get_mdptr(struct mapped_device *md);

 /*
+ * Export the device via the ioctl interface (uses mdptr).
+ */
+int dm_ioctl_export(struct mapped_device *md, const char *name,
+                   const char *uuid);
+
+/*
+ * Suspend feature flags
+ */
+#define DM_SUSPEND_LOCKFS_FLAG         (1 << 0)
+#define DM_SUSPEND_NOFLUSH_FLAG                (1 << 1)
+
+/*
  * A device can still be used while suspended, but I/O is deferred.
  */
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
--
1.7.0.4



------------------------------

Message: 4
Date: Fri, 14 May 2010 20:41:41 -0500
From: Will Drewry <wad@chromium.org>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, snitzer@redhat.com, agk@redhat.com
Subject: [dm-devel] [RFC PATCH v2 2/2] init: boot to device-mapper
        targets without an initr*
Message-ID: <1273887701-2152-2-git-send-email-wad@chromium.org>

Add a dm= kernel parameter modeled after the md= parameter from
do_mounts_md.  It allows for device-mapper targets to be configured at
boot time for use early in the boot process (as the root device or
otherwise).

The format is dm="name uuid ro,table line 1,table line 2,...".  The
parser expects the comma to be safe to use as a newline substitute but,
otherwise, uses the normal separator of space.  Some attempt has been
made to make it forgiving of additional spaces (using skip_spaces()).

A mapped device created during boot will be assigned a minor of 0 and
may be access via /dev/dm-0.

An example dm-linear root with no uuid may look like:

  root=/dev/dm-0  dm="lroot none 0, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0"

Once udev is started, /dev/dm-0 will become /dev/mapper/lroot.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 init/Makefile       |    1 +
 init/do_mounts.c    |    1 +
 init/do_mounts.h    |   10 ++
 init/do_mounts_dm.c |  353 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 365 insertions(+), 0 deletions(-)
 create mode 100644 init/do_mounts_dm.c

diff --git a/init/Makefile b/init/Makefile
index 0bf677a..1677baa 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -14,6 +14,7 @@ mounts-y                      := do_mounts.o
 mounts-$(CONFIG_BLK_DEV_RAM)   += do_mounts_rd.o
 mounts-$(CONFIG_BLK_DEV_INITRD)        += do_mounts_initrd.o
 mounts-$(CONFIG_BLK_DEV_MD)    += do_mounts_md.o
+mounts-$(CONFIG_BLK_DEV_DM)    += do_mounts_dm.o

 # dependencies on generated files need to be listed explicitly
 $(obj)/version.o: include/generated/compile.h
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 02e3ca4..0848a5b 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -383,6 +383,7 @@ void __init prepare_namespace(void)
        wait_for_device_probe();

        md_run_setup();
+       dm_run_setup();

        if (saved_root_name[0]) {
                root_device_name = saved_root_name;
diff --git a/init/do_mounts.h b/init/do_mounts.h
index f5b978a..09d2286 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -74,3 +74,13 @@ void md_run_setup(void);
 static inline void md_run_setup(void) {}

 #endif
+
+#ifdef CONFIG_BLK_DEV_DM
+
+void dm_run_setup(void);
+
+#else
+
+static inline void dm_run_setup(void) {}
+
+#endif
diff --git a/init/do_mounts_dm.c b/init/do_mounts_dm.c
new file mode 100644
index 0000000..7b188e2
--- /dev/null
+++ b/init/do_mounts_dm.c
@@ -0,0 +1,353 @@
+/* do_mounts_dm.c
+ * Copyright (C) 2010 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *                    All Rights Reserved.
+ * Based on do_mounts_md.c
+ *
+ * This file is released under the GPL.
+ */
+#include <linux/device-mapper.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+
+#include "do_mounts.h"
+
+#define DM_MAX_NAME 32
+#define DM_MAX_UUID 129
+#define DM_NO_UUID "none"
+
+#define DM_MSG_PREFIX "init"
+
+/* Separators used for parsing the dm= argument. */
+#define DM_FIELD_SEP ' '
+#define DM_LINE_SEP ','
+
+/*
+ * When the device-mapper and any targets are compiled into the kernel
+ * (not a module), one target may be created and used as the root device at
+ * boot time with the parameters given with the boot line dm=...
+ * The code for that is here.
+ */
+
+struct dm_setup_target {
+       sector_t begin;
+       sector_t length;
+       char *type;
+       char *params;
+       /* simple singly linked list */
+       struct dm_setup_target *next;
+};
+
+static struct {
+       int minor;
+       int ro;
+       char name[DM_MAX_NAME];
+       char uuid[DM_MAX_UUID];
+       char *targets;
+       struct dm_setup_target *target;
+       int target_count;
+} dm_setup_args __initdata;
+
+static __initdata int dm_early_setup = 0;
+
+static size_t __init get_dm_option(char *str, char **next, char sep)
+{
+       size_t len = 0;
+       char *endp = NULL;
+
+       if (!str)
+               return 0;
+
+       endp = strchr(str, sep);
+       if (!endp) {  /* act like strchrnul */
+               len = strlen(str);
+               endp = str + len;
+       } else {
+               len = endp - str;
+       }
+
+       if (endp == str)
+               return 0;
+
+       if (!next)
+               return len;
+
+       if (*endp == 0) {
+               /* Don't advance past the nul. */
+               *next = endp;
+       } else {
+               *next = endp + 1;
+       }
+       return len;
+}
+
+static int __init dm_setup_args_init(void)
+{
+       dm_setup_args.minor = 0;
+       dm_setup_args.ro = 0;
+       dm_setup_args.target = NULL;
+       dm_setup_args.target_count = 0;
+       return 0;
+}
+
+static int __init dm_setup_cleanup(void)
+{
+       struct dm_setup_target *target = dm_setup_args.target;
+       struct dm_setup_target *old_target = NULL;
+       while (target) {
+               if (target->type)
+                       kfree(target->type);
+               if (target->params)
+                       kfree(target->params);
+               old_target = target;
+               target = target->next;
+               kfree(old_target);
+               dm_setup_args.target_count--;
+       }
+       BUG_ON(dm_setup_args.target_count);
+       return 0;
+}
+
+static char * __init dm_setup_parse_device_args(char *str)
+{
+       char *next = NULL;
+       size_t len = 0;
+
+       /* Grab the logical name of the device to be exported to udev */
+       len = get_dm_option(str, &next, DM_FIELD_SEP);
+       if (!len) {
+               DMERR("failed to parse device name");
+               goto parse_fail;
+       }
+       len = min(len + 1, sizeof(dm_setup_args.name));
+       strlcpy(dm_setup_args.name, str, len + 1);  /* includes nul */
+       str = skip_spaces(next);
+
+       /* Grab the UUID value or "none" */
+       len = get_dm_option(str, &next, DM_FIELD_SEP);
+       if (!len) {
+               DMERR("failed to parse device uuid");
+               goto parse_fail;
+       }
+       len = min(len + 1, sizeof(dm_setup_args.uuid));
+       strlcpy(dm_setup_args.uuid, str, len);
+       str = skip_spaces(next);
+
+       /* If ro is non-zero, the table will be create FMODE_READ. */
+       if (*str++ != '0')
+               dm_setup_args.ro = 1;
+       if (*str++ != ',') {
+               DMERR("failed to parse table mode");
+               goto parse_fail;
+       }
+       str = skip_spaces(str);
+
+       return str;
+
+parse_fail:
+       return NULL;
+}
+
+static int __init dm_setup_parse_targets(char *str)
+{
+       char *next = NULL;
+       size_t len = 0;
+       struct dm_setup_target **target = NULL;
+
+       /* Targets are defined as per the table format but with a
+        * comma as a newline separator. */
+       target = &dm_setup_args.target;
+       while (str && *str) {
+               *target = kzalloc(sizeof(struct dm_setup_target), GFP_KERNEL);
+               if (!*target) {
+                       DMERR("failed to allocate memory for target %d",
+                             dm_setup_args.target_count);
+                       goto parse_fail;
+               }
+               dm_setup_args.target_count++;
+
+               (*target)->begin = simple_strtoull(str, &next, 10);
+               if (!next || *next != DM_FIELD_SEP) {
+                       DMERR("failed to parse starting sector for target %d",
+                             dm_setup_args.target_count - 1);
+                       goto parse_fail;
+               }
+               str = skip_spaces(next + 1);
+
+               (*target)->length = simple_strtoull(str, &next, 10);
+               if (!next || *next != DM_FIELD_SEP) {
+                       DMERR("failed to parse length for target %d",
+                             dm_setup_args.target_count - 1);
+                       goto parse_fail;
+               }
+               str = skip_spaces(next + 1);
+
+               len = get_dm_option(str, &next, DM_FIELD_SEP);
+               if (!len ||
+                   !((*target)->type = kstrndup(str, len, GFP_KERNEL))) {
+                       DMERR("failed to parse type for target %d",
+                             dm_setup_args.target_count - 1);
+                       goto parse_fail;
+               }
+               str = skip_spaces(next);
+
+               len = get_dm_option(str, &next, DM_LINE_SEP);
+               if (!len ||
+                   !((*target)->params = kstrndup(str, len, GFP_KERNEL))) {
+                       DMERR("failed to parse params for target %d",
+                             dm_setup_args.target_count - 1);
+                       goto parse_fail;
+               }
+               str = skip_spaces(next);
+
+               target = &((*target)->next);
+       }
+       DMDEBUG("parsed %d targets", dm_setup_args.target_count);
+
+       return 0;
+
+parse_fail:
+       return 1;
+}
+
+/*
+ * Parse the command-line parameters given our kernel, but do not
+ * actually try to invoke the DM device now; that is handled by
+ * dm_setup_drive after the low-level disk drivers have initialised.
+ * dm format is as follows:
+ *  dm="name uuid fmode,[table line 1],[table line 2],..."
+ * May be used with root=/dev/dm-0 as it always uses the first dm minor.
+ */
+
+static int __init dm_setup(char *str)
+{
+       dm_setup_args_init();
+
+       str = dm_setup_parse_device_args(str);
+       if (!str) {
+               DMDEBUG("str is NULL");
+               goto parse_fail;
+       }
+
+       /* Target parsing is delayed until we have dynamic memory */
+       dm_setup_args.targets = str;
+
+       printk(KERN_INFO "dm: will configure '%s' on dm-%d\n",
+              dm_setup_args.name, dm_setup_args.minor);
+
+       dm_early_setup = 1;
+       return 1;
+
+parse_fail:
+       printk(KERN_WARNING "dm: Invalid arguments supplied to dm=.\n");
+       return 0;
+}
+
+
+static void __init dm_setup_drive(void)
+{
+       struct mapped_device *md = NULL;
+       struct dm_table *table = NULL;
+       struct dm_setup_target *target;
+       char *uuid = dm_setup_args.uuid;
+       fmode_t fmode = FMODE_READ;
+
+       /* Finish parsing the targets. */
+       if (dm_setup_parse_targets(dm_setup_args.targets)) {
+               goto parse_fail;
+       }
+
+       if (dm_create(dm_setup_args.minor, &md)) {
+               DMDEBUG("failed to create the device");
+               goto dm_create_fail;
+       }
+       DMDEBUG("created device '%s'", dm_device_name(md));
+
+       /* In addition to flagging the table below, the disk must be
+        * set explicitly ro/rw. */
+       if (dm_setup_args.ro) {
+               set_disk_ro(dm_disk(md), 1);
+       } else {
+               set_disk_ro(dm_disk(md), 0);
+       }
+
+       fmode |= (dm_setup_args.ro ? 0 : FMODE_WRITE);
+       if (dm_table_create(&table, fmode, dm_setup_args.target_count, md)) {
+               DMDEBUG("failed to create the table");
+               goto dm_table_create_fail;
+       }
+
+       target = dm_setup_args.target;
+       while (target) {
+               DMINFO("adding target '%llu %llu %s %s'",
+                      (unsigned long long) target->begin,
+                      (unsigned long long) target->length, target->type,
+                      target->params);
+               if (dm_table_add_target(table, target->type, target->begin,
+                                       target->length, target->params)) {
+                       DMDEBUG("failed to add the target to the table");
+                       goto add_target_fail;
+               }
+               target = target->next;
+       }
+
+       if (dm_table_complete(table)) {
+               DMDEBUG("failed to complete the table");
+               goto table_complete_fail;
+       }
+
+       /* Suspend the device so that we can bind it to the table. */
+       if (dm_suspend(md, DM_SUSPEND_NOFLUSH_FLAG)) {
+               DMDEBUG("failed to suspend the device pre-bind");
+               goto suspend_fail;
+       }
+
+       /* Bind the table to the device. This is the only way to associate
+        * md->map with the table and set the disk capacity directly. */
+       if (dm_swap_table(md, table)) {  /* should return NULL. */
+               DMDEBUG("failed to bind the device to the table");
+               goto table_bind_fail;
+       }
+
+       /* Finally, resume and the device should be ready. */
+       if (dm_resume(md)) {
+               DMDEBUG("failed to resume the device");
+               goto resume_fail;
+       }
+
+       /* Export the dm device via the ioctl interface */
+       if (!strcmp(DM_NO_UUID, dm_setup_args.uuid))
+               uuid = NULL;
+       if (dm_ioctl_export(md, dm_setup_args.name, uuid)) {
+               DMDEBUG("failed to export device with given name and uuid");
+               goto export_fail;
+       }
+       printk(KERN_INFO "dm: dm-%d is ready\n", dm_setup_args.minor);
+
+       dm_setup_cleanup();
+       return;
+
+export_fail:
+resume_fail:
+table_bind_fail:
+suspend_fail:
+table_complete_fail:
+add_target_fail:
+       dm_table_put(table);
+dm_table_create_fail:
+       dm_put(md);
+dm_create_fail:
+       dm_setup_cleanup();
+parse_fail:
+       printk(KERN_WARNING "dm: starting dm-%d (%s) failed\n",
+              dm_setup_args.minor, dm_setup_args.name);
+}
+
+__setup("dm=", dm_setup);
+
+void __init dm_run_setup(void)
+{
+       if (!dm_early_setup)
+               return;
+       printk(KERN_INFO "dm: attempting early device configuration.\n");
+       dm_setup_drive();
+}
--
1.7.0.4



------------------------------

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

End of dm-devel Digest, Vol 75, Issue 12
****************************************

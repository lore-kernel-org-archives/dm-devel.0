From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/3] dm: a basic support for using the select or
	poll function
Date: Tue,  9 May 2017 12:10:26 -0700
Message-ID: <20170509191028.6898-2-agrover@redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170509191028.6898-1-agrover@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, snitzer@redhat.com
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

This is the very simple patch for polling on the /dev/mapper/control
device. The select or poll function waits until any event happens on any
dm device since opening the /dev/mapper/control device. When select or
poll returns the device as readable, we must close and reopen the device
to wait for new dm events.

Usage:
1. open the /dev/mapper/control device
2. scan the event numbers of all devices we are interested in and process
   them
3. call select, poll or epoll on the handle (it waits until some new event
   happens since opening the device)
4. close the /dev/mapper/control handle
5. go to step 1

The next patch allows to re-arm the polling without closing and reopening
the device.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-core.h          |  3 +++
 drivers/md/dm-ioctl.c         | 49 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.c               |  5 +++++
 include/uapi/linux/dm-ioctl.h |  2 +-
 4 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 97db4d1..c15df7b 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -146,4 +146,7 @@ static inline bool dm_message_test_buffer_overflow(char *result, unsigned maxlen
 	return !maxlen || strlen(result) + 1 >= maxlen;
 }
 
+extern atomic_t dm_global_event_nr;
+extern wait_queue_head_t dm_global_eventq;
+
 #endif
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2d5d706..855f7c9 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -23,6 +23,14 @@
 #define DM_MSG_PREFIX "ioctl"
 #define DM_DRIVER_EMAIL "dm-devel@redhat.com"
 
+struct dm_file {
+	/*
+	 * poll will wait until the global event number is greater than
+	 * this value.
+	 */
+	unsigned global_event_nr;
+};
+
 /*-----------------------------------------------------------------
  * The ioctl interface needs to be able to look up devices by
  * name or uuid.
@@ -1872,8 +1880,47 @@ static long dm_compat_ctl_ioctl(struct file *file, uint command, ulong u)
 #define dm_compat_ctl_ioctl NULL
 #endif
 
+int dm_open(struct inode *inode, struct file *filp)
+{
+	int r;
+	struct dm_file *priv;
+
+	r = nonseekable_open(inode, filp);
+	if (unlikely(r))
+		return r;
+
+	priv = filp->private_data = kmalloc(sizeof(struct dm_file), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->global_event_nr = atomic_read(&dm_global_event_nr);
+
+	return 0;
+}
+
+int dm_release(struct inode *inode, struct file *filp)
+{
+	kfree(filp->private_data);
+	return 0;
+}
+
+static unsigned dm_poll(struct file *filp, poll_table *wait)
+{
+	struct dm_file *priv = filp->private_data;
+	unsigned mask = 0;
+
+	poll_wait(filp, &dm_global_eventq, wait);
+
+	if ((int)(atomic_read(&dm_global_event_nr) - priv->global_event_nr) > 0)
+		mask |= POLLIN;
+
+	return mask;
+}
+
 static const struct file_operations _ctl_fops = {
-	.open = nonseekable_open,
+	.open    = dm_open,
+	.release = dm_release,
+	.poll    = dm_poll,
 	.unlocked_ioctl	 = dm_ctl_ioctl,
 	.compat_ioctl = dm_compat_ctl_ioctl,
 	.owner	 = THIS_MODULE,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 268edf4..d628592 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -57,6 +57,9 @@ static DECLARE_WORK(deferred_remove_work, do_deferred_remove);
 
 static struct workqueue_struct *deferred_remove_workqueue;
 
+atomic_t dm_global_event_nr = ATOMIC_INIT(0);
+DECLARE_WAIT_QUEUE_HEAD(dm_global_eventq);
+
 /*
  * One of these is allocated per bio.
  */
@@ -1717,7 +1720,9 @@ static void event_callback(void *context)
 	dm_send_uevents(&uevents, &disk_to_dev(md->disk)->kobj);
 
 	atomic_inc(&md->event_nr);
+	atomic_inc(&dm_global_event_nr);
 	wake_up(&md->eventq);
+	wake_up(&dm_global_eventq);
 }
 
 /*
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 4bf9f1e..1f0605d 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -267,7 +267,7 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	35
+#define DM_VERSION_MINOR	36
 #define DM_VERSION_PATCHLEVEL	0
 #define DM_VERSION_EXTRA	"-ioctl (2016-06-23)"
 
-- 
2.9.3

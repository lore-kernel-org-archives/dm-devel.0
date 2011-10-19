From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2 - v2] DM log userspace: Allow CTR device
	response
Date: Wed, 19 Oct 2011 16:04:49 -0500
Message-ID: <1319058289.4668.3.camel@f14.redhat.com>
References: <1318533312.28595.4.camel@f14.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1318533312.28595.4.camel@f14.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Allow DM userspace logs to register their log device

When device mapper targets use a device, they register the device via
'dm_get_device'.  Once registered, device dependency trees can be created
in userspace.  These dependency trees are necessary for the proper operation
of userspace applications, like LVM.  However, since the userspace logs don't
have access to 'dm_get_device', any devices they use are not properly
registered.

I've change the DM_ULOG_CTR operation to allow userspace to respond with the
name of the log device (if appropriate) to be registered via 'dm_get_device'.
Doing so necessitated the increment of DM_ULOG_REQUEST_VERSION.  If the
userspace log server does not use a log device, it can still return no data -
i.e. no devices need to be registered.

This solution is backwards compatible from the userspace and kernel perspective.
If the kernel and userspace log server have been updated, the new information
will be passed down to the kernel; allowing the device to be registered.  If the
kernel is new, but the log server is old; the log server will not pass down
any device information and the kernel will simply bypass the device registration
as before.  If the kernel is old but the log server is new, the log server will
see the old version # and not pass down the device info.  (If it did pass the
device name down in error, the kernel would report an error due to having
insufficient space to accept the new information.)

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-log-userspace-base.c
+++ linux-upstream/drivers/md/dm-log-userspace-base.c
@@ -30,6 +30,7 @@ struct flush_entry {
 
 struct log_c {
 	struct dm_target *ti;
+	struct dm_dev *log_dev;
 	uint32_t region_size;
 	region_t region_count;
 	uint64_t luid;
@@ -161,13 +162,15 @@ static int userspace_ctr(struct dm_dirty
 	struct log_c *lc = NULL;
 	uint64_t rdata;
 	size_t rdata_size = sizeof(rdata);
+	char *devices_rdata = NULL;
+	size_t devices_rdata_size = DM_NAME_LEN;
 
 	if (argc < 3) {
 		DMWARN("Too few arguments to userspace dirty log");
 		return -EINVAL;
 	}
 
-	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
+	lc = kzalloc(sizeof(*lc), GFP_KERNEL);
 	if (!lc) {
 		DMWARN("Unable to allocate userspace log context.");
 		return -ENOMEM;
@@ -195,9 +198,19 @@ static int userspace_ctr(struct dm_dirty
 		return str_size;
 	}
 
-	/* Send table string */
+	devices_rdata = kzalloc(devices_rdata_size, GFP_KERNEL);
+	if (!devices_rdata) {
+		DMERR("Failed to allocate memory for device information");
+		r = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * Send table string and get back any required devices
+	 */
 	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_CTR,
-				 ctr_str, str_size, NULL, NULL);
+				 ctr_str, str_size,
+				 devices_rdata, &devices_rdata_size);
 
 	if (r < 0) {
 		if (r == -ESRCH)
@@ -220,7 +233,24 @@ static int userspace_ctr(struct dm_dirty
 	lc->region_size = (uint32_t)rdata;
 	lc->region_count = dm_sector_div_up(ti->len, lc->region_size);
 
+	if (devices_rdata_size) {
+		/* Strings must be properly NULL terminated */
+		devices_rdata[DM_NAME_LEN - 1] = '\0';
+		if ((strlen(devices_rdata) + 1) != devices_rdata_size) {
+			DMERR("CTR device return string not properly terminated: Auto-terminating");
+			if (devices_rdata_size < DM_NAME_LEN)
+				/* Add trailing NULL if enough space */
+				devices_rdata[devices_rdata_size] = '\0';
+		}
+		r = dm_get_device(ti, devices_rdata,
+				  dm_table_get_mode(ti->table), &lc->log_dev);
+		if (r)
+			DMERR("Failed to register %s with device-mapper",
+			      devices_rdata);
+	}
 out:
+	if (devices_rdata)
+		kfree(devices_rdata);
 	if (r) {
 		kfree(lc);
 		kfree(ctr_str);
@@ -241,6 +271,9 @@ static void userspace_dtr(struct dm_dirt
 				 NULL, 0,
 				 NULL, NULL);
 
+	if (lc->log_dev)
+		dm_put_device(lc->ti, lc->log_dev);
+
 	kfree(lc->usr_argv_str);
 	kfree(lc);
 
Index: linux-upstream/include/linux/dm-log-userspace.h
===================================================================
--- linux-upstream.orig/include/linux/dm-log-userspace.h
+++ linux-upstream/include/linux/dm-log-userspace.h
@@ -52,15 +52,20 @@
  * Payload-to-userspace:
  *	A single string containing all the argv arguments separated by ' 's
  * Payload-to-kernel:
- *	None.  ('data_size' in the dm_ulog_request struct should be 0.)
+ *	The name of the device that is used as the backing store for the log
+ *      data.  'dm_get_device' will be called on this device.  ('dm_put_device'
+ *      will be called on this device automatically after calling DM_ULOG_DTR.)
+ *      If there is no device needed for log data, 'data_size' in the
+ *      dm_ulog_request struct should be 0.
  *
  * The UUID contained in the dm_ulog_request structure is the reference that
  * will be used by all request types to a specific log.  The constructor must
- * record this assotiation with instance created.
+ * record this assotiation with the instance created.
  *
  * When the request has been processed, user-space must return the
- * dm_ulog_request to the kernel - setting the 'error' field and
- * 'data_size' appropriately.
+ * dm_ulog_request to the kernel - setting the 'error' field, filling the
+ * data field with the log device if necessary, and setting 'data_size'
+ * appropriately.
  */
 #define DM_ULOG_CTR                    1
 
@@ -377,8 +382,11 @@
  * dm_ulog_request or a change in the way requests are
  * issued/handled.  Changes are outlined here:
  *	version 1:  Initial implementation
+ *	version 2:  DM_ULOG_CTR allowed to return a string containing a
+ *	            device name that is to be registered with DM via
+ *	            'dm_get_device'.
  */
-#define DM_ULOG_REQUEST_VERSION 1
+#define DM_ULOG_REQUEST_VERSION 2
 
 struct dm_ulog_request {
 	/*

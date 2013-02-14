From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-ioctl: enhanced messages
Date: Thu, 14 Feb 2013 18:06:26 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1302141805440.5031@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-ioctl: enhanced messages

This patch introduces enhanced message support that is needed for the
following statistics patch.

This patch allows processing of special messages in the device mapper in
the function "message_for_md". If the device mapper doesn't support the
message, it is passed to the target driver..

This patch allows two-way messages, that is messages that may return
some data. If the message returns data, the kernel signals it with
DM_MESSAGE_OUT_FLAG flag.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c         |   55 +++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/dm-ioctl.h |    5 +++
 2 files changed, 59 insertions(+), 1 deletion(-)

Index: linux-3.8-rc7-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.8-rc7-fast.orig/drivers/md/dm-ioctl.c	2013-02-14 23:31:21.000000000 +0100
+++ linux-3.8-rc7-fast/drivers/md/dm-ioctl.c	2013-02-14 23:42:59.000000000 +0100
@@ -1451,6 +1451,52 @@ static int table_status(struct dm_ioctl 
 	return 0;
 }
 
+struct dm_message_output_callback {
+	struct dm_ioctl *param;
+	size_t param_size;
+};
+
+static int dm_output_message_string(struct dm_message_output_callback *c,
+				    const char *string)
+{
+	size_t len;
+	char *p;
+	if (c->param->flags & DM_BUFFER_FULL_FLAG)
+		return -1;
+	if (!(c->param->flags & DM_MESSAGE_OUT_FLAG)) {
+		p = get_result_buffer(c->param, c->param_size, &len);
+		if (!len) {
+			c->param->flags |= DM_BUFFER_FULL_FLAG;
+			return -1;
+		}
+		*p = 0;
+		c->param->data_size = c->param->data_start + 1;
+		c->param->flags |= DM_MESSAGE_OUT_FLAG;
+	}
+	p = (char *)c->param + c->param->data_size - 1;
+	len = strlen(string);
+	if (c->param->data_size + len > c->param_size) {
+		c->param->flags |= DM_BUFFER_FULL_FLAG;
+		c->param->flags &= ~DM_MESSAGE_OUT_FLAG;
+		return -1;
+	}
+	c->param->data_size += len;
+	strcpy(p, string);
+	return 0;
+}
+
+/*
+ * Process device-mapper dependent messages.
+ * Returns a number <= 0 if message was processed by device mapper.
+ * Returns 1 if message should be delivered to the target.
+ */
+static int message_for_md(struct mapped_device *md,
+			  struct dm_message_output_callback *c,
+			  unsigned argc, char **argv)
+{
+	return 1;
+}
+
 /*
  * Pass a message to the target that's at the supplied device offset.
  */
@@ -1463,6 +1509,7 @@ static int target_message(struct dm_ioct
 	struct dm_target *ti;
 	struct dm_target_msg *tmsg = (void *) param + param->data_start;
 	int srcu_idx;
+	struct dm_message_output_callback c = { param, param_size };
 
 	md = find_device(param);
 	if (!md)
@@ -1486,6 +1533,10 @@ static int target_message(struct dm_ioct
 		goto out_argv;
 	}
 
+	r = message_for_md(md, &c, argc, argv);
+	if (r <= 0)
+		goto out_argv;
+
 	table = dm_get_live_table(md, &srcu_idx);
 	if (!table)
 		goto out_table;
@@ -1511,7 +1562,8 @@ static int target_message(struct dm_ioct
  out_argv:
 	kfree(argv);
  out:
-	param->data_size = 0;
+	if (!(param->flags & (DM_MESSAGE_OUT_FLAG | DM_BUFFER_FULL_FLAG)))
+		param->data_size = 0;
 	dm_put(md);
 	return r;
 }
@@ -1685,6 +1737,7 @@ static int validate_params(uint cmd, str
 	param->flags &= ~DM_BUFFER_FULL_FLAG;
 	param->flags &= ~DM_UEVENT_GENERATED_FLAG;
 	param->flags &= ~DM_SECURE_DATA_FLAG;
+	param->flags &= ~DM_MESSAGE_OUT_FLAG;
 
 	/* Ignores parameters */
 	if (cmd == DM_REMOVE_ALL_CMD ||
Index: linux-3.8-rc7-fast/include/uapi/linux/dm-ioctl.h
===================================================================
--- linux-3.8-rc7-fast.orig/include/uapi/linux/dm-ioctl.h	2013-02-14 23:39:39.000000000 +0100
+++ linux-3.8-rc7-fast/include/uapi/linux/dm-ioctl.h	2013-02-14 23:40:39.000000000 +0100
@@ -336,4 +336,9 @@ enum {
  */
 #define DM_SECURE_DATA_FLAG		(1 << 15) /* In */
 
+/*
+ * If set, message generated output.
+ */
+#define DM_MESSAGE_OUT_FLAG		(1 << 16) /* Out */
+
 #endif				/* _LINUX_DM_IOCTL_H */

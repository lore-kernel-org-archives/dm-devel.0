From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-ioctl: enhanced messages (version 3)
Date: Fri, 1 Mar 2013 12:58:22 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1303011250580.6744@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1302141805440.5031@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1302141805440.5031@file.rdu.redhat.com>
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

Hi

This is another resend of the statistics patch - previously some code was 
created in PATCH 1/2 and deleted in PATCH 2/2, so I'm resending both.

Mikulas

---

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
 drivers/md/dm-ioctl.c         |   46 ++++++++++++++++++++++++++++++++++++------
 include/uapi/linux/dm-ioctl.h |    5 ++++
 2 files changed, 45 insertions(+), 6 deletions(-)

Index: linux-3.8-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-ioctl.c	2013-02-27 00:36:14.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-ioctl.c	2013-03-01 18:49:05.000000000 +0100
@@ -1098,6 +1098,7 @@ static void retrieve_status(struct dm_ta
 	num_targets = dm_table_get_num_targets(table);
 	for (i = 0; i < num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(table, i);
+		size_t l;
 
 		remaining = len - (outptr - outbuf);
 		if (remaining <= sizeof(struct dm_target_spec)) {
@@ -1124,14 +1125,17 @@ static void retrieve_status(struct dm_ta
 		if (ti->type->status) {
 			if (param->flags & DM_NOFLUSH_FLAG)
 				status_flags |= DM_STATUS_NOFLUSH_FLAG;
-			if (ti->type->status(ti, type, status_flags, outptr, remaining)) {
-				param->flags |= DM_BUFFER_FULL_FLAG;
-				break;
-			}
+			ti->type->status(ti, type, status_flags, outptr, remaining);
 		} else
 			outptr[0] = '\0';
 
-		outptr += strlen(outptr) + 1;
+		l = strlen(outptr) + 1;
+		if (l == remaining) {
+			param->flags |= DM_BUFFER_FULL_FLAG;
+			break;
+		}
+
+		outptr += l;
 		used = param->data_start + (outptr - outbuf);
 
 		outptr = align_ptr(outptr);
@@ -1451,6 +1455,22 @@ static int table_status(struct dm_ioctl 
 	return 0;
 }
 
+static bool message_test_overflow(char *result, unsigned maxlen)
+{
+	return !maxlen || strlen(result) + 1 >= maxlen;
+}
+
+/*
+ * Process device-mapper dependent messages.
+ * Returns a number <= 1 if message was processed by device mapper.
+ * Returns 2 if message should be delivered to the target.
+ */
+static int message_for_md(struct mapped_device *md, unsigned argc, char **argv,
+			  char *result, unsigned maxlen)
+{
+	return 2;
+}
+
 /*
  * Pass a message to the target that's at the supplied device offset.
  */
@@ -1463,6 +1483,8 @@ static int target_message(struct dm_ioct
 	struct dm_target *ti;
 	struct dm_target_msg *tmsg = (void *) param + param->data_start;
 	int srcu_idx;
+	size_t maxlen;
+	char *result = get_result_buffer(param, param_size, &maxlen);
 
 	md = find_device(param);
 	if (!md)
@@ -1486,6 +1508,10 @@ static int target_message(struct dm_ioct
 		goto out_argv;
 	}
 
+	r = message_for_md(md, argc, argv, result, maxlen);
+	if (r <= 1)
+		goto out_argv;
+
 	table = dm_get_live_table(md, &srcu_idx);
 	if (!table)
 		goto out_table;
@@ -1511,7 +1537,14 @@ static int target_message(struct dm_ioct
  out_argv:
 	kfree(argv);
  out:
-	param->data_size = 0;
+	if (r == 1) {
+		param->flags |= DM_MESSAGE_OUT_FLAG;
+		if (message_test_overflow(result, maxlen))
+			param->flags |= DM_BUFFER_FULL_FLAG;
+		else
+			param->data_size = param->data_start + strlen(result) + 1;
+		r = 0;
+	}
 	dm_put(md);
 	return r;
 }
@@ -1685,6 +1718,7 @@ static int validate_params(uint cmd, str
 	param->flags &= ~DM_BUFFER_FULL_FLAG;
 	param->flags &= ~DM_UEVENT_GENERATED_FLAG;
 	param->flags &= ~DM_SECURE_DATA_FLAG;
+	param->flags &= ~DM_MESSAGE_OUT_FLAG;
 
 	/* Ignores parameters */
 	if (cmd == DM_REMOVE_ALL_CMD ||
Index: linux-3.8-fast/include/uapi/linux/dm-ioctl.h
===================================================================
--- linux-3.8-fast.orig/include/uapi/linux/dm-ioctl.h	2013-02-27 00:33:31.000000000 +0100
+++ linux-3.8-fast/include/uapi/linux/dm-ioctl.h	2013-02-27 00:36:14.000000000 +0100
@@ -336,4 +336,9 @@ enum {
  */
 #define DM_SECURE_DATA_FLAG		(1 << 15) /* In */
 
+/*
+ * If set, message generated output.
+ */
+#define DM_MESSAGE_OUT_FLAG		(1 << 16) /* Out */
+
 #endif				/* _LINUX_DM_IOCTL_H */

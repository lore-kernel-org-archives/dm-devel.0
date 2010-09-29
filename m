From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 1] dm log userspace add version number
Date: Wed, 29 Sep 2010 09:13:25 -0500
Message-ID: <201009291413.o8TEDP0p006091@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: dm-log-userspace-add-version-number.patch

This patch adds a 'version' field to the 'dm_ulog_request'
structure.

The 'version' field is taken from a portion of the unused
'padding' field in the 'dm_ulog_request' structure.  This
was done to avoid changing the size of the structure and
possibly disrupting backwards compatibility.

The version number will help notify user-space daemons
when a change has been made to the kernel/userspace
log API (none of which has yet happened).

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-log-userspace-transfer.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-transfer.c
+++ linux-2.6/drivers/md/dm-log-userspace-transfer.c
@@ -198,6 +198,7 @@ resend:
 
 	memset(tfr, 0, DM_ULOG_PREALLOCED_SIZE - sizeof(struct cn_msg));
 	memcpy(tfr->uuid, uuid, DM_UUID_LEN);
+	tfr->version = DM_ULOG_REQUEST_VERSION;
 	tfr->luid = luid;
 	tfr->seq = dm_ulog_seq++;
 
Index: linux-2.6/include/linux/dm-log-userspace.h
===================================================================
--- linux-2.6.orig/include/linux/dm-log-userspace.h
+++ linux-2.6/include/linux/dm-log-userspace.h
@@ -370,6 +370,16 @@
 #define DM_ULOG_REQUEST_TYPE(request_type) \
 	(DM_ULOG_REQUEST_MASK & (request_type))
 
+/*
+ * DM_ULOG_REQUEST_VERSION is incremented when there is a
+ * change to the way information is passed between kernel
+ * and userspace.  This could be a structure change of
+ * dm_ulog_request or a change in the way requests are
+ * issued/handled.  Changes are outlined here:
+ *	version 1:  Initial implementation
+ */
+#define DM_ULOG_REQUEST_VERSION 1
+
 struct dm_ulog_request {
 	/*
 	 * The local unique identifier (luid) and the universally unique
@@ -383,8 +393,9 @@ struct dm_ulog_request {
 	 */
 	uint64_t luid;
 	char uuid[DM_UUID_LEN];
-	char padding[7];        /* Padding because DM_UUID_LEN = 129 */
+	char padding[3];        /* Padding because DM_UUID_LEN = 129 */
 
+	uint32_t version;       /* See DM_ULOG_REQUEST_VERSION */
 	int32_t error;          /* Used to report back processing errors */
 
 	uint32_t seq;           /* Sequence number for request */

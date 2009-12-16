From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 1] dm log userspace variable calculation
	fixes
Date: Wed, 16 Dec 2009 14:37:47 -0600
Message-ID: <200912162037.nBGKblWN030076@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Patch name: dm-log-userspace-variable-calculation-fixes.patch

dm-log-cluster: Fix badly computed value.

This patch fixes two bugs that revolve around the
miscalculation and misuse of the variable
'overhead_size'.  'overhead_size' is the size of
the various header structures used during communication.

The first bug is the use of 'sizeof' with the pointer
of a structure instead of the structure itself -
resulting in the wrong size being computed.  This is
then used in a check to see if the payload (data_size)
would be to large for the preallocated structure.
Since the bug produces a smaller value for the
overhead, it was possible for the structure to be
breached.  (Although the current users of the code
do not currently send enough data to trigger this
bug.)

The second bug is that the 'overhead_size' value
is used to compute how much of the preallocated
space should be cleared before populating it with
fresh data.  This should have simply been
'sizeof(struct cn_msg)' not overhead_size.  The
fact that 'overhead_size' was computed incorrectly
made this problem "less bad" - leaving only a
pointer's worth of space at the end uncleared.
Thus, this bug was never producing a bad result,
but still needs to be fixed - especially now that
the value is computed correctly.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com

Index: linux-2.6/drivers/md/dm-log-userspace-transfer.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-transfer.c
+++ linux-2.6/drivers/md/dm-log-userspace-transfer.c
@@ -173,10 +173,15 @@ int dm_consult_userspace(const char *uui
 	int r = 0;
 	size_t dummy = 0;
 	int overhead_size =
-		sizeof(struct dm_ulog_request *) + sizeof(struct cn_msg);
+		sizeof(struct dm_ulog_request) + sizeof(struct cn_msg);
 	struct dm_ulog_request *tfr = prealloced_ulog_tfr;
 	struct receiving_pkg pkg;
 
+	/*
+	 * Given the space needed to hold the 'struct cn_msg' and
+	 * 'struct dm_ulog_request' - do we have enough payload
+	 * space remaining?
+	 */
 	if (data_size > (DM_ULOG_PREALLOCED_SIZE - overhead_size)) {
 		DMINFO("Size of tfr exceeds preallocated size");
 		return -EINVAL;
@@ -191,7 +196,7 @@ resend:
 	 */
 	mutex_lock(&dm_ulog_lock);
 
-	memset(tfr, 0, DM_ULOG_PREALLOCED_SIZE - overhead_size);
+	memset(tfr, 0, DM_ULOG_PREALLOCED_SIZE - sizeof(struct cn_msg));
 	memcpy(tfr->uuid, uuid, DM_UUID_LEN);
 	tfr->luid = luid;
 	tfr->seq = dm_ulog_seq++;

From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] dm-log-userspace: Failure to trap all errors
Date: Fri, 19 Mar 2010 17:04:37 -0500
Message-ID: <1269036277.22303.7.camel@hydrogen.msp.redhat.com>
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

This patch resolves unhandled errors.

When constructing a mirror, it is possible for the initial request to
fail for other reasons besides just -ESRCH.  These must be handled too.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-base.c
+++ linux-2.6/drivers/md/dm-log-userspace-base.c
@@ -180,8 +180,11 @@ static int userspace_ctr(struct dm_dirty
 	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_CTR,
 				 ctr_str, str_size, NULL, NULL);
 
-	if (r == -ESRCH) {
-		DMERR("Userspace log server not found");
+	if (r < 0) {
+		if (r == -ESRCH)
+			DMERR("Userspace log server not found");
+		else
+			DMERR("Userspace log server failed to create log");
 		goto out;
 	}
 

From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 1] dm log userspace check additional error
	conditions
Date: Wed, 29 Sep 2010 09:03:23 -0500
Message-ID: <201009291403.o8TE3N9b003300@hydrogen.msp.redhat.com>
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

Patch name: dm-log-userspace-check-additional-error-conditions.patch

This patch resolves unhandled errors.

When constructing a mirror, it is possible for the initial request to
fail for other reasons besides just -ESRCH.  These must be handled too.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-base.c
+++ linux-2.6/drivers/md/dm-log-userspace-base.c
@@ -181,8 +181,11 @@ static int userspace_ctr(struct dm_dirty
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
 

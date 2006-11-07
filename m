From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 13 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:06:58 -0600
Message-ID: <1162915618.17899.60.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
Cc: heinzm@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

 brassow

Bump the mirror version number to indicate that this code has the
ability to detect/tolerate failures.
Index: linux-2.6.18.1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-raid1.c	2006-11-06 17:00:49.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-raid1.c	2006-11-06 17:19:29.000000000 -0600
@@ -1731,7 +1731,7 @@ static int mirror_status(struct dm_targe
 
 static struct target_type mirror_target = {
 	.name	 = "mirror",
-	.version = {1, 0, 2},
+	.version = {1, 2, 0},
 	.module	 = THIS_MODULE,
 	.ctr	 = mirror_ctr,
 	.dtr	 = mirror_dtr,

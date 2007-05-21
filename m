From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc1-mm1 PATCH 10/10] dm-raid1-version-bump.patch
Date: Mon, 21 May 2007 17:09:34 -0500
Message-ID: <1179785374.13913.38.camel@hydrogen.msp.redhat.com>
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
List-Id: dm-devel.ids

 brassow

Bump the mirror version number to indicate that this code has the
ability to detect/tolerate failures.
Index: linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
@@ -1767,7 +1767,7 @@ static int mirror_status(struct dm_targe
 
 static struct target_type mirror_target = {
 	.name	 = "mirror",
-	.version = {1, 0, 3},
+	.version = {1, 2, 0},
 	.module	 = THIS_MODULE,
 	.ctr	 = mirror_ctr,
 	.dtr	 = mirror_dtr,

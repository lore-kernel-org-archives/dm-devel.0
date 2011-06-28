From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 5 of 7] DM RAID:  allow metadata devices -- FIX
Date: Tue, 28 Jun 2011 15:17:30 -0500
Message-ID: <1309292250.10259.3.camel@f14.redhat.com>
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

This patch fixes an improper conditional in the 5th patch of the dm-raid
updates series.

 brassow

Set the synchronization offset if the '[no]sync' parameters were /not/ specified.

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -709,7 +709,7 @@ static int super_init_validation(mddev_t
 		return -EINVAL;
 	}
 
-	if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
+	if (!(rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC)))
 		mddev->recovery_cp = le64_to_cpu(sb->array_resync_offset);
 
 	/*

From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] dm-raid-cleanup-parameter-handling-2.patch
Date: Thu, 14 Jul 2011 16:22:55 -0500
Message-ID: <1310678575.2246.26.camel@f14.redhat.com>
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

Correct parameter count for RAID status table.

The parameters for rebuilds are already counted by the preceding
'for' loop.  Do not count them again.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -554,7 +554,7 @@ static int raid_status(struct dm_target 
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
 				raid_param_cnt += 2; /* for rebuilds */
 
-		raid_param_cnt += (hweight64(rs->print_flags) * 2);
+		raid_param_cnt += (hweight64(rs->print_flags & ~DMPF_REBUILD) * 2);
 		if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
 			raid_param_cnt--;
 

From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 8 of 7]: DM RAID 'failed_devices' should be 64-bit
Date: Tue, 05 Jul 2011 10:55:09 -0500
Message-ID: <1309881309.19763.6.camel@f14.redhat.com>
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

I have two more patches to add to the original series of 7 patches
([PATCH 0 OF 7] DM RAID updates).  These two should be added to the
end of the series.

 brassow

Use 64-bit variable for 'failed_devices'.

'failed_devices' is a 64-bit field in the superblock.  The corresponding
function local variable must also be 64-bit.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -712,7 +712,7 @@ static int super_init_validation(mddev_t
 {
 	struct raid_set *rs = container_of(mddev, struct raid_set, md);
 	uint64_t ev1;
-	uint32_t failed_devices;
+	uint64_t failed_devices;
 	struct dm_raid_superblock *sb;
 	uint32_t new_devs = 0;
 	uint32_t rebuilds = 0;

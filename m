From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 7 of 7] DM RAID:  version number inc
Date: Wed, 08 Jun 2011 17:24:10 -0500
Message-ID: <1307571850.18638.16.camel@f14.redhat.com>
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

Increment the version number for dm-raid

Version number bump for the following features:
- region_size parameter added to CTR table and status output
- write_mostly parameter added to CTR table and status output
- Metadata devices to hold superblock/bitmap now supported
- Inclusion of RAID 1

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -1163,7 +1163,7 @@ static void raid_resume(struct dm_target
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 0, 0},
+	.version = {1, 1, 0},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,

From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH - v2] DM RAID: 'rebuild' parameter code should be
 setting MD_CHANGE_DEVS
Date: Tue, 29 Nov 2011 17:27:28 -0600
Message-ID: <1322609248.20158.20.camel@f14.redhat.com>
References: <1322510465.20158.2.camel@f14.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1322510465.20158.2.camel@f14.redhat.com>
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

Changes from previous:
- Add missing '{'
- Change comments to emphasize bug fix

 brassow

dm-raid: 'rebuild' parameter code should be setting MD_CHANGE_DEVS

The 'rebuild' parameter is used to rebuild individual devices in an array.
(Resynchronize a RAID1 device or recalculate a parity device in higher RAID,
for example.)  The MD_CHANGE_DEVS flag must be set when this parameter is
given in order to write out the superblocks and make the change take immediate
effect.

So, we need MD_CHANGE_DEVS to be set and the 'FirstUse' flag was being set as
a special case for rebuilds in super_init_validation.  The code that handles
new devices in super_load already sets MD_CHANGE_DEVS and 'FirstUse'.  Adding
a condition for rebuilds in super_load takes care of both flags without a need
for the special case in 'super_init_validation'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -667,7 +667,14 @@ static int super_load(struct md_rdev *rd
 		return ret;
 
 	sb = page_address(rdev->sb_page);
-	if (sb->magic != cpu_to_le32(DM_RAID_MAGIC)) {
+
+	/*
+	 * Two cases that we want to write new superblocks and rebuild:
+	 * 1) New device (no matching magic number)
+	 * 2) Device specified for rebuild (!In_sync w/ offset == 0)
+	 */
+	if ((sb->magic != cpu_to_le32(DM_RAID_MAGIC)) ||
+	    (!test_bit(In_sync, &rdev->flags) && !rdev->recovery_offset)) {
 		super_sync(rdev->mddev, rdev);
 
 		set_bit(FirstUse, &rdev->flags);
@@ -744,11 +751,8 @@ static int super_init_validation(struct 
 	 */
 	rdev_for_each(r, t, mddev) {
 		if (!test_bit(In_sync, &r->flags)) {
-			if (!test_bit(FirstUse, &r->flags))
-				DMERR("Superblock area of "
-				      "rebuild device %d should have been "
-				      "cleared.", r->raid_disk);
-			set_bit(FirstUse, &r->flags);
+			DMINFO("Device %d specified for rebuild: "
+			       "Clearing superblock", r->raid_disk);
 			rebuilds++;
 		} else if (test_bit(FirstUse, &r->flags))
 			new_devs++;

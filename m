From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID: Fix memory corruption caused by repeated calls to
 bitmap_load
Date: Fri, 27 Jan 2012 08:53:53 -0600
Message-ID: <1327676033.9152.7.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: dm-devel.ids

Neil,

I came across this bug when testing snapshots of RAID volumes.  The
snapshot code performs multiple suspend/resume cycles on the underlying
LV, which is what caused me to notice that 'bitmap_load' was being
called multiple times and causing memory corruption.  As I explain in
the patch header, I'm pretty sure that avoiding the repeat call to
'bitmap_load' and kicking the MD thread instead is all that is needed.
(It certainly works in all my tests.)  However, please let me know if
there is anything I'm not aware of.

Thanks,
 brassow

Prevent DM RAID from loading bitmap twice.

The life cycle of a device-mapper target is:
1) create
2) resume
3) suspend
*) possibly repeat from 2
4) destroy

The dm-raid target is unconditionally calling MD's bitmap_load function upon
every resume.  If steps 2 & 3 above are repeated, bitmap_load is called
multiple times.  It is only written to be called once; otherwise, it allocates
new memory for the bitmap (without freeing the old) and incrementing the number
of pages it thinks it has without zeroing first.  This ultimately leads to
access beyond allocated memory and lost memory.

Simply avoiding the bitmap_load call upon resume is not sufficient.  If the
target was suspended while the initial recovery was only partially complete,
it needs to be restarted when the target is resumed.  This is why
'md_wakeup_thread' is called on the before issuing the 'mddev_resume'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -56,7 +56,8 @@ struct raid_dev {
 struct raid_set {
 	struct dm_target *ti;
 
-	uint64_t print_flags;
+	uint32_t bitmap_loaded;
+	uint32_t print_flags;
 
 	struct mddev md;
 	struct raid_type *raid_type;
@@ -1135,7 +1136,7 @@ static int raid_status(struct dm_target 
 				raid_param_cnt += 2;
 		}
 
-		raid_param_cnt += (hweight64(rs->print_flags & ~DMPF_REBUILD) * 2);
+		raid_param_cnt += (hweight32(rs->print_flags & ~DMPF_REBUILD) * 2);
 		if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
 			raid_param_cnt--;
 
@@ -1247,7 +1248,12 @@ static void raid_resume(struct dm_target
 {
 	struct raid_set *rs = ti->private;
 
-	bitmap_load(&rs->md);
+	if (!rs->bitmap_loaded) {
+		bitmap_load(&rs->md);
+		rs->bitmap_loaded = 1;
+	} else
+		md_wakeup_thread(rs->md.thread);
+
 	mddev_resume(&rs->md);
 }
 



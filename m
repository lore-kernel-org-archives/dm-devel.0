From: Andy Whitcroft <apw@canonical.com>
Subject: reinstate dm target local ioctl support
Date: Thu, 28 Jan 2016 13:50:19 +0000
Message-ID: <1453989019-24300-1-git-send-email-apw@canonical.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: mohan_srinivasan@yahoo.com, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>, Tim Gardner <tim.gardner@canonical.com>
List-Id: dm-devel.ids

With the commit below the dm ioctl support was reordered so that the
target only had to identify the underlying device, the dm_blk_ioctl()
itself then applied those ioctls to the appropriate device:

  commit e56f81e0b01ef4e45292d8c1e19edd4d09724e14
  Author: Christoph Hellwig <hch@lst.de>
  Date:   Thu Oct 15 14:10:50 2015 +0200

    dm: refactor ioctl handling

However this also removed the possibility of a dm target having target
specific ioctls.  Currently this is not used by any in-tree targets but
was utilised by the flashcache out-of-tree module.

How would we feel about carrying something like the patch below in
mainline to allow for such target local ioctls.

-apw

From 3fa0480193b944dd97565364efe4df89414c250b Mon Sep 17 00:00:00 2001
From: Andy Whitcroft <apw@canonical.com>
Date: Wed, 27 Jan 2016 16:05:32 +0000
Subject: dm: introduce a target_ioctl op to allow target specific ioctls

In e56f81e0b01e "dm: refactor ioctl handling" the target specific ioctl
operation was removed in favour of providing a mapping to the underlying
device, to which ioctls are all assumed to apply.  This prevents targets
from having target specific ioctls.

Introduce a new target_ioctl callback which (if present) is offered the
command and arguments for processing.  This callback can return -ENOTTY
to indicate the ioctl should be passed on to the underlying device as
normal.

BugLink: http://bugs.launchpad.net/bugs/1538618
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/md/dm.c               | 9 +++++++++
 include/linux/device-mapper.h | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5df4048..9014d46 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -610,6 +610,15 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 	if (r < 0)
 		return r;
 
+	if (tgt->type->target_ioctl) {
+		int res = tgt->type->target_ioctl(tgt, cmd, arg);
+
+		if (res != -ENOTTY) {
+			r = res;
+			goto out;
+		}
+	}
+
 	if (r > 0) {
 		/*
 		 * Target determined this ioctl is being issued against
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ec1c61c..d770bf0 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -81,6 +81,8 @@ typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv);
 
 typedef int (*dm_prepare_ioctl_fn) (struct dm_target *ti,
 			    struct block_device **bdev, fmode_t *mode);
+typedef int (*dm_target_ioctl_fn) (struct dm_target *ti, unsigned int cmd,
+				   unsigned long arg);
 
 /*
  * These iteration functions are typically used to check (and combine)
@@ -157,6 +159,7 @@ struct target_type {
 	dm_status_fn status;
 	dm_message_fn message;
 	dm_prepare_ioctl_fn prepare_ioctl;
+	dm_target_ioctl_fn target_ioctl;
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
-- 
2.7.0.rc3


From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 5/6] dm, dm-linear: Add dax_supported to dm_target
Date: Mon, 13 Jun 2016 16:21:36 -0600
Message-ID: <1465856497-19698-6-git-send-email-toshi.kani@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk, axboe@kernel.dk, toshi.kani@hpe.com, linux-nvdimm@lists.01.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Extend 'struct dm_target' to have dax_supported bit, which allows
dm-table to check if a dm-target supports DAX.

Change dm-linear to set this bit when its target physical device
supports DAX.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-linear.c        |    2 ++
 include/linux/device-mapper.h |    5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 49bd7d2..6fdbbc8 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -59,6 +59,8 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
+	if (lc->dev->bdev->bd_disk->flags & GENHD_FL_DAX)
+		ti->dax_supported = 1;
 	ti->private = lc;
 	return 0;
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 16e6c8c..9b72989 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -290,6 +290,11 @@ struct dm_target {
 	 * Set if this target does not return zeroes on discarded blocks.
 	 */
 	bool discard_zeroes_data_unsupported:1;
+
+	/*
+	 * Set if the target supports DAX (direct access).
+	 */
+	bool dax_supported:1;
 };
 
 /* Each target can link one of these into the table */

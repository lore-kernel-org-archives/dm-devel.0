From: Paul Wise <pabs3@bonedaddy.net>
Subject: [PATCH 3/3] dm raid/raid1: enable discard support when any devices support discard
Date: Sun, 19 Apr 2020 15:30:26 +0800
Message-ID: <20200419073026.197967-4-pabs3@bonedaddy.net>
References: <20200419073026.197967-1-pabs3@bonedaddy.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200419073026.197967-1-pabs3@bonedaddy.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Paul Wise <pabs3@bonedaddy.net>
List-Id: dm-devel.ids

This will allow fstrim to work on filesystems on dm RAID arrays with
both HDDs and SSDs or dm raid SSD arrays with varying discard support,
which should increase the lifetime of the SSDs that support discard.

This makes dm raid and dm raid1 (mirroring) consistent with md raid,
which supports discard when only some of the devices support discard.

The existing code prevents this from being enabled with RAID 4/5/6,
which require more certainty about the behaviour of underlying devices
after a discard has been issued and processed.

Simply enable discard and return from the configure_discard_support
function when any of the underlying devices has support for discards,
since there are now no other checks in the device check loop.

Mixed discard support for md RAID types was added in these commits:

commit c83057a1f4f9 ("md: raid 0 supports TRIM")
commit 2ff8cc2c6d4e ("md: raid 1 supports TRIM")
commit 532a2a3fba8d ("md: raid 10 supports TRIM")
commit f1cad2b68ed1 ("md: linear supports TRIM")

Signed-off-by: Paul Wise <pabs3@bonedaddy.net>
---
 drivers/md/dm-raid.c  | 8 ++++++--
 drivers/md/dm-raid1.c | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 0f95e50e62a8..63f5d05021a9 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2962,11 +2962,15 @@ static void configure_discard_support(struct raid_set *rs)
 			continue;
 
 		q = bdev_get_queue(rs->dev[i].rdev.bdev);
-		if (!q || !blk_queue_discard(q))
+		if (q && blk_queue_discard(q)) {
+			ti->discard_support = DM_DISCARD_ANY_DEVS;
+			ti->num_discard_bios = 1;
 			return;
+		}
 	}
 
-	ti->num_discard_bios = 1;
+	ti->discard_support = DM_DISCARD_ALL_DEVS;
+	ti->num_discard_bios = 0;
 }
 
 /*
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 089aed57e083..2bfed681dd3f 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1114,6 +1114,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto err_free_context;
 
 	ti->num_flush_bios = 1;
+	ti->discard_support = DM_DISCARD_ANY_DEVS;
 	ti->num_discard_bios = 1;
 	ti->per_io_data_size = sizeof(struct dm_raid1_bio_record);
 
-- 
2.26.1

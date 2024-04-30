Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977E6171641;
	Tue, 30 Apr 2024 12:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481501; cv=none; b=m3WCHFttwTa/u2ngDnKAQ5a5LJKUXzACve1g52sSMaxLzHgOncv4xtTwx+5RNi1pgkfuPyXlZyN71ZEPBU5+s/ELS74xkYDO+XQFryvsLZMGFfKah0IeXJeIC2N0plqZfkwwK61AqIfWCGpGwUqn4n3EIudZbj/n/G9uS3K8zLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481501; c=relaxed/simple;
	bh=bhWcMqFFHVFC0hty2uVdf+vbsbPqs2/3RINkXh6NZ88=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSNvEg5vyIqu8UiM4u2u3uAajX50bptJw/humPapZQlxMja9EFW4Wy8VnLzSaAAAEn4FfYbzC+EhYqMGDqjZDLrw3oKScDuFHEWiYiiem09MkSxEcJaLfsSc8I2nVPSWSuupDqFQKIIOVxapitmxl3mE9+5Vp2v8o8EcS2ahWDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bxbkWWBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bxbkWWBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FF3C4AF19;
	Tue, 30 Apr 2024 12:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481501;
	bh=bhWcMqFFHVFC0hty2uVdf+vbsbPqs2/3RINkXh6NZ88=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bxbkWWBUOzv+cKOBxf3N/ITk+tYAVrXsC1P1Wbu7kr/6wJyg8Y1B1gg8VwfLPyHEY
	 FuluROY4iaQGmaSiEFyoKcLUTPoXs1CIRJ3XRbxXSnBlL+EVvuSupKhhCbJxnAXxvD
	 rsvLPW3BgR70FyNXm3jLH6J5oWf/VeMNro13dmIVIaJbiwcRG+N1FC7chI1+1mMWYY
	 6R+mLiGh5We5oSm4GhT7LOweypswTqgun3+XJgTTsne0lufQ7MWyF3yP5ll1r1Wf30
	 U0QmTLlv1dSVEwmf5UpeLH3040OKbicuaI6Vlm8ojCZ+bE1+JyXSqObeBhK82fLgoS
	 UIBOoFHFOUQtg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 07/13] block: Do not remove zone write plugs still in use
Date: Tue, 30 Apr 2024 21:51:25 +0900
Message-ID: <20240430125131.668482-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430125131.668482-1-dlemoal@kernel.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Large write BIOs that span a zone boundary are split in
blk_mq_submit_bio() before being passed to blk_zone_plug_bio() for zone
write plugging. Such split BIO will be chained with one fragment
targeting one zone and the remainder of the BIO tergetting the next
zone. The two BIOs can be executed in parallel, without a predetermine
order relative to eachother and their completion may be reversed: the
remainder first completing and the first fragment then completing. In
such case, bio_endio() will not immediately execute
blk_zone_write_plug_bio_endio() for the parent BIO (the remainder of the
split BIO) as the BIOs are chained. blk_zone_write_plug_bio_endio() for
the parent BIO will be executed only once the first fragment completes.

In the case of a device with small zones and very large BIOs, uch
completion pattern can lead to disk_should_remove_zone_wplug() to return
true for the zone of the parent BIO when the parent BIO request
completes and blk_zone_write_plug_complete_request() is executed. This
triggers the removal of the zone write plug from the hash table using
disk_remove_zone_wplug(). With the zone write plug of the parent BIO
missing, the call to disk_get_zone_wplug() in
blk_zone_write_plug_bio_endio() returns NULL and triggers a warning.

This patterns can be recreated fairly easily using a scsi_debug device
with small zone and btrfs. E.g.

modprobe scsi_debug delay=0 dev_size_mb=1024 sector_size=4096 \
	zbc=host-managed zone_cap_mb=3 zone_nr_conv=0 zone_size_mb=4
mkfs.btrfs -f -O zoned /dev/sda
mount -t btrfs /dev/sda /mnt
fio --name=wrtest --rw=randwrite --direct=1 --ioengine=libaio \
	--bs=4k --iodepth=16 --size=1M --directory=/mnt --time_based \
	--runtime=10
umount /dev/sda

Will result in the warning:

[   29.035538] WARNING: CPU: 3 PID: 37 at block/blk-zoned.c:1207 blk_zone_write_plug_bio_endio+0xee/0x1e0
...
[   29.058682] Call Trace:
[   29.059095]  <TASK>
[   29.059473]  ? __warn+0x80/0x120
[   29.059983]  ? blk_zone_write_plug_bio_endio+0xee/0x1e0
[   29.060728]  ? report_bug+0x160/0x190
[   29.061283]  ? handle_bug+0x36/0x70
[   29.061830]  ? exc_invalid_op+0x17/0x60
[   29.062399]  ? asm_exc_invalid_op+0x1a/0x20
[   29.063025]  ? blk_zone_write_plug_bio_endio+0xee/0x1e0
[   29.063760]  bio_endio+0xb7/0x150
[   29.064280]  btrfs_clone_write_end_io+0x2b/0x60 [btrfs]
[   29.065049]  blk_update_request+0x17c/0x500
[   29.065666]  scsi_end_request+0x27/0x1a0 [scsi_mod]
[   29.066356]  scsi_io_completion+0x5b/0x690 [scsi_mod]
[   29.067077]  blk_complete_reqs+0x3a/0x50
[   29.067692]  __do_softirq+0xcf/0x2b3
[   29.068248]  ? sort_range+0x20/0x20
[   29.068791]  run_ksoftirqd+0x1c/0x30
[   29.069339]  smpboot_thread_fn+0xcc/0x1b0
[   29.069936]  kthread+0xcf/0x100
[   29.070438]  ? kthread_complete_and_exit+0x20/0x20
[   29.071314]  ret_from_fork+0x31/0x50
[   29.071873]  ? kthread_complete_and_exit+0x20/0x20
[   29.072563]  ret_from_fork_asm+0x11/0x20
[   29.073146]  </TASK>

either when fio executes or when unmount is executed.

Fix this by modifying disk_should_remove_zone_wplug() to check that the
reference count to a zone write plug is not larger than 2, that is, that
the only references left on the zone are the caller held reference
(blk_zone_write_plug_complete_request()) and the initial extra reference
for the zone write plug taken when it was initialized (and that is
dropped when the zone write plug is removed from the hash table).

To be consistent with this change, make sure to drop the request or BIO
held reference to the zone write plug before calling
disk_zone_wplug_unplug_bio(). All references are also dropped using
disk_put_zone_wplug() instead of atomic_dec() to ensure that the zone
write plug is freed if it needs to be.

Comments are also improved to clarify zone write plugs reference
handling.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 82e540dad900..5792e3b160c9 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -520,8 +520,9 @@ static inline void disk_put_zone_wplug(struct blk_zone_wplug *zwplug)
 static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
 						 struct blk_zone_wplug *zwplug)
 {
-	/* If the zone is still busy, the plug cannot be removed. */
-	if (zwplug->flags & BLK_ZONE_WPLUG_BUSY)
+	/* If the zone write plug is still busy, it cannot be removed. */
+	if ((zwplug->flags & BLK_ZONE_WPLUG_BUSY) ||
+	    atomic_read(&zwplug->ref) > 2)
 		return false;
 
 	/* We can remove zone write plugs for zones that are empty or full. */
@@ -891,8 +892,9 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
 	struct bio *bio;
 
 	/*
-	 * Completion of this request needs to be handled with
-	 * blk_zone_write_plug_complete_request().
+	 * Indicate that completion of this request needs to be handled with
+	 * blk_zone_write_plug_complete_request(), which will drop the reference
+	 * on the zone write plug we took above on entry to this function.
 	 */
 	req->rq_flags |= RQF_ZONE_WRITE_PLUGGING;
 
@@ -1221,6 +1223,9 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 		spin_unlock_irqrestore(&zwplug->lock, flags);
 	}
 
+	/* Drop the reference we took when the BIO was issued. */
+	disk_put_zone_wplug(zwplug);
+
 	/*
 	 * For BIO-based devices, blk_zone_write_plug_complete_request()
 	 * is not called. So we need to schedule execution of the next
@@ -1229,8 +1234,7 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 	if (bio->bi_bdev->bd_has_submit_bio)
 		disk_zone_wplug_unplug_bio(disk, zwplug);
 
-	/* Drop the reference we took when the BIO was issued. */
-	atomic_dec(&zwplug->ref);
+	/* Drop the reference we took when entering this function. */
 	disk_put_zone_wplug(zwplug);
 }
 
@@ -1244,13 +1248,15 @@ void blk_zone_write_plug_complete_request(struct request *req)
 
 	req->rq_flags &= ~RQF_ZONE_WRITE_PLUGGING;
 
-	disk_zone_wplug_unplug_bio(disk, zwplug);
-
 	/*
 	 * Drop the reference we took when the request was initialized in
 	 * blk_zone_write_plug_attempt_merge().
 	 */
-	atomic_dec(&zwplug->ref);
+	disk_put_zone_wplug(zwplug);
+
+	disk_zone_wplug_unplug_bio(disk, zwplug);
+
+	/* Drop the reference we took when entering this function. */
 	disk_put_zone_wplug(zwplug);
 }
 
-- 
2.44.0


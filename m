Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1F59475;
	Wed,  1 May 2024 00:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522185; cv=none; b=qtPVBHEFFVcllzZK2J0fdD9N84W5PRe4OMRFOi//UjAekDj4F1wAC6mG9iQXfGw1rveZ9maMnuH+nr2KePDuM1IN+3yBp0xIQHNfsxHKB6O5Cnz/fVz05NjxIzl0sk7gKGD2KF5GwAfLhQN4WQdG4ov3CuP3j+vyGsk0wktru18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522185; c=relaxed/simple;
	bh=F/o8UB8C+DtWIsZV8WTwVmGSriyqvfA1esK0NjmzflU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggxvZopf6KF/XHI6wLacf+C/EwB6ktwcn0enOQsWHXfS1q9i6XDgaAAWuKpbRx1qCCyXytMFRICItldYfV3LQehcrg/BNzgsFBpWAPATSU/Q1lDFhfUAym9ZIV13XwpBiFELzk+wvzeVh/hPRFfuQSebymg7hVmUBFNNOc4ddJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTLx7Mdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTLx7Mdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBA4C2BBFC;
	Wed,  1 May 2024 00:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522184;
	bh=F/o8UB8C+DtWIsZV8WTwVmGSriyqvfA1esK0NjmzflU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QTLx7Mdmp6J6MA/0Rwtdlx2yjtD0HlssuuYr7Cf1rGRe3mCjgBlipXE+X7B2joPeQ
	 6YjpSuwkAiRQknkmIjwLlsdmc3jGLlx3Oria2IUAnx64Pq24RD8DkmOBblxCSVxKc/
	 pXmLxTDp1+9x+DMfuMKQ6uUmM30XydHvMrhVxSyY5Gc5iQ3rwELTLAS26koHDFlYjC
	 j7CcCCN81lltFLymcqd9waAjrZqf/TH6mQi0Scrvl7o7oY2IeFflWjxc4w6TnBVOvr
	 KyOgbH441I2XPww6++LKU2vmAK3L79sw3iwCCS/sszA6+nmqB17Cd9mi/cdN7HrTCE
	 eQmfDnXEHdjig==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 07/14] block: Do not remove zone write plugs still in use
Date: Wed,  1 May 2024 09:09:28 +0900
Message-ID: <20240501000935.100534-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240501000935.100534-1-dlemoal@kernel.org>
References: <20240501000935.100534-1-dlemoal@kernel.org>
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
targeting one zone and the remainder of the BIO targeting the next
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
 block/blk-zoned.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 68a4264aded5..96ea97ad80a9 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -520,10 +520,28 @@ static inline void disk_put_zone_wplug(struct blk_zone_wplug *zwplug)
 static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
 						 struct blk_zone_wplug *zwplug)
 {
-	/* If the zone is still busy, the plug cannot be removed. */
+	/* If the zone write plug was already removed, we are done. */
+	if (zwplug->flags & BLK_ZONE_WPLUG_UNHASHED)
+		return false;
+
+	/* If the zone write plug is still busy, it cannot be removed. */
 	if (zwplug->flags & BLK_ZONE_WPLUG_BUSY)
 		return false;
 
+	/*
+	 * Completions of BIOs with blk_zone_write_plug_bio_endio() may
+	 * happen after handling a request completion with
+	 * blk_zone_write_plug_complete_request() (e.g. with split BIOs
+	 * that are chained). In such case, disk_zone_wplug_unplug_bio()
+	 * should not attempt to remove the zone write plug until all BIO
+	 * completions are seen. Check by looking at the zone write plug
+	 * reference count, which is 2 when the plug is unused (one reference
+	 * taken when the plug was allocated and another reference taken by the
+	 * caller context).
+	 */
+	if (atomic_read(&zwplug->ref) > 2)
+		return false;
+
 	/* We can remove zone write plugs for zones that are empty or full. */
 	return !zwplug->wp_offset || zwplug->wp_offset >= disk->zone_capacity;
 }
@@ -893,8 +911,9 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
 	struct bio *bio;
 
 	/*
-	 * Completion of this request needs to be handled with
-	 * blk_zone_write_plug_complete_request().
+	 * Indicate that completion of this request needs to be handled with
+	 * blk_zone_write_plug_complete_request(), which will drop the reference
+	 * on the zone write plug we took above on entry to this function.
 	 */
 	req->rq_flags |= RQF_ZONE_WRITE_PLUGGING;
 
@@ -1223,6 +1242,9 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 		spin_unlock_irqrestore(&zwplug->lock, flags);
 	}
 
+	/* Drop the reference we took when the BIO was issued. */
+	disk_put_zone_wplug(zwplug);
+
 	/*
 	 * For BIO-based devices, blk_zone_write_plug_complete_request()
 	 * is not called. So we need to schedule execution of the next
@@ -1231,8 +1253,7 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 	if (bio->bi_bdev->bd_has_submit_bio)
 		disk_zone_wplug_unplug_bio(disk, zwplug);
 
-	/* Drop the reference we took when the BIO was issued. */
-	atomic_dec(&zwplug->ref);
+	/* Drop the reference we took when entering this function. */
 	disk_put_zone_wplug(zwplug);
 }
 
@@ -1246,13 +1267,15 @@ void blk_zone_write_plug_complete_request(struct request *req)
 
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


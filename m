Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100FBC2C4;
	Sun,  3 Mar 2024 14:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474522; cv=none; b=Dat2vD+959qhJzOz/2Q8QG3HJeN9ioULurrbxNJ0rxognBd/U9Myd0QXImM2zQaHfDVhpXLiBbETkObNwDXE+zyu7rKvc56OIKxfJY/vEUkqsCEhCgFqC1fIexHbXyeSmfnd50/7GlI6jtUeAuovLQofDm9DnWRtFVDpXUDGK4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474522; c=relaxed/simple;
	bh=L2Dfi+WHboPGCy+uIY56V3HXOOCpsd3P0JdlWw98OeA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nZZApuQWA3OhbuLG2G1624fG8JKFeuEhbPM3PREHdWmm2I+nbhh+4M8UHj9tonuatPmlTrDbiV9KU/ovbm/2WHAlDs7HU+rqDAGDFMICLe1Bainaub5N/9UIiAQx4cOmYoWxAEr/d9t5gkg+5sNKj9nKU5uCz0BTYw3W/rnJdY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LTAbP/Su; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LTAbP/Su"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hUnMHyYS/bN0lEima/6NxSSVK1YzsLlczHeQb0d6LVk=; b=LTAbP/SusRR36ikvEBXJNYVfDe
	WU3WzZ6IxTjntJZykkhgK0WnCaD5d+wvWIu3pvZVegWIoNJdgUhJTejbx1sp5284Ehertrsy5dUT1
	SS0Bcio+G0C/gPO9OimdDqpTl6mgR6ObImYiknJCUSXI6x7vSJrtdsbQp/ibsU6THfoOXAJwpSfdi
	mfhZSotyZwWxpkCimiZAUoRZgH38G6lY8JfqHYUCZ57yhHLSH8WRUUaUSC0DdkYWJSXjzC6KrktRl
	okYT3djnEL/1jIIDyM4taAv7gEP8h9klmD5c9v9y09tdvZdwYu8nLGS10UFprRYVLeN3v1NfCZolg
	4rRAsWTw==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmPd-000000061i9-1Wj7;
	Sun, 03 Mar 2024 14:01:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 01/11] md: add a mddev_trace_remap helper
Date: Sun,  3 Mar 2024 07:01:40 -0700
Message-Id: <20240303140150.5435-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240303140150.5435-1-hch@lst.de>
References: <20240303140150.5435-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to trace bio remapping that hides some argument
dereferences and the check for a DM-mapped MD device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed--by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
---
 drivers/md/md.c     |  6 +-----
 drivers/md/md.h     |  8 ++++++++
 drivers/md/raid0.c  |  5 +----
 drivers/md/raid1.c  | 11 ++---------
 drivers/md/raid10.c | 10 ++--------
 drivers/md/raid5.c  | 14 +++-----------
 6 files changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 48ae2b1cb57af5..bbf84fdb879cd0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -65,7 +65,6 @@
 #include <linux/percpu-refcount.h>
 #include <linux/part_stat.h>
 
-#include <trace/events/block.h>
 #include "md.h"
 #include "md-bitmap.h"
 #include "md-cluster.h"
@@ -8662,10 +8661,7 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 
 	bio_chain(discard_bio, bio);
 	bio_clone_blkg_association(discard_bio, bio);
-	if (mddev->gendisk)
-		trace_block_bio_remap(discard_bio,
-				disk_devt(mddev->gendisk),
-				bio->bi_iter.bi_sector);
+	mddev_trace_remap(mddev, discard_bio, bio->bi_iter.bi_sector);
 	submit_bio_noacct(discard_bio);
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b2076a165c1050..468bccbf206b71 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -18,6 +18,7 @@
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
+#include <trace/events/block.h>
 #include "md-cluster.h"
 
 #define MaxSector (~(sector_t)0)
@@ -874,4 +875,11 @@ int do_md_run(struct mddev *mddev);
 
 extern const struct block_device_operations md_fops;
 
+static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
+		sector_t sector)
+{
+	if (mddev->gendisk)
+		trace_block_bio_remap(bio, disk_devt(mddev->gendisk), sector);
+}
+
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c50a7abda744ad..aff094de974347 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -578,10 +578,7 @@ static void raid0_map_submit_bio(struct mddev *mddev, struct bio *bio)
 	bio_set_dev(bio, tmp_dev->bdev);
 	bio->bi_iter.bi_sector = sector + zone->dev_start +
 		tmp_dev->data_offset;
-
-	if (mddev->gendisk)
-		trace_block_bio_remap(bio, disk_devt(mddev->gendisk),
-				      bio_sector);
+	mddev_trace_remap(mddev, bio, bio_sector);
 	mddev_check_write_zeroes(mddev, bio);
 	submit_bio_noacct(bio);
 }
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afca975ec7f314..421154430f241c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1418,11 +1418,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	    test_bit(R1BIO_FailFast, &r1_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
 	read_bio->bi_private = r1_bio;
-
-	if (mddev->gendisk)
-	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),
-				      r1_bio->sector);
-
+	mddev_trace_remap(mddev, read_bio, r1_bio->sector);
 	submit_bio_noacct(read_bio);
 }
 
@@ -1655,10 +1651,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
-
-		if (mddev->gendisk)
-			trace_block_bio_remap(mbio, disk_devt(mddev->gendisk),
-					      r1_bio->sector);
+		mddev_trace_remap(mddev, mbio, r1_bio->sector);
 		/* flush_pending_writes() needs access to the rdev so...*/
 		mbio->bi_bdev = (void *)rdev;
 		if (!raid1_add_bio_to_plug(mddev, mbio, raid1_unplug, disks)) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8aecdb1ccc169a..9335a1620e6c10 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1235,10 +1235,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	    test_bit(R10BIO_FailFast, &r10_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
 	read_bio->bi_private = r10_bio;
-
-	if (mddev->gendisk)
-	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),
-	                              r10_bio->sector);
+	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
 	submit_bio_noacct(read_bio);
 	return;
 }
@@ -1274,10 +1271,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 			 && enough(conf, devnum))
 		mbio->bi_opf |= MD_FAILFAST;
 	mbio->bi_private = r10_bio;
-
-	if (conf->mddev->gendisk)
-		trace_block_bio_remap(mbio, disk_devt(conf->mddev->gendisk),
-				      r10_bio->sector);
+	mddev_trace_remap(mddev, mbio, r10_bio->sector);
 	/* flush_pending_writes() needs access to the rdev so...*/
 	mbio->bi_bdev = (void *)rdev;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 48129de21aecc2..db8fe9e92965be 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1293,10 +1293,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 
-			if (conf->mddev->gendisk)
-				trace_block_bio_remap(bi,
-						disk_devt(conf->mddev->gendisk),
-						sh->dev[i].sector);
+			mddev_trace_remap(conf->mddev, bi, sh->dev[i].sector);
 			if (should_defer && op_is_write(op))
 				bio_list_add(&pending_bios, bi);
 			else
@@ -1340,10 +1337,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			 */
 			if (op == REQ_OP_DISCARD)
 				rbi->bi_vcnt = 0;
-			if (conf->mddev->gendisk)
-				trace_block_bio_remap(rbi,
-						disk_devt(conf->mddev->gendisk),
-						sh->dev[i].sector);
+			mddev_trace_remap(conf->mddev, rbi, sh->dev[i].sector);
 			if (should_defer && op_is_write(op))
 				bio_list_add(&pending_bios, rbi);
 			else
@@ -5521,9 +5515,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 		spin_unlock_irq(&conf->device_lock);
 	}
 
-	if (mddev->gendisk)
-		trace_block_bio_remap(align_bio, disk_devt(mddev->gendisk),
-				      raid_bio->bi_iter.bi_sector);
+	mddev_trace_remap(mddev, align_bio, raid_bio->bi_iter.bi_sector);
 	submit_bio_noacct(align_bio);
 	return 1;
 }
-- 
2.39.2


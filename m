Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9DB7290D;
	Wed, 28 Feb 2024 22:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161017; cv=none; b=VAgMj7Gkv2D6vwb7gMewZmpyGKwLWj6zE4+HBYmJ3Now2qzTqcJPIl2alVHSW2SNd9SHNdbybRAVqqz/svNHJY6HtZwSuXoTh4/Ynej8Wq9xodGRsHaUc185agfXaF98U8Y5RmMcFnJw+mfgjEq9pzAyDuTW86ioSEzjXo2OWo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161017; c=relaxed/simple;
	bh=3/xOyO8bCQyh/vTDfk5iMCHyqJtwKvw42InP6I3FFxI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XL4eOpUWahlStMiC3ccBf0AjLJcrYOeZpffJrSlehqO0MLlwQauxAIRQ3sTQupoVkvJzGuzRqb5Js4wdDQMpAtzS1Dp5clFnN3luHfLVJwlPFb7TfoQYdlR9EiZEyhcfCHbakqxp0zE+CpRNYzbGZrSGgV6rBT/UitGeSpaJbOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cq2xurVN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cq2xurVN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DdiDosqRE4HrozPUItBNS0DqsW91jIxkrinJnwBod8E=; b=cq2xurVNjQdethG09/wwYWnchD
	aL1QM+rhDlIm8hbUaPoteBbI+QQQPkxO3ZpRRHzU1Ok9YNq/0mlcXkxJjzin5MuQ/ILKfDvGUIyq/
	0tgLd7bXkZr5cDYUY0b2GIp3M/33xOqL567OuqLVI/TZrJADplAC/Pp0Uq1CUEFeoUTXHRUyNSX4K
	fcvQaJ+RyMenI3s+ZTDZaA3o3/1MWsVJOS9VGEEMsoQ4QJ3rTc0upWRTezT5rZE6lvfqbiPsExxPe
	C6kSS+KKx+Ln/BcFvXLyMf5tnWxZ3Q/ka4jlxSuuN8Sw74buzT2t01OnGLaZkRjgxTTh2rNLEnZ5s
	DzNKg2gw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSr9-0000000BCO2-0e6i;
	Wed, 28 Feb 2024 22:56:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 04/14] md: add a mddev_trace_remap helper
Date: Wed, 28 Feb 2024 14:56:43 -0800
Message-Id: <20240228225653.947152-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240228225653.947152-1-hch@lst.de>
References: <20240228225653.947152-1-hch@lst.de>
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
---
 drivers/md/md.c     |  6 +-----
 drivers/md/md.h     |  8 ++++++++
 drivers/md/raid0.c  |  5 +----
 drivers/md/raid1.c  | 11 ++---------
 drivers/md/raid10.c | 10 ++--------
 drivers/md/raid5.c  | 14 +++-----------
 6 files changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 75266c34b1f99b..ccbc66ce8c4d13 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -65,7 +65,6 @@
 #include <linux/percpu-refcount.h>
 #include <linux/part_stat.h>
 
-#include <trace/events/block.h>
 #include "md.h"
 #include "md-bitmap.h"
 #include "md-cluster.h"
@@ -8663,10 +8662,7 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 
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
index 8d881cc597992f..6465411d3afd5d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -18,6 +18,7 @@
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
+#include <trace/events/block.h>
 #include "md-cluster.h"
 
 #define MaxSector (~(sector_t)0)
@@ -863,4 +864,11 @@ int do_md_run(struct mddev *mddev);
 
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
index 286f8b16c7bde7..cb64477fa89feb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1320,11 +1320,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
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
 
@@ -1557,10 +1553,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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
index 7412066ea22c7a..ae90cca8335b50 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1249,10 +1249,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
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
@@ -1288,10 +1285,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
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
index 14f2cf75abbd72..c7da69c6e7c50c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1295,10 +1295,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
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
@@ -1342,10 +1339,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
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
@@ -5530,9 +5524,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
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


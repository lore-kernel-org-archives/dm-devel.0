Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29B22E3380;
	Mon, 21 Jul 2025 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118210; cv=none; b=UjECOuCOQJ6GnuDAsyjGW+aY5Mmh4bEV7y97m2yAN9eV8j5ueZTM+tgZHAQhDIB1v2slJP0Bg/AXqUGXGKVvIZ/xZYBV4nAqgtPvdthOnPhp2z6dK1T428Hbkq+EDMJrrP5bt/HJE0/EyyhzW5G5NyRIkVdFjdoP0bJMxUfW3+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118210; c=relaxed/simple;
	bh=c1dpqkHETxTaTOX0pe4v0CUN48bw6LxJ1QLe7fM6g9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEbAtmuyUrizYZAkcabzizj0PglxwSqzHREWr4EYns+AlNbPgXrSHVf+CenSlSWP3V/3G1//PDvHbjtOvI10HmeV83pQcMCief7/FKkhLV3uGPuxyyaPWe3GQVsS9lwqgRkmUu32bats+cMoIBunjvCtGmtqMzQsAI9ckyKsWr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N84Xt5x8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N84Xt5x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B23EC4CEED;
	Mon, 21 Jul 2025 17:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118209;
	bh=c1dpqkHETxTaTOX0pe4v0CUN48bw6LxJ1QLe7fM6g9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N84Xt5x8x6z9pQVNM7z3F0Ml8cOY0Q/XSUs0+bdXDD3fK0ODjA0Cs7WDe04K6E1DZ
	 8ubo/CqR2oB8bDv2jRumcDZrBrISX1GaFJSOHfA3p04NzqaWNdS6zl/IFZk5hsCbIO
	 fjzVKFyjq1OJnYnpqRjkzg4w1FXKKpmBzUTvLvpfHOus5nJeFjkO2VUZbSfS0F1sEc
	 GVDpHNSOn5Y5M4Ar5LmZKFRE7xzlAc7Qf28KEuzSdIyTOSxRMyk0tF4J7c/uSz3J4F
	 NvEbIJdzFVzHvV+zlT4R201Vky70TdIW7EthMseJqzafbal7cJSJSClv6HWztV5o2T
	 +cez7+6fuwAEg==
From: Yu Kuai <yukuai@kernel.org>
To: corbet@lwn.net,
	agk@redhat.co,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	hch@lst.de,
	song@kernel.org,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com,
	Xiao Ni <xni@redhat.com>
Subject: [PATCH v4 03/11] md/md-bitmap: support discard for bitmap ops
Date: Tue, 22 Jul 2025 01:15:49 +0800
Message-ID: <20250721171557.34587-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250721171557.34587-1-yukuai@kernel.org>
References: <20250721171557.34587-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

Use two new methods {start, end}_discard in bitmap_ops and a new field 'rw'
in struct md_io_clone to handle discard IO, prepare to support new md
bitmap.

Since all bitmap functions to hanlde write IO are the same, also add
typedef to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md-bitmap.c |  3 +++
 drivers/md/md-bitmap.h | 12 ++++++++----
 drivers/md/md.c        | 15 +++++++++++----
 drivers/md/md.h        |  1 +
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 3c8b8ecf0695..0eb3774f372d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -3006,6 +3006,9 @@ static struct bitmap_operations bitmap_ops = {
 
 	.start_write		= bitmap_start_write,
 	.end_write		= bitmap_end_write,
+	.start_discard		= bitmap_start_write,
+	.end_discard		= bitmap_end_write,
+
 	.start_sync		= bitmap_start_sync,
 	.end_sync		= bitmap_end_sync,
 	.cond_end_sync		= bitmap_cond_end_sync,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 42f91755a341..8616ced49077 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -61,6 +61,9 @@ struct md_bitmap_stats {
 	struct file	*file;
 };
 
+typedef void (md_bitmap_fn)(struct mddev *mddev, sector_t offset,
+			    unsigned long sectors);
+
 struct bitmap_operations {
 	struct md_submodule_head head;
 
@@ -81,10 +84,11 @@ struct bitmap_operations {
 	void (*end_behind_write)(struct mddev *mddev);
 	void (*wait_behind_writes)(struct mddev *mddev);
 
-	void (*start_write)(struct mddev *mddev, sector_t offset,
-			    unsigned long sectors);
-	void (*end_write)(struct mddev *mddev, sector_t offset,
-			  unsigned long sectors);
+	md_bitmap_fn *start_write;
+	md_bitmap_fn *end_write;
+	md_bitmap_fn *start_discard;
+	md_bitmap_fn *end_discard;
+
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1db7af64184d..efb38b9cfbd0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8858,18 +8858,24 @@ EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 static void md_bitmap_start(struct mddev *mddev,
 			    struct md_io_clone *md_io_clone)
 {
+	md_bitmap_fn *fn = unlikely(md_io_clone->rw == STAT_DISCARD) ?
+			   mddev->bitmap_ops->start_discard :
+			   mddev->bitmap_ops->start_write;
+
 	if (mddev->pers->bitmap_sector)
 		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
 					   &md_io_clone->sectors);
 
-	mddev->bitmap_ops->start_write(mddev, md_io_clone->offset,
-				       md_io_clone->sectors);
+	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
 static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 {
-	mddev->bitmap_ops->end_write(mddev, md_io_clone->offset,
-				     md_io_clone->sectors);
+	md_bitmap_fn *fn = unlikely(md_io_clone->rw == STAT_DISCARD) ?
+			   mddev->bitmap_ops->end_discard :
+			   mddev->bitmap_ops->end_write;
+
+	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
 static void md_end_clone_io(struct bio *bio)
@@ -8908,6 +8914,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev, false)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
+		md_io_clone->rw = op_stat_group(bio_op(*bio));
 		md_bitmap_start(mddev, md_io_clone);
 	}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 72bce59376d7..8452aaa2295d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -872,6 +872,7 @@ struct md_io_clone {
 	unsigned long	start_time;
 	sector_t	offset;
 	unsigned long	sectors;
+	enum stat_group	rw;
 	struct bio	bio_clone;
 };
 
-- 
2.43.0


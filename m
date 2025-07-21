Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311EF2E1C7C;
	Mon, 21 Jul 2025 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118205; cv=none; b=IOnmx/+jiInCUXS1UMD6bjuudSXGyztt0bSDsOauHiCxiB2oZgaT7BSS6d454IUUhYDo45PlCBNbMZuK0xK5+9Nt+sQX/O6E5MLdMO4jSZR2kEHubtOiEgb8xFN37DOXS2DD1tzYtFz8AD9vgyOPjaIxqKwiY3kLmGsf7JPlL+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118205; c=relaxed/simple;
	bh=hDz3DFXOYFPizJGAaypFAC4xK+xh8V9TABn0O0/Ut5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUXEAM58Yy0PQnzSCQMIK0m9UnscMRrmpB1eOJIy0y2V9Am5AdiV9mryv9lei0fPDZARcS1/IqtL9/UzUmb2u2dTB+xEfm0m6WvCwXtHavfUUc75VA71Vm17SXf55gcKq5oV9p9aqNIqj3ffyBmvm8EW0ESzwnXg6cVCP0g58l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uEVRdu7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uEVRdu7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D57CC4CEED;
	Mon, 21 Jul 2025 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118204;
	bh=hDz3DFXOYFPizJGAaypFAC4xK+xh8V9TABn0O0/Ut5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEVRdu7cSUqKfBxu0+fDHIcFQUF2J8fQMYywzE4C3TPn92PuM82DWgsh3ZZqhzCcj
	 FJqdR4KqyAaxYChMG3bDtCX0H75J49ZPXd6T6XN51Pg0uxHz6ner6awyC+QhLym8P2
	 PH0k5aAydJbGBjQwm4KwXKQMG0nplTWRmL0OQqVHIBQDSh5XSbuh7nypJ1HptNP1PP
	 RSOcOpB/UFigfK+3J0qdb2wuLS7itM7OFpmH5GrZWCv/p39yD4eZPSpXPqHD7QA8Nh
	 LDBbiorDI029rXc/Bro8wutlKyGYWRxObvejSDU7vVu6IQkrC/UDFJCckHlNALIP9m
	 4VKZo+LB/K38g==
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
Subject: [PATCH v4 02/11] md: factor out a helper raid_is_456()
Date: Tue, 22 Jul 2025 01:15:48 +0800
Message-ID: <20250721171557.34587-3-yukuai@kernel.org>
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

There are no functional changes, the helper will be used by llbitmap in
following patches.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 9 +--------
 drivers/md/md.h | 6 ++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c4ef23ade9e2..1db7af64184d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9050,19 +9050,12 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 
 static bool sync_io_within_limit(struct mddev *mddev)
 {
-	int io_sectors;
-
 	/*
 	 * For raid456, sync IO is stripe(4k) per IO, for other levels, it's
 	 * RESYNC_PAGES(64k) per IO.
 	 */
-	if (mddev->level == 4 || mddev->level == 5 || mddev->level == 6)
-		io_sectors = 8;
-	else
-		io_sectors = 128;
-
 	return atomic_read(&mddev->recovery_active) <
-		io_sectors * sync_io_depth(mddev);
+	       (raid_is_456(mddev) ? 8 : 128) * sync_io_depth(mddev);
 }
 
 #define SYNC_MARKS	10
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 9e37c6c18722..72bce59376d7 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1033,6 +1033,12 @@ static inline bool mddev_is_dm(struct mddev *mddev)
 	return !mddev->gendisk;
 }
 
+static inline bool raid_is_456(struct mddev *mddev)
+{
+	return mddev->level == ID_RAID4 || mddev->level == ID_RAID5 ||
+	       mddev->level == ID_RAID6;
+}
+
 static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 		sector_t sector)
 {
-- 
2.43.0


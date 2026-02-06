Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC1D2C0F90
	for <dm-devel@lists.linux.dev>; Fri,  6 Feb 2026 05:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354345; cv=none; b=JiOqzUHl0SMqDu5vy+7+PyYSmaGei6UAFGf9KlcXiRZY3nlq+kqmxqITqTptUSou+f278FxBkfvK4z88FXWuxPUInQeEJb8qCVJ8D0lctKZ/l1anlW1pZWs3N4ckXFv+TPuUB1/H6eGdChE7PRFAI9DuYcFnzvWst6t4RzuwGgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354345; c=relaxed/simple;
	bh=B1r0XH0TjvMaPBG35nI2v13c75hdcVyF9EN7yB8QNjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PeVVDfAXIaHccjMQe3H3LUhjVaKRZVX1Y5pcA1If/Wjd//Cvdru/rYVw+mKj4g+QRvjQ+29EKsiZlK0t3cPiIVp3H79px8IGWttm7bosDJhKE/dPXrmY1VX+XnenNlASz3XEJiETZoHLjEnKaScdp+vHUxUAzszZiHp5eT3qdso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.52 with ESMTP; 6 Feb 2026 14:05:36 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: jaeyuel.im@lge.com
Received: from unknown (HELO jaeyuelim-three.bee-live.svc.cluster.local) (10.185.60.48)
	by 156.147.1.125 with ESMTP; 6 Feb 2026 14:05:36 +0900
X-Original-SENDERIP: 10.185.60.48
X-Original-MAILFROM: jaeyuel.im@lge.com
From: jaeyuel.im@lge.com
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"jaeyuel.im" <jaeyuel.im@lge.com>
Subject: [PATCH] dm init: ensure block device is ready before creating mapped device
Date: Fri,  6 Feb 2026 05:05:26 +0000
Message-Id: <20260206050526.930530-1-jaeyuel.im@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251212000955.171808-1-jaeyuel.im@lge.com>
References: <20251212000955.171808-1-jaeyuel.im@lge.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "jaeyuel.im" <jaeyuel.im@lge.com>

The current implementation of dm_init_init() uses early_lookup_bdev() to
wait for the device node to appear. However, early_lookup_bdev() only
verifies that the device node exists and returns the dev_t. It does not
guarantee that the underlying block device structure is fully initialized
and ready for I/O operations or to be opened.

On certain platforms (e.g., embedded systems with specific storage
drivers), this can lead to a race condition where dm_early_create()
attempts to open the device immediately after early_lookup_bdev() returns,
but fails because the device is not yet fully ready. This results in boot
failures as the mapped device cannot be created.

This patch adds an additional check using blkdev_get_no_open() after
early_lookup_bdev() returns. This ensures that the struct block_device is
actually available and the device is ready to be opened, effectively
preventing the race condition.

Changes in v2:
- Pass autoload parameter for new blkdev_get_no_open()

Changes in v3:
- Exported to a public header for both blkdev_get_no_open() and
  blkdev_put_no_open()

Link: https://patchwork.kernel.org/project/dm-devel/patch/20251212000955.171808-1-jaeyuel.im@lge.com/
Signed-off-by: jaeyuel.im <jaeyuel.im@lge.com>
---
 drivers/md/dm-init.c   | 14 ++++++++++++++
 include/linux/blkdev.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index b37bbe762500..b3905e094ffc 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -296,10 +296,24 @@ static int __init dm_init_init(void)
 	for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
 		if (waitfor[i]) {
 			dev_t dev;
+			struct block_device *bdev;
 
 			DMINFO("waiting for device %s ...", waitfor[i]);
 			while (early_lookup_bdev(waitfor[i], &dev))
 				fsleep(5000);
+
+			/*
+			 * early_lookup_bdev() only checks if the device node exists and
+			 * returns the dev_t. It does not guarantee that the underlying
+			 * block device is fully initialized and ready to be opened. On
+			 * some platforms, this can lead to a race condition where
+			 * dm_early_create() fails because the device is not yet ready.
+			 * Ensure the block device is truly available by attempting to
+			 * get it.
+			 */
+			while (!(bdev = blkdev_get_no_open(dev, false)))
+				fsleep(5000);
+			blkdev_put_no_open(bdev);
 		}
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 72e34acd439c..7f4a05b536ca 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1873,4 +1873,7 @@ static inline int bio_split_rw_at(struct bio *bio,
 
 #define DEFINE_IO_COMP_BATCH(name)	struct io_comp_batch name = { }
 
+struct block_device *blkdev_get_no_open(dev_t dev, bool autoload);
+void blkdev_put_no_open(struct block_device *bdev);
+
 #endif /* _LINUX_BLKDEV_H */
-- 
2.34.1


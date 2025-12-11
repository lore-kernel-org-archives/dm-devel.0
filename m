Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11BB13635E
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 08:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765440308; cv=none; b=lzr6v1NcQhPK9o6AkPul5OH8qpLher4BAZ5ww8Mf+3wpKcxzI2989Dya1FMit64jA3/EJNzIdiUcg7ogbbedzl7CThgSatD9+6/GlRQegl0TIFqGxRdDs+BsRoT86oZZT2K6cOb4RjnorFOyLXDliwqQOrl5k4nZvls4+LEgTpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765440308; c=relaxed/simple;
	bh=6cFsSnDGBIDrdRq5Hk9Lnc9beDhoR8leOw5S9+oXdB8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uovYVqV0GsfrfEKNeVTyugHDN5S1Ir30SpTEPUfCrlniUppAsaWBbEjI29kMM200PbaTdN6mmvHUSpAjeSFkCZCe0ZmXZ32Cbw9Ea2LlBIeDMHAGDjfpYjk0JNntyWkR3C/0IezU8MHZThInp5SQPp+kqXC+5AaM1+xH/+LjNtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.52 with ESMTP; 11 Dec 2025 16:35:02 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: jaeyuel.im@lge.com
Received: from unknown (HELO jaeyuelim-three.bee-live.svc.cluster.local) (10.185.60.88)
	by 156.147.1.121 with ESMTP; 11 Dec 2025 16:35:02 +0900
X-Original-SENDERIP: 10.185.60.88
X-Original-MAILFROM: jaeyuel.im@lge.com
From: jaeyuel.im@lge.com
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"jaeyuel.im" <jaeyuel.im@lge.com>
Subject: [PATCH] dm init: ensure block device is ready before creating mapped device
Date: Thu, 11 Dec 2025 07:34:26 +0000
Message-Id: <20251211073426.123026-1-jaeyuel.im@lge.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
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

Signed-off-by: jaeyuel.im <jaeyuel.im@lge.com>
---
 drivers/md/dm-init.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index ff9420f06483..76b84ca39906 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -299,10 +299,24 @@ static int __init dm_init_init(void)
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
+			while (!(bdev = blkdev_get_no_open(dev)))
+				fsleep(5000);
+			blkdev_put_no_open(bdev);
 		}
 	}
 
-- 
2.34.1


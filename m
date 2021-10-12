Return-Path: <SRS0=6/GL=PA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FC8C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Oct 2021 21:46:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 07ED660F3A
	for <dm-devel@archiver.kernel.org>; Tue, 12 Oct 2021 21:46:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 07ED660F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-3nX0DFf_O0OqhlOJednEHg-1; Tue, 12 Oct 2021 17:46:36 -0400
X-MC-Unique: 3nX0DFf_O0OqhlOJednEHg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43065801A93;
	Tue, 12 Oct 2021 21:46:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2330A60E1C;
	Tue, 12 Oct 2021 21:46:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C8BCE1806D00;
	Tue, 12 Oct 2021 21:46:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19CLjajS020692 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 12 Oct 2021 17:45:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EF9094E623; Tue, 12 Oct 2021 21:45:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB0934E6A2
	for <dm-devel@redhat.com>; Tue, 12 Oct 2021 21:45:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBE53811E7F
	for <dm-devel@redhat.com>; Tue, 12 Oct 2021 21:45:31 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-24-qVmMiQz1NxyMLDydyHFmvg-1; 
	Tue, 12 Oct 2021 17:45:27 -0400
X-MC-Unique: qVmMiQz1NxyMLDydyHFmvg-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B6A060FF2;
	Tue, 12 Oct 2021 21:45:26 +0000 (UTC)
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Tue, 12 Oct 2021 14:43:28 -0700
Message-Id: <20211012214330.40470-3-ebiggers@kernel.org>
In-Reply-To: <20211012214330.40470-1-ebiggers@kernel.org>
References: <20211012214330.40470-1-ebiggers@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Satya Tangirala <satyaprateek2357@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [PATCH v5 2/4] blk-crypto: rename keyslot-manager files
	to blk-crypto-profile
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Eric Biggers <ebiggers@google.com>

In preparation for renaming struct blk_keyslot_manager to struct
blk_crypto_profile, rename the keyslot-manager.h and keyslot-manager.c
source files.  Renaming these files separately before making a lot of
changes to their contents makes it easier for git to understand that
they were renamed.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/Makefile                                            | 2 +-
 block/blk-crypto-fallback.c                               | 2 +-
 block/{keyslot-manager.c => blk-crypto-profile.c}         | 2 +-
 block/blk-crypto.c                                        | 2 +-
 drivers/md/dm-core.h                                      | 2 +-
 drivers/md/dm.c                                           | 2 +-
 drivers/mmc/host/cqhci-crypto.c                           | 2 +-
 drivers/scsi/ufs/ufshcd.h                                 | 2 +-
 include/linux/{keyslot-manager.h => blk-crypto-profile.h} | 0
 include/linux/mmc/host.h                                  | 2 +-
 10 files changed, 9 insertions(+), 9 deletions(-)
 rename block/{keyslot-manager.c => blk-crypto-profile.c} (99%)
 rename include/linux/{keyslot-manager.h => blk-crypto-profile.h} (100%)

diff --git a/block/Makefile b/block/Makefile
index 41aa1ba69c900..c245e05b67453 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -36,6 +36,6 @@ obj-$(CONFIG_BLK_DEBUG_FS)	+= blk-mq-debugfs.o
 obj-$(CONFIG_BLK_DEBUG_FS_ZONED)+= blk-mq-debugfs-zoned.o
 obj-$(CONFIG_BLK_SED_OPAL)	+= sed-opal.o
 obj-$(CONFIG_BLK_PM)		+= blk-pm.o
-obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= keyslot-manager.o blk-crypto.o
+obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
 obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 1bcc1a1514248..08bfea292c754 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -12,9 +12,9 @@
 #include <crypto/skcipher.h>
 #include <linux/blk-cgroup.h>
 #include <linux/blk-crypto.h>
+#include <linux/blk-crypto-profile.h>
 #include <linux/blkdev.h>
 #include <linux/crypto.h>
-#include <linux/keyslot-manager.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/random.h>
diff --git a/block/keyslot-manager.c b/block/blk-crypto-profile.c
similarity index 99%
rename from block/keyslot-manager.c
rename to block/blk-crypto-profile.c
index 1792159d12d18..1a235fa3c3e82 100644
--- a/block/keyslot-manager.c
+++ b/block/blk-crypto-profile.c
@@ -28,7 +28,7 @@
 
 #define pr_fmt(fmt) "blk-crypto: " fmt
 
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 #include <linux/device.h>
 #include <linux/atomic.h>
 #include <linux/mutex.h>
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 103c2e2d50d67..9102803d36232 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -11,7 +11,7 @@
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 55dccdfbcb22e..841ed87999e79 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -13,7 +13,7 @@
 #include <linux/ktime.h>
 #include <linux/genhd.h>
 #include <linux/blk-mq.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 
 #include <trace/events/block.h>
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 95e4e35a5c700..a8cd064f6d643 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -29,7 +29,7 @@
 #include <linux/refcount.h>
 #include <linux/part_stat.h>
 #include <linux/blk-crypto.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 
 #define DM_MSG_PREFIX "core"
 
diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index 6419cfbb4ab78..628bbfaf83124 100644
--- a/drivers/mmc/host/cqhci-crypto.c
+++ b/drivers/mmc/host/cqhci-crypto.c
@@ -6,7 +6,7 @@
  */
 
 #include <linux/blk-crypto.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 #include <linux/mmc/host.h>
 
 #include "cqhci-crypto.h"
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 41f6e06f91856..885fcf2e59224 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -32,7 +32,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/bitfield.h>
 #include <linux/devfreq.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 #include "unipro.h"
 
 #include <asm/irq.h>
diff --git a/include/linux/keyslot-manager.h b/include/linux/blk-crypto-profile.h
similarity index 100%
rename from include/linux/keyslot-manager.h
rename to include/linux/blk-crypto-profile.h
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 0c0c9a0fdf578..725b1de417673 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -15,7 +15,7 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/pm.h>
 #include <linux/dma-direction.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 
 struct mmc_ios {
 	unsigned int	clock;			/* clock rate */
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


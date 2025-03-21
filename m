Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFC91EB19D
	for <dm-devel@lists.linux.dev>; Fri, 21 Mar 2025 07:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541503; cv=none; b=FMde1GuS4/b0SIhKBHJJ9eeXW+us4jlwuhrEuZ804UtTwF2nv7s26FPs/pbVORPmxLRbMvATJB1ynNAAfXSEzD6DuUAz5XiuM+ARJvs/1wBE0mX21sjG9ZNFr+XcLrcGa88bXTfMsmyZ+7YRQcegF1WoraaW2Ryt39FUE5o27yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541503; c=relaxed/simple;
	bh=+BbUh68VqsQ1m7+reX9kP25/MmQ6JJiTqL8zNwXFMTw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G9ywerm0aEi92mtQVJhPndMiqb2lO8j0IxDUGzv5+NVaEhnbMMGf9WEVL4A5nmtKybyP8fn7jwnktlIc83OD8M2Z/h/krHAw6YLhh8/CL4GCMHbSBKdkp1a1xjE9SIiwayzjJ2TjBqe5MmOvowY+wizyMGW0sHbTaTlVoYzexi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZGfyudkN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZGfyudkN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=DvqyUPd88oEFEA9bIxFaska/HKkfImUcdt5/cQaEnos=; b=ZGfyudkNgZ05DxRTRNr/0vgmB0
	DbHBcGoyzjhtS6jy/7vkVx3t4v4q4PK5uC8a5Bx9PRGZS3SuXBBMtEsAGKpGhsk460yklzvv2o8Xc
	3bc6ZVqNBlKdkSDbU2hLwbIQa/DqZMBCYJ5UtK2NIO+p0JhKEwsWf+J9e5BsRF8iMzZsI2hlN+mPU
	mpR2k3NuujHKJNS6ORX8UqamoT9zVRuMJfQq+wJjy0p8adq+9ZZ+SWJ4amgsX+WcQ25fijtXV7ZqE
	l9mkfCmiIVi06uu6Ox7BoUnGBFn/wJonuiW6G/FjcPZgv3q6I7mOOfFs26YGA44tOSkvByYHRk6dn
	MofpZU/w==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWe4-0000000E4uw-1ADL;
	Fri, 21 Mar 2025 07:18:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-delay: support zoned devices
Date: Fri, 21 Mar 2025 08:18:16 +0100
Message-ID: <20250321071816.1674943-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add support for zoned device by passing through report_zoned to the
underlying read device.

This is required to make enable xfstests xfs/311 on zoned devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-delay.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 08f6387620c1..d4cf0ac2a7aa 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -369,6 +369,21 @@ static int delay_map(struct dm_target *ti, struct bio *bio)
 	return delay_bio(dc, c, bio);
 }
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static int delay_report_zones(struct dm_target *ti,
+		struct dm_report_zones_args *args, unsigned int nr_zones)
+{
+	struct delay_c *dc = ti->private;
+	struct delay_class *c = &dc->read;
+
+	return dm_report_zones(c->dev->bdev, c->start,
+			c->start + dm_target_offset(ti, args->next_sector),
+			args, nr_zones);
+}
+#else
+#define delay_report_zones	NULL
+#endif
+
 #define DMEMIT_DELAY_CLASS(c) \
 	DMEMIT("%s %llu %u", (c)->dev->name, (unsigned long long)(c)->start, (c)->delay)
 
@@ -424,11 +439,12 @@ static int delay_iterate_devices(struct dm_target *ti,
 static struct target_type delay_target = {
 	.name	     = "delay",
 	.version     = {1, 4, 0},
-	.features    = DM_TARGET_PASSES_INTEGRITY,
+	.features    = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
 	.module      = THIS_MODULE,
 	.ctr	     = delay_ctr,
 	.dtr	     = delay_dtr,
 	.map	     = delay_map,
+	.report_zones = delay_report_zones,
 	.presuspend  = delay_presuspend,
 	.resume	     = delay_resume,
 	.status	     = delay_status,
-- 
2.45.2


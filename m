Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB65AC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:37:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3BA3364E15
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:37:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BA3364E15
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-oJdzA8JyNZ6ja327yufvlA-1; Wed, 17 Feb 2021 10:37:34 -0500
X-MC-Unique: oJdzA8JyNZ6ja327yufvlA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2A0D835E28;
	Wed, 17 Feb 2021 15:37:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A27742C169;
	Wed, 17 Feb 2021 15:37:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6E59958076;
	Wed, 17 Feb 2021 15:37:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 118AtrOA011353 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 05:55:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A27D42026D13; Mon,  8 Feb 2021 10:55:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DA962026D46
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 10:55:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A9A3800969
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 10:55:53 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-405-zf0FljkTP5SKSAh849WFLA-1;
	Mon, 08 Feb 2021 05:55:51 -0500
X-MC-Unique: zf0FljkTP5SKSAh849WFLA-1
X-IronPort-AV: E=Sophos;i="5.81,161,1610380800"; d="scan'208";a="104328075"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 08 Feb 2021 18:55:47 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 9A5AC4CE6F85;
	Mon,  8 Feb 2021 18:55:43 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
	G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 8 Feb 2021 18:55:45 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 8 Feb 2021 18:55:45 +0800
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Mon, 8 Feb 2021 18:55:28 +0800
Message-ID: <20210208105530.3072869-10-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 9A5AC4CE6F85.ADF44
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: qi.fuli@fujitsu.com, snitzer@redhat.com, darrick.wong@oracle.com,
	rgoldwyn@suse.de, david@fromorbit.com, y-goto@fujitsu.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v3 09/11] md: Implement ->corrupted_range()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

With the support of ->rmap(), it is possible to obtain the superblock on
a mapped device.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 drivers/md/dm.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7bac564f3faa..31b0c340b695 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -507,6 +507,66 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 #define dm_blk_report_zones		NULL
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+struct corrupted_hit_info {
+	struct block_device *bdev;
+	sector_t offset;
+};
+
+static int dm_blk_corrupted_hit(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t count, void *data)
+{
+	struct corrupted_hit_info *bc = data;
+
+	return bc->bdev == (void *)dev->bdev &&
+			(start <= bc->offset && bc->offset < start + count);
+}
+
+struct corrupted_do_info {
+	size_t length;
+	void *data;
+};
+
+static int dm_blk_corrupted_do(struct dm_target *ti, struct block_device *bdev,
+			       sector_t disk_sect, void *data)
+{
+	struct corrupted_do_info *bc = data;
+	loff_t disk_off = to_bytes(disk_sect);
+	loff_t bdev_off = to_bytes(disk_sect - get_start_sect(bdev));
+
+	return bd_corrupted_range(bdev, disk_off, bdev_off, bc->length, bc->data);
+}
+
+static int dm_blk_corrupted_range(struct gendisk *disk,
+				  struct block_device *target_bdev,
+				  loff_t target_offset, size_t len, void *data)
+{
+	struct mapped_device *md = disk->private_data;
+	struct dm_table *map;
+	struct dm_target *ti;
+	sector_t target_sect = to_sector(target_offset);
+	struct corrupted_hit_info hi = {target_bdev, target_sect};
+	struct corrupted_do_info di = {len, data};
+	int srcu_idx, i, rc = -ENODEV;
+
+	map = dm_get_live_table(md, &srcu_idx);
+	if (!map)
+		return rc;
+
+	for (i = 0; i < dm_table_get_num_targets(map); i++) {
+		ti = dm_table_get_target(map, i);
+		if (!(ti->type->iterate_devices && ti->type->rmap))
+			continue;
+		if (!ti->type->iterate_devices(ti, dm_blk_corrupted_hit, &hi))
+			continue;
+
+		rc = ti->type->rmap(ti, target_sect, dm_blk_corrupted_do, &di);
+		break;
+	}
+
+	dm_put_live_table(md, srcu_idx);
+	return rc;
+}
+
 static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 			    struct block_device **bdev)
 {
@@ -3062,6 +3122,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.getgeo = dm_blk_getgeo,
 	.report_zones = dm_blk_report_zones,
 	.pr_ops = &dm_pr_ops,
+	.corrupted_range = dm_blk_corrupted_range,
 	.owner = THIS_MODULE
 };
 
-- 
2.30.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


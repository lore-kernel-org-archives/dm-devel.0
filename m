Return-Path: <SRS0=uf5V=K6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC507C47097
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 06:28:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 900F66140B
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 06:28:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 900F66140B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-Vxk7_-rlOlmRbmNTKr4h4g-1; Fri, 04 Jun 2021 02:28:04 -0400
X-MC-Unique: Vxk7_-rlOlmRbmNTKr4h4g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16EB21883527;
	Fri,  4 Jun 2021 06:28:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDE4A60CC9;
	Fri,  4 Jun 2021 06:27:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C1F4A44A59;
	Fri,  4 Jun 2021 06:27:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1541Kn8c026862 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Jun 2021 21:20:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 402BF21144D1; Fri,  4 Jun 2021 01:20:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 368DE2114DD6
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 01:20:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08DE6919823
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 01:20:47 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-339-ceCrmAVxPGqqC4xYPHPzww-1;
	Thu, 03 Jun 2021 21:20:43 -0400
X-MC-Unique: ceCrmAVxPGqqC4xYPHPzww-1
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AoySG86mbvXdBRFbyJo4BYTZBOT/pDfJJ3DAb?=
	=?us-ascii?q?v31ZSRFFG/Fw9vrPoB1173LJYVoqMk3I+urgBEDjexzhHPdOiOF7AV7LZniEhI?=
	=?us-ascii?q?LCFu1fBOXZrQHdJw=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.83,246,1616428800"; d="scan'208";a="109209833"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 04 Jun 2021 09:19:37 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 0F1214C36A00;
	Fri,  4 Jun 2021 09:19:35 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
	G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Fri, 4 Jun 2021 09:19:35 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Fri, 4 Jun 2021 09:19:13 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Fri, 4 Jun 2021 09:18:42 +0800
Message-ID: <20210604011844.1756145-9-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 0F1214C36A00.A4EB9
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
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
X-Mailman-Approved-At: Fri, 04 Jun 2021 02:21:36 -0400
Cc: snitzer@redhat.com, darrick.wong@oracle.com, rgoldwyn@suse.de,
	david@fromorbit.com, dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v4 08/10] md: Implement dax_holder_operations
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

This is the case where the holder represents a mapped device, or a list
of mapped devices more exactly(because it is possible to create more
than one mapped device on one pmem device).

Find out which mapped device the offset belongs to, and translate the
offset from target device to mapped device.  When it is done, call
dax_corrupted_range() for the holder of this mapped device.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 drivers/md/dm.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca2aedd8ee7d..606ad74ccf87 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -749,7 +749,11 @@ static void dm_put_live_table_fast(struct mapped_device *md) __releases(RCU)
 }
 
 static char *_dm_claim_ptr = "I belong to device-mapper";
-
+static const struct dax_holder_operations dm_dax_holder_ops;
+struct dm_holder {
+	struct list_head list;
+	struct mapped_device *md;
+};
 /*
  * Open a table device so we can use it as a map destination.
  */
@@ -757,6 +761,8 @@ static int open_table_device(struct table_device *td, dev_t dev,
 			     struct mapped_device *md)
 {
 	struct block_device *bdev;
+	struct list_head *holders;
+	struct dm_holder *holder;
 
 	int r;
 
@@ -774,6 +780,17 @@ static int open_table_device(struct table_device *td, dev_t dev,
 
 	td->dm_dev.bdev = bdev;
 	td->dm_dev.dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+
+	holders = dax_get_holder(td->dm_dev.dax_dev);
+	if (!holders) {
+		holders = kmalloc(sizeof(*holders), GFP_KERNEL);
+		INIT_LIST_HEAD(holders);
+		dax_set_holder(td->dm_dev.dax_dev, holders, &dm_dax_holder_ops);
+	}
+	holder = kmalloc(sizeof(*holder), GFP_KERNEL);
+	holder->md = md;
+	list_add_tail(&holder->list, holders);
+
 	return 0;
 }
 
@@ -782,9 +799,24 @@ static int open_table_device(struct table_device *td, dev_t dev,
  */
 static void close_table_device(struct table_device *td, struct mapped_device *md)
 {
+	struct list_head *holders;
+	struct dm_holder *holder, *n;
+
 	if (!td->dm_dev.bdev)
 		return;
 
+	holders = dax_get_holder(td->dm_dev.dax_dev);
+	if (holders) {
+		list_for_each_entry_safe(holder, n, holders, list) {
+			if (holder->md == md) {
+				list_del(&holder->list);
+				kfree(holder);
+			}
+		}
+		if (list_empty(holders))
+			kfree(holders);
+	}
+
 	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
 	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
 	put_dax(td->dm_dev.dax_dev);
@@ -1235,6 +1267,87 @@ static int dm_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 	return ret;
 }
 
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
+			       sector_t sector, void *data)
+{
+	struct mapped_device *md = ti->table->md;
+	struct corrupted_do_info *bc = data;
+	struct block_device *md_bdev = bdget_disk_sector(md->disk, sector);
+
+	return dax_corrupted_range(md->dax_dev, md_bdev, to_bytes(sector),
+				   bc->length, bc->data);
+}
+
+static int dm_dax_corrputed_range_one(struct mapped_device *md,
+				      struct block_device *bdev, loff_t offset,
+				      size_t length, void *data)
+{
+	struct dm_table *map;
+	struct dm_target *ti;
+	sector_t sect = to_sector(offset);
+	struct corrupted_hit_info hi = {bdev, sect};
+	struct corrupted_do_info di = {length, data};
+	int srcu_idx, i, rc = -ENODEV;
+
+	map = dm_get_live_table(md, &srcu_idx);
+	if (!map)
+		return rc;
+
+	/*
+	 * find the target device, and then translate the offset of this target
+	 * to the whole mapped device.
+	 */
+	for (i = 0; i < dm_table_get_num_targets(map); i++) {
+		ti = dm_table_get_target(map, i);
+		if (!(ti->type->iterate_devices && ti->type->rmap))
+			continue;
+		if (!ti->type->iterate_devices(ti, dm_blk_corrupted_hit, &hi))
+			continue;
+
+		rc = ti->type->rmap(ti, sect, dm_blk_corrupted_do, &di);
+		break;
+	}
+
+	dm_put_live_table(md, srcu_idx);
+	return rc;
+}
+
+static int dm_dax_corrputed_range(struct dax_device *dax_dev,
+				  struct block_device *bdev,
+				  loff_t offset, size_t length, void *data)
+{
+	struct dm_holder *holder;
+	struct list_head *holders = dax_get_holder(dax_dev);
+	int rc = -ENODEV;
+
+	list_for_each_entry(holder, holders, list) {
+		rc = dm_dax_corrputed_range_one(holder->md, bdev, offset,
+						length, data);
+		if (rc != -ENODEV)
+			break;
+	}
+	return rc;
+}
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_RESET,
@@ -3157,6 +3270,10 @@ static const struct dax_operations dm_dax_ops = {
 	.zero_page_range = dm_dax_zero_page_range,
 };
 
+static const struct dax_holder_operations dm_dax_holder_ops = {
+	.corrupted_range = dm_dax_corrputed_range,
+};
+
 /*
  * module hooks
  */
-- 
2.31.1



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEFEC49EAB
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 083A861C62
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 083A861C62
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-cv0n6uvnOSC5KVWOqiRZUg-1; Mon, 28 Jun 2021 05:53:04 -0400
X-MC-Unique: cv0n6uvnOSC5KVWOqiRZUg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06A441084F57;
	Mon, 28 Jun 2021 09:52:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFB57694D6;
	Mon, 28 Jun 2021 09:52:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9992F4EA3D;
	Mon, 28 Jun 2021 09:52:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15S03aMM027103 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 27 Jun 2021 20:03:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 436EC43680; Mon, 28 Jun 2021 00:03:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E6B7814B
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E93799676E1
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:32 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-88-gAyhb5iyMvu802l6ObRnNw-3; 
	Sun, 27 Jun 2021 20:03:29 -0400
X-MC-Unique: gAyhb5iyMvu802l6ObRnNw-3
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AzsiqNai/4NpkHqZpZqe0lXFt43BQXjwji2hC?=
	=?us-ascii?q?6mlwRA09TySZ//rOoB19726MtN9xYgBZpTnuAtjifZqxz/FICMwqTNOftWrdyQ?=
	=?us-ascii?q?2VxeNZnOnfKlTbckWUnIMw6U4jSdkYNDSaNzhHZKjBjjVQa+xQpeVv7prY+dv2?=
	=?us-ascii?q?/jN8Sx1wcaF840NcAgafKEd/Qw5LHvMCZeChz/sCtzy9Ym4Wc8j+InEEWtLIr9?=
	=?us-ascii?q?rNmImjTgUBA3ccmXSzpALt+LjnCAKZwxtbdztOxI0p+W/Dnxe8xojLiYDB9iPh?=
X-IronPort-AV: E=Sophos;i="5.83,304,1616428800"; d="scan'208";a="110256402"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 28 Jun 2021 08:03:28 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id EC3084D0BA67;
	Mon, 28 Jun 2021 08:03:22 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
	G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 28 Jun 2021 08:03:13 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 28 Jun 2021 08:03:13 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Mon, 28 Jun 2021 08:02:17 +0800
Message-ID: <20210628000218.387833-9-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: EC3084D0BA67.A17F2
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 28 Jun 2021 05:52:34 -0400
Cc: snitzer@redhat.com, darrick.wong@oracle.com, rgoldwyn@suse.de,
	david@fromorbit.com, dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v5 8/9] md: Implement dax_holder_operations
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 drivers/md/dm.c | 126 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 125 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca2aedd8ee7d..11c9de0eca6d 100644
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

@@ -774,6 +780,19 @@ static int open_table_device(struct table_device *td, dev_t dev,

 	td->dm_dev.bdev = bdev;
 	td->dm_dev.dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+	if (!td->dm_dev.dax_dev)
+		return 0;
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

@@ -782,9 +801,27 @@ static int open_table_device(struct table_device *td, dev_t dev,
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
+		if (list_empty(holders)) {
+			kfree(holders);
+			/* unset dax_device's holder_data */
+			dax_set_holder(td->dm_dev.dax_dev, NULL, NULL);
+		}
+	}
+
 	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
 	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
 	put_dax(td->dm_dev.dax_dev);
@@ -1235,6 +1272,89 @@ static int dm_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 	return ret;
 }

+#if IS_ENABLED(CONFIG_DAX_DRIVER)
+struct corrupted_hit_info {
+	struct dax_device *dax_dev;
+	sector_t offset;
+};
+
+static int dm_blk_corrupted_hit(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t count, void *data)
+{
+	struct corrupted_hit_info *bc = data;
+
+	return bc->dax_dev == (void *)dev->dax_dev &&
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
+
+	return dax_holder_notify_failure(md->dax_dev, to_bytes(sector),
+					 bc->length, bc->data);
+}
+
+static int dm_dax_notify_failure_one(struct mapped_device *md,
+				     struct dax_device *dax_dev,
+				     loff_t offset, size_t length, void *data)
+{
+	struct dm_table *map;
+	struct dm_target *ti;
+	sector_t sect = to_sector(offset);
+	struct corrupted_hit_info hi = {dax_dev, sect};
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
+static int dm_dax_notify_failure(struct dax_device *dax_dev,
+				 loff_t offset, size_t length, void *data)
+{
+	struct dm_holder *holder;
+	struct list_head *holders = dax_get_holder(dax_dev);
+	int rc = -ENODEV;
+
+	list_for_each_entry(holder, holders, list) {
+		rc = dm_dax_notify_failure_one(holder->md, dax_dev, offset,
+					       length, data);
+		if (rc != -ENODEV)
+			break;
+	}
+	return rc;
+}
+#else
+#define dm_dax_notify_failure NULL
+#endif
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_RESET,
@@ -3157,6 +3277,10 @@ static const struct dax_operations dm_dax_ops = {
 	.zero_page_range = dm_dax_zero_page_range,
 };

+static const struct dax_holder_operations dm_dax_holder_ops = {
+	.notify_failure = dm_dax_notify_failure,
+};
+
 /*
  * module hooks
  */
--
2.32.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0621AC47086
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 984356138C
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 984356138C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-YiKjMC4yO-e1gXeZg4kwBQ-1; Tue, 25 May 2021 17:25:23 -0400
X-MC-Unique: YiKjMC4yO-e1gXeZg4kwBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F316107ACE6;
	Tue, 25 May 2021 21:25:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09D82163E2;
	Tue, 25 May 2021 21:25:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C3D4D180102A;
	Tue, 25 May 2021 21:25:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PLPFXM003312 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 17:25:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8143320148E7; Tue, 25 May 2021 21:25:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BEA9200FA7C
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFB621825061
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:14 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-140-pudP8aNQMJmMnaEyNmKgMQ-4; Tue, 25 May 2021 17:25:12 -0400
X-MC-Unique: pudP8aNQMJmMnaEyNmKgMQ-4
IronPort-SDR: ya7ST94i+OcpPYCFLFJqxOhNA1RcbWVXUdobHxbf1LrCIENCSXRbhkRG4Tc3VE2f7VnbSb8k7t
	rpZqMr7OINiAuDynPFzD3tkY6FKaUE7qAsgnFnaMhPRd/6k+8xlAkec7ebPFIOCr58FonwoFOS
	lN7kFk8WZ7lUXchhcnvpUPdJeZ/mZuVk1xHHFvtcUzDcKLGwnaKJYaMYRXv1xD/m5karjr3lO0
	ZM/45VfdqOrBiYkJiyZHJQrwZ8wg+WM7otBKE0ix3VFoYxgje6cfqnG3+4n2vLuluBEKoUPS0m
	rpA=
X-IronPort-AV: E=Sophos;i="5.82,329,1613404800"; d="scan'208";a="168717527"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 26 May 2021 05:25:11 +0800
IronPort-SDR: mLaI7MAU5IRstELj8zfzngrb7yFUcqfAFuJ9D8QPTuTBCxihQGPcRKhzoO2XwuzlOX2vj/e5q8
	gV1JMV0cO3zAbvtzNrGsDhyumFYPjZX2c1V9UYrbL0vTomGuITVHQoD/YGWF9/pZZcmr8VVJnK
	xfNXFe172di15l8c6pwTIZOxCaLlYheTrUV3kZ1LENG4Yrg8TzNF6fLXf6hSq08ZU9oU27oWmA
	JkZEqfMq0c6HBVGGOFHXA3rPJLrzCFq3b/ZrxUTVnRaP83bIcKwRQ/oneBf8sEEw4eknsyAf2l
	1oIqjkf6N1i4647Fp3HLoH3K
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	25 May 2021 14:03:21 -0700
IronPort-SDR: nVgte37Yi4En00VqZY7CHg2Ck5Zja5zDiLxN7bmoDn3lgi8jozlu5qA8xlNQAX5otyotwy1POE
	wnrIvT7XFaXuTBNZxG7fsW8uCP0TMiKZcQDtliy1743VHxaoDvP2Gx6m0meCu9O76DPSMK8l+0
	MzWMj+2KOi2rXRqf5QzQBuqNZgTYV+s0Hx0OrNzwmHb5lU9HeRKR4MDvrpV016vKyKG/nSxeJB
	e1nrWZZ7AlTUe3JjnTdkPl2PkCyJGiRGObKSLN4V2G3CzCjdmgR8SY4yVdCUEMfbYWqL1Fw1MW
	bnw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 25 May 2021 14:25:11 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 26 May 2021 06:24:56 +0900
Message-Id: <20210525212501.226888-7-damien.lemoal@wdc.com>
In-Reply-To: <20210525212501.226888-1-damien.lemoal@wdc.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v5 06/11] dm: move zone related code to dm-zone.c
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move core and table code used for zoned targets and conditionally
defined with #ifdef CONFIG_BLK_DEV_ZONED to the new file dm-zone.c.
This file is conditionally compiled depending on CONFIG_BLK_DEV_ZONED.
The small helper dm_set_zones_restrictions() is introduced to
initialize a mapped device request queue zone attributes in
dm_table_set_restrictions().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/md/Makefile   |   4 ++
 drivers/md/dm-table.c |  14 ++----
 drivers/md/dm-zone.c  | 102 ++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c       |  78 --------------------------------
 drivers/md/dm.h       |  11 +++++
 5 files changed, 120 insertions(+), 89 deletions(-)
 create mode 100644 drivers/md/dm-zone.c

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index ef7ddc27685c..a74aaf8b1445 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -92,6 +92,10 @@ ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
 endif
 
+ifeq ($(CONFIG_BLK_DEV_ZONED),y)
+dm-mod-objs			+= dm-zone.o
+endif
+
 ifeq ($(CONFIG_DM_VERITY_FEC),y)
 dm-verity-objs			+= dm-verity-fec.o
 endif
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 21fd9cd4da32..dd9f648ab598 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2064,17 +2064,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	    dm_table_any_dev_attr(t, device_is_not_random, NULL))
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
 
-	/*
-	 * For a zoned target, the number of zones should be updated for the
-	 * correct value to be exposed in sysfs queue/nr_zones. For a BIO based
-	 * target, this is all that is needed.
-	 */
-#ifdef CONFIG_BLK_DEV_ZONED
-	if (blk_queue_is_zoned(q)) {
-		WARN_ON_ONCE(queue_is_mq(q));
-		q->nr_zones = blkdev_nr_zones(t->md->disk);
-	}
-#endif
+	/* For a zoned target, setup the zones related queue attributes */
+	if (blk_queue_is_zoned(q))
+		dm_set_zones_restrictions(t, q);
 
 	dm_update_keyslot_manager(q, t);
 	blk_queue_update_readahead(q);
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
new file mode 100644
index 000000000000..3243c42b7951
--- /dev/null
+++ b/drivers/md/dm-zone.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ */
+
+#include <linux/blkdev.h>
+
+#include "dm-core.h"
+
+/*
+ * User facing dm device block device report zone operation. This calls the
+ * report_zones operation for each target of a device table. This operation is
+ * generally implemented by targets using dm_report_zones().
+ */
+int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
+			unsigned int nr_zones, report_zones_cb cb, void *data)
+{
+	struct mapped_device *md = disk->private_data;
+	struct dm_table *map;
+	int srcu_idx, ret;
+	struct dm_report_zones_args args = {
+		.next_sector = sector,
+		.orig_data = data,
+		.orig_cb = cb,
+	};
+
+	if (dm_suspended_md(md))
+		return -EAGAIN;
+
+	map = dm_get_live_table(md, &srcu_idx);
+	if (!map) {
+		ret = -EIO;
+		goto out;
+	}
+
+	do {
+		struct dm_target *tgt;
+
+		tgt = dm_table_find_target(map, args.next_sector);
+		if (WARN_ON_ONCE(!tgt->type->report_zones)) {
+			ret = -EIO;
+			goto out;
+		}
+
+		args.tgt = tgt;
+		ret = tgt->type->report_zones(tgt, &args,
+					      nr_zones - args.zone_idx);
+		if (ret < 0)
+			goto out;
+	} while (args.zone_idx < nr_zones &&
+		 args.next_sector < get_capacity(disk));
+
+	ret = args.zone_idx;
+out:
+	dm_put_live_table(md, srcu_idx);
+	return ret;
+}
+
+int dm_report_zones_cb(struct blk_zone *zone, unsigned int idx, void *data)
+{
+	struct dm_report_zones_args *args = data;
+	sector_t sector_diff = args->tgt->begin - args->start;
+
+	/*
+	 * Ignore zones beyond the target range.
+	 */
+	if (zone->start >= args->start + args->tgt->len)
+		return 0;
+
+	/*
+	 * Remap the start sector and write pointer position of the zone
+	 * to match its position in the target range.
+	 */
+	zone->start += sector_diff;
+	if (zone->type != BLK_ZONE_TYPE_CONVENTIONAL) {
+		if (zone->cond == BLK_ZONE_COND_FULL)
+			zone->wp = zone->start + zone->len;
+		else if (zone->cond == BLK_ZONE_COND_EMPTY)
+			zone->wp = zone->start;
+		else
+			zone->wp += sector_diff;
+	}
+
+	args->next_sector = zone->start + zone->len;
+	return args->orig_cb(zone, args->zone_idx++, args->orig_data);
+}
+EXPORT_SYMBOL_GPL(dm_report_zones_cb);
+
+void dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
+{
+	if (!blk_queue_is_zoned(q))
+		return;
+
+	/*
+	 * For a zoned target, the number of zones should be updated for the
+	 * correct value to be exposed in sysfs queue/nr_zones. For a BIO based
+	 * target, this is all that is needed.
+	 */
+	WARN_ON_ONCE(queue_is_mq(q));
+	q->nr_zones = blkdev_nr_zones(t->md->disk);
+}
+
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 11af20080639..c49976cc4e44 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -444,84 +444,6 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return dm_get_geometry(md, geo);
 }
 
-#ifdef CONFIG_BLK_DEV_ZONED
-int dm_report_zones_cb(struct blk_zone *zone, unsigned int idx, void *data)
-{
-	struct dm_report_zones_args *args = data;
-	sector_t sector_diff = args->tgt->begin - args->start;
-
-	/*
-	 * Ignore zones beyond the target range.
-	 */
-	if (zone->start >= args->start + args->tgt->len)
-		return 0;
-
-	/*
-	 * Remap the start sector and write pointer position of the zone
-	 * to match its position in the target range.
-	 */
-	zone->start += sector_diff;
-	if (zone->type != BLK_ZONE_TYPE_CONVENTIONAL) {
-		if (zone->cond == BLK_ZONE_COND_FULL)
-			zone->wp = zone->start + zone->len;
-		else if (zone->cond == BLK_ZONE_COND_EMPTY)
-			zone->wp = zone->start;
-		else
-			zone->wp += sector_diff;
-	}
-
-	args->next_sector = zone->start + zone->len;
-	return args->orig_cb(zone, args->zone_idx++, args->orig_data);
-}
-EXPORT_SYMBOL_GPL(dm_report_zones_cb);
-
-static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
-		unsigned int nr_zones, report_zones_cb cb, void *data)
-{
-	struct mapped_device *md = disk->private_data;
-	struct dm_table *map;
-	int srcu_idx, ret;
-	struct dm_report_zones_args args = {
-		.next_sector = sector,
-		.orig_data = data,
-		.orig_cb = cb,
-	};
-
-	if (dm_suspended_md(md))
-		return -EAGAIN;
-
-	map = dm_get_live_table(md, &srcu_idx);
-	if (!map) {
-		ret = -EIO;
-		goto out;
-	}
-
-	do {
-		struct dm_target *tgt;
-
-		tgt = dm_table_find_target(map, args.next_sector);
-		if (WARN_ON_ONCE(!tgt->type->report_zones)) {
-			ret = -EIO;
-			goto out;
-		}
-
-		args.tgt = tgt;
-		ret = tgt->type->report_zones(tgt, &args,
-					      nr_zones - args.zone_idx);
-		if (ret < 0)
-			goto out;
-	} while (args.zone_idx < nr_zones &&
-		 args.next_sector < get_capacity(disk));
-
-	ret = args.zone_idx;
-out:
-	dm_put_live_table(md, srcu_idx);
-	return ret;
-}
-#else
-#define dm_blk_report_zones		NULL
-#endif /* CONFIG_BLK_DEV_ZONED */
-
 static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 			    struct block_device **bdev)
 {
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index b441ad772c18..fdf1536a4b62 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -100,6 +100,17 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
  */
 #define dm_target_hybrid(t) (dm_target_bio_based(t) && dm_target_request_based(t))
 
+/*
+ * Zoned targets related functions.
+ */
+void dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q);
+#ifdef CONFIG_BLK_DEV_ZONED
+int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
+			unsigned int nr_zones, report_zones_cb cb, void *data);
+#else
+#define dm_blk_report_zones	NULL
+#endif
+
 /*-----------------------------------------------------------------
  * A registry of target types.
  *---------------------------------------------------------------*/
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


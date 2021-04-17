Return-Path: <SRS0=ANAI=JO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CB1C433ED
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 02:34:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A667C61107
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 02:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A667C61107
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-NNYBeYm_MRODyq0PMu7TJw-1; Fri, 16 Apr 2021 22:34:15 -0400
X-MC-Unique: NNYBeYm_MRODyq0PMu7TJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B416E81425A;
	Sat, 17 Apr 2021 02:34:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 935FE61141;
	Sat, 17 Apr 2021 02:34:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 675761806D15;
	Sat, 17 Apr 2021 02:34:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13H2Y9pk031503 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 22:34:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B05282138CF3; Sat, 17 Apr 2021 02:34:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58BB92138CF6
	for <dm-devel@redhat.com>; Sat, 17 Apr 2021 02:34:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 046C681C962
	for <dm-devel@redhat.com>; Sat, 17 Apr 2021 02:34:07 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-160-DaY39sxMPomMqpxkdb5yBQ-2; Fri, 16 Apr 2021 22:33:28 -0400
X-MC-Unique: DaY39sxMPomMqpxkdb5yBQ-2
IronPort-SDR: hNPn+bm/+peG+Qxbj/nDOfeTMk2l5dKLt61z+s+X7q76mXGZ59gLkSOiZUQW43bRpM5OE4TY16
	uImk4g1dP1mmhTGevd+M9qIDOiefGmYtNN8C7XFNU3NoFVxqTR/lrhDwQV2feHz55gzXS/SOBq
	D2JkvvHxG71a21PXtbDvc5hzqU8OhZYAoYkjXLogQWW1VagphrTFTXpf3hIl07maF+LWWyUXyZ
	QRZhX+VuoOQUzswoSRJ5vtaNWMFMRIdOk4kBhS7QXFdRphzKitX1F2ESsaXooc9lmYJZU8P0EX
	8Z8=
X-IronPort-AV: E=Sophos;i="5.82,228,1613404800"; d="scan'208";a="164553496"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 17 Apr 2021 10:33:28 +0800
IronPort-SDR: ghTD4EIz1WfyxMpVevXE4Q9mpR7mp0rnAoJ3y3MNgys4K1LCGni+INVue7eacBdlP7NgSoHQ8d
	Mv6iNfeUOmY2rS0rkpCQduQkY9EJn9TiRfE1BhXZ5Y5OYkKCXF5dE5j/oH5ceH7r3nyLB1RXeX
	ks7ub5PLMedDnBeAJxrzNe1Nb+0vBCc0I5e3J0qSiY+QW/LX4h+Lxtt4SlIeL9wRzaTa9rPg1j
	lanJOgLrMsslDPJX/Vmn0HSe+yroUNJuYp5SmGkOBZ1ZQ61MrdvrGtZQDJ/5OKo0kC1l0ElcUS
	5HS0QrhFsRNmqGPXtZ/pqYB4
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	16 Apr 2021 19:14:16 -0700
IronPort-SDR: UQflehws6aKDT+mFZ2nVQiUGb2lRUwWiMuBTx9jxGjceks+o06GOUReKHZ5fkVXjt7Kj5B/CZy
	Mp0Ws+qZfN+7WYGWYst3lEYumdIWJKlDCPxHvhR3q+AOWEUrWg4EIcgZ9stY6RgD8+AuNB0WNW
	xHduyhNolA7A+ImExw3mcQc08lDB9cUDyKFHP0pqsXMA73uC5RH42QEgfkZ4eBaL6/Q078vJpu
	wh5OcUneAqZuDkBjpm6TDPxIE0bhp4yo+cURINauqGwoe8qeHV11jqbhnar9TCvep01s+iLBkl
	cKw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 16 Apr 2021 19:33:27 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org
Date: Sat, 17 Apr 2021 11:33:21 +0900
Message-Id: <20210417023323.852530-2-damien.lemoal@wdc.com>
In-Reply-To: <20210417023323.852530-1-damien.lemoal@wdc.com>
References: <20210417023323.852530-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [dm-devel] [PATCH v2 1/3] dm: Introduce zone append support control
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

Add the boolean field zone_append_not_supported to the dm_target
structure to allow a target implementing a zoned block device to
explicitly opt out from zone append (REQ_OP_ZONE_APPEND) operations
support. When set to true by the target constructor, the target device
queue limit max_zone_append_sectors is set to 0 in
dm_table_set_restrictions() so that users of the target (e.g. file
systems) can detect that the device cannot process zone append
operations.

Detection for the target support of zone append is done similarly to
the detection for other device features such as secure erase, using a
helper function. For zone append, the function
dm_table_supports_zone_append() is defined if CONFIG_BLK_DEV_ZONED is
enabled.

Fixes: 8e225f04d2dd ("dm crypt: Enable zoned block device support")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm-table.c         | 41 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  6 +++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e5f0f1703c5d..9efd7a0ee27e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1999,6 +1999,37 @@ static int device_requires_stable_pages(struct dm_target *ti,
 	return blk_queue_stable_writes(q);
 }
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static int device_not_zone_append_capable(struct dm_target *ti,
+					  struct dm_dev *dev, sector_t start,
+					  sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return !blk_queue_is_zoned(q) ||
+		!q->limits.max_zone_append_sectors;
+}
+
+static bool dm_table_supports_zone_append(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (ti->zone_append_not_supported)
+			return false;
+
+		if (!ti->type->iterate_devices ||
+		    ti->type->iterate_devices(ti, device_not_zone_append_capable, NULL))
+			return false;
+	}
+
+	return true;
+}
+#endif
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -2091,6 +2122,16 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (blk_queue_is_zoned(q)) {
 		WARN_ON_ONCE(queue_is_mq(q));
 		q->nr_zones = blkdev_nr_zones(t->md->disk);
+
+		/*
+		 * All zoned devices support zone append by default. However,
+		 * some zoned targets (e.g. dm-crypt) cannot support this
+		 * operation. Check here if the target indicated the lack of
+		 * support for zone append and set max_zone_append_sectors to 0
+		 * in that case so that users (e.g. an FS) can detect this fact.
+		 */
+		if (!dm_table_supports_zone_append(t))
+			q->limits.max_zone_append_sectors = 0;
 	}
 #endif
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 5c641f930caf..4da699add262 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -361,6 +361,12 @@ struct dm_target {
 	 * Set if we need to limit the number of in-flight bios when swapping.
 	 */
 	bool limit_swap_bios:1;
+
+	/*
+	 * Set if this target is a zoned device that cannot accept
+	 * zone append operations.
+	 */
+	bool zone_append_not_supported:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


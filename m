Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED02C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 03:06:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A9CB66113D
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 03:06:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9CB66113D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-A-zZzqheO0eO72_oUmoVeg-1; Thu, 15 Apr 2021 23:06:39 -0400
X-MC-Unique: A-zZzqheO0eO72_oUmoVeg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF350107ACC7;
	Fri, 16 Apr 2021 03:06:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1EA762A0E;
	Fri, 16 Apr 2021 03:06:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6402B44A5F;
	Fri, 16 Apr 2021 03:06:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G36WSB030635 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 23:06:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8B36221111CB; Fri, 16 Apr 2021 03:06:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 854D321111C6
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 03:06:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EEB0805F47
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 03:06:29 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-15-N151JL9dNiySnksFQgJCvA-1; Thu, 15 Apr 2021 23:06:27 -0400
X-MC-Unique: N151JL9dNiySnksFQgJCvA-1
IronPort-SDR: ZlRxeiiiCdcDq/gwvo9/F6wjo0q56rcfr6v4PuDshpPyHqiLlES/GGCyYm9DPHIAy01r+SBoMI
	qtBH79z7W3Tnt1Bg8FhAjWguXvMnhcXJv0GAiKkVX077wr/HCzRQ01uWKDPYmYJKg/i1katy6w
	Ws9jn2Zymx4DFJkhBe5ARw1fu/LpxgboKsXsGx4gzaFIr/2F+1Cte+IZmKctunmiJcNGwgNcxo
	rfnxMPGReW2DVgNLQl25m6NOMIrwuW+tAr8WU8NbfkoygGYS/d2SgbdEvWEgVx7GLh3SjD6GsE
	0Wc=
X-IronPort-AV: E=Sophos;i="5.82,226,1613404800"; d="scan'208";a="165604474"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2021 11:06:08 +0800
IronPort-SDR: QmInBP3u3HzQUsL1Vg2kP2uxJbqjbWR2elUKSKdtFDn/LjUv/6gpkU0Mr42+T8GqaSI5DnVS5S
	B0GAY3qlgbPGxWGzj7JmbuOXAKWCHnMGuQYeGuF0WhVfUhulV+genZG5HoS7y873fz7wghsU9W
	f2fGdhHqEl53WKLqxK8iynPYgBQHRj9lDesUkKNIX0RZzuXHY+WKqXRcuRaTnjmwtB+cxeiTOx
	/sYT3UEx5AvUjDNlw1wAHoNvWkoJkQkJkeHwh8YMcW3d5eUzYNBFR4Nu9S5IouewboL5nb6wZ+
	SzcZtxUOnqVcDx5xRB8L3DZS
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	15 Apr 2021 19:46:32 -0700
IronPort-SDR: XeFcQprEuAFYDJO6DpiQxcsC7N+LCT2SR+Mu5LEf4Xaflth/DDQwNi/0LW5UM7TnbJeuRqTSwF
	A2caLaeVJPDIYpfpbqPdd+zoeTtgjcmwbGRtXPz+zFA/vSzLCL5oDZB1U1YXfv4rUoljrjQEml
	/GhFt+gXWizqvsuzIuD6xmX3mwwUI6vOaANrC/xXYqaNcz/AyDVJCnaZPyBki04K2v/eRMhvDK
	QTOVUkM8S+NS7fijSsafqxW0t+EdNdG09b4gvBZhddV08G/EQ+6pPc6oENmirSES3hRM8Xy5PG
	Eqo=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 15 Apr 2021 20:05:37 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>
Date: Fri, 16 Apr 2021 12:05:27 +0900
Message-Id: <20210416030528.757513-4-damien.lemoal@wdc.com>
In-Reply-To: <20210416030528.757513-1-damien.lemoal@wdc.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
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
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: [dm-devel] [PATCH 3/4] btrfs: zoned: fail mount if the device does
	not support zone append
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

For zoned btrfs, zone append is mandatory to write to a sequential write
only zone, otherwise parallel writes to the same zone could result in
unaligned write errors.

If a zoned block device does not support zone append (e.g. a dm-crypt
zoned device using a non-NULL IV cypher), fail to mount.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 fs/btrfs/zoned.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index eeb3ebe11d7a..70b23a0d03b1 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -342,6 +342,13 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 
+	if (bdev_is_zoned(bdev) && zone_info->max_zone_append_size == 0) {
+		btrfs_err(fs_info, "zoned: device %pg does not support zone append",
+			  bdev);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	zone_info->seq_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
 	if (!zone_info->seq_zones) {
 		ret = -ENOMEM;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


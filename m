Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EB9C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:23:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9A101611BD
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:23:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A101611BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-Y_WYNLXgOT2bzp5wHXjPHQ-1; Thu, 20 May 2021 00:23:08 -0400
X-MC-Unique: Y_WYNLXgOT2bzp5wHXjPHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09BD38042A8;
	Thu, 20 May 2021 04:23:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAA25687F5;
	Thu, 20 May 2021 04:23:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE00A180B763;
	Thu, 20 May 2021 04:23:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K4MhFS005807 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 00:22:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9F254209D0F8; Thu, 20 May 2021 04:22:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9908F209A81D
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D90999124D7
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:40 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-595-VQH05Ob8MPecZD0DcPLczw-3; Thu, 20 May 2021 00:22:36 -0400
X-MC-Unique: VQH05Ob8MPecZD0DcPLczw-3
IronPort-SDR: o/cTpXBNvF0/bQzD6sDij2HjbCtkeyeDYHC9TVXKoAgOaO6ssPDiYrNUDfVqL52A764Qml+lXS
	4oSq+ux9fG0RJfFTq9lEpr0q4WACCqa0R4DMnC2GOPAYxZNgYLwq/CY/C/iG/Bh5QSYOCfT1H9
	052k8NHA3ptQ+sTql6Eg8q32GB6/qi/oFQ/0j8iDMWzLr6nOfdACKKL82nd7GaGah4dpNbuaZU
	5oW96afQsDiMC6+uGiUQEi1fo8TJU8Tzy77wnTLXAQCGIOHzHqGbLuJqgEGoc2VoNqZEDP434W
	EVA=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="169343194"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 12:22:36 +0800
IronPort-SDR: 2vKdhhnGATkQQnxvjLxIsllwucyZAQkaR8l+xBiCeHQ0rWX9IVKawh9tWxcHJPiLWNjbQsnvPl
	1XBBeipsYFQu0zE+zxW5D6L3rkTZNSyNyeTWK2CFWMMjtS/JcADsJJnOauNVzhdkS7NI9HQ9YQ
	JpUH9hqaM3Ksc50zsiQZHDxyd1un+4AtNbLtA+wS1VNJTWETF149vw/4Rpwi/WvSmv3twr2rqA
	AA+dxUDijtdGaV15WJv/Quq9BukIZMtzxPSckk8F+HZtYSaGUYA1BaSkuLWK3d1dxNz8w3OTD4
	kFyHOY0P0OFA2GNWAI+y5rKn
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	19 May 2021 21:00:59 -0700
IronPort-SDR: 6kNOHqXrru0/CddEeEBMWKY14E7If5+84cgNhp8D/5XGKZ1yOqXB0WBBrgGWbvYPZOK+iFtJ+c
	ooqEd9ivvptwZC9IGLDSl8/FAlzAn4Yjl+FJo45XtC3jxbQwsgZxlI6/AqwrbttYhJQMA57B4W
	ufs6e8zTLtxqhchXNUNfyexTCivuTA86KhbCytPVZXZQgtYLHu9QC8IyENgm48Iao7GY1utEpQ
	U7wfIAH1A4EYDVQxH8V0nsBcfkuQ+/YIbs3xzM0Phbu/aFxFZ/FwsWGhsCdu2XIM/YdOEY/RJ1
	TUI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 19 May 2021 21:22:34 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Thu, 20 May 2021 13:22:22 +0900
Message-Id: <20210520042228.974083-6-damien.lemoal@wdc.com>
In-Reply-To: <20210520042228.974083-1-damien.lemoal@wdc.com>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH v2 05/11] dm: cleanup device_area_is_invalid()
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

In device_area_is_invalid(), use bdev_is_zoned() instead of open
coding the test on the zoned model returned by bdev_zoned_model().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ee47a332b462..21fd9cd4da32 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -249,7 +249,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	 * If the target is mapped to zoned block device(s), check
 	 * that the zones are not partially mapped.
 	 */
-	if (bdev_zoned_model(bdev) != BLK_ZONED_NONE) {
+	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
 		if (start & (zone_sectors - 1)) {
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


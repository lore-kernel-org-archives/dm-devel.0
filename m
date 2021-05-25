Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13DDC2B9F7
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 02:26:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 571D4613EC
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 02:26:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 571D4613EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-tYvujBZYN5iC1SOLMSq66A-1; Mon, 24 May 2021 22:26:13 -0400
X-MC-Unique: tYvujBZYN5iC1SOLMSq66A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58654801B16;
	Tue, 25 May 2021 02:26:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B2C561094;
	Tue, 25 May 2021 02:26:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0BF37180B464;
	Tue, 25 May 2021 02:26:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14P2PqpJ027696 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 May 2021 22:25:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8E137217E433; Tue, 25 May 2021 02:25:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 897B3217E431
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:25:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72A4483395B
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:25:52 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-354-BTZeMuwxPVqyzwmmS4pIIA-1; Mon, 24 May 2021 22:25:48 -0400
X-MC-Unique: BTZeMuwxPVqyzwmmS4pIIA-1
IronPort-SDR: iCIyTKH1qSjfAkrVjviDXINJngKEP7Ejjd18K15Gt4BgLtPT72adSoTHgWjEN+IKKAH2lWM1zg
	9absxZyyWampTS7Oc4qtFJEh+KPBMWlKTzkC4HnMMl7GKwdb0tsJ/k6J8FCMoLFNhEWAvZiSOJ
	pR+pEbw1p28d7wJlNuneZMSHJ7qkomsum+enLSUiQDgvqJcdZy89mHnK4OsLZxETju7vgAazhQ
	P7nuHQPLXRQRcCOBa459m9aAXBZAmuOzg+97C4fb/+Rcv6MVKc/gog7/1C7zXNsVSOOfGbXg+n
	+V8=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; d="scan'208";a="273213783"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 10:26:46 +0800
IronPort-SDR: DtwD5zrvLrfeF0DwB+QijyU038aE2WOgzsc2Xh56XJ76qWfgUH7HvOd67ZfboZAxXkzY7xwhk7
	5wHzmYyqrWthnNnlhmkAAAW1tMcIZxjxBmV5bZ+soOp4jv1Qqh2I0addw1/vHmxr8vZTcqgvm9
	dIHGHGFr+nrlfa6H94RRgJdoO3BO7QlSilps/rM/vwapfiZznxX4wo9ljpq5deTGK8zmfFlWeG
	qzr2ufwo25Fwp0JvrFO1qH1N5wNKBMgVMa+Xr8ZzaF22sNlIPo6EbYO0OoPNvlF0mNnz3AtnbJ
	UR6dOneNI6TUJhgAqRv4wXPE
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	24 May 2021 19:04:01 -0700
IronPort-SDR: nzjkQfLveOBcPnqFVJ3qcjNFl6RWinOGZaMHko/aoC07m7DRB/BgrvQ5lmQppmfHPTSCoIoxDI
	H7pYALN+qTXHXn43AD4j0oehM2MPa+Hq1zuwtVKb7JAP1B7+DeMn8/8PccGq7z8d+gC5OlUHYX
	gEjeb94ha+5eCCcVBIKZYipVLKMINtgi/zoo/wuprs7p0yNUSc/CcgIBqE2fmJ92lfK93IHweh
	w7Qz8Dgur5OOf6QegloFJaJ8/6D+Z+w4Xkn87wzg3sQ0n89gcQzBbu6N6rHuVi/7+wK21vHAcS
	TCs=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 24 May 2021 19:25:46 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Tue, 25 May 2021 11:25:33 +0900
Message-Id: <20210525022539.119661-6-damien.lemoal@wdc.com>
In-Reply-To: <20210525022539.119661-1-damien.lemoal@wdc.com>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH v4 05/11] dm: cleanup device_area_is_invalid()
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

In device_area_is_invalid(), use bdev_is_zoned() instead of open
coding the test on the zoned model returned by bdev_zoned_model().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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


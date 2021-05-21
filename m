Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1646C43460
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 03:02:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 56B136108D
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 03:02:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56B136108D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-Kw2LyVKhO6qXMq73hlmkow-1; Thu, 20 May 2021 23:02:28 -0400
X-MC-Unique: Kw2LyVKhO6qXMq73hlmkow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FABF6D595;
	Fri, 21 May 2021 03:02:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6085D5D9DC;
	Fri, 21 May 2021 03:02:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 331E9180C69B;
	Fri, 21 May 2021 03:02:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L31Zfw013463 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 23:01:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8CDFB1055241; Fri, 21 May 2021 03:01:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 87FE51067DC9
	for <dm-devel@redhat.com>; Fri, 21 May 2021 03:01:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FC43858F0D
	for <dm-devel@redhat.com>; Fri, 21 May 2021 03:01:32 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-262-sB9j9vQfN3GLl1mEfwgE0A-1; Thu, 20 May 2021 23:01:29 -0400
X-MC-Unique: sB9j9vQfN3GLl1mEfwgE0A-1
IronPort-SDR: SdbuQzG1sYXfUY9Vp0XVyefJ+VPyJJKO6UQgrKrF1iMdO97aWhpysvevF4/CNVxrfUmIImRiTF
	IhvAvBNAk24/OGg89dl3HTN3bKh/cE1im01+hy05aBM1wysgYjOSh630qalw29c0GYzHbkz0xo
	coHr26FWT6jAI9pjQCC94kPt8k3q+cTz52GGfpbkwymUJEPfEa76pyvENTXv8Sdyi67QGolrTM
	zYcCeHs/crkRE+WpBE3XaoWOfx0G0hoDK8Eo0IVDUgLSThsEWkzFQC6sDEA57jXG6Id8xQJX3e
	Lf8=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="173591086"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 21 May 2021 11:01:26 +0800
IronPort-SDR: f3tZLiwP4nbC0BWM/3XDi1KAXd8mPKQUy7kzpqiCibfBzXmY3Jwhf109oE1xDSTI5jPmI/kMx/
	tfIFaVybME8lqa2oTLU2lK78VjIwoUD0YFOCpZZ4bQGcH5q9+TQD78eo8A6/Ep4iFzX41qu/4S
	SMz27XBK6ytDxppI51Ny9GFq5sUIbw56J/j0BgePpt6uuxJVruzId+KLTx1TF+hwk0XiSt1TAK
	p1SbaN2icrp7QzuTiBMURCjHsibBcMlz+E2PKOCBJ3E+yp8PaK1lTfIdHI4yYiARscsMd1aKwH
	He0SN3TuQaAed39GB+oMCsLJ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	20 May 2021 19:41:04 -0700
IronPort-SDR: 4AZpCJ5RZBShdzujQpwtsu4LG365nyts0TnD3MLehk3UQSjrGyAeZeIs+UkRrvRn2uL9L/4Rs6
	5fBm7zZeVXVfrs3yB8wyrd+c1+y6Dc9pZ5WlODloIQmu+FtX3XsJ//CFegDiA9GrY4b/nGMUGi
	KFXAD1F4e4vEw5t5ToT2wl1BXmmBJy5TFd4yMx0gxvkiRJ5SSjK3t6R3a1zUmzeFVHCA+FNSny
	mXUTq6JuBobwx31k/kA+irggjxfW3QBKEIL91onw1issbC1v+SnkA1OMjsXsNSYwhoSRix63d7
	PbQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 20 May 2021 20:01:27 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Fri, 21 May 2021 12:01:13 +0900
Message-Id: <20210521030119.1209035-6-damien.lemoal@wdc.com>
In-Reply-To: <20210521030119.1209035-1-damien.lemoal@wdc.com>
References: <20210521030119.1209035-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v3 05/11] dm: cleanup device_area_is_invalid()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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


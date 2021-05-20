Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA0FC433B4
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:23:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 135BB611C2
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:23:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 135BB611C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-K_gd-RgEOheyd1DPt8PM9g-1; Thu, 20 May 2021 00:23:12 -0400
X-MC-Unique: K_gd-RgEOheyd1DPt8PM9g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5E6C1007480;
	Thu, 20 May 2021 04:23:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA273424D;
	Thu, 20 May 2021 04:23:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7CDB43FB4A;
	Thu, 20 May 2021 04:23:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K4Mjqe005831 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 00:22:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 02B3F107299; Thu, 20 May 2021 04:22:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1DD6107693
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47C931825064
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:41 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-452-0OdKPOyXN-OisCa2xePNvg-3; Thu, 20 May 2021 00:22:34 -0400
X-MC-Unique: 0OdKPOyXN-OisCa2xePNvg-3
IronPort-SDR: RNIGiyl/YITVd7X+P07gM0lCYhXFzWxJ+q3mBs7q1Wf/8KlqWnyErGhDGQpZQ6041UHDxUZm4Z
	5qE2/R7/iBxtHJrVkagQp46HcK0TDZAdMwfXhkK8ulWry+ldYpEW66gzdjX/EuvSjLx3pMVEZF
	I6mRVny1noNuQ4GiC+/9VfUOSbGDCgM6a1ezeJQT2tZowTeq/5JpSgly3LD872oH1F9th8U7DC
	DPPUspIez3zhPflU+Ez4HZgAvWieH5fOotCJyTAXwoQU5QB0SCB6cnu7fr9tHGrjziucDq7LJ8
	ZxQ=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="169343192"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 12:22:34 +0800
IronPort-SDR: ZCF/L6opBQPl3iVWMzYlaGNyvg9+3mE/rQzNl05CmXv8VS12lrcOgi/D42FkDlY5pPIXQbdPAs
	5QuLwPwucDCNPgAWfJlnuCzzE68c8dzFO14z4D0+HJ2uhRufanCSinzsm30xfwZqO8ybyfBMyA
	uD0B03NdcGinMY6ag0gnIDX2Q+itZ3XRkOhCQ/Z3IZS/Arew/Kph4O7zHImqGWEEDea3YMi9qP
	l7YXNylchQpClmwvu1AstK9nu1nZX7vyEITCUauxv+STMJ0E0LYDl1fkcU9vPCCR/q1+Uj3arY
	bodDALVfIyR8UWWV5GHlXoxI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	19 May 2021 21:00:58 -0700
IronPort-SDR: iMmTcvoJTNMSGxLdflsNlb0SPMpOaH43yQqsXpbohPjfRNCpHlofi/mjOrwqlECx8ajOvgT7K9
	cEbfH3r3qOk2NkgY3djchM2QSKyxEVQpnpFlFXFmsOr2/6w9gCvjGwxs2LpGyGDtbqre2riAhM
	HoNF0seytkMRnXc4Yr7EDkash/6hYoN9qv550pNm0I0SgA2Jxsrm52xpGDl0LAC2jX3qjT6dJv
	+R8Eg4GP/AJEvKh3GNTpdF5iSK1ucH5Ihr1UNZRzQ4kecA64JmH3Gq4Di2xw2S8IgGBlfhHO98
	7wg=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 19 May 2021 21:22:33 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Thu, 20 May 2021 13:22:21 +0900
Message-Id: <20210520042228.974083-5-damien.lemoal@wdc.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v2 04/11] dm: Fix dm_accept_partial_bio()
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

Fix dm_accept_partial_bio() to actually check that zone management
commands are not passed as explained in the function documentation
comment. Also, since a zone append operation cannot be split, add
REQ_OP_ZONE_APPEND as a forbidden command.

White lines are added around the group of BUG_ON() calls to make the
code more legible.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca2aedd8ee7d..a9211575bfed 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1237,8 +1237,9 @@ static int dm_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
- * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_RESET,
- * REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH.
+ * allowed for all bio types except REQ_PREFLUSH, zone management operations
+ * (REQ_OP_ZONE_RESET, REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and
+ * REQ_OP_ZONE_FINISH) and zone append writes.
  *
  * dm_accept_partial_bio informs the dm that the target only wants to process
  * additional n_sectors sectors of the bio and the rest of the data should be
@@ -1268,9 +1269,13 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 {
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	unsigned bi_size = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+
 	BUG_ON(bio->bi_opf & REQ_PREFLUSH);
+	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
+	BUG_ON(bio_op(bio) == REQ_OP_ZONE_APPEND);
 	BUG_ON(bi_size > *tio->len_ptr);
 	BUG_ON(n_sectors > bi_size);
+
 	*tio->len_ptr -= bi_size - n_sectors;
 	bio->bi_iter.bi_size = n_sectors << SECTOR_SHIFT;
 }
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


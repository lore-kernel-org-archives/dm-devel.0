Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D735BC43460
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 03:00:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E9AD6124C
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 03:00:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E9AD6124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-JOoOFXDfOue97peNZE95Sg-1; Tue, 18 May 2021 23:00:55 -0400
X-MC-Unique: JOoOFXDfOue97peNZE95Sg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ECB8181242A;
	Wed, 19 May 2021 03:00:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 23D5D18A50;
	Wed, 19 May 2021 03:00:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E78505EC77;
	Wed, 19 May 2021 03:00:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J2tfdo029479 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 May 2021 22:55:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1616621D0DAF; Wed, 19 May 2021 02:55:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 116A521D0DAD
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 920D01857F2A
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:38 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-202-q4Xc1jq0Md2BSZBpoUav0Q-1; Tue, 18 May 2021 22:55:36 -0400
X-MC-Unique: q4Xc1jq0Md2BSZBpoUav0Q-1
IronPort-SDR: THGrxmCyq8igYQc8QVzP5HtwC+Tg79pPwOkomsKoAhyn7HjB1yXRulNDwgwluLi92be1s+rxsb
	bk/q+WTApngdD9srUqwWth1Qv4asY/oL+y3fnMOX0nzL1dnzIdxzH9y+2Dk3LnB46bTgTATYJ5
	2/zmDA/U0fE+Jy4UWN3Ef4Xn9NbPCnbZokJNQ1Z+7JMgaLEWQ4K01SwgGCSmonvtYjKNbUF3GH
	28EdhMm7jH5cbJK0dUBBC8UDPEdn1yQ3wuwOfEreFeoyEQirLCpL1sUtsNLpiI54jrSGPq+lsZ
	PPs=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; d="scan'208";a="169197426"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 10:55:36 +0800
IronPort-SDR: 03S1wUgHSTUXGH/IYFSQdbWydFQ/27pazEzzhdBpgUui1NppklohoxA0hewiyUoZjAwwIf4xgF
	Q93vIuwvp/ZOFBKb8QvpyPKEAzJG5mobbwpWXIEtWsxCpw1D+ZR6BGtb0nqSONPHraKL6rMC+3
	Gzkfv8k8QdaeNb+yuzJ79upI8PCLoStwfzM/3ftFSlQpycQMUmSCDfZlU9eDGgEQ2WDoVwxRyV
	BSpcseGvWqX7fO+WScisUhVu1If2DaEV9Q2EA0sNaL2/zSFdUhX/3Xj549NVDk5bfRk5htcCQW
	BBtXRSwUVKrBGzmJytzwf23I
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 May 2021 19:34:00 -0700
IronPort-SDR: eBdyt+Zu6RnJp2t8ia3+EQ301600BuwRL4NGvgzYP/66dBzoFoyWUHDrhMoHZbzBHQMUvImMgr
	4OJ3LahGeuRsTiZHZRBWzTKEVWS+Faj1r3e5wbGKnym2kzosN/k/fB1/TmkziejJUG18tq8/9o
	qw6SWqkMc0KzpOthvJLzmKTj9YQGb0hjJ2a04uGT6gG6dj+UuU08uYLMiYxlanDFQ5pieiAe3W
	EmCHk3lXr0LYCY7tbcJq7OxfkvZmhj+LHvTBI9O0YC6T2O8EzfgZ7u90ODSFPMaOyALKFuZeGz
	cWc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 May 2021 19:55:34 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 19 May 2021 11:55:22 +0900
Message-Id: <20210519025529.707897-5-damien.lemoal@wdc.com>
In-Reply-To: <20210519025529.707897-1-damien.lemoal@wdc.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH 04/11] dm: Fix dm_accept_partial_bio()
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

Fix dm_accept_partial_bio() to actually check that zone management
commands are not passed as explained in the function documentation
comment. Also, since a zone append operation cannot be split, add
REQ_OP_ZONE_APPEND as a forbidden command.

White lines are added around the group of BUG_ON() calls to make the
code more legible.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
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


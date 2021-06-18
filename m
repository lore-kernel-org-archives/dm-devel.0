Return-Path: <SRS0=Vrzv=LM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1EDC48BDF
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 23:15:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B366160FE7
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 23:15:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B366160FE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-BfP-9d-zOSuzDhUlr9K4GQ-1; Fri, 18 Jun 2021 19:15:54 -0400
X-MC-Unique: BfP-9d-zOSuzDhUlr9K4GQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30D19362F9;
	Fri, 18 Jun 2021 23:15:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48F4A5F714;
	Fri, 18 Jun 2021 23:15:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EBC114A712;
	Fri, 18 Jun 2021 23:15:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15INFckt021767 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Jun 2021 19:15:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6BA7B202B198; Fri, 18 Jun 2021 23:15:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6573A202B191
	for <dm-devel@redhat.com>; Fri, 18 Jun 2021 23:15:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 213D7800142
	for <dm-devel@redhat.com>; Fri, 18 Jun 2021 23:15:35 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-23-IQlnGy_4PJyHT3m9254QYg-1; Fri, 18 Jun 2021 19:15:30 -0400
X-MC-Unique: IQlnGy_4PJyHT3m9254QYg-1
IronPort-SDR: z/YjWigehUp3sw35nzEuIhlaftgInq6CWI5uDuXmH8mKX9BrYrSbq0GhdPoptyTceLLvhJrG2X
	usAe89RqQWx1rTXKfko7Ps1k4oKl5WZQx9MxI1JJ763kpRGCWwu2iFGGNsSvbI+ItKnEqvsc01
	rmEIuaGgCCHIFx4ji4Y5dLTG9Z6CQt4UDTv2gthqCJMOeqeLZK69W9+gzVRAazYi+4muv02cN5
	cyPrtL8p8k3K5LpsAMD8k6K9oPVYaWHYSbQ5aUUUluF8ONTlNVIMdhXKHSQNRqs4xBAOEdNNZH
	xkQ=
X-IronPort-AV: E=Sophos;i="5.83,284,1616428800"; d="scan'208";a="276129186"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2021 07:15:50 +0800
IronPort-SDR: 1jwKNXFHNc/VS+eqq33s9WFGtG+cUvwLhElXhEmagJaD+iAiV+3p8rZC7YgifYMNtFKYLqbhF2
	y5MZWe9Ohq9sCGcz8ow302y5Y34QC1+lJh76+Nab9ei8lfZH7NgzHzXipFN9qu9+V6iUcqXUDJ
	KUE1YZkljGY1fTwWDyH3T4wqoZ4/tiqQ8kqEWLKzqI2DEuZjnESW5W11svnl/xq3c+L/kh0M6k
	JBvq1sN455gmILaMyLjiVsl4ax8rzrvZJBcOUyGWsj/kyTr2KGXib6OIjsHXtbiLCYGVQZspXD
	TPDt8p2ZrCgpl0tBzyhBMr7w
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jun 2021 15:54:15 -0700
IronPort-SDR: +Cq2t5rolkDE33iDnvpFNRvMxfFv1GiwDCkV46liJZMyVYawuoyUCh58/pp4VG2FL2ZiW27doR
	5bbi9QAU9cNsxkRkhAtRp9T+2q3YkwnqMuj06hsZkvlUYky9LP0OywP7tvxCS8p2z7A7xLAxHI
	y4MkNTFBNWrVHM7V9dhQdlWXCcU5eRIActZftLQC1NDqv5Ae1Rhajj94vhPA3jBqGJPQiPxxqs
	X2AqKUyAr/C1alQEzm0LyLWOU4mSeaF2aFO0reJCOTyr9bvySLMIDWOTFaIdPFstWK+Lst9HUd
	Jsc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jun 2021 16:15:29 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Date: Sat, 19 Jun 2021 08:15:19 +0900
Message-Id: <20210618231519.797033-1-damien.lemoal@wdc.com>
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
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [dm-devel] [PATCH] dm: fix dm_revalidate_zones() memory allocation
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Make sure that the zone write pointer offset array is allocated with a
vmalloc in dm_zone_revalidate_cb() by passing GFP_KERNEL gfp flag to
kvcalloc(). However, since we do not want to trigger IOs while
revalidating zones, change dm_revalidate_zones() to have the zone scan
done in GFP_NOIO context using memalloc_noio_save/restore calls.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: bb37d77239af ("dm: introduce zone append emulation")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zone.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index c2f26949f5ee..6d82a34438c8 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -205,7 +205,7 @@ static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
 		if (!md->zwp_offset) {
 			md->zwp_offset =
 				kvcalloc(q->nr_zones, sizeof(unsigned int),
-					 GFP_NOIO);
+					 GFP_KERNEL);
 			if (!md->zwp_offset)
 				return -ENOMEM;
 		}
@@ -230,6 +230,7 @@ static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
 static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
 {
 	struct request_queue *q = md->queue;
+	unsigned int noio_flag;
 	int ret;
 
 	/*
@@ -241,9 +242,14 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
 	if (md->nr_zones)
 		return 0;
 
-	/* Scan all zones to initialize everything */
+	/*
+	 * Scan all zones to initialize everything. Ensure that all vmalloc
+	 * operations in this context are done as if GFP_NOIO was specified.
+	 */
+	noio_flag = memalloc_noio_save();
 	ret = dm_blk_do_report_zones(md, t, 0, q->nr_zones,
 				     dm_zone_revalidate_cb, md);
+	memalloc_noio_restore(noio_flag);
 	if (ret < 0)
 		goto err;
 	if (ret != q->nr_zones) {
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07382C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 03:02:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8688E61355
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 03:02:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8688E61355
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-itGHCWo7PZiC1Eqkbjp2jg-1; Thu, 20 May 2021 23:02:15 -0400
X-MC-Unique: itGHCWo7PZiC1Eqkbjp2jg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C30C106BB2A;
	Fri, 21 May 2021 03:02:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D98E319C71;
	Fri, 21 May 2021 03:02:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A84271800BBE;
	Fri, 21 May 2021 03:02:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L31XtG013432 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 23:01:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 91D84163D16; Fri, 21 May 2021 03:01:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CE1E163D0F
	for <dm-devel@redhat.com>; Fri, 21 May 2021 03:01:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75791101A531
	for <dm-devel@redhat.com>; Fri, 21 May 2021 03:01:33 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-97-cOzWaQQRNiu3Gmh_peamJw-1; Thu, 20 May 2021 23:01:28 -0400
X-MC-Unique: cOzWaQQRNiu3Gmh_peamJw-1
IronPort-SDR: xvaRb3KE71kgWVLu3uYq8zii6jcP+48QTlqc8VXSWgiL+g3WbFFWde5levKjx0HW35wgtG/f+p
	BL4DbB8ZEKPDEt8wA4luQ7HazMdRvbbIW6xpwH+4/NPoCBeQ0ASHl2Xth63KTz99xVf42L67Ep
	NIoGmcQ7nWHkLDZS+pcAtUkq41tZVnzAao3EtnLcg87K2oonAmgRU7DmDoLLHxDG55K22LOkuc
	bsEzsc3Fq80iszF2plmAMQJ5ct0s7CmCaejUUqGfivGRJe/I4jlHhxNbQ8YeiCGFGvvRKwvt+y
	rOw=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="272871477"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 21 May 2021 11:01:27 +0800
IronPort-SDR: rdZ184hhKlBXj97OISu5SBfq2KNpJ5cbkOUvnMfFEiR0HLnfUAZSbI8AAyLZKimzUKsolJ4Dk2
	wOfrOu4dyNhnF87fmYmFEe2u0rCfW7PxqxBl8QQScHkItTTvmixcJWwyj/4or/SfE5lkimxjQD
	oga1M+jPXQQJUW2FqW0gEg1wvu247LWiVxz20U8YOTJuQOZ+zXXZHuXyQT/c1Gk3R5en4i8+6x
	HAsYi0zayYTLPN0lMngtH6o+JsfgFnuJJrFaPrzTf6zRLDgAWm56gi52EjP6n5rD01xXthHpcL
	ij4KcGPC9qudliaAb9m2eUn1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	20 May 2021 19:40:59 -0700
IronPort-SDR: eWE035UCu7Mks9ONY6f7nljDD8+7jYU6zjDemN2JpwWJFMSe/S67w+4WR+rDth3H/WR2gT/hhQ
	iJcLtA02Z/cObCMfSnvmnlE64WjzemeoOMN5fvfoaCbrsWKym3JxyqoWA+h07lvOPqa6emT9Fb
	VG8WP9ZumCyBDPclidyMt09I47nJddBJCuozI4dghjhV0mNkvRT+2WiGTj5reahz8wZkIPHXCU
	8G6gbbAFOtJtvgBoMohnJA/+QYw35B3Y0KCNwyOgijdgych/BR7Aadj4vwd2vwYoPy8s6gDZFd
	cmM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 20 May 2021 20:01:23 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Fri, 21 May 2021 12:01:10 +0900
Message-Id: <20210521030119.1209035-3-damien.lemoal@wdc.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v3 02/11] block: introduce bio zone helpers
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

Introduce the helper functions bio_zone_no() and bio_zone_is_seq().
Both are the BIO counterparts of the request helpers blk_rq_zone_no()
and blk_rq_zone_is_seq(), respectively returning the number of the
target zone of a bio and true if the BIO target zone is sequential.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/blkdev.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f69c75bd6d27..2db0f376f5d9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1008,6 +1008,18 @@ static inline unsigned int blk_rq_stats_sectors(const struct request *rq)
 /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
 const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
 
+static inline unsigned int bio_zone_no(struct bio *bio)
+{
+	return blk_queue_zone_no(bdev_get_queue(bio->bi_bdev),
+				 bio->bi_iter.bi_sector);
+}
+
+static inline unsigned int bio_zone_is_seq(struct bio *bio)
+{
+	return blk_queue_zone_is_seq(bdev_get_queue(bio->bi_bdev),
+				     bio->bi_iter.bi_sector);
+}
+
 static inline unsigned int blk_rq_zone_no(struct request *rq)
 {
 	return blk_queue_zone_no(rq->q, blk_rq_pos(rq));
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBEBC43461
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 03:01:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 16E3C611AD
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 03:01:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16E3C611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-FagnsaQlOvuz4b5YZen2Zg-1; Thu, 20 May 2021 23:01:44 -0400
X-MC-Unique: FagnsaQlOvuz4b5YZen2Zg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E69681883521;
	Fri, 21 May 2021 03:01:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8B145D9DC;
	Fri, 21 May 2021 03:01:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 67F9D44A5C;
	Fri, 21 May 2021 03:01:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L31ZBZ013464 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 23:01:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8E79E1067DC9; Fri, 21 May 2021 03:01:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8841E106A74B
	for <dm-devel@redhat.com>; Fri, 21 May 2021 03:01:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D873E185A79C
	for <dm-devel@redhat.com>; Fri, 21 May 2021 03:01:32 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-97-wbFNYBRgPCmiotsHzyujxw-2; Thu, 20 May 2021 23:01:30 -0400
X-MC-Unique: wbFNYBRgPCmiotsHzyujxw-2
IronPort-SDR: hbZ9iXF08o1KgEUlAGDL5clP6MEEN3luOmUYlXwsEUf25wtgGipDL1ufjVY40QHaJs5eYapFKk
	/vw7Rk9n9HrAW9e+8n3478uP2uNWiZXj8uuDmUDef1rvO9m0CZxVPKC7cIWRzXp3WEveKYFA4u
	N0rfNgtySUCP+dmzdNf5yVYgZOyTjUr9HdhAjvUG6QlNTU7D+g9oZhe2i50CtHCHqGw7bnMhYb
	r7sYuCW72+QOngGyF4V+3yzYv/MsWxVr9eWHgX37hL3g7Gt6KYfuXehSJpBcpB3YXipVf8J/T9
	TB4=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="272871478"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 21 May 2021 11:01:27 +0800
IronPort-SDR: 5q6oUN2oq5i+hyYDGda4R93Icia361YiiAj1+udMsUsHz6D0TkEmHiTDm3otscvaqJZPXSn4um
	wbwuR6bStLJ7oTXATX4Pw+v1O09VZ6kn2lSRUfweQlr2YuMZdvJfLTrhF0fiyhsQqs0auc1hQi
	ElkhBFjSm8SfdGlriw4Ou1On8hRe9etBcsulqUZXDCHk9i+xAiccoEOoHD0u1f2b18UEaCbLOm
	Bak0Z0RKGC81hmPMSViLFEzqCdnOcCa82pttkgzOEHAPMufHHoelAD2/PJ7nfEgWJtcb7QRu8D
	mmEPlp+alY/xYdBxwTtEq6HP
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	20 May 2021 19:41:01 -0700
IronPort-SDR: lAeiAp2b2gKV5TvRtg7Y01nKMN1o+nLd9OPWRivCMfl0DYPczAwXLajZ/jH7mBhVJbmqj9wkPI
	uj7RC1OY/oGqX8O/TtxTRpLNsQIYXTazwJbj/0Hf/qxzYtaEOHjOcDleSypSecySFst/QaWyJZ
	AbwwnpdJepMU7ynqzJ4dHI1oJtHqor8WHfh1IiAYfYTztuk9jQkNBKo/1clea0dahCnuVSz6yd
	2HLMC2lcN8ZnbwXC6t8zEvhLE0FwzIn0iuVzZRTRiJ3gc6BjKLVofR6uIIw9jHtaaWpgzqjmiZ
	2V4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 20 May 2021 20:01:25 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Fri, 21 May 2021 12:01:11 +0900
Message-Id: <20210521030119.1209035-4-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH v3 03/11] block: introduce BIO_ZONE_WRITE_LOCKED
	bio flag
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

Introduce the BIO flag BIO_ZONE_WRITE_LOCKED to indicate that a BIO owns
the write lock of the zone it is targeting. This is the counterpart of
the struct request flag RQF_ZONE_WRITE_LOCKED.

This new BIO flag is reserved for now for zone write locking control
for device mapper targets exposing a zoned block device. Since in this
case, the lock flag must not be propagated to the struct request that
will be used to process the BIO, a BIO private flag is used rather than
changing the RQF_ZONE_WRITE_LOCKED request flag into a common REQ_XXX
flag that could be used for both BIO and request. This avoids conflicts
down the stack with the block IO scheduler zone write locking
(in mq-deadline).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/blk_types.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index db026b6ec15a..e5cf12f102a2 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -304,6 +304,7 @@ enum {
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
 	BIO_REMAPPED,
+	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
 	BIO_FLAG_LAST
 };
 
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


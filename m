Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB47C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:23:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC46161244
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:23:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC46161244
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-NT1ThsKwP2uthD5AN0xiFg-1; Thu, 20 May 2021 00:23:05 -0400
X-MC-Unique: NT1ThsKwP2uthD5AN0xiFg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BFAB801B15;
	Thu, 20 May 2021 04:23:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EF5860BF1;
	Thu, 20 May 2021 04:23:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 55B27180B463;
	Thu, 20 May 2021 04:23:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K4McHc005761 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 00:22:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C36771054820; Thu, 20 May 2021 04:22:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC3FB105481E
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C332800B29
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:36 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-595-uJn-wWkNMlaKycGo9BjKSw-2; Thu, 20 May 2021 00:22:33 -0400
X-MC-Unique: uJn-wWkNMlaKycGo9BjKSw-2
IronPort-SDR: e1dvbe9B8/hHAlUr7PlpW1FYyQXbawn4wENxGS69N4MWJ7Bt1eTR6QuLPib7wkyBlGmjBCkIOH
	RrgriNt090HTHHEth+tDs/GRJb1FqoqVXaXwK5nQj2Pp5DmTlnD/qpRRft26yzse40oNPSYqoL
	BOxjkKHeb2hoqL3XLUtAPKv0DK+KrkYNKFM3NIIaK+QtussfPeCPEG6DitKPBk9sm+ZkWvrvGg
	xHUOd9l1I2aTooi0Sys//63OQu0FKLrJeVllrB6P4PJOoh8Xr3WrajbMVNnfgqpuMT8fr2Cv/t
	hX0=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="169343190"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 12:22:33 +0800
IronPort-SDR: HnNqtUsX617/kB9ysNtU02TI9nQckxY+hIMRgZQGgGK5GfOH7t/u6T61jaaXflNV7j3IfSEsk/
	R4yILuMTTlM9xshtaL5Vj5q6oZMcXdGon6UcDLtD+Hy5FyLD5MZbbaMcmSTARBR4o3uSXlZdYZ
	QUkstZHY8wCUrVsDhwWJTzWLhqfLOCQWDVOzCedRSw1eIRmCaDe9qclsyq8ieRbF8/kHoj5AsB
	AXKPxP5d7wgKSUWTiC/bgvgjPBZi6lOF4thK2PT3qmdWe/qZMmd82Rd2HIIqFPUFn/OSa2mtBJ
	pfZWwfIXLgyGM4ufRVpoac8g
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	19 May 2021 21:00:56 -0700
IronPort-SDR: CAw9+Fo4qDxasNQN/GopsJamFgI79cMYrsl9EI8NqsZOkQIFLVSxw1Q0Lp3x2zQmy0lNX4pAQf
	CMHbnNDHBmRvTOhtXDapU30f3hBZ7ZTtBtY2JcDwc7TnRQcaakwVAIqMhXiJ0lSfRhkdBNUjYG
	M1j6HdMWWHZImOKE+m6Rr9GX8LM58CM8WveF466Sr6z4hdal4gyGZI/v34ldLN8HiECxj3XS62
	C6pUWSCHUo2Xj3cA01K/OVEHvq8HqY1VVZ1kfaMofsowqbTfZmR3GXYE+TNvBgz0QhbG70nAKV
	q4g=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 19 May 2021 21:22:32 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Thu, 20 May 2021 13:22:20 +0900
Message-Id: <20210520042228.974083-4-damien.lemoal@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v2 03/11] block: introduce BIO_ZONE_WRITE_LOCKED
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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


Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D801C47085
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 02:26:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D935F61420
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 02:26:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D935F61420
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-K2LKT25JPZ2FD6aJZ_1Qfg-1; Mon, 24 May 2021 22:26:11 -0400
X-MC-Unique: K2LKT25JPZ2FD6aJZ_1Qfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E633800D62;
	Tue, 25 May 2021 02:26:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 538276E401;
	Tue, 25 May 2021 02:26:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0456C57DE5;
	Tue, 25 May 2021 02:26:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14P2PokV027662 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 May 2021 22:25:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0F6029C05A; Tue, 25 May 2021 02:25:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A2829C059
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:25:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3075857D08
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:25:46 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-372-_vyYTMC4N668V-mAiQmsew-2; Mon, 24 May 2021 22:25:44 -0400
X-MC-Unique: _vyYTMC4N668V-mAiQmsew-2
IronPort-SDR: Sqwhioj6eqXLzOkfwIkeLRw49cGbJUBvU41vHr4OpGc+uNFtppcXnf/8btcZrm4MhHcuJSKhkv
	dJjsznmt2couSZ14YS3sZ9A0X+7MmFXW24qMVjAKG9RdkdaqmkClzN4JpO6hV29VT0WHPFwhpB
	6K8lX+UfGm+zkv4DBBYLlvI26rKOCtxH4t8ofEbgSNqR1nW74/HrekiGZLxR+FeU3tz6cjInsP
	JRB56UCfdLYCsqTi9e9iKdn8F5csW/kyo4ZlYXb2RJ/5dRQeTZFFlsX5xf9zLKS86nKdw5iWxp
	tIk=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; d="scan'208";a="273213776"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 10:26:42 +0800
IronPort-SDR: d40dtCZfrM1hCMSZ+ghhpXCljc0eCISTMejJ0UHRpqLFpD8+GO0BJbdVDRU9X4eTtftKCCBCgK
	BLmyDIZi3Jl8XID/qEew3GQJMXwRrQdCnVlpVKCgZwysfMjo2FoW9+ihDLWMMmtzxxw4depGPX
	WIGpiIZ4kvwq61Yn8EyuLjD4l4NaLNdnIOILn+sRY/yu3ZPdQAfCXe54JX2bY9yFpCoCU/PGGR
	ICn+6iyV7Tswd5KCysRfgllNKhpnj35kxqE6lG5RSfl7FKwxYd9a+lLeR0oSWC8OJ22wiqkwyl
	ncT98sT7mkWSLO5YY3t41bXd
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	24 May 2021 19:03:58 -0700
IronPort-SDR: vKZCpJiDMYS2oJJbpIiyHtZCQWcB1ETJ2IpBF7qPbf8ODehVsQoPNM/4cAc9DdnRwu0MP9S7Yo
	zC4IV1Wwt9BVArLNehcCN8nL5Ufhics3Vl8atwMjF2AiypoO3+ZeA2DHoEpC30o4JHkUvELtJn
	i6tkvfjghv4AFvMo8Eu0dVZZn507xr3BlfKByP4ZjjX+XibxK1Nq/RhvgdmqiELDUhYmXV1mhO
	ghb/7j6b7SIL3Uia/VBF1D5gsodfUexHjRNCDsqFgNpHCKqmO3xUiF8zcOYFoUCV7VkO0+zcDc
	rhA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 24 May 2021 19:25:43 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Tue, 25 May 2021 11:25:31 +0900
Message-Id: <20210525022539.119661-4-damien.lemoal@wdc.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v4 03/11] block: introduce BIO_ZONE_WRITE_LOCKED
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
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


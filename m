Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA92C47086
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1739461423
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1739461423
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-SAp4bvLONTyTynXj5LfqSA-1; Tue, 25 May 2021 17:25:49 -0400
X-MC-Unique: SAp4bvLONTyTynXj5LfqSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B275B6416E;
	Tue, 25 May 2021 21:25:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9914D50DE6;
	Tue, 25 May 2021 21:25:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6B4001801267;
	Tue, 25 May 2021 21:25:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PLPJWA003346 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 17:25:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 05575103D232; Tue, 25 May 2021 21:25:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1D1F10F8E38
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F18D9124D2
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:13 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-140-SsSj9xqhNBCdAleJ0JY5FA-2; Tue, 25 May 2021 17:25:08 -0400
X-MC-Unique: SsSj9xqhNBCdAleJ0JY5FA-2
IronPort-SDR: Xap7/yGzu5bGB6Jza88Cq4A4kAO6RVotNSzfXR9U4bQKUHiYdLfxyYtUMT6JJlxhSPC9ZJGfZe
	EI2I0L/JuDFkztbHdsDfr/uTjKuIzYtWi55Jkw4Teimb8RQCQ71EyDV3juRpRiyJHNKVcQJ+Ig
	FLfFhhIO1Pipx2XLB21PKOf71pQR4ipAKWVM6xFkzIpgW0bB/h4IERatBpJXIQcBl7h67Yi+KG
	LEXzsD8PcX+oNMp63IkERmeon8QYtcr/W4wpBf55gpTpilOEnvHOaoXe3Zo5zlf98WN27JqMIj
	yiI=
X-IronPort-AV: E=Sophos;i="5.82,329,1613404800"; d="scan'208";a="168717516"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 26 May 2021 05:25:07 +0800
IronPort-SDR: xvbClJRSy88NZFym0uEcWxB54fwMgWasYXVYCi7IsNTPw7D2fjmIiP/Fn4k8AkCp2PIpQZTlYb
	/TkWnuz95dn6gOSFybFB8r3rDr0MWK1InBRKRPrYXmw/9vuQDwuN3O9xV3PjzbPEK6ploDZJTx
	D9tjD4RIKOu0r2F8MqDgpUe735GecyU9oqba6wKevWAFtkUgzBws9n12hsXn+XnvgEp7olDzJL
	TqcJc3undUbgJE4qXkFlfw0fH7jksmuQcXzJOgIlv34u2/cfm49o9UFhuP9qbqw0s7umxfbU65
	z/mTfb29DjKhD4GtzvSrJC59
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	25 May 2021 14:03:18 -0700
IronPort-SDR: cs03JQLS7hcWIucz1TPDpUrFjTrNuBxSxEa0ivmhTBQZlYUdzzUf0LsQmP1wn5ZwLyox9oAJul
	7A/Ft9j4Kbu5eFHderB/Nkfvjd2fU4N7j/SQXDU8THQ9+g4NBCJexgQ7U1WEVwM0Oz6w1qV5L0
	d/I0x1HE9tizeAKl7iRnrWJVPwi4HhsvP5qSLwoRZmrXJtmhohds7u930lzts9qBPl36SD0ycV
	RzLbC4oSSOxtpzuJRcKK7Q9sweMu8KAwG6MEkk1Y/VtPPq8oasAyDEUuH/erj6S+a/a8RWs9Ev
	JgQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 25 May 2021 14:25:07 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 26 May 2021 06:24:53 +0900
Message-Id: <20210525212501.226888-4-damien.lemoal@wdc.com>
In-Reply-To: <20210525212501.226888-1-damien.lemoal@wdc.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH v5 03/11] block: introduce BIO_ZONE_WRITE_LOCKED
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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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


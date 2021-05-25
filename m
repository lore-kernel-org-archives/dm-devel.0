Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461CCC47086
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D260161429
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D260161429
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-rdTneOhtN3O-sTFPLzfDuw-1; Tue, 25 May 2021 17:25:52 -0400
X-MC-Unique: rdTneOhtN3O-sTFPLzfDuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FC8C6417D;
	Tue, 25 May 2021 21:25:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 587061002F12;
	Tue, 25 May 2021 21:25:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2C0FA5534D;
	Tue, 25 May 2021 21:25:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PLPN1U003401 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 17:25:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C21C02087469; Tue, 25 May 2021 21:25:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCE732087465
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72674858F0D
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:23 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-215-R7MzreaoN0O4Q6apNTGHPw-6; Tue, 25 May 2021 17:25:18 -0400
X-MC-Unique: R7MzreaoN0O4Q6apNTGHPw-6
IronPort-SDR: eivjj1Sd0txNNDBazIP8dEdC4No2ZsdSBv9BC/b9Miya+vFD7R0uSZGwLmafV5iZ/Vz4+L6nG8
	K1NSfL0Nz8sSWvzdKFghOyMe/STMiISsmThpJ6iU4ifdG9sj5pFQYR/q4dlLCaFFk22iSEMzgW
	TyD1JUfweXYy1RiNWCOlZxI7oixenQQu7lGr72MUWmDJQcUFihkUN+0sCfEv7B+QqY0CsIE6+2
	SdOjV+ht5bwa8oXKoYr7PsftAuXqU3zVsWa+G/Fri/dY3SAwsUmO+npa6JrBRZo1pZacV0GSXJ
	4hY=
X-IronPort-AV: E=Sophos;i="5.82,329,1613404800"; d="scan'208";a="168717549"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 26 May 2021 05:25:17 +0800
IronPort-SDR: NVPtfPW0z/q+n3Lym2GVaae7Mmo36tZJv1fJMnOs+1d3lhD1JFqbMbrQ8Bt0PeBusu0jkDu0bn
	zmA0VwCUuGqSog4tOQ+cUd5Ro2jLyTnPTG5tq79+gg09p9EjvAsgWkCfkUCwoCbR6ztMLQVhnp
	e9605EPdtHDklgr8JURYGagGW3CG5FDjjV7iMQ67LPPl+/oPkYTvpxy6Nzh0OheVE2oHrsGGPd
	ELO+BNKDAwHa3ltEeHPxZ3E41N6ljBNyEZ+8Yxq9jv5xi7VYNQgn50rLDulb4Vz2l5cqeoELwQ
	mGLKFp+Q+W0YuFnSOLjnOjT2
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	25 May 2021 14:03:27 -0700
IronPort-SDR: FNmk77p8RaJkKJ4Lf3DM2Ud9DNupkU6U5O1zROkYxyKxSGhxq4OJunGO10+o4L6MuRYtE2H1Fm
	po1vbCpBIFroKqFEYU3NDhTff2xyL58bH+mLvyJ5deJuKcgsD6BBAh8lLqygUWRQlH8k/Cu6yl
	FafTPsK47Kcw2TinMkQH+7J/7/yP8tQe69m71KK4x49inIVgLiBsngobFb6vHGIIibRq+0dC78
	ey/iqrz7U2rHkRpxzRP+MaA9lgOO/OAGdLY3rFFte99MK8UsGuQtYi5VZJKkQdR0wOtAoPsExe
	IUU=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 25 May 2021 14:25:17 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 26 May 2021 06:25:01 +0900
Message-Id: <20210525212501.226888-12-damien.lemoal@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v5 11/11] dm crypt: Fix zoned block device support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Zone append BIOs (REQ_OP_ZONE_APPEND) always specify the start sector
of the zone to be written instead of the actual sector location to
write. The write location is determined by the device and returned to
the host upon completion of the operation. This interface, while simple
and efficient for writing into sequential zones of a zoned block
device, is incompatible with the use of sector values to calculate a
cypher block IV. All data written in a zone end up using the same IV
values corresponding to the first sectors of the zone, but read
operation will specify any sector within the zone resulting in an IV
mismatch between encryption and decryption.

To solve this problem, report to DM core that zone append operations are
not supported. This result in the zone append operations being emulated
using regular write operations.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/md/dm-crypt.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f410ceee51d7..50f4cbd600d5 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3280,14 +3280,28 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	cc->start = tmpll;
 
-	/*
-	 * For zoned block devices, we need to preserve the issuer write
-	 * ordering. To do so, disable write workqueues and force inline
-	 * encryption completion.
-	 */
 	if (bdev_is_zoned(cc->dev->bdev)) {
+		/*
+		 * For zoned block devices, we need to preserve the issuer write
+		 * ordering. To do so, disable write workqueues and force inline
+		 * encryption completion.
+		 */
 		set_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
 		set_bit(DM_CRYPT_WRITE_INLINE, &cc->flags);
+
+		/*
+		 * All zone append writes to a zone of a zoned block device will
+		 * have the same BIO sector, the start of the zone. When the
+		 * cypher IV mode uses sector values, all data targeting a
+		 * zone will be encrypted using the first sector numbers of the
+		 * zone. This will not result in write errors but will
+		 * cause most reads to fail as reads will use the sector values
+		 * for the actual data locations, resulting in IV mismatch.
+		 * To avoid this problem, ask DM core to emulate zone append
+		 * operations with regular writes.
+		 */
+		DMDEBUG("Zone append operations will be emulated");
+		ti->emulate_zone_append = true;
 	}
 
 	if (crypt_integrity_aead(cc) || cc->integrity_iv_size) {
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


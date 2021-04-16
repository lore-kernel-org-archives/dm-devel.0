Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EB0C433B4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 03:07:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 77F766113D
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 03:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77F766113D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-87YSejbJOhGKJ0kGUa_4Lg-1; Thu, 15 Apr 2021 23:06:59 -0400
X-MC-Unique: 87YSejbJOhGKJ0kGUa_4Lg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EFF11008063;
	Fri, 16 Apr 2021 03:06:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A65647;
	Fri, 16 Apr 2021 03:06:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17CB744A62;
	Fri, 16 Apr 2021 03:06:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G36aMb030658 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 23:06:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4A8ABFC73A; Fri, 16 Apr 2021 03:06:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43DDCFC72B
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 03:06:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEF08100DE79
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 03:06:32 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-297-qTTSM8-aNWy4b9m3Sn8HJw-1; Thu, 15 Apr 2021 23:06:28 -0400
X-MC-Unique: qTTSM8-aNWy4b9m3Sn8HJw-1
IronPort-SDR: JrLEM8e0UujlaAM39LEMrESyswaEodGxQCb7U5SZGKKwBeWy8cA5+jROYUQYYfqbcCj75kDZ8k
	MWCYR+KTL7cir4fm1abz7L354l43kTZ/Npyj+DODJq4O4He3dA7KFOqpQih6vfkC+H5J0+Ng64
	f3nW0+AVdzNQHDrTQMon0tvBLoVRdsY4Mo+5ymHiUbZcj8nHfeI2zWgJIuj0lPQvi9hbA9GQEP
	L4dqPOgrr7uIs7lwcNek6MbYJu1DA6TodMfDmhf3fw2PFvxoFYPxqyOIo8u8h2SqO8lTa0DRdk
	he0=
X-IronPort-AV: E=Sophos;i="5.82,226,1613404800"; d="scan'208";a="164423092"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2021 11:05:53 +0800
IronPort-SDR: w6HZ886ZE4qGJNDSWKR2GRS/X5Re8WQHgbxbw+7dVc0cUBOkndY3dfW4amAe4yId3gBq/lG1P1
	TM/Ng+2cI0wkJdU7dxKyM01HDcoCJlPLwoazuP6Ki0+C/Eap0c/69Y7z1wD3VXaKcABwIz3bHT
	Wf+EfgdeOMzTT6L0PAWaqrJaicHAaLWyvZ5OWy58NHUuL0xWDT9+9hprAoKeSD28eO3A3Azstw
	K0YEnX/9KejOplqCHig5LPDBTD0nhftNEdGfkIxa3ph9w/pWWqQdlznb8ETT7HolsPP4iCXY4y
	htblTr7ziERiu8AST+sCbMBU
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	15 Apr 2021 19:46:29 -0700
IronPort-SDR: reXaIl08fufcrKmwqlTrWikXVN+K7DeRaEHrim6atgn6l0Yzshs6cwZfuVPyG/kvBFwDZwOrfr
	KS+rIvyqVDxgc7Gk/123Bm8msgUO6s4kvzkQ+qbbMhLQMA2VUtrz2kPI7Uz0wH9p97zvdy+QzB
	dBNntEhDmRfVb+H6+MNJdlgbWRYLOtg4nGCU+7WubVXDhzMhGvHAgjkXjcQHedj6A+mGlgbgKU
	F2qkOL1fodLfhCMmK6ceLxyGqBvX+6LMi073Jjr5TrHhAQGPfhL+ssy2/DyhiIJ0c5n+L76/P5
	VD8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 15 Apr 2021 20:05:35 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>
Date: Fri, 16 Apr 2021 12:05:26 +0900
Message-Id: <20210416030528.757513-3-damien.lemoal@wdc.com>
In-Reply-To: <20210416030528.757513-1-damien.lemoal@wdc.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
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
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: [dm-devel] [PATCH 2/4] dm crypt: Fix zoned block device support
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

Zone append BIOs (REQ_OP_ZONE_APPEND) always specify the start sector of
the zone to be written instead of the actual location sector to write.
The write location is determined by the device and returned to the host
upon completion of the operation. This interface, while simple and
efficient for writing into sequential zones of a zoned block device, is
incompatible with the use of sector values to calculate a cypher block
IV. All data written in a zone end up using the same IV values
corresponding to the first sectors of the zone, but read operation will
specify any sector within the zone, resulting in an IV mismatch between
encryption and decryption.

Using a single sector value (e.g. the zone start sector) for all read
and writes into a zone can solve this problem, but at the cost of
weakening the cypher chosen by the user. Instead, to solve this
problem, explicitly disable support for zone append operations using
the zone_append_not_supported field of struct dm_target if the IV mode
used is sector-based, that is for all IVs modes except null and random.

The cypher flag CRYPT_IV_NO_SECTORS iis introduced to indicate that the
cypher does not use sector values. This flag is set in
crypt_ctr_ivmode() for the null and random IV modes and checked in
crypt_ctr() to set to true zone_append_not_supported if
CRYPT_IV_NO_SECTORS is not set for the chosen cypher.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-crypt.c | 48 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b0ab080f2567..0a44bc0ff960 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -137,6 +137,7 @@ enum cipher_flags {
 	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cipher */
 	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sectors */
 	CRYPT_ENCRYPT_PREPROCESS,	/* Must preprocess data for encryption (elephant) */
+	CRYPT_IV_NO_SECTORS,		/* IV calculation does not use sectors */
 };
 
 /*
@@ -2750,9 +2751,10 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 	}
 
 	/* Choose ivmode, see comments at iv code. */
-	if (ivmode == NULL)
+	if (ivmode == NULL) {
 		cc->iv_gen_ops = NULL;
-	else if (strcmp(ivmode, "plain") == 0)
+		set_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags);
+	} else if (strcmp(ivmode, "plain") == 0)
 		cc->iv_gen_ops = &crypt_iv_plain_ops;
 	else if (strcmp(ivmode, "plain64") == 0)
 		cc->iv_gen_ops = &crypt_iv_plain64_ops;
@@ -2762,9 +2764,10 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 		cc->iv_gen_ops = &crypt_iv_essiv_ops;
 	else if (strcmp(ivmode, "benbi") == 0)
 		cc->iv_gen_ops = &crypt_iv_benbi_ops;
-	else if (strcmp(ivmode, "null") == 0)
+	else if (strcmp(ivmode, "null") == 0) {
 		cc->iv_gen_ops = &crypt_iv_null_ops;
-	else if (strcmp(ivmode, "eboiv") == 0)
+		set_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags);
+	} else if (strcmp(ivmode, "eboiv") == 0)
 		cc->iv_gen_ops = &crypt_iv_eboiv_ops;
 	else if (strcmp(ivmode, "elephant") == 0) {
 		cc->iv_gen_ops = &crypt_iv_elephant_ops;
@@ -2791,6 +2794,7 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
 	} else if (strcmp(ivmode, "random") == 0) {
 		cc->iv_gen_ops = &crypt_iv_random_ops;
+		set_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags);
 		/* Need storage space in integrity fields. */
 		cc->integrity_iv_size = cc->iv_size;
 	} else {
@@ -3281,14 +3285,31 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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
+		 * have the same BIO sector (the start of the zone). When the
+		 * cypher IV mode uses sector values, all data targeting a
+		 * zone will be encrypted using the first sector numbers of the
+		 * zone. This will not result in write errors but will
+		 * cause most reads to fail as reads will use the sector values
+		 * for the actual data location, resulting in IV mismatch.
+		 * To avoid this problem, allow zone append operations only for
+		 * cyphers with an IV mode not using sector values (null and
+		 * random IVs).
+		 */
+		if (!test_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags)) {
+			DMWARN("Zone append is not supported with sector-based IV cyphers");
+			ti->zone_append_not_supported = true;
+		}
 	}
 
 	if (crypt_integrity_aead(cc) || cc->integrity_iv_size) {
@@ -3356,6 +3377,15 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	struct dm_crypt_io *io;
 	struct crypt_config *cc = ti->private;
 
+	/*
+	 * For zoned targets using a sector based IV, zone append is not
+	 * supported. We should not see any such operation in that case.
+	 * In the unlikely case we do, warn and fail the request.
+	 */
+	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND &&
+			 !test_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags)))
+		return DM_MAPIO_KILL;
+
 	/*
 	 * If bio is REQ_PREFLUSH or REQ_OP_DISCARD, just bypass crypt queues.
 	 * - for REQ_PREFLUSH device-mapper core ensures that no IO is in-flight
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


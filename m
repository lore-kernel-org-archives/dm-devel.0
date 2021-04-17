Return-Path: <SRS0=ANAI=JO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF09C433ED
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 02:33:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ED17B61166
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 02:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED17B61166
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-MtdaYh8xPvaUMEiz6_oHSQ-1; Fri, 16 Apr 2021 22:33:44 -0400
X-MC-Unique: MtdaYh8xPvaUMEiz6_oHSQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB2C98030C4;
	Sat, 17 Apr 2021 02:33:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C9475C73F;
	Sat, 17 Apr 2021 02:33:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D7057E16E;
	Sat, 17 Apr 2021 02:33:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13H2XYOe031239 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 22:33:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CDA062138CF6; Sat, 17 Apr 2021 02:33:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C76F02138CF3
	for <dm-devel@redhat.com>; Sat, 17 Apr 2021 02:33:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF6A6805F06
	for <dm-devel@redhat.com>; Sat, 17 Apr 2021 02:33:34 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-328-NboaPIc3MOCycj52rkvqCg-1; Fri, 16 Apr 2021 22:33:30 -0400
X-MC-Unique: NboaPIc3MOCycj52rkvqCg-1
IronPort-SDR: L4Mbr213L41rcrkaeCAqSfN67Qko+LJr86KL3bClQk+x/Ky6lNjjzgWGTC82VyACbfZhVqHj1f
	KX7TmwLl+a8lL49a9FPwk/0Jr5XWsTxAvUmyT4+C1nScgMEbJS9qAqyANqmhU3R4roaURFt2/N
	ELHR7Fgyqa/qwVH8R/g/IZBuxTDVB2+/PsSncwcTRfUQhkqhArtqpb8Vq5Zm+SiBJLhiFkv7g0
	l+8kco2PtpO5ycy4FUx3paSn9EsLIkOY5rDgQ2TSTblgAGi2w68mi8OnT3TI7J8t3BdnyTnXJu
	qtM=
X-IronPort-AV: E=Sophos;i="5.82,228,1613404800"; d="scan'208";a="164553499"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 17 Apr 2021 10:33:30 +0800
IronPort-SDR: jkQ3/fAHGKx7IvhvhY6mWviQ+fI5urpIM1/Rq95AGUej2z0vfU8sOfXz22XzNFA2lxWnDRGW48
	rruUknBzZi2BFlv2qhKkInIHMQPdEzM95CfosKyayXLHZeCrEWo4A29pYE/ar+UMg/mrSHQnix
	T8/9KeEvWkZgBPJ87wdk+h1so02Uvg9kmtKsvUIN4H0Z1Ug6rkpFDTHgFaSttKD7FPpbsjQDNb
	kqqVNf9s4tCGCbMXs7uOoqVTdHWem6aEgb9Z92Jg05FuGdfRMJGpM9QEOC2i+A9/hnXHc+8CwQ
	u/khmmOpdw8DaD7I3Nu5f7/G
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	16 Apr 2021 19:14:18 -0700
IronPort-SDR: xIOtvDVVUoEgifhjwweuy0fDdzV0M33C9Q/9LAS60QbO2JgzCZQNnvvYqoXOtCsotU6X1Tq9qR
	fRdbluZIbVpVm7Kdm6M6AbxvVhXX7+gHfj7VFjUlI7ggjslKXnRGbmZJfxt6CaVyEs8yLLb2ap
	xcl4sfWnLREwFWWruNSyclYXh1u8MnxTlEANLAvHw5TsltOSm4gZTenFH5kwSSxriR+VFF6G7y
	W2tjR8E/oS3cFvaD2JFJzrVxFbgRKyUn3dhoGIoRLiEMlr6hZwjTvpgEuHhNk35wxgqQnQFfPH
	QTg=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 16 Apr 2021 19:33:29 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org
Date: Sat, 17 Apr 2021 11:33:22 +0900
Message-Id: <20210417023323.852530-3-damien.lemoal@wdc.com>
In-Reply-To: <20210417023323.852530-1-damien.lemoal@wdc.com>
References: <20210417023323.852530-1-damien.lemoal@wdc.com>
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
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [dm-devel] [PATCH v2 2/3] dm crypt: Fix zoned block device support
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
Fixes: 8e225f04d2dd ("dm crypt: Enable zoned block device support")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-crypt.c | 49 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b0ab080f2567..6ef35bb29ce5 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -137,6 +137,7 @@ enum cipher_flags {
 	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cipher */
 	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sectors */
 	CRYPT_ENCRYPT_PREPROCESS,	/* Must preprocess data for encryption (elephant) */
+	CRYPT_IV_ZONE_APPEND,		/* IV mode supports zone append operations */
 };
 
 /*
@@ -2750,9 +2751,10 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 	}
 
 	/* Choose ivmode, see comments at iv code. */
-	if (ivmode == NULL)
+	if (ivmode == NULL) {
 		cc->iv_gen_ops = NULL;
-	else if (strcmp(ivmode, "plain") == 0)
+		set_bit(CRYPT_IV_ZONE_APPEND, &cc->cipher_flags);
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
+		set_bit(CRYPT_IV_ZONE_APPEND, &cc->cipher_flags);
+	} else if (strcmp(ivmode, "eboiv") == 0)
 		cc->iv_gen_ops = &crypt_iv_eboiv_ops;
 	else if (strcmp(ivmode, "elephant") == 0) {
 		cc->iv_gen_ops = &crypt_iv_elephant_ops;
@@ -2791,6 +2794,7 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
 	} else if (strcmp(ivmode, "random") == 0) {
 		cc->iv_gen_ops = &crypt_iv_random_ops;
+		set_bit(CRYPT_IV_ZONE_APPEND, &cc->cipher_flags);
 		/* Need storage space in integrity fields. */
 		cc->integrity_iv_size = cc->iv_size;
 	} else {
@@ -3281,14 +3285,32 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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
+		 * for the actual data locations, resulting in IV mismatch.
+		 * To avoid this problem, allow zone append operations only when
+		 * the selected IV mode indicated that zone append operations
+		 * are supported, that is, IV modes that do not use sector
+		 * values (null and random IVs).
+		 */
+		if (!test_bit(CRYPT_IV_ZONE_APPEND, &cc->cipher_flags)) {
+			DMWARN("Zone append is not supported with the selected IV mode");
+			ti->zone_append_not_supported = true;
+		}
 	}
 
 	if (crypt_integrity_aead(cc) || cc->integrity_iv_size) {
@@ -3356,6 +3378,15 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	struct dm_crypt_io *io;
 	struct crypt_config *cc = ti->private;
 
+	/*
+	 * For zoned targets, we should not see any zone append operation if
+	 * the cypher IV mode selected does not support them. In the unlikely
+	 * case we do see one such operation, warn and fail the request.
+	 */
+	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND &&
+			 !test_bit(CRYPT_IV_ZONE_APPEND, &cc->cipher_flags)))
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


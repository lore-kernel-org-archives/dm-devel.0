Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30A8C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:23:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2925961244
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:23:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2925961244
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-VpXanwcENX6BiQ5WQILpmg-1; Thu, 20 May 2021 00:23:09 -0400
X-MC-Unique: VpXanwcENX6BiQ5WQILpmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0828E107ACE4;
	Thu, 20 May 2021 04:23:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E36D8690F3;
	Thu, 20 May 2021 04:23:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B6AF25535A;
	Thu, 20 May 2021 04:23:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K4Mjhg005837 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 00:22:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6268110728F; Thu, 20 May 2021 04:22:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D55C107299
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 467C41825067
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:45 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-410-h8a7ani0Otuk4JzLAX0ncw-2; Thu, 20 May 2021 00:22:43 -0400
X-MC-Unique: h8a7ani0Otuk4JzLAX0ncw-2
IronPort-SDR: ANXwNtXIBCFU/D1h4IQVe2zHR6GF9NQF+sd4SILGnj6tBAKqc5KsuurCUvFgmwk8Kn92eBi74B
	EMQPVF+yic678MdE5JVhd/+nDuZHQ2at8VnFnqlDxo2Iq4R2Rk3T4sRjNRqSx3lSB18yCXrr39
	1li5GLW/JxiopwuI9WOBzysafktyu6ZV+HJgcLatXvMAspNZJo1jb0dF9CmTdvwSVPPpJqM+Wr
	yzG4GUa3pqrAl82HV3fDIhuNAMjDIm2IF5Eu1zcAyyWzjoAhoQN8KMBLlJ+dRQue/zR2WXFMNR
	rRo=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="169343210"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 12:22:43 +0800
IronPort-SDR: X6dTinf33Ht3HpizrwlMfg+89O7rZUKeSyiF1Fc4c/bQQ0i4lAd++eLdKrkT7kXIipbBFvNpuW
	Ly5+gWX0Y1x4nsUjz/bylvjVRHlB2/TwxSOhbwgwxsHMuDj3MlBCtfG316TGi8UXVv752PK64X
	+o554QmFVJPWVxDRgEoyRXwRW1YMqavOzGeJrMjCTYdYQ3ikz6RBRd7PI4GfOQygxyIKhhosT1
	tln3mnv0/w+GsrJ25cx4yg06dwNuxKqSqpxUGby2UNmtr+mfzry1CibXH1iLF0SDBBrx0UGvIB
	GfaH34NhT5w0elOs0h4tLHXK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	19 May 2021 21:01:06 -0700
IronPort-SDR: uIEnt6j+SWWkCs8OnuX2F4ckxYIIbMDwF+h1O/e2ATFkGGhNDagi5H+9hnLbov9gRoM/vexk4M
	1VLze6v9TC2z5KsIFLIRgeJEgJZ4nthJn/T+LkLFh3Gp63losI3oC6aR4X0+uLK8bneewub9Mk
	O1c/VFTLphVK1QZbQRk+oUVFkJ7AHjoI5ORxCgkr7rN9mMU4rKxL70XJJKysuahRRby9XP1tM0
	Zj195sPrd9sYOwQ9p0Tn+fE6mpKDv7ygvIeptLnzXej/Hyyuk6qarV/r+xh1BLlDZweWrNZ+0o
	fkY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 19 May 2021 21:22:41 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Thu, 20 May 2021 13:22:28 +0900
Message-Id: <20210520042228.974083-12-damien.lemoal@wdc.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v2 11/11] dm crypt: Fix zoned block device support
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


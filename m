Return-Path: <SRS0=l+U7=HY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561B0C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 21:17:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 96B8664E02
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 21:17:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96B8664E02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-9NccFFmVPiGvrFDjHuUcPQ-1; Mon, 22 Feb 2021 16:15:59 -0500
X-MC-Unique: 9NccFFmVPiGvrFDjHuUcPQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D4811083E94;
	Mon, 22 Feb 2021 21:15:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D32A5C1BD;
	Mon, 22 Feb 2021 21:15:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2315F57DFA;
	Mon, 22 Feb 2021 21:15:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11MLFmNk014513 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Feb 2021 16:15:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 91137200AC37; Mon, 22 Feb 2021 21:15:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BA702166B2F
	for <dm-devel@redhat.com>; Mon, 22 Feb 2021 21:15:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4057185828C
	for <dm-devel@redhat.com>; Mon, 22 Feb 2021 21:15:46 +0000 (UTC)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
	[209.85.128.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-415-u437MtFeOkehDfwKcNNv5g-1; Mon, 22 Feb 2021 16:15:42 -0500
X-MC-Unique: u437MtFeOkehDfwKcNNv5g-1
Received: by mail-wm1-f51.google.com with SMTP id m1so545744wml.2;
	Mon, 22 Feb 2021 13:15:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=PTZ2O6n1+huK+yenKFB2tBEu7kgtsTkONtfh5Lrynjs=;
	b=orGA93iHc5gJN4Aq4gOaOJFc9w+uFu5hnrdCt8GN0trZDWcWJARgdIPxZuboI6bcB+
	h3x1iawtC+kL+RNCrKoeZ7hwbxilcNSX8WEDk4v/5hTcYrINI4y071+PokorZ/uSMfeA
	cobF8xDsRCE74Nq/SMgXNZTIA7VXNkhoVLdfY6DCmvjc7/6mTqJpGvhrbFyly1D6xO4B
	zNClG5wC8nN60r1+xGcz/LzxH9msaH1Qtijo2saaiIGw791FlEZkjujPd1OLs0Yeh2k4
	C87+QIfPByJ44ve7fnHzCZEAogk6TwsGEXKSZND9tpjCFPbj7EUrHsb+1z8+hiQCYP9q
	M5dQ==
X-Gm-Message-State: AOAM531hTBojPsIuyk+mCmQ6z+XS5Xk9L+PZWqmzaiz85xfzKX14Nl8W
	g89OX/VYMrpNw0mbaGVuBnwY/fjIpc8=
X-Google-Smtp-Source: ABdhPJwKxO7ww55rWxTCKE28swLyHI8Kc3r9qyZulBxzgdHlFeXPxUGcimZpekQdjmoxzZ4AhAcAdA==
X-Received: by 2002:a7b:c249:: with SMTP id b9mr6554345wmj.99.1614028540887;
	Mon, 22 Feb 2021 13:15:40 -0800 (PST)
Received: from merlot.mazyland.net (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.googlemail.com with ESMTPSA id
	h11sm483413wmq.26.2021.02.22.13.15.39
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 22 Feb 2021 13:15:40 -0800 (PST)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@redhat.com
Date: Mon, 22 Feb 2021 22:15:28 +0100
Message-Id: <20210222211528.848441-1-gmazyland@gmail.com>
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
Cc: mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>,
	samitolvanen@google.com
Subject: [dm-devel] [PATCH] dm-verity: Fix FEC for RS roots non-aligned to
	block size
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

Optional Forward Error Correction (FEC) code in dm-verity uses
Reed-Solomon code and should support roots from 2 to 24.

The error correction parity bytes (of roots lengths per RS block) are stored
on a separate device in sequence without any padding.

Currently, to access FEC device, the dm-verity-fec code uses dm-bufio client
with block size set to verity data block (usually 4096 or 512 bytes).

Because this block size is not divisible by some (most!) of the roots
supported lengths, data repair cannot work for partially stored
parity bytes.

This patch changes FEC device dm-bufio block size to "roots << SECTOR_SHIFT"
where we can be sure that the full parity data is always available.
(There cannot be partial FEC blocks because parity must cover whole sectors.)

Because the optional FEC starting offset could be unaligned to this
new block size, we have to use dm_bufio_set_sector_offset() to configure it.

The problem is easily reproducible using veritysetup,
here for example for roots=13:

  # create verity device with RS FEC
  dd if=/dev/urandom of=data.img bs=4096 count=8 status=none
  veritysetup format data.img hash.img --fec-device=fec.img --fec-roots=13 | awk '/^Root hash/{ print $3 }' >roothash

  # create an erasure that should be always repairable with this roots setting
  dd if=/dev/zero of=data.img conv=notrunc bs=1 count=8 seek=4088 status=none

  # try to read it through dm-verity
  veritysetup open data.img test hash.img --fec-device=fec.img --fec-roots=13 $(cat roothash)
  dd if=/dev/mapper/test of=/dev/null bs=4096 status=noxfer
  # wait for possible recursive recovery in kernel
  udevadm settle
  veritysetup close test

Without it, FEC code usually ends on unrecoverable failure in RS decoder:
  device-mapper: verity-fec: 7:1: FEC 0: failed to correct: -74
  ...

With the patch, errors are properly repaired.
  device-mapper: verity-fec: 7:1: FEC 0: corrected 8 errors
  ...

This problem is present in all kernels since the FEC code introduction (kernel 4.5).

AFAIK the problem is not visible in Android  ecosystem because it always
use default RS roots=2.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-verity-fec.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index fb41b4f23c48..be170581eb69 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -61,18 +61,18 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
 static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 			   unsigned *offset, struct dm_buffer **buf)
 {
-	u64 position, block;
+	u64 position, block, rem;
 	u8 *res;
 
 	position = (index + rsb) * v->fec->roots;
-	block = position >> v->data_dev_block_bits;
-	*offset = (unsigned)(position - (block << v->data_dev_block_bits));
+	block = div64_u64_rem(position, v->fec->roots << SECTOR_SHIFT, &rem);
+	*offset = (unsigned)rem;
 
-	res = dm_bufio_read(v->fec->bufio, v->fec->start + block, buf);
+	res = dm_bufio_read(v->fec->bufio, block, buf);
 	if (IS_ERR(res)) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
 		      v->data_dev->name, (unsigned long long)rsb,
-		      (unsigned long long)(v->fec->start + block),
+		      (unsigned long long)(block),
 		      PTR_ERR(res));
 		*buf = NULL;
 	}
@@ -155,7 +155,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 
 		/* read the next block when we run out of parity bytes */
 		offset += v->fec->roots;
-		if (offset >= 1 << v->data_dev_block_bits) {
+		if (offset >= (v->fec->roots << SECTOR_SHIFT)) {
 			dm_bufio_release(buf);
 
 			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
@@ -674,7 +674,7 @@ int verity_fec_ctr(struct dm_verity *v)
 {
 	struct dm_verity_fec *f = v->fec;
 	struct dm_target *ti = v->ti;
-	u64 hash_blocks;
+	u64 hash_blocks, start_blocks, fec_blocks;
 	int ret;
 
 	if (!verity_fec_is_enabled(v)) {
@@ -744,15 +744,18 @@ int verity_fec_ctr(struct dm_verity *v)
 	}
 
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
-					  1 << v->data_dev_block_bits,
+					  f->roots << SECTOR_SHIFT,
 					  1, 0, NULL, NULL);
 	if (IS_ERR(f->bufio)) {
 		ti->error = "Cannot initialize FEC bufio client";
 		return PTR_ERR(f->bufio);
 	}
 
-	if (dm_bufio_get_device_size(f->bufio) <
-	    ((f->start + f->rounds * f->roots) >> v->data_dev_block_bits)) {
+	dm_bufio_set_sector_offset(f->bufio, f->start << v->data_dev_block_bits >> SECTOR_SHIFT);
+
+	start_blocks = div64_u64(f->start << v->data_dev_block_bits, v->fec->roots << SECTOR_SHIFT);
+	fec_blocks   = div64_u64(f->rounds * f->roots, v->fec->roots << SECTOR_SHIFT);
+	if (dm_bufio_get_device_size(f->bufio) < (start_blocks + fec_blocks)) {
 		ti->error = "FEC device is too small";
 		return -E2BIG;
 	}
-- 
2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


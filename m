Return-Path: <SRS0=OBV6=JL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1C6C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 14 Apr 2021 17:18:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE73261164
	for <dm-devel@archiver.kernel.org>; Wed, 14 Apr 2021 17:18:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE73261164
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-U8oPDavOOtOJskSdLOhoww-1; Wed, 14 Apr 2021 13:18:30 -0400
X-MC-Unique: U8oPDavOOtOJskSdLOhoww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E3981006C85;
	Wed, 14 Apr 2021 17:18:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 59FBE62AF7;
	Wed, 14 Apr 2021 17:18:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 726139971;
	Wed, 14 Apr 2021 17:18:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13EFSwFT007099 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 14 Apr 2021 11:28:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5BB0BF556A; Wed, 14 Apr 2021 15:28:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52A7AF51BB
	for <dm-devel@redhat.com>; Wed, 14 Apr 2021 15:28:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF7EF802A61
	for <dm-devel@redhat.com>; Wed, 14 Apr 2021 15:28:54 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-214-O20dFFBXOdmRuj40IJ_ptA-1;
	Wed, 14 Apr 2021 11:28:51 -0400
X-MC-Unique: O20dFFBXOdmRuj40IJ_ptA-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id A122D61158;
	Wed, 14 Apr 2021 15:28:50 +0000 (UTC)
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: dm-devel@redhat.com
Date: Wed, 14 Apr 2021 08:28:28 -0700
Message-Id: <20210414152828.760900-1-jaegeuk@kernel.org>
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
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13EFSwFT007099
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 14 Apr 2021 13:14:03 -0400
Cc: snitzer@redhat.com, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@google.com>, kernel-team@android.com, agk@redhat.com
Subject: [dm-devel] [PATCH RESEND] dm verity: fix not aligned logical block
	size of RS roots IO
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Jaegeuk Kim <jaegeuk@google.com>

commit df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to block size")
made dm_bufio->block_size 1024, if f->roots is 2. But, that gives the below EIO
if the logical block size of the device is 4096, given v->data_dev_block_bits=12.

E sd 0    : 0:0:0: [sda] tag#30 request not aligned to the logical block size
E blk_update_request: I/O error, dev sda, sector 10368424 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
E device-mapper: verity-fec: 254:8: FEC 9244672: parity read failed (block 18056): -5

Let's use f->roots for dm_bufio iff it's aligned to v->data_dev_block_bits.

Fixes: df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to block size")
Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/md/dm-verity-fec.c | 11 ++++++++---
 drivers/md/dm-verity-fec.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 66f4c6398f67..cea2b3789736 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -65,7 +65,7 @@ static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 	u8 *res;
 
 	position = (index + rsb) * v->fec->roots;
-	block = div64_u64_rem(position, v->fec->roots << SECTOR_SHIFT, &rem);
+	block = div64_u64_rem(position, v->fec->io_size, &rem);
 	*offset = (unsigned)rem;
 
 	res = dm_bufio_read(v->fec->bufio, block, buf);
@@ -154,7 +154,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 
 		/* read the next block when we run out of parity bytes */
 		offset += v->fec->roots;
-		if (offset >= v->fec->roots << SECTOR_SHIFT) {
+		if (offset >= v->fec->io_size) {
 			dm_bufio_release(buf);
 
 			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
@@ -742,8 +742,13 @@ int verity_fec_ctr(struct dm_verity *v)
 		return -E2BIG;
 	}
 
+	if ((f->roots << SECTOR_SHIFT) & ((1 << v->data_dev_block_bits) - 1))
+		f->io_size = 1 << v->data_dev_block_bits;
+	else
+		f->io_size = v->fec->roots << SECTOR_SHIFT;
+
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
-					  f->roots << SECTOR_SHIFT,
+					  f->io_size,
 					  1, 0, NULL, NULL);
 	if (IS_ERR(f->bufio)) {
 		ti->error = "Cannot initialize FEC bufio client";
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 42fbd3a7fc9f..3c46c8d61883 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -36,6 +36,7 @@ struct dm_verity_fec {
 	struct dm_dev *dev;	/* parity data device */
 	struct dm_bufio_client *data_bufio;	/* for data dev access */
 	struct dm_bufio_client *bufio;		/* for parity data access */
+	size_t io_size;		/* IO size for roots */
 	sector_t start;		/* parity data start in blocks */
 	sector_t blocks;	/* number of blocks covered */
 	sector_t rounds;	/* number of interleaving rounds */
-- 
2.31.1.295.g9ea45b61b8-goog


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=Qr9I=M3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A721C4338F
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 10:03:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A6A0C61050
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 10:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A6A0C61050
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-yRmq0_E2MDSI5icJQdQC0g-1; Wed, 04 Aug 2021 06:02:59 -0400
X-MC-Unique: yRmq0_E2MDSI5icJQdQC0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37582802923;
	Wed,  4 Aug 2021 10:02:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10EDE5D6B1;
	Wed,  4 Aug 2021 10:02:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE5434A7CA;
	Wed,  4 Aug 2021 10:02:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 174A2bUF007376 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Aug 2021 06:02:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 38DBEDEE71; Wed,  4 Aug 2021 10:02:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29C47EAFA6
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 10:02:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACE1A803CB8
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 10:02:33 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-515-XQl5Zty_PHOUdRxp9zyVRw-1; Wed, 04 Aug 2021 06:02:31 -0400
X-MC-Unique: XQl5Zty_PHOUdRxp9zyVRw-1
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mBDi1-005fHw-82; Wed, 04 Aug 2021 10:01:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  4 Aug 2021 11:56:25 +0200
Message-Id: <20210804095634.460779-7-hch@lst.de>
In-Reply-To: <20210804095634.460779-1-hch@lst.de>
References: <20210804095634.460779-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Ilya Dryomov <idryomov@gmail.com>, linux-um@lists.infradead.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, ceph-devel@vger.kernel.org,
	linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Geoff Levand <geoff@infradead.org>,
	Phillip Lougher <phillip@squashfs.org.uk>
Subject: [dm-devel] [PATCH 06/15] squashfs: use bvec_virt
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

Use bvec_virt instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/squashfs/block.c        | 7 +++----
 fs/squashfs/lz4_wrapper.c  | 2 +-
 fs/squashfs/lzo_wrapper.c  | 2 +-
 fs/squashfs/xz_wrapper.c   | 2 +-
 fs/squashfs/zlib_wrapper.c | 2 +-
 fs/squashfs/zstd_wrapper.c | 2 +-
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 855f0e87066d..2db8bcf7ff85 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -49,8 +49,7 @@ static int copy_bio_to_actor(struct bio *bio,
 
 		bytes_to_copy = min_t(int, bytes_to_copy,
 				      req_length - copied_bytes);
-		memcpy(actor_addr + actor_offset,
-		       page_address(bvec->bv_page) + bvec->bv_offset + offset,
+		memcpy(actor_addr + actor_offset, bvec_virt(bvec) + offset,
 		       bytes_to_copy);
 
 		actor_offset += bytes_to_copy;
@@ -177,7 +176,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 			goto out_free_bio;
 		}
 		/* Extract the length of the metadata block */
-		data = page_address(bvec->bv_page) + bvec->bv_offset;
+		data = bvec_virt(bvec);
 		length = data[offset];
 		if (offset < bvec->bv_len - 1) {
 			length |= data[offset + 1] << 8;
@@ -186,7 +185,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 				res = -EIO;
 				goto out_free_bio;
 			}
-			data = page_address(bvec->bv_page) + bvec->bv_offset;
+			data = bvec_virt(bvec);
 			length |= data[0] << 8;
 		}
 		bio_free_pages(bio);
diff --git a/fs/squashfs/lz4_wrapper.c b/fs/squashfs/lz4_wrapper.c
index 233d5582fbee..b685b6238316 100644
--- a/fs/squashfs/lz4_wrapper.c
+++ b/fs/squashfs/lz4_wrapper.c
@@ -101,7 +101,7 @@ static int lz4_uncompress(struct squashfs_sb_info *msblk, void *strm,
 	while (bio_next_segment(bio, &iter_all)) {
 		int avail = min(bytes, ((int)bvec->bv_len) - offset);
 
-		data = page_address(bvec->bv_page) + bvec->bv_offset;
+		data = bvec_virt(bvec);
 		memcpy(buff, data + offset, avail);
 		buff += avail;
 		bytes -= avail;
diff --git a/fs/squashfs/lzo_wrapper.c b/fs/squashfs/lzo_wrapper.c
index 97bb7d92ddcd..cb510a631968 100644
--- a/fs/squashfs/lzo_wrapper.c
+++ b/fs/squashfs/lzo_wrapper.c
@@ -76,7 +76,7 @@ static int lzo_uncompress(struct squashfs_sb_info *msblk, void *strm,
 	while (bio_next_segment(bio, &iter_all)) {
 		int avail = min(bytes, ((int)bvec->bv_len) - offset);
 
-		data = page_address(bvec->bv_page) + bvec->bv_offset;
+		data = bvec_virt(bvec);
 		memcpy(buff, data + offset, avail);
 		buff += avail;
 		bytes -= avail;
diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
index e80419aed862..68f6d09bb3a2 100644
--- a/fs/squashfs/xz_wrapper.c
+++ b/fs/squashfs/xz_wrapper.c
@@ -146,7 +146,7 @@ static int squashfs_xz_uncompress(struct squashfs_sb_info *msblk, void *strm,
 			}
 
 			avail = min(length, ((int)bvec->bv_len) - offset);
-			data = page_address(bvec->bv_page) + bvec->bv_offset;
+			data = bvec_virt(bvec);
 			length -= avail;
 			stream->buf.in = data + offset;
 			stream->buf.in_size = avail;
diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index bcb881ec47f2..a20e9042146b 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -76,7 +76,7 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void *strm,
 			}
 
 			avail = min(length, ((int)bvec->bv_len) - offset);
-			data = page_address(bvec->bv_page) + bvec->bv_offset;
+			data = bvec_virt(bvec);
 			length -= avail;
 			stream->next_in = data + offset;
 			stream->avail_in = avail;
diff --git a/fs/squashfs/zstd_wrapper.c b/fs/squashfs/zstd_wrapper.c
index b7cb1faa652d..0015cf8b5582 100644
--- a/fs/squashfs/zstd_wrapper.c
+++ b/fs/squashfs/zstd_wrapper.c
@@ -94,7 +94,7 @@ static int zstd_uncompress(struct squashfs_sb_info *msblk, void *strm,
 			}
 
 			avail = min(length, ((int)bvec->bv_len) - offset);
-			data = page_address(bvec->bv_page) + bvec->bv_offset;
+			data = bvec_virt(bvec);
 			length -= avail;
 			in_buf.src = data + offset;
 			in_buf.size = avail;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


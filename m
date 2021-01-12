Return-Path: <SRS0=y4zT=GP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C890EC433E9
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:16:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC9D922D2A
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:16:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC9D922D2A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-r851hcKYNze4j5YCXAKP8w-1; Tue, 12 Jan 2021 04:16:53 -0500
X-MC-Unique: r851hcKYNze4j5YCXAKP8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27AA1800050;
	Tue, 12 Jan 2021 09:16:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78069100164C;
	Tue, 12 Jan 2021 09:16:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7DDC14A7C6;
	Tue, 12 Jan 2021 09:16:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10C5qDnm008725 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 12 Jan 2021 00:52:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9B740110FC18; Tue, 12 Jan 2021 05:52:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96D0E110FC16
	for <dm-devel@redhat.com>; Tue, 12 Jan 2021 05:52:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6BC8185A794
	for <dm-devel@redhat.com>; Tue, 12 Jan 2021 05:52:10 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
	(out30-132.freemail.mail.aliyun.com [115.124.30.132]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-150-zypVpDafO--BI05o4HEHKg-1;
	Tue, 12 Jan 2021 00:52:07 -0500
X-MC-Unique: zypVpDafO--BI05o4HEHKg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R331e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
	TI=SMTPD_---0ULVEzsr_1610430720
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0ULVEzsr_1610430720) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 12 Jan 2021 13:52:00 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
Date: Tue, 12 Jan 2021 13:52:00 +0800
Message-Id: <20210112055200.86897-1-jefflexu@linux.alibaba.com>
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
X-Mailman-Approved-At: Tue, 12 Jan 2021 04:16:42 -0500
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm: cleanup of front padding calculation
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Add two helper macros calculating the offset of bio in struct dm_io and
struct dm_target_io respectively.

Besides, simplify the front padding calculation in
dm_alloc_md_mempools().

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b3c3c8b4cb42..b992fdaa297a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -105,12 +105,16 @@ struct dm_io {
 	struct dm_target_io tio;
 };
 
+#define DM_TARGET_IO_BIO_OFFSET (offsetof(struct dm_target_io, clone))
+#define DM_IO_BIO_OFFSET \
+	(offsetof(struct dm_target_io, clone) + offsetof(struct dm_io, tio))
+
 void *dm_per_bio_data(struct bio *bio, size_t data_size)
 {
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	if (!tio->inside_dm_io)
-		return (char *)bio - offsetof(struct dm_target_io, clone) - data_size;
-	return (char *)bio - offsetof(struct dm_target_io, clone) - offsetof(struct dm_io, tio) - data_size;
+		return (char *)bio - DM_TARGET_IO_BIO_OFFSET - data_size;
+	return (char *)bio - DM_IO_BIO_OFFSET - data_size;
 }
 EXPORT_SYMBOL_GPL(dm_per_bio_data);
 
@@ -118,9 +122,9 @@ struct bio *dm_bio_from_per_bio_data(void *data, size_t data_size)
 {
 	struct dm_io *io = (struct dm_io *)((char *)data + data_size);
 	if (io->magic == DM_IO_MAGIC)
-		return (struct bio *)((char *)io + offsetof(struct dm_io, tio) + offsetof(struct dm_target_io, clone));
+		return (struct bio *)((char *)io + DM_IO_BIO_OFFSET);
 	BUG_ON(io->magic != DM_TIO_MAGIC);
-	return (struct bio *)((char *)io + offsetof(struct dm_target_io, clone));
+	return (struct bio *)((char *)io + DM_TARGET_IO_BIO_OFFSET);
 }
 EXPORT_SYMBOL_GPL(dm_bio_from_per_bio_data);
 
@@ -2849,8 +2853,8 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
 		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
-		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
-		io_front_pad = roundup(front_pad,  __alignof__(struct dm_io)) + offsetof(struct dm_io, tio);
+		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + DM_TARGET_IO_BIO_OFFSET;
+		io_front_pad = roundup(per_io_data_size,  __alignof__(struct dm_io)) + DM_IO_BIO_OFFSET;
 		ret = bioset_init(&pools->io_bs, pool_size, io_front_pad, 0);
 		if (ret)
 			goto out;
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


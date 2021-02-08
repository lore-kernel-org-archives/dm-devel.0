Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2692C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:35:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 739B564E0F
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 739B564E0F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-66o09tk1NBqSQ3yYaWPjCw-1; Wed, 17 Feb 2021 10:35:05 -0500
X-MC-Unique: 66o09tk1NBqSQ3yYaWPjCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF38D835E22;
	Wed, 17 Feb 2021 15:35:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CC7039A5F;
	Wed, 17 Feb 2021 15:35:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1933618095CA;
	Wed, 17 Feb 2021 15:35:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1188qu7U030005 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 03:52:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DEF602166B2F; Mon,  8 Feb 2021 08:52:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D8E182166B29
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 08:52:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 893E1858F1B
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 08:52:53 +0000 (UTC)
Received: from out30-44.freemail.mail.aliyun.com
	(out30-44.freemail.mail.aliyun.com [115.124.30.44]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-33-5n0LtQFGNx6jAaJG8bLpNA-1;
	Mon, 08 Feb 2021 03:52:48 -0500
X-MC-Unique: 5n0LtQFGNx6jAaJG8bLpNA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R411e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UO8W.Pu_1612774364
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UO8W.Pu_1612774364) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 08 Feb 2021 16:52:45 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com, axboe@kernel.dk
Date: Mon,  8 Feb 2021 16:52:33 +0800
Message-Id: <20210208085243.82367-2-jefflexu@linux.alibaba.com>
In-Reply-To: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
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
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: caspar@linux.alibaba.com, hch@lst.de, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: [dm-devel] [PATCH v3 01/11] block: move definition of blk_qc_t to
	types.h
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

So that kiocb.ki_cookie can be defined as blk_qc_t, which will enforce
the encapsulation.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/blk_types.h | 2 +-
 include/linux/fs.h        | 2 +-
 include/linux/types.h     | 3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 866f74261b3b..2e05244fc16d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -532,7 +532,7 @@ static inline int op_stat_group(unsigned int op)
 	return op_is_write(op);
 }
 
-typedef unsigned int blk_qc_t;
+/* Macros for blk_qc_t */
 #define BLK_QC_T_NONE		-1U
 #define BLK_QC_T_SHIFT		16
 #define BLK_QC_T_INTERNAL	(1U << 31)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fd47deea7c17..04b687150736 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -330,7 +330,7 @@ struct kiocb {
 	u16			ki_hint;
 	u16			ki_ioprio; /* See linux/ioprio.h */
 	union {
-		unsigned int		ki_cookie; /* for ->iopoll */
+		blk_qc_t		ki_cookie; /* for ->iopoll */
 		struct wait_page_queue	*ki_waitq; /* for async buffered IO */
 	};
 
diff --git a/include/linux/types.h b/include/linux/types.h
index a147977602b5..da5ca7e1bea9 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -125,6 +125,9 @@ typedef s64			int64_t;
 typedef u64 sector_t;
 typedef u64 blkcnt_t;
 
+/* cookie used for IO polling */
+typedef unsigned int blk_qc_t;
+
 /*
  * The type of an index into the pagecache.
  */
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


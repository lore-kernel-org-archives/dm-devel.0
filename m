Return-Path: <SRS0=Xutw=LK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA10C48BE5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 13:07:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C756B6024A
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 13:07:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C756B6024A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623848829;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FJlMNoUhsdxjOSGwagQiwGux4ll5bFYAxHS/VKQwRuE=;
	b=DAhGub2oWbkgLHKWd8oXhbeINSZspeFTxze+zBFT1SqCI5EiQUmm2HihhjTsx0OHGYBFId
	SeFYmNb4hkPPBkXO4jZGLXwY1vbC3QaJSQdyu2bPiXuQIzgJ9VllFkokDbr7kwrpUMC6gs
	PPFBtxpvsMfHQKRl7r9RApC7U5iYUNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-S9HPkXU3P92Xi8siumThjg-1; Wed, 16 Jun 2021 09:07:07 -0400
X-MC-Unique: S9HPkXU3P92Xi8siumThjg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B7D1100C62A;
	Wed, 16 Jun 2021 13:07:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 408236060F;
	Wed, 16 Jun 2021 13:07:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 94FA346F59;
	Wed, 16 Jun 2021 13:06:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15GD6wM1001422 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Jun 2021 09:06:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 447AE60CC9; Wed, 16 Jun 2021 13:06:58 +0000 (UTC)
Received: from localhost (ovpn-12-48.pek2.redhat.com [10.72.12.48])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7159160C13;
	Wed, 16 Jun 2021 13:06:57 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Wed, 16 Jun 2021 21:05:31 +0800
Message-Id: <20210616130533.754248-3-ming.lei@redhat.com>
In-Reply-To: <20210616130533.754248-1-ming.lei@redhat.com>
References: <20210616130533.754248-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [RFC PATCH 2/4] block: add field of .bi_bio_drv_data to
	bio
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

After bio is submitted, bio->bi_next is used for IO merge for request
based queue only.

Reuse the filed for bio based driver for storing driver data, and name
it as .bi_bio_drv_data.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/blk_types.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 6e6c2af48d74..acb45213338c 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -220,7 +220,16 @@ typedef unsigned int blk_qc_t;
  * stacking drivers)
  */
 struct bio {
-	struct bio		*bi_next;	/* request queue link */
+	union {
+		/* request queue link */
+		struct bio		*bi_next;
+
+		/*
+		 * once bio is submitted to bio based queue, driver can use
+		 * this field to store its own data
+		 */
+		void			*bi_bio_drv_data;
+	};
 	struct block_device	*bi_bdev;
 	unsigned int		bi_opf;		/* bottom bits req flags,
 						 * top bits REQ_OP. Use
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


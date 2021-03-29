Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C573C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 15:27:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3EE7361932
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 15:27:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EE7361932
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617031660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CoyBIFn6xHg4Ak+VoDhr6CHJvIQdfAiw1ZGIvOoZdHw=;
	b=MPEeO20XAFR9aFeK198YaQn+14nW06QIOCITtwkGnLfpRqZegeofNuw4bZD5Ta40OFPXqc
	N06Shd2qtYSkz7kdgS6o9MMpjNUDgi2DSfJ44asL/rFmACJlzAaEqJeHIkH6qMsAxVzaUD
	+MXCvqlqfuu4GUckA800DMyC5hGRfEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-aHcnEWgBNsSBsup3wRpMnA-1; Mon, 29 Mar 2021 11:27:38 -0400
X-MC-Unique: aHcnEWgBNsSBsup3wRpMnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C4E3108BD1D;
	Mon, 29 Mar 2021 15:27:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DE7D60CE6;
	Mon, 29 Mar 2021 15:27:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D75DD1800216;
	Mon, 29 Mar 2021 15:27:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12TFRScx019387 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 11:27:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3C7BA2C01F; Mon, 29 Mar 2021 15:27:28 +0000 (UTC)
Received: from localhost (ovpn-12-50.pek2.redhat.com [10.72.12.50])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 895A959441;
	Mon, 29 Mar 2021 15:26:55 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 29 Mar 2021 23:26:12 +0800
Message-Id: <20210329152622.173035-3-ming.lei@redhat.com>
In-Reply-To: <20210329152622.173035-1-ming.lei@redhat.com>
References: <20210329152622.173035-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [dm-devel] [PATCH V4 02/12] block: add one helper to free io_context
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

Prepare for putting bio poll queue into io_context, so add one helper
for free io_context.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-ioc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 57299f860d41..b0cde18c4b8c 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -17,6 +17,11 @@
  */
 static struct kmem_cache *iocontext_cachep;
 
+static inline void free_io_context(struct io_context *ioc)
+{
+	kmem_cache_free(iocontext_cachep, ioc);
+}
+
 /**
  * get_io_context - increment reference count to io_context
  * @ioc: io_context to get
@@ -129,7 +134,7 @@ static void ioc_release_fn(struct work_struct *work)
 
 	spin_unlock_irq(&ioc->lock);
 
-	kmem_cache_free(iocontext_cachep, ioc);
+	free_io_context(ioc);
 }
 
 /**
@@ -164,7 +169,7 @@ void put_io_context(struct io_context *ioc)
 	}
 
 	if (free_ioc)
-		kmem_cache_free(iocontext_cachep, ioc);
+		free_io_context(ioc);
 }
 
 /**
@@ -278,7 +283,7 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
 	    (task == current || !(task->flags & PF_EXITING)))
 		task->io_context = ioc;
 	else
-		kmem_cache_free(iocontext_cachep, ioc);
+		free_io_context(ioc);
 
 	ret = task->io_context ? 0 : -EBUSY;
 
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


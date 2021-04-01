Return-Path: <SRS0=Hv8r=I6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDC1C43460
	for <dm-devel@archiver.kernel.org>; Thu,  1 Apr 2021 02:21:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D64836101E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Apr 2021 02:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D64836101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617243716;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mirgJqIbPFX+53RwTQq89Siuhfn9m76Zffmktu6KSuU=;
	b=Di5UoVWSoDmfBD0O4b2B5QWmnTMtJlQL9tVmJ/eZc9klwBOkI1WNk+0oGUHSFuW+w4Rw+C
	KGRxuS4JyX8InTZmyoNkQyg3hgcC7S4W5j2SrA696AeSvj98IQI7c36Ahd+5UxD85tvT6M
	j4gs0BhhiQpl8actrBWwNA3j32ZgP3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-O-ZZMBwHOlG--yYu4MpHvw-1; Wed, 31 Mar 2021 22:21:54 -0400
X-MC-Unique: O-ZZMBwHOlG--yYu4MpHvw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA201107ACCD;
	Thu,  1 Apr 2021 02:21:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C58D719D80;
	Thu,  1 Apr 2021 02:21:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 61C754A705;
	Thu,  1 Apr 2021 02:21:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1312L9x6017559 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 31 Mar 2021 22:21:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id ECC8E59454; Thu,  1 Apr 2021 02:21:09 +0000 (UTC)
Received: from localhost (ovpn-12-93.pek2.redhat.com [10.72.12.93])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 781E06E70D;
	Thu,  1 Apr 2021 02:20:59 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  1 Apr 2021 10:19:20 +0800
Message-Id: <20210401021927.343727-6-ming.lei@redhat.com>
In-Reply-To: <20210401021927.343727-1-ming.lei@redhat.com>
References: <20210401021927.343727-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [dm-devel] [PATCH V5 05/12] block: add new field into 'struct
	bvec_iter'
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

There is a hole at the end of 'struct bvec_iter', so put a new field
here and we can save cookie returned from submit_bio() here for
supporting bio based polling.

This way can avoid to extend bio unnecessarily.

Meantime add two helpers to get/set this field.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk.h          | 10 ++++++++++
 include/linux/bvec.h |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/block/blk.h b/block/blk.h
index 35901cee709d..c1d8456656df 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -395,4 +395,14 @@ static inline void blk_create_io_poll_context(struct request_queue *q)
 		bio_poll_ctx_alloc(ioc);
 }
 
+static inline unsigned int bio_get_private_data(struct bio *bio)
+{
+	return bio->bi_iter.bi_private_data;
+}
+
+static inline void bio_set_private_data(struct bio *bio, unsigned int data)
+{
+	bio->bi_iter.bi_private_data = data;
+}
+
 #endif /* BLK_INTERNAL_H */
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index ff832e698efb..547ad7526960 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -43,6 +43,14 @@ struct bvec_iter {
 
 	unsigned int            bi_bvec_done;	/* number of bytes completed in
 						   current bvec */
+
+	/*
+	 * There is a hole at the end of bvec_iter, add one new field to hold
+	 * something which isn't related with 'bvec_iter', so that we can
+	 * avoid extending bio. So far this new field is used for bio based
+	 * polling, we will store returning value of submit_bio() here.
+	 */
+	unsigned int		bi_private_data;
 };
 
 struct bvec_iter_all {
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


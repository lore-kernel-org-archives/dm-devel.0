Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C66B8C43217
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-2TzaPcSyMtG_8ePMBQvzMw-1; Sun, 17 Apr 2022 22:27:55 -0400
X-MC-Unique: 2TzaPcSyMtG_8ePMBQvzMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 042D0811E78;
	Mon, 18 Apr 2022 02:27:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8873145BA54;
	Mon, 18 Apr 2022 02:27:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD92F19451F1;
	Mon, 18 Apr 2022 02:27:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E34DD194034F
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C53E340F495E; Mon, 18 Apr 2022 02:27:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C0EF040F4941
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA417185A7A4
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:51 +0000 (UTC)
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com
 [209.85.222.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-hhAYqFlMPn6b6TgW9g_LCw-2; Sun, 17 Apr 2022 22:27:50 -0400
X-MC-Unique: hhAYqFlMPn6b6TgW9g_LCw-2
Received: by mail-qk1-f173.google.com with SMTP id e128so8240604qkd.7
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=ndIDyPfVlDVkX+WyqwxK5RiwctnNFTeMuPYc14gJico=;
 b=f2AowajNkWbKzk2VKKIZfwKVYHOAxYdbZrlWfN764bESBkSW73ucqGCUwK7uMDaS51
 sLQCdVA8bT2mcVmh+Po+sIarrI1UDq05xFUV+igWoj/aO64uL6rcrNOfkeGYcnccib7H
 uKRwxjwgQhE8qS/bp8EjUegR3fxYVbXwYlRV1k5+JlMAPzY3AzyZc2vyy7QNjP7TMbkU
 /I85pu9VqZWitYPN9Qwp27oSnd3WXv7UcKRdyVE8aPi1EdDfI42gchxGsMTotDr8jdNd
 BTqxFti3dytvo6E7qn3XK0IwKJEooRSGgoCtaQff2wp+d/PL9bC8QW0RnZrb7aIY3/8p
 ul+Q==
X-Gm-Message-State: AOAM530hb2xjfgSnB+zAz/gId9/I42nyb+w8DFGHdKvwT0mIBlddHLwu
 2dXa4wHK16zVsHcCh9Lh2favO8KU839vIn3c3bVz2pfJtrz0t2p+Jc13G/jQsAYj3LsmxJiL7DJ
 cYthulgrWgIW3vHuCdJua+lwqQah3Q8SV5D8sw+zuYLnAtxzMOY4NboKfcmxVjxg62mI=
X-Google-Smtp-Source: ABdhPJxAWngH3gF3AK7LyMK/wnSsn8K+fY8tU6Plkjl+CJoFNW8mSEdselJUBNYSPxnUMxDyD+56MQ==
X-Received: by 2002:a37:aa8d:0:b0:69e:9974:4d1b with SMTP id
 t135-20020a37aa8d000000b0069e99744d1bmr1843256qke.524.1650248869477; 
 Sun, 17 Apr 2022 19:27:49 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 f11-20020a05622a1a0b00b002f1f3b66bd4sm3596968qtb.94.2022.04.17.19.27.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:48 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:24 -0400
Message-Id: <20220418022733.56168-13-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [dm-5.19 PATCH 12/21] dm: use bio_sectors in
 dm_aceept_partial_bio
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Rename 'bi_size' to 'bio_sectors' given bi_size is being stored in
sectors.  Also, use bio_sectors() rather than open-coding it.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3359b55daa99..c8933d7e6a78 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1195,7 +1195,7 @@ static int dm_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
  * +--------------------+---------------+-------+
  *
  * <-------------- *tio->len_ptr --------------->
- *                      <------- bi_size ------->
+ *                      <----- bio_sectors ----->
  *                      <-- n_sectors -->
  *
  * Region 1 was already iterated over with bio_advance or similar function.
@@ -1212,15 +1212,15 @@ static int dm_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 {
 	struct dm_target_io *tio = clone_to_tio(bio);
-	unsigned bi_size = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+	unsigned bio_sectors = bio_sectors(bio);
 
 	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
 	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
 	BUG_ON(bio_op(bio) == REQ_OP_ZONE_APPEND);
-	BUG_ON(bi_size > *tio->len_ptr);
-	BUG_ON(n_sectors > bi_size);
+	BUG_ON(bio_sectors > *tio->len_ptr);
+	BUG_ON(n_sectors > bio_sectors);
 
-	*tio->len_ptr -= bi_size - n_sectors;
+	*tio->len_ptr -= bio_sectors - n_sectors;
 	bio->bi_iter.bi_size = n_sectors << SECTOR_SHIFT;
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


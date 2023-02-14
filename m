Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6279C6379F
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 09:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676453644;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ngYF4L35C3p/8w/Plt2gq5kt26vQ7YAFnmCn80CMkT0=;
	b=KafMpHtUAChHMnMlSh1UAfcwyIYc6r3xmDdCmLqSGp7uF4R02Gvpjgk6BoVd9k/Z0ygstf
	8PitbPrY3sUkokNZMa5c24C/bZmH4m05MYIDcE5zlPmUzSNz4uUXjfKjg2uAorf4hLt6vJ
	6Ht9/2kQ5fwOoR/eUwXDL19ZBlMpFLI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-u6xgL-jMOgaORRd-DOW9bw-1; Wed, 15 Feb 2023 04:33:46 -0500
X-MC-Unique: u6xgL-jMOgaORRd-DOW9bw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99F001C0691F;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A909714171BA;
	Wed, 15 Feb 2023 09:33:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 626FC1946A43;
	Wed, 15 Feb 2023 09:33:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0F3AC1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 19:02:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D996040B40E4; Tue, 14 Feb 2023 19:02:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D131540B40C9
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:02:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD12E801779
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:02:44 +0000 (UTC)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
 [209.85.166.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-418-pN8vXBqeOqGsN3qlBibMQQ-1; Tue, 14 Feb 2023 14:02:41 -0500
X-MC-Unique: pN8vXBqeOqGsN3qlBibMQQ-1
Received: by mail-il1-f173.google.com with SMTP id v13so5098205iln.4;
 Tue, 14 Feb 2023 11:02:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=mFajPTMRcCMM2sMtnpqlL+/MlXEk9UiKBjz1wMnJjFA=;
 b=4YhkyFYgIOqBuLBjbeHKgSmyWG4x4I9kK/7PhDQFJEJb/+UV9w/3KAnJ+8shXUX9Bd
 idDK2Y3Icv135zYlm7E0D9mADylkJd3o35gh6USTFcTm/TSSa/K24MyVn7LAXEqn/PXj
 yCyTSG1jN1px/XUoWQaczw04a9mLdEi7YUOLK4nLbtvb1xSsX0jpw5fReGFhHrYv/7z1
 nk2F2R2i4DBeskU+b8UGSzNUCjOizofsxI/MX5bUU3H/7KW3Cnl05xPqHX+3MB7XAgIK
 ksMvPtPruorv5xG3NttbpZ40pRIhM9ObN8HgI3Jh4QmplJ7WuOaKD574461I9/HNI1gw
 JXow==
X-Gm-Message-State: AO0yUKXcKluDY0YWpV4gAMyNIF1QeEJHokYPbGZeKhnZBsvLJbgz3Wij
 CgWdG3SJYgOF1Nf0TgiAt2A=
X-Google-Smtp-Source: AK7set+zChOBkvDmv8upovQoaKfuAxrbFAxXV5MZ5rjassuOdi24vOvvtuhY+6wN48rk9TwI/nKFhA==
X-Received: by 2002:a05:6e02:1b8c:b0:315:45c5:9185 with SMTP id
 h12-20020a056e021b8c00b0031545c59185mr3407244ili.31.1676401360782; 
 Tue, 14 Feb 2023 11:02:40 -0800 (PST)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net.
 [67.174.241.145]) by smtp.gmail.com with ESMTPSA id
 r11-20020a056e0219cb00b0030c27c9eea4sm3608770ill.33.2023.02.14.11.02.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Feb 2023 11:02:40 -0800 (PST)
From: Yang Shi <shy828301@gmail.com>
To: mgorman@techsingularity.net, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, akpm@linux-foundation.org
Date: Tue, 14 Feb 2023 11:02:20 -0800
Message-Id: <20230214190221.1156876-5-shy828301@gmail.com>
In-Reply-To: <20230214190221.1156876-1-shy828301@gmail.com>
References: <20230214190221.1156876-1-shy828301@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 15 Feb 2023 09:33:38 +0000
Subject: [dm-devel] [v2 PATCH 4/5] md: dm-crypt: move
 crypt_free_buffer_pages ahead
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
Cc: linux-block@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

With moving crypt_free_buffer_pages() before crypt_alloc_buffer(), we
don't need an extra declaration anymore.

Signed-off-by: Yang Shi <shy828301@gmail.com>
---
 drivers/md/dm-crypt.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 2653516bcdef..73069f200cc5 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1639,7 +1639,17 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 	return 0;
 }
 
-static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
+
+static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
+{
+	struct bio_vec *bv;
+	struct bvec_iter_all iter_all;
+
+	bio_for_each_segment_all(bv, clone, iter_all) {
+		BUG_ON(!bv->bv_page);
+		mempool_free(bv->bv_page, &cc->page_pool);
+	}
+}
 
 /*
  * Generate a new unfragmented bio with the given size
@@ -1707,17 +1717,6 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 	return clone;
 }
 
-static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
-{
-	struct bio_vec *bv;
-	struct bvec_iter_all iter_all;
-
-	bio_for_each_segment_all(bv, clone, iter_all) {
-		BUG_ON(!bv->bv_page);
-		mempool_free(bv->bv_page, &cc->page_pool);
-	}
-}
-
 static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
 			  struct bio *bio, sector_t sector)
 {
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


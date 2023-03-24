Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E149AC6FD20
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 17:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679680657;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DAJc3fmLFwDnes03C0cyYHHJ/I7nqeLJsE61lIKEm4c=;
	b=Bi3Uo4uz9LEUtmy1MqTZMMrj07REFS3viqCJWMPGxBprLYV6eaGxpHCrRiSOe0vXcCLWsI
	MuE4AWls2derXxi1VN4tWDqsoCtXYm8k4htMJyzdcnSae+mR0S4h1JzonQVXshJ4D9yG6r
	i/qIMpJY6cWB+7b/sVxH2+3VBs3X0aM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-c1QUokCcP9-qCZ_xEZ_rjA-1; Fri, 24 Mar 2023 13:57:36 -0400
X-MC-Unique: c1QUokCcP9-qCZ_xEZ_rjA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AA98185A78F;
	Fri, 24 Mar 2023 17:57:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 282EE40C6E68;
	Fri, 24 Mar 2023 17:57:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DA0B11946A79;
	Fri, 24 Mar 2023 17:57:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D38AA1946A78
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 17:57:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BACF1492B01; Fri, 24 Mar 2023 17:57:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B3B5F492C3E
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97953185A78F
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:11 +0000 (UTC)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com
 [209.85.160.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-mfW23TkeO0isrVOxogQxzg-2; Fri, 24 Mar 2023 13:57:10 -0400
X-MC-Unique: mfW23TkeO0isrVOxogQxzg-2
Received: by mail-qt1-f177.google.com with SMTP id ga7so2219394qtb.2
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 10:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679680629;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Uz4MQKqyyyXmrhMudVOv+R32y8m1MjTz5D9yPmV0boc=;
 b=bNZxFiVzgFMtXziBIGqozhP9CkmwIJyg/1xK+XyDGuidhZwvK9Tb1lhBjf6IMriDh6
 7SaSgsW97i9rPvBnHHRaSj6dcUDQMdL/uh9+ExYnWuNMT1GUHcDEqyLIO3MDeOBryBlH
 1GVQJqvPxerLry5+wDC3NuKwA/xBi0ww4C+0bBw/GthxFz58eoKrffVXkwKw/yVnLi+t
 YnptHMKKXQVP0d3vkrs1Gp1enSkIoc2U4CIiOcIrBGsol8nXjOQH7FKr+eWbAxRPY2NT
 KZpGXCm2JiRWH2dSDHiKBpw6sPU4aKgt1WcAUrfGEW3eClCi9jQNDqZiwEuxNR3reVz0
 GfFA==
X-Gm-Message-State: AO0yUKV9F2B1Dibu33GmfIL/BsqqYdBiFH3k63oRinhpXvgHZlmT49e5
 JRq/GsPQ+NhfOSj9w2vrkpRPxoBLFahVYl1muH2+jKGUeGpl7MmbRp23kTNCxncWOdV/HnpFrdL
 ejPGrQu7REel9wdFCc8dWYKAGYSctZRcrAM0WfHiu7Os155yld3WxwGpVzRxEgq6gyesHcvIkFZ
 0=
X-Google-Smtp-Source: AK7set9fHWCfv+WpbP227HebgcPFG2XPeSL9RTRyiG2kVwcMqW1edMInAthmNNTgnRLcW2xLweTTjA==
X-Received: by 2002:a05:622a:387:b0:3d4:17dc:3fcf with SMTP id
 j7-20020a05622a038700b003d417dc3fcfmr6176455qtx.5.1679680629263; 
 Fri, 24 Mar 2023 10:57:09 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 i22-20020ac860d6000000b003dd8ad765dcsm8040082qtm.76.2023.03.24.10.57.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 10:57:08 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 24 Mar 2023 13:56:53 -0400
Message-Id: <20230324175656.85082-7-snitzer@kernel.org>
In-Reply-To: <20230324175656.85082-1-snitzer@kernel.org>
References: <20230324175656.85082-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [dm-6.4 PATCH v2 6/9] dm bufio: use multi-page bio vector
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
Cc: ebiggers@kernel.org, keescook@chromium.org, heinzm@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Mikulas Patocka <mpatocka@redhat.com>

The kernel supports multi page bio vector entries, so we can use them
in dm-bufio as an optimization.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index b638ddd161b4..927969b31e2f 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1326,19 +1326,14 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
 {
 	struct bio *bio;
 	char *ptr;
-	unsigned int vec_size, len;
+	unsigned int len;
 
-	vec_size = b->c->block_size >> PAGE_SHIFT;
-	if (unlikely(b->c->sectors_per_block_bits < PAGE_SHIFT - SECTOR_SHIFT))
-		vec_size += 2;
-
-	bio = bio_kmalloc(vec_size, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOWARN);
+	bio = bio_kmalloc(1, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOWARN);
 	if (!bio) {
-dmio:
 		use_dmio(b, op, sector, n_sectors, offset);
 		return;
 	}
-	bio_init(bio, b->c->bdev, bio->bi_inline_vecs, vec_size, op);
+	bio_init(bio, b->c->bdev, bio->bi_inline_vecs, 1, op);
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = bio_complete;
 	bio->bi_private = b;
@@ -1346,18 +1341,7 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
 	ptr = (char *)b->data + offset;
 	len = n_sectors << SECTOR_SHIFT;
 
-	do {
-		unsigned int this_step = min((unsigned int)(PAGE_SIZE - offset_in_page(ptr)), len);
-
-		if (!bio_add_page(bio, virt_to_page(ptr), this_step,
-				  offset_in_page(ptr))) {
-			bio_put(bio);
-			goto dmio;
-		}
-
-		len -= this_step;
-		ptr += this_step;
-	} while (len > 0);
+	__bio_add_page(bio, virt_to_page(ptr), len, offset_in_page(ptr));
 
 	submit_bio(bio);
 }
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


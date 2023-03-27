Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8598EC6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948032;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wC/XujJj3ZvjqKDMeFFXKX7Qe40iLFRGtgkJQgagcdQ=;
	b=CPFEdaYb0z/O/a7ehkZvC2wGPRrV9IqoMZBMFlgq4i6ILRup8aeKWqwuAJwavUJgHh1wdP
	NZkqa3X9meBC05CQMxH6nxdg7MN7IkYhE6WjHSr7fnRQJ8J7QATzWbz8kl25npU23KJwmQ
	NycyikothpmlXIho2s3zbNkZO910/lU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-3fQ-TuFyPoqXnV6wYkJa3w-1; Mon, 27 Mar 2023 16:13:48 -0400
X-MC-Unique: 3fQ-TuFyPoqXnV6wYkJa3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A12BD811E7C;
	Mon, 27 Mar 2023 20:13:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 916012166B29;
	Mon, 27 Mar 2023 20:13:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 19D0319472DC;
	Mon, 27 Mar 2023 20:13:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F0AB19465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4FD354020C84; Mon, 27 Mar 2023 20:13:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 486204020C82
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E4C4185A791
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:27 +0000 (UTC)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com
 [209.85.160.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-v6rciKTEOZaKrufUv62xcA-2; Mon, 27 Mar 2023 16:13:25 -0400
X-MC-Unique: v6rciKTEOZaKrufUv62xcA-2
Received: by mail-qt1-f176.google.com with SMTP id bz27so9824180qtb.1
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948005;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=pVnf9GI1VNVce+UTfVz3CQAGt+fJmIpbfH8UFMjTV9Y=;
 b=WtkkegYR9ZXewfTelmSlIrv0EEx1SRgHW+L3K+00Y1zAr8bCF+kOpSkpIoZ00ZVbDz
 xjh/di4qn8/q7dQFtT5I5xOJihe1Ao+3XIc/yUrK3Xiv6xK+JDP4rrLLZSNFBZN/M21E
 obvmKmuv8fcr10ApYbz/9hA+0sAKDF0xWMnQLrcLOlwlBSiAHTzGXSw4N/5oujik3tBT
 rbUFcSGDUN2KzMDghZpbVCaojLwLqMCyXAkGsxNfp1TAcEv8q/2nkqNIMGFVBaj4H38J
 9/143grlDmKXjpZbTM4FLPjUjH2fPNN3iyHm8gThA/UPskgrQH0egLqkKBaOM7/OSml1
 u5aQ==
X-Gm-Message-State: AO0yUKWFMUQi79KS8rRb/PipXOSJT6muSnJOBLROAFvXii2CiTeF5zWO
 qNcgW99JWkB8BXG6tkxjVI/hNiJGuhToBYsr1tfe5XRKUUZ2wp1ugl6emhwsnHyYu6TPe+hnmvE
 Vhe4kJ4lkdM29UR4os0ssaloOHk3qxqPyWevxQKX3j83P8UWMHz3xwG3zYi2fBC9gIH9OY1iBo4
 c=
X-Google-Smtp-Source: AK7set/QhxRjmAYqq9vwOTVV6ZCx9K0pKe5GG2wkdvifb91iLlhC2h6StgNwdnfJ1O/ta0hPff4PHw==
X-Received: by 2002:a05:622a:1a03:b0:3e3:8427:fb56 with SMTP id
 f3-20020a05622a1a0300b003e38427fb56mr22558795qtb.63.1679948004961; 
 Mon, 27 Mar 2023 13:13:24 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 75-20020a370a4e000000b006ff8a122a1asm11508110qkk.78.2023.03.27.13.13.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:24 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:34 -0400
Message-Id: <20230327201143.51026-12-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [dm-6.4 PATCH v3 11/20] dm bufio: use multi-page bio
 vector
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, keescook@chromium.org,
 heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
index cca43ed13fd1..ae552644a0b4 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1312,19 +1312,14 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
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
@@ -1332,18 +1327,7 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
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


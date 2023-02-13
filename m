Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12788C64ED9
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319335;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vbBSYHdtpaQ6FD8PHARBiS+A41xs1ahfZhMjfgCMZlE=;
	b=M7NAQQ1USGjYUlGmoLjIZqSvXJvv5qn3iuw0rgzoxYIvb+K/PAEi8dd/oPU3Kkd94dVb1B
	SrnxPBOzpFS85JT6NQZl04RDpRlwH0wNPiMldqiz5Plqhoc3rMY9OeWiSxAnPuU9H95Ep8
	mfJ9KfZdPcUUV5n2ItiglX75qAO0P4s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-IICgz-KfOnCJH_O3x8wvLw-1; Mon, 13 Feb 2023 15:15:33 -0500
X-MC-Unique: IICgz-KfOnCJH_O3x8wvLw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C0A13C18358;
	Mon, 13 Feb 2023 20:15:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 87D54492B04;
	Mon, 13 Feb 2023 20:15:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 737AC1946588;
	Mon, 13 Feb 2023 20:15:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D6DAE1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B704F2166B29; Mon, 13 Feb 2023 20:15:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B085D2166B26
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 976A897108C
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:22 +0000 (UTC)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com
 [209.85.219.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-418-L4rVBNwJMu25POpOlLiVhw-1; Mon, 13 Feb 2023 15:15:10 -0500
X-MC-Unique: L4rVBNwJMu25POpOlLiVhw-1
Received: by mail-qv1-f50.google.com with SMTP id d13so9095571qvj.8
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=+Gxt6MpJNCl1zDM44TvZBYdDttT360AD34tvVqTglPg=;
 b=zZKIiLAo2p2t12YVdqtjVDSLRAkb60A7GlwKFqh1D76rzXD5XgV2aIwyY1I98VxhI5
 SfTgYwEB8SJcKHnWwCNVuxO5eI5ZecNXqMvpWKSto/IYp80jan6uvCyBog0HzswKsTCl
 uLeSgg9xWm8KUdrx/aKc7OJeVv1oWELjO/+J6AdJsG3RvU13TZfOuZnwL7tFIWcMuX7A
 6VL4KUSJj1XpmYtHqTJNtVB3KnCDv+s1Z3mpvhIY946EA7604+F+rE18tYtnI8FgQAVZ
 xaq+NU444y5177OUmOTk/CHkAfSOVJpuVhqP16fcpARvAsY3NRjpJK3X89ukMzDUIvaO
 7RUA==
X-Gm-Message-State: AO0yUKX3FEKDZctZ9FwBxnn957Z2dEkNVdYwNvAytCX8ksJLcZXoU4T+
 BFVpoKvN+icKCNUlvc4rIOIZfjK040DKSJJyC5B3s96j+q6chJyK8f6NeM7i8FmEYDP/QtGA+BF
 0Yin+OCjp8wEzKZJJ0n3s7Wt18FNWVcuZdC6zT7s5ZEK2XEMjR6DDg71RAmqVQM3fySTkdw==
X-Google-Smtp-Source: AK7set/SgsG4UGTv5Z8r6ShypY86AimKozFpjRcKAhjy8IJ/F86hv0bF9ssk5q7I+LO8yyQPiN5/cw==
X-Received: by 2002:a05:6214:2b06:b0:53a:7253:4093 with SMTP id
 jx6-20020a0562142b0600b0053a72534093mr393618qvb.14.1676319309346; 
 Mon, 13 Feb 2023 12:15:09 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 c131-20020a379a89000000b0073a7b317834sm6065120qke.83.2023.02.13.12.15.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:08 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:47 -0500
Message-Id: <20230213201401.45973-26-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 25/39] dm: avoid useless 'else' after 'break' or
 return'
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-stripe.c                        |  8 ++---
 drivers/md/dm-thin-metadata.c                 |  4 +--
 drivers/md/dm-verity-target.c                 | 33 ++++++++++---------
 drivers/md/dm-writecache.c                    | 16 ++++-----
 drivers/md/persistent-data/dm-btree.c         |  4 +--
 .../md/persistent-data/dm-space-map-common.c  | 11 +++----
 6 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 9f203a1790d5..9a2906dd9317 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -259,11 +259,11 @@ static int stripe_map_range(struct stripe_c *sc, struct bio *bio,
 			sc->stripe[target_stripe].physical_start;
 		bio->bi_iter.bi_size = to_bytes(end - begin);
 		return DM_MAPIO_REMAPPED;
-	} else {
-		/* The range doesn't map to the target stripe */
-		bio_endio(bio);
-		return DM_MAPIO_SUBMITTED;
 	}
+
+	/* The range doesn't map to the target stripe */
+	bio_endio(bio);
+	return DM_MAPIO_SUBMITTED;
 }
 
 static int stripe_map(struct dm_target *ti, struct bio *bio)
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index ddd0718fcf81..54bd32351d93 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1612,8 +1612,8 @@ static int __find_mapped_range(struct dm_thin_device *td,
 		if (r) {
 			if (r == -ENODATA)
 				break;
-			else
-				return r;
+
+			return r;
 		}
 
 		if ((lookup.block != pool_end) ||
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 0f9814099d1b..ade83ef3b439 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -110,23 +110,24 @@ static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
 		sg_init_one(&sg, data, len);
 		ahash_request_set_crypt(req, &sg, NULL, len);
 		return crypto_wait_req(crypto_ahash_update(req), wait);
-	} else {
-		do {
-			int r;
-			size_t this_step = min_t(size_t, len, PAGE_SIZE - offset_in_page(data));
-
-			flush_kernel_vmap_range((void *)data, this_step);
-			sg_init_table(&sg, 1);
-			sg_set_page(&sg, vmalloc_to_page(data), this_step, offset_in_page(data));
-			ahash_request_set_crypt(req, &sg, NULL, this_step);
-			r = crypto_wait_req(crypto_ahash_update(req), wait);
-			if (unlikely(r))
-				return r;
-			data += this_step;
-			len -= this_step;
-		} while (len);
-		return 0;
 	}
+
+	do {
+		int r;
+		size_t this_step = min_t(size_t, len, PAGE_SIZE - offset_in_page(data));
+
+		flush_kernel_vmap_range((void *)data, this_step);
+		sg_init_table(&sg, 1);
+		sg_set_page(&sg, vmalloc_to_page(data), this_step, offset_in_page(data));
+		ahash_request_set_crypt(req, &sg, NULL, this_step);
+		r = crypto_wait_req(crypto_ahash_update(req), wait);
+		if (unlikely(r))
+			return r;
+		data += this_step;
+		len -= this_step;
+	} while (len);
+
+	return 0;
 }
 
 /*
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 0c89b884fe54..99bcfbb6e646 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -623,15 +623,15 @@ static struct wc_entry *writecache_find_entry(struct dm_writecache *wc,
 		if (unlikely(!node)) {
 			if (!(flags & WFE_RETURN_FOLLOWING))
 				return NULL;
-			if (read_original_sector(wc, e) >= block) {
+			if (read_original_sector(wc, e) >= block)
 				return e;
-			} else {
-				node = rb_next(&e->rb_node);
-				if (unlikely(!node))
-					return NULL;
-				e = container_of(node, struct wc_entry, rb_node);
-				return e;
-			}
+
+			node = rb_next(&e->rb_node);
+			if (unlikely(!node))
+				return NULL;
+
+			e = container_of(node, struct wc_entry, rb_node);
+			return e;
 		}
 	}
 
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index d646d792ce51..67b868ac2128 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -1352,8 +1352,8 @@ static int find_key(struct ro_spine *s, dm_block_t block, bool find_highest,
 		i = le32_to_cpu(ro_node(s)->header.nr_entries);
 		if (!i)
 			return -ENODATA;
-		else
-			i--;
+
+		i--;
 
 		if (find_highest)
 			*result_key = le64_to_cpu(ro_node(s)->keys[i]);
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index cc7e06a026ae..f0643af04060 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -793,13 +793,12 @@ static int __sm_ll_dec_overflow(struct ll_disk *ll, dm_block_t b,
 	rc = le32_to_cpu(*v_ptr);
 	*old_rc = rc;
 
-	if (rc == 3) {
+	if (rc == 3)
 		return __sm_ll_del_overflow(ll, b, ic);
-	} else {
-		rc--;
-		*v_ptr = cpu_to_le32(rc);
-		return 0;
-	}
+
+	rc--;
+	*v_ptr = cpu_to_le32(rc);
+	return 0;
 }
 
 static int sm_ll_dec_overflow(struct ll_disk *ll, dm_block_t b,
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B707EC636D4
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319279;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PzRT+F88VKO07vQLD04Sao321wRRid/iTh2Gu7L9en4=;
	b=efKkCOP/rReAkBtWAEkFFvNWIhG7kzzzDO/46v67lA/8KRaFVHcgpU1JFG11BDy8hihHcc
	VDSe7Gat8zHt3PZ4lzTXg39S5k5urpafbXRmE4E+Y9QkBK1/5R8q1qpYcdF+HAciq1kWg7
	9RYwwWpJnlUDQkgbjGNz99sRBZ/A+lQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-DDwYt7pYN9CrgMg726auuA-1; Mon, 13 Feb 2023 15:14:36 -0500
X-MC-Unique: DDwYt7pYN9CrgMg726auuA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 690291C05EA7;
	Mon, 13 Feb 2023 20:14:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56B1340C83B6;
	Mon, 13 Feb 2023 20:14:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 160681946588;
	Mon, 13 Feb 2023 20:14:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 70B7B19465A3
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 63E6D2026D68; Mon, 13 Feb 2023 20:14:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BE912026D4B
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40A461869B6C
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:32 +0000 (UTC)
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com
 [209.85.219.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-1-MQsCLmchOH-kML97zLnkwQ-1; Mon, 13 Feb 2023 15:14:30 -0500
X-MC-Unique: MQsCLmchOH-kML97zLnkwQ-1
Received: by mail-qv1-f45.google.com with SMTP id j9so9139710qvt.0
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=oacbZu9fK/2sjv3poCIljoUVmnDD0D+Qw/Mf6QP3CKs=;
 b=eG9eixcLvrB7h+AgPuFVCoJ5yoke1OClaow6OHXLpyR/7J8D1Z0sWJCFswdEQAJVzU
 xX7C5mkgWekXKAb9xoMxqScZslUX/DKOi4mk507hkKFFRnnOKElk302o5EaVeJTXnDLM
 O/KtrISe05AE/6OQF9bTa0NbbLBNpwEakinO6/AoVqm9C7isNYFOs6/rAyOkBnK1WqLJ
 RBrOMJjGI+nX3mH0YIFNDoamwvg7I1hruGeLiyc+OA0A4oaWKvpQtnD+cQW8O2c39pEj
 TmJhscvdkOHayJghtvJgImEDe0H+lKb2jFvJ1/wFVyzMeUS9wph4C8xfR4xR4XneMhiy
 6Klg==
X-Gm-Message-State: AO0yUKUfmR/qOi+2iu9QUZqOJAvAH6nrhpM3l985StX9edKpRuOBGONe
 3x64yk734VKnfNsVbyb5TfyBe+NnQ3gogbYS57jgH+FQpDbetayOSRZR/FSl9w/FLPSqyW52ce3
 104r21Bt7MkqaePxXwPDe3RGFHBlpG2Mj0Zujl+wTixBuSyt9TVWAgiS83C+jAkLRoC1bVg==
X-Google-Smtp-Source: AK7set84oDnJzJR0KumGEk5f7tXfKRce/0562Lrh/kqIZWNiUsl26dUXSM7Gy5wAdLSnR5M/ffDeyQ==
X-Received: by 2002:a05:6214:f0d:b0:56e:b395:20d with SMTP id
 gw13-20020a0562140f0d00b0056eb395020dmr302619qvb.26.1676319269549; 
 Mon, 13 Feb 2023 12:14:29 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 t73-20020a37464c000000b007186c9e167esm10351445qka.52.2023.02.13.12.14.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:29 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:24 -0500
Message-Id: <20230213201401.45973-3-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 02/39] dm: prefer kmap_local_page() instead of
 deprecated kmap_atomic()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-crypt.c      | 24 ++++++++++++------------
 drivers/md/dm-log-writes.c | 12 ++++++------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b8333b966a4d..e7fd9e770bc0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -532,9 +532,9 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
 		sg = crypt_get_sg_data(cc, dmreq->sg_in);
-		src = kmap_atomic(sg_page(sg));
+		src = kmap_local_page(sg_page(sg));
 		r = crypt_iv_lmk_one(cc, iv, dmreq, src + sg->offset);
-		kunmap_atomic(src);
+		kunmap_local(src);
 	} else
 		memset(iv, 0, cc->iv_size);
 
@@ -552,14 +552,14 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 		return 0;
 
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	dst = kmap_atomic(sg_page(sg));
+	dst = kmap_local_page(sg_page(sg));
 	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + sg->offset);
 
 	/* Tweak the first block of plaintext sector */
 	if (!r)
 		crypto_xor(dst + sg->offset, iv, cc->iv_size);
 
-	kunmap_atomic(dst);
+	kunmap_local(dst);
 	return r;
 }
 
@@ -682,9 +682,9 @@ static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 	/* Remove whitening from ciphertext */
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
 		sg = crypt_get_sg_data(cc, dmreq->sg_in);
-		src = kmap_atomic(sg_page(sg));
+		src = kmap_local_page(sg_page(sg));
 		r = crypt_iv_tcw_whitening(cc, dmreq, src + sg->offset);
-		kunmap_atomic(src);
+		kunmap_local(src);
 	}
 
 	/* Calculate IV */
@@ -708,9 +708,9 @@ static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
 
 	/* Apply whitening on ciphertext */
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	dst = kmap_atomic(sg_page(sg));
+	dst = kmap_local_page(sg_page(sg));
 	r = crypt_iv_tcw_whitening(cc, dmreq, dst + sg->offset);
-	kunmap_atomic(dst);
+	kunmap_local(dst);
 
 	return r;
 }
@@ -975,15 +975,15 @@ static int crypt_iv_elephant(struct crypt_config *cc, struct dm_crypt_request *d
 		goto out;
 
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	data = kmap_atomic(sg_page(sg));
+	data = kmap_local_page(sg_page(sg));
 	data_offset = data + sg->offset;
 
 	/* Cannot modify original bio, copy to sg_out and apply Elephant to it */
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
 		sg2 = crypt_get_sg_data(cc, dmreq->sg_in);
-		data2 = kmap_atomic(sg_page(sg2));
+		data2 = kmap_local_page(sg_page(sg2));
 		memcpy(data_offset, data2 + sg2->offset, cc->sector_size);
-		kunmap_atomic(data2);
+		kunmap_local(data2);
 	}
 
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
@@ -1003,7 +1003,7 @@ static int crypt_iv_elephant(struct crypt_config *cc, struct dm_crypt_request *d
 		diffuser_cpu_to_disk((__le32*)data_offset, cc->sector_size / sizeof(u32));
 	}
 
-	kunmap_atomic(data);
+	kunmap_local(data);
 out:
 	kfree_sensitive(ks);
 	kfree_sensitive(es);
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index ea8a17dfa893..aed3a2cd1abd 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -232,13 +232,13 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
 		goto error;
 	}
 
-	ptr = kmap_atomic(page);
+	ptr = kmap_local_page(page);
 	memcpy(ptr, entry, entrylen);
 	if (datalen)
 		memcpy(ptr + entrylen, data, datalen);
 	memset(ptr + entrylen + datalen, 0,
 	       lc->sectorsize - entrylen - datalen);
-	kunmap_atomic(ptr);
+	kunmap_local(ptr);
 
 	ret = bio_add_page(bio, page, lc->sectorsize, 0);
 	if (ret != lc->sectorsize) {
@@ -287,11 +287,11 @@ static int write_inline_data(struct log_writes_c *lc, void *entry,
 				goto error_bio;
 			}
 
-			ptr = kmap_atomic(page);
+			ptr = kmap_local_page(page);
 			memcpy(ptr, data, pg_datalen);
 			if (pg_sectorlen > pg_datalen)
 				memset(ptr + pg_datalen, 0, pg_sectorlen - pg_datalen);
-			kunmap_atomic(ptr);
+			kunmap_local(ptr);
 
 			ret = bio_add_page(bio, page, pg_sectorlen, 0);
 			if (ret != pg_sectorlen) {
@@ -743,9 +743,9 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 			return DM_MAPIO_KILL;
 		}
 
-		dst = kmap_atomic(page);
+		dst = kmap_local_page(page);
 		memcpy_from_bvec(dst, &bv);
-		kunmap_atomic(dst);
+		kunmap_local(dst);
 		block->vecs[i].bv_page = page;
 		block->vecs[i].bv_len = bv.bv_len;
 		block->vec_cnt++;
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


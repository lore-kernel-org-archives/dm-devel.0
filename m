Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69BD4C64ED6
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319343;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fvwVxQYd6vUql0cO8obqHl/Xz/yClVMD0Y5luOm2SnU=;
	b=J0FDNxDzrXEgsprPv3SeYxhcfT7u4N01Ay3JkJVgH2ldpqjVBzVCLnF3+EZcEqJY8dxFMs
	P1gtnJww9ZJARoIOX/2R/X09ZxJzeqMZu3sk97SD3REUm99D9P2AyEHqkTBIa2qi55+Zqm
	Q1jusS483mK8nntitklBjd5izHWFaM8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-s2i9YE4oO5yOQtlS4imUxA-1; Mon, 13 Feb 2023 15:15:39 -0500
X-MC-Unique: s2i9YE4oO5yOQtlS4imUxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA71C2823816;
	Mon, 13 Feb 2023 20:15:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B914D2026D4B;
	Mon, 13 Feb 2023 20:15:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AAC8A194658C;
	Mon, 13 Feb 2023 20:15:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3254B1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18972492B05; Mon, 13 Feb 2023 20:15:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1114A492B04
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3EA7100F906
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:25 +0000 (UTC)
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com
 [209.85.219.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-408-sdXJDCh-MHy_5Vrb3J-pcg-3; Mon, 13 Feb 2023 15:15:23 -0500
X-MC-Unique: sdXJDCh-MHy_5Vrb3J-pcg-3
Received: by mail-qv1-f52.google.com with SMTP id l7so4177305qvw.7
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=KFuJKZ54VPA7PQmTRS/XXnoWjpeemT6pbShD9rwJ1/0=;
 b=gg+Gp35lCqKKpi+WGfnDlOcMabtW04Z3pZR0oIGzNthUHKsc7LsIFONDrAXkrtBPhr
 agjHx22E4dbm6czJgAhQF3dcN6+SoLvzI6IIPh1tRt2KP0+zT0legOp2N9m67RHLQ/Ry
 FtRouba2oBIixKtf9G9RdpUxUeqa7mFaywu19PBhFT6eg2nKLy3sGyPEhUvkEh2P962m
 A5VbW5N8EUu4vugndy2dnne4lS0JrK1374w/ogwWq/J9XB8jIi6hhcAl0VzB22UVXoZO
 ok2WaRWChxjq+TgEzzPxBu9p6AoNHeq5bK+Nscai0wzypy5pF/SkJFGO67iVaUfYt23g
 lmZg==
X-Gm-Message-State: AO0yUKW0/byDF3qq4gndhdC4NSEVkHHuj/LhtGeLaEfaHQUAiwbM2Daj
 hknFd0fhHCNPiLGOJxkYtGIS9vqgBQ8yS3wFofcTlrh0yvX5HfpsSbFefoClndBMUoFIa2nh22N
 ELZv4f5t1FrPILx9fXvIbAZB3koJ/YF79XqI5BhP5Mu3fMWUoJmStGb6/7rX81D0yx8xd1A==
X-Google-Smtp-Source: AK7set9t6SODI0DUOIoM/1yoaVJ0tDZSQqGMmtf3yV6cMzg3ixwVsVAgZLf2hYk8lFyCT/vROENyNw==
X-Received: by 2002:ad4:4ee9:0:b0:56e:b4e0:1bf3 with SMTP id
 dv9-20020ad44ee9000000b0056eb4e01bf3mr379526qvb.18.1676319321751; 
 Mon, 13 Feb 2023 12:15:21 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 p6-20020ac84086000000b003b9a573aec6sm9881330qtl.70.2023.02.13.12.15.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:21 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:55 -0500
Message-Id: <20230213201401.45973-34-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 33/39] dm: fix use of sizeof() macro
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c      |  6 +++---
 drivers/md/dm-integrity.c  | 16 ++++++++--------
 drivers/md/dm-kcopyd.c     |  2 +-
 drivers/md/dm-writecache.c |  6 +++---
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index a5d7f8555aa0..859d85a31637 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1815,7 +1815,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	    (block_size < PAGE_SIZE || !is_power_of_2(block_size))) {
 		unsigned int align = min(1U << __ffs(block_size), (unsigned int)PAGE_SIZE);
 
-		snprintf(slab_name, sizeof slab_name, "dm_bufio_cache-%u", block_size);
+		snprintf(slab_name, sizeof(slab_name), "dm_bufio_cache-%u", block_size);
 		c->slab_cache = kmem_cache_create(slab_name, block_size, align,
 						  SLAB_RECLAIM_ACCOUNT, NULL);
 		if (!c->slab_cache) {
@@ -1824,9 +1824,9 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 		}
 	}
 	if (aux_size)
-		snprintf(slab_name, sizeof slab_name, "dm_bufio_buffer-%u", aux_size);
+		snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer-%u", aux_size);
 	else
-		snprintf(slab_name, sizeof slab_name, "dm_bufio_buffer");
+		snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer");
 	c->slab_buffer = kmem_cache_create(slab_name, sizeof(struct dm_buffer) + aux_size,
 					   0, SLAB_RECLAIM_ACCOUNT, NULL);
 	if (!c->slab_buffer) {
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 63cf42ee6017..b70defcdd982 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -826,7 +826,7 @@ static void section_mac(struct dm_integrity_c *ic, unsigned int section, __u8 re
 		}
 
 		section_le = cpu_to_le64(section);
-		r = crypto_shash_update(desc, (__u8 *)&section_le, sizeof section_le);
+		r = crypto_shash_update(desc, (__u8 *)&section_le, sizeof(section_le));
 		if (unlikely(r < 0)) {
 			dm_integrity_io_error(ic, "crypto_shash_update", r);
 			goto err;
@@ -836,7 +836,7 @@ static void section_mac(struct dm_integrity_c *ic, unsigned int section, __u8 re
 	for (j = 0; j < ic->journal_section_entries; j++) {
 		struct journal_entry *je = access_journal_entry(ic, section, j);
 
-		r = crypto_shash_update(desc, (__u8 *)&je->u.sector, sizeof je->u.sector);
+		r = crypto_shash_update(desc, (__u8 *)&je->u.sector, sizeof(je->u.sector));
 		if (unlikely(r < 0)) {
 			dm_integrity_io_error(ic, "crypto_shash_update", r);
 			goto err;
@@ -1687,7 +1687,7 @@ static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector
 		}
 	}
 
-	r = crypto_shash_update(req, (const __u8 *)&sector_le, sizeof sector_le);
+	r = crypto_shash_update(req, (const __u8 *)&sector_le, sizeof(sector_le));
 	if (unlikely(r < 0)) {
 		dm_integrity_io_error(ic, "crypto_shash_update", r);
 		goto failed;
@@ -2967,8 +2967,8 @@ static void replay_journal(struct dm_integrity_c *ic)
 		goto clear_journal;
 
 	journal_empty = true;
-	memset(used_commit_ids, 0, sizeof used_commit_ids);
-	memset(max_commit_id_sections, 0, sizeof max_commit_id_sections);
+	memset(used_commit_ids, 0, sizeof(used_commit_ids));
+	memset(max_commit_id_sections, 0, sizeof(max_commit_id_sections));
 	for (i = 0; i < ic->journal_sections; i++) {
 		for (j = 0; j < ic->journal_section_sectors; j++) {
 			int k;
@@ -3685,7 +3685,7 @@ static void free_alg(struct alg_spec *a)
 {
 	kfree_sensitive(a->alg_string);
 	kfree_sensitive(a->key);
-	memset(a, 0, sizeof *a);
+	memset(a, 0, sizeof(*a));
 }
 
 static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, char *error_inval)
@@ -3852,10 +3852,10 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 				clear_page(va);
 				sg_set_buf(&sg[i], va, PAGE_SIZE);
 			}
-			sg_set_buf(&sg[i], &ic->commit_ids, sizeof ic->commit_ids);
+			sg_set_buf(&sg[i], &ic->commit_ids, sizeof(ic->commit_ids));
 
 			skcipher_request_set_crypt(req, sg, sg,
-						   PAGE_SIZE * ic->journal_pages + sizeof ic->commit_ids, crypt_iv);
+						   PAGE_SIZE * ic->journal_pages + sizeof(ic->commit_ids), crypt_iv);
 			init_completion(&comp.comp);
 			comp.in_flight = (atomic_t)ATOMIC_INIT(1);
 			if (do_crypt(true, req, &comp))
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 81bc33a3581d..e11de9218ced 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -826,7 +826,7 @@ void dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 		job->pages = NULL;
 		job->op = REQ_OP_READ;
 	} else {
-		memset(&job->source, 0, sizeof job->source);
+		memset(&job->source, 0, sizeof(job->source));
 		job->source.count = job->dests[0].count;
 		job->pages = &zero_page_list;
 
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 99bcfbb6e646..230d8864f8c9 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -772,7 +772,7 @@ static void writecache_poison_lists(struct dm_writecache *wc)
 	/*
 	 * Catch incorrect access to these values while the device is suspended.
 	 */
-	memset(&wc->tree, -1, sizeof wc->tree);
+	memset(&wc->tree, -1, sizeof(wc->tree));
 	wc->lru.next = LIST_POISON1;
 	wc->lru.prev = LIST_POISON2;
 	wc->freelist.next = LIST_POISON1;
@@ -1182,7 +1182,7 @@ static int process_clear_stats_mesg(unsigned int argc, char **argv, struct dm_wr
 		return -EINVAL;
 
 	wc_lock(wc);
-	memset(&wc->stats, 0, sizeof wc->stats);
+	memset(&wc->stats, 0, sizeof(wc->stats));
 	wc_unlock(wc);
 
 	return 0;
@@ -2174,7 +2174,7 @@ static int init_memory(struct dm_writecache *wc)
 	writecache_flush_all_metadata(wc);
 	writecache_commit_flushed(wc, false);
 	pmem_assign(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
-	writecache_flush_region(wc, &sb(wc)->magic, sizeof sb(wc)->magic);
+	writecache_flush_region(wc, &sb(wc)->magic, sizeof(sb(wc)->magic));
 	writecache_commit_flushed(wc, false);
 
 	return 0;
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


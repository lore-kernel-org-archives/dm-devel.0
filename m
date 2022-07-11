Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7715C43334
	for <dm-devel@archiver.kernel.org>; Mon, 11 Jul 2022 20:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657571431;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TNWpxwEL3zuo5qoy7SbK8oqQr3LZHro7a/0HU06B4gw=;
	b=M1Rgg/QzSj/sjMASELh7CdHXwRKW1an1Af4496y1YCrq8CtyNAGyoXMKmxLKIDkBRJVQSP
	3hya8PWjqE8Qnye8C0a9TUG3cdJa/hZcnfWeG0Te39jMootVzB3tG9CeRZk0yagBEd/nt3
	AXpTSQrcGpmUz+GCLLAx9QwuglQJqlA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-EZgbuD-NNRK5T4XQVvrWsg-1; Mon, 11 Jul 2022 16:30:30 -0400
X-MC-Unique: EZgbuD-NNRK5T4XQVvrWsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F76D85A581;
	Mon, 11 Jul 2022 20:30:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8949D1121314;
	Mon, 11 Jul 2022 20:30:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4EDF21947060;
	Mon, 11 Jul 2022 20:30:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7F8B8194704A
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Jul 2022 20:30:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 602F42166B2B; Mon, 11 Jul 2022 20:30:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 556152166B26;
 Mon, 11 Jul 2022 20:30:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 26BKURIU005597; Mon, 11 Jul 2022 16:30:27 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 26BKURTq005594; Mon, 11 Jul 2022 16:30:27 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 11 Jul 2022 16:30:27 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Yu Kuai <yukuai1@huaweicloud.com>, Mike Snitzer <msnitzer@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2207111627260.5249@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2207111629560.5249@file01.intranet.prod.int.rdu2.redhat.com>
References: <20220706093146.1961598-1-yukuai1@huaweicloud.com>
 <alpine.LRH.2.02.2207111627260.5249@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH 1/4] dm-writecache: make
 writecache_map_remap_origin return void
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
Cc: yukuai3@huawei.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 agk@redhat.com, yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The functions writecache_map_remap_origin and writecache_bio_copy_ssd
return only a single value, thus we can make them return void.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -1329,8 +1329,8 @@ enum wc_map_op {
 	WC_MAP_ERROR,
 };
 
-static enum wc_map_op writecache_map_remap_origin(struct dm_writecache *wc, struct bio *bio,
-						  struct wc_entry *e)
+static void writecache_map_remap_origin(struct dm_writecache *wc, struct bio *bio,
+					struct wc_entry *e)
 {
 	if (e) {
 		sector_t next_boundary =
@@ -1338,8 +1338,6 @@ static enum wc_map_op writecache_map_rem
 		if (next_boundary < bio->bi_iter.bi_size >> SECTOR_SHIFT)
 			dm_accept_partial_bio(bio, next_boundary);
 	}
-
-	return WC_MAP_REMAP_ORIGIN;
 }
 
 static enum wc_map_op writecache_map_read(struct dm_writecache *wc, struct bio *bio)
@@ -1366,14 +1364,15 @@ read_next_block:
 			map_op = WC_MAP_REMAP;
 		}
 	} else {
-		map_op = writecache_map_remap_origin(wc, bio, e);
+		writecache_map_remap_origin(wc, bio, e);
+		map_op = WC_MAP_REMAP_ORIGIN;
 	}
 
 	return map_op;
 }
 
-static enum wc_map_op writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
-					      struct wc_entry *e, bool search_used)
+static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
+				    struct wc_entry *e, bool search_used)
 {
 	unsigned bio_size = wc->block_size;
 	sector_t start_cache_sec = cache_sector(wc, e);
@@ -1419,8 +1418,6 @@ static enum wc_map_op writecache_bio_cop
 	} else {
 		writecache_schedule_autocommit(wc);
 	}
-
-	return WC_MAP_REMAP;
 }
 
 static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio *bio)
@@ -1458,7 +1455,8 @@ static enum wc_map_op writecache_map_wri
 direct_write:
 				wc->stats.writes_around++;
 				e = writecache_find_entry(wc, bio->bi_iter.bi_sector, WFE_RETURN_FOLLOWING);
-				return writecache_map_remap_origin(wc, bio, e);
+				writecache_map_remap_origin(wc, bio, e);
+				return WC_MAP_REMAP_ORIGIN;
 			}
 			wc->stats.writes_blocked_on_freelist++;
 			writecache_wait_on_freelist(wc);
@@ -1469,10 +1467,12 @@ direct_write:
 		wc->uncommitted_blocks++;
 		wc->stats.writes_allocate++;
 bio_copy:
-		if (WC_MODE_PMEM(wc))
+		if (WC_MODE_PMEM(wc)) {
 			bio_copy_block(wc, bio, memory_data(wc, e));
-		else
-			return writecache_bio_copy_ssd(wc, bio, e, search_used);
+		} else {
+			writecache_bio_copy_ssd(wc, bio, e, search_used);
+			return WC_MAP_REMAP;
+		}
 	} while (bio->bi_iter.bi_size);
 
 	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks))

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


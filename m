Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1EF6C43334
	for <dm-devel@archiver.kernel.org>; Mon, 11 Jul 2022 20:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657571493;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QvOi4hzGv2RApGhsbAIo3u+WtXU1C8LEqpK8kYpd6YU=;
	b=C+kj+I3J3hSMlrFoNC4dpFtvD5Dh13kbYUswZJXhfL5/7XFtV30r/g/ZZNJwe1e20fO31Z
	40fFaVju6375VngBNI4eQULw3CQLh99ufQuTbW2wZDUt65Bn/TU/7bzEx3ZOhgb0jbJWRI
	daBaHucnWviGj2Xs82kk/F5Z2qlfZLU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-kGF0yL1SNOCAWRgk7ZDKtg-1; Mon, 11 Jul 2022 16:31:32 -0400
X-MC-Unique: kGF0yL1SNOCAWRgk7ZDKtg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65C40801590;
	Mon, 11 Jul 2022 20:31:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5500F492C3B;
	Mon, 11 Jul 2022 20:31:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2761F194705C;
	Mon, 11 Jul 2022 20:31:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CB842194704A
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Jul 2022 20:31:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4C832EF9E; Mon, 11 Jul 2022 20:31:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A962218EB7;
 Mon, 11 Jul 2022 20:31:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 26BKVQ4q005686; Mon, 11 Jul 2022 16:31:26 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 26BKVQ3K005682; Mon, 11 Jul 2022 16:31:26 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 11 Jul 2022 16:31:26 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Yu Kuai <yukuai1@huaweicloud.com>, Mike Snitzer <msnitzer@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2207111627260.5249@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2207111631000.5249@file01.intranet.prod.int.rdu2.redhat.com>
References: <20220706093146.1961598-1-yukuai1@huaweicloud.com>
 <alpine.LRH.2.02.2207111627260.5249@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 3/4] dm-writecache: count the number of blocks
 written, not the number of write bios
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Change dm-writecache, so that it counts the number of blocks written
instead of the number of write bios. Bios can be split and requeued using
the dm_accept_partial_bio function, so counting of bios provided
inaccurate results.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Yu Kuai <yukuai1@huaweicloud.com>

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -1413,6 +1413,9 @@ static void writecache_bio_copy_ssd(stru
 	bio->bi_iter.bi_sector = start_cache_sec;
 	dm_accept_partial_bio(bio, bio_size >> SECTOR_SHIFT);
 
+	wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
+	wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
+
 	if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		wc->uncommitted_blocks = 0;
 		queue_work(wc->writeback_wq, &wc->flush_work);
@@ -1428,9 +1431,10 @@ static enum wc_map_op writecache_map_wri
 	do {
 		bool found_entry = false;
 		bool search_used = false;
-		wc->stats.writes++;
-		if (writecache_has_error(wc))
+		if (writecache_has_error(wc)) {
+			wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
 			return WC_MAP_ERROR;
+		}
 		e = writecache_find_entry(wc, bio->bi_iter.bi_sector, 0);
 		if (e) {
 			if (!writecache_entry_is_committed(wc, e)) {
@@ -1454,9 +1458,10 @@ static enum wc_map_op writecache_map_wri
 		if (unlikely(!e)) {
 			if (!WC_MODE_PMEM(wc) && !found_entry) {
 direct_write:
-				wc->stats.writes_around++;
 				e = writecache_find_entry(wc, bio->bi_iter.bi_sector, WFE_RETURN_FOLLOWING);
 				writecache_map_remap_origin(wc, bio, e);
+				wc->stats.writes_around += bio->bi_iter.bi_size >> wc->block_size_bits;
+				wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
 				return WC_MAP_REMAP_ORIGIN;
 			}
 			wc->stats.writes_blocked_on_freelist++;
@@ -1470,6 +1475,7 @@ direct_write:
 bio_copy:
 		if (WC_MODE_PMEM(wc)) {
 			bio_copy_block(wc, bio, memory_data(wc, e));
+			wc->stats.writes++;
 		} else {
 			writecache_bio_copy_ssd(wc, bio, e, search_used);
 			return WC_MAP_REMAP;
Index: linux-2.6/Documentation/admin-guide/device-mapper/writecache.rst
===================================================================
--- linux-2.6.orig/Documentation/admin-guide/device-mapper/writecache.rst
+++ linux-2.6/Documentation/admin-guide/device-mapper/writecache.rst
@@ -80,11 +80,11 @@ Status:
 4. the number of blocks under writeback
 5. the number of read blocks
 6. the number of read blocks that hit the cache
-7. the number of write requests
-8. the number of write requests that hit uncommitted block
-9. the number of write requests that hit committed block
-10. the number of write requests that bypass the cache
-11. the number of write requests that are allocated in the cache
+7. the number of write blocks
+8. the number of write blocks that hit uncommitted block
+9. the number of write blocks that hit committed block
+10. the number of write blocks that bypass the cache
+11. the number of write blocks that are allocated in the cache
 12. the number of write requests that are blocked on the freelist
 13. the number of flush requests
 14. the number of discard requests

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


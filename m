Return-Path: <SRS0=K1eQ=L6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE71C11F6F
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jul 2021 11:24:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8E74461E32
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jul 2021 11:24:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E74461E32
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-740yXJ3yOQObRB9xCr1PRA-1; Tue, 06 Jul 2021 07:23:59 -0400
X-MC-Unique: 740yXJ3yOQObRB9xCr1PRA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7C9F804170;
	Tue,  6 Jul 2021 11:23:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E5732EB22;
	Tue,  6 Jul 2021 11:23:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 630191809CB2;
	Tue,  6 Jul 2021 11:23:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 166BNMnK026357 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 6 Jul 2021 07:23:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C4C23119D35D; Tue,  6 Jul 2021 11:23:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0D231134CC7
	for <dm-devel@redhat.com>; Tue,  6 Jul 2021 11:23:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA8D880B719
	for <dm-devel@redhat.com>; Tue,  6 Jul 2021 11:23:22 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-554-WCm9MiMYMuaCrs5vaUahBw-1;
	Tue, 06 Jul 2021 07:23:16 -0400
X-MC-Unique: WCm9MiMYMuaCrs5vaUahBw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15A8061E11;
	Tue,  6 Jul 2021 11:23:13 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue,  6 Jul 2021 07:20:41 -0400
Message-Id: <20210706112203.2062605-55-sashal@kernel.org>
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [dm-devel] [PATCH AUTOSEL 5.10 055/137] dm writecache: don't split
	bios when overwriting contiguous cache content
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit ee50cc19d80e9b9a8283d1fb517a778faf2f6899 ]

If dm-writecache overwrites existing cached data, it splits the
incoming bio into many block-sized bios. The I/O scheduler does merge
these bios into one large request but this needless splitting and
merging causes performance degradation.

Fix this by avoiding bio splitting if the cache target area that is
being overwritten is contiguous.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 8628c4aa2e85..64c2980aaa54 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1360,14 +1360,18 @@ static int writecache_map(struct dm_target *ti, struct bio *bio)
 	} else {
 		do {
 			bool found_entry = false;
+			bool search_used = false;
 			if (writecache_has_error(wc))
 				goto unlock_error;
 			e = writecache_find_entry(wc, bio->bi_iter.bi_sector, 0);
 			if (e) {
-				if (!writecache_entry_is_committed(wc, e))
+				if (!writecache_entry_is_committed(wc, e)) {
+					search_used = true;
 					goto bio_copy;
+				}
 				if (!WC_MODE_PMEM(wc) && !e->write_in_progress) {
 					wc->overwrote_committed = true;
+					search_used = true;
 					goto bio_copy;
 				}
 				found_entry = true;
@@ -1404,13 +1408,31 @@ static int writecache_map(struct dm_target *ti, struct bio *bio)
 				sector_t current_cache_sec = start_cache_sec + (bio_size >> SECTOR_SHIFT);
 
 				while (bio_size < bio->bi_iter.bi_size) {
-					struct wc_entry *f = writecache_pop_from_freelist(wc, current_cache_sec);
-					if (!f)
-						break;
-					write_original_sector_seq_count(wc, f, bio->bi_iter.bi_sector +
-									(bio_size >> SECTOR_SHIFT), wc->seq_count);
-					writecache_insert_entry(wc, f);
-					wc->uncommitted_blocks++;
+					if (!search_used) {
+						struct wc_entry *f = writecache_pop_from_freelist(wc, current_cache_sec);
+						if (!f)
+							break;
+						write_original_sector_seq_count(wc, f, bio->bi_iter.bi_sector +
+										(bio_size >> SECTOR_SHIFT), wc->seq_count);
+						writecache_insert_entry(wc, f);
+						wc->uncommitted_blocks++;
+					} else {
+						struct wc_entry *f;
+						struct rb_node *next = rb_next(&e->rb_node);
+						if (!next)
+							break;
+						f = container_of(next, struct wc_entry, rb_node);
+						if (f != e + 1)
+							break;
+						if (read_original_sector(wc, f) !=
+						    read_original_sector(wc, e) + (wc->block_size >> SECTOR_SHIFT))
+							break;
+						if (unlikely(f->write_in_progress))
+							break;
+						if (writecache_entry_is_committed(wc, f))
+							wc->overwrote_committed = true;
+						e = f;
+					}
 					bio_size += wc->block_size;
 					current_cache_sec += wc->block_size >> SECTOR_SHIFT;
 				}
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


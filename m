Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E23F9CCA473
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119095;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RaSy+Y/cENtkR2q7LbihkHezARjLGc+wCn57S5+YKRs=;
	b=euIChZEC+wQWWa/UFb5MEDSclJs9LKRp+ObufCuyCT4pzdeW8pj+UGKRXVPZWEOLDIeCs0
	oAHnFgGIxLpzhNeAN+B2KO25jhF5MtHx5cZahT7Id6OTjucxt5R5mxmpAsqqCBuoKpdFaS
	z/82pXE7X9qk9czcgzTvUHACgf9Ef+o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-QQhdzSUPPAGDVgZ34IHF8A-1; Wed, 06 Jul 2022 10:51:34 -0400
X-MC-Unique: QQhdzSUPPAGDVgZ34IHF8A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21601801C99;
	Wed,  6 Jul 2022 14:51:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0CFBC492C3B;
	Wed,  6 Jul 2022 14:51:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C6351947067;
	Wed,  6 Jul 2022 14:51:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7A298194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 09:38:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 696D440CFD0A; Wed,  6 Jul 2022 09:38:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 65D4540CF8E7
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 09:38:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E943811E7A
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 09:38:31 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-ycpIqYR_Ou2X6Qbz-5jeuw-1; Wed, 06 Jul 2022 05:38:23 -0400
X-MC-Unique: ycpIqYR_Ou2X6Qbz-5jeuw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4LdDVL16b9z6PgKX;
 Wed,  6 Jul 2022 17:18:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP3 (Coremail) with SMTP id _Ch0CgAXemmNU8VihkO+AQ--.22758S4;
 Wed, 06 Jul 2022 17:19:11 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 mpatocka@redhat.com
Date: Wed,  6 Jul 2022 17:31:46 +0800
Message-Id: <20220706093146.1961598-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: _Ch0CgAXemmNU8VihkO+AQ--.22758S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZw43uFy3AFyrJrW8XFWxCrg_yoW5WFW8pF
 Z7Jr15Gr1SvF47WwsrAa4UWa4FyayDJasFq347G3yxuF1DAwnxCFWUWFy2yF40qr97uFW3
 AF4DKrW8CryjyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWUWVWUuwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
 r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
 xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
 cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
 AvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
 xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: [dm-devel] [PATCH] dm writecache: fix inaccurate reads/writes stats
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
Cc: yukuai3@huawei.com, yi.zhang@huawei.com, linux-kernel@vger.kernel.org,
 yukuai1@huaweicloud.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Test procedures:

1) format a dm writecache device with 4k blocksize.
2) flush cache.
3) cache 1G data through write.
4) clear stats.
5) read 2G data with bs=1m.
6) read stats.

Expected result:
cache hit ratio is 50%.

Test result:
stats: 0, 1011345, 749201, 0, 263168, 262144, 0, 0, 0, 0, 0, 0, 0, 0
ratio is 99% (262144/263168)

The way that reads is accounted is different between cache hit and cache
miss:

1) If cache hit, reads will be accounted for each entry, which means reads
and read_hits will both increase 256 for each io in the above test.

2) If cache miss, reads will only account once, which means reads will only
increase 1 for each io in the above test.

The case that writes_around has the same problem, fix it by adding
appropriate reads/writes in writecache_map_remap_origin().

Fixes: e3a35d03407c ("dm writecache: add event counters")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-writecache.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index d74c5a7a0ab4..c2c6c3a023dd 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1329,16 +1329,29 @@ enum wc_map_op {
 	WC_MAP_ERROR,
 };
 
-static enum wc_map_op writecache_map_remap_origin(struct dm_writecache *wc, struct bio *bio,
-						  struct wc_entry *e)
+static enum wc_map_op writecache_map_remap_origin(struct dm_writecache *wc,
+						  struct bio *bio,
+						  struct wc_entry *e, bool read)
 {
+	sector_t next_boundary;
+	unsigned long long miss_count;
+
 	if (e) {
-		sector_t next_boundary =
+		next_boundary =
 			read_original_sector(wc, e) - bio->bi_iter.bi_sector;
 		if (next_boundary < bio->bi_iter.bi_size >> SECTOR_SHIFT)
 			dm_accept_partial_bio(bio, next_boundary);
+	} else {
+		next_boundary = bio->bi_iter.bi_size;
 	}
 
+	miss_count = (round_up(next_boundary, wc->block_size) >>
+			wc->block_size_bits) - 1;
+	if (read)
+		wc->stats.reads += miss_count;
+	else
+		wc->stats.writes += miss_count;
+
 	return WC_MAP_REMAP_ORIGIN;
 }
 
@@ -1366,7 +1379,7 @@ static enum wc_map_op writecache_map_read(struct dm_writecache *wc, struct bio *
 			map_op = WC_MAP_REMAP;
 		}
 	} else {
-		map_op = writecache_map_remap_origin(wc, bio, e);
+		map_op = writecache_map_remap_origin(wc, bio, e, true);
 	}
 
 	return map_op;
@@ -1458,7 +1471,8 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 direct_write:
 				wc->stats.writes_around++;
 				e = writecache_find_entry(wc, bio->bi_iter.bi_sector, WFE_RETURN_FOLLOWING);
-				return writecache_map_remap_origin(wc, bio, e);
+				return writecache_map_remap_origin(wc, bio, e,
+								   false);
 			}
 			wc->stats.writes_blocked_on_freelist++;
 			writecache_wait_on_freelist(wc);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB4F35DA78
	for <dm-devel@lists.linux.dev>; Tue, 18 Aug 2026 10:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787047568; cv=none; b=pXGpGr3CPe8XidDwVJPcDyV+f/tZVBuHvDNg3BcqhfReLj50vD0QU+IxRc37usrnKdZDh5qgmSZ8V9hVtD4OlyTfCtdr65Ow2YmaoiEr4EjLlKydnU0/gIYkqxEhgVXHBZI4xPmREQtFfTtJeZKuydSkIWYG1ziUL9+MYCWSChg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787047568; c=relaxed/simple;
	bh=L0xCe8dJVV8I8QCu+0haWA2zygXGtJnGgfpla3/+d6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Kwu7/vsbaa1N/YeG6EgjrqrSitXOQ6HlKyQqM6qG/Ur7ZqJKR7D+wzZV32ktqtG/+KzF8/wDLky+xIZn+ulD+n3FwE3DTiL41jfuXxpn2Jc2RZUuTTp+MPFjq+z9pk/jV9YmnjWkY5s8jIgtckdnomr/+zrkhfdgLiSv1I+ErQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JbxxI2SS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JbxxI2SS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787047566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c62CBXbLaeOSU+PeNa4ubeyli0G0E3JaDoFgah8zyfk=;
	b=JbxxI2SSs2moLbb7dO8p1PPa5u1CNsl6p56vGVx2FJt6rDEbfWiTOYu2IYAc0G8T1u+tyV
	UrO42Tc5gxIYUasCfPBkdu0zML6qT22EGYC4nCoWl5TmWV2/pJhjzX5tmO13BXpCvp0Ac0
	ksnVn5MMNwNrYB1IxTOUcEdtv7dPIQY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-249-OwUmdrFkNKWNkS3_uoV20g-1; Tue,
 18 Aug 2026 06:06:00 -0400
X-MC-Unique: OwUmdrFkNKWNkS3_uoV20g-1
X-Mimecast-MFC-AGG-ID: OwUmdrFkNKWNkS3_uoV20g_1787047559
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF6091800D9E;
	Tue, 18 Aug 2026 10:05:58 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.46])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 442C31956042;
	Tue, 18 Aug 2026 10:05:54 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Ben Marzinski <bmarzins@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH] dm cache: fix demotion stats in passthrough mode
Date: Tue, 18 Aug 2026 18:05:47 +0800
Message-ID: <20260818100547.79884-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NtBB-suO1WHKTOPoNzV2rSZnD4UxH_fbR9RXIoHqTWQ_1787047559
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The demotion counter is incremented per incoming write bio before the
invalidation begins, causing the demotion count to exceed the actual
number of cached blocks when multiple bios target the same cached
block. Additionally, the counter is incremented unconditionally
regardless of invalidation failure.

Reproduce steps:

1. Create a cache device consisting of 512 cache entries

modprobe brd rd_size=262144
dmsetup create cmeta --table "0 8192 linear /dev/ram0 0"
dmsetup create cdata --table "0 65536 linear /dev/ram0 8192"
dmsetup create corig --table "0 65536 linear /dev/ram0 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 65536 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. Populate the cache, and record the number of cached blocks

fio --name=populate --filename=/dev/mapper/cache --rw=randwrite --bs=4k \
--direct=1 --ioengine=libaio --iodepth=32 --io_size=2048m
nr_cached=$(dmsetup status cache | awk '{split($7, a, "/"); print a[1]}')

3. Reload the cache into passthrough mode

dmsetup suspend cache
dmsetup reload cache --table "0 65536 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"
dmsetup resume cache

4. Write to the passthrough cache with multiple jobs to trigger
   multiple bios hitting the same cached block.

fio --filename=/dev/mapper/cache --name=test --rw=write --bs=4k \
--direct=1 --ioengine=libaio --iodepth=32 --numjobs=4

5. Check if demoted matches cached block count. These numbers should
   match but may differ due to overcounting per bio.

nr_demoted=$(dmsetup status cache | awk '{print $12}')
echo "$nr_cached, $nr_demoted"

Fix by moving the demotion counter increment into invalidate_complete(),
gated on the success flag.

Reported-by: Ben Marzinski <bmarzins@redhat.com>
Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 097315a9bf0f..b79206816956 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1461,6 +1461,9 @@ static void invalidate_complete(struct dm_cache_migration *mg, bool success)
 	struct bio_list bios;
 	struct cache *cache = mg->cache;
 
+	if (success)
+		atomic_inc(&cache->stats.demotion);
+
 	bio_list_init(&bios);
 	if (mg->cell) {
 		if (dm_cell_unlock_v2(cache->prison, mg->cell, &bios))
@@ -1732,7 +1735,6 @@ static int map_bio(struct cache *cache, struct bio *bio, dm_oblock_t block,
 		if (passthrough_mode(cache)) {
 			if (bio_data_dir(bio) == WRITE) {
 				bio_drop_shared_lock(cache, bio);
-				atomic_inc(&cache->stats.demotion);
 				invalidate_start(cache, cblock, block, bio);
 				return DM_MAPIO_SUBMITTED;
 			} else
-- 
2.49.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305CA3A874B
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 11:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772625414; cv=none; b=AOFM/DzZQOF+h5nFzp7MKTeJAKl5hxLBJdaOgxJUcTuAGmnTZNhZBwtTheN+NeE88rBs5HHZTbzvSOv/1fzviyYOZ6Q9l4YMz9jpxvqULTNiG/0MzVG+n8gknCwU5axCIlvcxzytX1M2juZtUHeJKf3XaRzOh9ADVMCt1EW2L3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772625414; c=relaxed/simple;
	bh=tjMSROyZgXtmhjkNsG1xvx4TRIjt2gYuAh0IsHJyp64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=HubC1TkW+f+zyyFshEtpBKqNvwUhWHWEF74lYJ5twORygJq4O/8p55o2xua+u6qwRo2jHE0SZ2X9qxWgUygU3Rb/ROsSKnR97GZH+Z34WHHY+8WUgo8a/KGwl+kOZrhSNYeabeb4v4/MaAgcEzx7PLM2OTEDqwT6h74lTe35/vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C96pv0lC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C96pv0lC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772625410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YytD3YucMqefjunp4JOMJzD9J9RdEY42EvkSZ7yzZPg=;
	b=C96pv0lCO2IuvZvthqRbNC4tpBvSyU+oa9xrWS9t5D0G9RVQSx8J/zs64IKN0bRBdY+nF4
	YWCgOvyjXvewLzvwDC73TW/Q4+MPr6kLsW0GZIUL9BmtDI/k2/hlcTRiAxtuXRFxP3FIEh
	+8Ema2FfZK0+iL4Ia1RiWXORlcbP5wU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-uOQ7qwE4P0COBWj06NHmJw-1; Wed,
 04 Mar 2026 06:56:47 -0500
X-MC-Unique: uOQ7qwE4P0COBWj06NHmJw-1
X-Mimecast-MFC-AGG-ID: uOQ7qwE4P0COBWj06NHmJw_1772625406
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E62819560A1;
	Wed,  4 Mar 2026 11:56:46 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3CAE91800759;
	Wed,  4 Mar 2026 11:56:42 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH v2] dm cache metadata: fix memory leak on metadata abort retry
Date: Wed,  4 Mar 2026 19:56:28 +0800
Message-ID: <20260304115628.143949-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nkazJ9uH3EKLCTJZAvH4sZHn3cGH7BFmbVB_30XfZ9c_1772625406
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When failing to acquire the root_lock in dm_cache_metadata_abort because
the block_manager is read-only, the temporary block_manager created
outside the root_lock is not properly released, causing a memory leak.

Reproduce steps:

This can be reproduced by reloading a new table while the metadata
is read-only. While the second call to dm_cache_metadata_abort is
caused by lack of support for table preload in dm-cache, mentioned
in commit 9b1cc9f251af ("dm cache: share cache-metadata object across
inactive and active DM tables"), it exposes the memory leak in
dm_cache_metadata_abort when the function is called multiple times.
Specifically, dm-cache fails to sync the new cache object's mode during
preresume, creating the reproducer condition.

This issue could also occur through concurrent metadata_operation_failed
calls due to races in cache mode updates, but the table preload scenario
below provides a reliable reproducer.

1. Create a cache device with some faulty trailing metadata blocks

dmsetup create cmeta <<EOF
0 200 linear /dev/sdc 0
200 7992 error
EOF
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 131072 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 1 writethrough smq 0"

2. Suspend and resume the cache to start a new metadata transaction and
   trigger metadata io errors on the next metadata commit.

dmsetup suspend cache
dmsetup resume cache

3. Write to the cache device to update metadata

fio --filename=/dev/mapper/cache --name test --rw=randwrite --bs=4k \
--randrepeat=0 --direct=1 --size 64k

4. Preload the same table

dmsetup reload cache --table "$(dmsetup table cache)"

5. Resume the new table. This triggers the memory leak.

dmsetup suspend cache
dmsetup resume cache

kmemleak logs:

<snip>
unreferenced object 0xffff8880080c2010 (size 16):
  comm "dmsetup", pid 132, jiffies 4294982580
  hex dump (first 16 bytes):
    00 38 b9 07 80 88 ff ff 6a 6b 6b 6b 6b 6b 6b a5 ...
  backtrace (crc 3118f31c):
    kmemleak_alloc+0x28/0x40
    __kmalloc_cache_noprof+0x3d9/0x510
    dm_block_manager_create+0x51/0x140
    dm_cache_metadata_abort+0x85/0x320
    metadata_operation_failed+0x103/0x1e0
    cache_preresume+0xacd/0xe70
    dm_table_resume_targets+0xd3/0x320
    __dm_resume+0x1b/0xf0
    dm_resume+0x127/0x170
<snip>

Fixes: 352b837a5541 ("dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
v2: Remove redundant cmd->fail_io check after WRITE_LOCK_OR_GOTO since
    cmd_write_lock() already checks fail_io atomically under root_lock.
    Also mention the races in cache mode updates as alternative trigger.

 drivers/md/dm-cache-metadata.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 24a6eea5579f..acb335cee4d3 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1023,6 +1023,12 @@ static bool cmd_write_lock(struct dm_cache_metadata *cmd)
 			return;			\
 	} while (0)
 
+#define WRITE_LOCK_OR_GOTO(cmd, label)		\
+	do {					\
+		if (!cmd_write_lock((cmd)))	\
+			goto label;		\
+	} while (0)
+
 #define WRITE_UNLOCK(cmd) \
 	up_write(&(cmd)->root_lock)
 
@@ -1780,11 +1786,8 @@ int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 CACHE_MAX_CONCURRENT_LOCKS);
 
-	WRITE_LOCK(cmd);
-	if (cmd->fail_io) {
-		WRITE_UNLOCK(cmd);
-		goto out;
-	}
+	/* cmd_write_lock() already checks fail_io with cmd->root_lock held */
+	WRITE_LOCK_OR_GOTO(cmd, out);
 
 	__destroy_persistent_data_objects(cmd, false);
 	old_bm = cmd->bm;
-- 
2.49.0


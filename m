Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F9E2836A0
	for <dm-devel@lists.linux.dev>; Tue,  3 Mar 2026 12:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772541221; cv=none; b=sm4v7mAgGts5oFouiZieaOP9EhbC/QQj8KLyIPf6H6Ne+0DAiTlL+w4bmiiQLETmHb+wYhPbHCvrA3957KhCkm/iIbJlfAe2uIf9eItN534w6kfAmRhVTQ0Ecs0/mMh5qZ4kckQOjvIW1eRluJVuSaHJthiSBpcYCdjGHqnHYi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772541221; c=relaxed/simple;
	bh=fUjAf7e7L2sBkr7tkj7hbUInH34XoVi3BLoTFyTq45U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=N0BET2Cy93pNnudYTKf24GzZvV7QLo2ccZv44fLtTloaZ26Rn6XimZ/mYDA3WU7Ih791y4GhQDJF1/l72bMalqDFqHdIOFV3cXex41+EmkxbIoi4ym0f9Nr/L45rT73VaiZHmVK7bS2sDW9t5wrkn5KyK8gHYmt2FkTVvBV/1Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hmqkwsWs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hmqkwsWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772541219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=k2BMi/WI1jp0nubmEauxzAPmxJ3aGE5xrsvFxzJTBkQ=;
	b=hmqkwsWspIysXSflLnS9ClBV9M2OS81YhpUyq2Mj8FxoPxjzIwnVTH8mnJRCY6GznqoTI2
	oL6xXSQp9886Gwqno4amjDZ8Nb9DbkvedmpdLiUrTKUC/4Xm5N3Uvi8WO2g6KEb2J0g673
	50iEDpbhrnArMVFmA5AZxB6+jUUGp+0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-XdvwhLc8MveS2MOzvZeqUw-1; Tue,
 03 Mar 2026 07:33:36 -0500
X-MC-Unique: XdvwhLc8MveS2MOzvZeqUw-1
X-Mimecast-MFC-AGG-ID: XdvwhLc8MveS2MOzvZeqUw_1772541215
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FC8619560A3;
	Tue,  3 Mar 2026 12:33:35 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20DE11800370;
	Tue,  3 Mar 2026 12:33:31 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH] dm cache metadata: fix memory leak on metadata abort retry
Date: Tue,  3 Mar 2026 20:33:14 +0800
Message-ID: <20260303123314.75664-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -vkOB8ica0i5oRZu_uZzv0axUjlnOgDqastjin4f92E_1772541215
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
 drivers/md/dm-cache-metadata.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 24a6eea5579f..a8ad7dac84b2 100644
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
 
@@ -1780,7 +1786,7 @@ int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 CACHE_MAX_CONCURRENT_LOCKS);
 
-	WRITE_LOCK(cmd);
+	WRITE_LOCK_OR_GOTO(cmd, out);
 	if (cmd->fail_io) {
 		WRITE_UNLOCK(cmd);
 		goto out;
-- 
2.49.0


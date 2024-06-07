Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFCD10F4;
	Fri,  7 Jun 2024 00:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717719689; cv=none; b=o0UyArctCmD0lcXye1o36+ul6KrZxWzI+ERY+7yGZX1Bg/TIhrHxjcNtjMPvIdEqrMdhL3SQ9Nxk1b86Xp7v7z7vHGeXNoRu8R1uqRnnTRRFAGlYCRHCPlA5uuRxv0bU0NbB0nqis/e3F0i1c7OTcI9GOdgmZusZaSuhdumZNk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717719689; c=relaxed/simple;
	bh=vQ8Gf/Ers+0eETKce+w1dKy8sUU/qoj3cDWXOZUQz9c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RZ6fi5JhSsoWyRZ5PomeH6LwYRCv8N6xTRySNp4mLpCoaf4Qy/EjSLK+oZ1ySVRCH7/M4zx9u8UvXFrMBRHiGu+4cRV4bzKBNX3rHCdTCvQCkGQLIizo9Xir/DiB5cqwVgU2mNQ4wWT1zGQwGv9T5GynQBriX0f8cAYI96jEcNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVt28Hli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVt28Hli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC57C2BD10;
	Fri,  7 Jun 2024 00:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717719688;
	bh=vQ8Gf/Ers+0eETKce+w1dKy8sUU/qoj3cDWXOZUQz9c=;
	h=From:To:Subject:Date:From;
	b=eVt28Hlir+DCKJcus9pFTzTNI3c0TtpWc24MqpO9qiSgDegRG4ZBfcW6wyXlt9M3A
	 g05StvpCLkW/sdDZfP2OQ08wE4ehOgasvf6Ubt1A4KJty04pBL2sEdfbkqexYOkuNZ
	 UgyxQRYKhRUqwQZccwbZWRJxom/+i9qf8XBE47a7gF1aQ1Z/EC6/fXvAEaMa0ZHkKo
	 h7UvD6PdBX9p2q9mVPQxX4iVfypytHAX1W+Zm1GfjCI0gcVwNc0YbqBhyOpC/J4tY6
	 Lzd4aG/MM0CmLlRFgujjIimmMi4DTe/HNMmWeCYXiYAV+rW9CGFg7dCrGwZoEjikli
	 sQEGqVnWWe1Ew==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] block: Optimize disk zone resource cleanup
Date: Fri,  7 Jun 2024 09:21:26 +0900
Message-ID: <20240607002126.104227-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For zoned block devices using zone write plugging, an rcu_barrier() call
is needed in disk_free_zone_resources() to synchronize freeing of zone
write plugs and the destrution of the mempool used to allocate the
plugs. The barrier call does slow down a little teardown of zoned block
devices but should not affect teardown of regular block devices or zoned
block devices that do not use zone write plugging (e.g. zoned DM devices
that do not require zone append emulation).

Modify disk_free_zone_resources() to return early if we do not have a
mempool to start with, that is, if the device does not use zone write
plugging. This avoids the costly rcu_barrier() and speeds up disk
teardown.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 8f89705f5e1c..137842dbb59a 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1552,6 +1552,9 @@ static void disk_destroy_zone_wplugs_hash_table(struct gendisk *disk)
 
 void disk_free_zone_resources(struct gendisk *disk)
 {
+	if (!disk->zone_wplugs_pool)
+		return;
+
 	cancel_work_sync(&disk->zone_wplugs_work);
 
 	if (disk->zone_wplugs_wq) {
-- 
2.45.2


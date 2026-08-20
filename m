Received: from mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4982489891
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 21:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787262358; cv=none; b=tad93UD9iAH6llxvWh/8qa6AlX6QjGOP5XoeDc9UZaNatpQBqnyLOoixRfMYbBbbpKrcCeF6SaqO9ZuiMDSZrgWZw2uBAig2CvCNhO5Kt8PnV7C0danLfwlNEmAC3BSXHTqzUG6WwdKM8PKYC3xb7ewj0FjCRkDCZD4JfxBNSIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787262358; c=relaxed/simple;
	bh=rqBwdTzJTsUHLdH9mNFjmD0wlARq772TB++7ROC8Uhg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iW0It9cpp2+LerU0PjBJabmiOQe54OolenpW+mgrxfdyQj1eyYgUlbekh6Ldg7t6cipJNjvIZUr9F/RegwEqM+SBx6bilK2h+NyAocQ7PJG8ivcEsrRoT3U7qTSdN3JAYFjPaPf/66EV+Wn8qrUYVxaCFvTvddxeOY/G4HzktkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cressey.dev; spf=pass smtp.mailfrom=cressey.dev; dkim=pass (2048-bit key) header.d=cressey.dev header.i=@cressey.dev header.b=H4Unc+aO; arc=none smtp.client-ip=95.215.58.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cressey.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cressey.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cressey.dev header.i=@cressey.dev header.b="H4Unc+aO"
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=rqBwdTzJTsUHLdH9mNFjmD0wlARq772TB++7ROC8Uhg=;
 c=simple/simple; d=cressey.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787262353; v=1; x=1787867153;
 b=H4Unc+aO+kHgzlH8sEN9C+sbhuux7XoEfmpoEgE73j3K35g+vvU7NkszluVmwFSFwBFwJDuL
 be6pC227lRFLZCrb6/Hngr23yTE2cXYWq13Hv190PzhM7CcZ5VY1d68/67kJzBqeNrHtJlUYLlt
 B4Ug3qHrs0lfV5YQdDGX2S4+DRefzxSmUrDGfufbXbjn73pmmCe39LeA6ziBiciZKGiJJ6Ub/aZ
 3e3stB/sGHNC8hB+lJOC3af80wc22OmiwNYr+n/eYzYrbFYO+n21DgJcGn8qxuULZqTlcV8i2iC
 wJPvWsPeUUvo91mzhWrH/R3OWdInc9LX6nWbK6H81vWKw==
X-Envelope-To: dm-devel@lists.linux.dev
Received: from coder-bcressey-whiskers-0.coder-bcressey-whiskers.remote-dev.svc.cluster.local (35.83.186.167)
	by smtp.migadu.com with ESMTPS id b6f451db4fd30599;
	Thu, 20 Aug 2026 21:45:53 +0000
X-Mizu-Trace-ID: b6f451db4fd30599
X-Migadu-Flow: FLOW_OUT
From: Ben Cressey <ben@cressey.dev>
Date: Thu, 20 Aug 2026 21:44:57 +0000
Subject: [PATCH 1/2] dm-integrity: fix buffer overflow with keyed discard
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-dm-integrity-discard-v1-1-196d3618d09a@cressey.dev>
References: <20260820-dm-integrity-discard-v1-0-196d3618d09a@cressey.dev>
In-Reply-To: <20260820-dm-integrity-discard-v1-0-196d3618d09a@cressey.dev>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, Shukai Ni <shukai.ni@kuleuven.be>, 
 Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Mike Snitzer <snitzer@redhat.com>, 
 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>, 
 Ben Cressey <ben@cressey.dev>
X-Mailer: b4 0.15.2

Since commit 68c5c42567bc ("dm-integrity: replace forgeable discard
filler with a keyed sector marker"), integrity_metadata computes a
checksum for every discarded block into the "checksums" buffer.
integrity_sector_checksum always writes the whole digest. So if the tag
size is smaller than the digest size, the checksum of the last block
that fits into the buffer is written past the end of it. For example,
with hmac(sha256) and tag size 16, a 4MiB discard writes 16 bytes past
the kmalloc'ed page.

Fix this by subtracting extra_space from the buffer size when computing
max_blocks, like we do for writes.

Fixes: 68c5c42567bc ("dm-integrity: replace forgeable discard filler with a keyed sector marker")
Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: Claude:unspecified
---
Found with KASAN on current mainline (after the 7.3 dm merge): brd,
"0 <n> integrity /dev/ram0 0 16 J 2 internal_hash:hmac(sha256):<key>
allow_discards_keyed", 8MiB written, then BLKDISCARD of 4MiB:

  BUG: KASAN: slab-out-of-bounds in __hmac_sha256_final+0x1be/0x1e0
  Write of size 4 at addr ff11000104b05000 by task kworker/0:0/9
  Workqueue: dm-integrity-offload integrity_bio_wait
   integrity_sector_checksum_shash+0x181/0x490
   integrity_metadata+0x101e/0x18a0
   dm_integrity_map_continue+0x1eb2/0x34d0
  The buggy address is located 0 bytes to the right of
   allocated 4096-byte region
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index c50feaa98bf9e..73c1db7e55d5c 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1980,7 +1980,7 @@ static void integrity_metadata(struct work_struct *w)
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
 			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
-			unsigned int max_blocks = max_size / ic->tag_size;
+			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
 			sector_t sector = dio->range.logical_sector;
 
 			if (!ic->discard_keyed)

-- 
2.53.0


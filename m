Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CCE17BB6;
	Thu,  3 Oct 2024 01:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727918177; cv=none; b=A6b4R0nzKvzy2rszN6pUsOIz9sUF6YS9hx1mFVjN8BYnZ4S876lc5B+UzfOn4u6RRPkJ0X5cVHN0a4qt5BsOgPI3iPywo8y8qBEg1VeOyfrO31Pl+Zhsrg4zwtHK9oYKwX+CX4+fuHDZtt94yls1i9YtY6zvCCbHM7msXOGH0iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727918177; c=relaxed/simple;
	bh=EpYZoNR/IU1qKBDFNxBkkRtrmlKPw9YQyQdWkhpZN4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iukUz9Y+jlDBTuO6HTpdW+MFuBCbNj0VJFmBd7zsxMWMujP+3GSGiAptL8f7VOVq0Cse8JyU2zciZ9rxDWI32ZErnjpnJ5QpH35S39iMsRIuWmOY1uNTAb6kTBShtHiMxoLVbi0/AVfLLa3kt4fIxIrUnGF3jnkMz4KJcn+ASGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=BcprqNvu; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="BcprqNvu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=H3JQLHPWDS2GmOiIkpOwMQLDiiaYcGQvArj/9yvjlMA=; b=BcprqNvuIVseM5cj
	wfBzZ8KH/EcF9O3SBSTlEFe6vKGe4bdyJZCfmSLSjHTwMyzw2opdx4U1y+5fxba/4Frc9PM1yRgSK
	wr3PiC7yWwHMPI/CipX97GvvuEpVSWOXp4joOlmchHHjJkEJ7hNDRVCMQWfsS3E+EseoUTPu/GM/s
	Scahh/l2zeFZ0YEVidT7eG5TLuNqiXeLOUdTfInnTb966WQLpnY2IuXGvfQW/0vDl/KAKkL3cwdL0
	jDh1R6WF315W1DD9nGxV7Eh5Ullzy+JAlBMc74GoOhzFQOxbQUnHmwLkaq6PtlX6omz6P0lZFsPcE
	NmZuUIi59W3nSppkTA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1swARt-008Zju-1M;
	Thu, 03 Oct 2024 01:16:09 +0000
From: linux@treblig.org
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 2/9] dm cache: Remove unused dm_cache_dump
Date: Thu,  3 Oct 2024 02:15:47 +0100
Message-ID: <20241003011554.266654-3-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241003011554.266654-1-linux@treblig.org>
References: <20241003011554.266654-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

dm_cache_dump() has been unused since the original commit
c6b4fcbad044 ("dm: add cache target")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/md/dm-cache-metadata.c | 24 ------------------------
 drivers/md/dm-cache-metadata.h |  2 --
 2 files changed, 26 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 24cd87fddf75..5c757603ab36 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1507,30 +1507,6 @@ int dm_cache_load_mappings(struct dm_cache_metadata *cmd,
 	return r;
 }
 
-static int __dump_mapping(void *context, uint64_t cblock, void *leaf)
-{
-	__le64 value;
-	dm_oblock_t oblock;
-	unsigned int flags;
-
-	memcpy(&value, leaf, sizeof(value));
-	unpack_value(value, &oblock, &flags);
-
-	return 0;
-}
-
-static int __dump_mappings(struct dm_cache_metadata *cmd)
-{
-	return dm_array_walk(&cmd->info, cmd->root, __dump_mapping, NULL);
-}
-
-void dm_cache_dump(struct dm_cache_metadata *cmd)
-{
-	READ_LOCK_VOID(cmd);
-	__dump_mappings(cmd);
-	READ_UNLOCK(cmd);
-}
-
 int dm_cache_changed_this_transaction(struct dm_cache_metadata *cmd)
 {
 	int r;
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index 57afc7047947..3e5472173baa 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -123,8 +123,6 @@ int dm_cache_get_free_metadata_block_count(struct dm_cache_metadata *cmd,
 int dm_cache_get_metadata_dev_size(struct dm_cache_metadata *cmd,
 				   dm_block_t *result);
 
-void dm_cache_dump(struct dm_cache_metadata *cmd);
-
 /*
  * The policy is invited to save a 32bit hint value for every cblock (eg,
  * for a hit count).  These are stored against the policy name.  If
-- 
2.46.2


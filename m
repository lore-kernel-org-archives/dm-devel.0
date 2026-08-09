Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A251F16B
	for <dm-devel@lists.linux.dev>; Sun,  9 Aug 2026 05:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786252756; cv=none; b=j6jE0tq4PlOxJs/+JeWVt8C2Np4PFn7QQ/mcTPIkTa4HHVZRKwa9WpzxvRwoWRTgrfdwQlKyLGZkQECcqHcArM+Yr7eeU5fOxDpRkqUI1OUgzKi3JpKe76kmzh3PpMreZm+vwVNEjFujGdvYZXimWLGTQ5R9C0JLCPe/m0GYBIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786252756; c=relaxed/simple;
	bh=730NGO+OLHLql5ltl2Sao+Pip2aNRr2vZFLsPQg6qWc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bOOgFYEnGRupJdM/580nME8fnWDwWrCBGX5WmshsaQ3EsnNCmx0I822uYJ72j7QJ6yILnjBM6aBG8fYlnuB2yiB4oJpEDlyJRM5UZr+xVL4O9NaxtwXf3xhDQLsWjw8ml5YPwJbQVy2mAp7NH5qf0KdlS87m2+U6m6JkDtJBPgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=TC18frBC; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="TC18frBC"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 494a666f6;
	Sun, 9 Aug 2026 13:19:07 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	runyu.xiao@seu.edu.cn,
	jianhao.xu@seu.edu.cn
Subject: [PATCH] dm-crypt: unlock allocation mutex before retry
Date: Sun,  9 Aug 2026 13:18:39 +0800
Message-Id: <20260809051839.3504080-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9fe4f5e31b03a1kunm80c6b82374bb3
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSU1MVh4eSENMHkMZH05KGFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=TC18frBCKI05lPeofl7ghkrLEMo76xMAggs0FWP6lg6mwQg18Eg0U+UohbmS5tLKSANLtNy2lCYcW+lH8+IesPDmMk43VvPjXlVWy7h5J8lSb3b6Wez9d5VSCvHtS5DNQCtfgKi3poJ7aAo6PYGfiP2+jQXlN4wz7HngPktLk6Y=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=dnEkjdinUx2l01HDZ++L+yTZhZ5TmKgdNLcAsCC4tNk=;
	h=date:mime-version:subject:message-id:from;

If the initial GFP_NOWAIT page allocation fails, crypt_alloc_buffer()
sets __GFP_DIRECT_RECLAIM and retries while holding bio_alloc_lock. If a
later page allocation fails, the retry edge bypasses the common unlock and
reacquires the same mutex. This can deadlock the dm-crypt I/O path and
leave I/O for the affected mapping stalled.

Release the mutex before retrying, but only when this attempt took the
direct-reclaim path; the first attempt did not acquire it.

This issue was identified by a static-analysis checker and manually
confirmed by following the retry control flow in v6.1.66 and current
mainline. A source-level control-flow check verified the vulnerable
ordering and the unlock-before-retry ordering after this change. A small
POSIX-thread model checked only the mutex re-acquisition condition; it does
not exercise dm-crypt.

Fixes: 7145c241a1bf ("dm crypt: avoid deadlock in mempools")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/md/dm-crypt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 608b617fb817..aabb9a5f85a7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1674,6 +1674,8 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 		if (!pages) {
 			crypt_free_buffer_pages(cc, clone);
 			bio_put(clone);
+			if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
+				mutex_unlock(&cc->bio_alloc_lock);
 			gfp_mask |= __GFP_DIRECT_RECLAIM;
 			order = 0;
 			goto retry;
-- 
2.34.1

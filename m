Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BC82594B9;
	Sun,  1 Mar 2026 01:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328069; cv=none; b=QQe7WrsmojFVeXrA5JZwbgiLYs0Y7hs7wbGS06JnKGccNT3m/VBt0SjuKM5oeg+PidOd0Cz5xZ4zqXMTfe6F/q7wly1T46nBFlAqfEtIqJhHZLG0PbYQp0iSUVXNGRfAR/mW3E1TicE1+GM1j5pc2iSwNWymatQVZOFW2PqR6y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328069; c=relaxed/simple;
	bh=6+gu4Xajp1ethqr+RImvnmiolAvnR3vfCki4OvHsALM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gb1mIejWJVrhCyiV3B2ykfWFI5OVbPaW1EglEFLB2MKmvgUXYSgatgikWG/3osuMS140rxjByxyTGwGW2R83YW4YMGSFKrb5v0eKZd4PXmG+x62NOnmxjCrX+veJgaggoXUhqPs7uU4PQVv7SPuGZYdGtN6pXy4lfzR5TkdsvDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3E+FjFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3E+FjFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69453C19421;
	Sun,  1 Mar 2026 01:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328068;
	bh=6+gu4Xajp1ethqr+RImvnmiolAvnR3vfCki4OvHsALM=;
	h=From:To:Cc:Subject:Date:From;
	b=o3E+FjFY7F2waAPVZQZhSFZoLWFtAxto44YVEvbaMer7OEr3cE9W1JQoAALtURMyO
	 dh2kFRzt1V66354Ovr/o6MkW0HDmP8I55CZjx8AzwJg6gEvxCU1RUuZhAU3pAmfb8V
	 hvBvOJeMGGlSkj2D+Ty+X56EggQk23XxMp4isuuqxqMd6cdpj8/FK4PV3ZMl5L+VtR
	 J01mZpN/ShYlUuZmNcoPELgzFzOFLpYZLe3rt29ey9fCDl//OcjKJGDMqtuRMqykX+
	 7ufYNWFnSiLobePwphoODjZqBMgJbB2aSc+2ziUKSxDuZ47mQSrQ2qrCDwGM2gdFA/
	 FXkrLqDuubYQQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm-integrity: fix a typo in the code for write/discard race" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:21:07 -0500
Message-ID: <20260301012107.1676933-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From c698b7f417801fcd79f0dc844250b3361d38e6b8 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Mon, 12 Jan 2026 21:15:27 +0100
Subject: [PATCH] dm-integrity: fix a typo in the code for write/discard race

If we send a write followed by a discard, it may be possible that the
discarded data end up being overwritten by the previous write from the
journal. The code tries to prevent that, but there was a typo in this
logic that made it not being activated as it should be.

Note that if we end up here the second time (when discard_retried is
true), it means that the write bio is actually racing with the discard
bio, and in this situation it is not specified which of them should win.

Cc: stable@vger.kernel.org
Fixes: 31843edab7cb ("dm integrity: improve discard in journal mode")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 170bf67a2edd9..79d60495454a5 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2411,7 +2411,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 
 		new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
 		if (unlikely(new_pos != NOT_FOUND) ||
-		    unlikely(next_sector < dio->range.logical_sector - dio->range.n_sectors)) {
+		    unlikely(next_sector < dio->range.logical_sector + dio->range.n_sectors)) {
 			remove_range_unlocked(ic, &dio->range);
 			spin_unlock_irq(&ic->endio_wait.lock);
 			queue_work(ic->commit_wq, &ic->commit_work);
-- 
2.51.0





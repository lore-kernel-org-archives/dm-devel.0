Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BE02BD0B;
	Sun,  1 Mar 2026 01:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328128; cv=none; b=V9sBQhVC4LZBve7GwDQZ9cldiGEwLU2ekqNgHBPwU/LiaiP+86+aZjqVV5g6hWmh6HTLQCBJDBCPmZyQxcOBEexyMs3UjeKOqk5TzlotrwwhEhxvkO3XelE4soPquWo2dogbTB4zFF31YKH1Tc44FyuDvCjUfeacaQUY6udvncE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328128; c=relaxed/simple;
	bh=ih2Dd/RaF24QD/X5P2E3Ua0bTxxuraC/vK8wpf7vWoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UrbKM0V3q0KiyuhLrfHm5HNIBE48hKvfKeZUdhr+UUAtq8asSdTexrxIlmcSZ3jUA641HqovDKXCKSKHPRTPP6QWRITtWF3tVuPtHUFQnwh0LY9nSAMzUbKifyuR9Rplz7O9JbN2xnX+BpJTZ7S1FirOut128L2EfMi7jL2bXhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgkS0E1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgkS0E1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94D1C19421;
	Sun,  1 Mar 2026 01:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328128;
	bh=ih2Dd/RaF24QD/X5P2E3Ua0bTxxuraC/vK8wpf7vWoQ=;
	h=From:To:Cc:Subject:Date:From;
	b=VgkS0E1v0sCT/4VhndhuY17xJ/q0ZulhZMZwlsE6IdFpCeBCdlCo9eCqpwq7QvgDx
	 3X++nCV95igVs9yHcTOK6AGe4kPeQ/XQvtrLIlZ0W7iCY3ufo3kS+MoJy4FNSoVZo3
	 gjau4+B0kKzsDB4rBKjgzEVA/FUdlYobfBArAKBIO6ot9JFUfXh0dE9pB+XieS+zbP
	 BlHCEiMp1BkQe+bx1iKK2wjFTT70cp4t4DXnP/G0Jbgzym0/vZpup7F9MPM9ZBi9MF
	 3fY35vrVAYzV1/tqU/pdG8PUAgMrgyO459Ur6GMVJavtptTnrtHWubwP02bz9A5+dH
	 28BdZXPsF2p2w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	kernel@mattwhitlock.name
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm-unstripe: fix mapping bug when there are multiple targets in a table" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:22:06 -0500
Message-ID: <20260301012206.1678262-1-sashal@kernel.org>
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

From 83c10e8dd43628d0bf86486616556cd749a3c310 Mon Sep 17 00:00:00 2001
From: Matt Whitlock <kernel@mattwhitlock.name>
Date: Sun, 18 Jan 2026 13:36:15 -0500
Subject: [PATCH] dm-unstripe: fix mapping bug when there are multiple targets
 in a table

The "unstriped" device-mapper target incorrectly calculates the sector
offset on the mapped device when the target's origin is not zero.

Take for example this hypothetical concatenation of the members of a
two-disk RAID0:

linearized:       0 2097152 unstriped 2 128 0 /dev/md/raid0 0
linearized: 2097152 2097152 unstriped 2 128 1 /dev/md/raid0 0

The intent in this example is to create a single device named
/dev/mapper/linearized that comprises all of the chunks of the first disk
of the RAID0 set, followed by all of the chunks of the second disk of the
RAID0 set.

This fails because dm-unstripe.c's map_to_core function does its
computations based on the sector number within the mapper device rather
than the sector number within the target. The bug turns invisible when
the target's origin is at sector zero of the mapper device, as is the
common case. In the example above, however, what happens is that the
first half of the mapper device gets mapped correctly to the first disk
of the RAID0, but the second half of the mapper device gets mapped past
the end of the RAID0 device, and accesses to any of those sectors return
errors.

Signed-off-by: Matt Whitlock <kernel@mattwhitlock.name>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 18a5bf270532 ("dm: add unstriped target")
---
 drivers/md/dm-unstripe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index e8a9432057dce..17be483595642 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -117,7 +117,7 @@ static void unstripe_dtr(struct dm_target *ti)
 static sector_t map_to_core(struct dm_target *ti, struct bio *bio)
 {
 	struct unstripe_c *uc = ti->private;
-	sector_t sector = bio->bi_iter.bi_sector;
+	sector_t sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
 	sector_t tmp_sector = sector;
 
 	/* Shift us up to the right "row" on the stripe */
-- 
2.51.0





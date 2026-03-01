Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E7216132A;
	Sun,  1 Mar 2026 02:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330468; cv=none; b=kXhjVNVWlhFwSe+wSEFkp1nXm4RsTxkqFx+tuIR8orc58t/HVWMtTVzzN5bJM1qE7eTYdatdMmV5siKM729LOQXBg0jjOTjSnItjWHKJuVSrNPL0LKRPP7H7l1zzmocZ9Poqi6B3fvQ2XuInTYeyIwsCPuoE31iVV7vXnrEZ2aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330468; c=relaxed/simple;
	bh=XZqSslqH5aefPUYHLUJgLTcF85MLhe81LypuMbegfcY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RxNoFsRTJ663VxirNZ+qLuENvXwvfn+tSAdSO+iunlezFHnOdjgitktaZPpVKC5ziEjjrXdjfQRxQa2iMlFxyAAu92+HKDtDo+SbROTEvI1p3VVASPXsKnW5Fn5HiI3Tr+4l6TjsBMutx2ISKXmeMnB9k4MLgun5XAB0bXUJIoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oet0Twc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oet0Twc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9937EC19425;
	Sun,  1 Mar 2026 02:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330468;
	bh=XZqSslqH5aefPUYHLUJgLTcF85MLhe81LypuMbegfcY=;
	h=From:To:Cc:Subject:Date:From;
	b=Oet0Twc0mAdkkhAsKz2O9zYwPHmIzDGf7gQJxuz9mpCvIFZmOmvLwLG6eRVPqXyoo
	 JeEmOgFQwghc1fBto+TcmyoT7WEWG1j4idX0lttDuqGc/GnDL3fL9f0Azb+68PQ/Kg
	 jgL9JOdBwTDiyOKd29YkU60O/eT9r97LKknlJyRGiV1BkSt0/sGBtaG7gI/FuzTUlm
	 HY2xExWbxQMa1UPU+hJJ1N4P3k4W3Xh7R56X9/6RukWY6KDsGjZKE5XLfeDj+hgXiz
	 91Y6iVQudkn77D8C7sqo3zjk/xHBONw+1Ej7UPaUP6fhvJPfqnf4QzCSlIOf2UTPNr
	 PuXfs/Wd/iFgA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	kernel@mattwhitlock.name
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm-unstripe: fix mapping bug when there are multiple targets in a table" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:01:06 -0500
Message-ID: <20260301020106.1728117-1-sashal@kernel.org>
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

The patch below does not apply to the 5.10-stable tree.
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





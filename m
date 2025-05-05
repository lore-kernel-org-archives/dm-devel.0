Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47482D2CD3;
	Mon,  5 May 2025 23:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486128; cv=none; b=Kdss8E/KpYD3MbFrEQnzwF0ej9tIuSXb2OJDRnI9PyhcTU9/EV7yoc/XAkL2O4TH6d5MpoTgCZervBG9nL4m+XsNgOkbhLUvDNNfweAPMuVs8R+GXF8uqvLL2G/JyIXxUKLk2NeHide0Td4Gpzm+FFIZQwIP3eGYbqK4n4z+C0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486128; c=relaxed/simple;
	bh=oQclxnIaI4lHrzdjhuHJdETat9Mz0A7+aU01aLzbpaM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RnSjMeCatXXQSNcpOPloSaI15lew2N50xm8hlkFJeYY9I8YaztPsBgRSzpBhDNPHU51kI/EAncGOi+9iKNM6kVbBaK/LsGLCfCE7AdCFhSOy9HTuR8T1BmJaBVYRkIAvYRylfAJ56Tpyd5G4LsSFwRw6DfI1LEKgFJ/mO2xpLDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQwT6+E3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQwT6+E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3752EC4CEED;
	Mon,  5 May 2025 23:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486127;
	bh=oQclxnIaI4lHrzdjhuHJdETat9Mz0A7+aU01aLzbpaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQwT6+E3CeAvoM5I42EPQ/u+wQAzToiqwRrvl93UM11cIaX4qR8jrQ4hSA5lohCiO
	 AIyc9+ZHWIVKN9P3+9v3DP/+7otEMjulqOok4LrR+aAbD+3yS+SO8jBUnYp6a/NMBU
	 TfopEkVLCopyrd66upR9k7DBrx7NmmI6bg+DyCO5a+JEY6iomjSYnL9fl2U1VnfRiC
	 fZ2O/KxIi7kT9YknPZTkHtnIvV+nIXE0OCzvbF6vUoOsPEQBCMAXdTtBrKg+DwnJJo
	 yYcs/9ntLFSEaGz+4k+SUbk4b/YNqF86paHhxUHIBnI8fKpGaIYukgzDenbpbM8xzO
	 4iGnGlfTGOAuw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jinliang Zheng <alexjlzheng@gmail.com>,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Tianxiang Peng <txpeng@tencent.com>,
	Hao Peng <flyingpeng@tencent.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.6 166/294] dm: fix unconditional IO throttle caused by REQ_PREFLUSH
Date: Mon,  5 May 2025 18:54:26 -0400
Message-Id: <20250505225634.2688578-166-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@gmail.com>

[ Upstream commit 88f7f56d16f568f19e1a695af34a7f4a6ce537a6 ]

When a bio with REQ_PREFLUSH is submitted to dm, __send_empty_flush()
generates a flush_bio with REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
which causes the flush_bio to be throttled by wbt_wait().

An example from v5.4, similar problem also exists in upstream:

    crash> bt 2091206
    PID: 2091206  TASK: ffff2050df92a300  CPU: 109  COMMAND: "kworker/u260:0"
     #0 [ffff800084a2f7f0] __switch_to at ffff80004008aeb8
     #1 [ffff800084a2f820] __schedule at ffff800040bfa0c4
     #2 [ffff800084a2f880] schedule at ffff800040bfa4b4
     #3 [ffff800084a2f8a0] io_schedule at ffff800040bfa9c4
     #4 [ffff800084a2f8c0] rq_qos_wait at ffff8000405925bc
     #5 [ffff800084a2f940] wbt_wait at ffff8000405bb3a0
     #6 [ffff800084a2f9a0] __rq_qos_throttle at ffff800040592254
     #7 [ffff800084a2f9c0] blk_mq_make_request at ffff80004057cf38
     #8 [ffff800084a2fa60] generic_make_request at ffff800040570138
     #9 [ffff800084a2fae0] submit_bio at ffff8000405703b4
    #10 [ffff800084a2fb50] xlog_write_iclog at ffff800001280834 [xfs]
    #11 [ffff800084a2fbb0] xlog_sync at ffff800001280c3c [xfs]
    #12 [ffff800084a2fbf0] xlog_state_release_iclog at ffff800001280df4 [xfs]
    #13 [ffff800084a2fc10] xlog_write at ffff80000128203c [xfs]
    #14 [ffff800084a2fcd0] xlog_cil_push at ffff8000012846dc [xfs]
    #15 [ffff800084a2fda0] xlog_cil_push_work at ffff800001284a2c [xfs]
    #16 [ffff800084a2fdb0] process_one_work at ffff800040111d08
    #17 [ffff800084a2fe00] worker_thread at ffff8000401121cc
    #18 [ffff800084a2fe70] kthread at ffff800040118de4

After commit 2def2845cc33 ("xfs: don't allow log IO to be throttled"),
the metadata submitted by xlog_write_iclog() should not be throttled.
But due to the existence of the dm layer, throttling flush_bio indirectly
causes the metadata bio to be throttled.

Fix this by conditionally adding REQ_IDLE to flush_bio.bi_opf, which makes
wbt_should_throttle() return false to avoid wbt_wait().

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Reviewed-by: Tianxiang Peng <txpeng@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5dd0a42463a2b..9ea868bd0d129 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1536,14 +1536,18 @@ static void __send_empty_flush(struct clone_info *ci)
 {
 	struct dm_table *t = ci->map;
 	struct bio flush_bio;
+	blk_opf_t opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
+
+	if ((ci->io->orig_bio->bi_opf & (REQ_IDLE | REQ_SYNC)) ==
+	    (REQ_IDLE | REQ_SYNC))
+		opf |= REQ_IDLE;
 
 	/*
 	 * Use an on-stack bio for this, it's safe since we don't
 	 * need to reference it after submit. It's just used as
 	 * the basis for the clone(s).
 	 */
-	bio_init(&flush_bio, ci->io->md->disk->part0, NULL, 0,
-		 REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC);
+	bio_init(&flush_bio, ci->io->md->disk->part0, NULL, 0, opf);
 
 	ci->bio = &flush_bio;
 	ci->sector_count = 0;
-- 
2.39.5


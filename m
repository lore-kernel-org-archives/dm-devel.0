Received: from lf-1-128.ptr.blmpb.com (lf-1-128.ptr.blmpb.com [103.149.242.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAFB3672BE
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 09:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.149.242.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778663393; cv=none; b=IlDJqQ4VoZ1ozsRZWc3kVBzYQ3v6QrMIcMS+pwoc2B3LaElnTy51ZoHlP/2dQFBn1r9PA2tt6z1Mr/0D/GOhD45fbDmsu2E89On6R/q2sfT94GqMQTyVLuLK5ZO7evks0aYycgWjul8LWVYQ9U8ZYkk2blkZ0I5K9f375oXRvhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778663393; c=relaxed/simple;
	bh=Uw0uScx8E1a3wIEO5ri99NR4rDuQtAaM+XVL+5J8xD0=;
	h=Date:Subject:Content-Type:To:Cc:Mime-Version:From:Message-Id; b=jgYh11Qham1h5EOP8qSSYtF3l1PmocFln9kRQocGFtOMLu/l40dZG8oBtbKZCL+aZM44NuSgCPWSegftUy5RBpq5rUVwF6w4qeUOv9SnBt9w046S4X2phG/9R1f5oBtIn/lK0b2lU4arxA2Q31gLUegUYad22hsUyVoypHRxwwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=I5h1iDV9; arc=none smtp.client-ip=103.149.242.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="I5h1iDV9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778663299; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=y9nLA5PRTc6yF2cdJng5j4g+eBMacB7v/4HE+A0Ob9E=;
 b=I5h1iDV9Ssd1bg8h5q7eLtPqgfebv33khYcuDn/RG0nFrgAcV7Nu4Tm8P20RlOrSaennVp
 5pXViXz6YP9WX/iZ0/6vOtPy3Ph3sfWIxw2xRcphXOA0XoFx0SUR8xl1vhFVFtC35xAGwU
 G9U+BOg1f4t49QrXQh2fHOvohBS+7d3qefOsUNtEyk/Q+1Ld3o5qnC7gCKoWzHGva0xtEF
 xOz1I25o1cgr5xnsCGytKOPdzzC2VUsuRCPd6qpLN1V40RrwIhBqsCB3URsvJXq4k+whWn
 ZD2jMozENT3oPwHGctCILkpsTBqgfmQGDaOOqjg9iRgtSXO7kVO24mVHjWU11Q==
Date: Wed, 13 May 2026 17:07:55 +0800
Subject: [PATCH] dm: limit target bio polling to one shot
X-Lms-Return-Path: <lba+26a043f81+d5f666+lists.linux.dev+changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
To: <axboe@kernel.dk>, <asml.silence@gmail.com>, <io-uring@vger.kernel.org>, 
	<agk@redhat.com>, <nitzer@kernel.org>, <bmarzins@redhat.com>, 
	<dm-devel@lists.linux.dev>
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
Content-Transfer-Encoding: 7bit
From: "Fengnan Chang" <changfengnan@bytedance.com>
Message-Id: <20260513090755.99278-1-changfengnan@bytedance.com>

dm_poll_bio() is the ->poll_bio() callback for a stacked dm device.
The caller only knows about the dm queue, so it may decide to do a
spinning poll if it thinks a single queue is being polled. Passing those
flags unchanged to the mapped clone lets blk_mq_poll() spin on a target
queue from inside dm_poll_bio().

With io_uring IOPOLL on a dm-stripe target this can keep a task in

  dm_poll_bio() -> bio_poll() -> blk_mq_poll()

long enough to trigger an RCU CPU stall, before io_uring gets back to
io_iopoll_check() and its need_resched() check.

Keep dm's ->poll_bio() bounded by forcing one-shot polling for target
bios. The caller can invoke dm_poll_bio() again if it wants to keep
polling, and it also gets a chance to reap completions or reschedule
between passes.

Fixes: f22ecf9c14c1 ("blk-mq: delete task running check in blk_hctx_poll()")
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 drivers/md/dm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e178fe19973ea..8f44fbbcf3da2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2098,8 +2098,17 @@ static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
 	WARN_ON_ONCE(!dm_tio_is_normal(&io->tio));
 
 	/* don't poll if the mapped io is done */
-	if (atomic_read(&io->io_count) > 1)
-		bio_poll(&io->tio.clone, iob, flags);
+	if (atomic_read(&io->io_count) > 1) {
+		/*
+		 * DM hides the target queues from the upper poller, which may
+		 * decide it is safe to spin on a single stacked queue.  Do not
+		 * pass that spinning policy down to a target queue: one slow
+		 * clone could keep the task inside dm_poll_bio() for a long
+		 * time.  Poll target bios once and let the caller decide
+		 * whether to keep polling, reap completions or reschedule.
+		 */
+		bio_poll(&io->tio.clone, iob, flags | BLK_POLL_ONESHOT);
+	}
 
 	/* bio_poll holds the last reference */
 	return atomic_read(&io->io_count) == 1;
-- 
2.39.5 (Apple Git-154)

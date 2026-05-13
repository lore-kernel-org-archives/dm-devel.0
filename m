Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA233E51F2
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 09:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778663662; cv=none; b=d/uCfZ0RHtCZAG5+P0TNGjKMt5tMVM6E4xZKYUZ+SqW6TwLGbDvpg7MAy9IQDepYZozBg7uZWmEqmiIz5jeImN+0/ZHxh2PfKe4agp3t+k2oSaa+s7U2UqtIxnU6Kq/nsEqhRUYOTiGRHvKm7DOJEoAWuLSW207apsbEcnGXkzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778663662; c=relaxed/simple;
	bh=Uw0uScx8E1a3wIEO5ri99NR4rDuQtAaM+XVL+5J8xD0=;
	h=Date:Content-Type:Cc:Subject:Mime-Version:To:From:Message-Id; b=epoHDZAl1BBPRlKzC/ZQ3Qdb7I5Y7jIehTGhufYSx5ueHXSt0fW3cdLCyRBWaxSfVr0GheTCdl3+DHmbgJXCJKWOXiiPVfo3v5ZrpLbBXKy0TlS9JGJr0j4neVGbPipG7y8eC7pVGeJZdsX1hcCBR3P5c4Z7HaW9Ed6JZoFYBMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=j4xV9Q+p; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="j4xV9Q+p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778663650; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=y9nLA5PRTc6yF2cdJng5j4g+eBMacB7v/4HE+A0Ob9E=;
 b=j4xV9Q+puY7d8l3iZfDVdfWBIn0QdqPOy6q4YJcMB1mIHbqYrWF46SLhyBSaUFbmbmfuQF
 uHSzrpbEWvcn8pyFHcYRSOaabw16aCglp4CvWB1qY7uTSGWcFU6ClxtsGrRPlLVgH+yMUc
 yEtzJctaSYUtK0ag8bZmOzAjmMf3p3YVAURdicnoIg+uCP/rIziAihXr9tPcyZ8mLEFsJi
 oqH/ue034JzAu91haYuNiB1cUv6FnU/1a8A6F/H4YjbdR7vIXRPRTqVRN4TeXbmEAgx3oZ
 tzrMhOnEnIsQe4j49lUfieWevaj8fQlpZlmfhPBcCd/1gwybIv4rFJ1IhyFswQ==
Date: Wed, 13 May 2026 17:13:49 +0800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Subject: [PATCH RESEND] dm: limit target bio polling to one shot
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a0440e0+74435d+lists.linux.dev+changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
To: <axboe@kernel.dk>, <asml.silence@gmail.com>, <io-uring@vger.kernel.org>, 
	<agk@redhat.com>, <snitzer@kernel.org>, <bmarzins@redhat.com>, 
	<dm-devel@lists.linux.dev>
From: "Fengnan Chang" <changfengnan@bytedance.com>
Message-Id: <20260513091349.2194-1-changfengnan@bytedance.com>

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

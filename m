Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B892BD597
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 20:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745353383; cv=none; b=tp6PLQW4Ia7pkwI8iW50g7oXeVogH83ymvljFTlW5pFguQ2K7dD9CW6Z3RDwPkrDDwTdMnwnUZMqBrLNLJO1vBNfV9RcS6rwIKifgD8kt5hlltOeUXmOoVdjzhVJbr+XXakBi3L0Mn5nv6SsDyfSVsryZguNsShwJxRgdGpGgcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745353383; c=relaxed/simple;
	bh=R5GvMHy88vZpZwGoYA87Dn2AqKvUw7DrVeI3nMJwYlc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sWoRvppebLMp/CEtOmR2HlEB1PI3+bh4OTG7SENbEaoMuqmMwzYn5R62jkbVKstf0PlnmfYvBlnkh4LcOsl1Ov/nXhCNjV2b6ZMmXKFt+7g4jSMo2alX/l3JdFcjDV1Hpi0ESwe0rPK/S2ElPNIzjZeYcInxWx8QuNuraa+IRLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXrerbNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXrerbNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2143AC4CEE9;
	Tue, 22 Apr 2025 20:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745353382;
	bh=R5GvMHy88vZpZwGoYA87Dn2AqKvUw7DrVeI3nMJwYlc=;
	h=From:To:Cc:Subject:Date:From;
	b=HXrerbNdUaKab9iD3jmgfPEvMvxlHek7pcPaY27eah8iAiccNfSXjNTl4121RUApM
	 uNxHIIYeB+FqBvCYTnz7Py/C/62QGn99NlVQqY/dQhN6sR7gR694t1o+E5aBwV2L8V
	 8UCIQnqI2tYwXWTe9ofBeYtDeTkvZzbRLWHSMVvExJF4ba73+y+MugwDRh9kRW77qg
	 TvlmnkEHDPwjokH4icj67HdPvGHgIyJHkpCwvMotklUgALzOih6pbzmd86GQKM09YF
	 FwXtwM5cP6W9n1+E7azDTq+MwEqm7ZhEUEeqlfEcw1nl3O+8txSDDouCk33pDAL+hA
	 5aElG5Hu9o5TA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: LongPing Wei <weilongping@oppo.com>,
	Eran Messeri <eranm@google.com>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH] dm-verity: use softirq context only when !need_resched()
Date: Tue, 22 Apr 2025 13:22:05 -0700
Message-ID: <20250422202205.100444-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Further limit verification in softirq (a.k.a. BH) context to cases where
rescheduling of the interrupted task is not pending.

This helps prevent the CPU from spending too long in softirq context.

Note that handle_softirqs() in kernel/softirq.c already stops running
softirqs in this same case.  However, that check is too coarse-grained,
since many I/O requests can be processed in a single BLOCK_SOFTIRQ.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 3c427f18a04b3..4de2c226ac9db 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -680,11 +680,12 @@ static void verity_bh_work(struct work_struct *w)
 }
 
 static inline bool verity_use_bh(unsigned int bytes, unsigned short ioprio)
 {
 	return ioprio <= IOPRIO_CLASS_IDLE &&
-		bytes <= READ_ONCE(dm_verity_use_bh_bytes[ioprio]);
+		bytes <= READ_ONCE(dm_verity_use_bh_bytes[ioprio]) &&
+		!need_resched();
 }
 
 static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;

base-commit: a33b5a08cbbdd7aadff95f40cbb45ab86841679e
-- 
2.49.0


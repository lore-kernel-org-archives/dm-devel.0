Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AC314AD3F
	for <dm-devel@lists.linux.dev>; Sat,  8 Mar 2025 15:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741449026; cv=none; b=Hfl4EmJcA4QqBu33jkEwofU1lkeR2yQOhF89vfkbTdhaGg0sjmRx4/BJr7E5AQ6mq2KRwrrGuHWaavyXASTtjCEmWlmvWjYBAreBvhzuKQ+LSZmTBdoPWKwBdpZ9Q7BPcXdBHq/QAAtm6hhQq8DeVrfIiCPrkUSdZRuk51eK+Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741449026; c=relaxed/simple;
	bh=7BO7p/o4mn2spR7wu/fFw/7CM5EaYKBQr9VvDbqtCvA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D/dOFDU3sruHKCk2YVyzM3Xgb1g5awv3fGKiFCisLZ2JwLhzIQJcb+99dOQ+Q31+yV8g8GqPiDdiHccH4x+jXOeooKkScivVh/caE6kFHpHJB66PPMLfGl9ScHihaKOq4vOvq8QNQ66LpLjtyyafH/sf13aqfCgvnQYa4v1aiM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fwpq0irL; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fwpq0irL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741449020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RDbg6uQaZ9lUNRxHNQWby3YZ+13Iwmip9kgaNhCvlqA=;
	b=Fwpq0irLuoY2/wNQKchxAiKtF4NYT3+w0qdIeLW4JYUgBDZtE75RVhWA54JZU2yXksNt0Q
	DyWdGgMtLI5bhTqRDiuaGGownVrYFkykRp3NNLTU30wohgYpTG5eOU/yL2amFsAsnBSJEM
	w4glOqnIu/a9VNp9uxRmBCY1DmF3Sxk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: 
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Alasdair Kergon <agk@redhat.com>
Subject: [PATCH] dm-flakey: Fix memory corruption
Date: Sat,  8 Mar 2025 10:50:08 -0500
Message-ID: <20250308155011.1742461-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

So, this code clearly isn't getting tested - at all. Besides this bug,
the parsing for the "corrupt" modes is also broken.

Guys, don't push broken crap, and figure out how to write some tests.

-- >8 --

Cc: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 drivers/md/dm-flakey.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 731467d4ed10..5ceb5d68f65c 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -426,7 +430,7 @@ static struct bio *clone_bio(struct dm_target *ti, struct flakey_c *fc, struct b
 	if (!clone)
 		return NULL;
 
-	bio_init(clone, fc->dev->bdev, bio->bi_inline_vecs, nr_iovecs, bio->bi_opf);
+	bio_init(clone, fc->dev->bdev, clone->bi_inline_vecs, nr_iovecs, bio->bi_opf);
 
 	clone->bi_iter.bi_sector = flakey_map_sector(ti, bio->bi_iter.bi_sector);
 	clone->bi_private = bio;
-- 
2.47.2


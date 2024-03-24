Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4701225A6;
	Sun, 24 Mar 2024 18:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711304378; cv=none; b=qVOgvdpmg7d05ChHF4s1ZeviUzE7YrfqvNB4qaTIvtt8YpcIo/zMBPUr9/pTsSxQuXRREtpTuIu63QJtjtIhuJyB3w07kpCNaimEoLDULM4ABhW+hjx3GxtOSEikHsqmCmMjnxnH6AO2sCxZRzmthNpjtV/FmQh16tcWGh7utCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711304378; c=relaxed/simple;
	bh=BhNL/Evr3WyN9wkTHYuELdqnzMJFpMrJEIlG5ceO/Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wq2kK3Rz7bDe6PKJZ28xBFA7sSGQcZJnkQwOwDZzytzugO0RUf5jqUHNI0WXcAxlgkTBwgQPdR/O93c8jgSoUkbGwZ8HLrikNCgag/+cK7gNnUFk72+sOEX4ObXWMr74sodbBcP89KtzXInS/zxy1/UTxPQ5fcsfP7sxNKuN2jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DL1nylpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DL1nylpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154F7C433C7;
	Sun, 24 Mar 2024 18:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711304378;
	bh=BhNL/Evr3WyN9wkTHYuELdqnzMJFpMrJEIlG5ceO/Jk=;
	h=From:To:Cc:Subject:Date:From;
	b=DL1nylpuCgfakAHYfK37ZpgS5YygUkP+8vnwJFaF1n0gdHGinUz+tMxfOpIs1Govh
	 4n+YLL2gNWdyvkDHYMFZC/0DT0ZwFhl1OxVy+ZLsdroY/EQKt1Q26q6mpNn1lefsab
	 qbXMV5x1T9kKmNNPK614xRBe/s6P52kvFAEsiUyenpLwgkcdopcryMi/Dz0R/Xuwkw
	 7g8/r5yANTsBTtpt410afrukVHxXWI0wQUfItC07+87+btGyUdLCMGSVjxJnU0Ra2C
	 tPGdOh+8V6kAfUIuJblHOXhY3xFPIVSWyYb882EOIbi3dON7N+6jdeojCfJDd2Ngzj
	 uCrfZ56Xj6gkA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-integrity: fix a memory leak when rechecking the data" has been added to the 6.7-stable tree
Date: Sun, 24 Mar 2024 14:19:37 -0400
Message-ID: <20240324181937.642861-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm-integrity: fix a memory leak when rechecking the data

to the 6.7-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-fix-a-memory-leak-when-rechecking-the-d.patch
and it can be found in the queue-6.7 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 22554ed2b958dd9fec6ba88da1a3f976d03373cf
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Mon Mar 18 18:35:06 2024 +0100

    dm-integrity: fix a memory leak when rechecking the data
    
    [ Upstream commit 55e565c42dce81a4e49c13262d5bc4eb4c2e588a ]
    
    Memory for the "checksums" pointer will leak if the data is rechecked
    after checksum failure (because the associated kfree won't happen due
    to 'goto skip_io').
    
    Fix this by freeing the checksums memory before recheck, and just use
    the "checksum_onstack" memory for storing checksum during recheck.
    
    Fixes: c88f5e553fe3 ("dm-integrity: recheck the integrity tag after a failure")
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index e8e8fc33d3440..cc834c8423bcf 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1848,12 +1848,12 @@ static void integrity_metadata(struct work_struct *w)
 			r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
 						checksums_ptr - checksums, dio->op == REQ_OP_READ ? TAG_CMP : TAG_WRITE);
 			if (unlikely(r)) {
+				if (likely(checksums != checksums_onstack))
+					kfree(checksums);
 				if (r > 0) {
-					integrity_recheck(dio, checksums);
+					integrity_recheck(dio, checksums_onstack);
 					goto skip_io;
 				}
-				if (likely(checksums != checksums_onstack))
-					kfree(checksums);
 				goto error;
 			}
 

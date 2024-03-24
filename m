Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B067E37157;
	Sun, 24 Mar 2024 18:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711304761; cv=none; b=rQ5jhhl4OjEOVUPHNDcrVF2JL6ptcs4RuFVyEaPsXtYN6kzz8Btgg/ivsBTMPTAhDwLYAqUEUTKAxZlESpDdoMLXET2mDIgPZb2lfAuD+Er/RKDcVJ5BgNcrMk8V3p2zWVKwroHfUhWr2zFRP+DfvFkzaLjBgktLh3pUW0FE5sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711304761; c=relaxed/simple;
	bh=HKik9tEpB3WfdWLz3RnFYPmIV4dxjVpM5WmBohiU82Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TINM7aZEYf02ETLzu/4h9GZEUfOnrAlLSQj9jVE7qjiDeBzECXNJf1ciwwILGeZuw4Q0FK5RUkNiT4SZZ9gdX2CelSE6KVL6gMdUgoQH4+KTAUphObiili6NUazdzccAjxNEPuA0iyCG6b6Z0aHcxCP0L/qe92ztMSEjRGMUaLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpdTMeWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpdTMeWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB365C433C7;
	Sun, 24 Mar 2024 18:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711304761;
	bh=HKik9tEpB3WfdWLz3RnFYPmIV4dxjVpM5WmBohiU82Y=;
	h=From:To:Cc:Subject:Date:From;
	b=JpdTMeWnbW2dHJsuO+wUHXvPwVHtEI5bMkEX7mXRHEgIvfuHn2SBVtTJDqwhQRd3F
	 tPylcI3cxA8apCgs0YPvPjYWPxfcNM2y5aPWvFZrQ3t2zOgX74VSwf6j1BBKdxX3LE
	 bRIeC5bwJFD7i4lg/oJnsORnepKvDHM22EuBujI6srv2uZqCf11lTwvxpSZHp83xV4
	 ZGtvpKiaVJedFj6b1+zJefsZcgmK6/deAGS+yNcvLTn4fH5B/jWbJslZK/yGCsLxu+
	 UeG2uOEan7KvtFSzcJAo6FSyUx+yodVyyHEJAqI8s82wes1f8tKal8jDncBaXfrM+r
	 bHZoCAonkBwMw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-integrity: fix a memory leak when rechecking the data" has been added to the 6.1-stable tree
Date: Sun, 24 Mar 2024 14:25:59 -0400
Message-ID: <20240324182600.649203-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-fix-a-memory-leak-when-rechecking-the-d.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 390bb24f2075034853b0fb0106539ef576031fc0
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
index 3da4359f51645..e1bf91faa462b 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1856,12 +1856,12 @@ static void integrity_metadata(struct work_struct *w)
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
 

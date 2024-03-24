Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562211B7E1;
	Sun, 24 Mar 2024 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711304137; cv=none; b=Fl2Ojrbv1h0m41x+/IPCID5UFeEPBH8KVasP2HHjiH0B4HGMpTt55w9OR3A49g6pedsFICwvAUQ+p+nvCcAfEfxARC3cBAzhI4JgDuReHQqHtBw6iD3GZBI5+fg+qr13bWRmqs0M4BIFhxnw3bycFLTObyrpn2Q49B/sCy3c4U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711304137; c=relaxed/simple;
	bh=lCSxFNQbLcQ+w1CyKtkUreaXHA/eP+lrSHY73AFWUT8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KoawgYhCmsMg+xUf1ErTO9OTAuPNw21finFSTDEXbksiIjs1f4hn9+4kHF/CcjsLUXgNCaPd8EZiC6DOrbjJ+30169J4YduQUh2weIUG7qxasGo4vIQr1RSwp/AOV/9Jbwa4S4waPLs5nA+Aa61GeSowAHvOjzfHTAdKOaBFrsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0yB3p3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0yB3p3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92656C433F1;
	Sun, 24 Mar 2024 18:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711304137;
	bh=lCSxFNQbLcQ+w1CyKtkUreaXHA/eP+lrSHY73AFWUT8=;
	h=From:To:Cc:Subject:Date:From;
	b=X0yB3p3PGcL9Dpo1rneD8c6XM9nwUsLnYDfEQNME9UenBp3OfktaXzsURZsqzHjqA
	 n3fm4Fz44UnlHc26be29IwTx9Rvv19UyG77DVZslaN3loPEpJZ1E+N2Ec8opHrQyMT
	 tCTMwnQY3vgLfQPan5x3/Q3jkdFffyY3EsSKl0SZ/bpXxXhN6M/I560NnupaN9mYo5
	 76mbm431XOl/V0g64jQw8ewCEfmeavINvg/CTwKv82HODzzvMGt26Z2gAIAdgK6DW/
	 gkHeczFB1VyrzFRF6qjCg0w6Twi+/q1u3vL8qwgNsGxKdHE/zZjluV1l3SXz4MDVOi
	 WoUyXxXIORrlA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-integrity: fix a memory leak when rechecking the data" has been added to the 6.8-stable tree
Date: Sun, 24 Mar 2024 14:15:35 -0400
Message-ID: <20240324181535.638706-1-sashal@kernel.org>
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

to the 6.8-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-fix-a-memory-leak-when-rechecking-the-d.patch
and it can be found in the queue-6.8 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit ef98187329030eae6af5d8d20a8375d6c0a45877
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
index 1fc901df84eb1..f194ce6bfacb5 100644
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
 

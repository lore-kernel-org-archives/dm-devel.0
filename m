Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2CE1A5BA;
	Sun, 24 Mar 2024 18:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711304598; cv=none; b=iEFPKBX4l2L4GjuVtQCeOVhEf4nPFbFV3/A1dUtRqaunqGQXjj+mC7a/AfZRc7dLAPIkuoNBACq4YcnBEz0rPXSXfTnCZfyvsBc4D5i18x6mkBsVOG0obby76Wzhqf/7PX3dNeIdBAec39H4pXzqU2/ErmZdF3HdQtNqIG88e0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711304598; c=relaxed/simple;
	bh=WDYNd+SOrBKI9Q660u4eJJOL0hJ9+31kNTQjErOYrFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kc2BmAqgE0Tu2jIW5nwgRsxjgZfMT/fdzs1zdWq5grM7EaDJqyZln2WwN4ljIMXO/jXzOB37tjWj+S6We0wdGhvLElpY0kyqkFOxd2E1Eu9K7/5DcwE6zFJ2vKEponj83nHWrCufm7JOs8B4ta72vAAsIaRX61oPiXZSaz9Uv/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFdH5kpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFdH5kpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8580C433F1;
	Sun, 24 Mar 2024 18:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711304598;
	bh=WDYNd+SOrBKI9Q660u4eJJOL0hJ9+31kNTQjErOYrFo=;
	h=From:To:Cc:Subject:Date:From;
	b=mFdH5kpHpPpYhSL8WSdSjnuwTSF/uwoMH1UbLrHTavJRG9EE/NwpPJDVBAL65Nzer
	 InG/5p27NVdlHZaUGzH5xg8DYxSxoDysqeG9sUOu+/BbuvgHgDOuI5l1PTvb3T3m6Q
	 zB/ta/w41Lo/Lry8/65EG7kAKKB/F60N8i9OcCDKCLzRr9bvfDh+2/QBProkQOkmsw
	 F1p7avpyCAC2RniNn464yL0Ln6JA+5RaDFntCpziRQN3urwnCNef+6VBUK8UfxUH0q
	 yn0HVp1dKoXjDkgb8mIpPtLWVVVGELouMg/3+IDBWhq7ZM+5ckMq4KEmUcBCj4IfMU
	 pVMZ8JnWHo2HA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-integrity: fix a memory leak when rechecking the data" has been added to the 6.6-stable tree
Date: Sun, 24 Mar 2024 14:23:16 -0400
Message-ID: <20240324182317.646522-1-sashal@kernel.org>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-fix-a-memory-leak-when-rechecking-the-d.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 27a812f3acc7863f8853ed32e2fcaa3e10add66e
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
index 68923c36b6d4c..e2b57699efd74 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1858,12 +1858,12 @@ static void integrity_metadata(struct work_struct *w)
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
 

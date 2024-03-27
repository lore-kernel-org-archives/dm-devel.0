Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F366C52F7C;
	Wed, 27 Mar 2024 11:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711539416; cv=none; b=lEzzkkm4nXRIPTBB6ICFUquFiuiWjYi4agALtMLwe4QuW6mFijMcZWIWp79T2vmhIw7tgf41iT5tfYTCPI7+9vTre3Xcc8UFSzpgl/bbvvbGxyEpZud0z3kwRhzv0hNh29cox1eHPCNjp2hmqEk6LPm7V3/pgaz7m+OknZljzy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711539416; c=relaxed/simple;
	bh=/cE9CHXsHYM3CsU9SHhBrZ4kJmgeNcpHdWflRrDk84Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C448k9LHxXxkRITrAtzev7Ewtq5S1Go3J1tVejCzEQDVXIDdjopt3ulHernPkDrWft2O5cy5DL+mDjC5d2MxW3uZpV9IgbWII9/W3noA/V/cIe8PYS4zB06n6PhvyyXN3tSq0qs9xmuB9vmmWxffq/HYu48xFYUUO8X0ozqcBg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAEOWQ3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAEOWQ3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327BEC433C7;
	Wed, 27 Mar 2024 11:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711539415;
	bh=/cE9CHXsHYM3CsU9SHhBrZ4kJmgeNcpHdWflRrDk84Y=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=OAEOWQ3r/uJpLQfpzb4O9ezjOLquEdilxixghDXK5mF4LxrD4JaPZhyF6Q/R7+cNv
	 tDKnPORMA2gCcyUxl/tCMD3SoBcG3urTYC7RbhyHKKAlWubZy1Uhl95bA3DiXEUrDv
	 Iei8ZJHUlUkePnyRDW/NXkkTXaNfShieG/RMcaTR0LRzyJQ/0ocUXgFkgE19AWgWBb
	 Q3VnvvfFVFkIslcxAOcsFAIxx2raaPoN9iA8H0OrjIKFIRWWPxG3wBUdgppRIp9T76
	 CVjHJvh1WkA/Nr3X31BCBu8HjlrhC/zXo7acq+n/RTjDMsEe7g1a6P2b0uCkXyd2cG
	 19ZekJUkauXmQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm snapshot: fix lockup in dm_exception_table_exit" has been added to the 6.6-stable tree
Date: Wed, 27 Mar 2024 07:36:54 -0400
Message-ID: <20240327113654.2801154-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Reply-To: stable@vger.kernel.org
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm snapshot: fix lockup in dm_exception_table_exit

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-snapshot-fix-lockup-in-dm_exception_table_exit.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 466c692aeb78906f44b998250c9e39b3961311f5
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Wed Mar 20 18:43:11 2024 +0100

    dm snapshot: fix lockup in dm_exception_table_exit
    
    [ Upstream commit 6e7132ed3c07bd8a6ce3db4bb307ef2852b322dc ]
    
    There was reported lockup when we exit a snapshot with many exceptions.
    Fix this by adding "cond_resched" to the loop that frees the exceptions.
    
    Reported-by: John Pittman <jpittman@redhat.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index bf7a574499a34..0ace06d1bee38 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -684,8 +684,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	kvfree(et->table);

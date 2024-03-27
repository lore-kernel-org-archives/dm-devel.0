Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76F512BE92;
	Wed, 27 Mar 2024 11:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711540325; cv=none; b=g28PT2GE6tP58JmG547EC+G5kJ6qsCQbLUBTM8Tf/9KxkGUQZTPWDeGg8ABAxxDDuZPSJ3SlT3qile2bqg4xtVjJ2WX4VcCh4vL5Dh2Xrcru8ZItzxqmDGOWmybt3HmDunOMne5raRB0u0Zpmgu6RSuzlvLbkeoxp75CImSFmY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711540325; c=relaxed/simple;
	bh=ZT3eAxHk5sFrbGFvW4ZI89xArKMjxvkH3NgXK+CPxpU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jiO1g/YEFDKLc6G0EJz7UZEgg7YgpRqJLFqKfJGt/Tcys7M0c03rwA7+Lq5HmKVpKTJD9oM823bCW/Ogl8Tc1cngDdmoyPGkqkalGPnhZdtVZ/dGkmt48BWILrm1XydKqggDYOtGujCn4/0kyH//yRCHLntqac9ERqtTbjp973I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g1uT0fOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g1uT0fOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B719BC433F1;
	Wed, 27 Mar 2024 11:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711540325;
	bh=ZT3eAxHk5sFrbGFvW4ZI89xArKMjxvkH3NgXK+CPxpU=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=g1uT0fOFDAN8mmCht2fYCljlCftgXm6kn2ECcppmML01zEV5WAHLuf413KnUGta3t
	 7/bGMXg12gWNq5yNJfn5NQMNaAFDgRnPXB44APfc+3eA0FK7nIzQC0xnq7sWkLF6NW
	 Z6/rk3rGO/oi0RwFywoGN8SYjZf7L+MVh07sIWLz12kVz3JuMjwslXPov+O3OM7jPd
	 aHxmS0lflZspKJrlk/s3FAw1K1jVzN/ak4GNfK1GqTp3ba3YMF5g0IH2UNL5Deab5z
	 CsgkSABRSkCeFSuy7B2xeIMHQlBESJYXHgTQ9pP4IehE1tbp4Fx4+5rDsdPoMRgdXr
	 8ArwtER+jp2Qg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm snapshot: fix lockup in dm_exception_table_exit" has been added to the 5.10-stable tree
Date: Wed, 27 Mar 2024 07:52:03 -0400
Message-ID: <20240327115203.2817244-1-sashal@kernel.org>
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

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-snapshot-fix-lockup-in-dm_exception_table_exit.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit d34dc105da100e9ea5d00a6b7a2f6d4cd1302f9a
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
index 41735a25d50aa..de73fe79640fd 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -685,8 +685,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	vfree(et->table);

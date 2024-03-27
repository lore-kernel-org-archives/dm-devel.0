Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51375811A;
	Wed, 27 Mar 2024 11:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538311; cv=none; b=t/qsc/l+zB7ACohGfbGNqK2+y5/puVbLluAVt/u3tacNYycMzKxNP3MP9fxtNsZPXWo1sbIrwsbRn4ay989YvUacpE9ddUtPQRQjLhAjVCXLQDH8KjgH/d0ugF9hiciCaj2bqmUa9nx7mqyQ5xy0Pq5BnKwNyTnC/094jAS5ZMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538311; c=relaxed/simple;
	bh=E640g8JsHZoCTjm6vYs59+gHKIvlf9AJ1n0wfpC3jnM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eRxtUX1N38x6wvKNi1NHySc4a/e4Ll+0miegcDE6Hdz8rzWJc2DbZxqoh/SBPTlwxmcbJy1hjizqbYb4zKKerpeywEIdpb08PFnaQIJsjLL5X4urmghvv4lJESK9GlhF/DA+Al/JH0kB4cPmbliqQS9eivNemsK0+zgsPSF4IgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+n7ZzvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+n7ZzvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C7DC433F1;
	Wed, 27 Mar 2024 11:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711538311;
	bh=E640g8JsHZoCTjm6vYs59+gHKIvlf9AJ1n0wfpC3jnM=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=A+n7ZzvXhr2A9XBqm2/xLBloLFHAEdmwvdQ0gTb3S1sEbZTN1krKgXFNNXsGHOTxU
	 utu/mXZ0q4cczuh0Pbp0+l20nyA6NJOmFtUeXWvWiif4u692Ddi1vjl9qCk0HbnTPJ
	 LlkQTqkUKyx18DhZTS4Cex34G2Ll/zYBG/4Ow/yCJCWXPVKNag6HxRQTPRDj1zDpTP
	 ArAdNolMjHi5k+MIRULkMgymOk52k5T96zF8xjx1W/G25lUDzh6RyQ/pDnhbXXIS/Z
	 xDKKfzd22kWdgiHeC7Sx5GXW2pcWH0MNTx33oHdzGaM/OnJ/a6EWw6y1mekNt5XVDC
	 bpUzPexoMtTsA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm snapshot: fix lockup in dm_exception_table_exit" has been added to the 6.8-stable tree
Date: Wed, 27 Mar 2024 07:18:29 -0400
Message-ID: <20240327111830.2765047-1-sashal@kernel.org>
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

to the 6.8-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-snapshot-fix-lockup-in-dm_exception_table_exit.patch
and it can be found in the queue-6.8 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a21c460bd74304aff94ac8ea5c11d7744e7af33d
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

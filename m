Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7699A12CDBF;
	Wed, 27 Mar 2024 11:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711540533; cv=none; b=suwbUEQWBrqs7tntAJ7zXPECw5yOjf03Swpx50r8D+zoeQhAgoxbKxbSTnUg4SYo/hKRnWtq8CEeku4NnNfi9LuMKnHGPEDmGsePAdeMdoFkPgK+3nVEWUdtvLOaEmllPrxCauwl5KqD4mhL3kLIovJRrBSQ11xD2HkUa9y7/b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711540533; c=relaxed/simple;
	bh=6M7i1Ulhe3iCcU0liBXkPvStBWoENbXunis3hw3IcFI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U5TIP5n3TEYpqBGu5VBWpQPnSMgEruYRqk+qc6lt0D1AQlDn9VjUzPR6fOgOjuP+1nuWpK0XU70/b2w9it9wS+zkF0xIH2SPI0g1vHgjHIcGby145lbb5m7/Lp1tSoXKquMnERRkpiS7G+hZeU57Igom5iKQNBEvmyxLzOjH4ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8ay/nDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8ay/nDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29F2C433C7;
	Wed, 27 Mar 2024 11:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711540533;
	bh=6M7i1Ulhe3iCcU0liBXkPvStBWoENbXunis3hw3IcFI=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=J8ay/nDlCnfqNrAeEoAPl8IWsjk3NUHIcBu6a5Z3y53sOyU9osRSfiS0s33UFgSQ3
	 FW31VrM8Rp8RcWfWWIw2Q/gLi46OEhVqnq1OtIDpiiB1rF9n2XWP6y/oiJbrgGwDLs
	 UM320wktSz+OOg63kypIanHEx/78Q2T6oudKtVl1bbPv/FsNYUDAsB9uFE4TIwyCwd
	 +RH2PZAe2q3/2Ur8LvV7i52c/9YYwnZY92ZPRYKQihpamprQC3Drg/RPoLp/rsFe3+
	 1GXTTxmHE6s5dA0SQVpRPsryPc2KgIr58DerpMeP/+pj2iRjPghSBfyV0Db/WkLZlg
	 cfvH0axk3+8iw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm snapshot: fix lockup in dm_exception_table_exit" has been added to the 5.4-stable tree
Date: Wed, 27 Mar 2024 07:55:31 -0400
Message-ID: <20240327115531.2820933-1-sashal@kernel.org>
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

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-snapshot-fix-lockup-in-dm_exception_table_exit.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 101f87a83c2afb4bffda0905079ba6250f134db7
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
index e902aae685af9..d8902d2b6aa66 100644
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

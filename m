Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A091292C5;
	Wed, 27 Mar 2024 11:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711540052; cv=none; b=HS74TrtN564KLdwlQEo1Y3PBYgDEf5fb6kRVyDgylTwACn0xvadgrYvMM+WM7Zp+2h2RuEioMax9xU0EjmEl+lyc5wHWhkmnZMVNJ5/5Nmuxlvb9IjMyHCmWOIRKa4R1GTOoNCkHcHPZT7WF7rAX1d4GO6jZNaOZfvyeGcmnEgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711540052; c=relaxed/simple;
	bh=Gze+EbGc66t7lxowS7odiAbvJ+bn6OBawNjgu5YQBEM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h5wMyqgQdrr8YbmLosx5CMd1i+EI7k+zYX/R8bmEdilsyTUYns+itMRAATFPoTbYFAYSStILj0G6vX+sIstGjgyVb4P/WuzmSXHB/PRbmMXmMI8qr4EzRNt8TlAB22K1YRXNWTSbTJllWiNlgrEzIpEidKY0KjorA2EPPwdeBEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eOdoiZt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eOdoiZt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D1FC433C7;
	Wed, 27 Mar 2024 11:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711540051;
	bh=Gze+EbGc66t7lxowS7odiAbvJ+bn6OBawNjgu5YQBEM=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=eOdoiZt/cdS7L7e1g3Ria7QPzv0R+lqpIlSBcin5zQRdxipn1aleDCyF8IEHn+gUq
	 Tc1Xh6cciFNt6qzHlgStRSZ3RhGDYt30e9bzr8SJ7r4jx17U9NEYE2VM5XOJcQbfT1
	 UCS9Ghp0TrmHPv0aRNmcVqg+sh0Rk6kFzUzIGXrdcbEEE3IaTOsuSZWXVEwGWNnh2O
	 2cvL/B/bvv4WN8dyoEXEOjaISrYspUcuQOx1pxOv8TUao2w6o+XxDHVOAayQiCXxYc
	 QrbzJ3/JLWvJCV4OUEyzSmDu3Sj2pLncD2UhjwVj8gIpbJ+KlyknZCdmPG5nbXk4zt
	 BB6EZjMi5aV0A==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm snapshot: fix lockup in dm_exception_table_exit" has been added to the 5.15-stable tree
Date: Wed, 27 Mar 2024 07:47:29 -0400
Message-ID: <20240327114730.2812350-1-sashal@kernel.org>
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

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-snapshot-fix-lockup-in-dm_exception_table_exit.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 14aa8a42525701537143ad8402d1ac655ce01559
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
index dcf34c6b05ad3..d3716d5c45c23 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -686,8 +686,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	kvfree(et->table);

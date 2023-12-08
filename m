Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE96125D3
	for <dm-devel@lists.linux.dev>; Fri,  8 Dec 2023 10:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4qpkddb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D099C433C7;
	Fri,  8 Dec 2023 10:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702029976;
	bh=j63Rn1Xs/cHUVcxaMmeOev/MtpgEjAnETLUjLKFcyq4=;
	h=From:To:Cc:Subject:Date:From;
	b=X4qpkddbCdUmbL9uoudDfqnfXVxYVpYy505XNLpDtpVF1BVgs39VmoN1BSBDHtYfL
	 nl2JjF/BGyWtSRf4GTW/yzsFfNVVFhstDAd8++N3RKW7kg3y2lWZcECQeh2rG+I2LL
	 aRhY9lhzU7E0YsFyzjnvryj18+5Csx5UmMrW5aaLiKPZfr5SdjuQda+tjxSnSNwbPU
	 ctnfXs80MVmXZrX0BJtndkZj76P5CXmpIOj2U8G+UcthPwau8UY46ohKI8YQy7iEdP
	 ygYfQV/pCzF5yeOcTaCCAXObEoBJXP3tR26GCNCf85WErExVIOl+FzdaeukXTG6u32
	 BvlkB6zBimb0Q==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-crypt: start allocating with MAX_ORDER" has been added to the 6.6-stable tree
Date: Fri,  8 Dec 2023 05:06:13 -0500
Message-ID: <20231208100613.2845631-1-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
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

    dm-crypt: start allocating with MAX_ORDER

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-crypt-start-allocating-with-max_order.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 622358e7f48feee3351300a2af4163f1258fcc7b
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Fri Nov 17 18:38:33 2023 +0100

    dm-crypt: start allocating with MAX_ORDER
    
    [ Upstream commit 13648e04a9b831b3dfa5cf3887dfa6cf8fe5fe69 ]
    
    Commit 23baf831a32c ("mm, treewide: redefine MAX_ORDER sanely")
    changed the meaning of MAX_ORDER from exclusive to inclusive. So, we
    can allocate compound pages with up to 1 << MAX_ORDER pages.
    
    Reflect this change in dm-crypt and start trying to allocate compound
    pages with MAX_ORDER.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index cef9353370b20..17ffbf7fbe73e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1679,7 +1679,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
 	unsigned int remaining_size;
-	unsigned int order = MAX_ORDER - 1;
+	unsigned int order = MAX_ORDER;
 
 retry:
 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))

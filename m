Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFA315574E;
	Sat, 26 Apr 2025 06:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745648232; cv=none; b=fGCEXg5WzJpq/BkLw17xsIQB8fUMZIHL7pz+Ep50//+dt1ENlgiEzmpzUaqcO0qMMHRlTU8izHAMSHTT9mA13h6Rct7XpD+ZdcfLZudEqLPokNnsGTMGATtOcclbl33iO/ccfifZ91ULz/kQt01NxZVIrZ3850PxXTNrtYiquFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745648232; c=relaxed/simple;
	bh=lf1p2wcjty98b/+pjp31SMXZYts/q1FsF2v7W/qdTSA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NjDYqIFb6b9ZI10JOKM4ESpXNG/65s8Jat/d4eRBbkQvkjNR6J6Nfh6yQtxnwChhTD0XcHuuZClX6e7m+ONvGIx6KnyDsKKDVkH89ktvPaSh78qBSskt/2Ih9OMcyGXZPy3B+U3B/1dBD0xrHJmEp/JLeF1DN17OO/V+XQt8ulM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CtSvd5ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtSvd5ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8786C4CEE2;
	Sat, 26 Apr 2025 06:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745648231;
	bh=lf1p2wcjty98b/+pjp31SMXZYts/q1FsF2v7W/qdTSA=;
	h=From:To:Cc:Subject:Date:From;
	b=CtSvd5ecyCJ3ls9gLBT0OTIh9dqeDzP25tlI5NMqW/I7bLsa/PPm07emcw0Oj/rKh
	 zOSy+lmfboqgcB/xE2GFawHKrj2RnzwnTFBcpmlqVshWsv8nDVt4TPMjwPaN5uyfz6
	 ane1J0Rs2uVUF6U+TIAJMf+Kt9NZ92g6fjKsGgSlYoB+gtfr/kBM0vMTxjsZszCrqr
	 2J0YNRPGJBsKUP633X/0nlymgnHec6p9DmN6aHtkvVwyRQo9OYRi/lG9vZZc1PlP9N
	 JAwvGyij82BOy7khNNJPRpNgy/Z9JDLZjPB2etQ8S0MkFj2nrmG49y4/1GBrkLI1YV
	 b72TvdSkbNQ7Q==
From: Kees Cook <kees@kernel.org>
To: Alasdair Kergon <agk@redhat.com>
Cc: Kees Cook <kees@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] dm: dm-zoned: Adjust dmz_load_mapping() allocation type
Date: Fri, 25 Apr 2025 23:17:08 -0700
Message-Id: <20250426061707.work.587-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1351; i=kees@kernel.org; h=from:subject:message-id; bh=lf1p2wcjty98b/+pjp31SMXZYts/q1FsF2v7W/qdTSA=; b=owGbwMvMwCVmps19z/KJym7G02pJDBk8Vcl7u7mK+Q50X82f9jLm5AmW47o9/26fWByUnnxsB svRGz7TOkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACbydTLD/8DZWkFH718PzInb 2/Ans3/acT/2rokbN0ctndzlrtF24AQjwx+j5dyqvhyn/014rDspJXEB2y6f4C8/bbNcY3hW35B IYwMA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for making the kmalloc family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct dmz_mblock **" but the returned type will
be "struct dmz_mblk **". These are the same allocation size (pointer
size), but the types do not match. Adjust the allocation type to match
the assignment.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: <dm-devel@lists.linux.dev>
---
 drivers/md/dm-zoned-metadata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index deff22ecccbb..8934ad20012c 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1687,7 +1687,7 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 
 	/* Metadata block array for the chunk mapping table */
 	zmd->map_mblk = kcalloc(zmd->nr_map_blocks,
-				sizeof(struct dmz_mblk *), GFP_KERNEL);
+				sizeof(*zmd->map_mblk), GFP_KERNEL);
 	if (!zmd->map_mblk)
 		return -ENOMEM;
 
-- 
2.34.1


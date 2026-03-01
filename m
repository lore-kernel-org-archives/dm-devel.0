Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316872D837E;
	Sun,  1 Mar 2026 01:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329741; cv=none; b=QJ9hlzXoTFyAhD3/7hH51cViqXP3Qy2id4ditDJVLQ+yZP6lpTaR3reSA967+1x2jmuLCFHSSa/lt4dxXqQxmyhJ/2E2MD75iBmMb7vL/FKhC85Soh444jeRBOQo9rvA3octzADRjSmn0GAZjzN394bxNHqLk06ABhx3O2BpY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329741; c=relaxed/simple;
	bh=1v5VOec4mPL2m0hJuGIj42Rm/Fdy7QBXm4L3bn/wd/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u3KT9vn/0RPK6Ysk3NSk0cXrfsPr+1xqEugGCB/AMi93KMmYwpZA6rMqb2Cel+Nr+M0nw3RCw5s8zHAdaPl2YwHaUpO8vD/ZpWb2getnQ/PLskoDaRstZoR4Xv3aUMNyQNdlSgfdJ9HVkKoly3YnS1/Ne0irlpRNJqffbQ8afmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NqATBNtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NqATBNtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE7DC19424;
	Sun,  1 Mar 2026 01:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329741;
	bh=1v5VOec4mPL2m0hJuGIj42Rm/Fdy7QBXm4L3bn/wd/0=;
	h=From:To:Cc:Subject:Date:From;
	b=NqATBNtvuX+4tz0pQCuupduPpnkoK7VmbBbBoIJxxJ4jD2omeB8mqLsJAtth8oR5Y
	 ekkjbK7ZfA9NfXWjd6KFid1jUHr50L736iSJL5otw7lJ1JPWP0yKToAxKQQsHvAY1c
	 5oAjLPmEUYFP3CQ1SVKDyw7IH/je9/8AA74gOCbvpL+tO2es1Kcd95sCuseMKj+PvG
	 uTTQr+w9vRIZRg2zGFw2rqgXy3/nDNAy7y91xr8Y+s5VcDer/v1UpGrLaofLpuDFjV
	 XIZ5th7Dfnex1Xh+eZOVCm/GV/T7Byv36ow9i0ajDFRAGU0CYjl+eT85NqSth/RSoE
	 PeqOWcMBDyMeA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	ebiggers@kernel.org
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm-verity: correctly handle dm_bufio_client_create() failure" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:48:59 -0500
Message-ID: <20260301014859.1713290-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 119f4f04186fa4f33ee6bd39af145cdaff1ff17f Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@kernel.org>
Date: Fri, 19 Dec 2025 11:29:08 -0800
Subject: [PATCH] dm-verity: correctly handle dm_bufio_client_create() failure

If either of the calls to dm_bufio_client_create() in verity_fec_ctr()
fails, then dm_bufio_client_destroy() is later called with an ERR_PTR()
argument.  That causes a crash.  Fix this.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-verity-fec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index ef9970b889aaf..7583607a8aa62 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -501,9 +501,9 @@ void verity_fec_dtr(struct dm_verity *v)
 	mempool_exit(&f->output_pool);
 	kmem_cache_destroy(f->cache);
 
-	if (f->data_bufio)
+	if (!IS_ERR_OR_NULL(f->data_bufio))
 		dm_bufio_client_destroy(f->data_bufio);
-	if (f->bufio)
+	if (!IS_ERR_OR_NULL(f->bufio))
 		dm_bufio_client_destroy(f->bufio);
 
 	if (f->dev)
-- 
2.51.0





Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EC2257849;
	Sun,  1 Mar 2026 01:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772327957; cv=none; b=kTWJuaDNy5SFPSt4O5SvstrSrzP2CfKRV/2i4DfHAZ/G9m1ZuRypN4/YO+GNIikUWEEaBdhZAAM0QPnBPPvTounGXmdKteBuWgPJ81BVWQiAPtyHdyBWmcC301lLccTfUbXoKMByr+ImQ5h9GaN8gv0L3GtV/CvMpxwDFuHvJeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772327957; c=relaxed/simple;
	bh=vg2wYXpIJqGd8g0WmYcYCUB3RP4fbeALeEXbSIbweNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FNoLOivAXGXZJ+t1ziEw4jyzcrczKm3ppvrGtrqg51mkJj51uGiB06VJzPDez91JNwEAHe+V0ZC8HOtnj5jdyQLrRiFVyoOVIU5gElMBgL1vwXC+AAoEyq3HQv2eikRnWgT6lPiuGblHcvYGidW4q0wF6Zy9NkqL7F5lqodGSGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iS5sooO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iS5sooO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9680C19421;
	Sun,  1 Mar 2026 01:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772327957;
	bh=vg2wYXpIJqGd8g0WmYcYCUB3RP4fbeALeEXbSIbweNc=;
	h=From:To:Cc:Subject:Date:From;
	b=iS5sooO0PbdPpbRKnnjAnH4CgPiw0/7vdweuwhXLSmCQQVy7jB2Sn9LboJk9slS2/
	 NXgUUlIciTkb44Gjc1qBOF3je3Wy53oxZok5ldcm1+w9m0k2OHVOb2VZEG5wV4CWKp
	 AFnvT+39xTK9Qi6EB9hy5IECpiaL+r3hB4hYP2WXxRDjlycPephomYvlBQ6C+d0dl+
	 +xGK/qmygn4oHqHBDk4p3jEDTwnbIxRcQA4Iku33OInLSSLpgLCyrHqQ+3hU657MM5
	 l1EFY3pp/o5JdQxLS+Ly+Nwm4EzVJSWJ3Ot3MyE3ypAgnZjNqoZ9UxKwGDfqFEA64B
	 PGuOohIp4aOPw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	ebiggers@kernel.org
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm-verity: correctly handle dm_bufio_client_create() failure" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:19:15 -0500
Message-ID: <20260301011915.1674187-1-sashal@kernel.org>
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

The patch below does not apply to the 6.12-stable tree.
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





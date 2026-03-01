Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CD42C21F7;
	Sun,  1 Mar 2026 01:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330365; cv=none; b=UFAuAPX4O764QCa/CVsvVugrd9wIxk+FhhmFvUxB4XUelKBv6Ro5i0eOaFV2pRwBg/LlUzw5F0Dth46sfI/librRD9ZqkJG9faUNHOa8mcn7M/Zi77nRFHyoigJ++MqdCrBnCIeAxajsuiku+2tyliKZnP2Q12iWBfftt8Rdmfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330365; c=relaxed/simple;
	bh=Rlx/jhaQlgXxz7H0S5U8zpCFInBncDIG37HQ+fcT/o8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pqJFTBfGAGUQowxaECDuhrhL+COFS3S7cyY9sZw3WoYihOk5Ligmcl7XOB7iqlSvdo3zGao4IClyJgoz8qlA4/k7L+pnICM+XVxkZFA2912bb5tAQIfFCWhK9i4tihLOGwN3idrJtqUaPXPxul3rgsPrlUbPrbb2vG4+dIr6uxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u89/eStC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u89/eStC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E345EC2BC86;
	Sun,  1 Mar 2026 01:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330365;
	bh=Rlx/jhaQlgXxz7H0S5U8zpCFInBncDIG37HQ+fcT/o8=;
	h=From:To:Cc:Subject:Date:From;
	b=u89/eStC8OLwJU8tEk6VY0ScvVMkjwVoh8CpynRB+k6uxf1zKJMsPiQollfv7T9ee
	 Qnnfoqq70Nz7pq1WMtM4DBsmjLqQvQ9VqsM03NWzWBFb1ID9ijdWBuZfz2F4PD2UN1
	 nezN+uTtjhx1OWMkkKgUmVGIHc9hAXP4RVdIP+d69DDuiv/lhToEaJ8uSONoLaj8Ey
	 p6E2GtMGZ3XhVs2cPgW5XSipMyrMQFtviu32cMRSmcRSQBqQWvp2vlBTG7tZYKDWTL
	 wzm+0hJNgGyIpiL6ohfas4lmnPv8X3aOz+8smM6q7aLiXkrSbAzBZaUokTZ01sBFQP
	 MrVrXj0eSWBwA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	ebiggers@kernel.org
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm-verity: correctly handle dm_bufio_client_create() failure" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 20:59:23 -0500
Message-ID: <20260301015923.1725096-1-sashal@kernel.org>
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

The patch below does not apply to the 5.10-stable tree.
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





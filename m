Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D8A26ED35;
	Sun,  1 Mar 2026 01:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328650; cv=none; b=NYlI6aApbQ3hjcNuhpWLhKgXICN+iORC+PZXvyeW4vAy12gx7e6Vu2uAOaIvpRZP0BxbcjHteQgjaNkLdQdX+m4pXztZ0VekJNhB5SUhxWUMm5Q4f7Xv41OM8cyDCL3bkcFInR+aJ3bmOM2pkyE5OUDwU+Mg+DvglkBLzZpl71I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328650; c=relaxed/simple;
	bh=iRUdbxNevkhhq1dCpOKT7fxBZsEI2yWj6hHi2ZxP5Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n+paL6o4B5GrwhJtJ1eJ9GR2sy7IT6LZ4GguzwPDPVDoiXGHFKwgV4Revr3wa37AEAaz7+bzbZeaGGjyRrt1WC9pcpAf7nwgXWVRyiS9IRF5qmft+3NUuzZNU/oHJht3qpYDkf9hGCk8JZ6TublHe0L8q1mCGCNyGiVXUkMMPSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJBVePR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJBVePR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD79C19424;
	Sun,  1 Mar 2026 01:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328650;
	bh=iRUdbxNevkhhq1dCpOKT7fxBZsEI2yWj6hHi2ZxP5Pw=;
	h=From:To:Cc:Subject:Date:From;
	b=QJBVePR+Z371fBp8NbEfzTzk2w1d3Q35xEAueHq7kBcZWPl+f0NtTmf6hYQpc6T8o
	 +BWudRKJ88uT5Ix5nH3Fn1dVHQ90MDKExy2aahF1Hz/eltfHUsxK5S/+XT/2OAEOdG
	 aPfIn5XqHZORO5EFx3BUddKl+lr+u+ZUF9Z4sq+3gimujutZSG+sD6sAtq4/x3Q95i
	 Geb1O7p1K/fQ2xqJyLQIUupDv/A0SrJuBHrdwHcPaURPaBxesy8LSFqakGHmqHVvV9
	 uXLyoH5/Br7TmfwoB1GkqEAhAht8bmmDALSGq1Am88kLMWefSDlDr/XI3z3yVS7IYH
	 qBN8hee2RA8bw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	ebiggers@kernel.org
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm-verity: correctly handle dm_bufio_client_create() failure" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:30:48 -0500
Message-ID: <20260301013048.1689105-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
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





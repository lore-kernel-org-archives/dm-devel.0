Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CCAC8F0;
	Sun,  1 Mar 2026 01:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328263; cv=none; b=K3EA65KuDfuKWEVoCCuFe26FU344+YPkEgtbxp+bqj0c/e3H//heylo/KYw6lSbydjGh9cX/HRYom50uYmY/HhGoc3FMdqInmfQTQEU95zOBAiBC24vzrQfcHdID+TscWcpJoc1T+2vdjpXT+ahWACYzTr3/bzULlrZNkZYGVcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328263; c=relaxed/simple;
	bh=ipazECDcqer34PkhZzEYOQwthLWQmfOseCJHjGmGwf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s9gfZe4PxAABRv9iE0PhNNlIz6OsbfWvHv85ClQNJfu9dXes9DGEME3QKL1v/PI4XoNcuQhW0C+vaTQKtv/TczYfvwQtv4QHTU5mtACsafvvIBpCQRsUFd4+4VHifkfXk7Sv3N0lZJkgCyq7SHBpifVDiMRbTnrBPe5uHUpGB24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=husj1rxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="husj1rxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7E5C19421;
	Sun,  1 Mar 2026 01:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328263;
	bh=ipazECDcqer34PkhZzEYOQwthLWQmfOseCJHjGmGwf0=;
	h=From:To:Cc:Subject:Date:From;
	b=husj1rxru1YPKylzj+o8YaWX3AkfyR+O+JlcL3rrfgjSZ0lM03rvIOZHzyAClYfOV
	 yEOlo2sGqaC5EJjpSvE8E/oei/iDo0MWWXU22tD43VqiWTT4UOAChvIcVn8IfiMc3v
	 WQHAVKecV6UYku6hIu3YH9TwN8sf4eqv8PHs+jeu0ns6/s8rYHBFXVk/0Glx92YeMf
	 WnxKSie8xxT44Orde8k4yJQhztYR/18NM2YvacLCjVlVYb7DT2v9yN2Pj09pft5iHu
	 VSCuwNnyV6MsjvoFlg9mx/bNzYFwAW9yyi8LHCP8yU+k8s41rfzgTHRvoZQss8e7/3
	 2TV8rTMqKNZsw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm mpath: make pg_init_delay_msecs settable" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:24:21 -0500
Message-ID: <20260301012421.1681192-1-sashal@kernel.org>
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

From 218b16992a37ea97b9e09b7659a25a864fb9976f Mon Sep 17 00:00:00 2001
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 27 Jan 2026 19:12:24 -0500
Subject: [PATCH] dm mpath: make pg_init_delay_msecs settable

"pg_init_delay_msecs X" can be passed as a feature in the multipath
table and is used to set m->pg_init_delay_msecs in parse_features().
However, alloc_multipath_stage2(), which is called after
parse_features(), resets m->pg_init_delay_msecs to its default value.
Instead, set m->pg_init_delay_msecs in alloc_multipath(), which is
called before parse_features(), to avoid overwriting a value passed in
by the table.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6f9d86f4b912c..de03f9b065842 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -225,6 +225,7 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 		mutex_init(&m->work_mutex);
 
 		m->queue_mode = DM_TYPE_NONE;
+		m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
 
 		m->ti = ti;
 		ti->private = m;
@@ -251,7 +252,6 @@ static int alloc_multipath_stage2(struct dm_target *ti, struct multipath *m)
 	set_bit(MPATHF_QUEUE_IO, &m->flags);
 	atomic_set(&m->pg_init_in_progress, 0);
 	atomic_set(&m->pg_init_count, 0);
-	m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
 	init_waitqueue_head(&m->pg_init_wait);
 	init_waitqueue_head(&m->probe_wait);
 
-- 
2.51.0





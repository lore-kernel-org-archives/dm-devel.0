Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA7814ABE
	for <dm-devel@lists.linux.dev>; Fri, 25 Sep 2026 03:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790305619; cv=none; b=AEGetDsEIMDmuqtFSpdFlXJWq/vies7PKQiKybM45s50W1yhXrvxSG7tD3nKWvpUOC0SSJJpmkxnauwSZ9RqtJxE04y094r5GZ+9Pem2eav/tS7PSNQMaumMf4qfOWAboZsoR8PpHH7PGxE6yIZJBxJspRO6Wufp/mOu9UtqYA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790305619; c=relaxed/simple;
	bh=NwQpNvlVY4c6JjoDd4WxMbnyYORhtkbdS1SqyrgIDGY=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=HeUcVZ8hdY/VM1qpxjTopBd47gZdm1plv32f7JX4erzwtEHTRCxTJnTTLyZlVcQAlYiLLW/qfPs/GGc51PPgYkZ+Wu+Nsnk3SyOkfpyqLc9pmXWZe4c7N50NMlffOxVFkgWYu316RoIcOcXuwRux9IfXROUhYmoKhQXtXQ6gVgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=sW+jaAX8; arc=none smtp.client-ip=162.62.57.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="sW+jaAX8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790305611; bh=Wh1cX9SEA/J9VRPcqeXv2Rk3xbNPU4Cgu3+dEnZjW3s=;
	h=From:To:Cc:Subject:Date;
	b=sW+jaAX8FoV+zFDPf+GT6Uxff/+t87NKsXhg5tRBv2WmZNHjl4VRRwhiFHYkh5U2V
	 uLeiYJBGqr14x7X5Y81KhvinWOU0INZoDzpxcxCPtPzRw5gmtjXCBGruF59YPPj1F4
	 NyR590QG4ipwhsOpg6ffvYWtfK4uMr7zSFMQ2lqQ=
Received: from localhost.localdomain ([182.239.119.212])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 1778B8DE; Fri, 25 Sep 2026 11:05:55 +0800
X-QQ-mid: xmsmtpt1790305555t7e8phg5o
Message-ID: <tencent_B97043EE6125DF666647316C208B39130805@qq.com>
X-QQ-XMAILINFO: MuagZN7e4fMyxp+F4zsMyrFkHYU7szRhqzYjkKvI6gml/bJFurvuB2LxG8NA+o
	 wqJ6HVEayEyYk5OAQUkFGFa6A5GhZRfdCZpAze8+FgGw5rdLVjjqhpIrlA58PbD+10JrtDUp+ypG
	 O/avZiQrtu+fT3cupP1au+AIPczoSvqkwXzjoLQmmFuveUi/cf1rdq3nJ73JH3S3X9AD7ws7/2b7
	 BIxpRghEV/nJnMrCk2n/907rYKiZzXEKE221Lzx9KVFsJYDw5zV5ty1B3gQCOZPdta8rwr8PXv0L
	 lQ2NFLOxTkHgN29kdnbUOW7uIdWNCfwET1QbMjqzRaXx7A997nfktKlDDrLQ2pR5TX29/zBte8Q9
	 tvBe3WH6x5J8C5tvBnRKiMoJ96437Xa7Dm43TK4a+9r9VToI8pgB0hX1oDcFonRW7i88iqPbRdsY
	 je/6v9g6XjShyicgZ7t8noO3DXpAe1s81Iz88EgVy6P2FyoyxXZG1HsaL1fhhon/33T+9ZTWnM8r
	 fRZSYNsTbzMsanYv5b8VBrgsskaE6gX0tFDGsp5xkZ4++3vYVIxoAl5YFxAsvq8hZgMAMtde8BlP
	 dcUR8jZYeczwFRxISVtv0ObHZRjAx9w/EVXNZJ5nbLiuqM6CnAxX0Y1QBCaaPObiFmTQ2xk2ewuE
	 aE/Dr9od+Ul9dj1jIGLkg0odZUyJqYuLDoSdVdwGHvL1Cam2Fb+l7CcqLN7msGeNYTHVv+CYaUyS
	 KH8hXNGK1SzsZIfSEZtw8SmbEx3W/HQarZkovgCBVdA88VvpSGLnsW/iWXlxLzboBR6pnG30yh7J
	 YGg8cfX0bY1/BL4kHutDG/Rfh0qNbQPZtCNhwDJnVk14pin8MckLHy7bsyl7KnzqdkIEVaphYMjF
	 3LKUj6WosZR402KGUaPITeEzumuXy3L2YPBuXiR1Lh9EN5++19znwjFYWtyaamhkZ799XGfQbEe0
	 X1TTlnfHIYlOy2tLLS7MgFSvIb5zT97oRCs+i4xCaoaYmQYh9UACfA6kLpM9ZSx7lmqYvSDRqnEq
	 xe/BKPcMJlB8+kSfGFtedrUmqOAX2aau9swuRE3m/3LVHr6XLO
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Ma Xinmeng <1564938642@qq.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-snap: reject the transient exception store for snapshot-merge
Date: Fri, 25 Sep 2026 11:05:39 +0800
X-OQ-MSGID: <20260925030539.1298-1-1564938642@qq.com>
X-Mailer: git-send-email 2.49.0.windows.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

snapshot_merge_next_chunks() calls s->store->type->prepare_merge() without
checking it. The transient store ("N") implements neither prepare_merge nor
commit_merge, and snapshot_ctr() validates those callbacks only on the handover
path (__validate_exception_handover()), so a directly constructed snapshot-merge
calls a NULL prepare_merge on resume:

  snapshot_merge_resume -> snapshot_merge_next_chunks -> prepare_merge(...)

commit_merge() is NULL for the same reason. Userspace only issues documented
device-mapper ioctls (CAP_SYS_ADMIN); this is a misconfiguration the kernel must
reject rather than oops on.

Reject the combination in snapshot_ctr() at table-load time (-EINVAL), the same
check the handover path already performs; this also covers the commit_merge()
call site, which a guard local to the prepare_merge call would miss.

Tested on Linux v6.6.157 KASAN: unpatched, the dmsetup reproducer oopses in
snapshot_merge_next_chunks(); with this patch, the table load fails with -EINVAL
and no oops. Also present on v6.6.145; still present on the linux-dm tree
(555f3d7be91a) and on torvalds/linux master (62f4c998b297) as of 2026-09-22.

Signed-off-by: Ma Xinmeng <1564938642@qq.com>
---
 drivers/md/dm-snap.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index dcf34c6b0..f42935361 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1320,6 +1320,20 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_store;
 	}
 
+	/*
+	 * snapshot-merge requires the optional prepare_merge/commit_merge
+	 * callbacks; the transient exception store does not implement them.
+	 * The handover path checks this in __validate_exception_handover(),
+	 * but a directly constructed snapshot-merge never goes through it.
+	 */
+	if (dm_target_is_snapshot_merge(ti) &&
+	    (!s->store->type->prepare_merge ||
+	     !s->store->type->commit_merge)) {
+		ti->error = "Snapshot exception store does not support snapshot-merge.";
+		r = -EINVAL;
+		goto bad_hash_tables;
+	}
+
 	argv += args_used;
 	argc -= args_used;
 
-- 
2.49.0.windows.1


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966371E0B86;
	Sun,  1 Mar 2026 01:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328922; cv=none; b=asCJwJghyY8i36APNCkyC0xtSdhCnC2J0nU/kK4ItjnTz3U5q1kLIvj/HPm2gRVKYVHpjSSaSTuLkGsPJXsM1S+GRhP4gnlJhzqEBq13thFaDikLkQWMsXTF9Tw61dLp9jDEQrNBeiDyfrKTGAD6IKHNDLi5zARctkVgo3QuQ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328922; c=relaxed/simple;
	bh=uEfHyww357q23iYungBzXWx/reQ/YgWKbiTpeVCvVcU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sPooEoOEcE7or8HZmPHdDmZXmNc/55PvwMjaxLBXWPDYmHEZQLoBfAb7ktjkPn0k3s3KeJWTqTtwnFjHKPMILglrYdZ/W3FLnad8XjsHiRelAOHUkBRtW6ic8yn1ZQ6fYeiTC0U8ELLchCK3dvvD07WkOm8qCVNOeQ73O+7dUrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDuN+qwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDuN+qwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEB1C19424;
	Sun,  1 Mar 2026 01:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328922;
	bh=uEfHyww357q23iYungBzXWx/reQ/YgWKbiTpeVCvVcU=;
	h=From:To:Cc:Subject:Date:From;
	b=gDuN+qwdPTNsdqisA2/MxTVONULvTOTG4k0/ge1mQJo5C2EOQoJp4U0xJLGJ514LY
	 Rn7OmKBud9lMNRXCsy1cVkBmEICz0G2zdKXSXf2zCwdvwdWidHiS6McexhAHspVezk
	 d2o/A2UlyLndAhVJqX5I/9YwM5s9Kc/Pw8R1TbQ7asBCku/ux5LlSvCKJ1mWYOVAl1
	 QjjYOfQzR8jvMY/D5xF3/JsNw2qcyHrXfcDz/AOvzbfW9xTfU1kiP8LOPz6PjytcEm
	 dLaxtrRyTDcTXKTgLsV/H8dY9Tce7RMdpnztu24eMZEwbgy8xgWhV1fVDMStiFgJFL
	 7KQeTtQ6YL7Pg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm mpath: make pg_init_delay_msecs settable" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:35:20 -0500
Message-ID: <20260301013520.1695007-1-sashal@kernel.org>
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





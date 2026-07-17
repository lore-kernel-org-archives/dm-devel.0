Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10773C199C;
	Fri, 17 Jul 2026 11:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287616; cv=none; b=sIvIiBkdsj7GRhS40KEehMUiIPtC3fj3uFE6bk71agJwtDJQp9BvzEjX+Pp2Y4AbVGFpSAlW4N98WHtXA9jlfnzrwV7LIVa+8Pl8NZsG7IsT8Q8+aujvt0w0LE3dFnRr1RNsupdpHPJMl4V/WM999IHY1Htxj/eIJjBsqhFoeNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287616; c=relaxed/simple;
	bh=lpydZFZOaGYCWBb7v/yW09iPNNSvU0qbM47gUMZfWaY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=n+dlnM+T0WKW33L55UYM9nNYP7yHDSXJMS+9Yp6Ikz2P9fygUYfouxvMBOiVzNV4NMzcc4MeRZ4MqwV6yOS9HlSiO3OzGhqZqKtCSGoIm9b75syO/lBnOpz9yVVlTqzoCNY6sRP4tNXFe00fgTTQWZ1/Sy9eNgFD92SCmGJ/XsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=li7r6Y/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="li7r6Y/l"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E5FCC2BCFB;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784287615;
	bh=lpydZFZOaGYCWBb7v/yW09iPNNSvU0qbM47gUMZfWaY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=li7r6Y/lVistP+fSkNYjKuiOxL1i+53AX+qiX2elB/ZaNyEPDqLtDQfbYJ1hjzG17
	 MHg69jZ8yEaq7kVxcgjdxdS9VftLDnjvndj8RXESlm35sAFlFKcAWLRAyYIK+2Uwkh
	 CZ6AkWhC5vF/FJaT0I8JdFRKok6lk7I5chIFhaXW91tDdtEoww13g1GyQp/eOMfZFC
	 8WKBx6j5ULeuCtpxtVUhVOo3HLZZz0TRhfIYOCpwrXdH7ophcksblYAAM3Dc5pcrtB
	 2WjM93mUkD/h5AGKQ34bjXpqHCjxw0wL9+2F/vIvMPawlKk4EyJaj7WAUAdNUIVWEs
	 SUDSvjm9Rqm5w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF7FC44516;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 17 Jul 2026 06:26:58 -0500
Subject: [PATCH v2 05/11] dm-pcache: reject a kset that overruns its
 segment
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-disp-4c0a0039-v2-5-19227d6e313c@proton.me>
References: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
In-Reply-To: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
To: Zheng Gu <cengku@gmail.com>, Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784287613; l=2364;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=VDNrRdx1QgfmUKR1cmC1fUFZHKtUK1mTEMdKllWQ9/k=;
 b=9jXwTIWCfMx/ewKKdUozqL/UtY0fI2YFUov6Fk/PIiEsUsFXnY7wsSso7WeZU23B3MgEGNEG/
 Bhs3DhxCbccCdWQRbBsyPSyPbOsNz2K2MomT+sVOnNKfGnsHhG5Z3iE
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

cache_replay(), the writeback worker and the GC worker read a kset of
get_kset_onmedia_size() bytes and advance the position by it. A forged
key_num makes that size exceed the segment's remaining space, so the
advance walks past the segment and trips the cache_pos_advance() BUG_ON.

Reject a kset whose on-media size exceeds cache_seg_remain() before use.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/dm-pcache/cache_gc.c        | 5 +++++
 drivers/md/dm-pcache/cache_key.c       | 5 +++++
 drivers/md/dm-pcache/cache_writeback.c | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache_gc.c
index 1ed513745023..c483c7a3afaf 100644
--- a/drivers/md/dm-pcache/cache_gc.c
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -146,6 +146,11 @@ void pcache_cache_gc_fn(struct work_struct *work)
 			continue;
 		}
 
+		if (get_kset_onmedia_size(kset_onmedia) > cache_seg_remain(&key_tail)) {
+			atomic_inc(&cache->gc_errors);
+			return;
+		}
+
 		for (i = 0; i < kset_onmedia->key_num; i++) {
 			struct pcache_cache_key key_tmp = { 0 };
 
diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index f4459b2e1b3b..d00497f9e462 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -818,6 +818,11 @@ int cache_replay(struct pcache_cache *cache)
 		}
 
 		/* Replay the kset and check for errors. */
+		if (get_kset_onmedia_size(kset_onmedia) > cache_seg_remain(pos)) {
+			ret = -EIO;
+			goto out;
+		}
+
 		ret = kset_replay(cache, kset_onmedia);
 		if (ret)
 			goto out;
diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
index 34c34b448e04..7a85a9aed18e 100644
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -261,6 +261,11 @@ void cache_writeback_fn(struct work_struct *work)
 		goto queue_work;
 	}
 
+	if (get_kset_onmedia_size(kset_onmedia) > cache_seg_remain(&dirty_tail)) {
+		atomic_inc(&cache->writeback_errors);
+		goto unlock;
+	}
+
 	ret = cache_kset_insert_tree(cache, kset_onmedia);
 	if (ret) {
 		atomic_inc(&cache->writeback_errors);

-- 
2.43.0



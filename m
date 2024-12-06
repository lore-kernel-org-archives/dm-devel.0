Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27772213E74
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528216; cv=none; b=RM+RBvNvR9iAxx+GDbu8glwwDj9whiLxYU9473l01UM3rEAjGdtI3lVr/3SU/4/68gKaw0GYSOdwekBZRxkEv1lNZcWFUcuBzGa+aZnhfqkVVKsfRC8HGOwBKwNq/U6XL42ePi8knZgj4jD2vAH6trCofx269VBZyUk8aBItlhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528216; c=relaxed/simple;
	bh=QoYAfNYJvLd/TJckwCG64F8GWIrNQCyslJfU7rQGdjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faS+EBO1W/vW9mSaUT+yMF0cltbMpu7GKvW1N8mujc8+N0NELcTcbJevcIZH9M6xX04xnpVqWgk+wFlJ8zI8qcCcqMUGB44/uLrXWU6qOMEXC35oO4HsODA/AGpP3YljV5lZxiTgax/xAeIxTgYaZbWtT0uaLzQLinjjBqdlBi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H250VejL; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H250VejL"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-385eed29d17so2044825f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528212; x=1734133012; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+ZChgxxwjJP0AvgnYxkAg/5ApCP3lML/endeze60rE=;
        b=H250VejL4wp7wwVKJ4N5ZE871i0Y58YEuSmhZapz4AjbCtjqOL70dKaZmReax4UJ1O
         VfLs7lxJy7ZKcCt/LuCplAI3ScrhUMg70OBci2rhz/o477sqRz1eV083qKVyLc4fxgN4
         6phmQ3MmrsQlQadvFMobQOJyjks16NNrhPTD6qHiGWnA66xwsNUFSJmTElysEKv83MHC
         WvdKyoD3L3x5LQp2GgiXTPeCaNc+aT17unX5kQ94TvYnORAXL3DwTBcELp2Fq64uwiMP
         KMCboG6vkK5GgN9q5Mtm4X2levIY9++vOYPpKLS5wjEwfRfi1nlebG5lJYJU4yr8SLC1
         fCig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528212; x=1734133012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+ZChgxxwjJP0AvgnYxkAg/5ApCP3lML/endeze60rE=;
        b=TsEfMM23WqofEUkoeqwq+9o+kTbOiKKcPVd0vIMqdy53uAsUsJ27FCtVEeDYGgmMOM
         mI6rMhFsLy04DEnGCdRxLF5puQZNJrbouzQSn+gDwoLJk6lJ7DIm6E7VVoBxm8nfjMLs
         lih6p4KFYcSP3Jd8UIDY3nsTELdhHKCqjbLNfvPiU4ihc16tUa5DLps1Eu6mLCfiUNyH
         AvFy6cJOCEVD97ykHMdmW+zpxUar18YviWWRXdBzcoFBce4Db49JovTyI943iF63IlON
         HZ57CAaidquIcJSoZ+g5kI8Ww8htKyBQk4ttK/kioPh85ebopz0XGTYW8XQxntBpGnkY
         7bcg==
X-Gm-Message-State: AOJu0YykY4M7VkIGyM0qx0PaQX5BG8np6shv/51XlnIb/7iFReUFnkW6
	GmmegU+YPK8Cy6msCjqlHz+qNj7CzmBRBzE6+Jnl5hiXXgWIMd5kStwL2HGoiRCLEE0W2y9bEst
	U
X-Gm-Gg: ASbGnctHDQL0IrWsFmfPaWp9c/ZYhRUXRlJYt9YYjOkqTRSbCR2taqRIOj2b0txnsPw
	EAN3Aj41Mf11tN1FQh3KsODdHoedOQEqRH6/MAm0QoxtDxu7sJ3gp/GiHYA28oz3vwiL6oNF0uV
	q/hihg/cmVheuJizl42Zp8ewqQjyLt12vjjkQT5RdvEOvMsv6wE2MkMx/wSdnjpTPdFLXiZzeez
	aejz+slHscv4g/CGhD74BxyFKsnV/bnNZPGJdympyHdRycsNW+EhWjaj511ry4eqM/umlSCrR8+
	U55SUWFE/YNCV+IGi6cZe2ou7STgrdx1HCnS
X-Google-Smtp-Source: AGHT+IGiwDtJPqAnYyN1Az7PDTtB4iIJ98t516OYQA8CbwgJehaPXwjVAlp/6kTe+F2WykHWKdPSYA==
X-Received: by 2002:a5d:59a2:0:b0:385:df44:12cb with SMTP id ffacd0b85a97d-3862abd8ac0mr3359714f8f.0.1733528212340;
        Fri, 06 Dec 2024 15:36:52 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5d3d871f1c8sm495561a12.13.2024.12.06.15.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:51 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 08/13] multipathd: remove mpvec_garbage_collector()
Date: Sat,  7 Dec 2024 00:36:12 +0100
Message-ID: <20241206233617.382200-9-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206233617.382200-1-mwilck@suse.com>
References: <20241206233617.382200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function duplicates functionality that we now have in the
do_sync_mpp() code path. Remove it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 7e844a5..43f6cc8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1967,24 +1967,6 @@ enable_group(struct path * pp)
 	}
 }
 
-static void
-mpvec_garbage_collector (struct vectors * vecs)
-{
-	struct multipath * mpp;
-	int i;
-
-	if (!vecs->mpvec)
-		return;
-
-	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		if (mpp && mpp->alias && !dm_map_present(mpp->alias)) {
-			condlog(2, "%s: remove dead map", mpp->alias);
-			remove_map_and_stop_waiter(mpp, vecs);
-			i--;
-		}
-	}
-}
-
 /* This is called after a path has started working again. It the multipath
  * device for this path uses the followover failback type, and this is the
  * best pathgroup, and this is the first path in the pathgroup to come back
@@ -3002,7 +2984,6 @@ checkerloop (void *ap)
 {
 	struct vectors *vecs;
 	struct path *pp;
-	int count = 0;
 	struct timespec last_time;
 	struct config *conf;
 	int foreign_tick = 0;
@@ -3074,18 +3055,6 @@ checkerloop (void *ap)
 			lock_cleanup_pop(vecs->lock);
 		}
 
-		if (count)
-			count--;
-		else {
-			pthread_cleanup_push(cleanup_lock, &vecs->lock);
-			lock(&vecs->lock);
-			pthread_testcancel();
-			condlog(4, "map garbage collection");
-			mpvec_garbage_collector(vecs);
-			count = MAPGCINT;
-			lock_cleanup_pop(vecs->lock);
-		}
-
 		get_monotonic_time(&end_time);
 		timespecsub(&end_time, &start_time, &diff_time);
 		if (num_paths) {
-- 
2.47.0


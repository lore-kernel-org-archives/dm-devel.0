Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321A51F2C25
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957998; cv=none; b=Ggzd3PRnfA8TvXh9g4ymF48EqT+mnbtAIp+bXQ1bytoyrbY87ysHiXchLXoRE8KtDTrAzqErlZN93Mb0oD2AdIid3kKvWYuCUNqp7052kFeX50IPbbYc4dUmIGJz3SWJYO2AAVqHUQsyDdfBPyTyMPqlgWMa+QonZJvs+CorlYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957998; c=relaxed/simple;
	bh=6j3+WRbuSlVrNfQ3Q90ksjso3L1HhU3ZQVfad+/28Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYcXnjPZkzyISuWv+FVbgdA42VijCYkUUQzinalBM2v2umHm4lIPRgNKihieVuYKu+6VBRsjIVuGPC3ociadhDqCeiWMJFcoVPS8/RCAc3ARcoLpEo+7M2p9hVmugS57j1pRTIEqZ9oG5IF09s84NgNChzdm4JOMsOyJWJsDZU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H0yYqfqZ; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H0yYqfqZ"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa67ac42819so709797166b.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957994; x=1734562794; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUyyo0iIKGnQnX8alrh9k2AK2MSYQRXSOtx7dP+3pZI=;
        b=H0yYqfqZuAkTgwMaWkxLe9HxrG/xq+0JNNThY5XXw5p/DxmqATlnouASPYnf5Qc131
         NQalOM1vSKVYMXIwBn7a/xUY4su8UpY80VGDrOLAIwh4CizkUiiWQtMk4A40JWkiPKQi
         p4tY0gMM5hWF9Lju0rVUpLx4QJXaTBKqvIHGLsD9lIrEOlWkdhTW+7E6h2kEjzHA2LiU
         UsBDGzjuMuR0qx1YSVywBk6/hoY8w1WACLZPPPuqBJlauQIWU+KVRlRS+4sv5LGf6V4d
         6f7CX0xPKW6As4NYCuDkZ5hR6aeO1rugzecZvLB0qD8aIkCm5JGyXEKd2FkTr9sk2ykf
         VeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957994; x=1734562794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUyyo0iIKGnQnX8alrh9k2AK2MSYQRXSOtx7dP+3pZI=;
        b=sSyAoogMZ1SGX1SlhHURFTBu+Vy4RWK8R+F4CVKVQ0jKf9IbY6i6LRMx222X4v7Xwt
         O5WMZYJM6JBdVF683SAc04B7oBm+MNPGCf1nU3TYbzkKCC8YCxX5hYOxRiSoIcyKTfyY
         sF5h2n0gI5mF6RMzP7tC08KK9CEcZiprA7PWS7sifQpfu8lbPLs9D2m6dO26UHqZuVXb
         N3AfLM/EKFxPgutwKI2bpw3PMDvjA9snAlHlFzW3pfDPiz1PRRXe3NX2HPOZSpHZTeY7
         GjzfVFxP2eL8BLr1jj25k+wesouI+BV7diu+tKtRdNGyu7SlN0VLmZgoMrKbupKxEctE
         ZQrQ==
X-Gm-Message-State: AOJu0YzK7uDxjF7jWKB9TLYrerceUIUPWofJyDbI0k0fi5bj/C0I/S8g
	lvK70nUmOv5EzrRL5lqGotdT17VZhWDRsLHHxQ02yXhJAPYDqXo09tUyc4KTUP8=
X-Gm-Gg: ASbGnct7RiMEysZ9pN/YYzPzOKwg48DxYnSGax6Meg2QPLj/6kfyBnlR7hdg5iW+/AK
	/W3Wp5m0aPMwPX3rD68sHYh7QQUWZKijm065xeSWHLldW+lG4a8SBOSX3L/8AdsXcQjG9LRTXY2
	5KzXdoqlN/GZYyQlkNxADbiFHmhUT7/7pTvHhbqe9kgKNLo9Tuqu6galUKjmJ8AC7n132eXia0B
	tCjf5pI2D3JELcYIYo4tVGQLV4lvi1Q41ARMEjb+yh0y9lNg4AxFXD/m+J1xvWayShdBA/8dcit
	ytY2pAGwZHYy90PZP1QWySiquuMeb/54jriXbVlr
X-Google-Smtp-Source: AGHT+IEF7RqmEexzHd7JWCMvKkRZX3bUNNI8xTArNvuhyqq/xi8hmTLIRqfztPd86CkCs2e+o7vOOg==
X-Received: by 2002:a17:906:cc2:b0:aa6:7165:504b with SMTP id a640c23a62f3a-aa6c1b1dfa6mr157955766b.31.1733957994281;
        Wed, 11 Dec 2024 14:59:54 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa677c4970bsm616489866b.112.2024.12.11.14.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:54 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 14/14] multipathd: remove mpvec_garbage_collector()
Date: Wed, 11 Dec 2024 23:59:09 +0100
Message-ID: <20241211225909.298770-15-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241211225909.298770-1-mwilck@suse.com>
References: <20241211225909.298770-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function duplicates functionality that we now have in the
checker_finished() code path. Remove it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 138ddd0..941ec68 100644
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
@@ -2983,7 +2965,6 @@ checkerloop (void *ap)
 {
 	struct vectors *vecs;
 	struct path *pp;
-	int count = 0;
 	struct timespec last_time;
 	struct config *conf;
 	int foreign_tick = 0;
@@ -3050,18 +3031,6 @@ checkerloop (void *ap)
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


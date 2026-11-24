Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523168;
	b=Ti289V9p5f0MLenJ5PSQFDefar4MfNYEjz/bSGqKgfDERq9jdw2e6G5DHoPJ89BUEN+O
	 csd/1JhdTpPdJzofT0PUVLSjx3cPksKqP0Wm2u5tBDBXXkbvobFKt40QCKFhBtVc6j9ps
	 8x9E0QXPgUtstUbiJLusRRl+gX7R8k4uvPz7aQ45biAEv85Dcu1BpmHw8piE9WDLzrwgZ
	 YInJFhB31RgWYm4T4YVEYBdTwsBEg5mzNt7v6bnZToYInN2sJXJ8Yq9XpNALwHIykGRjW
	 D8eKgvq1GIDm+Kb77RqdcN1m6wzlGtkoMeDeIhAOhx/CsLloIfb6Xp6VQpu6zoSFxDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523168;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SqV4Jv6wNfUGVd/YP57RFpsT3eJh+v6vOgo/2e6RqII=;
	b=EPOoWamzE/lw7SCNDlK+hKhXv24WrQI7c4EjKIhcKPb4yeFZ6zuCG7ZAk9lVo3+xBdAQ
	 9aR7A5sYUENzCOJRtw9KWJpLFCZ9zPmH1Qwmh1vdSHbWw2JprGzKNa7mRc76hs/R3JGms
	 1GVCp8RhNXizK96b9IHo45XA73k9L2sfwhiSXJNDxgCw+lc/XVEgR380rY6qh6qCAOdSk
	 0EK5mr+56KxrIS0u86S4F/3mBuUWQ9ETR71EnRlkzP0lSPBEhUIsy9Tnv/eXPW/tNT/Uv
	 STC9WODvCt2WdmAPawq7sU66DLyiX46FiB5AdGytIRl0J+Idc398TnKCYiY9DLVPGfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvz.org;
	spf=pass smtp.mailfrom=openvz.org;
	dkim=pass header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=MKe0YAVA;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2B2606A682
	for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 12:26:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE2B2606A682
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvz.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvz.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=MKe0YAVA
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4b467581b98so42667605e9.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 04:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz.org; s=google; t=1795523166; x=1796127966; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SqV4Jv6wNfUGVd/YP57RFpsT3eJh+v6vOgo/2e6RqII=;
        b=MKe0YAVAiOjbBk2p7ST0M3DHVtC0zA56xqgup7aSwKqxIAP/W3YhsRCmL3/nmNUq5v
         xb6uhtwZrU16xrdmh/T2uZxNHMSo1mhrQoI0MeChe2UwH8nMiXWHftKS61+mt5zuyoT8
         AuMCIDTzLnTa+kvKIXNgCWeTpNlJTBsAjk7zAd2RId6Ssd4hRKSVc5ryAX4KmiVNXKZe
         jnkUcfyze7e+GKOYs7njOE9/4KXyUN2MA6jhTVXe6mhRU2W9E14HjcEM1yDSkmQkuf6D
         qteJkv+nUdJdIDMoAsevj5a18dBXtZyciN3TLR+HoEh5dkDuTp4kd1UvgpyTxL/MiO+g
         i6lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795523166; x=1796127966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SqV4Jv6wNfUGVd/YP57RFpsT3eJh+v6vOgo/2e6RqII=;
        b=uJW0eV/5VuMNWcnSTkeKp0R/nFjFdBq98ZTvGdjVl6W706qEeA/k+AxtbYHfKXtYsF
         e4eUruUiCn5m3eihnihRQtkO/EcOFPcUq9JqCAt1s/q2PkOTfIhysVOmGZ7CKMIARxT3
         KUBs32+AXiH4k7Kvhb0CPp+s1jnPd97DXSLXmMu0c9sQ0BIZwxG54Xek6k4eOf06rnRr
         fu8bgpDiI7BHQBzv9R6eh6+AJyUS6B/X52O9gnxF4yM0JhhAiITmQncES48rCRD2/27k
         6/1x6EoJZuFlxzOROFsNg8qonAGRlTv5bLhH2Bqn36m3ODs3fytWKDGPWzzu8JP3+LGC
         ijwQ==
X-Forwarded-Encrypted: i=1; AL+hErEF8lwJONt4jzTJwxl/xvomsFKn0j4SxJA4kKYn3dLyGgwu/jWjFFfUO543/VUB9cKRFzbib0lRBw==@lists.linux.dev
X-Gm-Message-State: APuU4Z+GXGDKP4BPSMI5TjVsodYeH/YK9u/aDEOKOoHN8MKnXh8rYg0K
	wFip72ph5fFLHhfazZQzw9PgrQx1YvPkDcjIMK76PdlihkkQbOGSeAKt5ecdDgI3IGw=
X-Gm-Gg: AZFdTZf+3xgNTbdyZJaMXDWmO7B5y6GF9ryVBk/U+wZIQDtPlFtDAB9xX5a1fZpWODt
	GKdxddUmOwb6j6ts9uqyLdYVvfAf+mo11XXJgO+ik50pd/iP5xVQp+UzwFYp74p5G9Y0dNbkOga
	zwuPNsgb8u8HQGazhawPDALAE8IXEzomiUHmo3uJARIAy3JUa04ZmBf9GwF0NZvVBV63nkS5GON
	L8gyCf2dDwi4ZdTMZ4dfNkp2089hDXh0hTCij5NIDB2rQi8Ih7Iu+xvS2kMT+07e/Y1WXUlr4JZ
	+hU995IINO9ytA5fiyIPBI/hITsWuxzxNBkIDD2TntmaQXfeM3Ce5aOz5O1DvTDAJhNF1lguSBV
	CkXCmfyghHsiLKpUFl+HeqfYn8Bz2JIFzCIY4ArrfJbDN2elaJcp/oYGgVbav2ewNiXDD9a8Ys6
	ghJ5TIyjfEjgZtlO+E3HvnMTqCMLdhasq+HHqtaO3hyzRkOZ+fpnSJeEpJDYLfNwLQb7HVsFSQK
	iQy5gQYC9zS64f3Q/SeQZIQyh6WAW7BcWV9PmEGeLMhpYZ3hYK5s7of5vnHvUjR9SHUaYIa+3ZF
	F0nE3vRBUDnvSm/NEEZkN1UXFXsW1XNPwzUDR4BnOHx6W9Xn
X-Received: by 2002:a05:600c:468c:b0:4bb:6d61:af7c with SMTP id 5b1f17b1804b1-4bb88944bf5mr286853905e9.35.1795523166104;
        Tue, 24 Nov 2026 04:26:06 -0800 (PST)
Received: from artemis.sw.ru ([2a06:5b06:b600:300:8dcd:31dc:bf64:9564])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853ca452sm423615975e9.15.2026.11.24.04.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 04:26:05 -0800 (PST)
From: "Denis V. Lunev" <den@openvz.org>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	thornber@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	den@openvz.org
Subject: [PATCH v2 2/3] dm era: refuse metadata rpcs once the target is suspended
Date: Tue, 24 Nov 2026 13:26:00 +0100
Message-ID: <20261124122601.436965-3-den@openvz.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261124122601.436965-1-den@openvz.org>
References: <20261124122601.436965-1-den@openvz.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Denis V. Lunev <den@openvz.org>

An rpc reaches the worker in two steps: the caller puts it on the rpc
list, then wake_worker() queues the work unless the target is
suspended. stop_worker() raises that flag and drains the workqueue with
no ordering against either step, so an rpc can land on both sides of
the drain.

An rpc queued before the flag is raised, whose wake_worker() runs after
it, is never served. The caller waits for a completion that only the
next resume can deliver, and it waits holding the table srcu, so a
reload blocks in dm_swap_table() and the device can no longer be
reloaded or removed.

An rpc whose wake_worker() read the flag as clear can instead queue the
work after drain_workqueue() has returned. The worker then commits the
metadata beside the commit era_postsuspend() runs in its own thread.
Both commits allocate from the same space map and take the same block,
which corrupts it, and every commit after that fails:

  device-mapper: space map common: unable to decrement block
  device-mapper: era: metadata_commit: pre commit failed

Add the rpc and queue the work under the rpc lock, take that lock to
raise the flag, and refuse an rpc that arrives once it is raised. An
rpc that made it onto the list is then queued before the drain waits
for it.

Userspace sees one change. A status query on a suspended era device
used to block until the device was resumed, and now reports the target
in error.

Fixes: eec40579d848 ("dm: add era target")
Cc: stable@vger.kernel.org
Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 drivers/md/dm-era-target.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index ea499adca4ce..29b0602e7849 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1389,10 +1389,14 @@ static int perform_rpc(struct era *era, struct rpc *rpc)
 	init_completion(&rpc->complete);
 
 	spin_lock(&era->rpc_lock);
+	if (atomic_read(&era->suspended)) {
+		spin_unlock(&era->rpc_lock);
+		return -EBUSY;
+	}
 	list_add(&rpc->list, &era->rpc_calls);
+	queue_work(era->wq, &era->worker);
 	spin_unlock(&era->rpc_lock);
 
-	wake_worker(era);
 	wait_for_completion(&rpc->complete);
 
 	return rpc->result;
@@ -1427,7 +1431,10 @@ static void start_worker(struct era *era)
 
 static void stop_worker(struct era *era)
 {
+	spin_lock(&era->rpc_lock);
 	atomic_set(&era->suspended, 1);
+	spin_unlock(&era->rpc_lock);
+
 	drain_workqueue(era->wq);
 }
 
-- 
2.55.0


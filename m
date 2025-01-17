Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D3C1AA786
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145692; cv=none; b=uQJU1EjDf76bW0w8CqXu3kPASomf4u3nBFSiZlNwYgLDDTnUXDAh4DusQHtCf9YNXo8Njxn/P6tgSI4a9gEvjgesJUbMqwipCeiuVyjz3GtCBzIgzPU8rDrr/GGKjXkwixowWAzKz93SvW+JkAVh+o5JLru+z1U2o/Px0M5fOPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145692; c=relaxed/simple;
	bh=FAXAm1J8YRS1gWxlemXx3kNV5741Cdivd+wuVBMlhRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GP6Ktfc0awwjOrHQldlovw7Vtf7rDSENVTKl5q4laYjJyBLcjJn/yGKhUuEUeuU7V5U9NZi/jSaB3fLa5s1Rk1gJ4e0L85yWhEGtAgMurKMBlRWo8hn+LKZzLy1Rq8f00yMgrJ3c7nGeEHYNCkOt08xPX3BGCh1S7/7bKSycZYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WdNDNSar; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WdNDNSar"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4361815b96cso17216205e9.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145688; x=1737750488; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SsqlaGkhrUAicGMTeUUETjsiwQu1kbZNgtHvHlRy5SY=;
        b=WdNDNSarFvj2SxpjPfDc/c6HhjXrhApn94z9mXmaqAFN+45RkpEh5OjKQF/hA/Rmvk
         9IpqPOJ4PZscpCvn2w0LoUQB8wYM0jGAzDQ4lxaTdfaIU2x/8Oc0jJrSKmqXhp2Q6aGu
         /AcIPUAjYFG4coRqGtEMQ7os5EpsOCgVuQ7MtUNT0jX7tV31Z+lTdn3SZT1cEm49f453
         F6NYFlla9dBlYOO2VZsuYaOyp5YtjV/bjf+Cn/rAMuqT9YNIn7I6kZr27Lz3EjYN/zHw
         m5ofh+ddyX3znzATCM583fAYYH2KgusytrsOMRF+AwTTW4cqnppWE/8mm8AQWDjdV7Rv
         514w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145688; x=1737750488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SsqlaGkhrUAicGMTeUUETjsiwQu1kbZNgtHvHlRy5SY=;
        b=YFJ6yh6xE9byvvcu9VD5M6SSmimtNyqoaY8R4ASTaYuLSMhJnUhmu2oqVo0DKMh8wl
         8m3LKx0wGOspGd8V8n2Av/7ioCCmXD65mVFApxYlrynSGV5gh3AbTKK8mI1gAmVoPWKC
         4Rnszrk2npNAYdse+Ywi45VoFir+2HEgR+irVkBKEgvviLbDykblwWvntUvTjOmAmDM1
         L/ieGaqJnIzN905ONDyY4HiNYan0aT8giElh+2my1uzD72z0PmuONqy0hFxsjOC74PUM
         aymRPbWcn1Nm77An7e7Sqsh/iZs9qYTNTE9LeXtfzNml3gMiFYXwVbUl+OWa/j7TJCkf
         qcbQ==
X-Gm-Message-State: AOJu0Yy72/rzijBVyf+KBv3QDh4XGofdE5P9tahuZBDGUHqXeZIJxMSt
	ja+66r7ZE8aGfkEprkdBShteS4kCmvHGmE0Db+bk0EZ6lY2M09Kma3eAY41rFhU=
X-Gm-Gg: ASbGnctZId8a+Fx/1csq5FBc2/RktJbZAe3HcbCqlfVdGb3qg7gQ3g2zmJQCdAGeaua
	DW6Mjz4CwXm5jrVdABZcaHDqsTO6VFfvn79Bxmq4LT1hO1IH2Z5B5f8BNzkUFXuqGWyM9XauFZ+
	51MmFH8SQBXxn6vW011yWz8WAzNImhw2GQNRc0BiYJ4Al4GvbuPn+KVhzgYlZ7R9FJS9IYZrLzL
	1jlPyY/ak/06GVlmYafb4G5PGkKoDqltfho5b0vp7i+xYbYePKxmfjaNezgEbzREg6OIdSjHGjU
	V9Ayd07BwteirCPrgqeEQb2Si/q8tXmT9vpomhcy9ng=
X-Google-Smtp-Source: AGHT+IFtJElpGnK9+VrwHBgVblY+FsGIgYL46m7lhyy9aHewB0iUzE7K731jLoyCofkeZfQt2syzbg==
X-Received: by 2002:a5d:6d86:0:b0:385:e38f:8cc with SMTP id ffacd0b85a97d-38bf59e1e56mr5375255f8f.38.1737145688134;
        Fri, 17 Jan 2025 12:28:08 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38bf32755f0sm3370260f8f.76.2025.01.17.12.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:28:07 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 13/15] multipathd: remove non-existent maps in checkerloop
Date: Fri, 17 Jan 2025 21:27:36 +0100
Message-ID: <20250117202738.126196-14-mwilck@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250117202738.126196-1-mwilck@suse.com>
References: <20250117202738.126196-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If update_multipath_strings() returns DMP_NOT_FOUND for a map that
we are tracking in the checker, the map must have been removed by
an external entity. Remove it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4063e82..792b94a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2413,7 +2413,7 @@ get_new_state(struct path *pp)
 	return newstate;
 }
 
-static void
+static int
 do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
 {
 	int i, ret;
@@ -2426,21 +2426,22 @@ do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
 			"couldn't synchronize with kernel state");
 		vector_foreach_slot (mpp->paths, pp, i)
 			pp->dmstate = PSTATE_UNDEF;
-		return;
+		return ret;
 	}
 	set_no_path_retry(mpp);
+	return ret;
 }
 
-static void
+static int
 sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
 {
 	if (mpp->sync_tick)
 		mpp->sync_tick -= (mpp->sync_tick > ticks) ? ticks :
 				  mpp->sync_tick;
 	if (mpp->sync_tick && !mpp->checker_count)
-		return;
+		return DMP_OK;
 
-	do_sync_mpp(vecs, mpp);
+	return do_sync_mpp(vecs, mpp);
 }
 
 static int
@@ -2944,7 +2945,11 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 		bool inconsistent, prio_reload, failback_reload;
 		bool uev_wait_reload, ghost_reload;
 
-		sync_mpp(vecs, mpp, ticks);
+		if (sync_mpp(vecs, mpp, ticks) == DMP_NOT_FOUND) {
+			remove_map_and_stop_waiter(mpp, vecs);
+			i--;
+			continue;
+		}
 		inconsistent = mpp->need_reload;
 		prio_reload = update_mpp_prio(mpp);
 		failback_reload = deferred_failback_tick(mpp);
-- 
2.47.1


Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270341F2C2D
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957993; cv=none; b=FpeTQWBgcjaXCgxim+eHLsB8nOk2AuSJOXw7Bj0uBYAI0br3s9IDSy50tqyJGpmU5QaNf4wR+xLhwQNg+4xYN74MeQKEMjnAmZjkTg1ESk/Y2v4xtTfjodQv3zfPWRVo20TDs0y/9druvotCZMgKeXVwwPAUOS3JirVNrvPyVU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957993; c=relaxed/simple;
	bh=OTURv4mMaiUUVHWaf5RA0F8+poDNB5nykqxAxzFRyIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFBPjsCdOncVH00omu8A0vfFEUoHQUegnmQkXMrYUbRAlAKFZRVqkW5lDwFpb7lnA8fDny6y7nWIcBZ+EckTb5eciwOz1VcxJtE+HxVDpdj4E0NKSV9NIjehNCARP5gCKKP8j13OACofBCQI4CeJEEPPhv3Taf++0WfHRX23tNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RYgfVMRy; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RYgfVMRy"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9a977d6cc7so1072710166b.3
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957989; x=1734562789; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WCzCXETmWmuQCGBNVwgaV8Qa6e6pSIjkgHIgtmct0G0=;
        b=RYgfVMRyXxMIWzxp4WzTEGe2fJKR52Us+R3qHv6WwbllxLk3pw6MLEjSCR6rVcDbu1
         vs7uptul70Yo7y23/+d4il3nP1Pxjrzcv2tqNniRtyg2+TJw+/P0riDuxwKEI3v3C9/7
         MDqpfd7VPsx/jypCVgBRAaW4Y7DQE4eARPW61VSMbmksjOi1UDmKW6Dx2/kZz4NnJ/Ss
         9LDGKxk0Cgx3kevMTrJQlhesrUs6sm2rI/HGXjED/R26nb8OHxj6EmWpAncCNJ08yVPU
         Eo+pgEczUCkNl51VYoVKFw+68gnNZjyFteO9LnEFztDzRt4w78dye1lz9eAN1ARPljJd
         36Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957989; x=1734562789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WCzCXETmWmuQCGBNVwgaV8Qa6e6pSIjkgHIgtmct0G0=;
        b=OuRvtb11iiikkJjdVVQpRqGIu/MU9b9JP71DQa9laLpxtb5rjt5M011R/1m8SfLXSA
         343LSoD4YB6ErIHPOrjroDM0EslawKXm/i/8HU13nXes/r0r92m0fS0bXAJ7Z3TrYYXO
         lrWDWxEwjMZ7a4IeSqPrCL1pUTRrrEwiX7MHsI94V9WOeckVKaYse5rpFBlzWyh96r/D
         bnYfyfQ6FZQFVYDHJ9bgm1GID1FMLIKee3aMGLCXcCBaUjn4aSc0nrR/WKynCScS2nkn
         /kzbsVSTRpKUNGi6ToFKdzYKPkC8DmzGeLbaml4gJzLVfLw5wV1DZYHY5HKImSwV+6A6
         CWYA==
X-Gm-Message-State: AOJu0YyHi6XOas9X2klKzXkvCtqxrqYnZOtgtlgCd3DTuwWLxxsdsnif
	yie38+tyWLCj0sW+tdHMB5tJWkdtuywNCQrzvXhMHNoxMSDajwSGs+72hscOw30=
X-Gm-Gg: ASbGncvC6GAftL0sZO/lcwsocr5NKjLT8E6PcV/YrUUXBRqmcZ/sSMyuoDUcd2/FVYv
	PzzxpBQ9VMfzpnnof6YO+XHD5crWoEIJqNwPnsMnqzYuxOtvQP+RksVSJMsq5/vW8MneY+nWWqP
	+Ctp8eWMYSbhQAvAl3aeqnU0kGfA6pGfSQppP9V3cSoDHo+5OUD2i4LufXVOHNbSfpi2IaJAQCS
	dvSXvhGP0idTvgs++lWyRhHnmX0wOaO7eT47M14I40YXH6M1DzOYYWqd6GlgiWX2d+KVj+aHHy6
	U3Ghg673+hI4hIqIK33RM/VRDjO+CzWcKNT5MyRZjes=
X-Google-Smtp-Source: AGHT+IEwZt8xYGmi2HIAvpONkU+bVo+483jkKOQXwYlx5AJvp9PEmP6+2Xz8VGJZGrnwZ7fE34YOqw==
X-Received: by 2002:a05:6402:35c5:b0:5d3:ba42:e9e3 with SMTP id 4fb4d7f45d1cf-5d43308a1efmr9672592a12.13.1733957989194;
        Wed, 11 Dec 2024 14:59:49 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa67f4c4ae4sm578524666b.111.2024.12.11.14.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:48 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 10/14] multipathd: don't call update_map() from missing_uev_wait_tick()
Date: Wed, 11 Dec 2024 23:59:05 +0100
Message-ID: <20241211225909.298770-11-mwilck@suse.com>
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

Instead, check for missing uevents in the existing mpvec loop.
Note that if the uevent tick expires, we need to call update_map() rather than
reload_and_sync_map(), because the paths have not been added to the multipath
(see wait_for_udev handling ev_add_path()).

The set of actions taken by update_map() is a superset of those in
reload_and_sync_map(), thus we don't need to call the latter if we've already
called the former.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fd9ea6c..6d3c3a2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2029,29 +2029,19 @@ followover_should_failback(struct multipath *mpp)
 	return 0;
 }
 
-static void
-missing_uev_wait_tick(struct vectors *vecs)
+/* Returns true if update_map() needs to be called */
+static bool
+missing_uev_wait_tick(struct multipath *mpp, bool *timed_out)
 {
-	struct multipath * mpp;
-	int i;
-	int timed_out = 0;
+	if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
+		int wait = mpp->wait_for_udev;
 
-	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
-			timed_out = 1;
-			condlog(0, "%s: timeout waiting on creation uevent. enabling reloads", mpp->alias);
-			if (mpp->wait_for_udev > 1 &&
-			    update_map(mpp, vecs, 0)) {
-				/* update_map removed map */
-				i--;
-				continue;
-			}
-			mpp->wait_for_udev = 0;
-		}
+		mpp->wait_for_udev = 0;
+		*timed_out = true;
+		condlog(0, "%s: timeout waiting on creation uevent. enabling reloads", mpp->alias);
+		return wait > 1;
 	}
-
-	if (timed_out && !need_to_delay_reconfig(vecs))
-		unblock_reconfigure();
+	return false;
 }
 
 static void
@@ -2954,16 +2944,25 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
 static void checker_finished(struct vectors *vecs, unsigned int ticks)
 {
 	struct multipath *mpp;
+	bool uev_timed_out = false;
 	int i;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		bool inconsistent, prio_reload, failback_reload;
+		bool uev_wait_reload;
 
 		sync_mpp(vecs, mpp, ticks);
 		inconsistent = mpp->need_reload;
 		prio_reload = update_mpp_prio(mpp);
 		failback_reload = deferred_failback_tick(mpp);
-		if (prio_reload || failback_reload || inconsistent)
+		uev_wait_reload = missing_uev_wait_tick(mpp, &uev_timed_out);
+		if (uev_wait_reload) {
+			if (update_map(mpp, vecs, 0)) {
+				/* multipath device deleted */
+				i--;
+				continue;
+			}
+		} else if (prio_reload || failback_reload || inconsistent)
 			if (reload_and_sync_map(mpp, vecs) == 2) {
 				/* multipath device deleted */
 				i--;
@@ -2977,7 +2976,8 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 			mpp->sync_tick = 1;
 		retry_count_tick(mpp);
 	}
-	missing_uev_wait_tick(vecs);
+	if (uev_timed_out && !need_to_delay_reconfig(vecs))
+		unblock_reconfigure();
 	ghost_delay_tick(vecs);
 	partial_retrigger_tick(vecs->pathvec);
 }
-- 
2.47.0


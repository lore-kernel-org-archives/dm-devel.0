Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA051F2389
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957994; cv=none; b=cCgJdTzdyaWxyGv6QTBRtvvsqA/BqPUFwQp2HvanHof752PZl3L3mI57gez5btf59ZIPW9oq7cwA3Vf+Q3Vowgj/xD+ucPcXJeQHN47HZSom8AT4dtLFkR/fD7wqqU5Nsf+5ZcO4I4UsPFHuu/IwZLpI8GqOvOQfq2zAWCPBFsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957994; c=relaxed/simple;
	bh=zESFE5r2C7tTbZV6+10OAneD2vWZuhloe/T2TPEF6Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwMgKG5GGW6povk+fmczYYnulXXuZZmmcMFKJlioAXJoSeLacLJJsQeJ7W0Glyn0HgwiHuc0TB9JU544lxPcKOfKfUgrjW3VSytIHcCzKFkq+lrJM2cmCc+4TssuC43gaUWvVtiYko2XU3npiG0Oy+b15/X2zwzMr9btv7pYtkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K2eVtqXe; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K2eVtqXe"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso1104238766b.1
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957991; x=1734562791; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6qUh2eNVaqGfkkOYCT/XVvpoNZCXmA195FS/jO21TbA=;
        b=K2eVtqXe4HRLuIsJqhbneQbcRH/zph/sxV5ZyOoNLDxrzn882GjtfsG4rSxphsQP2e
         Q3lt/UJ1A9lleDyM5IT7rW4rxfEnGVjeXuouXU4vEpobCfyl8osBOfrNMuP7ocWAAKiu
         q02Uc1jx/zgKCTYYdsvWw8heWuR2PIAkbFU63w1HQQf2q9i9E2nffDLopUPZssHDC5V0
         K/ADpHtbjktXJAMCnrBG1KNVNeN08H5O5Zm10jNEnOLWMWL7HxVh3DV8D4bS5d5jjlaW
         GFqrXonhu0RBYnAKmzhFBKubCwVqvTd9UfbKgtekMVL/Nhx+0SO0MydA3ugXPROQMl6D
         L/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957991; x=1734562791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6qUh2eNVaqGfkkOYCT/XVvpoNZCXmA195FS/jO21TbA=;
        b=gu7j25ktqRr9Y4qkvUzg+oi3yYFDANnTMlSuAr8jnxBJGvkpSsnR6YpchA36mUveng
         IHAq31sh9V4RnBr8lDpUE40XEsTTX+zPkhw+8QQgYSNjnLHzaSOYo7ICuPG3UJQNTbyI
         eTqRuVSMK7taUZqMoO6O45wXq3MCu6HZEQsSr32HYUliAK2yj84gUHkBNMwWkguRCGJ0
         FMy6zN7N2K+D2V/FRSQf5dJSe1WSPyyqGSC3hIS468PpG7Un2vc4rWu6MYL4oVBR0sVq
         NShDhWeBbOgB1NKD6JkPKdi9kysq6KdIuz3eTKorUQr9w1C7wZCY06xpjnmovqJD2XLV
         DfBA==
X-Gm-Message-State: AOJu0Yx4coPVhVwIosCpgy0sozEFnTUuyDglHcgG3WFUNBZNFuMFrbJD
	8kAu0T0KDbW/LisgBgm95ZS4qecZowoIzj+IaHUIn9RrogdkNcmwuZsqGp3DZWY=
X-Gm-Gg: ASbGncvDYSopZD2R4MTcR7O4HHTQq3PHU8wnPju4i+mLaA8wRvs4IZ9eT6skHHZMIhz
	lIWDALGqLZG4ntT7LewBdOCvB3eLCLtPXSwruvIsT4rCGly1Mxmor/6HolDBooh1Q8i9LPa1tFk
	EdZAiLJ1Y3AXYwCLIYw2Mroljr8DCOn175pN+1wtTteotIuGgWbAHWDDBRqPl5wfQAEG9Vz0KZA
	KBLP0tPro2D2ZfHIUwuBWA3c2qHqG6RDhihiXze9heb7TTJfid+cuGWCSQkpyiR48E+W1LAhF7+
	NKiL4+JBSRAQWJ0lbiGuzNOI/LxuZQHfxh6I9Kh/
X-Google-Smtp-Source: AGHT+IEgLmvIDyYlEVwWNDmjWhUlNhRdPvTdzS5YzrzJ3EH5JgSy80Ycue453KZ0cP7nMhF5A5pqrg==
X-Received: by 2002:a17:907:7816:b0:aa6:7470:8efe with SMTP id a640c23a62f3a-aa6c1af9f66mr142454966b.13.1733957990619;
        Wed, 11 Dec 2024 14:59:50 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa66ef6409esm661697866b.149.2024.12.11.14.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:50 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/14] multipathd: don't call udpate_map() from ghost_delay_tick()
Date: Wed, 11 Dec 2024 23:59:06 +0100
Message-ID: <20241211225909.298770-12-mwilck@suse.com>
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

Instead, move the call into the existing mpvec loop and call update_map()
from checker_finished().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 6d3c3a2..71d5363 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2044,26 +2044,17 @@ missing_uev_wait_tick(struct multipath *mpp, bool *timed_out)
 	return false;
 }
 
-static void
-ghost_delay_tick(struct vectors *vecs)
+static bool
+ghost_delay_tick(struct  multipath * mpp)
 {
-	struct multipath * mpp;
-	int i;
-
-	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		if (mpp->ghost_delay_tick <= 0)
-			continue;
-		if (--mpp->ghost_delay_tick <= 0) {
-			condlog(0, "%s: timed out waiting for active path",
-				mpp->alias);
-			mpp->force_udev_reload = 1;
-			if (update_map(mpp, vecs, 0) != 0) {
-				/* update_map removed map */
-				i--;
-				continue;
-			}
-		}
+	if (mpp->ghost_delay_tick <= 0)
+		return false;
+	if (--mpp->ghost_delay_tick <= 0) {
+		condlog(0, "%s: timed out waiting for active path", mpp->alias);
+		mpp->force_udev_reload = 1;
+		return true;
 	}
+	return false;
 }
 
 static bool deferred_failback_tick(struct multipath *mpp)
@@ -2949,14 +2940,15 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		bool inconsistent, prio_reload, failback_reload;
-		bool uev_wait_reload;
+		bool uev_wait_reload, ghost_reload;
 
 		sync_mpp(vecs, mpp, ticks);
 		inconsistent = mpp->need_reload;
 		prio_reload = update_mpp_prio(mpp);
 		failback_reload = deferred_failback_tick(mpp);
 		uev_wait_reload = missing_uev_wait_tick(mpp, &uev_timed_out);
-		if (uev_wait_reload) {
+		ghost_reload = ghost_delay_tick(mpp);
+		if (uev_wait_reload || ghost_reload) {
 			if (update_map(mpp, vecs, 0)) {
 				/* multipath device deleted */
 				i--;
@@ -2978,7 +2970,6 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 	}
 	if (uev_timed_out && !need_to_delay_reconfig(vecs))
 		unblock_reconfigure();
-	ghost_delay_tick(vecs);
 	partial_retrigger_tick(vecs->pathvec);
 }
 
-- 
2.47.0


Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F9D1AAA05
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145684; cv=none; b=asq8yAS+3ViknO4vqm7aQ4R9rzkYQXLL3a0q+GnjKpsYTqRhLKfOynW51pRcEH2KOxHHPQ2jmm2n53c3Bx9WhYnI+EGPDJEctQQjaI1aGcCvbPvjPHmaVVUxpnieUUmzFuOIpf3VpbeuDxn+CScMyZqJfZcnIAphsY0+goKbZBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145684; c=relaxed/simple;
	bh=/I6EUDHeb4xacp4ztvBF8ffpTYDG15T8Ci7qcb7Bqu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COSVgD+85qjlUjEgOfMC+INZRc5gAczAKFcUTagWTkWWw74Is+F7yNRKpSzg9Yb7awLek1n89SzFjObv4a50bK3UztT0MyXp1/OozWxQaIouxjaJuojvxDhpCysoF92TA8Ve1SBDn+56xYYf80XjN9tFG8U6BRr7BQ/gAUc0YfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OmgFJkRg; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OmgFJkRg"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43618283d48so17473165e9.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145681; x=1737750481; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iokqSG1plG4aytu5apWJLGCl0kDl59YYmG1ZOO86fOA=;
        b=OmgFJkRggF7eRhJ9rnRv+CpJRRoBVN0JMZohMYZedvTJbY7Gkm6R4zdjfl3VNzXH0i
         6ZoEWctLdRUCwGmWEqw3smBboVz4tatBs8GG+VnHL4ECEinoGEPTqma5+v0M/NPpBHDA
         +W+fx2P0LY2thAXIN/FYuWLQX/DPqMxAPzSkmPY0frRZmC/9ukZy/xl5Mu580RHwi6wN
         vKE6JbS888D4ogC3dVjY3K2UC52uo3ynUCfd3a9J8rky9vhzkLIPy6azIAvqVz9Ozb1u
         8/4ffqvE18bZZT12BVnJRxe55w9TejBRh7Gy91i1cNiv4WR1H8NVMfJlhyWgH119m6gl
         kp7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145681; x=1737750481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iokqSG1plG4aytu5apWJLGCl0kDl59YYmG1ZOO86fOA=;
        b=mRxQk73RpKDMjOotvLzdDkr/iVAXuMrhHs6id8Gs2y57jcp3lGao1tjY0leSR+L05h
         CKLngDh/Rvr2FxK9bPAGyPO5EaLTVyVMXgrJFcWt+rWL3soXAquMR1VAOTJaG02R3zlX
         AzqjXUA/RqxgHSxjevZWC4ail5njUqRi6/JrsrcTsOtIQZ4HMjAAbQ3qa4/kyD3Cgzww
         WJoaE8B7HIP4DMBdwwfoFFoohhO/K2ZUpZH2GMQAGzrohOta3Vj9YG5XYm5T+MFPjOdr
         odbm1rAIZ9kB06ND99YGLxID8W8g9NyJLHhcnSceqAR1a932irSV0Huji2LxM9CfrgQ1
         5bxA==
X-Gm-Message-State: AOJu0YxjRI7OVzUTyIcUfpC1fg3vrd7jjHK561676N0JPcHL8HyNmLqG
	YO4U3RSuJdLK7ZVAIMsE+4S0spe4dY/xAhFmd+QdHq4DW6TsC9EyiSvuJqnjw68=
X-Gm-Gg: ASbGncv7e/4rDzwar20N2sLqG1/Jm9D8mdh3F+YC+MQ9D+APvi8X/QkNEmV1xFGXhYI
	B2Tt6jF6E5O76paqqJ5ZZGLiRyYWqvdXsajjLQIBq+90d0LmKaXECUaRYUDGV4KEMEgj+ZpJUXl
	SN6sKrC85rZTQ8r/ZWejIS7kuJvea29ETUbzkwsLAYNqlAU7SBpAPYd2o53H59hk2vqxWMMTUZr
	ACQo7aaAmUyecy12tisDHmiSNlEEsaIx6LzcvCytdNoRmH3Ak3QaRi28wD6zf3kwX3y5ZicMQSs
	SgTzc/d5ttrV9V0k58cBJsxmkY2rwz6U8964cwpCOoI=
X-Google-Smtp-Source: AGHT+IGj4oaFqjKZeS0lGKk1lIVti74jwHFsVOXHuPpyvY8cXrzX/W9nK+fZi9GRX9+kR2457rBmBg==
X-Received: by 2002:a05:600c:3420:b0:436:f3f6:9582 with SMTP id 5b1f17b1804b1-438913cb729mr44778915e9.8.1737145680465;
        Fri, 17 Jan 2025 12:28:00 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-437c7499884sm107255285e9.5.2025.01.17.12.27.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:28:00 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 08/15] multipathd: don't call reload_and_sync_map() from deferred_failback_tick()
Date: Fri, 17 Jan 2025 21:27:31 +0100
Message-ID: <20250117202738.126196-9-mwilck@suse.com>
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

Instead, move the call inside the existing loop over vecs->mpvec and call
reload_and_sync_map() from checker_finished(). Note that we can't simply
put the call deferred_failback_tick() in the "if" condition, because we
need to adjust the ticks even if update_mpp_prio() returns true. For
consistency, use separate bool variables for each condition that would
necessitate a reload.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 6df8769..8c2712d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2076,32 +2076,22 @@ ghost_delay_tick(struct vectors *vecs)
 	}
 }
 
-static void
-deferred_failback_tick (struct vectors *vecs)
+static bool deferred_failback_tick(struct multipath *mpp)
 {
-	struct multipath * mpp;
-	int i;
 	bool need_reload;
 
-	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		/*
-		 * deferred failback getting sooner
-		 */
-		if (mpp->pgfailback > 0 && mpp->failback_tick > 0) {
-			mpp->failback_tick--;
+	if (mpp->pgfailback <= 0 || mpp->failback_tick <= 0)
+		return false;
 
-			if (!mpp->failback_tick &&
-			    need_switch_pathgroup(mpp, &need_reload)) {
-				if (need_reload) {
-					if (reload_and_sync_map(mpp, vecs) == 2) {
-						/* multipath device removed */
-						i--;
-					}
-				} else
-					switch_pathgroup(mpp);
-			}
-		}
+	mpp->failback_tick--;
+	if (!mpp->failback_tick &&
+	    need_switch_pathgroup(mpp, &need_reload)) {
+		if (need_reload)
+			return true;
+		else
+			switch_pathgroup(mpp);
 	}
+	return false;
 }
 
 static void
@@ -2973,11 +2963,13 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 	int i;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		bool inconsistent;
+		bool inconsistent, prio_reload, failback_reload;
 
 		sync_mpp(vecs, mpp, ticks);
 		inconsistent = mpp->need_reload;
-		if (update_mpp_prio(mpp) || inconsistent)
+		prio_reload = update_mpp_prio(mpp);
+		failback_reload = deferred_failback_tick(mpp);
+		if (prio_reload || failback_reload || inconsistent)
 			if (reload_and_sync_map(mpp, vecs) == 2) {
 				/* multipath device deleted */
 				i--;
@@ -2988,7 +2980,6 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 			condlog(1, "BUG: %s; map remained in inconsistent state after reload",
 				mpp->alias);
 	}
-	deferred_failback_tick(vecs);
 	retry_count_tick(vecs->mpvec);
 	missing_uev_wait_tick(vecs);
 	ghost_delay_tick(vecs);
-- 
2.47.1


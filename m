Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3691C548E
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528208; cv=none; b=chdIrqoyNmJElKfBXJfbRSaFLpRo/kP7jDGqaV10ECAsqTTAbcwrZFKCmwkbvrlZ0o/MX7dbMlQfIls/V+40uvCeX9/tLijriFoXNDp7F8a9VMaMn8umGro5fjk4MKdcvObJQ2utT2qQ9Jf5rk6XKgAW28TDWkapZeEpjVGllhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528208; c=relaxed/simple;
	bh=TJUbZMJ/BQnct+rp7MX35gEGnVA9vmc04rNCABtswL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elqurcgDp7ejTEuhHE3j2QAoHIOfQdyPV9H/vBvyEBynVfVfmMyGfyylPktlXUh3tObVEEsoCG4e64jk2/rPa6TNTjbGxfzSB0F8NnKMQUMrJnVZfmeOx1ucRvkKkLf4R6TpumCBHIBph4eKn1UJxqjjevJGF1/DsvRqz4n5BNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BFA6+p9o; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BFA6+p9o"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9f1d76dab1so132292366b.0
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528203; x=1734133003; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=up0bw/sBlDrivAIEU6w0r5sQC4powLACo44lnav8imE=;
        b=BFA6+p9oMHINS1ti78bO3NVAPM/2wYSRS0Z4gilKEz/Xf3y/rIqQrCaFEeGObt+i8t
         yWmImlTOa8GkzXCxzRIiOYyZkRzoGlQpGi2FuOhn6Q+Ct+uCpHuy6UnMD72VXVmR5QrC
         8p3GzADYGPgJuxhxdjTZrEdR2CW+/J8opQp+fPlHr4wytbwotTBsPxL3zwfhJ83XEmoR
         8UkyB6sgz0mQLOEjEA8v4SH3cKsZEbJOfKeGu7futxP3F/GEiWBlGbXAZbm4dZHr3DHk
         jXk8Z3QLtiedeWdUMc6FIrbEUkDvoRNWBMqdnbxLgzXSePmaAMbkZ4Un3C43xA9ye35p
         3MCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528203; x=1734133003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=up0bw/sBlDrivAIEU6w0r5sQC4powLACo44lnav8imE=;
        b=KcV8lJ9QXGvxlj9Lj1AHMZ2eZubF1l2xxIiCcr6haRfbdkMOtwMHiBqiX2C0OyXXht
         Ho7w/Y6xn78O6RFZXYz3T7Fwwz5ZUeSIIqPP50BxQADPY1PZPe+1XAsl1ZDhVJleaoxD
         q6UKFhdNjJ7XFVVSXfGD9wkyWJi/ja8OsALAJkFoh6+PqwGx9fBcBrIw4y4PAcE43jCI
         IlHPvLQ2XrK03R4WdJkluPCz7/0kklYFvJrhnBpNQWKXqEPcKIj+rS9leCO2ajm+mFu/
         +JTI2dFUYLcfw3sTSEBybvE6rMVgrbFinpT59EkOYO2pCVcxV0+t/xWeawPrXvMcxPam
         xj3Q==
X-Gm-Message-State: AOJu0YzUi3OW5Kw/XoaTZokl+K9Puu5v6ZVOBWrIzBbAH2qFDkL9ZYFH
	fsUzn1xtxGrFcnZhkgwVq1VSv0B3ugqwSPanfLk/d/VjP7Ni/28Ka9NHRISRLE8=
X-Gm-Gg: ASbGnculLMA8oopDJZAi/hvBhm5zG+ta0rDtZSRosfLmwjJErvmjeADohfvWcCd+yxj
	LFST5PRGZEJ2ZyeGQGZ2K3BhmOm9h5j7OqEvbK8iTXvlXgqefwP2VNJ4omXv05HrLiZyl8W/CBt
	XhSqLBMyRkS7uMObsQbBKMZjrQ7V2u4p+eIjrrc0LRgB03CVIcKGHhWURSe3tcFjNZr7cQfnjxT
	E0LREHZBW+3358dVR7ZBZ8vimORYbJKPPBT0SkFcBS5sIaMVgzwxKJePa5PPbOkMuFpjnhYd/Da
	0P+Zuqd02t88hsyasUBVK8LqBpU9xCDof0kA
X-Google-Smtp-Source: AGHT+IH/NwhX+bRAfkXjmND55wkBlSKKqof37xT3aXazlTxHSVff8yKduR7jrWOijzmUkiW1GySycg==
X-Received: by 2002:a17:906:3194:b0:aa6:1e70:bc8e with SMTP id a640c23a62f3a-aa63a268950mr483792066b.48.1733528202589;
        Fri, 06 Dec 2024 15:36:42 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa625e92a08sm304708366b.45.2024.12.06.15.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:42 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 01/13] multipathd: don't reload map in update_mpp_prio()
Date: Sat,  7 Dec 2024 00:36:05 +0100
Message-ID: <20241206233617.382200-2-mwilck@suse.com>
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

Rather, return a bool indicating whether checkerloop() should call
reload_and_sync_map().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d7d4a26..fa684e6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2689,25 +2689,25 @@ update_path_state (struct vectors * vecs, struct path * pp)
 	return chkr_new_path_up ? CHECK_PATH_NEW_UP : CHECK_PATH_CHECKED;
 }
 
-static int
-update_mpp_prio(struct vectors *vecs, struct multipath *mpp)
+/* Return value: true if the map needs to be reloaded */
+static bool update_mpp_prio(struct multipath *mpp)
 {
 	bool need_reload, changed;
 	enum prio_update_type prio_update = mpp->prio_update;
 	mpp->prio_update = PRIO_UPDATE_NONE;
 
 	if (mpp->wait_for_udev || prio_update == PRIO_UPDATE_NONE)
-		return 0;
+		return false;
 	condlog(4, "prio refresh");
 
 	changed = update_prio(mpp, prio_update != PRIO_UPDATE_NORMAL);
 	if (prio_update == PRIO_UPDATE_MARGINAL)
-		return reload_and_sync_map(mpp, vecs);
+		return true;
 	if (changed && mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio &&
 	    mpp->pgfailback == -FAILBACK_IMMEDIATE) {
 		condlog(2, "%s: path priorities changed. reloading",
 			mpp->alias);
-		return reload_and_sync_map(mpp, vecs);
+		return true;
 	}
 	if (need_switch_pathgroup(mpp, &need_reload)) {
 		if (mpp->pgfailback > 0 &&
@@ -2718,12 +2718,12 @@ update_mpp_prio(struct vectors *vecs, struct multipath *mpp)
 			 (prio_update == PRIO_UPDATE_NEW_PATH &&
 			  followover_should_failback(mpp))) {
 			if (need_reload)
-				return reload_and_sync_map(mpp, vecs);
+				return true;
 			else
 				switch_pathgroup(mpp);
 		}
 	}
-	return 0;
+	return false;
 }
 
 static int
@@ -3040,13 +3040,11 @@ checkerloop (void *ap)
 							     start_time.tv_sec);
 			if (checker_state == CHECKER_FINISHED) {
 				vector_foreach_slot(vecs->mpvec, mpp, i) {
-					if (update_mpp_prio(vecs, mpp) == 2 ||
-					    (mpp->need_reload &&
-					     mpp->synced_count > 0 &&
-					     reload_and_sync_map(mpp, vecs) == 2)) {
+					if ((update_mpp_prio(mpp) ||
+					     (mpp->need_reload && mpp->synced_count > 0)) &&
+					    reload_and_sync_map(mpp, vecs) == 2)
 						/* multipath device deleted */
 						i--;
-					}
 				}
 			}
 			lock_cleanup_pop(vecs->lock);
-- 
2.47.0


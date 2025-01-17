Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC85F1A9B4D
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145694; cv=none; b=JqLe90MmYKeF9bhFpvMcGNGv27rOwX9KD+q8Oc2m9tMKsYF1uYjJ3HtfVJvFYOimY9/ju6XOcM3w9T8+iSIgIAhQAvkyz/eX7ZYqDlHhq7tPdnO+FTY2A496UFvLX4MEt/wdcScfKBizu2/QgoqbYpIMSFrxU/t8nIQeGuyMghI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145694; c=relaxed/simple;
	bh=fdB+Fgxlk+RDksRPcgzJPFGP3POrrXtb/LhA6De2azs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1ttjk/L+yhiGbXZ5KFbvOxwTvog6HDnZ+Z329a3zLZHFb1QJg0UD+dzJ4J+3cBKnLVLn9p90AzS4xo+jhRC9YcfalewQUwq3PYWp1XwOutAD1Zl/cMybaVL8PegDRdmEXjJI+SF/MaHlkY4z9Fp/19dWhZ4z7mHV5i+Zn8TmCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a1ZUYZJ4; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a1ZUYZJ4"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-436249df846so17087495e9.3
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145691; x=1737750491; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i0fkqNdLYiBF+RU51RO+V2INehDNd1zCcP1iEidomaA=;
        b=a1ZUYZJ4V0n/YfPW4tUFMnYl32J8m3uYyHANuT9BwXwrACbRb9aLZ7Gvtnx8thScSK
         /v4HjVjfA4NFgbPCc9TF72SK1V9eQ8ox8pOYXOp4Sn+qizhxjrx89PaEbuqLSVXECzK9
         nN4b45d2TjVE9yk6u3pxl0/nzycgatsoNre4iXe3+icoTCElxbrO32FCBIulF+EKd2iM
         oAXmMPBF7UZw5nyoXB9FSE/QfHQBEgCAjf+stHb0Zqc3DTQJVtzbXLo5nUOjTn5FcOdR
         YnXoVO/lrueond9KcgQGTIM1g/II0NgSWWsVmAB4mUopTEPlBokTU+8ElPoKuomW8elx
         r1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145691; x=1737750491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i0fkqNdLYiBF+RU51RO+V2INehDNd1zCcP1iEidomaA=;
        b=STIQJg2ejAeYEsqNL/dBPQAetid27dYXLcTCVje1m6IZGW/Q4ecL4Mn3X5tXrF3scv
         CfB33TRoojRbbpTHWvroThdxd1BMfAfNBIfmzfv4TYyw9BEG3BMsbtCWQljGXg5FK1dG
         e0Hk03ag4H1XPUkhn97CvZAczaH8dMGp4E0e8qeiBp7qt9RcbafSGpQI1mPJcvUcF+56
         dR29gPPrvytup+P7J+YQfydmrnLGs1kitaOHsXt+DaBWSha79dAjfLuQpBoJregXJ64s
         gU5OhWy2zar+373In2cWKce64WCMVYzjD4zrsG0R7/SqfjzSM2UmZ8/79BkHptkcWhOS
         Kh2w==
X-Gm-Message-State: AOJu0YxegnHxxh4olDdpzyjO6g+oDQM1fqKc0DhaTPF7Ru7Sg3hJyLJZ
	jbvhpmGxO+LUbChmBSZN0O8i66jvSxjWGKjoVdDSW8fKa9jBcWUww1I778tp8Vk=
X-Gm-Gg: ASbGncsAaV/HqrsUHQ2nxLxgNset5SkdurVRXXTmL4SMhwGxKEgL2n4/EXfVF04r3WJ
	ELT90RYvIwvPfMHenGhLFiZ69xvuFbc+yn79l97q4bNUJ9O+7e1Wa9Mfm983VO1g4pp34MT8BXp
	h0oeuP8aqMEMUviexG9mhnizEDivkU8M9jPOu7nsXmYOA2rsBAAzUCOWRcbMXT67aXiUqqtNSfZ
	2l7bjcGUXNsAxJntfg/j2WHQl2cvMsnDO0dPtnvJVCk4HiYiWaj6bYUWJ5n/x6pTPP+lqXvsjNJ
	d5s9Xj+fQFKwa+aoEwNQNWcUtHe//vKSJNE7HqP3PlA=
X-Google-Smtp-Source: AGHT+IFX18sIVs8IIX4yFuk1VMwCQzqT3BCNJGYu8Xh3F55MzTCqEEbTW8e9IteqoMvlKP1XfrIKUA==
X-Received: by 2002:a05:6000:1863:b0:38a:8d32:274e with SMTP id ffacd0b85a97d-38bf56551famr3788641f8f.5.1737145690754;
        Fri, 17 Jan 2025 12:28:10 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38bf327df12sm3381147f8f.92.2025.01.17.12.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:28:09 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 15/15] multipathd: enable pathgroups in checker_finished()
Date: Fri, 17 Jan 2025 21:27:38 +0100
Message-ID: <20250117202738.126196-16-mwilck@suse.com>
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

multipathd calls enable_group() from update_path_state() if a path in a
previously disabled pathgroup is reinstated. This call may be mistakenly
skipped if the path group status wasn't up-to-date while update_path_state()
was executed. This can happen after applying the previous patch "multipathd:
sync maps at end of checkerloop", if the kernel has disabled the group during
the last checker interval.

Therefore add another check in checker_finished() after calling sync_mpp(),
and enable groups if necessary. This step can be skipped if the map was
reloaded, because after a reload, all pathgroups are enabled by default.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 310d7ef..98abadc 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2917,6 +2917,34 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
 	return CHECKER_FINISHED;
 }
 
+static void enable_pathgroups(struct multipath *mpp)
+{
+	struct pathgroup *pgp;
+	int i;
+
+	vector_foreach_slot(mpp->pg, pgp, i) {
+		struct path *pp;
+		int j;
+
+		if (pgp->status != PGSTATE_DISABLED)
+			continue;
+
+		vector_foreach_slot(pgp->paths, pp, j) {
+			if (pp->state != PATH_UP)
+				continue;
+
+			if (dm_enablegroup(mpp->alias, i + 1) == 0) {
+				condlog(2, "%s: enabled pathgroup #%i",
+					mpp->alias, i + 1);
+				pgp->status = PGSTATE_ENABLED;
+			} else
+				condlog(2, "%s: failed to enable pathgroup #%i",
+					mpp->alias, i + 1);
+			break;
+		}
+	}
+}
+
 static void checker_finished(struct vectors *vecs, unsigned int ticks)
 {
 	struct multipath *mpp;
@@ -2943,12 +2971,16 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 				i--;
 				continue;
 			}
-		} else if (prio_reload || failback_reload || ghost_reload || inconsistent)
+		} else if (prio_reload || failback_reload || ghost_reload || inconsistent) {
 			if (reload_and_sync_map(mpp, vecs) == 2) {
 				/* multipath device deleted */
 				i--;
 				continue;
 			}
+		} else
+			/* not necessary after map reloads */
+			enable_pathgroups(mpp);
+
 		/* need_reload was cleared in dm_addmap and then set again */
 		if (inconsistent && mpp->need_reload)
 			condlog(1, "BUG: %s; map remained in inconsistent state after reload",
-- 
2.47.1


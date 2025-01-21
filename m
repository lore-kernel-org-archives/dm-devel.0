Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1547B1B425A
	for <dm-devel@lists.linux.dev>; Tue, 21 Jan 2025 11:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737459969; cv=none; b=li4sDuUIeD6koPk2XhVXUffiOFvqOM0UqzuWvvL2+idiOobjeuDG+5P2h6v32GKt8JGToGk37thciRsGbZ1r2dmRwICwGdChm0sUUk4K2VU0eaFKxFqigbLidF1QMMMWRw1jOjDJ401mCLIDucgk+dLa1O88GIGHCgPrprrWlEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737459969; c=relaxed/simple;
	bh=Bw+SZTbGoucliq+u8aiJTw4W/6zWrst/BtF4sUb8YPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf32FLvR8RY1deMuAveA6uv+P7W08fkLt/w4Y+CERvvH5xXOZUL+bfLbrhcACnAJkLh32STuUTWqM7Byx45srwLqllrVkupq/E5wz3PcztbkB9vex95pWhBBxVO1ttNyPjZSuFxx3cYZ2xg5mG2AvNcgcLxOb6ZOVtMq/xLcR/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Q8zTDMeU; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Q8zTDMeU"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ab2aea81cd8so929086766b.2
        for <dm-devel@lists.linux.dev>; Tue, 21 Jan 2025 03:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737459965; x=1738064765; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iuWGvHoE0pZwhH+DFNsjgXXtXS6FOkY/gXA30+toKiI=;
        b=Q8zTDMeUlY7FZTrdw0Mtc4zPcxFtSNadh5gLDnEQ+1U7YIae1W6O5Xdq8zJqDZCs7D
         oCRxiRWfcVzLY2DpVzXBU91zZVmjqI70wimyNj2pVkgJTpLZuBR/PAfMGHvVNQWFdVyd
         fZqoykeX0UZ8o6NOe4ORVXBb7U8PJzBDiW3gGD0WqWowARlY0a+OPiEPyQb49hBGhe3o
         OsQpMKm2j1V4JtMh4e2YoSdih2Th2Q3sGSxapyyFxOhSTwRZELXtdRoa+ZIIzB39EORD
         R7n+sWXI3h5+eWJ2lkXVsTAgCrG/MTPkUSpe/lOeFqbSL+VV6pu8y/EFhUeNfBhndkRz
         CLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737459965; x=1738064765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iuWGvHoE0pZwhH+DFNsjgXXtXS6FOkY/gXA30+toKiI=;
        b=C6lGvvsBLiKbiiwX9V2TC08xLcjCPRlHqJyEDC6fJ7b5muN8+paDfBfWW2uBL9KF81
         X5kOnEUvU41Hv3Bb1NlW54UbO3yokPpwpPlYB+bqrj8ixrkseE+65y1zHeAnKZK8IRpM
         k4ioln7Bdjk0XOyGtAD/LHDIiMoRdSN4jW8y/+NNtlp2SQcFt8Fxlp2oLuwp9Lt1QE4W
         q7zY8/MdXl9JUmBcZHeWUD4V0tm0weYZ34Uy06vwPDGWCcdhPf/ekKFH4MySk+VSafLY
         MkQG78iNCJrKTaikfUTmwNgqu4bMIjAPWZIxk3blGpRo2hkUmuIl7I79HgZnZFTuR6X2
         yJ6g==
X-Gm-Message-State: AOJu0YzlFAQ4Wo+d0d0CjnIaq2uoTHVzDDCQM3lIhptVmdiAP2RcA7r8
	oOj7HU2arKbjB9lCfQfKXdSdVKgzAFxNaL4P34hGUXyVwbaDU8qQBh59zNjbiz7nLX0Z6mTpkeX
	K
X-Gm-Gg: ASbGnctiFynpx+Q+Mk2YSI2EI7b8MH5iJ7HM4yWanVRygFPjZBiLFRTcTrrkF40rEnx
	lCcsp+FI/DKmFYj8OW73X4WD7dR5Lkr+0Cr6H9Wejms91G1CahDn/lRyFfCCrkdBouDlvc1/SUS
	LqVeTOMm54tiZvGZjsUQ32wdWlyClkC/koeKVZQVFPJTSd6j+rSyILIZtDzRniY8iB4oq5mQ1d1
	KuPBMPvlGxbVs67vp96lwcC7yLW3mR+rifrz7iaiuRB6C4djiMDzRnqvsFA/6cNvWE6fyvyvgfl
	q15MshG7rzhglJDIs7jbaRC+0mmD6rQ1R0Cx4PY+eMP2U9PYEdhU994U
X-Google-Smtp-Source: AGHT+IFMxOPcUpxPfIGbJjm9k8JGUzZajyQZL8DDO/UJVN2NPIekkrXWGtWhe7OcZjN7zzmFgjC8rw==
X-Received: by 2002:a17:907:3e1e:b0:aab:eefd:4ceb with SMTP id a640c23a62f3a-ab38b0a2b92mr1668327366b.10.1737459964987;
        Tue, 21 Jan 2025 03:46:04 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-ab384ce0172sm732868666b.44.2025.01.21.03.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 03:46:04 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v4 15/15] multipathd: enable pathgroups in checker_finished()
Date: Tue, 21 Jan 2025 12:45:38 +0100
Message-ID: <20250121114538.31963-2-mwilck@suse.com>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250121114538.31963-1-mwilck@suse.com>
References: <20250121114538.31963-1-mwilck@suse.com>
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
 multipathd/main.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 310d7ef..2052ede 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2917,6 +2917,36 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
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
+			if (!(pp->state == PATH_UP &&
+			      (pp->is_checked == CHECK_PATH_CHECKED ||
+			       pp->is_checked == CHECK_PATH_NEW_UP)))
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
@@ -2943,12 +2973,16 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
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
2.48.0


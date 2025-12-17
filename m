Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1C92FFDDC
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006489; cv=none; b=rKyNaxM6IMAnehOkQKbS/+fAWn3mSmvKHZsyA3of2IAWMHl//bWaRYDIqclsFEU77tZaKQrVwaJJ2ddINwEOkU36Rn9MAg9tQXRuQ6USL9BO8HBSB5xGpHuBHZigJCcSZhhJtNaVDDeamFeuMNoDbOyTcLUc0PqJGOSCn0HWqfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006489; c=relaxed/simple;
	bh=9b82XPAUKJTfGZeUtjivujsFmAk+V7+4B2OjJZE9eaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccolnFIu+nByTL8dg7Bu1qptiZjclpiQLDMuw0QmKntk1LYVxrHOZlQ0YFC7/bLNGcK91qEjPAeVKXBIzo99zcI7nAXoSXwfgGnnHg7vMTN9sA+rfCCxc9llgyWQhPSfzIJKj1EbcYSD0hr26rDp5rVToSlRBa1yuprzF/5HkGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HKTdwXYB; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HKTdwXYB"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-649820b4b3aso4802392a12.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006485; x=1766611285; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TR0T83dq/XLmU9sA8OB9nubnwgJpGdbivhC9ApfgFpg=;
        b=HKTdwXYB9PNQQCtnW7jJcJF4rovtMMWchPqMODVzoLez4APXt6IzWE3N1vUUBaVQYy
         U9yOMnYVeVk3cvtVWLDHTcPJNeAxa6gFbN2n4D/M3ZMLCi/yZpUkfAa2kMaAkjMmyoVL
         yn4Q+vlXafDIno3RfH7+0MJtQ8SQF06LYuOsWMeJEkdlsG2s2q733sqGPy4r8NqRbpyi
         nfDJ5O0qu64hiuRBsq3CEEreWFoh5jG56Er1Zmc12ziOCHjiqp1mtBDI3g+MiJHb9K76
         vBhaaO8sX6jB1LnVGnKEllDe3ITwiXuDsa31WXxDsDRaZR3CKGIeJ3dkrvo3pvNM+qhw
         kaMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006485; x=1766611285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TR0T83dq/XLmU9sA8OB9nubnwgJpGdbivhC9ApfgFpg=;
        b=VRQ4MZ1Lo9qqS8C3J1AC6bXuntuUWP9SzEG6F0Mgh9Yk0TjmZDce3/sBckCPJmE0it
         Lk9gQlQAgMnXspLTiSA+ZYQCRiLxKBg0fAXWl62WnntnKEc90MTFXbXE1//L4vASZu87
         r1SXXSUCP//Eic5s5I5f/M++MlZmGfIt9L0zfFO+pqcMqtJ7qlVTkaNibGAwOU1AMFB+
         ZME+hKDi3DRSHWD00JoeUsyIQevcnoH/1fMfL7QHFJ0y7/BIYC8VqfEEOZZXXnTLDshf
         TfWSeUMwtN+bZW63O+nJHuMkDouDLuDA1H/3B7yV/elX52dWhw6/ES9xZKoCEQ2S1WPb
         lHHg==
X-Gm-Message-State: AOJu0Ywy1Yv1R0nRG0A10bWydE3+KWtG1zm7hU34Kyhnh9qaZn/IWFds
	Tbo9nP90JMRXyYqxFU+3X7DfNH2VaecYOb8rUQ5Zc3eg9KGcRJNLgohECCkbcZmPHrPi6zfgye2
	zVuht
X-Gm-Gg: AY/fxX7xCB5slykMIgBdAmQ3V+Bq/WlDHVNh6DYLSH2+O7kurWPmauxqfokfQu38CUR
	ys+giQmXFEsbz0Xo96EVtFkXB2mAIv453EwqONOHrTKjDPHB87UsP5xXkvGA98chD1nsQBeqCgf
	2kGBlGjGFc96G5zB/zp2Xxoe5UBdxB6PKck25Nq8B6wl+fTREyTMFgCD4HFl4MqrQlfE9R9h2B4
	JRxxT3CigDaw64dWEvGLDMOTmZphDj/SbShXtjCXa9ig9TXw/AmgNmMFnzar8y55hAZhZIhU+xz
	gIuzChsZB2VqUHNyZRIThiiEbFMeS6RY+vv2YwQXQCDaT83YbnyGzXm5IEBT1Q1JBYs6g1wkEI7
	wI2Al8YSxgU1L5V1RTlIzR5tRlihpu+EmzQ3sM3LwCJUTeH/BWpsKbMGQvGquw+kZZtPWmfZdmI
	qyqGimCihj/VTOTXDfI4O4sJj8mZCr1mEAt3kztBus8gFChpa0arSiJiflmtE3SAp86lvx6KCUj
	g==
X-Google-Smtp-Source: AGHT+IGBdxETeuRFGql+w4OtB5WQIf0VLXTbiAU3Fp+7mkMZWUJq7W87L2Ww0ewxuwg1jEIq3vhSbQ==
X-Received: by 2002:a17:907:1c0a:b0:b40:b54d:e687 with SMTP id a640c23a62f3a-b7d23ad8ce8mr1853613466b.47.1766006485172;
        Wed, 17 Dec 2025 13:21:25 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8023466002sm28447066b.35.2025.12.17.13.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:24 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 04/21] libmultipath: don't touch mpvec in remove_map()
Date: Wed, 17 Dec 2025 22:20:56 +0100
Message-ID: <20251217212113.234959-5-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the removal of an mpp from the mpvec into a separate function,
remove_map_from_mpvec(). There should be no functional differences
so far.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c          | 14 +++++++-------
 libmultipath/libmultipath.version |  1 +
 libmultipath/structs_vec.c        | 26 +++++++++++++-------------
 libmultipath/structs_vec.h        |  3 ++-
 multipath/main.c                  |  8 ++++----
 multipathd/main.c                 | 17 ++++++++++-------
 6 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index baa1357..2d324ad 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1140,7 +1140,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 
 		if (!mpp->paths) {
 			condlog(0, "%s: skip coalesce (no paths)", mpp->alias);
-			remove_map(mpp, vecs->pathvec, NULL);
+			remove_map(mpp, vecs->pathvec);
 			continue;
 		}
 
@@ -1172,7 +1172,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 		if (cmd == CMD_DRY_RUN && mpp->action == ACT_UNDEF)
 			mpp->action = ACT_DRY_RUN;
 		if (setup_map(mpp, &params, vecs)) {
-			remove_map(mpp, vecs->pathvec, NULL);
+			remove_map(mpp, vecs->pathvec);
 			continue;
 		}
 
@@ -1192,7 +1192,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 				condlog(2, "%s: %s map",
 					mpp->alias, (mpp->action == ACT_CREATE)?
 					"ignoring" : "removing");
-				remove_map(mpp, vecs->pathvec, NULL);
+				remove_map(mpp, vecs->pathvec);
 				continue;
 			} else /* if (r == DOMAP_RETRY && !is_daemon) */ {
 				ret = CP_RETRY;
@@ -1201,7 +1201,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 		}
 		if (r == DOMAP_DRY) {
 			if (!vector_alloc_slot(newmp)) {
-				remove_map(mpp, vecs->pathvec, NULL);
+				remove_map(mpp, vecs->pathvec);
 				goto out;
 			}
 			vector_set_slot(newmp, mpp);
@@ -1224,20 +1224,20 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 
 		if (mpp->action != ACT_REJECT) {
 			if (!vector_alloc_slot(newmp)) {
-				remove_map(mpp, vecs->pathvec, NULL);
+				remove_map(mpp, vecs->pathvec);
 				goto out;
 			}
 			vector_set_slot(newmp, mpp);
 		}
 		else
-			remove_map(mpp, vecs->pathvec, NULL);
+			remove_map(mpp, vecs->pathvec);
 	}
 	ret = CP_OK;
 out:
 	free(size_mismatch_seen);
 	if (!mpvec) {
 		vector_foreach_slot (newmp, mpp, i)
-			remove_map(mpp, vecs->pathvec, NULL);
+			remove_map(mpp, vecs->pathvec);
 		vector_free(newmp);
 	}
 	return ret;
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index e5b7b83..9282ff2 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -160,6 +160,7 @@ global:
 	remove_map;
 	remove_map_by_alias;
 	remove_map_callback;
+	remove_map_from_mpvec;
 	remove_maps;
 	remove_wwid;
 	replace_wwids;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 3a9ab58..7f5da21 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -420,11 +420,16 @@ void remove_map_callback(struct multipath *mpp __attribute__((unused)))
 {
 }
 
-void
-remove_map(struct multipath *mpp, vector pathvec, vector mpvec)
+void remove_map_from_mpvec(const struct multipath *mpp, vector mpvec)
 {
-	int i;
+	int i = find_slot(mpvec, mpp);
 
+	if (i != -1)
+		vector_del_slot(mpvec, i);
+}
+
+void remove_map(struct multipath *mpp, vector pathvec)
+{
 	remove_map_callback(mpp);
 
 	free_pathvec(mpp->paths, KEEP_PATHS);
@@ -436,13 +441,6 @@ remove_map(struct multipath *mpp, vector pathvec, vector mpvec)
 	 */
 	orphan_paths(pathvec, mpp, "map removed internally");
 
-	if (mpvec &&
-	    (i = find_slot(mpvec, (void *)mpp)) != -1)
-		vector_del_slot(mpvec, i);
-
-	/*
-	 * final free
-	 */
 	free_multipath(mpp, KEEP_PATHS);
 }
 
@@ -452,7 +450,8 @@ remove_map_by_alias(const char *alias, struct vectors * vecs)
 	struct multipath * mpp = find_mp_by_alias(vecs->mpvec, alias);
 	if (mpp) {
 		condlog(2, "%s: removing map by alias", alias);
-		remove_map(mpp, vecs->pathvec, vecs->mpvec);
+		remove_map_from_mpvec(mpp, vecs->mpvec);
+		remove_map(mpp, vecs->pathvec);
 	}
 }
 
@@ -466,7 +465,7 @@ remove_maps(struct vectors * vecs)
 		return;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i)
-		remove_map(mpp, vecs->pathvec, NULL);
+		remove_map(mpp, vecs->pathvec);
 
 	vector_free(vecs->mpvec);
 	vecs->mpvec = NULL;
@@ -831,7 +830,8 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
 	return mpp;
 
 out:
-	remove_map(mpp, vecs->pathvec, vecs->mpvec);
+	remove_map_from_mpvec(mpp, vecs->mpvec);
+	remove_map(mpp, vecs->pathvec);
 	return NULL;
 }
 
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index cb02d75..89e4213 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -24,7 +24,8 @@ int update_mpp_paths(struct multipath * mpp, vector pathvec);
 int update_multipath_strings (struct multipath *mpp, vector pathvec);
 void extract_hwe_from_path(struct multipath * mpp);
 
-void remove_map (struct multipath *mpp, vector pathvec, vector mpvec);
+void remove_map_from_mpvec(const struct multipath *mpp, vector mpvec);
+void remove_map(struct multipath *mpp, vector pathvec);
 void remove_map_by_alias(const char *alias, struct vectors * vecs);
 void remove_maps (struct vectors * vecs);
 
diff --git a/multipath/main.c b/multipath/main.c
index f2adcde..58db288 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -181,15 +181,15 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 		if (refwwid && strlen(refwwid) &&
 		    strncmp(mpp->wwid, refwwid, WWID_SIZE)) {
 			condlog(3, "skip map %s: out of scope", mpp->alias);
-			remove_map(mpp, pathvec, curmp);
-			i--;
+			vector_del_slot(curmp, i--);
+			remove_map(mpp, pathvec);
 			continue;
 		}
 
 		if (update_multipath_table(mpp, pathvec, flags) != DMP_OK) {
 			condlog(1, "error parsing map %s", mpp->wwid);
-			remove_map(mpp, pathvec, curmp);
-			i--;
+			vector_del_slot(curmp, i--);
+			remove_map(mpp, pathvec);
 			continue;
 		}
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 49a1f25..2043ff3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -480,7 +480,8 @@ remove_map_and_stop_waiter(struct multipath *mpp, struct vectors *vecs)
 	condlog(3, "%s: removing map from internal tables", mpp->alias);
 	if (!poll_dmevents)
 		stop_waiter_thread(mpp);
-	remove_map(mpp, vecs->pathvec, vecs->mpvec);
+	remove_map_from_mpvec(mpp, vecs->mpvec);
+	remove_map(mpp, vecs->pathvec);
 }
 
 static void
@@ -745,7 +746,8 @@ retry:
 fail:
 	if (new_map && wait_for_events(mpp, vecs)) {
 		condlog(0, "%s: failed to create new map", mpp->alias);
-		remove_map(mpp, vecs->pathvec, vecs->mpvec);
+		remove_map_from_mpvec(mpp, vecs->mpvec);
+		remove_map(mpp, vecs->pathvec);
 		return 1;
 	}
 
@@ -1439,7 +1441,8 @@ rescan:
 		goto fail;
 
 fail_map:
-	remove_map(mpp, vecs->pathvec, vecs->mpvec);
+	remove_map_from_mpvec(mpp, vecs->mpvec);
+	remove_map(mpp, vecs->pathvec);
 fail:
 	orphan_path(pp, "failed to add path");
 	return 1;
@@ -1837,8 +1840,8 @@ map_discovery (struct vectors * vecs)
 
 	vector_foreach_slot (vecs->mpvec, mpp, i)
 		if (update_multipath_table(mpp, vecs->pathvec, DI_DISCOVERY) != DMP_OK) {
-			remove_map(mpp, vecs->pathvec, vecs->mpvec);
-			i--;
+			vector_del_slot(vecs->mpvec, i--);
+			remove_map(mpp, vecs->pathvec);
 		}
 
 	return 0;
@@ -3353,8 +3356,8 @@ configure (struct vectors * vecs, enum force_reload_types reload_type)
 	 */
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		if (wait_for_events(mpp, vecs)) {
-			remove_map(mpp, vecs->pathvec, vecs->mpvec);
-			i--;
+			vector_del_slot(vecs->mpvec, i--);
+			remove_map(mpp, vecs->pathvec);
 			continue;
 		}
 		if (setup_multipath(vecs, mpp))
-- 
2.52.0


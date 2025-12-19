Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673A422DFA5
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155285; cv=none; b=smw52btzx49T2xwzEMc98ujciwnfBJA+XEQ0cwD8e0o0IR9eqbW2wfqeuZKCVJbvd8fvRs9e+Q507gvIZqi0xaHn756iC42NhquyA+9aQk2IUL51uI++4Eq5iwJEon0S+OFcvXxSX1cxHQWvMyVS2ZOm+UxebMZmVKRW02JtkjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155285; c=relaxed/simple;
	bh=ZrwFEOrOPDAdQlSlfL5Z7/4NPCITysAgkvNTP0GpVTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxCg/7g5bjhAc7o5iqXraCHNRcdYQp3PtKQd/sx6TQWLKUyc70paJItCTNb2f4G2rxXG5oMG8gzjjocK4Ktear8B3vsiN6Y+ac89chwOyLNX5EChk6kwGn8oPO9o5JaLk8gzI0jKr9NJcobW8JL/0vCYkPB4HPvHIXeEKpFm3+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C2G5cBc2; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C2G5cBc2"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b73161849e1so414086266b.2
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155281; x=1766760081; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MI0vCrIP28WJPWzz4K6iCih/4FnB4pssl1K8ZD0L6vw=;
        b=C2G5cBc2XeP3FYJ05eAh8BiddgK50fBHy5y6exKlds16FxlvD0iUrCrMZbaviPoxu1
         uWMc5x1ZX9G74lpBgOzkGIjMlevxDN2XwSDFq0eI6hASO/ZlgufjwZPETSDeFFjxPHTa
         7Q65VQjKdALxteK6dSRFYXYmcaHe0kvxpMe6aZwme+C9c5Zrx4h0doDsUxyeY1YoVFkD
         O1W3R1N9tcKRYJv4q1m5gTOnIRPDnyMBu9pauP6KZa7TrLKEBHp+nei3q6vIO9aoTV7B
         ixFzgVfixuDE+PnB9+80PjbyatHyNtbOUA0Q1IRmImzK188lCBESnXvEAsbZY6hHDQgQ
         +NxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155281; x=1766760081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MI0vCrIP28WJPWzz4K6iCih/4FnB4pssl1K8ZD0L6vw=;
        b=nIhlhEYjxFJ+u1hgAIs3ip9Zqq0RwQjdxQLHUev6gPZFLlQaThsebK8hVR7g/E/J8f
         irf3BwapuBWthfzVCpmBdW/OefgsUxiP65Y0Ib8dXkYg7umtiKCedv7SoIRctq7VyrGp
         MYZwdPw7ORl5JcdqLNZRgIGfFuo9UgzeFhe+wjgC4d1NZHtEh/Tm0jJYp7I5WVyHy32G
         5URJr/4nV7yAFWxc5Xb0Wh6dXDVvGCMdwn8qebYnUE4kQolHyE+g2m2OP8eit2jSftrg
         l8tcPJUP/B4WeShFpsr84VB3s+kxkr00LOhO44Mmz7SQZoIRxjgX2h6riURI0asr367y
         A1sA==
X-Gm-Message-State: AOJu0Ywy/viUsCqF45cc5c77JTN6e5kOJJm4ko6iyUtqgPGwBtp98/IK
	CLVAraRG5yAzefdfIe1mHddrQcnei6Aoj9V0sXB/gbTbvp5ljt8P2Ur1tXf14emasV0=
X-Gm-Gg: AY/fxX4a1w+8fUjCao6AtwrrKubcmQME7ew+QEKpJUQ3GaYpy9O/4rKga2qMIExB5ZU
	oQyk2i+hv74Fbd18JrtStb8rpy6x/PipeR8lKEw1W4SNsfVdmaYFcrCbSjwlSb3m8inhqEN7OI9
	qanuCFBeExL8fGW/oVsf1ZiqmiW9pB36052RTT9nF0x8C3XFX4zhRcUj2olnWgHHFN7g7DJsx0y
	uD5wePKPoII05p6iYf7WOauNK378htvkqMbsEn4NS8DVQS4N9o4pop1ydRkV6mZ1qH8A5zMlcCf
	yZHwxCZ13NVTWiW8OrCKnfWpcGw405ZnXux6ClYslPErIwU1ofgfAuV0g3F2jZHeo/7gf2lUU9t
	ikIiFW6ZpCkYmPuaB2jyTCQiLXhggoIKlZJi3tV22OjiOp5OPJX8dnbcMET08yW08m+aBfyy2yw
	HUbz5J0K+JIn2BuMwjibucHo5LL/7okgLzEpXjvNNqefiPzShHejHAnjVU6sldL8LKK0EfmVYgF
	67a/umpWCyn
X-Google-Smtp-Source: AGHT+IERsj47mU5qvb6CvjRnXZ1uRIYBkTk7R4IjKv8Zkun6E21dsiYEccFCsPaiBrwwQ/ASJiwmwQ==
X-Received: by 2002:a17:907:1c1d:b0:b7c:f5b6:bb52 with SMTP id a640c23a62f3a-b8037198fa2mr328675266b.43.1766155281346;
        Fri, 19 Dec 2025 06:41:21 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037a60500sm241767466b.13.2025.12.19.06.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:20 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/26] libmultipath: don't touch mpvec in remove_map()
Date: Fri, 19 Dec 2025 15:40:46 +0100
Message-ID: <20251219144108.237928-5-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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
index 89ae2a3..30b282f 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -159,6 +159,7 @@ global:
 	remove_map;
 	remove_map_by_alias;
 	remove_map_callback;
+	remove_map_from_mpvec;
 	remove_maps;
 	remove_wwid;
 	replace_wwids;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f651b29..7bceeb6 100644
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
@@ -832,7 +831,8 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
 	return mpp;
 
 out:
-	remove_map(mpp, vecs->pathvec, vecs->mpvec);
+	remove_map_from_mpvec(mpp, vecs->mpvec);
+	remove_map(mpp, vecs->pathvec);
 	return NULL;
 }
 
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 1188ada..1eedfc8 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -23,7 +23,8 @@ int update_mpp_paths(struct multipath * mpp, vector pathvec);
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
index d3bf4d0..6c29d5e 100644
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
@@ -3352,8 +3355,8 @@ configure (struct vectors * vecs, enum force_reload_types reload_type)
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


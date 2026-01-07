Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8038A338582
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817128; cv=none; b=TNhA3C2r7gzFTu5U9jSigrcnwvvl6JABGbpNwbz2c8otHc6NQEWV3zpQzeoszxLhz+eiD5/TKZHp/FnE20fP+7TpTEeKjXIK1s7Y328DbpD3LnXFcikkjpXH3xRo3eMWhbjf1YMfCcOoQxwjkJAOUvpaf8Wt6Bny2IMy0PsaKxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817128; c=relaxed/simple;
	bh=cy/ZHRWA8FqD/hti0Jlyr1D3RdAJYtBLZEv5lU423TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxUZxfHmTEGsOlqm6tj99sOZsgjwcEmc7a3vzfnNmPjTWLLc9AhU+3htHx19WVzUzdCfTrfM1SdIFGxx9kyFbZer8ezi42s/qnoevpjS3yt2NlxtUKO1wQ7D35oD2X29WJ8d0khe54VeDpsH/FFGNxxCErzxcOMBhdiPtYxFosQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BogMCtLA; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BogMCtLA"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b76b5afdf04so474314666b.1
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817125; x=1768421925; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kaWs/YKCaNzyF8duL3a6jiWci5MJyAQAvuVBeoaNxr0=;
        b=BogMCtLAGnC8ZcN2pvtB6aFAGmwQ4z84dNppr176eHrqHMdPJx0H1AXkRJ5fvP6Jfr
         SfrBch2cxSaMrBrxEuvQ0MUKszihg/Oktc4IyzjGAtqSE9Ngh4YWN/jYP2x7XNCUBoE/
         +TPGLpXicYVzmUmshNd88P2kqB5QhHCzzp8JgHYuNgHZO5jM4lOxM8xrza8d97fO77cp
         eiyAeJKOtFEO8vo08ok7hF56YKbcGeQZ4okKHqpdKLkNw67lBOZMWRq1FX4wV0sC9zF/
         y/75AfZfyEBlLTFbEdUGffz8xS2c6W0dAVdkDcHoPOgYcl1jjyoKP/Yl6TEh4FRp6Ebq
         oUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817125; x=1768421925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kaWs/YKCaNzyF8duL3a6jiWci5MJyAQAvuVBeoaNxr0=;
        b=WPU4mfvntj/IL6tP9nIlJ2auASsFHYPYlp+AmKhBxicfMYwfnROGQp8U3sVqmwQOmK
         aXCQhOztY4cSCWmj/ysVg6vTCHZVk1qJuFb04UfCx7goo7VQIdtS+6wHdR86xBfcLXDN
         FDFBiDQqV5i+joUgjQZJG2AjQBo5F0J6UZjdmz0iqN+8FJKFmP8g5iHxiAE10Yu9V+d8
         gGECYd75dHHPjp089XltWkh51IDQNnarjK+At1vrlWI5XAPWwUeY6Re2ClcK3Lr5CrXt
         V2XFHplIhC7LJqXgy859e8n/oZNv2VyTJUTvHNFI8W5c4M0nh7CJHwm8vcNJBjoyap9H
         7EJw==
X-Gm-Message-State: AOJu0Yx54myc7ZLvbeq5LmzeKxoRAUaPbjAPKT+xz5eQP39MuRp9HKmZ
	lYTrJ6SmgeMhm/+AELtYOhCVq0Q4SRWkm0ooGsP+LWDGCaFFbB86PgtiOJw1tTqma69pIoUF/DH
	37GQM
X-Gm-Gg: AY/fxX5Y+g12z0mFFLEZJF/pyF8n3+8C1D9a3mcp1ik7P5ye7xNliPXLiaeEvwrsaCt
	ZEJ9XfxSwnlbaCoewwb98eeVc92r8U8PEHQYMDqeVkQYC/tQUBvP2fKJQYYSeG/pyMKpFpNu/DM
	H34rR/zkM/PbTuXgs8zzeXEVQEP4lc++80JFozm6+loES9lCfiJ0n9uJ94RoBnakYAtgW39BZpb
	I9u6UWgGlTBPPaf/p7q+oH5q7advb+hLbod+bKgd6E/mmqS00ThgrUHTxzt4/u8/MwbrpL5TU1p
	G3DME+VS1bAoOVbpjyKmWgh2IGshd3EN5gL29gsZVyVDnxZPOKUzQV3AC+q4agQWWDHGcrkcYN2
	wHjoAvq0jljlIwkrcRJ7y1q58rxnMn3Ur61KWBxfCCwTa+FZoKGvRczbcuKEl5eMu68MinS79Zm
	WHIfqb3mBUg4zeReeKsaLCCnW/bvHD+SjxwkHrP8guGQuy9KlpWZ0gOlmXxdr1lfEhQyeaVbfmN
	w==
X-Google-Smtp-Source: AGHT+IHbDMM4RuXMhMIJLmKHw372IpvIRs4iVOc4DFmlL454YxxBqNOKII0JfbaODCu6jqw6gv3Dsg==
X-Received: by 2002:a17:907:1c0d:b0:b7a:6eed:b590 with SMTP id a640c23a62f3a-b84451f397cmr425046466b.25.1767817124643;
        Wed, 07 Jan 2026 12:18:44 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a5118d3sm608516766b.47.2026.01.07.12.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:44 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 04/26] libmultipath: don't touch mpvec in remove_map()
Date: Wed,  7 Jan 2026 21:18:04 +0100
Message-ID: <20260107201826.323977-5-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
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
index 5017a54..e971af0 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -158,6 +158,7 @@ global:
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


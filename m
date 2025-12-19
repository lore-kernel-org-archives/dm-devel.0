Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5A83246F3
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155299; cv=none; b=SWd5khhxhO5ETTpOVY981q/Ka72nbzWIwKIxii5EpNm06grzVHA8aVLQssq1f1331wFN4sg4ZPzZIT4n+fAjodarezzuNs6WMAeA2m1HCPQj3jUdi7uAfm4f8nuG6Q4+MM6rtRrhI+m9Itwfcm1ULePFhcnKFs+H6PK/OA/pD5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155299; c=relaxed/simple;
	bh=ZwgnT9aD3Kbz9O8SN2JXxNroccmlZJ1z8Zfm/ifqxp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0yMVlZH1+0j4HGCdVcaIcaSzXPGp8KRQ4xwuSiYGVTS8LF8+1qoIkg7jKfegptwwaTkmFb6/N2+iOYX4CWpHl0OSFZIZ9IPi1R4k3TsRUqfKrTwaqBIU4tg2chHsNJaVjbYg5FadSnIQ4LReoUgplrDxVeolHlmWYy32dNWy9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SzqCEBta; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SzqCEBta"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b727f452fffso473197866b.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155295; x=1766760095; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krHFRXsxToJI2HknXCGGttJadcG02oOcAEZ2zNN92Tw=;
        b=SzqCEBtahAM8tyfcq1V/rv/dskuKJRYbZUOC0mFgNYS5LWKehNYIVc67BJRBWcrGIX
         aft/ovpQwLsfv/JsxXCsn5XP6D00XyFAO/pi6dzWJTCNouik+COcjJrGe9L67KJLbgf1
         Iw0ZwDda26etjBFgewrq2iSg0a6/amIf7zmWV9b4J1Btf3cvr6VWeYTnpfZ+6nC2vbKn
         EVMp7YjJlMX7DMv34DcnmEvYaj34+qEtB522WzK4feAgwzsvexQdpHsux0Osyf44LliX
         92Y9/fR8fYQIruJr7wpr6B1CZ8AcH1PuMBi5FGw0wsxu4bGovwA4eVEvoK+GakN634CO
         j5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155295; x=1766760095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=krHFRXsxToJI2HknXCGGttJadcG02oOcAEZ2zNN92Tw=;
        b=fl9NHlIR2KO/4LGXuImKU9/NDdo8QXVH4BcMiw/1m4DJTBLUhCZGode9OX4WNjHIsG
         tH/yHfPfB7gIViWBijepuWJBC9bLWsRRtBdgnoaRiWQxSYwCVrJLRkcCmnQeJT1AuF5A
         B69oAiIeDteMBDJFnHR91DtBvZoR0xRHccf+mBZJlXzgAa3hnYrBGP2+kEJfK/kU/wi5
         HthGux9QvedCOLERNIvOPBmVo4JAS2YhYDrqIciRn1d64FW/j6Dy8ZjPFwOnstLw8IVY
         4+a9zch5b8edl0ACCAdolPrtwjTYEMmO1+BxGsEQuPe/AYdl0U+z8HUWRQMmM4VPF4rc
         PzIg==
X-Gm-Message-State: AOJu0YxPOgqtgWbNsreaHqjwYjFNnmWZmKBxUoOp6PbpOJP4Z0VPR2xE
	zq5+nDdknucLtz1vKsn0hbzEWJd8oywEVYzIe/eUgESR2dN97E8BYLmrSy/BslngdjE=
X-Gm-Gg: AY/fxX5IUA6yRX5ak1XX22lHCrUDK9rIICqqYx7sMpXt9k5rBDfQLH4Qir26aOqog3P
	4dfYS8hCg1v7f8MkZ61+zoRwSmthibEDCw1V/zsmk5twBAmflrAUjf0cu94NR5COV3O5BUYQnum
	peKtyVJqxK3NFh57mk6vlEyfHnvVJ/AxkEB4EZh9qisIwFJeV/x9NrIbwfBPlYjevgmTkWMtlGQ
	55HV+54QDczJkYOgWQXCjFTpP6Dt5crhOVDtddYEI39QUPf0tm8B3//qgzJZa/qwEeK+lNy+/NA
	22r9kMsa/0ies/OVOa/1rzPkkGnYsSqsiK47O/6DccUqAlcwrfoGzErb2vLEUN8SNKghO/CNofF
	7Z6J/3ke4qqwwi3ex5NRifZQU0jnxUhJUji90kEjS+pLiuMgcY59YVsoZkjP7TYa/6BZQQCH1/m
	LROzGM2FxrPAvVliw0iG4wWe5uUgv0g1pZ080wR8ckeoWpc4DXF6yvMNq58MbRke3fG5ECyTIjW
	w==
X-Google-Smtp-Source: AGHT+IFjwWCGB6LRd4N+NxvY957g9brx/H0PEej/O5E4TZ+847uJ8xkrJR8KfRVQ88SdRIy0qCx7+A==
X-Received: by 2002:a17:907:96a2:b0:b76:afa4:933f with SMTP id a640c23a62f3a-b80205de9dcmr610688166b.22.1766155295451;
        Fri, 19 Dec 2025 06:41:35 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64cfebea196sm57496a12.7.2025.12.19.06.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:35 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 17/26] libmultipaths: annotate functions that may free paths
Date: Fri, 19 Dec 2025 15:40:59 +0100
Message-ID: <20251219144108.237928-18-mwilck@suse.com>
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

Paths are freed in check_removed_paths() quite deeply in the call
stack. Annotate this function and some of its callers, lest we forget
about it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 33 +++++++++++++++++++++++++++++++--
 multipathd/main.c          | 10 ++++++----
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 62ee450..9905ff2 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -563,6 +563,34 @@ static struct path *find_devt_in_pathgroups(const struct multipath *mpp,
 	return NULL;
 }
 
+/*
+ * check_removed_paths()
+ *
+ * This function removes paths from the pathvec and frees them if they have
+ * been marked for removal (INIT_REMOVED, INIT_PARTIAL).
+ * This is important because some callers (e.g. uev_add_path->ev_remove_path())
+ * rely on the paths being actually gone when the call stack returns.
+ * Be sure not to call it while these paths are still referenced elsewhere
+ * (e.g. from coalesce_paths(), where curmp may still reference them).
+ *
+ * Most important call stacks in multipath-tools 0.13.0:
+ *
+ * checker_finished()
+ *   sync_mpp()
+ *     do_sync_mpp()
+ *       update_multipath_strings()
+ *         sync_paths()
+ *           check_removed_paths()
+ *
+ * [multiple callers including update_map(), ev_remove_path(), ...]
+ *   setup_multipath()
+ *     refresh_multipath()
+ *       update_multipath_strings()
+ *         sync_paths()
+ *           check_removed_paths()
+ *
+ * refresh_multipath() is also called from a couple of CLI handlers.
+ */
 static void check_removed_paths(const struct multipath *mpp, vector pathvec)
 {
 	struct path *pp;
@@ -583,6 +611,7 @@ static void check_removed_paths(const struct multipath *mpp, vector pathvec)
 	}
 }
 
+/* This function may free paths. See check_removed_paths(). */
 void sync_paths(struct multipath *mpp, vector pathvec)
 {
 	struct path *pp;
@@ -611,8 +640,8 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 		pp->mpp = mpp;
 }
 
-int
-update_multipath_strings(struct multipath *mpp, vector pathvec)
+/* This function may free paths. See check_removed_paths(). */
+int update_multipath_strings(struct multipath *mpp, vector pathvec)
 {
 	struct pathgroup *pgp;
 	int i, r = DMP_ERR;
diff --git a/multipathd/main.c b/multipathd/main.c
index 7b522e8..697e269 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -503,6 +503,7 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
 	remove_maps(vecs);
 }
 
+/* This function may free paths. See check_removed_paths(). */
 int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
 {
 	if (update_multipath_strings(mpp, vecs->pathvec) != DMP_OK) {
@@ -513,6 +514,7 @@ int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
 	return 0;
 }
 
+/* This function may free paths. See check_removed_paths(). */
 int setup_multipath(struct vectors *vecs, struct multipath *mpp)
 {
 	if (refresh_multipath(vecs, mpp) != 0)
@@ -2519,8 +2521,8 @@ get_new_state(struct path *pp)
 	return newstate;
 }
 
-static int
-do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
+/* This function may free paths. See check_removed_paths(). */
+static int do_sync_mpp(struct vectors *vecs, struct multipath *mpp)
 {
 	int i, ret;
 	struct path *pp;
@@ -2538,8 +2540,8 @@ do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
 	return ret;
 }
 
-static int
-sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
+/* This function may free paths. See check_removed_paths(). */
+static int sync_mpp(struct vectors *vecs, struct multipath *mpp, unsigned int ticks)
 {
 	if (mpp->sync_tick)
 		mpp->sync_tick -= (mpp->sync_tick > ticks) ? ticks :
-- 
2.52.0


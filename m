Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1CD324700
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155292; cv=none; b=AugrDwxsQTM5DkoINEsLSBj9fMK4dH8qUnP1tX2KQGY8GefeJsxBuhiYZtA7YKJ/ISZUaVAE1eI1dmPT9MoqWKyYg5ptjvylj5g7mBWuRYPvBSPBVsebY3EWAB5BywklRQlP0A8/GuEgPGYkVJP71kkxEvgzZxJe1obnIIwOWEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155292; c=relaxed/simple;
	bh=fR+8oW+tRizjTJrtXuRGi8/6Roo+3eU19vF0QBH17tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ep73nXfE3Do2BTedHN2kmHinOzfpLZGszw9KRkx0bzHdO/H2akoxcnhRVIToE/au+h7pIKUfGL+YvfixZdCaduznxn2QtjmtX/jWTcSXuB2Qw8sfR7sWL4epMtfvae0WG9ObqMewW9Y5BA18XtSF8knymSUkaa26LyXCK1tJhoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gA2cL0uo; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gA2cL0uo"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b560e425eso2292108a12.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155288; x=1766760088; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tvNfhxWKITU50bH4PguqpOoIJh43pnpYIsiWKp/qu60=;
        b=gA2cL0uoZBaeCIL7JGIfBbYXSB1/sIMp2zrImKGALeQ+hvWS4mvwnQMF9ptZuJtcTr
         NLWC0G8jX+lAYEe+OxxrDblLX6hDGDLikSs/vIieMSW0I6/mwg7+34hIhQl6qNEBuu/g
         fUQdEPQklj+nxvs6NmuzGXngbvezRBobCIHSVoP02AjFv/yjara+omEA+L3M5KyqKLNo
         9opB8iOvyKOrX0lTOUKh8tMeivX1ex8oJWuSoK5o4wjRNhqg1KyGtLMTLcX5jLM982Ai
         Lgah5pnUMSCzihz6wqxtlkgMmvYLI57j7iJMmDwJyH91W5hliHiWvVdke3XEEq29D4vi
         sK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155288; x=1766760088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tvNfhxWKITU50bH4PguqpOoIJh43pnpYIsiWKp/qu60=;
        b=og56h99AQ9U6aLxiSf1LsOf/RFoGmFJdNBHZyEbk9NrwU1A+Lk3aT78cDIzpIZXxPI
         KDu00Kk3hGiRr+fHGcKnMWEA4dt6rom8KfOpUk6Xzz3YFIf/F0MVgFIzhv6hTj1juXj0
         1ORcwJo5zsPuZ4ZfBmoL0P4qWY8gFIP82ajt10cVcBK3w697mpsROwnKceJxnqFA3aV/
         XJIiSIRHRbQJvcspLdo9SNNXTEZ11lvOJV1D/FI3g6bm+CGe8ReMQhAKJ9OGEHTQz3HQ
         14Dy1utPZ7KbuDf58JYR/hQS+Epvcim8x7Nk/J9OLulTJ+QFxQz4BD+/1YCGtX9Dx98q
         hNbw==
X-Gm-Message-State: AOJu0Yw/Fjxdk0E1sR5BO5CM3oqbmbp5ShqNWhiHGXPwKaFfK/3KqxVV
	qaQmVhxre7uHBXmFe9RbDsL2oC7Bv66lKiIVKIh4mkaCDvPVq47Mn98YdrQHtpXKz1BeJGtAdse
	LZ9Og
X-Gm-Gg: AY/fxX6Z3yRC+vpMy/W4CkGw/lzeWrti/RAn0lQ9xuafWypSCXBeVzk2Y+wIJTvyv51
	8AaULWB22AdUHCt9DHFK1VzFR+f5m4Qbmd3DRwsXVrKg1ef+Xr6S4rI0M5RFWtx8Nreypj1cIQE
	hKC7cXlia9TmMp/hNV+mE/QaaJ0AV2tQfcq8r7i9jqbgSVuz9C8GYmOue3qzC9CLrTERgany9mZ
	kHj9mWA9ulanCcjOotUNMITUqWBe8D1sTApSQ6KfbSU1SEb3rkNCgsZSUHdwACsnxYHvBjXkdX3
	pgjGycUq6kKUkg56U44zlaJU4fv3ohM8sh25VTHlWJ+IxF5mLAfLyraRJJCWAAZRcEbuCxYHWrE
	fle9Pfx2qFEfZ8V8mIHjqqo6IVB/mWcd6rgSMoc1GAxisw5awWpm7koW4U8k6xFf15dR2mqcUE/
	Mp3Wa131OHHnDY9iFatebweXcVd3F4ehIEw4t56Rp4rLZc5gnCa1pnGnWGNIjh1tkHPQngpetWd
	z6bpAwftP9N
X-Google-Smtp-Source: AGHT+IEetodHujs5SawKezoy/rZxV8fTZhQHQy2qzubFPw7i72L9xDVtT+Btmdi+gytTDQjWTGhTEg==
X-Received: by 2002:a17:906:9fd2:b0:b73:42df:27a with SMTP id a640c23a62f3a-b8036f2fa8fmr290140866b.1.1766155288143;
        Fri, 19 Dec 2025 06:41:28 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037f5120bsm249955966b.66.2025.12.19.06.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:27 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 10/26] libmultipath: remove free_paths argument from free_pathgroup()
Date: Fri, 19 Dec 2025 15:40:52 +0100
Message-ID: <20251219144108.237928-11-mwilck@suse.com>
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

free_pathgroup() is always called with free_paths=KEEP_PATHS,
except from free_pgvec(). Remove the argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   |  2 +-
 libmultipath/dmparser.c    |  2 +-
 libmultipath/pgpolicies.c  |  6 +++---
 libmultipath/structs.c     | 11 +++++------
 libmultipath/structs.h     |  2 +-
 libmultipath/structs_vec.c |  2 +-
 6 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 2d324ad..a8e18a2 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -375,7 +375,7 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	 */
 	if (mpp->pg) {
 		vector_foreach_slot (mpp->pg, pgp, i)
-			free_pathgroup(pgp, KEEP_PATHS);
+			free_pathgroup(pgp);
 
 		vector_free(mpp->pg);
 		mpp->pg = NULL;
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index c8c47e0..e0151ed 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -261,7 +261,7 @@ int disassemble_map(const struct vector_s *pathvec,
 			goto out;
 
 		if (add_pathgroup(mpp, pgp)) {
-			free_pathgroup(pgp, KEEP_PATHS);
+			free_pathgroup(pgp);
 			goto out;
 		}
 
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 23ef2bd..d7302a9 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -252,7 +252,7 @@ int group_by_match(struct multipath * mp, vector paths,
 	free(bitmap);
 	return 0;
 out2:
-	free_pathgroup(pgp, KEEP_PATHS);
+	free_pathgroup(pgp);
 out1:
 	free(bitmap);
 out:
@@ -314,7 +314,7 @@ int one_path_per_group(struct multipath *mp, vector paths)
 	}
 	return 0;
 out1:
-	free_pathgroup(pgp, KEEP_PATHS);
+	free_pathgroup(pgp);
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
 	mp->pg = NULL;
@@ -343,7 +343,7 @@ int one_group(struct multipath *mp, vector paths)	/* aka multibus */
 	}
 	return 0;
 out1:
-	free_pathgroup(pgp, KEEP_PATHS);
+	free_pathgroup(pgp);
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
 	mp->pg = NULL;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 08d8b87..a7c68f2 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -225,18 +225,17 @@ alloc_pathgroup (void)
 	return pgp;
 }
 
-void
-free_pathgroup (struct pathgroup * pgp, enum free_path_mode free_paths)
+void free_pathgroup(struct pathgroup *pgp)
 {
 	if (!pgp)
 		return;
 
-	free_pathvec(pgp->paths, free_paths);
+	free_pathvec(pgp->paths, KEEP_PATHS);
 	free(pgp);
 }
 
-void
-free_pgvec (vector pgvec, enum free_path_mode free_paths)
+void free_pgvec(vector pgvec,
+		enum free_path_mode free_paths __attribute__((unused)))
 {
 	int i;
 	struct pathgroup * pgp;
@@ -245,7 +244,7 @@ free_pgvec (vector pgvec, enum free_path_mode free_paths)
 		return;
 
 	vector_foreach_slot (pgvec, pgp, i)
-		free_pathgroup(pgp, free_paths);
+		free_pathgroup(pgp);
 
 	vector_free(pgvec);
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d89582c..796201a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -578,7 +578,7 @@ void uninitialize_path(struct path *pp);
 void free_path (struct path *);
 void free_pathvec (vector vec, enum free_path_mode free_paths);
 void cleanup_pathvec_and_free_paths(vector *vec);
-void free_pathgroup (struct pathgroup * pgp, enum free_path_mode free_paths);
+void free_pathgroup(struct pathgroup *pgp);
 void free_pgvec (vector pgvec, enum free_path_mode free_paths);
 void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void cleanup_multipath(struct multipath **pmpp);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 1259aec..91c8d58 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -254,7 +254,7 @@ static void update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 	delete_pg:
 		condlog(2, "%s: removing empty pathgroup %d", mpp->alias, i);
 		vector_del_slot(mpp->pg, i--);
-		free_pathgroup(pgp, KEEP_PATHS);
+		free_pathgroup(pgp);
 		must_reload = true;
 		/* Invalidate pgindex for all other pathgroups */
 		pg_deleted = true;
-- 
2.52.0


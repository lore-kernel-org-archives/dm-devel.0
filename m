Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027A1335081
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817136; cv=none; b=BR8QnKYbPWjFE5ADNE3EhrC+bfIIlG5y4dMX9aEn6wMvnu/Uh5+1CI4nIhv9yWhmhtL/bF6AbqB+PBd7S3Z6rabtP9ijoM7pW/cQToWLSi1qETCaOAioccmjpGOMvxQ0u8fFOqIgzhoMuqSEIKyp3daefPBMf3qb0tiZGAx8Myk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817136; c=relaxed/simple;
	bh=Sc89VUs9Bfp0vK7kHQfs4QX9dHGpcEAVNkI7pCPwurU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2KkrRwfz1mkMsJMEyTuHN6KTEtwdeEl1M0llNJfOLzQlhvFPSzbryosrvZLip5+Wii2PpfLr5eNx6ySnDcqgNAP3a1tW2+LRPnh61FDmXa416M60GromdeClEZwj/PC3I7XMom269fm9VfFp0FJdn5Krf4WkfYRTgfRLATiOjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Rc5FKNLE; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Rc5FKNLE"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b7eff205947so336089066b.1
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817130; x=1768421930; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLCCYh8QCdbWDg0ottDtOwI9frWeidjQx6Pnb1vMd4w=;
        b=Rc5FKNLE/hQ5VCJjBFAP5T8H4RdVSpNmjmsF4ndCa4/Ne4eDd84D0ciLykkryB12Tz
         a0u7Qp9PvR9/SmdeiU9kUfNzLjiaiFBwA8yhZZs3HbFFSP77xZ0EHpbuPxMvL0yvPD3X
         kcf6k1c+11A+n3FAf7qBiAhef0uxNQYHBL4EOxBpUVM7s6mt+S+FFiyE2t4KbAUBH8fA
         PDUPTJ9QBc3Lk4ms2557AxERMS2spRvsK7z93rooLo76hCUT2I66Ote/igzlmqyZwJ5e
         JlgMfjWZF0JTpR0pWcz1M9Ync1X7WXeghhLjg9vvh0E6pd0d2iRueTEMvkar/73n7Jje
         bH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817130; x=1768421930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nLCCYh8QCdbWDg0ottDtOwI9frWeidjQx6Pnb1vMd4w=;
        b=P4qqOxW7PBffn+YHrdmmZPtXNEJXA+pfpcmAHuEbs8Rmf7faNnL2XJh5tFKqjzwM1Z
         qmEBSol8lOIsyA+upJmoirUdncJkCHur7iinwAakMlo8RG8h7jgWHQcuag07eSUu8BSf
         bJcXDHVb8qhGqoZm6nPIYdAmqtQIGIqSlq7iLxXJkNAO12AUucNhSl+TbjbN2Bj3tRNH
         PtOT6JOq8Lxj/6qHXuqPw39pI4WVweYTB6LmaPjpTf2y+zDZ2L+jen4FAhcyqS4HiZuZ
         12lpckm4wpizec3A9855WARwlz6atZHg2AMGOKe8fCq9uhWgo2FHwkyqqLXqsZFOvLYz
         p44Q==
X-Gm-Message-State: AOJu0Yy5ngVposPu8ieR+Vk8cYo9mheUeUD4HVtymWD3xQioFog3gVNp
	sniLbBL1jC6NKlfrdbPZYNy1ieIu5y4Ee/CofOmyWz+VbZh9sAxryBQKwHMXthdgFzs=
X-Gm-Gg: AY/fxX5FIE+YOLSeLVqRYz7NRTNZ/AvT94eersBYy/sMaGmuUE/fvqV9Em7EyjefV7T
	hG1EQLLM90MXvHBgNfXCWQGOj+Wtf9fnTyLCm6kZXaPaeOT1aGa/C5+f0ehE2FNgS6xb7anAo00
	2wSH9JoAz1UC41Bu2ujt3kdO8g/qwmOjugZtgn3/Uy0OAtzHZJLCalqb0D4WBk0D6TOHtL6pKF7
	Ln9f4G3PxVJQHsTplBnfwbg3y6ovgqRWcqbVWROtRY7deLm1gsPWjRCxhWrBJjRfZ1ndRoUirSe
	pMVvaqOkdc8VdswYUgzYqb5D8rq2FYAnd9CfejPr7R+Psii03W8GxlM8srWbS69OB7EkSNpH705
	OoFw4wBprVsaLMlZAt3g/jvSj7kl7BljHKp3NYVK6cykUWD6ymD/3MNyeecLyi92a6fX5Vu1NdT
	ztzRUWMLjeLMjHPHam1NR3EX60eG8npAUSsiDI+p/14FtCh3a8DKHz0l7MCuDadXrj7EegfB/MZ
	3ox2PKxjbH5
X-Google-Smtp-Source: AGHT+IE+LWSyZjTnVnhFY7cV/9zNNcaJfP/JS77u4We0PJTmiDH1vwV8U3SJ1mnfZgxuZFMOnTi6TA==
X-Received: by 2002:a17:906:ef0c:b0:b83:246c:c514 with SMTP id a640c23a62f3a-b8444fce93fmr380084866b.51.1767817129626;
        Wed, 07 Jan 2026 12:18:49 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a4d31e7sm618151266b.42.2026.01.07.12.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:49 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 09/26] libmultipath: remove free_paths argument from free_pathgroup()
Date: Wed,  7 Jan 2026 21:18:09 +0100
Message-ID: <20260107201826.323977-10-mwilck@suse.com>
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
index fe777dc..fb23c43 100644
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


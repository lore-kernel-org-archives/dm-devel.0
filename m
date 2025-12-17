Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3EB30F7F9
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006494; cv=none; b=quYcPWjNR2n8nJbCScs6qGDvFJuUmfrllfbtWlF9RHn3tcB3aPgYtbVdugp3XJJ3u/xtjm3+MPNazu+Dqk7xeLaBflfZASjJFK7Atv881NRwfb4/QKVoLSSdGXcTno/AMfWc0Mk8AX8Xy7CPP9N5JxSiKDLGthaR/XpbrOlsI7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006494; c=relaxed/simple;
	bh=EJaSx68uDXfo+yocViOK3TLmxgcJUODV9f8OJ3+zTJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+hSGJiGCrft4cneCT426YPT7EITTujj1BuqTIPj+nDz8drFaVzjUdqiho9aNjO8ZZeFOAfboRZpWFhdHZFMt2d05k/baP9x5++cu8iLNnImY2JFF4APzeJxGO4g4CUT9f+Wm7uSXqRoW+ksOJixvSCgd1x29HUHXcXbCOc7xtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g6s327z6; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g6s327z6"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b735487129fso1087262966b.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006490; x=1766611290; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9J0Fdh43J0Z9rrtXFvz/qb/IFJo4xnZg/Puqlr2QFEM=;
        b=g6s327z6pNcmAsTCkzLvQ3B3dnShGRFJEofJGlDRZq1SdRefHecL10yiEcB3GMPc+S
         SLN3H3Ca3P11gPBD0Ml2hfTZpatnObQZW5JDn5mCVgIPdTlZYYisE3noOOIN5Q4dqycW
         9zUhWPVXFyLHPap/tqbGHLE48F+s/+psx3dCppCnENu88hGYgWqdzah9AF2ZKo7SJkv8
         qMBG4x26BjJ5zLqlA/gx4HydHykU0ey4gsG2yMqnVWymsrNLvLB+LJSO5DusTpGD/bN2
         xur2sFheyUEtMuGErTFtBv4nlPZnJZXse/gKcC4fp7u+BkhygiKBnW2QpHo4ibDJzh9Q
         7gmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006490; x=1766611290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9J0Fdh43J0Z9rrtXFvz/qb/IFJo4xnZg/Puqlr2QFEM=;
        b=cByrA7DL3hePnUp451hIscRhxRIbxl3rnVxC60c0S1zHMpTAxDd41/0HZS85GE+kbI
         gHl/iUUMKdiLpHZetCiZjQZd6axVIPbtpPyQ1KnBRuv56Q5dt7Y7UGTuTkBltu3xsFv9
         yYHVKg8N8qNMVMdoGSENT5C57MRbCpjTKcXGtrjAM4ir2vR3pAP1NaaIp7FtPTtow3yx
         s40RDQk/ZeJ7iM8UTwgu5HebTn6WVSwHUzECmlcV18vIwBHlfzINvDR+zxYaAExZihIL
         mL/UDUogbFiHkHzLopSeXeOl6pfl5SDSgfkf6WYos8qekPoq4DKtVKvWBVF1RiDx1I//
         r3wg==
X-Gm-Message-State: AOJu0YzJURk6kbNtaQkV0uSpJZTJ6mOBdD5SvixsgZUuj0VigNaQwl4o
	4ChB+7fdC9V1qLX4CFdnrmCLtOcIJMwMXAc5eUWSkHSCtaVVTyAhxSF7bXL1rb8sYQU=
X-Gm-Gg: AY/fxX71H5lvPA8w9wu1jeKZL2+U1Su84qJlChaPV9G5JziGhTOXqb2drCEk1qhCURx
	ZQMEr/pyyz+RtGS/FAuFjh/jC7+BU0WTYJMSWsoL/Wfg6ovfsvzsn8fhQGGSkxEziiaT9NcpzVm
	S82pCuYVpebPQArl351x8cGYOrMVGBZbJ5801egV6/AbBUCsC/98CBIXeDfy0KSr63UyYfDp9EX
	c536tpGhMnMAAwxZz6q8ae4Kr9/b7BZ3qMITCgKAUraN1IN0zihxTVA6v9UDR5w2glJ6Kk8gqK2
	vlCd51Amx0vAvhLGwr+UgzLp6qNffAi34eiFkX4legwiVweav6vT7frjWpqHKbaptAA+c68u8lQ
	UzcLv+iiBW5fu802L52tePdhsk5ot6jDC+oZ3sWpwdy8HTWVfmcZHdiAm1g8fRrT5SBahD7rfyf
	9j6jCovVrXruEvmqobou7qohgPmJaS9G63+s+uuIKHXMAh89PeyEfSDpzjvKrPGBSqW2bk0AhH7
	w==
X-Google-Smtp-Source: AGHT+IHzcZZdQf474QzJTG9wl5vaibufoe6vXyt6groOKAN5rBo9pvdARxUSCN3WgQXHtIat1iL0TA==
X-Received: by 2002:a17:907:3d87:b0:b76:4c16:6afa with SMTP id a640c23a62f3a-b7d23687c3emr2202167266b.28.1766006490109;
        Wed, 17 Dec 2025 13:21:30 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b80234a2ee4sm26745766b.57.2025.12.17.13.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:29 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 08/21] libmultipath: remove free_paths argument from free_pathgroup()
Date: Wed, 17 Dec 2025 22:21:00 +0100
Message-ID: <20251217212113.234959-9-mwilck@suse.com>
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

free_pathgroup() is always called with free_paths=KEEP_PATHS,
except from free_pgvec(). Remove the argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   | 2 +-
 libmultipath/dmparser.c    | 2 +-
 libmultipath/pgpolicies.c  | 6 +++---
 libmultipath/structs.c     | 8 ++++----
 libmultipath/structs.h     | 2 +-
 libmultipath/structs_vec.c | 2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

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
index 7df5562..aaa7e50 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -225,17 +225,17 @@ alloc_pathgroup (void)
 }
 
 void
-free_pathgroup (struct pathgroup * pgp, enum free_path_mode free_paths)
+free_pathgroup (struct pathgroup *pgp)
 {
 	if (!pgp)
 		return;
 
-	free_pathvec(pgp->paths, free_paths);
+	free_pathvec(pgp->paths, KEEP_PATHS);
 	free(pgp);
 }
 
 void
-free_pgvec (vector pgvec, enum free_path_mode free_paths)
+free_pgvec (vector pgvec, enum free_path_mode free_paths __attribute__((unused)))
 {
 	int i;
 	struct pathgroup * pgp;
@@ -244,7 +244,7 @@ free_pgvec (vector pgvec, enum free_path_mode free_paths)
 		return;
 
 	vector_foreach_slot(pgvec, pgp, i)
-		free_pathgroup(pgp, free_paths);
+		free_pathgroup(pgp);
 
 	vector_free(pgvec);
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 81c69b4..8fe74c2 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -577,8 +577,8 @@ void *set_mpp_hwe(struct multipath *mpp, const struct path *pp);
 void uninitialize_path(struct path *pp);
 void free_path (struct path *);
 void free_pathvec (vector vec, enum free_path_mode free_paths);
-void free_pathgroup (struct pathgroup * pgp, enum free_path_mode free_paths);
 void free_pgvec (vector pgvec, enum free_path_mode free_paths);
+void free_pathgroup(struct pathgroup *pgp);
 void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void cleanup_multipath(struct multipath **pmpp);
 void cleanup_multipath_and_paths(struct multipath **pmpp);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 58c785e..f3f47d4 100644
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


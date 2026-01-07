Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DC417D6
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817137; cv=none; b=CNMryZ9gsVPy3OBDy9+Vlhm5iQbdOZroEsXCElPvilEz4hzxGvj3ScI1vMEqimb1sdif9pKN8PHt4grAgAwG+ZWdu4A7InZqSFrBV4DDgQtr5z4b4mQMFO4jWXLOcxAXeUtjIcxLpkJsM1gN0sakY0dwNudhh48f+qmpE3XKQRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817137; c=relaxed/simple;
	bh=kIDU/qBWKxAc2X19G2oF+U3fyWvSLtILlzKUTrKvt8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmYpiw7Hs98aGtA9s3arqXHbVW5cncEE/tbHTa2u1hA5QjaC6txwQcGzSc8AbfwcerKq/MtqVKNlAiprXNxovSrALVwYcTTDJDxV8+lYF1236DU/+rcJVl/N5fhx+irx3NzHEXmYcwKt7fB3TO88zAAUZNmlSUMEPfOR1I8eP1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CUBHckxR; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CUBHckxR"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b76b5afdf04so474331066b.1
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817131; x=1768421931; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZeV+IyyT6CObHqx+QsU+y2xTnfGFcU2l7Je85cMOnpM=;
        b=CUBHckxRbLoUbAAXRhU4IfEDePw6BWu0bR8m2MQ0zIOiI8BVI1VLEnKGX32BnD1Aun
         LSOQrkthW7kK3QNPpA7QhoyLqJf6ozX7BlqwsdCIhRy1sMIAMp9cyGo9SHNHJo0FEQji
         R5owjiOMSRpt6KEq6e6RAl0j9vnj9c8tkgwO4sIiwKEp0djRrwMMS2sBK8anPCcxGWRy
         fKvWZbnDY8WRSD5x7QqcglLA+Ec/+21FCI+W0s10dWjUWW8MFu/OESaLHrei5oNWqi8g
         1HNAJwtA3PlkkgvpU2vNMmO5QA5RsSrzqmhhSkX8+EwyXQl4i6NdXFIU5RGnB8NzWmNF
         Aldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817131; x=1768421931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZeV+IyyT6CObHqx+QsU+y2xTnfGFcU2l7Je85cMOnpM=;
        b=w8khCxpZs+5qZiqvZ3GpY3+YsWQNQ7SqAMW8+VFd3I3oSUpI+dG8Y1Yzbje0BDQ54N
         yu2SG3vX3jTN9IDUcWie/kGcQmDRyJFZPssN1AiNkJHvyFyI9gEuDEjUuumDH3QmPAlN
         PimNYzGwVEmBR7/UP6PWYwhbIrvUMfA1Bhoz/8ZR+2q9Yb+IK0CND0qHZSqIAH43WIGK
         ScL0GRN2U7efxWRWem/HL6sG40T4IheoSzoFf8BkjqDZwtLG3dvgN452dSYLwAlZXNiM
         8JtAuHgHgfqZBU2ISHdFatvSQ0261QjuD/fH+zLWeLyP3vZ3PzCwhpUskq42mmjqgrNF
         hzkQ==
X-Gm-Message-State: AOJu0YwCxi2eUNuqlZjHQoFm5nd+BJysfP82/hEH3lqcn3WrXJ69fdzl
	dKnqr5Kv29V2XGNFjCi6Hwyt5JvTAGvdybdmsOgVdC81oO0EhNtzN9QWkNb36P2tuWE=
X-Gm-Gg: AY/fxX4CLuEc6pRm82osiYd/g/9QOaprGmqB3yZp3BCb2iXD9plSDis+a6LMD2urZ5S
	Yg2x5VmVBM6UYUMZ8IG22AbuPq2kA7XxtdcG8VN+rzC+I3CqMrM7WyRvRmNwACTW7CDuFge3ZEY
	7EKjyW8jP4+U6yhXJ183qEaWZs0i11HnKkOvqEG2ot4SiuU3kwYALPyYy9LXvnlj5aT969eAAlB
	kaJ0gkXoK/DNJ1TgRkIXpmKUVl8H9l0zUFAMfhtSVxLigvECAuNJfGcL/YpwKhlSSbcCy3qFq+k
	UcRP3iRxFuOZTmckLih+5zOLzl5Nu/VU96/9HWgq5xRLWvaTx9DWnFeGDdLg9MPeUi/aWUTIJST
	3SAMHrgMwErcMU8+kcxSO9wTqX8yH/d5UUTkUD5KDQOhHWkuQy23c9E6CI1W0DfjlX7wUuA5FFr
	5HvCQhrP/cPKOCSd3/UZv93HZCZJZu7Eo7D+Su6dFaDkeqvUSXFCuPYQL5p77CErOUCkoQto5OR
	ZbzU31BjUC9
X-Google-Smtp-Source: AGHT+IEuDzyj6D3aFkchvAVnm+nmnSPJthoN80dMTPD5moAMAp3x/saDM4FEkj41x0UT/de/zDuTbQ==
X-Received: by 2002:a17:906:ef0b:b0:b84:365f:10b9 with SMTP id a640c23a62f3a-b844522a6cfmr350545866b.29.1767817130667;
        Wed, 07 Jan 2026 12:18:50 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a4cfe60sm594191666b.45.2026.01.07.12.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:50 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 10/26] libmultipath: remove free_paths argument from free_pgvec()
Date: Wed,  7 Jan 2026 21:18:10 +0100
Message-ID: <20260107201826.323977-11-mwilck@suse.com>
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

free_pgvec is always called with free_paths=KEEP_PATHS, except
from free_multipath(), which will be fixed in a follow-up patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dmparser.c    | 4 ++--
 libmultipath/pgpolicies.c  | 6 +++---
 libmultipath/structs.c     | 5 ++---
 libmultipath/structs.h     | 2 +-
 libmultipath/structs_vec.c | 4 ++--
 tests/pgpolicy.c           | 2 +-
 6 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index e0151ed..3411bd0 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -205,7 +205,7 @@ int disassemble_map(const struct vector_s *pathvec,
 				return 1;
 		}
 	} else {
-		free_pgvec(mpp->pg, KEEP_PATHS);
+		free_pgvec(mpp->pg);
 		mpp->pg = NULL;
 	}
 
@@ -336,7 +336,7 @@ int disassemble_map(const struct vector_s *pathvec,
 out1:
 	free(word);
 out:
-	free_pgvec(mpp->pg, KEEP_PATHS);
+	free_pgvec(mpp->pg);
 	mpp->pg = NULL;
 	return 1;
 }
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index d7302a9..2e1a543 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -256,7 +256,7 @@ out2:
 out1:
 	free(bitmap);
 out:
-	free_pgvec(mp->pg, KEEP_PATHS);
+	free_pgvec(mp->pg);
 	mp->pg = NULL;
 	return 1;
 }
@@ -316,7 +316,7 @@ int one_path_per_group(struct multipath *mp, vector paths)
 out1:
 	free_pathgroup(pgp);
 out:
-	free_pgvec(mp->pg, KEEP_PATHS);
+	free_pgvec(mp->pg);
 	mp->pg = NULL;
 	return 1;
 }
@@ -345,7 +345,7 @@ int one_group(struct multipath *mp, vector paths)	/* aka multibus */
 out1:
 	free_pathgroup(pgp);
 out:
-	free_pgvec(mp->pg, KEEP_PATHS);
+	free_pgvec(mp->pg);
 	mp->pg = NULL;
 	return 1;
 }
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index a7c68f2..511173d 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -234,8 +234,7 @@ void free_pathgroup(struct pathgroup *pgp)
 	free(pgp);
 }
 
-void free_pgvec(vector pgvec,
-		enum free_path_mode free_paths __attribute__((unused)))
+void free_pgvec(vector pgvec)
 {
 	int i;
 	struct pathgroup * pgp;
@@ -326,7 +325,7 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 	}
 
 	free_pathvec(mpp->paths, free_paths);
-	free_pgvec(mpp->pg, free_paths);
+	free_pgvec(mpp->pg);
 	if (mpp->hwe) {
 		vector_free(mpp->hwe);
 		mpp->hwe = NULL;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 796201a..064a76b 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -579,7 +579,7 @@ void free_path (struct path *);
 void free_pathvec (vector vec, enum free_path_mode free_paths);
 void cleanup_pathvec_and_free_paths(vector *vec);
 void free_pathgroup(struct pathgroup *pgp);
-void free_pgvec (vector pgvec, enum free_path_mode free_paths);
+void free_pgvec(vector pgvec);
 void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void cleanup_multipath(struct multipath **pmpp);
 void cleanup_multipath_and_paths(struct multipath **pmpp);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index fb23c43..814d477 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -424,7 +424,7 @@ void remove_map(struct multipath *mpp, vector pathvec)
 	remove_map_callback(mpp);
 
 	free_pathvec(mpp->paths, KEEP_PATHS);
-	free_pgvec(mpp->pg, KEEP_PATHS);
+	free_pgvec(mpp->pg);
 	mpp->paths = mpp->pg = NULL;
 
 	/*
@@ -624,7 +624,7 @@ update_multipath_strings(struct multipath *mpp, vector pathvec)
 	condlog(4, "%s: %s", mpp->alias, __FUNCTION__);
 
 	free_multipath_attributes(mpp);
-	free_pgvec(mpp->pg, KEEP_PATHS);
+	free_pgvec(mpp->pg);
 	mpp->pg = NULL;
 
 	r = update_multipath_table(mpp, pathvec, 0);
diff --git a/tests/pgpolicy.c b/tests/pgpolicy.c
index fb956d1..ed050fa 100644
--- a/tests/pgpolicy.c
+++ b/tests/pgpolicy.c
@@ -131,7 +131,7 @@ static int setup_null(void **state)
 
 static int teardownX(struct multipath *mp)
 {
-	free_pgvec(mp->pg, KEEP_PATHS);
+	free_pgvec(mp->pg);
 	mp->pg = NULL;
 	return 0;
 }
-- 
2.52.0


Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9361130DD0C
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006497; cv=none; b=iNZp6h/WCzS/I7Yx1gF8v7Khb5X1sfYOsz7HAHiVLDRou5KQHa44mZ5xuKqkI00WWMxZKCAS4gQmSKFm0Mz42OdH97kry56qGrzov6uYN6e+9CpUIEIz3Q6I3KUtRkNXSSaxnhdBSzjP+WkVqXo7MVpVij//FDQTBqM/0uEymJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006497; c=relaxed/simple;
	bh=firAlPkPatAKUgOZIjB7h5Z0vTQ6hKaFFDRhruJED1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzoGeU9R0NTv2KsZ5cWXmApaFjkRUKYDSFCHt/9PJPf5IBwn8Ul7oBllRZ3s8X5H+nCa0qyQV4tRP4qQmYXptGSazLLYSqvzhe2focxMwpq9gi2UGURYyqCD5hAtry9jcdhdd0tDBRdYe/vbA7U6RvzdTRPEBu3LdUgv9q57J30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JcYjSK0r; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JcYjSK0r"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7277324054so1010061366b.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006492; x=1766611292; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Utbt7c9SrDiJYqfi9Eio/Nd40xAeaPyYBJRFcF/prBA=;
        b=JcYjSK0rV46PCvovwVVglD7mumKwHoPwgw1s7yICGLWLtnaMcZjNVgllh6EkH3Mwqv
         gH7CUfx88Pwi6fYRy3CKj89lD2bYpvzVUxMPlecJlTCWn+mXCmuqZROYdiaTSa4BXknt
         yms4wqjZadnaPpVJHb3yTSY1+BFV/DxzaOZJrjbblTXC5aF7upfgGzIZA2whtWVCXNKS
         7Z/Hfi0jpu7vzWJiJRvcNO7n2JFJFE1BncVuibqBkGXoQnnMAGiAvQMTffAB0Dk0BQqC
         A8H7jAxNEE+VbfaUku11lGF4E+9WHmG1KW9ajJqMhN3Ws9LTpX82UXKdR4JVWIW+NKwZ
         drnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006492; x=1766611292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Utbt7c9SrDiJYqfi9Eio/Nd40xAeaPyYBJRFcF/prBA=;
        b=p1PQ2sVqdCZf6kzwFT7Xp2NPLRv6aLHlI7vfEB1c4LMtbhPuz4XBqkP0E24z3ku3pG
         DPy1ZiuIjYBeAN/rUNyu0PCqk7mXk5DziY1QHja0Qw/7XxKoOM/7Rz5e+ttbEWdLAYW6
         lTFuq473opgTxlyD2J8dBS4GIRja6qkw71+5ubO7P5txKoAd2mklMx0MMVH9hOOu2Gv3
         pGj0knY5GtVhXjU1wzoa5/cwUCqEED8TxjivjTTOkzxrNvUuApTqRqeglQCiOKdLnEgB
         bbqGZtNlrkiGsu/rLniwKOZa8uRYedYkfYC5dcjCd0ROjpf88pPovuo/RhvyhlHJrYqh
         bz+w==
X-Gm-Message-State: AOJu0YzB94kAMXXFNKNK7ByfcLdiixT7o7yUsPSdQbMNUkJuavxUNzc/
	YgwgyqIT1K7nSNzAH8XJfwkiA/UNdWdIaF71S+itzJvZ5ceIKcJ4KkFjrl/MEr19qAc=
X-Gm-Gg: AY/fxX7KBa/2Lcxupd9RE7JiTrl/puqKs0AnR2qBqp7PXRsXEeOj3kfhC0nCPAfLOoe
	0GwMiQHlwBUtSdRKxaN7hcI9K+Kxv9Uhv9iXkKcJ87ZWKL0R6ru3SnDvLTSMuezfJS86TuFbZyM
	SNwzu9qAewzuvwxl29/9V9x8Hzv6dw7jSdNrHo4EcwvbO7HYXpzwqH7cHgNFQsnJNd/od6Dm7J2
	KW+FALn+GkYmdkT9bfDOPXbxG5vDmOm9HZekvaEzuDKxgraUQiILhyXwTMCA4i1rVtwLFiUMoV4
	Syc1uUYHGnYGJYFghg2LP3l14Pnr5245zTaYtfMHZUeyE7kcnIx9fN0xTFXHYFQRhqnQUXXOlcO
	tO5Ih+rJ3VmYXG5Hbv686VYLz+azsltBo05GKuGfWRpYKtxUY5yH9Itw2EBDXFHHZOGPHZNqpnv
	W/QSsCQMF3reCVdOzkIQJRmNVP/u1ODP2d8c6PIcXA+MuVsTILW1iGjR1SLmQlJg7MbeZdIc2a4
	g==
X-Google-Smtp-Source: AGHT+IFL+hL7aMggSPbHvHlR16PA704BtsoauX8x2uagYbJazHrPucrJobxe39PZGPoH/ALJpe7MHQ==
X-Received: by 2002:a17:907:7292:b0:b6c:38d9:6935 with SMTP id a640c23a62f3a-b7d23632746mr1859323066b.24.1766006492296;
        Wed, 17 Dec 2025 13:21:32 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b802350bf00sm27397866b.62.2025.12.17.13.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:31 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/21] libmultipath: remove free_paths argument from free_pgvec()
Date: Wed, 17 Dec 2025 22:21:02 +0100
Message-ID: <20251217212113.234959-11-mwilck@suse.com>
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

free_pgvec is always called with free_paths=KEEP_PATHS, except
from free_multipath(), which will be fixed in a follow-up patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c    | 4 ++--
 libmultipath/pgpolicies.c  | 6 +++---
 libmultipath/structs.c     | 4 ++--
 libmultipath/structs.h     | 2 +-
 libmultipath/structs_vec.c | 4 ++--
 tests/pgpolicy.c           | 2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

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
index 059d454..7b5b483 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -235,7 +235,7 @@ free_pathgroup (struct pathgroup *pgp)
 }
 
 void
-free_pgvec (vector pgvec, enum free_path_mode free_paths __attribute__((unused)))
+free_pgvec (vector pgvec)
 {
 	int i;
 	struct pathgroup * pgp;
@@ -326,7 +326,7 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 	}
 
 	free_pathvec(mpp->paths, free_paths);
-	free_pgvec(mpp->pg, free_paths);
+	free_pgvec(mpp->pg);
 	if (mpp->hwe) {
 		vector_free(mpp->hwe);
 		mpp->hwe = NULL;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 8fe74c2..3a52c01 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -577,8 +577,8 @@ void *set_mpp_hwe(struct multipath *mpp, const struct path *pp);
 void uninitialize_path(struct path *pp);
 void free_path (struct path *);
 void free_pathvec (vector vec, enum free_path_mode free_paths);
-void free_pgvec (vector pgvec, enum free_path_mode free_paths);
 void free_pathgroup(struct pathgroup *pgp);
+void free_pgvec(vector pgvec);
 void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void cleanup_multipath(struct multipath **pmpp);
 void cleanup_multipath_and_paths(struct multipath **pmpp);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f3f47d4..c23e754 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -424,7 +424,7 @@ void remove_map(struct multipath *mpp, vector pathvec)
 	remove_map_callback(mpp);
 
 	free_pathvec(mpp->paths, KEEP_PATHS);
-	free_pgvec(mpp->pg, KEEP_PATHS);
+	free_pgvec(mpp->pg);
 	mpp->paths = mpp->pg = NULL;
 
 	/*
@@ -623,7 +623,7 @@ update_multipath_strings(struct multipath *mpp, vector pathvec)
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


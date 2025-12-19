Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE53026ED25
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155293; cv=none; b=rZxQ20WTQjQlJ/aR9g6VDNb4flPKi4oiEUSLYay1NMpphjz4FH4m6QNwPhSG1hw1d2iq5SrbXQqa6/5juIDJr86XpudnDoAuec7OgH+hdOqXYepFB2aOo1dGG7bE5JMGqLod9hcOq4HeiluxgltdLnsNfrr2Tjejy7Vlbj5aSFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155293; c=relaxed/simple;
	bh=76PQ46nwWi3lKefKyp+o3nAQB4IPntNFtaJgkFz5RnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZXO7mLGabfCwMS1u/bWGVGReOkARgNZploonyPwsAePhEkaGB9pmbHt+iyLE+0CWwDkvI2LhNiw5mCJxKPDuRMQ+dJiHj5BMi1nGOYT8OekPrcQWP895vej17gHpcQfYc/Z3BkSKlUT/E5yDstEPL6NcRNlqWDd5m14uI23E6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DErsEP3R; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DErsEP3R"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b735e278fa1so330783466b.0
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155289; x=1766760089; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPyI2+q+sglIiq7m/FlSem5Sb54H2sUYUXZ3fxs2egw=;
        b=DErsEP3RAWQW1XM7hUG1UBzflZthP1mvGB/FZjfvIi48CRK5KT5kEa40aes1FJ+E2I
         IOvru8GMJCfppLbSuI6BJt49egXYxE/FXZyswTEQ7sKHRkKYAQDnkG+pQe9EEJgJiUXS
         rfU6jatN/coaXZpmyQkkM4nmrK7xXXT/Hk2ncEVnLICD17+d9S8A0R4LXMgoIFj2B5TC
         mm9bNc1tnKW+Apt/w8sTIZPsRv48YsEj1S4qVU94mv4umKPKnxVtw2Z9JWeYDQp1rSAJ
         8dj+XgLP1BXTGiwBQdvsw7SkC6klAwlhoCLGhVa848l+blRRlkkeOMew2szvJt5gCPzV
         NNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155289; x=1766760089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iPyI2+q+sglIiq7m/FlSem5Sb54H2sUYUXZ3fxs2egw=;
        b=IhPOTLjcYTyvHIBpzwN7lROJzc/OeBADdcwqR4eVk1qbO0FcZ6SuY6E6OTy0GYVuAa
         c1v32O1a8N2jcP9VIlazVp+aShvyMJr054F/H7lGNiPswUcweLOhemw2U2g4tb9WPjWI
         7S2WLxwhc5OovfS8EmU/SvxKdQA474kOJwI0ZwakbWI93s/EEPueVLyORcFX2GrEPsW7
         NM71aqB0EcmkpPQDVC/T8srN3HvtZw/LlWdJV6Mnv7mazqG4I/w2KpARcHSNugJBfqVQ
         NjHS29sJTwcLiqF6gQdM7/p3jL5sVktSClH9C191t8xeA4Iv0JFV8CEaZsgG030Jjtdv
         gaxA==
X-Gm-Message-State: AOJu0YzhLcNBWPvxG6xdG5BA650V4VkmhkxmScPvsWBHh/UgAEMBWLJJ
	ezXfkfRtzawU4QyWJovsjUhrJQJIVeSdRTRWDYsA8lSYWVZMivgiJdrSdcTSHAT24hM=
X-Gm-Gg: AY/fxX4ojdmCgWQjAuNeK9trzd9Qgsw73mT9r+2zZfnCMmpltv+LsXqfqyN78JIufgj
	Vo9J0iIx//JRdigzJtAYxNRsfJPi1CTYRcrUg8P8hyZNa6mV0/AQuWnam/UGcqvh/b4/SDapIIA
	pC1xKC1jQj8AYN6+lOWITlhT1dBNpKvQln9K4ytngEEmQta2Gq7nNNUHo1KJv84v6mmPj82XKPH
	E3o57yO5ToucMWgi3HkTBGlTQ5KMhN4Z8S5tx5+MA7ToSALzeiMcCecL0Q/iKXOAD35yh5BTU+X
	ZAvYShSafWMeDIWwK6yjEeMoTxvkO3e0ZMEFR1+nfvmesfgnNZefbFrptm3nziiRBPJoMpgjCDF
	+NrJmvWUAO90u5+Uy+RLcxFC8yJcmmLUASq/vxDcwLmpI6TCL0f5E/NVr1wnHMX39GnqVpydGSt
	hyBLaQqn56JTGHcPuGPOxre80hcvgiHJDcSGhEzNMQyp5SlumzPEeLFk4QlXw/5BykdqNdQ2/5N
	w==
X-Google-Smtp-Source: AGHT+IEifr+uy1uhPoHLuTvVGz7Xd9iaCty19INqspMMKOXS1f3jlnb0lZncbLZUVe5pkC7fG39rbw==
X-Received: by 2002:a17:907:8686:b0:b7c:e5d6:2462 with SMTP id a640c23a62f3a-b8036f60923mr311716166b.28.1766155289193;
        Fri, 19 Dec 2025 06:41:29 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037a5bdfesm247266966b.10.2025.12.19.06.41.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:28 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/26] libmultipath: remove free_paths argument from free_pgvec()
Date: Fri, 19 Dec 2025 15:40:53 +0100
Message-ID: <20251219144108.237928-12-mwilck@suse.com>
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
index 91c8d58..8d9c0be 100644
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


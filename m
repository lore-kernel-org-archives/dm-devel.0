Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC33B18F2DB
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 14:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732545160; cv=none; b=nedLliGJRmKkpstQEUnENo7eksebM95k64JzSRe2IhgdRQt/KEKpVi3m65Mwd27/BoGQ3GsoOV4OdmJNa09oBgmuKO7XKhhziklatNXv4muvWC+qrGAhCiIKyN/6CQpdcRTQdZQRTTJPiCCeKjNUzOdBuGQeSocn4eiczR46mzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732545160; c=relaxed/simple;
	bh=CuACxtTcfHIQP+6vMPYr4FxMUK2BBukZaS0UQjJn4gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnA/fRWhRkTIjWb1sMY59YCk/Fq36TvukyFIwgDYiSsDhNIGXv5u6zOnRfvdtfAHe9wT74Rz4fmV8M8u50EjxixGVK2ZuvgK3VudJeuLZ5MG4supSdhS5CpxTYBBHVQFowAJbtmFykWyGpn6cSu6wJ3nZzFKZX0glAaqlSC/Izs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b1hLog3J; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b1hLog3J"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa51b8c5f4dso397612066b.2
        for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 06:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732545157; x=1733149957; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYm3Cau7rRrbqxoOYXZrlPRfPTCGqsWUPnVMetDEeZs=;
        b=b1hLog3Jt7j3fJYCfukvF2TvuZC6qDnEvDMJoq6VIhPdx9WYivgtFGRtaRAnFtrHi9
         st/lWWPI33E1EEWJaI0Y5VyrEy74xukQVDGNBpN3M83BLprjhZhXrlPLYEmcEx7SFHFO
         dM1bJU+pe3ygLDvhL3tYpZNyzIF9rn/FjawsTJu+77zoboV4f7iY86ORqQIsT8stifRc
         aVhM5hi0aNCpIkr81alkNGj+e0LjCYTrGtZ9ZBbO2rjjtRPow5fyRQ2ntjRBCOE3ZhIq
         4M1khxEOJnXpxpLOAaGRx90frNPKceL7ETDKkQSsRMQU+DUiGmj/wkRsekDBABjE6MoN
         JwFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732545157; x=1733149957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tYm3Cau7rRrbqxoOYXZrlPRfPTCGqsWUPnVMetDEeZs=;
        b=IS2ZpMoQC69LXMHZY1X+8mRQiVRO/2XD7Ard667CzSj4zumnsikxNazyWToxOyIck2
         VW+Taru69r9sI3jBrCxzxvzRqc5RenQb6bhuHDlMg7o9BHt53HKfNbumpFBQeuteu3iU
         zrjHhWMUOt+DgatL1c7kRKFYjhM5GXEqnrnJK3YSAPwu8QE33VKFkB+iimJzZvnjx+E6
         1vmyTmrpvmfgnWYuWv+bvFZGnKVTFf2MQPqfRv4YKU3hoVgbt2EF3110qA7tUhrBWh4E
         kAD5OoHh36HH0hfXXf2jgib2GM0ZrcXA4s+oHqdnsEKJTYdVsamAxNIcN39KJVUuaUaB
         FfUg==
X-Gm-Message-State: AOJu0YxdkUGxW1k6Pz8EUJGpjNt9nafMvx3w9qmwG6I29KAYDwiBYlwe
	fkPi24fKpOd66cej5WB4e9C6RQOcQmLC4BhYwlUjlZJcow08rlI+Ms2a7g5jf2I=
X-Gm-Gg: ASbGnculRIHjE32uiyZ/4pjVQrOVJBh0jWENY6qD1WXPppMiVMb3Tawgj2VhbSLuYq0
	p7Fwt0EDk/InXTLVlAIlgsBjgsKYrgdKMzaHnCQ7f1axbzErt7qdUmj3b9FS6v4BAZj/GAdX5T9
	9UHg1F6tUSd3EMCKrQZlyQ/lyMifs9spRZp0buWExw7DakoNgTjSNWE141wKljB39NtPoXszznn
	odjKdSWec2AHWge1uzfWBZnwfCX4LWdq8FgLPynJ0HcUbB7ru22XVxkImCCx6Yx0CgCc908bilD
	Hj48BsxrrsK5kxNexhjsqCJkrDHunIw8UozG
X-Google-Smtp-Source: AGHT+IFJjr8T7qJ6Zc8R05XBgnLluvMfOA3rxjhqBacV2cCprk2s0Nk6KXxjLUDp9wzi7HSqi1YkVw==
X-Received: by 2002:a17:906:2182:b0:aa5:3853:5536 with SMTP id a640c23a62f3a-aa5385357camr644386266b.46.1732545156687;
        Mon, 25 Nov 2024 06:32:36 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa50b28f719sm468542666b.12.2024.11.25.06.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 06:32:36 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/3] libmultipath: fix handling of pp->pgindex
Date: Mon, 25 Nov 2024 15:32:22 +0100
Message-ID: <20241125143224.51934-2-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241125143224.51934-1-mwilck@suse.com>
References: <20241125143224.51934-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pp->pgindex is set in disassemble_map() when a map is parsed.
There are various possiblities for this index to become invalid.
pp->pgindex is only used in enable_group() and followover_should_fallback(),
and both callers take no action if it is 0, which is the right
thing to do if we don't know the path's pathgroup.

Make sure pp->pgindex is reset to 0 in various places:
- when it's orphaned,
- before (re)grouping paths,
- when we detect a bad mpp assignment in update_pathvec_from_dm().

The hunk in group_paths is mostly redundant with the hunk in free_pgvec(), but
because we're looping over pg->paths in the former and over pg->pgp in
the latter, I think it's better too play safe.

Fixes: 99db1bd ("[multipathd] re-enable disabled PG when at least one path is up")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/pgpolicies.c  |  6 ++++++
 libmultipath/structs.c     | 12 +++++++++++-
 libmultipath/structs_vec.c |  8 ++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index edc3c61..23ef2bd 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -127,6 +127,8 @@ fail:
 int group_paths(struct multipath *mp, int marginal_pathgroups)
 {
 	vector normal, marginal;
+	struct path *pp;
+	int i;
 
 	if (!mp->pg)
 		mp->pg = vector_alloc();
@@ -138,6 +140,10 @@ int group_paths(struct multipath *mp, int marginal_pathgroups)
 	if (!mp->pgpolicyfn)
 		goto fail;
 
+	/* Reset pgindex, we're going to invalidate it */
+	vector_foreach_slot(mp->paths, pp, i)
+		pp->pgindex = 0;
+
 	if (!marginal_pathgroups ||
 	    split_marginal_paths(mp->paths, &normal, &marginal) != 0) {
 		if (mp->pgpolicyfn(mp, mp->paths) != 0)
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 61c8f32..4851725 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -239,8 +239,18 @@ free_pgvec (vector pgvec, enum free_path_mode free_paths)
 	if (!pgvec)
 		return;
 
-	vector_foreach_slot(pgvec, pgp, i)
+	vector_foreach_slot(pgvec, pgp, i) {
+
+		/* paths are going to be re-grouped, reset pgindex */
+		if (free_paths != FREE_PATHS) {
+			struct path *pp;
+			int j;
+
+			vector_foreach_slot(pgp->paths, pp, j)
+				pp->pgindex = 0;
+		}
 		free_pathgroup(pgp, free_paths);
+	}
 
 	vector_free(pgvec);
 }
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index d22056c..64c5ad5 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -139,6 +139,13 @@ static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 				must_reload = true;
 				dm_fail_path(mpp->alias, pp->dev_t);
 				vector_del_slot(pgp->paths, j--);
+				/*
+				 * pp->pgindex has been set in disassemble_map(),
+				 * which has probably been called just before for
+				 * mpp. So he pgindex relates to mpp and may be
+				 * wrong for pp->mpp. Invalidate it.
+				 */
+				pp->pgindex = 0;
 				continue;
 			}
 			pp->mpp = mpp;
@@ -354,6 +361,7 @@ void orphan_path(struct path *pp, const char *reason)
 {
 	condlog(3, "%s: orphan path, %s", pp->dev, reason);
 	pp->mpp = NULL;
+	pp->pgindex = 0;
 	uninitialize_path(pp);
 }
 
-- 
2.47.0


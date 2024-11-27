Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012D2202F71
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 23:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748682; cv=none; b=qIPfWMI+P0QpMMGsHwtXbSl61Yxg/PFnxQDoh0vhsQTsGtuc4ncqekOJoVmHPVEI/ClJNXowYmQyNUMR9rPEHCev2jz2cAhHH0djecfcKrvYWi+z2HMN/jfnjUrH7pELEpQeSMZaoWnPT/a3gvz+S4uEvh+Chn48kdhRiVv0jS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748682; c=relaxed/simple;
	bh=VP699SPieS4EpYkuuwK5suHCqsorrOXQSYXuM3atX/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMJVXwvREYdRjuPPaWTHKItopIQzumR1u7LWffU2Ljk/Q4UM0UhFakT6+jIsS0adLnReZ6ziUSyYEmDYjdzskPZKvaeisiHdZ0YmTy8P87mOCHRFHOt4v+OoFQRo18P4plZ9IL0xdI8lOecV/n2c/pKYtjdVWAhawI9nfzzPzXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d4svfP/L; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d4svfP/L"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-434ab938e37so1106205e9.0
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 15:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732748678; x=1733353478; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GIL0oYsqG4cDKJBSXjIgjmATe2D58BHvG6PUTe0fWfQ=;
        b=d4svfP/LjdTzghJszVDWdr2bGAUJXPiWSsMxFGPX0K95+UohUP1/3P7I0Fnzm15huP
         1kLx9D6nKVyzi6z3QWw6t9xXbGbCtpYkCak/YElFIyZ4oREoZ5AdRgI1Ffz/WGDyNA8T
         BI4mC4LWFbPXcUubWxFRdm6ezPIDhvdtFR3Qn9a0YfwiETmpe55DD7phxFchJuR65qPL
         JcYAmX41UEV4K75I/747TynzZSNBqmI5TybOXK02MFDjk0qXu1hn9eJtYLZ5Rn+78Naw
         s1UD7HfAlWHL2b5TU1rBcX+Jbd35h1GiXnmoXsISNUb94mxo9+PuZrMRb2ouctzPy2o7
         bNPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732748678; x=1733353478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GIL0oYsqG4cDKJBSXjIgjmATe2D58BHvG6PUTe0fWfQ=;
        b=t577GBB+ych+zyqs9ZDFG3+BSoY0bpmT/XtvBhyHxgtJidGHqVgnjuJUJ1EB1TvvI8
         jhgQcCDf3t7SMuMwU+EHxk4CTDa3MiSL7U9QFbsl7BwiSTEkdD+YXzrj3lPL3XlvQRIm
         zTO1XS3n/D/4iId2tbdRb4kk+td5cPoscnVx24lm54X3Ywev3y5hy5zuO/NyjUXzeS65
         UabOQlDsWlvGmYcSjAbKZnpQkZb9wtFJZRwQuwTTtX2TmMmnR+e+HTEeHGtsBcUnXzOZ
         /8iHQTzqRkQg41Zuzcmd7Ylf+J8CWoaHJiN9pIB+aEbppiam4XjHjgIkcw2CGQRSq/H4
         BXqQ==
X-Gm-Message-State: AOJu0YzczeHi4BtKvehkiAYjCaPlQcQQzQzFSVMNNtQIAmsdfHlUuu0A
	+nuCTOgmmTGmwMr8XDACLtyrui7b6TZioqiRndcFe2zkMUojQbWsPlu9/7/py28=
X-Gm-Gg: ASbGncus3OohzHiKTQlp393MhxsItnSL94wDva/+U9D25bplsWXd1pHPzEHnnwVw6EY
	EOd885U4hFmUMP1lO7U8jrsZHDv1OHw2HGTiJIwE/TSXIO/W32GRERNU+0VARIUCIjBRnAvRvCw
	9uc1Dy4WPL3LKLHhQ60irHyfbuQFbfSoiv/ldRdjcwr4l7p09Wuf6ZMBHxOigY1rYFywvGYgA4m
	R2nY5iRrJxEB5yB0rAa+OrbKZKJBs5aDu3kzqr7RCTFtxDc5DlVIkT2mU0M4RFjby1ZvyLcsoBE
	P63UitwxYjf6ZtfRU0DHFF1PFCw/rFD47IcN
X-Google-Smtp-Source: AGHT+IH+QqLc0ulfgKKUGPsh+how/Rp9n0iuM5E5Q04hcLtTQy1WMxLMtLXg32LKXrbUyg+U133E8w==
X-Received: by 2002:a05:600c:3546:b0:431:5044:e388 with SMTP id 5b1f17b1804b1-434a9de78d0mr40726085e9.22.1732748678143;
        Wed, 27 Nov 2024 15:04:38 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-434aa7804fbsm34732595e9.21.2024.11.27.15.04.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 15:04:37 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/8] libmultipath: fix handling of pp->pgindex
Date: Thu, 28 Nov 2024 00:04:23 +0100
Message-ID: <20241127230430.139639-2-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241127230430.139639-1-mwilck@suse.com>
References: <20241127230430.139639-1-mwilck@suse.com>
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
- when a pathgroup is deleted in update_pathvec_from_dm(). In this
  case, pgindex needs to be invalidated for all paths in all pathgroups
  after the one that was deleted.

The hunk in group_paths is mostly redundant with the hunk in free_pgvec(), but
because we're looping over pg->paths in the former and over pg->pgp in
the latter, I think it's better too play safe.

Fixes: 99db1bd ("[multipathd] re-enable disabled PG when at least one path is up")
Fixes: https://github.com/opensvc/multipath-tools/issues/105
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/pgpolicies.c  |  6 ++++++
 libmultipath/structs.c     | 12 +++++++++++-
 libmultipath/structs_vec.c | 15 +++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

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
index d22056c..35883fc 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -108,6 +108,7 @@ static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 	struct config *conf;
 	bool mpp_has_wwid;
 	bool must_reload = false;
+	bool pg_deleted = false;
 
 	if (!mpp->pg)
 		return false;
@@ -125,6 +126,10 @@ static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 
 		vector_foreach_slot(pgp->paths, pp, j) {
 
+			/* A pathgroup has been deleted before. Invalidate pgindex */
+			if (pg_deleted)
+				pp->pgindex = 0;
+
 			if (pp->mpp && pp->mpp != mpp) {
 				condlog(0, "BUG: %s: found path %s which is already in %s",
 					mpp->alias, pp->dev, pp->mpp->alias);
@@ -139,6 +144,13 @@ static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
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
@@ -237,6 +249,8 @@ static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 		vector_del_slot(mpp->pg, i--);
 		free_pathgroup(pgp, KEEP_PATHS);
 		must_reload = true;
+		/* Invalidate pgindex for all other pathgroups */
+		pg_deleted = true;
 	}
 	mpp->need_reload = mpp->need_reload || must_reload;
 	return must_reload;
@@ -354,6 +368,7 @@ void orphan_path(struct path *pp, const char *reason)
 {
 	condlog(3, "%s: orphan path, %s", pp->dev, reason);
 	pp->mpp = NULL;
+	pp->pgindex = 0;
 	uninitialize_path(pp);
 }
 
-- 
2.47.0


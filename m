Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6D6204087
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 23:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748686; cv=none; b=JaX0YWYF8bzR6FCd882Rd1nQ6FybjrIuA8BMXQIEeLa9eh7KFphmvAkcAwqQ6BzpD8xKTPTLAJ+joqTVR2VNCpXwr1QL2tKgN3As3YPVnN2kHWS6ZlE8P7DD9KmP8+Tnit8J7JNh0AjgMaRFYmA1dMIpDOZadK+oAzzctisArpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748686; c=relaxed/simple;
	bh=lxTFy6jJzIon/IJFM9OVu6a5u22eyDOg1t1zGeBhZLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JK4xs9IjR8MKNOFvwRf4JwXn8Y6dSY8VgoFfRTwzNeIqgVpaC7m2u7i+xxL+XYZdiQ1seuvr9cHU99Ghm1aMl6YVRSXEFo/UO2gH429BhJpeNKCFKKSimK1FUnIGsOXeudPDS2+m1Ul8T8G3wvYQyPCNFKUXiNYQjzZeFb/iNIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R2Ex3X9W; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R2Ex3X9W"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-434a83c6b01so1654295e9.0
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 15:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732748683; x=1733353483; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTVUYr3FUXW0DkJ4E5yibvxLSGtXLyvZowRC/+2BwpU=;
        b=R2Ex3X9WuZWgQ+APwgGt/jJq6eH5fzAqpSGLQmdF3nJrSKEKzfAQmU5Rt7DNexsd5W
         Tub2t228UsdONi2ulnJK3oK6LL5nL2nsv+m6xBmnM4v5I0d82+dFnKLQfuPkhjPV3Rtc
         lHU6Z8sH3tliIo/KRRmxva080BCJWkVmth5fl+sfshGDs4qZK87PbIIx8qxpyrFoEZbJ
         84J7rdxdtOysmrov8UcEvOoLLROfiAlZSl//lGTYd/AkRg0ZALxybtYYnvLLgF8ID55g
         0pVepePHQnSjxkxlsgJ8QjRDfpeOf1mcbsz9XQDoog/BCiE8eeq6sRQh6BkyhibNgFnk
         xyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732748683; x=1733353483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTVUYr3FUXW0DkJ4E5yibvxLSGtXLyvZowRC/+2BwpU=;
        b=Dxg2RbPS0JTRwhbsHCmBeq3SrZcDsmTzQa3OI5WeYsXkiuZ7u6zKGqnYSb14dzDg56
         YYRTqz/2S6IzLzPJ+eqqwh9IsZ7Ahs0YG3FDaS17rnONsXuNFKTnQZ1+rSkNySmRIqUl
         3rpPziJ5CdRNdcvOEU8fcSAxOQUgSAOTiuMwwfwdNFqlaLB1RcCHkB6KwJrbDQpNt0uo
         1/5DR66eVGweEgwloUj1CnmRsgqf/HsKJYMmVaS1+jxBiIDMIJmUvQ3L4rD7rdLjdkYj
         D687DDM7SAVC1Bi+nFd8N6zX5m5aD0PF/mkxXNiWrjk6WfZvN/roPqKqOVavpJ9t/zBN
         g4Lg==
X-Gm-Message-State: AOJu0Yyb0YPsIPyR+u8mF3js+aapxqJ2SZFyqr8Ms4UCxE+I6Q0+2Wwf
	9TaYe9KLQ/rTC8mxj/n5e9s7ViTVUg5fesqzvFio8OUoRVnirA19hwXK2h+01Ce5icvxz5bZDMx
	4
X-Gm-Gg: ASbGnctuzlmz8TIJ50mLC6wGRmSE6KNJcba1dlzgbf+1ocwZhPi+xOCIid8Hy+BOMN1
	qSK4sEmjappEI1sIUJVHHtG0v5QLRkEiTZazhiFAlNKeKzJu0weGj6wXCluDK00hXI8Thnuqrzb
	Mow5sGaliHkDCDzK+EPw7O9B0zsUkw4AQLmuYhA2KMZFzHUKmGTBP3Ftsqn7LBechIHJ8OWGBZM
	iXWexV/ctb8AdwHxrpB3jo5613EoruaTuO8jq61Ix24ZhGPP5pI/6As9ymvgr2vVdsEDwpajjuF
	6OcFPh9LBnqxPa7msp7qtADQaPM2pxAVncLc
X-Google-Smtp-Source: AGHT+IHFeo8bNUIJFbjoNopc+kcNPPJ8UJwNXWbG/rJErIed4zihaS+2mAQ4oYc8idtUN/TU7H1GAQ==
X-Received: by 2002:a05:6000:1866:b0:382:4a98:da57 with SMTP id ffacd0b85a97d-385c6ed75afmr4515544f8f.47.1732748682564;
        Wed, 27 Nov 2024 15:04:42 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385ccd2db59sm79343f8f.11.2024.11.27.15.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 15:04:42 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 5/8] libmultipath: re-implement pgcmp without the pathgroup id
Date: Thu, 28 Nov 2024 00:04:27 +0100
Message-ID: <20241127230430.139639-6-mwilck@suse.com>
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

pgp->id is not only calculated with a weak XOR hash, it can also
get wrong if any path regrouping occurs. As it's not a big gain
performance-wise, just drop pgp->id and compare path groups
directly.

The previous algorithm didn't detect the case case where cpgp
contained a path that was not contained in pgp. Fix this, too,
by comparing the number of paths in the path groups and making
sure that each pg of mpp is matched by exactly one pg of cmpp.

Fixes: 90773ba ("libmultipath: resolve hash collisions in pgcmp()")
Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 94 ++++++++++++++++++++++++++--------------
 libmultipath/dmparser.c  |  1 -
 libmultipath/structs.h   |  1 -
 3 files changed, 61 insertions(+), 35 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 9ab84d5..bd71e68 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -416,16 +416,6 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	return 0;
 }
 
-static void
-compute_pgid(struct pathgroup * pgp)
-{
-	struct path * pp;
-	int i;
-
-	vector_foreach_slot (pgp->paths, pp, i)
-		pgp->id ^= (long)pp;
-}
-
 static int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
 {
 	int i, j;
@@ -445,32 +435,74 @@ static int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
 	return pnum - found;
 }
 
-static int
-pgcmp (struct multipath * mpp, struct multipath * cmpp)
+static int pgcmp(struct multipath *mpp, struct multipath *cmpp)
 {
 	int i, j;
-	struct pathgroup * pgp;
-	struct pathgroup * cpgp;
-	int r = 0;
+	struct pathgroup *pgp, *cpgp;
+	BITFIELD(bf, bits_per_slot);
+	struct bitfield *bf__  __attribute__((cleanup(cleanup_bitfield))) = NULL;
 
 	if (!mpp)
 		return 0;
 
-	vector_foreach_slot (mpp->pg, pgp, i) {
-		compute_pgid(pgp);
+	if (VECTOR_SIZE(mpp->pg) != VECTOR_SIZE(cmpp->pg))
+		return 1;
 
-		vector_foreach_slot (cmpp->pg, cpgp, j) {
-			if (pgp->id == cpgp->id &&
-			    !pathcmp(pgp, cpgp)) {
-				r = 0;
-				break;
-			}
-			r++;
-		}
-		if (r)
-			return r;
+	/* handle the unlikely case of more than 64 pgs */
+	if ((unsigned int)VECTOR_SIZE(cmpp->pg) > bits_per_slot) {
+		bf__ = alloc_bitfield(VECTOR_SIZE(cmpp->pg));
+		if (bf__ == NULL)
+			/* error - if in doubt, assume not equal */
+			return 1;
+		bf = bf__;
 	}
-	return r;
+
+	vector_foreach_slot (mpp->pg, pgp, i) {
+
+		if (VECTOR_SIZE(pgp->paths) == 0) {
+			bool found = false;
+
+			vector_foreach_slot (cmpp->pg, cpgp, j) {
+				if (!is_bit_set_in_bitfield(j, bf) &&
+				    VECTOR_SIZE(cpgp->paths) == 0) {
+					set_bit_in_bitfield(j, bf);
+					found = true;
+					break;
+				}
+			}
+			if (!found)
+				return 1;
+		} else {
+			bool found = false;
+			struct path *pp = VECTOR_SLOT(pgp->paths, 0);
+
+			/* search for a pg in cmpp that contains pp */
+			vector_foreach_slot (cmpp->pg, cpgp, j) {
+				if (!is_bit_set_in_bitfield(j, bf) &&
+				    VECTOR_SIZE(cpgp->paths) == VECTOR_SIZE(pgp->paths)) {
+					int k;
+					struct path *cpp;
+
+					vector_foreach_slot(cpgp->paths, cpp, k) {
+						if (cpp != pp)
+							continue;
+						/*
+						 * cpgp contains pp.
+						 * See if it's identical.
+						 */
+						set_bit_in_bitfield(j, bf);
+						if (pathcmp(pgp, cpgp))
+							return 1;
+						found = true;
+						break;
+					}
+				}
+			}
+			if (!found)
+				return 1;
+		}
+	}
+	return 0;
 }
 
 void trigger_partitions_udev_change(struct udev_device *dev,
@@ -763,11 +795,7 @@ void select_action (struct multipath *mpp, const struct vector_s *curmp,
 		select_reload_action(mpp, "minio change");
 		return;
 	}
-	if (!cmpp->pg || VECTOR_SIZE(cmpp->pg) != VECTOR_SIZE(mpp->pg)) {
-		select_reload_action(mpp, "path group number change");
-		return;
-	}
-	if (pgcmp(mpp, cmpp)) {
+	if (!cmpp->pg || pgcmp(mpp, cmpp)) {
 		select_reload_action(mpp, "path group topology change");
 		return;
 	}
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 1d0506d..c8c47e0 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -307,7 +307,6 @@ int disassemble_map(const struct vector_s *pathvec,
 
 			free(word);
 
-			pgp->id ^= (long)pp;
 			pp->pgindex = i + 1;
 
 			for (k = 0; k < num_paths_args; k++)
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 49d9a2f..2159cb3 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -531,7 +531,6 @@ static inline int san_path_check_enabled(const struct multipath *mpp)
 }
 
 struct pathgroup {
-	long id;
 	int status;
 	int priority;
 	int enabled_paths;
-- 
2.47.0


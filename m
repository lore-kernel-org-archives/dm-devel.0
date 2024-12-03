Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D791E47C6
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 21:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733262439; cv=none; b=rDN+I6sFmTo2+eqsOoes6h1VwN0RFA+m6Ha5pPehI18BalGYP+/JvKQcDW+YW7hS8Ktcx5ah8vwqfbEXHwzgiszIOompoKGbapM4QUXGjGkkSeYRYkzHVnSIrw3b/VmCP7MSJLh/kHpqGCKFoslN0YjXc4i96GBFsXCa3zVc01Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733262439; c=relaxed/simple;
	bh=+ILs4MmP/Td3y7CIjSt+V98VPZnpqvoUHe3PvqNYvtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo4Jtylft4TaFHn9RI6uDzMFhemj5YnujG1TtpYfiGFfnUMUCTKOLkBo+AXy8fNod2uUtlTjbK1vP7Ha9zalq7NYd4uwRY/DseL+mfqrRccX7iKdYnlFQ5tAxRzyECXZr5Mr7MZYXfJbdKdb5I2qBVBYtzFOunf7+YUlRLjrD1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CzwmxK6L; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CzwmxK6L"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-385e1f3f2a6so2809469f8f.3
        for <dm-devel@lists.linux.dev>; Tue, 03 Dec 2024 13:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733262435; x=1733867235; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJoXr8A80vm54VrYcBYcbLrs/gP5/8CwvM6Ya9CgJ0I=;
        b=CzwmxK6LXuPSRcbeNeSjLe1Z0V4sYL++GWiPGwZZSDVQc7hJA4F1WakKMq+TtRN03Z
         Moe0mSgB6jYbY0ekrkvN8D0RGV+6VP/yS2xM79fUByQAL8KF0iMGt6l/XOZjHLTY3juf
         Ze1QOAeKTiqpMG/kqnnTkQGtOGhniwn4wT40PzLWLHV97mRbX2w2NSWts/bRT8RaQOEw
         du/A6XJjQHkuK+pFUkXUMTiXwuKdWAiAetd+rUDCZ10QtuwN7iOtQs813QBRoeCBpZpr
         yP9vQiAShhgzh1k5xXuTOwMrzaW/bAv/wifYAp+Pbug7ibr3cFB17TlexYXS/vhVlo8x
         OJ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733262435; x=1733867235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJoXr8A80vm54VrYcBYcbLrs/gP5/8CwvM6Ya9CgJ0I=;
        b=Iw3N2VsdWheP2I2e9kmD7lnRTcCCwktkN+vlEVB9W2B5GxSKfp+BhikKbsIwZg1fmo
         tQLW4mKkX/7lzeQgSjQ6bf+CpuoEWWJdWtlp7+xomNtm9Go2DDWU6voOrB9as+FPZbId
         iuZWONbHJy2NXAuPSWEU0YgKGlpTELM0cw5jmy2Br4Gjs8TjQbTG52XcJxAEi7NnM9jN
         0JOtcXtNyjO55r9zGlVyo/GotQD/qPdhw5fgVCc/CFgZcpfJ0O/SIffqtsUBhXKkKIuj
         +bgCfiVT0bnE1ruplHceO4C/YGQOGimoj8oEAQbvtSSMSEeb9EOfwZpKBPa21jIGA8R/
         54zA==
X-Gm-Message-State: AOJu0Yxi445CI0QZnb3ENEu+1RVNB5076C6Uk4f7n0Xy9ZQCM5mtqLpP
	xobYeXFeiCLWzvPuRXMQ1gPLp36FzHV6glZJn2eNR7Ahhkkp5neVdKlx/o/6Sh4=
X-Gm-Gg: ASbGncuvdiweVXn9mk4Hq3cmGs38uZlBR0cNj5yqXqVaODhDVVYTt/WoSqnOrD6tCoq
	OfPqVdB4a3qJ41FymK+lDXspwUeBUO01NDVUJztzvqtQgeJnr4kIH7XxcTuP6VSgpl7CbaeiXRq
	xXvl02HdXMoF1XVji7Ystt4k0OhCBrudB2LaiNmfsOosKdC5jH5Ts2PwSMJf0ttM3QRB8GyjRtG
	zVihIozPlCKTnu1MOvI7zNB8ytSNABM0o9/Zq9zfR2ZBvGYNYw/tdXchVmvy3+dy8LvnRzaKluV
	gOqGr3i/9GJOqnIpbHtHM4IzPTW2P4Z638GS
X-Google-Smtp-Source: AGHT+IG3wkuQAT88NPZmSl0h3Ktr2YlT9ZpwuEdad+XShJA0h/ae5UWadeeYP7W96tUZ+hgookm0SA==
X-Received: by 2002:a5d:6daa:0:b0:385:f195:27f with SMTP id ffacd0b85a97d-385fd3cd094mr2897223f8f.5.1733262434694;
        Tue, 03 Dec 2024 13:47:14 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385ebaf3bccsm9148789f8f.68.2024.12.03.13.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 13:47:14 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 5/8] libmultipath: re-implement pgcmp without the pathgroup id
Date: Tue,  3 Dec 2024 22:47:02 +0100
Message-ID: <20241203214702.107918-2-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241203214702.107918-1-mwilck@suse.com>
References: <20241203214702.107918-1-mwilck@suse.com>
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
 libmultipath/configure.c | 87 ++++++++++++++++++++++++++--------------
 libmultipath/dmparser.c  |  1 -
 libmultipath/structs.h   |  1 -
 3 files changed, 56 insertions(+), 33 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 9ab84d5..bfa8a39 100644
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
@@ -445,32 +435,71 @@ static int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
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
 
-	if (!mpp)
-		return 0;
+	if (VECTOR_SIZE(mpp->pg) != VECTOR_SIZE(cmpp->pg))
+		return 1;
+
+	/* handle the unlikely case of more than 64 pgs */
+	if ((unsigned int)VECTOR_SIZE(cmpp->pg) > bits_per_slot) {
+		bf__ = alloc_bitfield(VECTOR_SIZE(cmpp->pg));
+		if (bf__ == NULL)
+			/* error - if in doubt, assume not equal */
+			return 1;
+		bf = bf__;
+	}
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
-		compute_pgid(pgp);
 
-		vector_foreach_slot (cmpp->pg, cpgp, j) {
-			if (pgp->id == cpgp->id &&
-			    !pathcmp(pgp, cpgp)) {
-				r = 0;
-				break;
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
 			}
-			r++;
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
 		}
-		if (r)
-			return r;
 	}
-	return r;
+	return 0;
 }
 
 void trigger_partitions_udev_change(struct udev_device *dev,
@@ -763,10 +792,6 @@ void select_action (struct multipath *mpp, const struct vector_s *curmp,
 		select_reload_action(mpp, "minio change");
 		return;
 	}
-	if (!cmpp->pg || VECTOR_SIZE(cmpp->pg) != VECTOR_SIZE(mpp->pg)) {
-		select_reload_action(mpp, "path group number change");
-		return;
-	}
 	if (pgcmp(mpp, cmpp)) {
 		select_reload_action(mpp, "path group topology change");
 		return;
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


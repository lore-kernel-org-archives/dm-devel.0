Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1840B29AB11
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983978; cv=none; b=ZgWsFPRVKiySTkPMpdbVPBSaMW5bgmyYj+EMaQWmcial+CKhiS7ZdshEcDbJHPFOWAv/m12/+vWsb8jwaRreLZBhGLJQdpj70x84nY4BRs1SIWLd6BIkBFjxGNMHYRTQRcFtEZjN2UgxS9ptxNrZ/20/Rwyg6Qd4Dp+6lqpepzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983978; c=relaxed/simple;
	bh=WoVSlomu19WkyD9dauK+bSCbcgoNQzhdtKD9XuZRstE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdWqS75v7HApR2FuhGTdGFM/WdyCwjF89qFGx/CbklQYIhpCoHrOeVgVxFls09/usJeA7OVmSYhbfu11Le8R5kkAQdUOI4M7aK8XBLuNxC3HVfMv3To+XGMWD0KCKCz/Q/8uXkQDuVe21ElyoRCeVEIvucBwS5z+Fap7pjwwvZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LKppRgNX; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LKppRgNX"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-432755545fcso2677955f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767983974; x=1768588774; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ic7f0MAvOLlPIdakRKIRjp9qXsTDEo0Xic5rBhPl7Mg=;
        b=LKppRgNXyFRB0d/BP56nraOgaa+iVgjE3U+B+w7HmA7Po1Am9jTeETTuifL9NmwzFE
         fQjJGLGKhpEFnqqihI5uh6i1WEjN0nFdIhcocb4bVl3Z3hN01w1BFrUkNMYCodwBFcKw
         KB7QuHb9lX9rvdw7TNT6MWrUytx7G/2Kw5LWOZtOW8JE7Y/f1osnRtCq2BBR6dR1VR9A
         GIg+O5GQlKaZkNfFv3Nh/PCm2k+Xx9pfQhqAOY9nLoIyEhU1d1rZLuEqpmmKw68NKcVZ
         CuArEAx6Qqg/nMqxZ0xGABWpCOZdSmU0HKFKbGSQSovJp4PGxAC8bodMzyXB4AmoH+ky
         eohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983974; x=1768588774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ic7f0MAvOLlPIdakRKIRjp9qXsTDEo0Xic5rBhPl7Mg=;
        b=V39JvZGj7qsO9+v8APaT/6/X0kcohvu/hoQ++ZcZCHYM8GOXkMKkB42lY32+YiH+WN
         5mVnQIHArheA1jSuvYbVBlWjEcCHLCh3RUCcEs+vjsmL0i7XPIXRDj9kxl+2FD2JXzNZ
         GTWyfBYkT7whaGgh5/lIYuK+jfwFGmqG8xstnmJjCf5bYYa46XnLrRSVvkkZX7fBhiAy
         Whiw/+TdCr4vGJQjNSUECgWsZ4Z3UO1EyiK7FIFof5u2IY2ueQKQDrRZ1f30dcFznOIp
         qAOEUGenSgSCdOv29Omx3lmOgdC4JmGC1SweX7PEqmJe3GD1/Oj0WXa0+Ldjp43+Jotz
         h5ag==
X-Forwarded-Encrypted: i=1; AJvYcCVSW0Gr0nnqdEcEhK83YkIGPiYRvB5SHZnLyAi/HzwlNhPmkeRNp3wtkI9JA8noYhKM8/wlRC37Kg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwfI3kb1AfYEDsyrDoO1UlrsxvC58q61bsOsH3L9RMKiaMVT4G0
	zBJaRjGRFauJA5v4YBaSP22j+t1b2jazrvqO0Qv86ydtGmoPtiLShONk4hdSgfz5LQ1eFzUf0dP
	q9UQN
X-Gm-Gg: AY/fxX6yLTx9eZpd8p6oiOToNFqcbjsb6Jmu6BgWs0RlnlpPUhPKD4KgsQ5ApBYKu4D
	b8bD92h6jIG69HGVToW+MJXjJBVRGDV3ombQ8Co3eYFVaC4Fq27zpApZL4sX0O1VYvZU99ID2Gn
	Zek1IaycaHvtXrKPeJGmT8M6v1mBsNNjrSfCwHwANq/gl5fhReuJNvqE0rf7YfxnoPDAVQAhFVA
	p6TDIHWkc9xaug0l1guzaQ42mrrjXka7/0nWdeEbWoTxln9kNpMkqCKETaGR3IsCQC5S5+api7r
	ijKjbYifylz17XczUWeIj10DEOy3S2vG0lx2eCYKmoKrdVSeN1qEgiE0lTSwgm+GJDFT1NKxtaI
	8zUxpauUETYZwM9+sIdp8+Uu5lUoBQt1ubyUOq8F8MUqu4qba47ftECFyvdO0ul2avc4g753DGX
	ncijQXYuGgyulUz87I2n4cUESUPDXas+FO2mLhxdjBI4Kgzh2IkJ5e55IfkZG/rT+ymAkwbg+87
	g==
X-Google-Smtp-Source: AGHT+IHve1mlBM5dRI1od/nyt03AoC5nrLvjlrgEpXHn3y0vzT/E2jnA/9n7ZGVReVWJcrx69jgGRQ==
X-Received: by 2002:a05:6000:40da:b0:430:f23f:4bc5 with SMTP id ffacd0b85a97d-432c3760d02mr12095606f8f.45.1767983974152;
        Fri, 09 Jan 2026 10:39:34 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd5ff319sm23982026f8f.43.2026.01.09.10.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:39:33 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 6/9] libmultipath: don't free mpp->paths in group_paths()
Date: Fri,  9 Jan 2026 19:39:04 +0100
Message-ID: <20260109183907.201250-7-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109183907.201250-1-mwilck@suse.com>
References: <20260109183907.201250-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I'm not sure why we ever did this. We have update_mpp_paths() and
sync_paths() now, which make sure that mpp->paths and mpp->pg are
as synced as possible.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/pgpolicies.c | 2 --
 tests/pgpolicy.c          | 7 +++++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 57b7485..92f84c7 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -158,8 +158,6 @@ int group_paths(struct multipath *mp, int marginal_pathgroups)
 	}
 	sort_pathgroups(mp);
 out:
-	vector_free(mp->paths);
-	mp->paths = NULL;
 	return 0;
 fail_marginal:
 	vector_free(normal);
diff --git a/tests/pgpolicy.c b/tests/pgpolicy.c
index aec16ec..a37aa8e 100644
--- a/tests/pgpolicy.c
+++ b/tests/pgpolicy.c
@@ -131,6 +131,8 @@ static int setup_null(void **state)
 
 static int teardownX(struct multipath *mp)
 {
+	vector_free(mp->paths);
+	mp->paths = NULL;
 	free_pgvec(mp->pg);
 	mp->pg = NULL;
 	return 0;
@@ -165,10 +167,9 @@ static void
 verify_pathgroups(struct multipath *mp, struct path *pp, int **groups,
 		  int *group_size, int *marginal, int size)
 {
-	int i, j;
+	int i, j, sum = 0;
 	struct pathgroup *pgp;
 
-	assert_null(mp->paths);
 	assert_non_null(mp->pg);
 	assert_int_equal(VECTOR_SIZE(mp->pg), size);
 	for (i = 0; i < size; i++) {
@@ -176,6 +177,7 @@ verify_pathgroups(struct multipath *mp, struct path *pp, int **groups,
 		assert_non_null(pgp);
 		assert_non_null(pgp->paths);
 		assert_int_equal(VECTOR_SIZE(pgp->paths), group_size[i]);
+		sum += group_size[i];
 		if (marginal)
 			assert_int_equal(pgp->marginal, marginal[i]);
 		else
@@ -192,6 +194,7 @@ verify_pathgroups(struct multipath *mp, struct path *pp, int **groups,
 			assert_ptr_equal(pgp_path, pp_path);
 		}
 	}
+	assert_int_equal(sum, VECTOR_SIZE(mp->paths));
 }
 
 static void test_one_group8(void **state)
-- 
2.52.0


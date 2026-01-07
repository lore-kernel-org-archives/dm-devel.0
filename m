Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5540F3396E6
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817145; cv=none; b=YvatPq4BHTIRhsSCVCVo82kKvVzNMaXLjCohfRfnQZzrkPsXS+Xhu+/OvWx5pmWpFED/Xo/4fQh1IWKyKseDMwlGTjxNIxs5lAnr//gBr2LaHCZCN7hJRXyA8m7NP24UqBFhO/di76Um+2ioIcoE0pdyVWH0yrE/FCOqz/FtrOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817145; c=relaxed/simple;
	bh=yBptf+/m8+dsejNEJleaJRiXmUdwMXAnlei2zXt6uJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQlewLYBKdHjO6U5X/tNjZ5c9FlKs7Dlk9cBGkCpkUtkTMjPYSt3FG5J7iX2sxPDnJtJNZaqw2mGoWdRdGFEmzGQXTiDrBuauSVFLPv2ng99drp/IzqiHqwygmcuxH2FlRkcB5UREBRI4U5HATfLDKu/jpsaeeucUHA+h2u+DJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K1Q5ylEH; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K1Q5ylEH"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64b7318f1b0so3358133a12.2
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817138; x=1768421938; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E0YFvoOYkrW1pLRMUmwuhOIkTPfz72qmht3w5BQyuZw=;
        b=K1Q5ylEHk6WXAc3F9di8a9AgOvIM2R+xsbfoN+tVFix1haoQX+tgQ4O/nn8ZZfazIH
         EZwEVjFExB6gIueJlizYVLemrH3f4BhZ0aZK/lHO1RdjgFy3KaZI0fk74PMio7YYyaIp
         SgY64nCKWzW65Mayg3fmwogZNt/qeQqbUFqfRbnnKmtvWFnjpoAA8gJ+f5PulrnHaBaJ
         Pwl0NbWn3Cc2E2U91xRbOkqKf7l2QonTInbB83whVmWnJyOJUxigAUi1NbMTuGXlrVyV
         Yw7BIqoG9pkJnjnaunmHaU9/K2FNgZjEzYqW6NNXW/wuuTEt5sc8nmbgqsf9wKLHUqqL
         /H9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817138; x=1768421938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E0YFvoOYkrW1pLRMUmwuhOIkTPfz72qmht3w5BQyuZw=;
        b=K+2g6CsN+2TlynDQq2fvJ51Cs6gZ9vPYmBb1E+hfazRvSGsszRo026/JAzAhHZ3GnP
         QUB4ldrGkdslgZuhMoqc/u3mf5fjHJj+6jxba5E47hpl9JMj4xW2MyrkmxPDI29NbFU7
         o/TFDlRE56naQVOFIwUFpa1fUmMjwMRHyT93gRfinKhvGj5Uek80NvPcQvukn0I0Zuu5
         9Kp0I6lwmdmvY+j0fB0c7brVCUYUMx5yEmYj4PVFD5JsMfGqaCjIzE9xEaCQGZrRvEYv
         dsJ+O+1S0qw9yo72RdnUlp4HLwIXFKY3f+5mayiRhaR7hzQOyjYV4nsdTEoo/yuV9dtu
         SmFA==
X-Gm-Message-State: AOJu0YwRL0mNxkBprEwb9Xiv+NexNwVFaB2NlSbK6T8bORyU6n0LOxVO
	A2+Sa4JI/fQpbSAPHLGALdh1yqaPOEfJoq1EUUb0qWJnigX2dQz1Mn3aP/23IxuwZ4U=
X-Gm-Gg: AY/fxX5Is7PSdK9RPWXZZFPXWwOl8BhPyXGkHljgeX2Tc2056pgfqM2qJ5g3L+QzxEl
	Ormh45qLPam2jacMbTrlVf4XXNJHXpILlTWgeIyyDyYThp1w4ELN4wiTdCfeRHkwKeih8TU1/a5
	z7QmrfvbUV2GgvBEOsGMbUawiXN2qbi3CQGQ84iPMX1ptKQb9C8KNomZ+cGBMtcHy0UZ1VccuDp
	0RZ8TKoLKurYUh6kPriE4tkO3fBCCl0PkMX/zLG0ZtX5pMWBRTvHts+WX6e2w9wi+ZMWLSWpPe7
	UkeTXelnIB1+XTG9tsRVKwqFyJ59iivm8Monkkn/TK2NRkOuHqf9KmQkgh8KaJ1GgZsRZv9IFQA
	8g+BC5sTYSHLB+7Gv+C40GsWHKON19tJ7SWz3lM/a17nwbRYQ45GDct89r0+E6JDYV5g/rmor7K
	PQf8+8K6LTC8CmV++Q2UEsYAJCVqvDv9qzLvwrqN2qLrpUO8tk97Y9GP8gRR7Ts4ubNB0QmSvgs
	w==
X-Google-Smtp-Source: AGHT+IGg0EFI1YBIOTAKFotCuVP4ww672+5C2+7fbtxl60RXSdvgXLLooNl02m92WdBvHh92rQNrog==
X-Received: by 2002:a05:6402:4492:b0:650:8563:fdbe with SMTP id 4fb4d7f45d1cf-65097e5af32mr2853001a12.23.1767817133845;
        Wed, 07 Jan 2026 12:18:53 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6507b8c446esm5673054a12.6.2026.01.07.12.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:53 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 13/26] libmultipath: don't free mpp->pg and mpp->paths in remove_map()
Date: Wed,  7 Jan 2026 21:18:13 +0100
Message-ID: <20260107201826.323977-14-mwilck@suse.com>
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

These are freed in free_multipath(), which we call from remove_map().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c     | 1 +
 libmultipath/structs_vec.c | 4 ----
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 6f2468d..0af46a2 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -321,6 +321,7 @@ void free_multipath(struct multipath *mpp)
 			pp->mpp = NULL;
 	free_pathvec(mpp->paths, KEEP_PATHS);
 	free_pgvec(mpp->pg);
+	mpp->paths = mpp->pg = NULL;
 	if (mpp->hwe) {
 		vector_free(mpp->hwe);
 		mpp->hwe = NULL;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 54280a9..62b208b 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -423,10 +423,6 @@ void remove_map(struct multipath *mpp, vector pathvec)
 {
 	remove_map_callback(mpp);
 
-	free_pathvec(mpp->paths, KEEP_PATHS);
-	free_pgvec(mpp->pg);
-	mpp->paths = mpp->pg = NULL;
-
 	/*
 	 * clear references to this map.
 	 * This needs to be called before free_multipath(),
-- 
2.52.0


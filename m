Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCF4213E66
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528210; cv=none; b=p5LYna41b18jND90iPrlK2ogCzJuRaOWcUX+UVptSEuDrzSM6AqWAg9ysgrdSqmMEvVNkkSAj4bUcVqK/gkrSGbeqLHKq3kfZAlnVpaZFoaW+JhUGjZ/i/7122rZY+rw28U/iB5DBtPTBwHV3hOu3ppQTbTMjAKpx04s3sLbFO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528210; c=relaxed/simple;
	bh=OK5JVvaBin33/wnH+u5gj9rO7i8UGEcABa5TF/Yns8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUVryXwO0Y/Tg7dPjzr+DJPgrMoysC5C/w9ZXujD2LJwF1rcuQlnOpFXQp5C3QKKUr4OLuXHIGcViRDrQ44CTGPATJDdDSL7GYdt7jGes2ADzug5PWQqsR1umKtBH5uBM54DZMDXi3LjIwS8b/Te1hEWS7z/rJwwOAbr2fBUZ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GVgbXNOU; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GVgbXNOU"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aa636f6f0efso201993766b.0
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528207; x=1734133007; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tm0Do27B3CLVTFwAy172uniH+04DzO3Ca0sBEPc3JRc=;
        b=GVgbXNOUK+UIcQ7+4pnwGwcc7lSyWZk1DAZ4tJZD/+vbwKXI4BhGKsR8DDtP0OOUZj
         KfVaMGizlGo+e5p3zqy+XrX7wfkWz+BOHpWMciOjVwoqHJlV+tUy/qrhqdtabriRA2Vq
         xPw83N/f2Ma+OtCZR3KCEtn7riZ2Dnb8TQXng62A5b3HBJNcVFxTA2ItdS3US8fVOS2+
         4KWEilLL169Of7E9G5Iiv1KUgOBzRZ3QTy/WyyKzSl63Prb8xp5abNC+1w02q/OgFjsh
         IDja3bBq2RzrsHMFFjlMerNVHBTBxOdtGJwxawxaVHoAFOJn3cwDAmGc/pNs7I83L+gU
         VevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528207; x=1734133007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tm0Do27B3CLVTFwAy172uniH+04DzO3Ca0sBEPc3JRc=;
        b=rzLN8dzr22PrJTKBd8RHQ2kPdx6u3SRh5RImOQr7UHYbFf8BUvSFtAqndXIhXbRMQx
         gWpVJ/DB5ECrlfHyzFbnJFmQwYXlhM/ce1gHRFTrc2yTgp7aEL3ze5E23YuTadQrueVs
         SLGC4ap+WFTensIp7pdmwhRTelZA6+OKhVA2fNBm2Z7y8GA9hkPFhVBoF8SVdLNl+d5r
         Fky4VOmLvoQGJpZHc3kvqk22pz8sTaLV90uc0t1VgZRHph1kK7RnOypvAjLhbmvhC8us
         D6Zy2ygkSHDdwFMxWHvDy5GJkrFFtIhfO0EnzHaqh2VeZLlriXQIkImBRlwWTQKc80Ye
         xEZw==
X-Gm-Message-State: AOJu0YySsOqtBWazYaaiYYDvKtBVAkuNCvxd/3JtGiEsUfGgnDbWvG08
	+PSTQ4ZPfzM1elIqRsFaZecCusecqmbIKXWImKcvk/iZ4KujYoCK/VGgGTF5jwdK92VhzWrR4e3
	J
X-Gm-Gg: ASbGncv7Sq5z39pSp6EpdkaiE8UQ2n00YtSgpUg2shp/1bI27PN9EnprYAdNamGh/HE
	BKHJlQmJQKnjxp3iT9o6/3BE8ZjEH10XrkbudWpw5yXiLFWmCHaknCC9oFJH7vrGkI+GRLtBDz3
	odKC2GUcO78/x8bab7BTb/bZ8cp8o9Nq5VBLY8AF9JuuN6gV8qDpWGwgJWojfCirag+hhe0SbJw
	wK6UNiejJFRLGBWrnHSDboVfxLigSnslunZa+qN8shcrNxwQiS2CgAgQqjpxU2VHHYi8IZyQHqz
	dz8BYU4vU8apjQCFs3w2G96HfJWnmEJW/fhM
X-Google-Smtp-Source: AGHT+IE7Kx35BJNVs2/4ktlbDi8MXd+sxIPdGg2c8FOVxVMjEd85VDPEEB2U6g6shE/y6VGE3ovNKw==
X-Received: by 2002:a17:906:4ca:b0:aa6:2d86:bd2c with SMTP id a640c23a62f3a-aa63a0ed36cmr304320466b.21.1733528206655;
        Fri, 06 Dec 2024 15:36:46 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa625ea28c4sm301591466b.79.2024.12.06.15.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:46 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 04/13] multipathd: reload maps in do_sync_mpp() if necessary
Date: Sat,  7 Dec 2024 00:36:08 +0100
Message-ID: <20241206233617.382200-5-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206233617.382200-1-mwilck@suse.com>
References: <20241206233617.382200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

update_pathvec_from_dm() may set mpp->need_reload if it finds inconsistent
settings. In this case, the map should be reloaded, but so far we don't
do this reliably. A previous patch added a call to reload_and_sync_map()
in the CHECKER_FINISHED state, but in the mean time the checker may have
waited for checker threads to finish, and may have dropped and re-acquired the
vecs lock. As mpp->need_reload is a serious but rare condition, also try
to fix it early in the checker loop. Because of the previous patch, we
can call reload_and_sync_map() here.

Fixes: https://github.com/opensvc/multipath-tools/issues/105
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 131dab6..18083c7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2450,12 +2450,25 @@ get_new_state(struct path *pp)
 static int
 do_sync_mpp(struct vectors *vecs, struct multipath *mpp)
 {
-	int ret;
+	const int MAX_RETRIES = 1;
+	int ret, retry = 0;
 
+try_again:
 	ret = refresh_multipath(vecs, mpp);
 	if (ret)
 		return ret;
 
+	else if (mpp->need_reload) {
+		if (retry++ < MAX_RETRIES) {
+			condlog(2, "%s: %s needs reload", __func__, mpp->alias);
+			if (reload_and_sync_map(mpp, vecs) == 2)
+				/* map removed */
+				return 1;
+			goto try_again;
+		} else
+			condlog(1, "%s: %s still needs reload after %d retries",
+				__func__, mpp->alias, retry);
+	}
 	set_no_path_retry(mpp);
 	return 0;
 }
-- 
2.47.0


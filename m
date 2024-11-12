Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7111B202F9C
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423759; cv=none; b=hvjnfISRS6I5nJZBBDNCEYkADXeJiKmYe0fj5LOvQvgVQoAbfzx/Slg57r12Ty5SPQ0zHd0JEcCNlGPhVWFEKYF79x8EiMFSNS7VJQpf11MlS7nbhdGzHOeEQYbGvHSRuA9uyUMjCH4UHnO+JesZ4Wm2Bdv9dk2pBVtKGiizDQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423759; c=relaxed/simple;
	bh=wwpgGa1IpqLv0Y3jwkmcqUvUlItSqjpF2iQVWbPRXHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4kfQlzIJOtLdPP8jJsWeXetROExEsZRuoiYsVb1eSqleUfb70ORBIODXYSFeKd6XImNn6SIBvmkTXmPgVM6x58CuyWgpzOmvP5sC21gTX6wQYT1c0KJ4jo6UnOnldPNugbVR0CQypLSsHi7e9+7ruX/0j2eEMU/k8OZYEsV3YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HJAcIrie; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HJAcIrie"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4315eac969aso33503275e9.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423756; x=1732028556; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uaegvdmr12Jodj4tZFHwcVICwYupT9s60O77leYHrq0=;
        b=HJAcIrie67LlZN3EzwhODF5jpY7K1ZozFo1+RYoXLXh+Bsi4SBByxZfrdsiuyD2vca
         rryOjWfX/NtfffChovLvZeMEjR0egsypUkb3g2YTY4i7dCPjLwPECgUDduT7asQc8fsb
         uwC//CK+qmKI2MFkfvwzbh5GYoR1EXX39VxFvoIUglUf7H3HQt9wL1RT2qo6Ubji7MBv
         6IofMqFlvQFdW46E98Lzq7GDxFCU5tF62YW5IoyArNTnX+IK2gKxR43j6EAukgh6+gpu
         0nlpmn5bfOWy8eFftnC0Jd8kjZ8wHYlY4mqUaz3r3VCAroZYTlHGJE9gSaeXAkhxT0pj
         i3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423756; x=1732028556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uaegvdmr12Jodj4tZFHwcVICwYupT9s60O77leYHrq0=;
        b=E4y2SwAvRGQfjvD1npB5iPx5iW9sVmH0HsvS02M44X4dEEvawdMtvpPhbYi/SV4prl
         02t5jAsv9yafdV8UFt8YwjathabASdT2nVNmseJUnQ2oZVfWvaZsX/ZPt7hrD82e7YMy
         hEA2raOIJ0FLrJ/T7nxPgIH04cLbePO9tL+pNrHogz+7S7j2Gl63HNKY7ew0BiiAb4ho
         lBsLnwmrSGAUp53NNRnG54Jnhiaz15vBh/h0snQi0jpLyRXbEf0J2jOJGfn7iE7Kzbkz
         DKCaIaCp5K2nM3SDeugK6Pc7cf3IqcN3ZZVlg4ItqsywrChbrfnpFTB7pod8Ns0mwwxU
         FLRQ==
X-Gm-Message-State: AOJu0YzaF+gKOwlYnlCNBVdxr5UI7iVBDHYqIIl7zc8WiattrN0DHa9t
	liRb8VERNsTRH94s7iZw6doh3GGRfIM2fDDhHHG6mMTE4knTKn4suahNEel2hvHqXO5x4aVNcoh
	m
X-Google-Smtp-Source: AGHT+IHnlNL4HryuRw1Vo5SJa4C9XNJ5aWWIuWeK+V1hnRQOVGdYF5n2vo3Po73gv9y5eRxyKAgjPA==
X-Received: by 2002:a05:600c:3ba9:b0:431:47e7:9f45 with SMTP id 5b1f17b1804b1-432b686ec45mr153149175e9.11.1731423753586;
        Tue, 12 Nov 2024 07:02:33 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432aa73886bsm246087645e9.39.2024.11.12.07.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:33 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/12] libmultipath: libmp_mapinfo(): return DMP_NO_MATCH for multi-target maps
Date: Tue, 12 Nov 2024 16:02:05 +0100
Message-ID: <20241112150215.90182-3-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

multi-target maps are more like maps with a single non-multipath
target than like maps with no target at all.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 2 +-
 tests/mapinfo.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 52bfe9c..ab6eefc 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -719,7 +719,7 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 		if (dm_get_next_target(dmt, NULL, &start, &length,
 				       &target_type, &params) != NULL) {
 			condlog(2, "%s: map %s has multiple targets", fname__, map_id);
-			return DMP_NOT_FOUND;
+			return DMP_NO_MATCH;
 		}
 		if (!params) {
 			condlog(2, "%s: map %s has no targets", fname__, map_id);
diff --git a/tests/mapinfo.c b/tests/mapinfo.c
index fca6462..66c81e8 100644
--- a/tests/mapinfo.c
+++ b/tests/mapinfo.c
@@ -870,7 +870,7 @@ static void test_mapinfo_bad_next_target_01(void **state)
 	rc = libmp_mapinfo(DM_MAP_BY_NAME,
 			   (mapid_t) { .str = "foo", },
 			   (mapinfo_t) { .size = &size });
-	assert_int_equal(rc, DMP_NOT_FOUND);
+	assert_int_equal(rc, DMP_NO_MATCH);
 }
 
 static void test_mapinfo_bad_next_target_02(void **state)
-- 
2.47.0


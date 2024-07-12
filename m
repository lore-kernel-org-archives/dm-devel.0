Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A9A176FAB
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804575; cv=none; b=o+HQX0INK0dftQNTdGhNMMrtL1SBuoJDKGNCj6ZMjgyH9yRqcxwgq565WbJeZ02jrcVRSznHT7NM8XRgRuPhzPxKglHuIOaQ6mrbiq9vS0FB/znx9yGEk1B3ju1qfCu+EtZq/ar1c1zUeTUjC+FP+NC+YE7JKRyohBwNro9RGqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804575; c=relaxed/simple;
	bh=3mJfe5elNzQEbuXYSPBcymKhL6AzUUma4FQY5aZnSCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=To/l0ihGha5PnhGlIRG85gEmBpj6Lb24/Hac9NS3q1yqmX6ElsQXMT1pXhpkvROoCnBVVrdbAoQQ1x2k7NWLyvnlkRKqw4vULZmeXxP1gQIGbWXjYMXeZVKgBHbKnwSh5RlRTtvI9dyxaohDjCRPRCRdZxn9w55B9RHorja/X3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cf92xl9l; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cf92xl9l"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52ea79e689eso3134507e87.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804572; x=1721409372; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxqsESTpjg9CK28sjPNodqMRrZfivIXhocnUtglpk1I=;
        b=Cf92xl9lqBKKMOmde3hHKEzic6DLRWwkVYffBqxg/YYqbszkJicZQZHpjy0GOVvRK2
         +faQwPcl4T9ySFVoveQFYEYWmwzqfDQjNmx59hxJmQP/kgneEJju+fls55GQ0shUjr98
         zL5JYcFCMzKxkXuC43S3VDh7wYmu4EF0p2NjQBHVbG134iZtcPVS06WxOVYRgp6SNwuN
         cZBt990/JNsXYopxb8tC0UcYwrokife9+HGAwXrogYUIBUHuGkSC0avtNxiOrX036a6k
         Nx0hM5IMjN7VI9H0xxN9tftwhfVXnTK5mOqbWHgUzFiTNxD5bOFPYpqmU/xeNW+vmD2d
         rOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804572; x=1721409372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bxqsESTpjg9CK28sjPNodqMRrZfivIXhocnUtglpk1I=;
        b=OrrtUX02WXHkTR5M+qFFcEVS7z94rvGuPaQPH8cirHpYFNlHGA1UcLcn4TSxvKJGrk
         5Dxem3z3ckf169kqLrv3dmjjdH851jWD8P1eNnthlGO+TZIC3JY9pT0AaIDZ1kzplS5F
         Dx1g1Mw2MzEzwclfnsN2PHXtiJ6WsPvZaLQnCW65OqXkqGvrvDE6OUa7ODfwwOLUomFh
         Vx2jrGYXAyFMxvJEXS5kXkLcF5z8aAyrLtmfXhSUcrAAS4LU+tGx2D6+JXQU3GniplCH
         541KtLeLwv99acyj0Rl53Ku8L5LgMKWPINkjLcgkE4g/pPEiV7LvxmGNUXq1Uis9JxdR
         OrAQ==
X-Gm-Message-State: AOJu0YzlPQKw1K/+oLqF7ihMp23pft6FRwQmn8qgdQK+rtXyuvigIuwD
	721FFXrqIuJFBQsZ8/1sdTckkehYVpAQz6X0PyDhsY2CWAFySgQnyqBkmXkgSW4=
X-Google-Smtp-Source: AGHT+IH5vWp2D1RecFnwBAHqre6Ah50z2ylv0sB+PJj6sP4RaMdaoxKJ4geU7dP3pbCG27gS3xWeIg==
X-Received: by 2002:a05:6512:3b9d:b0:52b:be6b:d16a with SMTP id 2adb3069b0e04-52eb99a3526mr11243463e87.31.1720804572160;
        Fri, 12 Jul 2024 10:16:12 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6e37c4sm360583966b.82.2024.07.12.10.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:12 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 39/49] libmultipath: drop extra call to dm_map_present() in domap()
Date: Fri, 12 Jul 2024 19:14:47 +0200
Message-ID: <20240712171458.77611-40-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm_get_wwid() will return DMP_NOT_FOUND if the map doesn't exist.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 2fdaca8..b4de863 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -834,6 +834,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 {
 	int r = DOMAP_FAIL;
 	struct config *conf;
+	char wwid[WWID_SIZE];
 
 	/*
 	 * last chance to quit before touching the devmaps
@@ -843,8 +844,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		return DOMAP_DRY;
 	}
 
-	if (mpp->action == ACT_CREATE && dm_map_present(mpp->alias)) {
-		char wwid[WWID_SIZE];
+	if (mpp->action == ACT_CREATE) {
 		int rc = dm_get_wwid(mpp->alias, wwid, sizeof(wwid));
 
 		if (rc == DMP_OK && !strncmp(mpp->wwid, wwid, sizeof(wwid))) {
-- 
2.45.2


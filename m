Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9142EB5DF
	for <dm-devel@lists.linux.dev>; Fri,  5 Sep 2025 21:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757106450; cv=none; b=HRxPyRIkQVYQkDnJHLGLorEEX84lWG0UBOkfI0ANALYMUA1IqPnAlexnnbSN/qtnMFzC+TNOBZI5w4rseO3KVxQcKxmGs4+2OHeemNmZZJqK3B0ooVhVvXnxbW5IbPyYwxGGH7JkmgvbOGQgVvqGcSCRLbc1jei+sNqd4ryj7+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757106450; c=relaxed/simple;
	bh=sf6XLt+OaC3Lo1EFOAxx2fCLtiE5iewKokxbCFZp94c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzTpo1L+8iOqczmQSJCxN7+p+6l3rxO70Bc+w96G1KZuLB4eq7DohqJ5CpXPNBWZAYc/28j68N+AmFlC9+CHH7C6F8qtloIW+HUsX8AuYJbe7xrSfwTowu73NjA6NPUK9gIlP4VVzT9a37HbM+kwBecM31UHpSk90+u4ivID/T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N3j7SgpE; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N3j7SgpE"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45dddd98d8aso820315e9.3
        for <dm-devel@lists.linux.dev>; Fri, 05 Sep 2025 14:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757106446; x=1757711246; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a4mXFavxNHvlDq6dn+Rz+nunMLmMl3BVIYSm7p4qkC4=;
        b=N3j7SgpEn7RZTjhSHEtCd368B/6seSo41pyDavL10QIw/GYRwS7RsHsxsjzTp8nJAd
         ZAr66vkT9rnXMI1nox1SvNIOqVHFjgUSLoVw005H6ox12zOgZe75AyplE8RQE6wk1ohB
         I2r4z4jJ/cEqHRJ23bB+oZ9EO//PGrUF7b/QQ5nrR6LNRQZHK67JfGcUYaHyIgmGZRj3
         ZVxoMpz5ueKFT0D9ORfehi86F2ER+y/YrekSlGpOFDG05PcCnVVPjnIVSHB8puwapj37
         /AAHX1lmOgHQZVH2MxSqJw7PTCxYTnXDJf33UtIhtGYS1JDHSyikNkdgxJRGA83tq4lw
         fCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757106446; x=1757711246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a4mXFavxNHvlDq6dn+Rz+nunMLmMl3BVIYSm7p4qkC4=;
        b=SDctwO8nGUe+RxrcqTVnzrmlXayCpsdqqXz/eUrFDOjkl6P3dPIF2Bp7P9Da4t2S6F
         Qghyf6hpXycTsPrgoi3sI7GwjqysFsdOgACRZjBLxm6Ytg5+v9qGwS5YJp8db4eFi2/W
         fog+gsOhygah35hoLpuIkazYG+a81JtShs1jj419sJOgwV+TPuHc23JiqfKbgT+GvuW0
         SZ9350zToke+9ZieEMANOCKi3Lc/PoIXcUZeb/ZHXPE2gOy6+wumR0R2jLE7T0Q1v+iB
         giNvGa5TAslRUaScQMysQwRELozKBrCN9D55UTwjXmKTIAOsiwjtXvr04ZWc1RPEN6o6
         JCOg==
X-Forwarded-Encrypted: i=1; AJvYcCXoJj0Qsmj/60fjMoh4LAxv0XiXV5iMcOAPb4mva2MUfEG/4qyXWeHt0NOoHEqnmZRFSO/aVTlqag==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2YNcrEdfLutSjLEOZJfk8GV4KjO1+Y4+bxLXV4UCh5cAQGnVt
	C7rY/P8f6Ssku+xTbyRWBrvjP03Y7UYK8E04Sw5tMdsNQAHRxBjmioXfuw+2HMvb6DSrD03Wec6
	8gVsZ
X-Gm-Gg: ASbGncvzp0KVxxHplgDTsyvJSsZrEAA3niTory+KEL2tpZr3imd8ORlsmQQNPRpyyYO
	ukP+lM1shmOjJJjTCuw95+ZHnl1z/+J8Fk1v3qzqOuf8Mk8yaIQ2DBKSgeRKKhV0G1X6ilwZcQQ
	oH9+mefH6Hogga9kSzBU3y5fSpq0onVu0FPmH9K5x4P3xEMtVNoHfI0gp1rGSvEbQUs5ueKFgiN
	diCSUDGiJbIZANyz8adwpTKvYrQX8hiiy/J94gzfdjL7BL4MOnV8H25BPlEor2DzG2sEtwQSfWq
	lBrmLHqRbiMDTGVIvrhMJy9otKAyiKaWwekmTzKtSjREQAgAnoNcL464Cl6JOSJfR30Oxqp2SN1
	yC+KjIngNmarOzJQArcXiiWNc4u2c0zICRNqpwPwk92V6z73IVAdPKaTgFflLmbjrzYqUGnT7qB
	zZDQEQRhnxVio=
X-Google-Smtp-Source: AGHT+IGg9+Cl1PrfxB1u30kczFTx+lL4HF863Q/M7Ft8DbnO8aCFbSPZ+8GHj42zoACeR0uSUx1hSA==
X-Received: by 2002:a05:600c:1c0d:b0:45b:9961:9c01 with SMTP id 5b1f17b1804b1-45ddde832ebmr2550685e9.16.1757106446038;
        Fri, 05 Sep 2025 14:07:26 -0700 (PDT)
Received: from localhost (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3d1007c0dc8sm31135478f8f.53.2025.09.05.14.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 14:07:25 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 2/2] libmultipath/foreign/nvme: fix return value check in get_ctrl_blkdev()
Date: Fri,  5 Sep 2025 23:07:14 +0200
Message-ID: <20250905210714.167202-3-mwilck@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905210714.167202-1-mwilck@suse.com>
References: <20250905210714.167202-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only a negative return value from udev_enumerate_add_match_subsystem()
indicates an error.

Fixes: 7b47762 ("libmultipath: nvme: fix path detection for kernel 4.16")

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign/nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 0d19303..4cbdf60 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -536,7 +536,7 @@ struct udev_device *get_ctrl_blkdev(const struct context *ctx,
 	pthread_cleanup_push(_udev_enumerate_unref, enm);
 	if (udev_enumerate_add_match_parent(enm, ctrl) < 0)
 		goto out;
-	if (udev_enumerate_add_match_subsystem(enm, "block"))
+	if (udev_enumerate_add_match_subsystem(enm, "block") < 0)
 		goto out;
 
 	if (udev_enumerate_scan_devices(enm) < 0) {
-- 
2.51.0


Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB60171A5
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379622; cv=none; b=VUJM11vCER8jV6Kr+HGRaY32TvSWhGxHxX/mpYuo4TwXPGsKafmhjZyjtzaRBs6xk156q1ENLCI1LQxu0bEV2masyUOrbbE+H8HbVQPuBNQFcHv1IfYkFyuxpNDV3kIR5esBze+ZYHNzsczTO2sgZHYFU243sv6Kkbq//JzU0yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379622; c=relaxed/simple;
	bh=SO0DtHDuegnhT+Y8X0OaIOd3Q0R7Ey+XxiapKg6hVrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhrZp1BoLx7mdq4W1sMmO2JMckEqT46R5lpCXZMQvxDHMco6cLNUtGJDQmmrOQT8ny+AqkXsTpxuwSXRkmPnmCT6DRtHGJrjx0L59gXTWQ79E9WxMX4UYyNRiT2Pq015xIApKHNutfV5ZplfYejZlxFzsedXg6sjDNyxQ+0RxJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CVIgSZeL; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CVIgSZeL"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a5200202c1bso791101666b.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 11:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713379619; x=1713984419; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=srxyZAGyXYvn2b4ezfzCvudChQrNSnEsfsA8PnCNW9E=;
        b=CVIgSZeLe4AcPDRjF+OTHG5Pfr5980BcasgGJSSdQCjKqyEQK3pHBcf6Iaxrbr+JyU
         sq0WEdBg5tCZdmrZYnV1qODFI3Mt367W+9wimuJA39TtKxWAp30EgD5IOHigvY2Zyl96
         nxHMFz0IXM+5F/drBqNeOOsQmjr+GTMadW5/Xc/I8WFLeuA5AstaBcYyvFDX6UMuzDWh
         /xL3xOujj0PF9ToAuDeQHOYzm6V806DdwlUlPRVdj83rv/q2OZO36Kfil7keUR5NUI6y
         IbMvjnvl90h56JwUa1Sg1qVairyr+N9lJNHV6UE+6PQWBwoxd3+btB82IjKApNxnjQ4C
         4n/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713379619; x=1713984419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=srxyZAGyXYvn2b4ezfzCvudChQrNSnEsfsA8PnCNW9E=;
        b=Yrmn975erP5ZkcUUTGhdnKPVnmFMocYdgyEKHYXTjTc8ou7pG6NZV9M8w8OOYiGMUX
         zW5P/OhdkwTAlqti6VEmm936+CZ5d5oFgsNOdLAAYR1IMb60Ix+wshZ/nLWs5M/z7FNQ
         GKRjThAYBplS6YMd541X2zGJKixQT0azS/8cYPTYMzr5jSM1FEHeODFYHxWk7AcbiXnJ
         XZXMaNcYrhDQB1Gt2FcDZ9XiO/XEW9IvMb7Na0GGvpReZrpSmgAv7IJU57nvDOQtvtUQ
         UeC1+i8HtZNplZvyN4lMYZXpwmaxuZhvDZgKhfo5eAoackSPg5w9h+VI3KV04Zx1ivh3
         miGA==
X-Gm-Message-State: AOJu0Yx9zZQX8B6ZBouSeyiujGHOo5U4meGCEkno/CbAB0HkdN6nNpNJ
	nOo/c9QSefMgDCAiV7iB2pQiG4dmoRCJhHut2P4NZL2d018MkB99Udd5dLJ0iIQ=
X-Google-Smtp-Source: AGHT+IGuBeDkJxq3l/2p84b0q63zgETiPHBsrnMh9NuxlHR8gaYxrBzj4DyfI1gTH8e3euTThTFhdA==
X-Received: by 2002:a17:906:32d2:b0:a51:d611:cd5e with SMTP id k18-20020a17090632d200b00a51d611cd5emr245150ejk.57.1713379618889;
        Wed, 17 Apr 2024 11:46:58 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id ji16-20020a170907981000b00a5244a80cfcsm6408791ejc.91.2024.04.17.11.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 11:46:58 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>
Subject: [PATCH 4/8] Revert "libmultipath: fix max_sectors_kb on adding path"
Date: Wed, 17 Apr 2024 20:46:40 +0200
Message-ID: <20240417184644.6193-5-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240417184644.6193-1-mwilck@suse.com>
References: <20240417184644.6193-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit bbb77f318ee483292f50a7782aecaecc7e60f727.
---
 libmultipath/configure.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 89ac03d..13602f3 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -575,12 +575,11 @@ sysfs_set_max_sectors_kb(struct multipath *mpp, int is_reload)
 	ssize_t len;
 	int i, j, ret, err = 0;
 	struct udev_device *udd;
-	int max_sectors_kb = mpp->max_sectors_kb;
+	int max_sectors_kb;
 
-	/* by default, do not initialize max_sectors_kb on the device */
-	if (max_sectors_kb == MAX_SECTORS_KB_UNDEF && !is_reload)
+	if (mpp->max_sectors_kb == MAX_SECTORS_KB_UNDEF)
 		return 0;
-	/* on reload, re-apply the user tuning on all the path devices */
+	max_sectors_kb = mpp->max_sectors_kb;
 	if (is_reload) {
 		if (!has_dm_info(mpp) &&
 		    dm_get_info(mpp->alias, &mpp->dmi) != 0) {
-- 
2.44.0


Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC0418785C
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561219; cv=none; b=jlC6+jZbmhCNvu02Psqy9nJSqvAbfrqYLe/xzihvo6zBA13fGg6ytWRdYfpXbnWAH+wI2bTA8YIUZds1jp/dYqRNXjfEG1AW/bsG7bD9gKF8r9M/IonuKJhZOZfoqmgJxrJ1S+wcZqNqbRjBj5y+lz3PVk6SroNadnnKh4kRQ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561219; c=relaxed/simple;
	bh=wOLp6wjyRwQLwny19+njOUxq+YNDtXjLT9k2WDcVxQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvqgT33tS/z3Yl+tz8S92pvPY00VV2LaLUXavbpWGQTJZv9aaFG6vxh99+FpdL9VyAqtdnz69dxa8dC0WLKGS3oG68sJt20ktvsBYpT5yRaHELKXsUJd20cRQ26k5sUlUUhaeoB3gBeBPH/X9v26MSwZZh89bTTRtmp72bJNnr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G+4B9lNi; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G+4B9lNi"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-59589a9be92so1294010a12.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561216; x=1721166016; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PAuhDI84QLk3Xz3/VqKhuS2sfBuuqFOJcO3UnFnmklk=;
        b=G+4B9lNi7haAIXDrE8F4259hb6iYnkOXpcrqIdi7AgSA6lUYsmYTY05+titrbSBBTX
         EzCUWIoom0UxPiCV78sYEiHKbrZsBoC8+9gAnZ1529z6g8y+f7+d1UiUxyckTh3GTR3Y
         SwR4eYX2XzhsBW43q9XzCOm46e9dnvYCm9MK0PTYdj2UHyxmIisKX50WDriRSBA85iYc
         UmGWjSZAcNNXP9I1Y++TjWghm7BED7XPe/5ZHAD0Hz2ZB05/rssWYkmF7zlU0ydlGImP
         BRQkroLJ/JWyqJzz20u32xBzWt+oAUHEc+O5giIURB2yGW+i18zXWrNK3ok0/iImj9ss
         GiWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561216; x=1721166016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PAuhDI84QLk3Xz3/VqKhuS2sfBuuqFOJcO3UnFnmklk=;
        b=Dg0rMvLRtCrawvQbPwkdnvRQNPkRjp5MdI4Bc3mDsBE7EQAuZ9xa9aLtXkJgaUB2SQ
         mg/cFo88/PlTLl8UWC8T5y456dpGmPZqJxhlM8wTide6tu6Fak0yPgvfwVW5s0U2FyjU
         eEGwuciudJ78GTOIOu5K/e/4h0zJOrOQ4XeW0CpjGrhJuSz1I1FaMUURg5kG+6YthFUh
         /8UK5zAAmW3lQ8mg8jqrgC8pahOyUCEY5W4UxzzJNokkYDBt58RN/Ol5GTEWGEPBHn92
         SoMZFm1/oWIqq7xJ3WICoOkxlz+TZ7/+GBkeHRl0WMURns8vA2NRt/gmJM2zWm1Qg6c+
         oqkg==
X-Gm-Message-State: AOJu0YzkVghTuNukNqzf2YvzzA4bwdD8DSvCG0+sR3wzK4anFZuCdC3g
	b3n8XEAScD+vt4UmdoL84JdxSnJZN1gJB+i83D+gsDsZ+2yJCHEuOaAGmUj6r6yusfQGZ68k1Cr
	U
X-Google-Smtp-Source: AGHT+IEY/9VZHmCWsvtkHAgz6PGGzVyxo4ILk+MrHO1wmo4guXd/VeZ87L3Mgpl/fgHniQBBA3hWRA==
X-Received: by 2002:a17:907:614:b0:a77:c26c:a571 with SMTP id a640c23a62f3a-a780b881ca3mr253430666b.54.1720561216253;
        Tue, 09 Jul 2024 14:40:16 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bda284a5sm1483194a12.85.2024.07.09.14.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:16 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 30/44] libmultipath: use libmp_mapinfo() in _dm_flush_map()
Date: Tue,  9 Jul 2024 23:39:21 +0200
Message-ID: <20240709213935.177028-31-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We can spare one dm ioctl here.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index bfe202a..806ffb8 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1056,10 +1056,16 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 	int r;
 	int queue_if_no_path = 0;
 	int udev_flags = 0;
-	unsigned long long mapsize;
-	char *params = NULL;
+	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	char uuid[DM_UUID_LEN];
 
-	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES)
+	if (libmp_mapinfo(DM_MAP_BY_NAME,
+			  (mapid_t) { .str = mapname },
+			  (mapinfo_t) {
+				  .uuid = uuid,
+				  .tgt_type = TGT_MPATH,
+				  .target = &params }) != DMP_OK
+	    || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
 		return DM_FLUSH_OK; /* nothing to do */
 
 	/* if the device currently has no partitions, do not
@@ -1073,7 +1079,6 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 			return DM_FLUSH_BUSY;
 
 	if ((flags & DMFL_SUSPEND) &&
-	    dm_get_map(mapname, &mapsize, &params) == DMP_OK &&
 	    strstr(params, "queue_if_no_path")) {
 		if (!_dm_queue_if_no_path(mapname, 0))
 			queue_if_no_path = 1;
@@ -1081,8 +1086,6 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 			/* Leave queue_if_no_path alone if unset failed */
 			queue_if_no_path = -1;
 	}
-	free(params);
-	params = NULL;
 
 	if ((r = dm_remove_partmaps(mapname, flags)))
 		return r;
-- 
2.45.2


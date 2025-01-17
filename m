Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B35A187550
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145675; cv=none; b=GHLzEW8aOtz/deQ70tuK+ni2p08ZPKdgkHLat9W8kL+JoMYzjD+gjGtne84WRoDjW5KUiIbO5qv8LTZr7kDrvEx7Tw35VeHHXTfkA/j9PvTJlz9wLUmqDZhiShvsUCkBthFwzwGz8++PoI6zg406wEixiJECex7Ux45aNzXHMhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145675; c=relaxed/simple;
	bh=1LL98hFy0UfV7enFAIetQFkfpluoICYIqIstLhzpcQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHD54rzzmW301NpMxMlkXBrDQRvGfSD4M7TSWF+JKaKABXxoEoWk6ciA1Ldo0xyJynxr/gb/YVUkY/f0U/RKB6rShyeUBzshNE8azEG50W12QI3AC/NCutsBfHtnPSqfKONxLqx/N6ktSEtlwgkhICNJ5qoU0QkUFO9AgG9ebac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZNF5wwXR; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZNF5wwXR"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4361b6f9faeso16119655e9.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145672; x=1737750472; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yX8A4x2HFwzmK8LTslJKGzzqABVfy9N0g2Xwi7+Yb18=;
        b=ZNF5wwXRki2w6GVBy3mpQJXyORVMPBhXqebaJaZy46epNDzCW7OdFGvZMXYV5lQRQl
         V8PSg7Me07VNi+5/hmYX17gcDZz2JvShrH9PVLuBRREEJwi3p3MSrdOH3vlQIUEu2/b2
         k2D8JiLOszQMP7ZWzMd6wTsNP9BqnnZXVA1bpQ+3fSdjRIli895qb5/ORA5KD+iT0xJ3
         RZ5qKnXsgk/rF7XB0571dy+TsDPh3R4R8soF8Njj8qNjUHfl6FHCLgae/tOm6jb5nEPb
         omQJB3EvrRPb3u+Pdt4WRbH2+4gMLCxOXLpMzxNcfXPtc2ERAJT9m8wqAAmq4WSITfw1
         GO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145672; x=1737750472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yX8A4x2HFwzmK8LTslJKGzzqABVfy9N0g2Xwi7+Yb18=;
        b=o7UYrwyXxGttZQKXbFJ+ImeMYeWz4Ll9vZJUhRSsCEZpOj+A3Wt2Py2DYsy8OzE97e
         ncOsFhIAxlK8Tqyi2b5YDXN3EmTVmkCaYpUw8CEFmkrYxhDc6OPnXXJuKqDBCZzWgptU
         o4hc+4GgAbtXleu3CVrHer595QJNnL22NdXPvo6OlFFqQ+JB5fulPA4LK1ka3qTiy9T0
         3B/P1QdOcVFyZHRDKJmLFi93kcn+fnG7v9+WzL4ytn4OvIyIXiZwC+tGldftUa3VvF5L
         D6uVUkvRDCg3pT9KMfwYm6cn6O8P5e64kcTeiyzQoR3KzJOqgfmG0Tl8fejuC0jBIBg8
         yXVw==
X-Gm-Message-State: AOJu0Yw+yrsw/UTW75+we+iL5Cih+4MIyQY1AhmZBlyMANZIxdUw5S3d
	+g9PhWzDUXCnASD3yow/SYmDKfdun978Fcq6s7JT8uw6BfHdzVaXy15wolOQ5so=
X-Gm-Gg: ASbGncv1hG4iTw/vdc+4lRDq8KcKtPA2Cyzaz0rzsfp9f8tYtgqP6CgJ9ApHc7aem19
	CpHgmwYaxDw4L8quXsuAwqIJvFsKarEOsxxsPz59PkDA9nZYtfsPePLlWMLLFvgW29cNY10b3v3
	qniZDczxVfMYWeaMQzkwne2r0wi5f5Qjj0Dj/Y0QO8ozingCuuhywCa/nRFPBfV1SA2Zl94SpyA
	0/xEdnVSHdPljCGaqIfk5NFE7ZVWJQnIv8ZOmSxfKuRCp/Nu6lYiVQUDH81Ukn5Qu9Y+eZZBU5u
	lKYzQpcvPMdNjI0Iru9MA61IPF678IMC3AWMdtfRPEY=
X-Google-Smtp-Source: AGHT+IF8xfkql8H1NYWRQh/Sk3vmQ3EOUJyeIFKqlFUHJhbNgJCNpyfn+YWaDpushCQY3R+Tm780uw==
X-Received: by 2002:a05:600c:1e09:b0:434:f2af:6e74 with SMTP id 5b1f17b1804b1-438919136c6mr39858535e9.15.1737145671534;
        Fri, 17 Jan 2025 12:27:51 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38bf3221a6dsm3282171f8f.25.2025.01.17.12.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:27:50 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 02/15] multipathd: remove dm_get_info() call from refresh_multipath()
Date: Fri, 17 Jan 2025 21:27:25 +0100
Message-ID: <20250117202738.126196-3-mwilck@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250117202738.126196-1-mwilck@suse.com>
References: <20250117202738.126196-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the map is inaccessible, update_multipath_strings() will fail.
There is no need for the extra call to dm_get_info().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fa684e6..4a28fbb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -503,20 +503,12 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
 
 int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
 {
-	if (dm_get_info(mpp->alias, &mpp->dmi) != DMP_OK) {
-		/* Error accessing table */
-		condlog(2, "%s: cannot access table", mpp->alias);
-		goto out;
-	}
-
 	if (update_multipath_strings(mpp, vecs->pathvec) != DMP_OK) {
-		condlog(0, "%s: failed to setup multipath", mpp->alias);
-		goto out;
+		condlog(0, "%s: failed to read map from kernel", mpp->alias);
+		remove_map_and_stop_waiter(mpp, vecs);
+		return 1;
 	}
 	return 0;
-out:
-	remove_map_and_stop_waiter(mpp, vecs);
-	return 1;
 }
 
 int setup_multipath(struct vectors *vecs, struct multipath *mpp)
-- 
2.47.1


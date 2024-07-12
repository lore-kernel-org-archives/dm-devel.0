Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1823817C6B
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804545; cv=none; b=q/yMn1IlEFNV1N3lggnlYiOD/CGEdZwaXhfNKBXOu21tU6RJVaz38ZNF56Q0P/o1AN/zaz3BDv8osWwfNaTR3rwzxSLz+q/N2ylD7k3rz4gMJd+mFn5w99W0Ny6V50PRtC/Wn8CCklM9YT5+upoHri+vZnG3vtD8qvjtDS4AdkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804545; c=relaxed/simple;
	bh=EHVIdQjEPCn9dbQB+9y+hO7sTWOOE6Fx1oJK0zfY8VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fA1fbaVhMpfmG7Ntl1YPnJ7YWFltEd0P2AvDWjxSXkGOQ5fEwEL5Nk3dPR/WLUrS8SRzlXwUYdqNqFmErd7+YOB/tI0L7sYCfBIlVvu+xTbgUf8eRkUu9sJAdj/Qytq0SnsWeBFBwXi6yGm/pG78cgX8jeIKd7TX7KHHIvKHm0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EUXOrVgQ; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EUXOrVgQ"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-58b447c5112so3121192a12.3
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804541; x=1721409341; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhQBOEExdxLioLnfTE8uk5qUeyX81jGOGkpCXie+Nxg=;
        b=EUXOrVgQxv0tzZnlRYcwm2kgGrGQviz2ggSqtIyvvb/yzLXvNtt+vF7l76Hg5gVBvN
         ylzhjwhcB1GLV43mfNIx0Ro1KUb46lGEXfxLrioimHay+st5qMu+xi0nvQUMZeXnOVQK
         Mq7I+I2eOCYHhiOfZWpTpLRkUWqdulnJw6bvfdQ04Swqv7jTJj96JliSx8MPSwWvU5fj
         r7KlcfX/YBBD/ivQ696JiX6UqhEITd7khR0CikNOLNrIetCvIpiTSkJm8n6Zi+5e8GRO
         ahLn+6rr9Ge9kKGj9xvKL060pGqhLMJpQXUO4kgTv4d0sE9KBL48/BoknCNd8PTkJP0g
         VVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804541; x=1721409341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yhQBOEExdxLioLnfTE8uk5qUeyX81jGOGkpCXie+Nxg=;
        b=neC9lMFsKOSx3gQcwP8JChYysIUQ3BHdBa1qX4c2wNWzodz+npHHLjhvsLXp+A8CnE
         HCLgECJgLfu/LfUAN+EYPSoAGUD7w7VXYj8ApOi5lddwurHTR+U9UxdLfTb1afLQTGn4
         jEuCUpJeFuFajo3p7jN7im00c1c7ymzRlDjEmOI/F0rFWIhO6yHC3mC/cP3nZK8nbsrB
         HSB2KyNik0gHY1OYTfWCxM2+BsNLQCqXRF+b4HTu6/aahIDcMzWESairwLBuXAQT3x1J
         nZQMxeKv3U2hfb0cCV0Y7cuZHc8psblaS33Fg4VBdNJ9ij1vixnQJvK0ZulI9auUEc13
         d8CQ==
X-Gm-Message-State: AOJu0Yz0hQFW3PUi/o0COcv0O24HwlvUTFt4HsAihW1QjFaL0ILIgQ8c
	09s9Ap1gVtxj6EIrY1ugjQ52vDQwmdq/ABtiSWl+Vp7pnP2rueDAPrckNUIx5Ls=
X-Google-Smtp-Source: AGHT+IHx6dvKIoVrBwED4uZlWxnzG17oHzEKCDtomQxwUjozxiEekiG8ypHOae7sojJ6ecojqJzkwg==
X-Received: by 2002:a17:907:1759:b0:a6f:4bf2:daa2 with SMTP id a640c23a62f3a-a780b68a8a3mr797431866b.15.1720804541176;
        Fri, 12 Jul 2024 10:15:41 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a86ed05sm362568266b.188.2024.07.12.10.15.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:41 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/49] libmultipath: use DM_DEVICE_INFO in dm_mapname()
Date: Fri, 12 Jul 2024 19:14:19 +0200
Message-ID: <20240712171458.77611-12-mwilck@suse.com>
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

DM_DEVICE_INFO aka the kernel's DM_DEV_STATUS ioctl, is sufficient to
fetch the map name, and more lightweight than DM_DEVICE_STATUS, which maps to
the kernel's DM_TABLE_STATUS ioctl.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3ee8555..baa1ead 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1412,7 +1412,7 @@ dm_mapname(int major, int minor)
 	struct dm_task *dmt;
 	int r;
 
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_STATUS)))
+	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
 		return NULL;
 
 	if (!dm_task_set_major(dmt, major) ||
@@ -1422,7 +1422,7 @@ dm_mapname(int major, int minor)
 	dm_task_no_open_count(dmt);
 	r = libmp_dm_task_run(dmt);
 	if (!r) {
-		dm_log_error(2, DM_DEVICE_STATUS, dmt);
+		dm_log_error(2, DM_DEVICE_INFO, dmt);
 		goto bad;
 	}
 
-- 
2.45.2


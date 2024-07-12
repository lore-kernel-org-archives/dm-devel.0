Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D8616191E
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804565; cv=none; b=IBvl6V4vsyjaroDSHovV4LAHK/VQPQB2zd//h1yTjXoxk6x8dti8uJo6GPyrk7rRTPOopiO38+jfd+JFys5uff0wAeNFO68GfMOA1fvdVWdQiObRRob0QBDiRiRtUR3XL63W6oKNm9KAYmBZXikIA67vAfiifjvvNfjrPkGrlO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804565; c=relaxed/simple;
	bh=iJMaFNNxmTL2IibeLRCmVUpqO6YCMoHUHwxljp9/wfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntdEKNs3kG0j6aBADnc6eJ7ClvuHa4TXWUlV4AV6elQVhfX56HmaLs0Q0iH2X9M2HK+eFaO5OD7sMBmKULDCPUARDZK1BxsAB+rsI97YBCRgmc1j+mehfkiOm48mqC2WfsQb9BUozMmJJSA+Igek8Ih1ys6V/dR/3rlcIRXXmo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X2Vvr6Zk; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X2Vvr6Zk"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a77c2d89af8so291976166b.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804562; x=1721409362; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hOW0DVeC6Jzop7KNSYiOpbwl+glUBvDsj/EU75kw7A=;
        b=X2Vvr6ZkV2ZB/7FbM4Rd1uzqmsEaJQcr1xh7q7PuVjnZN73IyCnC4ZK7MsvxL54VjA
         zt9+McKgxH0e+SYzLwWvr5gbgRAMq4ZBkN9wWtJJ/d1pMriFJE97ZbiXSMEwCizcYHKC
         dWOoVyUUPVdOPDgGHcOlHcx7+iYkKlQNq/vlbksXg6MHIt3SUel5FA9TBFtfqN+A0xnx
         kwrFnoyxtn1Mk9NQe0ipAkGYThDyH5hWtMUwvqZF205A7nJ1NOjjL9Q1uR6jqtUYQw9X
         Fbx226cjBVlfqsUKllW5Vz/BdiEMoq1TOMD7RPWtFFjA7+cV3D3D8+0bzv9zExHvN2Pi
         8bgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804562; x=1721409362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5hOW0DVeC6Jzop7KNSYiOpbwl+glUBvDsj/EU75kw7A=;
        b=Bow5r4doagmJ+2C8tvUiz7+1xGhbIkjtOaIE59H3gA78bCHZrDloLhHNjxhPQyuJmS
         +0CX5SU2yVvCcZS7p2sUBHFXl90KslQ7Ms6xknJG9KDDE3FiE0E5w//v3dN6sGyCoxPG
         p/WCz7aBzfbio/k8AQ0rpeYdGTtM5HuhG2Uz6f1cqDZLMgENeWIOwgyQaA9GCDcLFcbD
         wTSwl0Fw+X+i7yI3Z61AxqoCPgg/dtn4RLMQ/bhesB4Y1Jidtx2B/gMlbsSfJNY9OfIn
         q59MPV4yQXdybRIsXhfTqikZz8rVIoDutGeJ8Ewtli5Wp+SJ2plOgjDdt7LYcMNN+wiT
         Mpfg==
X-Gm-Message-State: AOJu0YxcmUU6sI76147sXQePWU5PI3MCGy986vZhZ6xpXrwL24yhdi71
	Xnz6qUGXG9myLQ6ixPok/TaMJXlX4j1aGj9jhT5/yetDlKYek1RGQnuAPHy2Z6BC+dWOOcKRHDX
	K
X-Google-Smtp-Source: AGHT+IGgRVv1fjkIfbg0pNhHj/1Nz+OIyHaXnJw2InVxQUExok6Cp7G70/KHqc412Ush6mXYAhKQGg==
X-Received: by 2002:a17:907:9496:b0:a77:e2e3:3557 with SMTP id a640c23a62f3a-a780b884a19mr1027743266b.57.1720804559690;
        Fri, 12 Jul 2024 10:15:59 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6e172csm363285066b.86.2024.07.12.10.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:59 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 28/49] libmultipath: reimplement dm_get_opencount() with new API
Date: Fri, 12 Jul 2024 19:14:36 +0200
Message-ID: <20240712171458.77611-29-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5cada4c..47ff827 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1048,34 +1048,14 @@ static int dm_dev_t (const char *mapname, char *dev_t, int len)
 	return 0;
 }
 
-int
-dm_get_opencount (const char * mapname)
+int dm_get_opencount (const char *mapname)
 {
-	int r = -1;
-	struct dm_task *dmt;
 	struct dm_info info;
 
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
-		return 0;
+	if (dm_get_info(mapname, &info) != DMP_OK)
+		return -1;
 
-	if (!dm_task_set_name(dmt, mapname))
-		goto out;
-
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_INFO, dmt);
-		goto out;
-	}
-
-	if (!dm_task_get_info(dmt, &info))
-		goto out;
-
-	if (!info.exists)
-		goto out;
-
-	r = info.open_count;
-out:
-	dm_task_destroy(dmt);
-	return r;
+	return info.open_count;
 }
 
 int
-- 
2.45.2


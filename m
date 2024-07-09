Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438B5185623
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561214; cv=none; b=JTr/RDuCLI+CPt2sfvLl6YhuvkT08cvmWMEf0qy94urhuUlb5yEtVo+YFTY+yG9fsvw3MFFYO2KtfCejVewmKVnv4gnsinLb9UuG3Pue25AALiXOLzUvpZp1QOxgY7cR56tRw3n8WQJ80C/Nhpz+WDGv+tS5B/zy5p/MQm7oVEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561214; c=relaxed/simple;
	bh=LtITAMouhWRQa92PIMNhmtyK49k0N36M+sl4NydPuPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txmPY9BWMk9O7uAn2/01IQT71wL3qk1tfqN2nnEANV5guduKDhYsqCTu7AREg5aNXT9K23+66IYymqkNKlPsMqNhsg/cJ0OTkZb+veZ7q5mpfbSIjo/dJ2xzwUkvPqM8c4hY+IF2ib0H5kOJAtYqEeckotvqWfOalg1v4Ytx4bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SxG1TMgv; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SxG1TMgv"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-58f9874aeb4so6200260a12.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561211; x=1721166011; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dnWRTY943+wOFieUZpcmUssG/G6SgBmhUFJKPdk9UfE=;
        b=SxG1TMgv6Y1GHQ7ftqytwVAXgRaZjpV/CM/DO0ZFxxC2c06JWaPGZvCZv72qpFM9Ur
         BaNKqnNETGgCHQ+sGFEVkQLPbAEtWizymfl4c6s5Dwg7BaBSn1N+JZhsqQxRAhFujHOw
         nwfN+nMGGQPzK5yovJVp1oYHajufbOVedZ75o9RGCMAdlk6IwtwcMsmdzZhbCKbxX48u
         1DCalGgoMF8OMquslVLCOCQmksjGa9DSpsGl6n/dbGDol1fsJgOPNAN7WoInet5QaPUR
         1Jj22j1bFCwyIrqRUwJuzWNogO1Zfm/NHg690dQb14JBoEeD1+QivpNAHigNpBKDuzYh
         BkZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561211; x=1721166011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dnWRTY943+wOFieUZpcmUssG/G6SgBmhUFJKPdk9UfE=;
        b=kskqhiconvs5B36rcb4YoLe8/no2HI04XoWI+0qwgk68eFXr8fHbMzKAU7vaGDEgd8
         c5y28pFwQ3o1g7/4ijYpAeWju4R6fH05f5cBwDj6HOyMxmoYS2bv/IMVhXNFlxyfCmz6
         /wKY66mdtYwslaA+T6CUm8UjM8n40i1L0cvsJdsYbMf7Q+KZZEbq2EGBewSsD6JF+IrM
         6MKsif30Se0GxOd48rvDNVW5gEA+1HE0tT4Cb1prV/fKhbXyLI1uyLQUa+vD/wS/2cG0
         Dp5gki6TS7MoFYFDZbL8vplxMDQQdYe+zZ9KBAPo5+x36YYSTvvw6bZk8g+Mb2pIc8LX
         okmg==
X-Gm-Message-State: AOJu0YzVMrKdsunwlP2uzDf1b9n4hpPHVvVhZUPUNc9Ytv5MccIrM0ql
	eZtSErSjr+k/+gRg0v+T1WmyCIyQ/ZaTCJNGy6X48fhx/H8mxqhQefKeXEOJzDI5FzfcbeClKIJ
	n
X-Google-Smtp-Source: AGHT+IFmz+wGPIsZwNhXhBKMh+5KcPpsJbR/8KI1asp01i/CvS5P3FVCjQF7Wv/F/qPPlm8AbCrvIQ==
X-Received: by 2002:a17:906:fa8c:b0:a6e:f7bc:dcab with SMTP id a640c23a62f3a-a780b89debbmr247563966b.65.1720561210660;
        Tue, 09 Jul 2024 14:40:10 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a86f636sm107185966b.208.2024.07.09.14.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:10 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 24/44] libmultipath: reimplement dm_map_name() with new API
Date: Tue,  9 Jul 2024 23:39:15 +0200
Message-ID: <20240709213935.177028-25-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 1eebcb5..caa8385 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1469,37 +1469,15 @@ dm_is_suspended(const char *name)
 	return info.suspended;
 }
 
-char *
-dm_mapname(int major, int minor)
+char *dm_mapname(int major, int minor)
 {
-	char * response = NULL;
-	const char *map;
-	struct dm_task *dmt;
-	int r;
+	char name[WWID_SIZE];
 
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
+	if (libmp_mapinfo(DM_MAP_BY_DEV,
+			  (mapid_t) { ._u = { major, minor } },
+			  (mapinfo_t) { .name = name }) != DMP_OK)
 		return NULL;
-
-	if (!dm_task_set_major(dmt, major) ||
-	    !dm_task_set_minor(dmt, minor))
-		goto bad;
-
-	r = libmp_dm_task_run(dmt);
-	if (!r) {
-		dm_log_error(2, DM_DEVICE_INFO, dmt);
-		goto bad;
-	}
-
-	map = dm_task_get_name(dmt);
-	if (map && strlen(map))
-		response = strdup((const char *)map);
-
-	dm_task_destroy(dmt);
-	return response;
-bad:
-	dm_task_destroy(dmt);
-	condlog(0, "%i:%i: error fetching map name", major, minor);
-	return NULL;
+	return strdup(name);
 }
 
 static int
-- 
2.45.2


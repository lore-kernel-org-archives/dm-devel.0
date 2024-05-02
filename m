Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF9715FA73
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 19:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714676411; cv=none; b=if9XTueBpkz55fOpwPTS//Be+aNvIWSs22exrcuqnTx5RJbHCQJ7QpVfCUkc3fOv7ICs+f6mJAMZxWCycNdpyb3fGMM+HUPuwL69FxNFBF1YeSC2hkjWI1qUi0uDObK4Ual+EBmtLXrgz1KT4Ap4pt7xQ1O+Z9e96Vbjb+3AwDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714676411; c=relaxed/simple;
	bh=4KJOrg09JRz5+jdoWpKCAdTKZLK862YNzxK06ZopN8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZZSsoJHe1i7GCHFxF3KZBXsXKajXLWtPsfKYsviUssa/nfjE6vHhQ55mpdSQVUUcvxLTYHb3YYVmCpcKUf6wg+WXTPaj5vhfwoqDPyrjvpDW1bk4S2/z00m6UYa8XSY8/P6T5pxmfw1SBK1JsQ7G4/YmCwq0JtMu+Y7Py0hEWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MEBgA+N5; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MEBgA+N5"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a595c61553cso274461066b.1
        for <dm-devel@lists.linux.dev>; Thu, 02 May 2024 12:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714676407; x=1715281207; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSj8+GFAHYtdcJJK/ttVbJ3Dza0QpoLbDyzRgd0ohlI=;
        b=MEBgA+N5IrRUU64QcFh+Zq6bGSLaSFJdi/1f49apDILGZmStIMXWSlXkaVS5HcX9Ej
         bMkSuxpUJI3DfK44nwp6JIVyQPCcumZNKTwrthP2vw77oR+NQgocYHudmKeVVz8YOfnh
         Bsw6VNjhHOrY2CSzhJiYfBg8zWpu57mSCR2+qUkWEmTLpHmGdqjOYV/yxt5eLJ1kQrZz
         TQ6a4okTWOkuuNl9ICtbVtgcLtfTZhDO191NhYIQzeDrWEA128+SNlYfCj5S3YsM2FJ5
         v9Z0lNUvvfM1nYL6NT4BKQ0OmUNG+F5413Nhd3WKhyS+KVXfSbjeJdWapGlQB6iTBt9f
         QbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714676407; x=1715281207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QSj8+GFAHYtdcJJK/ttVbJ3Dza0QpoLbDyzRgd0ohlI=;
        b=ZQtVfdzK6weyF2IerZT8ySD0bxCT8SiV7NIbPVLdA8YFYQduNZ9R2IYotWYOGjdifb
         AGFyOkznZa9TMDSEtJV4CxwqCJvN5ADzR/Deek/l0+15I7490YwfPkmlfJi2UHqcE572
         rW8U/9H96p9BDMn6qA0qXTfYqZbAsc3FiMvXIE4mW3/Ym1G1gR5Q+aHqCOxq3p26wtTp
         rqctR0uVvc8eECHK0Vam0ghfUCJzBHCTA2ifj5trAXMBOoIRvDG98Os+NhtkIip1VPb/
         u/LYh9A3eDtBGFJJ7eOXlfVEhnO7aZS3xFFvx8RKidRPLcDUyr5CJPJdmQhEPFrFT8mw
         W99w==
X-Gm-Message-State: AOJu0YwmAtt0zwulYz+fP3edPJOu8F9NqSlcrZfplDd9jIFByY+kVrkq
	2DsefQq6YrZMSY4CaaXBNbbedg62p80lafjH55uCB+WxdCdtaWPFoBZrwg/Qbx3HUVN45VXj2XM
	w
X-Google-Smtp-Source: AGHT+IFe5KhpHe9RFyerS7F2J0d0/VgUCr1nWJtzuJX4JS8UH2MjCp62o8jSy87xfalZ6vjns3a68Q==
X-Received: by 2002:a17:906:a159:b0:a52:3f01:e11d with SMTP id bu25-20020a170906a15900b00a523f01e11dmr256370ejb.34.1714676407197;
        Thu, 02 May 2024 12:00:07 -0700 (PDT)
Received: from localhost (p200300de373edc00b298a6be282c8242.dip0.t-ipconnect.de. [2003:de:373e:dc00:b298:a6be:282c:8242])
        by smtp.gmail.com with UTF8SMTPSA id o12-20020a170906358c00b00a55b17418ebsm830873ejb.89.2024.05.02.12.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 12:00:07 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/3] libmultipath: use bitwise flags for dm_simplecmd API
Date: Thu,  2 May 2024 20:59:45 +0200
Message-ID: <20240502185946.31192-3-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240502185946.31192-1-mwilck@suse.com>
References: <20240502185946.31192-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also use bitwise flags for dm_simplecmd() and its relatives. Again,
this makes the code more expressive and more readable, while
simplifying the function calls.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 26 +++++++++++++-------------
 libmultipath/devmapper.h |  5 +++--
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a6a9c2b..08bb3c5 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -386,10 +386,9 @@ libmp_dm_task_create(int task)
 }
 
 static int
-dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
-	      uint16_t udev_flags, int deferred_remove __DR_UNUSED__) {
+dm_simplecmd (int task, const char *name, int flags, uint16_t udev_flags) {
 	int r = 0;
-	int udev_wait_flag = ((need_sync || udev_flags) &&
+	int udev_wait_flag = (((flags & DMFL_NEED_SYNC) || udev_flags) &&
 			      (task == DM_DEVICE_RESUME ||
 			       task == DM_DEVICE_REMOVE));
 	uint32_t cookie = 0;
@@ -404,11 +403,11 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
 	dm_task_no_open_count(dmt);
 	dm_task_skip_lockfs(dmt);	/* for DM_DEVICE_RESUME */
 #ifdef LIBDM_API_FLUSH
-	if (no_flush)
+	if (flags & DMFL_NO_FLUSH)
 		dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
 #endif
 #ifdef LIBDM_API_DEFERRED
-	if (deferred_remove)
+	if (flags & DMFL_DEFERRED)
 		dm_task_deferred_remove(dmt);
 #endif
 	if (udev_wait_flag &&
@@ -429,18 +428,17 @@ out:
 
 int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags)
 {
-	return dm_simplecmd(task, name, 0, 1, udev_flags, 0);
+	return dm_simplecmd(task, name, DMFL_NEED_SYNC, udev_flags);
 }
 
 int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags)
 {
-	return dm_simplecmd(task, name, 1, 1, udev_flags, 0);
+	return dm_simplecmd(task, name, DMFL_NO_FLUSH|DMFL_NEED_SYNC, udev_flags);
 }
 
 static int
 dm_device_remove (const char *name, int flags) {
-	return dm_simplecmd(DM_DEVICE_REMOVE, name, 0, flags & DMFL_NEED_SYNC, 0,
-			    flags & DMFL_DEFERRED);
+	return dm_simplecmd(DM_DEVICE_REMOVE, name, flags, 0);
 }
 
 static int
@@ -594,8 +592,9 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 			      params, ADDMAP_RO, 0);
 	}
 	if (r)
-		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush,
-				 1, udev_flags, 0);
+		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias,
+				 DMFL_NEED_SYNC | (flush ? 0 : DMFL_NO_FLUSH),
+				 udev_flags);
 	if (r)
 		return r;
 
@@ -603,8 +602,9 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	 * drop the new table, so doing a second resume will try using
 	 * the original table */
 	if (dm_is_suspended(mpp->alias))
-		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush, 1,
-			     udev_flags, 0);
+		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias,
+			     DMFL_NEED_SYNC | (flush ? 0 : DMFL_NO_FLUSH),
+			     udev_flags);
 	return 0;
 }
 
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index bb4a55a..a242381 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -38,8 +38,8 @@ void skip_libmp_dm_init(void);
 void libmp_dm_exit(void);
 void libmp_udev_set_sync_support(int on);
 struct dm_task *libmp_dm_task_create(int task);
-int dm_simplecmd_flush (int, const char *, uint16_t);
-int dm_simplecmd_noflush (int, const char *, uint16_t);
+int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags);
+int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
 int dm_map_present (const char *);
@@ -64,6 +64,7 @@ enum {
 	DMFL_NEED_SYNC = 1 << 0,
 	DMFL_DEFERRED  = 1 << 1,
 	DMFL_SUSPEND   = 1 << 2,
+	DMFL_NO_FLUSH  = 1 << 3,
 };
 
 int _dm_flush_map (const char *mapname, int flags, int retries);
-- 
2.44.0


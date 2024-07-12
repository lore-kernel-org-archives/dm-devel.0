Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4A0176AAD
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804551; cv=none; b=rmea8ifeJnhv8CbY/47P/yWzt8yOQ3BnraMMh11ZZ8eIvkWl5cPxTpgfoLJrrAU+i7CqpNBMMff89SFk4bNJ7yyti6dJoSIRZje33RJRniWqzihtCsCA7F/20sDv0Xix1vCiDQYQ0Ob8EVsMPh5g2V2Y7b1+9otK8FB4Ph996KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804551; c=relaxed/simple;
	bh=GbPl1jhGQtpULVCFUDcVuirJGddvFbXJxiQNHxd/qAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YE1zZ/hdCC6tUJsIZEb7gkhLq4HGLGXw/D8Bs5CBTWRvECLhb3mYxezc0Sga18aq4otcKS5wbrpNx9RShaANouwLllUAQ9FsFFLp7A1grMNooLpnlZw8a3gdT0p/IRBzfUkpSgUsEmHku1zOSQes1H6gFtaMeNTP2+xhmNUjdUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=elxygJ2h; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="elxygJ2h"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a6265d3ba8fso273098666b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804548; x=1721409348; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cVmA7ZgDqHQeLCSjLbZhultkOWjweqJFgk141ONO2m0=;
        b=elxygJ2hV79lT9sBSJ155YNxS7LP+mvjGegOgwR7LvkclOXlzqBjQ5Qn6B9SnMGYKc
         UoqtU7Ma5WGTGKslLzAi7hp+sOhOKKf/KoC/aZ9mDGfhDlmQ82+4kpRVjf3IzFfTlPJK
         VjkL5agw23QYtkPnXeyeMgQMwXh3ucdRimEDJ0aCvZTf6+KcKmuBxL3lrED2BfC8Xzp1
         Wrxy+09F9oos8SFzo/RUlVDNlHLKnEl0fnGWuSrIFDb6ZRI3HwlSFKE8KJ5TLdli1JGe
         /1QPYoVC5bngz1K1oP6PAovkR3Gg315Ln3PGBsPRRXT4CNv09weOOP5dhZfrUdgktlfQ
         MmVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804548; x=1721409348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVmA7ZgDqHQeLCSjLbZhultkOWjweqJFgk141ONO2m0=;
        b=WMbQPM16OuxVAt8ilJmjm8OTmVrVuCrNDg8hbJ9ZbH4PvwyTQhTH2BLs0qm1P+zFHW
         /fjirldffkejSXgMK60tmCV0s+iM1je4ryiqhpVw3T4ygPs9v8BlxBAVQLKafpnNel7K
         +Hpl82wZUQpLmkpZJIxnuaRcQ6UaE/ihTP/BRkE4l9VB9evhMYiWyiiMAJ0mCQDYM0OW
         x4nMqxr6RhAHzjvlG7sFcrU9hAraXoCBHZYfMMG32UG33p7zDLyRGZoEy7eQ3ordI2kB
         qqLrWivIbJ0Z7Fl060xbB0oHuCgzMlbbaCmP7FceSyYZm0BZJiwh5CZtIh/M8bbVPqoZ
         xMFw==
X-Gm-Message-State: AOJu0Yy1ydp/a815RTVthVESFbUORdbQLwc/pXX2Ck9HrnE62tST73bA
	5hQvCqmpmZZczyjYKG0QAxfEDVjqDkD3ZPLBRh/n+zf5vzOc1XaSj+99SpvTUrOyOeg/QMN0anJ
	w
X-Google-Smtp-Source: AGHT+IE6EH02GsECf6/EclV7bUpew4m5eveASEQ4yM28Am750DwrOBxfh4/4csspK82t8vEfRmNw8A==
X-Received: by 2002:a17:906:6895:b0:a6f:718f:39b6 with SMTP id a640c23a62f3a-a780b6b1818mr770090466b.25.1720804547395;
        Fri, 12 Jul 2024 10:15:47 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a855193sm369760966b.172.2024.07.12.10.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:47 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 17/49] libmultipath: rename dm_type()->dm_type_match() and use symbolic values
Date: Fri, 12 Jul 2024 19:14:25 +0200
Message-ID: <20240712171458.77611-18-mwilck@suse.com>
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

Also, make the function static.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 37 +++++++++++++++++++------------------
 libmultipath/devmapper.h |  1 -
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4bff62d..a63154f 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -806,43 +806,44 @@ out:
 	return r;
 }
 
-/*
- * returns:
- *    1 : match
- *    0 : no match
- *   -1 : empty map, or more than 1 target
- */
-int dm_type(const char *name, char *type)
+enum {
+	DM_TYPE_NOMATCH = 0,
+	DM_TYPE_MATCH,
+	/* more than 1 target */
+	DM_TYPE_MULTI,
+	/* empty map */
+	DM_TYPE_EMPTY,
+	DM_TYPE_ERR,
+};
+static int dm_type_match(const char *name, char *type)
 {
-	int r = 0;
 	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	uint64_t start, length;
 	char *target_type = NULL;
 	char *params;
 
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
-		return 0;
+		return DM_TYPE_ERR;
 
 	if (!dm_task_set_name(dmt, name))
-		goto out;
+		return DM_TYPE_ERR;
 
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
-		goto out;
+		return DM_TYPE_ERR;
 	}
 
 	/* Fetch 1st target */
 	if (dm_get_next_target(dmt, NULL, &start, &length,
 			       &target_type, &params) != NULL)
 		/* multiple targets */
-		r = -1;
+		return DM_TYPE_MULTI;
 	else if (!target_type)
-		r = -1;
+		return DM_TYPE_EMPTY;
 	else if (!strcmp(target_type, type))
-		r = 1;
-
-out:
-	return r;
+		return DM_TYPE_MATCH;
+	else
+		return DM_TYPE_NOMATCH;
 }
 
 /*
@@ -1426,7 +1427,7 @@ do_foreach_partmaps (const char * mapname,
 		    /*
 		     * if there is only a single "linear" target
 		     */
-		    (dm_type(names->name, TGT_PART) == 1) &&
+		    (dm_type_match(names->name, TGT_PART) == DM_TYPE_MATCH) &&
 
 		    /*
 		     * and the uuid of the target is a partition of the
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 19b79c5..ff28575 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -46,7 +46,6 @@ int dm_map_present (const char *name);
 int dm_map_present_by_uuid(const char *uuid);
 int dm_get_map(const char *name, unsigned long long *size, char **outparams);
 int dm_get_status(const char *name, char **outstatus);
-int dm_type(const char *name, char *type);
 int dm_is_mpath(const char *name);
 
 enum {
-- 
2.45.2


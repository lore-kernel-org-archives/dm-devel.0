Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD50E177999
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804570; cv=none; b=lZlz+JrD2SToPXiLpLvUmdmuIbbBbhJdXyhtm6xH8Gay53FEzhwyORWrQB8rUm4XjZEIcoPx/5pbxFB2bYrHWnX+BGgn3WcMiSHLyHhtEcfJIyj7rAivstffzCw9q5S3tuNKLYg4K3naH9Y1GnnIdqYIt8zb1tqlvloVKAK4OLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804570; c=relaxed/simple;
	bh=tKWt4/1zCA/FNfqJzws5IAf92vxgOmrsBFaOU0AXvZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jff1UaoaDFI4qvmy1Y2PFuVT5U86Km/BYQ8WetaUNJFpT26JRfduWXzrXJsDabYZmLqAYm0Fo9DS7b0Kqo/YfATUPyO52kbBQ3R8oZxdPwkjgAGSALI0hZnD1ktURZpv5gs1jyCxzaNlBnkl5A2AN2lHjgk961y115XEExroRvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Fmv+symU; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Fmv+symU"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a77dc08db60so284265966b.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804567; x=1721409367; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i4vItA7EW5RGeKtTjXZNOru8Xocm80XSNLAgW2ehs5k=;
        b=Fmv+symUMyPTsRHqvXoIdDm61Rc8NyQRi+HO3aPxlV+Wa2cs6UMxbow+SRwLprnOCy
         j4wXHejQ6qonn/SSd/iqo/8RcbnMO3zCTilVplHGo0dC7GAAaDRjZtI/iK9jDwRhILsH
         603t5b5HdZbF152Y19QiY8K4TR90827CFFzBR7WRSW4odCA7d4RNYbCtChwlHMdBO+DS
         ZXQ5MvujHuYHUCUeK2PqZ0yHa11Qu5hdAzkxQB/3x5pacOCTSHziVFtQWlsWPUYMIlAv
         ziMLZVZEExMVX/hruoqTNur8ASM73chHHlGBQRjWy7Afd4CLDBV8DqQq5k6Z84zXK+F+
         qPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804567; x=1721409367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i4vItA7EW5RGeKtTjXZNOru8Xocm80XSNLAgW2ehs5k=;
        b=QQqiyNoIMZKT3AGXHvCrCweGCaMzo3AbfHtcR871VqP9m/E4EP4N54+RZgvHRcys13
         gJjIx0bwfHV7O+baKiLOaqcJgJXG/fWzCwiKQC2zIq4LJQjEHx1Z1znYWSvgtmFePHb7
         eTqC6lGtax9WrLMJrx+CMsDJgkXjpelW4U1Sz8kxqO781h/OXqk2w3kNPEG+2MDe+QO0
         T695H5HMyVfskDtBXvorv3MK72gWmDDrC+iS40wrQ2rZg5MZLk+cIR9BWZe0QEgp9yt+
         593/leGzQKbQWQCMesMS/oh3Ky9ttNSSlAkJhKk0+9rXuWhEebHWgOb07vLOztdoXJlC
         X8iQ==
X-Gm-Message-State: AOJu0Yx9hO5yu8Qg1qYVrVR9tFO4WxwoLXwFVmteAIV1whMz3U4JlhVa
	wcyqFWJ2Qn5obgDpX3jLNaH+IZIS7XchkyTiZ0cBBwpP8B1jKv9O9/jyB3ZtHBA=
X-Google-Smtp-Source: AGHT+IFnZow9Nzfqxp9efLnM6Lg5kAxjH5TlpcNEbaOT4jfHSBZ3FFE/xoypwN1OSnABkM+XnJFlwg==
X-Received: by 2002:a17:907:d93:b0:a75:20f7:2c71 with SMTP id a640c23a62f3a-a780b6ff667mr1223210866b.38.1720804567231;
        Fri, 12 Jul 2024 10:16:07 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a8561fesm360310066b.186.2024.07.12.10.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:07 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 34/49] libmultipath: add is_mpath_part_uuid() helper
Date: Fri, 12 Jul 2024 19:14:42 +0200
Message-ID: <20240712171458.77611-35-mwilck@suse.com>
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
 libmultipath/devmapper.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 6f17d32..4ad84dd 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -870,21 +870,15 @@ int dm_get_wwid(const char *name, char *uuid, int uuid_len)
 	return DMP_OK;
 }
 
-static int is_mpath_part(const char *part_name, const char *map_name)
+static bool is_mpath_part_uuid(const char part_uuid[DM_UUID_LEN],
+			       const char map_uuid[DM_UUID_LEN])
 {
-	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN], c;
+	char c;
 	int np, nc;
 
-	if (dm_get_dm_uuid(part_name, part_uuid) != DMP_OK)
-		return 0;
-
 	if (2 != sscanf(part_uuid, "part%d-%n" UUID_PREFIX "%c", &np, &nc, &c)
 	    || np <= 0)
-		return 0;
-
-	if (dm_get_dm_uuid(map_name, map_uuid) != DMP_OK)
-		return 0;
-
+		return false;
 	return !strcmp(part_uuid + nc, map_uuid);
 }
 
@@ -978,6 +972,20 @@ static int dm_type_match(const char *name, char *type)
 		return DM_TYPE_NOMATCH;
 }
 
+static bool is_mpath_part(const char *part_name, const char *map_name)
+{
+	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN];
+
+	if (dm_get_dm_uuid(map_name, map_uuid) != DMP_OK
+	    || !is_mpath_uuid(map_uuid))
+		return false;
+
+	if (dm_get_dm_uuid(part_name, part_uuid) != DMP_OK)
+		return false;
+
+	return is_mpath_part_uuid(part_uuid, map_uuid);
+}
+
 int dm_is_mpath(const char *name)
 {
 	char uuid[DM_UUID_LEN];
-- 
2.45.2


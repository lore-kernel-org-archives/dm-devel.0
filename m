Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F68417BCD
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804561; cv=none; b=dFh+tD7QOgQRpMiv62eFlWvZ/d770HI5jklOHXRDYWdOx8dZiipxUAU4L5Ob8U1TAYYkOUJVd64Dcz8mVtQUHDJ9LxamIJNC9m9oijt0fkfa+iEgaEuzIx4Agr8V6zomXFvrlTtMXfR49gO/t3IXgG2ANsyetRPZtrbRQYouJ2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804561; c=relaxed/simple;
	bh=QDptvS7uYoQvzzR+xQFWt+pz4LwOXTTRapQrykmxxu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzWgP983gV6kWAegWB0IFhXJiaovpxuH/HM+2991Rq8jhRQyC+eXVqw0bvLI10J4xP9N9uhSeJbRqwnZtP6gEzzC3fu7oDsZL0Goe7Rrr7sg/tJcNEcm+kZM6Ufe/xa5Fc9p+yuh/UDotC8/N8lgUHLJw5j3l4u/h3C4CVg7pyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RCaEpAYa; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RCaEpAYa"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-58b447c51bfso2871445a12.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804557; x=1721409357; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4e/tyY2eQGPT+A/M6tl3n8h+9lLbt+diAgdDFdeZx4U=;
        b=RCaEpAYazTmtwt1v0hZ4IPs8b+lceAHCrGz/rYbyRqOnedVwUsruh4Jbkt0wExhEYX
         5/Iu6KocavGmaCHkV/DRaxW71goxt1pXm9PHXZ8ZA28fe7kONwI0/ajNGXmbPgKaksBa
         xWamZB1+kR1Kr1SPMu2e9RENUQ0Lrwx91x82yZsUzTNe9wCjex50ebVHRAlGkj5H4yJx
         rGCnv6opX0xm4ftrMS2Jzz7EcYOwMCW8ljgeDasXKDx7OSuaCU2kTZh0wwT+CSoZ4syW
         WzDigHf0h8Id3sSVMq3yYozL1jiDkOMZh+aRZRJY0+iLKOy7nxV1DxXJBFXTCjX+e96L
         bPaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804557; x=1721409357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4e/tyY2eQGPT+A/M6tl3n8h+9lLbt+diAgdDFdeZx4U=;
        b=EKMqKklxL5HO8xqddzqDIpfDMN06WE/a6SXgucJXAGyDMx8/RFP/z6UTQY0AOX4IqO
         tMJ0P7LaDhEDixX5egtm44SoRj+alPInOO0ZLnNuTGxjT15o6myfQdWSZGfTA8ECuFWd
         Dq8RbU7fUrMoz5Jx8wJV3hDA6kzsSmtoJ36/52nv7ukhKJC4VLfGa6RmFjg/Tgjw54wP
         CfW6TMFOXOz4WX2bA3KG+uUJ5Ig6ihCMLzHh6LcMGWHMnmkaUmcSQI5ZiUuboReCG2oi
         idAAzWL/DwfB5OICj504CXp5k9pjBF2cDZZt5y92hLxnhoaBUPgb7toQEzD6xyKzWz/z
         9t4g==
X-Gm-Message-State: AOJu0YzmHATitlEpwCgDGkgu0VK34YYmaXPP/jtT+loIlQvlKukOwc28
	+aUhVy8ZgQCsvK/6GPKgnHeQwepEizUxZPH7IuB19J5TRmpKSJSDWKa3f33O01JCfvAIRRfaC+F
	b
X-Google-Smtp-Source: AGHT+IH6mXn/Tjko/IHwYd5eordoPwbHTy17bhELqIenUf8M5Vfum344ZMDXYFuBCKcaizOsTodWWQ==
X-Received: by 2002:a50:eac6:0:b0:578:6c19:4801 with SMTP id 4fb4d7f45d1cf-594bb5807a2mr7712658a12.22.1720804557463;
        Fri, 12 Jul 2024 10:15:57 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5994d1ff8edsm1254391a12.18.2024.07.12.10.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:57 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 26/49] libmultipath: reimplement dm_map_name() with new API
Date: Fri, 12 Jul 2024 19:14:34 +0200
Message-ID: <20240712171458.77611-27-mwilck@suse.com>
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
---
 libmultipath/devmapper.c | 34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 003d834..8af4167 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1481,37 +1481,15 @@ dm_is_suspended(const char *name)
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


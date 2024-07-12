Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C1D176ACE
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804558; cv=none; b=qHUca3zctduGZxbT5otTki/rvVs/Fo8K77PVXCepq0NLUd7sl05jrawtf5HEmXAwD6nQ1PDIf2+eNP2P+AaV0+zPDl6ptdNabl8nfzZNVg/XxcACLubHcN1QDk5/o39rKO/iBQ7uZuAFOa9oa1VrLUeY/DHtYURAneHkvobahww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804558; c=relaxed/simple;
	bh=uqYBnk2DSEy3yh+KxclPWWI5O3FbNdTPOQtwW1GCH6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETilsBMxfZKbikU65X4tC6G5IwQVsXL1MCWMYqEGeQAmomxOkUsqAae9D7YRRZSdPBP4moiBhOzRgc67iIUaXMinS6S3NPyMDUdJQ3sZhKRjy6i+PsfiQSyNCf6v7qWINquanzzCAfFImhiGSamGGdsQGdkmq5efoSEn33EduDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P2BRiC2Q; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P2BRiC2Q"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a77cb7c106dso286417966b.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804554; x=1721409354; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rd5jiIJdq95VDuJROUfCB4shfMuH9jcNHZ+S2lg/4lo=;
        b=P2BRiC2QRrhrasIsflM+Ik0Gy+oB29nRt8onticiwXcrqVUwNnQXetN5oewFKHqypA
         EH0lHmST0MYmzZR7MJAAgqVeT6q/v4i7B2QxKlNsHuoU8qE6V4TQML02+AfNmA7UwgFM
         ypyTv9SRc6VRAHbFS0sGAyhETRnv6+0ZN/qwo7sT5Xt8+JAU2dFZ9GwlaMGKzXn1Hrdk
         fWRHQii05y5c1Ef8ttxLZ1A7nrktyJ6OWPLyy/AnbzxZkDzobvOkV6MbfnFliBuFwnRx
         J8xnejt0QFwASL7HRdG8lbu1GKSqIUN5y2F3ZIKpTjjWIVI1c/YyTZ0B/LPCIq7/ljna
         s8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804554; x=1721409354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rd5jiIJdq95VDuJROUfCB4shfMuH9jcNHZ+S2lg/4lo=;
        b=WlC6zUQwc6Gi/VaNwZpuaJwN8KgXIop9URLBstQxtuU6zinfDKeNbU7WyIM70KGtUO
         HtOeX6qwm+qLQ7Yr5qaCVo5a1+9zjS2H9YfI3RTOMVMfGZwkrGzEsByplmHdV2m9CJqc
         dh0NJY2GIT6nL2PpVbscyBbj5lqi3b6duyr0jbP2agP54rqlkhM94mx2kJw0f7hLpUXw
         p0e1AJeSEN8otA52WYUCbloqNRIdSgh9OnMN6ZRqG96H3xASbOsHPLFh2r2tyLb2McCu
         IBYnr9TH5o31C+ae+UcdmiWrV4Q+1boGyf9Jpj1Dv/R5CUDd7scZLciKVr1rfp465NTd
         B9Rw==
X-Gm-Message-State: AOJu0YyJ5JlOzI3Qy8SMzGRo6UFSE6XTRhKPlfBqoOV6Eo/PYlhkuvRs
	cfxDwlh1T4FLfTtvkN/eAysesHJloPVAhB5Bm32fWjqtJX+Z63aYDxzQ8d+4lnqFrl0xrmOxhq6
	h
X-Google-Smtp-Source: AGHT+IHplqKHSmuuyeuq81XMw8/HaX0u2pRAZ9+XaxlhDmeJXXoY/3lzAOd3oigXYb4ZDJ/5XYMKgg==
X-Received: by 2002:a17:906:28cd:b0:a72:6b08:ab27 with SMTP id a640c23a62f3a-a780b70166cmr757846266b.36.1720804554284;
        Fri, 12 Jul 2024 10:15:54 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bcc3bsm361367866b.22.2024.07.12.10.15.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:54 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 23/49] libmultipath: is_mpath_part(): improve parsing
Date: Fri, 12 Jul 2024 19:14:31 +0200
Message-ID: <20240712171458.77611-24-mwilck@suse.com>
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

Use sscanf to make the parsing of the UUID more robust.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0bc5e34..f80fbdf 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -857,23 +857,20 @@ int dm_get_uuid(const char *name, char *uuid, int uuid_len)
 
 static int is_mpath_part(const char *part_name, const char *map_name)
 {
-	char *p;
-	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN];
+	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN], c;
+	int np, nc;
 
 	if (dm_get_dm_uuid(part_name, part_uuid) != DMP_OK)
 		return 0;
 
+	if (2 != sscanf(part_uuid, "part%d-%n" UUID_PREFIX "%c", &np, &nc, &c)
+	    || np <= 0)
+		return 0;
+
 	if (dm_get_dm_uuid(map_name, map_uuid) != DMP_OK)
 		return 0;
 
-	if (strncmp(part_uuid, "part", 4) != 0)
-		return 0;
-
-	p = strstr(part_uuid, UUID_PREFIX);
-	if (p && !strcmp(p, map_uuid))
-		return 1;
-
-	return 0;
+	return !strcmp(part_uuid + nc, map_uuid);
 }
 
 int dm_get_status(const char *name, char **outstatus)
-- 
2.45.2


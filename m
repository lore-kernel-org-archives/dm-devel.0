Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2927517736
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804569; cv=none; b=u4TgIQ4kUa6O5xV9lEGQEPMeXYXKiB/txj+qWSFpDFhxh3s1d2A4XWnp+Czz/KLKaQOlFDqfGiClljN+ReaInMjCBnA2R4tZ3BVWuOryO9332diF8KjlNlWk14QBMxzxMGecmjaJYWCnYFe9eZevMdNTifkT9RTo9VYm540z+9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804569; c=relaxed/simple;
	bh=vBEJ8hgk5mbVoFyIF9lBA2AyZUdnOTHBsYBg/IRz0L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuHQ93Q0tDlOqT5syTlt4TJa1jqhk8lLFQubiFvup+IvARcN4yMv4Aa3hwqikbgnupbm/w8GNolnw0gLAW2IZCPz/9vlkZtKLuwzvEyP6CtbJFm+l74s/UDsq6fAFXgY6UBN3KhuvqmCaNZoHBarFQ3fDJaFdRCAhf79UCj/hyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FAGDEsxb; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FAGDEsxb"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a77dc08db60so284262666b.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804565; x=1721409365; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U1+rE77bDSNAEPCQMi8HjUNLyVF+VXzSkeRMqWUfpGg=;
        b=FAGDEsxb5apR1ZQ9SPYaVKc5rKm+WrTm3VjgMzH2ylidepC20zmZwRKrP4Gt2Al6Tm
         1w+oAHyevGRrl1TXHstJF3SPPDLjV9zcbxwZVs/rwTSmQtiV5OUIHT6/x8K99NASbYEq
         dq1J/hHJPEVRFiJoT2xvyl1DlQW9ADoIH4aGkMY+rWoTxnVe2C6Hp60Rx2XxL3iXfw9s
         OIAarV6hmUIaQ9qLrmcCX80L9CQpVCmdcBTr0rZ02QcxxwcMQCk2caUM8fnW3Qfhuuw1
         DUGW8uTLshrlShChnOEm0TqHkMot67rQHUSgn6oC/3jpOLN1TlDa6n6TGoyZ6wQaP5Jo
         /ezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804565; x=1721409365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U1+rE77bDSNAEPCQMi8HjUNLyVF+VXzSkeRMqWUfpGg=;
        b=ql6jp/HGMUgyWw0ZyDvyCNl8t0ab5woFfmSk4s+rr/u34ePgyKTc1w3x/V4V064x3f
         numJespqxXalpdz5/a5lbWmdszUaYfoaMMUlZNLI1m6AcUvDQt+EgBJgXqKD4gh3qzho
         fQscOXNrT4KGeWRA3ka0zEWyeUEUxROmhM2v0e4oREssPskjxKOYlcgzXPEBrD9qIQcv
         oMVBkBVaYY6E66nNarz70Rmr3USsno7x0KqZ3TtCMyPO49VT9YjjL97ME+pP9C4O9xb3
         oQ6tzKQxty/CFMTH+2aMB99vUQDnVuRRoW3fnXUj1RMdtI+AAIiKKYyYOy/e7HLMhb1c
         Yphw==
X-Gm-Message-State: AOJu0YxzNMtrbZCFdQugfk7cdlF6P1qUvLiar2WjbcRN2DvEQpBTisHL
	L7G2atgbvLJtrYxtsnF2kooJAZQPOQm1VXgniEbHL6Ix0XgLsAR1bcTAAfUpek8=
X-Google-Smtp-Source: AGHT+IGSMJE/nKvVgItnsAb3JDetQhEk6+Aeog+YLQGjH5M2x385L3Zd7GOxfgbCeu056Rtau0laGA==
X-Received: by 2002:a17:906:195a:b0:a72:a05a:6601 with SMTP id a640c23a62f3a-a780b6891f6mr832442466b.14.1720804565494;
        Fri, 12 Jul 2024 10:16:05 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff038sm358713866b.115.2024.07.12.10.16.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:05 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 32/49] libmultipath: use libmp_mapinfo() in _dm_flush_map()
Date: Fri, 12 Jul 2024 19:14:40 +0200
Message-ID: <20240712171458.77611-33-mwilck@suse.com>
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

We can spare one dm ioctl here.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 2f547ab..9483f02 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1074,10 +1074,15 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 	int r;
 	int queue_if_no_path = 0;
 	int udev_flags = 0;
-	unsigned long long mapsize;
-	char *params = NULL;
+	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	char uuid[DM_UUID_LEN];
 
-	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES)
+	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			  (mapid_t) { .str = mapname },
+			  (mapinfo_t) {
+				  .uuid = uuid,
+				  .target = &params }) != DMP_OK
+	    || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
 		return DM_FLUSH_OK; /* nothing to do */
 
 	/* if the device currently has no partitions, do not
@@ -1091,7 +1096,6 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 			return DM_FLUSH_BUSY;
 
 	if ((flags & DMFL_SUSPEND) &&
-	    dm_get_map(mapname, &mapsize, &params) == DMP_OK &&
 	    strstr(params, "queue_if_no_path")) {
 		if (!_dm_queue_if_no_path(mapname, 0))
 			queue_if_no_path = 1;
@@ -1099,8 +1103,6 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 			/* Leave queue_if_no_path alone if unset failed */
 			queue_if_no_path = -1;
 	}
-	free(params);
-	params = NULL;
 
 	if ((r = dm_remove_partmaps(mapname, flags)))
 		return r;
-- 
2.45.2


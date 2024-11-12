Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DC420370C
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423760; cv=none; b=dfuUWW0x6+UTF71XSYMgzr5Q38RI2q7MtK+aRkr57PSXx3LpYdD3Hb+9HQ2IhOFkg9+NYsk9tR27+nc/tnTPABi8/pWg9KIFodLy4ZDB64HmRG6g7+DbqpNge1psb2iPp4XPEkhUaLIAwHovPzZAVEItHvVLTgATeFxFoIZ6eeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423760; c=relaxed/simple;
	bh=H+VRsW7Xn0yLoakFQJ0gRM3MyEEWzOa34iOeU8px734=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RufQOod3fk6mcgMR+kojiZQANZUKXSai2mvBjQGLD8InSVibzToTLTPLrUEBXzCGQCLMufg2cKIN8dfjdNr9mGZW0yU6L0TbIT9qbgLuz+u7mZlPsVXlFQVECo0j8W0GlQyhTK/zvPTcB53Ap+dRYuxomjANCkeWlUeTQRh+zT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gd/UIFr2; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gd/UIFr2"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37d473c4bb6so5371743f8f.3
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423757; x=1732028557; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1o4XHBXt7Gcdwmg05GovfIjGORc7/16vIFhR/9ZGGM=;
        b=gd/UIFr2j4Rw9FJwPruNMstzQAC6cIH9YfSUSD195HpFU5fRAt8OSCbItOLK322LN0
         X7lsXgfjfXf5qMDH5PUmJ7yn5lUmT85F77TDqV9KnZp6lYQG5rfcpFcNR+fUrVMFSULf
         zqiXyZOvMTey9TWNnf3NI7XjT93jisvN/wgTkU87kTUMwiUGKITtREo4BkIYnhWwH9j1
         juRMnXqTHa6t8wAZrgSXQ8XR560pWayClxA6ZCs/daeA/l7/lCFn8bjx9vsMZpECPhUB
         IxpYfHZh52AxTtLVN20D0apMamif4fpdDKeytBEUMomLBUFXVCGDVf7fy8lytWBi9uQp
         fLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423757; x=1732028557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o1o4XHBXt7Gcdwmg05GovfIjGORc7/16vIFhR/9ZGGM=;
        b=nGltOCM6nqWao83pJVVeKvE15xeuSMmaLvVb9Fkp7wpCcCpYQMUXRX2BJk0vioPbgg
         xd3m6rngtseeWisfDEpSoPwXzfPsRVWusWM5XjuRruCoEV+SW10kVe+locbuzyGRwC8k
         fJFeUhv0B50dS8YEp2Ij5zqp0nVkHhRrZ+ws6I90eID097+vvpMfVbDqPsdci8f2FY17
         C8Z3NzqTXF6g79SDN6aX/wzPR1Ld9OvcMjacfzekeF1Kekn/0tT7i0IUKQWH5SzQLcKR
         zf0Mz2/9uXK9JNQ7jm//kjGvHDWOgRNVfM9iHLfs/Iw/cxu+1ZRdQkIvomQaMqOjD5rb
         iBow==
X-Gm-Message-State: AOJu0YwMk6LXm9f1ucVMekljtK6mmFPhQWzffEZgiYj04w0iigHhcNWf
	SzxZ8L8+xgOklOe90mf4GdxdqsgRkvHlEqYZyGRfC7LoEkoPqWIXrZVj7aeJc98=
X-Google-Smtp-Source: AGHT+IF9KhphZyoUdEOTTPjxRw/lGl6WoIrMMc0QMm2Cb/gZqB8zorEnGW4UZWT0ecA+etW173vHgg==
X-Received: by 2002:a05:6000:1fa1:b0:37d:3e6d:6a00 with SMTP id ffacd0b85a97d-381f1884805mr16454000f8f.47.1731423756084;
        Tue, 12 Nov 2024 07:02:36 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-381ed997313sm15541648f8f.53.2024.11.12.07.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:35 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/12] libmultipath: use MAPINFO_CHECK_UUID in dm_get_multipath
Date: Tue, 12 Nov 2024 16:02:07 +0100
Message-ID: <20241112150215.90182-5-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Marzinski <bmarzins@redhat.com>

Instead of seperately calling is_mpath_uuid(), just use
MAPINFO_CHECK_UUID when calling libmp_mapinfo.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 93fbc4a..d193586 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1211,7 +1211,8 @@ static int dm_get_multipath(const char *name, struct multipath **pmpp)
 	if (!mpp->alias)
 		return DMP_ERR;
 
-	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID |
+				MAPINFO_MPATH_ONLY,
 			  (mapid_t) { .str = name },
 			  (mapinfo_t) {
 				  .size = &mpp->size,
@@ -1220,9 +1221,6 @@ static int dm_get_multipath(const char *name, struct multipath **pmpp)
 			  })) != DMP_OK)
 		return rc;
 
-	if (!is_mpath_uuid(uuid))
-		return DMP_NO_MATCH;
-
 	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
 	*pmpp = steal_ptr(mpp);
 
-- 
2.47.0


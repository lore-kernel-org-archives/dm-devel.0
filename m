Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908CE14A96
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 18:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379620; cv=none; b=k6sCSsOWh93TpzXF/5D3z6nivc/5NWpKEX1+yxhtorn1n5v92xpBkbWArDxga3vrduQU+NOAed7ysNHnWYJPZFeuVY9j30u89uGPAo83sxkcanqksNg4KPi6J011iSCj1TRIFhFmuUYcrBazG2cJ8PzgkG8Qgk2f4QwUe+MKTdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379620; c=relaxed/simple;
	bh=TpEX0GK1rQQ/Xpklw3SopwVXaYIqxOhb7DH2DJKMsCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XliLlXt/JyRh+xWQL3uZEqdTctvfDCbuvf/us3JryuE4T6OmM8wxZxVS7Kzj2svSZN3HBgfecgmVkgjnRPAn/eGHi66KmX2PR51DpqxmkPCeFjUxhLOL0NlQiPh15p1Mflnz6hsDPo4hYN+Bv/A8Ijlb26hXfK/XpCllL87DWbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bV0dqyZ0; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bV0dqyZ0"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a51beae2f13so693239966b.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 11:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713379617; x=1713984417; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSEbmtP17uf1+bU90SODFrwuyJTQShZqEa2GOWESEX0=;
        b=bV0dqyZ090ubeL8QtAZGoerVds56raU1UyuzgF7CbMatAifJBPtigbGD2R5yAZPzdn
         wmpZVDFfne+zCFMLDi3lD5y1ba2Us6CuWKBD1mQYJm64UGU3ZDioSLpa0dtSAeVlsKoS
         5mn/y2fku+HzQojBYOm1M3+bdwbTSXFn9T1mI6q7NJishgupbHZx+tBX/S1NPYJh4UD+
         bBUFv5wTQfF7cRrl+LtjA8asmf59AabH7rgVP3ryQzyaAfzdzZJfUzyxFvs4BDV1ldfJ
         ftgAmjx1OmIpdT05JXMk3nr42+PRdBsryRGF66eHT/4KygY61l1oYUFI9ET5hazXL24V
         Lggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713379617; x=1713984417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSEbmtP17uf1+bU90SODFrwuyJTQShZqEa2GOWESEX0=;
        b=ZqrhhqWwTgCqzrfTgiY9lxcl9gr2rEmwg6c7PKE/q8bw9xPpjvQw+WF5l0r7d4Wcfr
         XjCPXLTLC9PCRR5Ys3okzuMXd1wUKFdaEb7ToMzf0WTss+7doRD+IQ4zwbjmWkwFW9U1
         kVRaMfBTGzzVGDuw5HqHewi89YjOYAGaXV/3RtkaBNzxfMAwr58fSrxsCcPino4ugKxU
         0kpQVnk94VCgojo0NN1ih/7FP5ZITixI0FGp3zVn6NDFTrqEwQTM1JJmkzluOdg1ocJo
         ClTqLpM3+NxGotMm1sNrke/L84Mgea1TjW0pajaA52AcAVDZC7SDC0XhTYGpNn2N1z3t
         VgtQ==
X-Gm-Message-State: AOJu0YwhcCAbcKgY5byU9Ea/9h7I9MwXo1Lqa94TXVDN/Ch1Znt5XA1Z
	oEHsZZOB5IwhiSQOXr90dDEiwf4kNCP7YvNMfD++doXiwRqCGssDMLEB4HCtGPI=
X-Google-Smtp-Source: AGHT+IF8YGJ8FHkPm+sOzRRZDx9VM3w5Ej7TIxYCEaAu7OcNkcTakixSqmBQPKFJT6JKYvMuGwIWvQ==
X-Received: by 2002:a17:906:11d2:b0:a55:653b:3981 with SMTP id o18-20020a17090611d200b00a55653b3981mr201621eja.50.1713379616874;
        Wed, 17 Apr 2024 11:46:56 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id q5-20020a170906360500b00a51da296f66sm8357746ejb.41.2024.04.17.11.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 11:46:56 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>
Subject: [PATCH 2/8] libmultipath: move get_udev_for_mpp to sysfs.c
Date: Wed, 17 Apr 2024 20:46:38 +0200
Message-ID: <20240417184644.6193-3-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240417184644.6193-1-mwilck@suse.com>
References: <20240417184644.6193-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes, just code movement.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 20 --------------------
 libmultipath/sysfs.c     | 19 +++++++++++++++++++
 libmultipath/sysfs.h     |  4 ++++
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 4ecf6ba..89ac03d 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -453,26 +453,6 @@ pgcmp (struct multipath * mpp, struct multipath * cmpp)
 	return r;
 }
 
-static struct udev_device *
-get_udev_for_mpp(const struct multipath *mpp)
-{
-	dev_t devnum;
-	struct udev_device *udd;
-
-	if (!mpp || !has_dm_info(mpp)) {
-		condlog(1, "%s called with empty mpp", __func__);
-		return NULL;
-	}
-
-	devnum = makedev(mpp->dmi.major, mpp->dmi.minor);
-	udd = udev_device_new_from_devnum(udev, 'b', devnum);
-	if (!udd) {
-		condlog(1, "failed to get udev device for %s", mpp->alias);
-		return NULL;
-	}
-	return udd;
-}
-
 void trigger_partitions_udev_change(struct udev_device *dev,
 				    const char *action, int len)
 {
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 328951e..afe9de9 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -339,3 +339,22 @@ bool sysfs_is_multipathed(struct path *pp, bool set_wwid)
 
 	return found;
 }
+
+struct udev_device *get_udev_for_mpp(const struct multipath *mpp)
+{
+	dev_t devnum;
+	struct udev_device *udd;
+
+	if (!mpp || !has_dm_info(mpp)) {
+		condlog(1, "%s called with empty mpp", __func__);
+		return NULL;
+	}
+
+	devnum = makedev(mpp->dmi.major, mpp->dmi.minor);
+	udd = udev_device_new_from_devnum(udev, 'b', devnum);
+	if (!udd) {
+		condlog(1, "failed to get udev device for %s", mpp->alias);
+		return NULL;
+	}
+	return udd;
+}
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 2db86bd..3be3f66 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -39,4 +39,8 @@ do {									\
 int sysfs_get_size (struct path *pp, unsigned long long * size);
 int sysfs_check_holders(char * check_devt, char * new_devt);
 bool sysfs_is_multipathed(struct path *pp, bool set_wwid);
+
+struct multipath;
+struct udev_device *get_udev_for_mpp(const struct multipath *mpp);
+
 #endif
-- 
2.44.0


Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BB5338581
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817144; cv=none; b=tVLEerXEGGd7sLgHbw+Mir+4+QMFQJAIkufBV3z2SPNuLVx0cKpLfkvlvd1yUwVSRlFEuofQq26QttF/Aa0NlfzoXpQAgvTftNYKu3Fv9IE9KapSWateMTrln4zwEAMJbps9GAy+vcRIcblJqr4cpwceJQiX4YnNBy8Qc2vfDRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817144; c=relaxed/simple;
	bh=LynzlpRdwxb5OMRcnWqp/SDVzIyvm5ToM5rYeM6yqb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVjKr2ge78tCjdzPyQMluT2O6kPsVqMUBkHzakmqqyNUA1OVPtZYrKngT8xXHV3fMPtkfXMIFlJt2A2bMqB+ozR2C3A6/8GOz8XdbmSP2RM4DSWM9nYcDEUE+bSEzmA2fqGZg49BAC+rYvwhXpeUI9sKVr7CBIaI5b2En0ipKEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QIT85ci9; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QIT85ci9"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64d0d41404cso3653481a12.0
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817140; x=1768421940; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACT83A+LDdCCHg1rjy2VCDjCliOcr2Ne8r2XteelJ+0=;
        b=QIT85ci9cV5MK0ZZYty3qh+TXuetCOad301J1Eh8F8kS0QMt6roU5jSVnZx358UINE
         IFCznBF4LkLamxBngx+z9RL1Kp0g7bVa9l4jj56NvUrMa3RWagv7NSCmIKTybXz2VfbM
         TvSAQ2WdJDjQe//BLPEqwmjupe+30B46OtBmDXnTUdb/yngB2fHzeQHZALGVaL+wqKzG
         8qaIYH23mmL4CEAv6/4Y1QEApvExMteb5/AFfYEJQkj4JT5+5LccBKbrrg62iwT/D+Fb
         +OH+S9irYHeNVhhn9Nc/tY+fon2D6xAibqfsp0sWFDCS1p2WMpGvSbAWw4H0BGPjd0AM
         unQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817140; x=1768421940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ACT83A+LDdCCHg1rjy2VCDjCliOcr2Ne8r2XteelJ+0=;
        b=kpLVO5M2vokThRVttIL7fjFiDHRurzNR+uK2u8DAbbrvhZm0OY7UvmpdMF/TUTp0h+
         OcU1w5TRbQeFu2ifdITs1+mVaz6xNhO7cnbiSwhBiTUPT0wHWP/wuGoyTSX0k4c7Qrw/
         3BFUL/GDgIwK0Lj4xrCqmhXcMolcCHAwbIAjCPs7GIG8VzIoIK4LEbCIzaYptJF6uOO5
         xnQdwgtaXvhp70nTy6IwLCdVkn4l3A0Vw0WkWuZiUhgcnIpmCCA/uHyPjqqN4mJJji5S
         BaizDfBaj5DGjRCstmwbbTvkWrejKdAJ4bIQXwOOjq2C9JfZzt3p88gD6yCxHJD8kTCS
         7K2g==
X-Gm-Message-State: AOJu0Yw4XAkSrPszlt0SmRVVlfYTdAAKE6KFvfWhjXeVdVYSndPlIjh0
	uDTHXRfW+Z46Iva8Zc0aWVAazaK1UesvdQUCTAF1t4K+CARoyHK5r7qDnthCCXbiIWk=
X-Gm-Gg: AY/fxX6QCOwsE080RQ7a12TuB38SMGcfDEkA3uErQSrVdHCapu9RUkBQK6iJRAuV/Vc
	kXhWuRjh9Via/9hbEHakTJCB6dWv07VvBblXThhgYzA4GXrI0etha7DcPZmKjd37KDdw4rHf0gx
	0AKaQWQsJcJHNDXzadIXcBAo3lVMBRfI6par2AUqkJNFBe4hilM5gbePIV6rpwISbbvh+ym4e4h
	7sx0IDw4jENEFjPsWHPUZhGr+rqDOqH8yN3btsr76B6aQZ0GmdYkifa15K/YN5g8B9SJEswu5n/
	a6vyqDaCbnTQMfRAWfQTf9Fyixf/Aoz0y9Lmo0NoOmifdZ12AR5qqo0gGoAvFTO7+w3uNBpObr/
	bF4oaiwnTZZGRwju8/Bry2FctzCYTfn/LPDYoCEnfK7pDnKGw2Rh46wKfeUUsT+/NiUFz8SOKUH
	uQAlcWwUsWzWUaL+sI6qkkmj85AJupLfPBK3ugyhV1rcaIK6WmeI/tDvjMQsw/8ur/crUBCkDpu
	Q==
X-Google-Smtp-Source: AGHT+IFEYE8KJuvHQJRiNGHouaRx6mZYuyVzXzdRIPoITZ4XGE8zFi3Si1k+HTDUuT1Jhgdak1IPSQ==
X-Received: by 2002:a17:907:9449:b0:b7a:1be3:a583 with SMTP id a640c23a62f3a-b844516e596mr342991566b.64.1767817140189;
        Wed, 07 Jan 2026 12:19:00 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a4d1c61sm594190666b.35.2026.01.07.12.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:59 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 19/26] libmultipath: simplify sysfs_get_target_nodename()
Date: Wed,  7 Jan 2026 21:18:19 +0100
Message-ID: <20260107201826.323977-20-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All devices that we use to derive the target node name from are
parents of the scsi_target device. This allows some simplification
in sysfs_get_target_nodename().

This changes the sequence of libudev calls in some of the tests, which
need to be adapted.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 36 ++++++++++++++++++++----------------
 tests/test-lib.c         |  5 +++--
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 31db875..85ea1aa 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -325,19 +325,23 @@ static int
 sysfs_get_tgt_nodename(struct path *pp, char *node)
 {
 	const char *tgtname, *value;
-	struct udev_device *parent, *tgtdev;
+	struct udev_device *parent, *tgtdev, *device, *target;
 	int host, channel, tgtid = -1;
 
 	if (!pp->udev)
 		return 1;
-	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev,
-							 "scsi", "scsi_device");
-	if (!parent)
+	device = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi",
+							       "scsi_device");
+	if (!device)
 		return 1;
+	target = udev_device_get_parent_with_subsystem_devtype(device, "scsi",
+							       "scsi_target");
 	/* Check for SAS */
-	value = udev_device_get_sysattr_value(parent, "sas_address");
+	if (!target)
+		return 1;
+	value = udev_device_get_sysattr_value(device, "sas_address");
 	if (value) {
-		tgtdev = udev_device_get_parent(parent);
+		tgtdev = udev_device_get_parent(target);
 		while (tgtdev) {
 			char c;
 
@@ -362,7 +366,7 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 	}
 
 	/* Check for USB */
-	tgtdev = udev_device_get_parent(parent);
+	tgtdev = target;
 	while (tgtdev) {
 		value = udev_device_get_subsystem(tgtdev);
 		if (value && !strcmp(value, "usb")) {
@@ -375,11 +379,8 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 		}
 		tgtdev = udev_device_get_parent(tgtdev);
 	}
-	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi", "scsi_target");
-	if (!parent)
-		return 1;
 	/* Check for FibreChannel */
-	tgtdev = udev_device_get_parent(parent);
+	tgtdev = udev_device_get_parent(target);
 	value = udev_device_get_sysname(tgtdev);
 	if (value && sscanf(value, "rport-%d:%d-%d",
 		   &host, &channel, &tgtid) == 3) {
@@ -399,13 +400,15 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 				strlcpy(node, value, NODE_NAME_SIZE);
 				udev_device_unref(tgtdev);
 				return 0;
-			} else
+			} else {
 				udev_device_unref(tgtdev);
+				return 1;
+			}
 		}
 	}
 
 	/* Check for iSCSI */
-	parent = pp->udev;
+	parent = target;
 	tgtname = NULL;
 	while (parent) {
 		tgtname = udev_device_get_sysname(parent);
@@ -428,13 +431,14 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 				strlcpy(node, value, NODE_NAME_SIZE);
 				udev_device_unref(tgtdev);
 				return 0;
-			}
-			else
+			} else {
 				udev_device_unref(tgtdev);
+				return 1;
+			}
 		}
 	}
 	/* Check for libata */
-	parent = pp->udev;
+	parent = target;
 	tgtname = NULL;
 	while (parent) {
 		tgtname = udev_device_get_sysname(parent);
diff --git a/tests/test-lib.c b/tests/test-lib.c
index e529711..963e289 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -292,12 +292,13 @@ static void mock_sysfs_pathinfo(const struct mocked_path *mp)
 
 	/* sysfs_get_tgt_nodename */
 	will_return(__wrap_udev_device_get_sysattr_value, NULL);
+	will_return(__wrap_udev_device_get_subsystem, NULL);
 	will_return(__wrap_udev_device_get_parent, NULL);
 	will_return(__wrap_udev_device_get_parent, NULL);
 	will_return(__wrap_udev_device_get_sysname, "nofibre");
 	will_return(__wrap_udev_device_get_sysname, "noiscsi");
-	will_return(__wrap_udev_device_get_parent, NULL);
 	will_return(__wrap_udev_device_get_sysname, "ata25");
+	will_return(__wrap_udev_device_get_parent, NULL);
 }
 
 /*
@@ -328,7 +329,7 @@ void mock_pathinfo(int mask, const struct mocked_path *mp)
 	    (mask & DI_BLACKLIST && mask & DI_SYSFS))
 		return;
 
-	/* path_offline */
+	/* path_sysfs_state */
 	will_return(__wrap_udev_device_get_subsystem, "scsi");
 	will_return(__wrap_sysfs_attr_get_value, "running");
 
-- 
2.52.0


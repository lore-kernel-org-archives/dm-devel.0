Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7737202F88
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 23:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748688; cv=none; b=ikhqOW0PhL1pST9xwJOo5GM7Eul3fCltVAM2oSvcxGSUqaYm+pl+om0Hc8th4NfL6BaTrDmMUl4YJPI6dEVZ8PS0ABizaIRpf1jh9T56O41vQYV+ervKdA9jaGvRjivWaC3o084+JNjJnahpVXpTa68olGY1iQciGY8juHld28U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748688; c=relaxed/simple;
	bh=EbRSsIU8M5Z7wguy9WPxLyqDC7aPCUNC9FI3hsLSiWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXUHRMxGRSxpm5/v3BvfixyS86Yr9YXBdzQnWoTLWCL1kTXixwbF5n1aRdhVHrSy4OWpMUwD2M7uPDedIwpMa9XuTbs5rGyMK1NxLygxWy2706x7a1km0UC5gmFiHn1KtRahCf08cMhgFwreXj8g4YaWYAJGf0k0t2CGdEzs6NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DPLf2z4+; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DPLf2z4+"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-434a1fe2b43so1569175e9.2
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 15:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732748684; x=1733353484; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2I0ZMSlmKaPHwyazn+ikQztNTZEcjG3llZmEp37SW4=;
        b=DPLf2z4+fUzAzaLqk2xptLU3Fx/D/WpJSJi68VpghDV1HBVFFrBPpOTY6iXN4ania7
         GfgiHJijpHkGBFC11V9UdXK52omv56k4ZnKvnk7YHgzE8lvPX0eoJiO1/pxA7VhGaOia
         pWBc9ShH8kwJ7r+gN7VBLubykw8QE9VWjm+zUIq/ObsFRthjVn9NyErJu00uufU3Mz6T
         7CLmxe8a0CgnQ4L8wCFSS8R3fYYluNSt8GXRHnBYOTwQB10063RBcVX9HWWvjP5I/2d0
         y4/71gN2ntb4IdN0iYieaw6shwJjDUDoIKAAlTQf8P9eG9tl1PYcdT/m8wnS2ZXPpz4D
         3qzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732748684; x=1733353484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p2I0ZMSlmKaPHwyazn+ikQztNTZEcjG3llZmEp37SW4=;
        b=qCBd6lI3kajbdaofIwPGIXK8iu0PWYhjYEWA3DJsCrLQ0MuGuKg6bNDxyba58ITwVz
         3xfSd8x6T74eSpFIwWgq7zaRno9A4YErA5VeogmobQjG5d0XhcXrIs2+yqD7wjnBufRG
         HQnNRztpnZyFghpU5kPPUslVBC47/qDG5Bn/V0oMxpCN5aIfcqBY3xERk/nmjYAjRRcO
         9cw1euvm9lMAUieb8LJDLKkCfgR5l8INkn4FDlG0Sp3dianPOjwI/eyS4+G/O0UcqD/Y
         TEhZT3u+QKhHVSei/pmyH/Smb4kalXGfDn2Eo8yKl/QnB6rhVrs5NNHvVh4v+OCugaqy
         JmAg==
X-Gm-Message-State: AOJu0YzqDsRHjxg1KHSdnyGkaoouLitd+wMTC+f4BjlDgZ6517Bt4ND9
	ehMvqqVFWE1He5Fzi+5pJX5l3S7dC3Kut226HIXDDh49ZWn5kdJg6EPpoL8V89eZv3loc5z36/A
	y
X-Gm-Gg: ASbGnctm5cTnOCH/o+q4CO3Aqo0tENkSs3SFsks/M07k0hM/axKJU5IzRDLmzU6jFda
	pF6SR5DkBg0069sAvHDLs4hbzXAxcCyiuJ8AjN6FZx4KSZPRgF4efncdRZ1e2thCPAqyiZua5Ta
	J5hMfhtManCck1nHRZ1OOkEk+0Tr8xcfooEJw834Hdf8JrKWKQ9hS+6iggkOsqctWBSLQ6/vcjx
	68b1hE3DcNHcFGguDdMIGSATrG1qnAYwq5OckV0TYtFGMr+k4vDJHtp+I2VJZ1YiwZrPtwK4Euh
	U8Seh+FGWkM4AF6axB/ycVTTjgnEIVGOAjh5
X-Google-Smtp-Source: AGHT+IGI0edCpgIdr8hRPJI67Vn2JYzEVEvB0j07dLrAQj5gyAjRF+eFgdkrmc5R6rLWjgY4CnMiJA==
X-Received: by 2002:a05:600c:510c:b0:434:a902:97d0 with SMTP id 5b1f17b1804b1-434a9df21f4mr41965615e9.29.1732748683891;
        Wed, 27 Nov 2024 15:04:43 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385ccd3a71bsm74982f8f.55.2024.11.27.15.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 15:04:43 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 6/8] libmultipath: trigger uevents upon map creation in domap()
Date: Thu, 28 Nov 2024 00:04:28 +0100
Message-ID: <20241127230430.139639-7-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241127230430.139639-1-mwilck@suse.com>
References: <20241127230430.139639-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If map creation succeeds, previously not multipathed devices are
now multipathed. udev may not have noticed this yet, thus trigger
path uevents to make it aware of the situation. Likewise, if
creating a map fails, the paths in question were likely considered
multipath members by udev, too. They will now be marked as failed,
so trigger an event in this situation as well.

Fixes: https://github.com/opensvc/multipath-tools/issues/103
Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 11 ++++-------
 libmultipath/devmapper.c |  9 +++------
 libmultipath/structs.h   |  1 -
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index bd71e68..2b1dfd2 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -614,8 +614,6 @@ trigger_paths_udev_change(struct multipath *mpp, bool is_mpath)
 		vector_foreach_slot(pgp->paths, pp, j)
 			trigger_path_udev_change(pp, is_mpath);
 	}
-
-	mpp->needs_paths_uevent = 0;
 }
 
 static int sysfs_set_max_sectors_kb(struct multipath *mpp)
@@ -1002,10 +1000,10 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		 * succeeded
 		 */
 		mpp->force_udev_reload = 0;
-		if (mpp->action == ACT_CREATE &&
-		    (remember_wwid(mpp->wwid) == 1 ||
-		     mpp->needs_paths_uevent))
+		if (mpp->action == ACT_CREATE) {
+			remember_wwid(mpp->wwid);
 			trigger_paths_udev_change(mpp, true);
+		}
 		if (!is_daemon) {
 			/* multipath client mode */
 			dm_switchgroup(mpp->alias, mpp->bestpg);
@@ -1030,8 +1028,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		}
 		dm_setgeometry(mpp);
 		return DOMAP_OK;
-	} else if (r == DOMAP_FAIL && mpp->action == ACT_CREATE &&
-		   mpp->needs_paths_uevent)
+	} else if (r == DOMAP_FAIL && mpp->action == ACT_CREATE)
 		trigger_paths_udev_change(mpp, false);
 
 	return DOMAP_FAIL;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index d4dd954..55052cf 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -537,7 +537,7 @@ static uint16_t build_udev_flags(const struct multipath *mpp, int reload)
 		 MPATH_UDEV_RELOAD_FLAG : 0);
 }
 
-int dm_addmap_create (struct multipath *mpp, char * params)
+int dm_addmap_create (struct multipath *mpp, char *params)
 {
 	int ro;
 	uint16_t udev_flags = build_udev_flags(mpp, 0);
@@ -547,9 +547,7 @@ int dm_addmap_create (struct multipath *mpp, char * params)
 
 		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
 			      udev_flags)) {
-			if (unmark_failed_wwid(mpp->wwid) ==
-			    WWID_FAILED_CHANGED)
-				mpp->needs_paths_uevent = 1;
+			unmark_failed_wwid(mpp->wwid);
 			return 1;
 		}
 		/*
@@ -570,8 +568,7 @@ int dm_addmap_create (struct multipath *mpp, char * params)
 			break;
 		}
 	}
-	if (mark_failed_wwid(mpp->wwid) == WWID_FAILED_CHANGED)
-		mpp->needs_paths_uevent = 1;
+	mark_failed_wwid(mpp->wwid);
 	return 0;
 }
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 2159cb3..6a30c59 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -467,7 +467,6 @@ struct multipath {
 	int max_sectors_kb;
 	int force_readonly;
 	int force_udev_reload;
-	int needs_paths_uevent;
 	int ghost_delay;
 	int ghost_delay_tick;
 	int queue_mode;
-- 
2.47.0


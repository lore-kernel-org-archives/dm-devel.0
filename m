Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F298324700
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155301; cv=none; b=tY1z/szpmE+E85PBH8G5qUiQEEagCs4UxzTMRtw076gx1s/hgOiOzeNkpryK+4OtgTpGPzf5w553lEy1/0Ty9SY+7KliNeZd/+V5lsWKkQ6lqNuHxeU5ADSFFURuzNj7LbI9ENbF7kqV1zie+5VGIKe/XDqRmoOVD0YgMNxk8k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155301; c=relaxed/simple;
	bh=LynzlpRdwxb5OMRcnWqp/SDVzIyvm5ToM5rYeM6yqb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Na3nNdHDzqKJnyB7yN12uVziJwhONa1jDkOfrbO9kTS4jtqGPwzmbd09JXnP++rJBZL2NBAZJ1YKnQbXW22+Y/MjTEcvhY1gHRxyHVuuMSiJtudwuIEFwPABOhLFOb/CdJ4CAURclKVSiKgsubpDQFY6lwt06eASVJY0AbLpC9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U9OP3pHG; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U9OP3pHG"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7355f6ef12so353419666b.3
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155298; x=1766760098; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACT83A+LDdCCHg1rjy2VCDjCliOcr2Ne8r2XteelJ+0=;
        b=U9OP3pHGmd+8gXUWqAdOIVOGZ8q4Sdno5NoWaIqXZECsYo/vp+hvz7x1ZimzCUUhO7
         PqmuZ0g2bUlWbxBAvyTonhYJsx7/u1tHOSLm495O9cM8xlwqMQuy6CbNqgJIEHM/Xhzp
         YiWMm6NDS0/CFrL4dGEuBWYCn5vx797jQT6E/1Hy8pCbg4ue3KFth92GI0vy4mGwWmSg
         rDJ8vrKnkyWdoFhZYJuV/iZGoqy7XWqODqRXmtblWqgJXqYMV9lBRx2HIJS2OMlYVbfp
         qaLnoagqQW4zmn4KUO5efzSZDUOefYwHJx7G/Pd3MZYHl3zR2zWQ/Bfkc05gJzXvqrT1
         tpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155298; x=1766760098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ACT83A+LDdCCHg1rjy2VCDjCliOcr2Ne8r2XteelJ+0=;
        b=FseAWeYZwl7lNdg2GpR0VOhRlc0SIx6KcvlF74ahMV3hvmk/noZaDSESszK06HZ96q
         suXc6F0iYSdejIXvPVvIpYxfhSMTQVl4IN5K2ofemFmz89Dz6nXMb2tXwW9qSXDzYjcy
         KxGqP06jPLWHpWH8j9QLpLCPxMg1/RWTdvXWuP/xnMC599vIChhQAxUjXSNBymIj1Pbc
         afM13BVyoUbLfg1dfWpv1bhYhSj1j0QXTZKCJ1TSKqb6pJc9WhnokouXE1nbUjuad92p
         yme3WVWHhZgQvf4kMOzC5gsouH010EVTurG4JEunb69JOLQlrRsezGuplE19ufSo9992
         s70A==
X-Gm-Message-State: AOJu0Yz67HpMGjsP8qJH3ncOPD4U8yQz1nX+MBV1DXfcGCLa9/DjoWti
	jYI7ytbN3WbDGciOcc4pXShkiPWdF4iSXponCNxLbSg956tgs1ccqi8SXoJDgG+BdXw=
X-Gm-Gg: AY/fxX4C29syZH/5Q0eG1mK7c9yMjgNxbFAU6OXbDzgf56UwgdgTCdtUD/TGEtJPGhj
	EO9gI4kf8j5oREKnJ7lefC3pXcKnwnYX2KNX9LPnwK/VmdkLZahscnZESybI/nIiYVRL+O4HE7x
	rnb1/kfHaw/6IiVSD0WGK7uaz3ExjC52BzQUICD3jy4OdPF/39qvQ7deqOthMZpN17GII1l6b9h
	TdYRU/XLN+8xgI1sDByXtvLtdEGPoLlGNTHw5FxY9J3u7+sfveqr5DP62wVFd9GlOYDrjChxnAb
	oJLkoq6reGSqu4KHnqI+0hRhnMnuT6Q7GLdt3wAoVGCiVOjRR8OO6MQq+BhyDr2Z4ktqL4uij9Z
	7WBIPKtAOKFzWjIZWm9dewLj2DlajhsyMPadgETeaUtJ0yCk7RuP1m2C/jzeqhNEu5PqHepw44E
	6K9TOOE8JKziO9FEaq7xHhHRWUr8LwvbLAU5BuoP0/G3fMpGCKAqzGqGpro7jloBvlN3BGrbQ1Q
	g==
X-Google-Smtp-Source: AGHT+IG2suPtS9YeJRMyW9D8ctlzwiCn5X2G6kDxBWY0YanYkFLS5yeyTT9cPjSXs/dlpZviYJowwA==
X-Received: by 2002:a17:906:9f91:b0:b72:ddfd:bca7 with SMTP id a640c23a62f3a-b8037058ba5mr295145366b.35.1766155297740;
        Fri, 19 Dec 2025 06:41:37 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037f4ef2bsm244187566b.68.2025.12.19.06.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:36 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 19/26] libmultipath: simplify sysfs_get_target_nodename()
Date: Fri, 19 Dec 2025 15:41:01 +0100
Message-ID: <20251219144108.237928-20-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
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


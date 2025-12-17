Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6404330FC01
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006500; cv=none; b=ku1dPaM+RpG6gwQRhu7Duvzo4gKqlu7bOzlxvKknDv606sjIw5jfbDdZeXAOIs5OplaYTidnlup9kRra0f949f5p2LQt88bDG4WGhscVInfzZ6qQhNNenXiX8LRlkbcx83KZmZgPPvcq8UfvWa7yHSv9UO4MPua5sWZ8uaMeOuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006500; c=relaxed/simple;
	bh=RNxGvikqY9FDO6Q7nydsNw0LR6vTeHFhenJNks91LlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukw5GKxmVTgWLEPTHtbc+UXLRpvV5R53/nDy+SPGnZ+VE4FAGVnbIaO4xs7L/tihZUXVcck6rytJMF/eLm0Mnw+SeECOE3DBuCc1/1JktN/Dnb0Z/ALV0Gjn4towAWmfCLtK4jestLZ+PxNrsT4vuCwazUZ6ggHZ/NSrXhwLieM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XL74ATcJ; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XL74ATcJ"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b79ea617f55so668974366b.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006497; x=1766611297; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EwIsJQqW5vbxX5kcJR9SM6kGA0v8UCSFVB6XV5sw5X8=;
        b=XL74ATcJeQQuvrXU6VTQ96860zKy3cT5X5DJqVQCccjbGe7W3HR3ojXycwd4cROTWr
         frBO5LH6zmYd5lxbp2Du3+EnXdW2JVbfqTZgO9hpluh1+8UrWjr8/w28J0xzGJQUfPR2
         6MdTCvZfPHv8EAPcNg4vGd1v9a33JKPaXW84e6eUYeVaCddgCOw4+KPupASThBVUWOKV
         DMn5yRTzooWgON/PFSP+8vHuw+414wZqPGOujwOauedbkovkgrD0W5XASibA31GhsiP+
         LMhT4GddEE+JScHmRL/52Jg2nFQi0lEHIl4Y6WyZS0s9w33qtrgQplQoAtnEjgaljJoB
         e5fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006497; x=1766611297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EwIsJQqW5vbxX5kcJR9SM6kGA0v8UCSFVB6XV5sw5X8=;
        b=Y8Ir6TAaV06Z4b/XviKrc3xsaMn/fQSOeOPEJx6PHeyPs/5gS/THWCHfh7daKhewIW
         H1bWs2by33RNM/Sz9WgAU27+6mF1pB61hTOL6VgXVwGKbZJLujXBFrQXubbBT1aghBwf
         7maOVlHpt3u4gLuujce+ZYD0BMx3ehu0JDeeBJTTfW10zGXZsXaIKaVUmwyNFG+T/a84
         18SuPoBoL90ZC8+67DqFdRIMiOnrLPbV9fjw5YNz4ic2kK6MKPw1ao6nacP5jZ2gjvsX
         jPG+75ykhxvf78d5iRUO/XbGIIMCDwUWTnh7K2kmgzrl7Z9EOQIoyiQ2cFrCLtO4fJ3s
         X9Qw==
X-Gm-Message-State: AOJu0YyLD7zBxrovveB4HbSBbI9sspDKoOE2R8EX1g2ymeqrh9OsAV0M
	povTAox0yA628MhhayHKGvEq8PRsUHIeLaY6MUGPioUEpJMTeL7wmvzEVsHQNXGZVg4=
X-Gm-Gg: AY/fxX6tLhdqauQemkksAT5HFmXDh/hSSJBjydF2mpa1QuaCxzwhikiP2JsHZ1OjRPX
	EodKDz3xb5l7YYi0gKaTsBNvfc7cAyJl1Jnky/nAa1Uv/+oz4zHnpIMrTTEpQmFBp+RQvLrea9M
	xn8L7HUpT0IKJogDWOk768LbP0AGcygmJMwFeEAndWFFjWEjxIKqWcTcFAbjOCrws7KBcCbrSlt
	5ZfPyMFI8hsL8Hp2+dAzVGih2XYt0KiI80pqo5pcO+xYi8GCY9sKmAeSqwhujCJhW6eVSQOucFh
	8QMmOQQPUVWiabT+Ocs7Un+zsFaK/fDu9j34wL2PFQpgcSf2F/rlD0Eqkij2biM3CpMdKxBNucT
	umdqZcYPLqPq3TFujmJb1Y5BC2EVoroNdfiUt22jknx7CG44CWfoJYCKSaRJPyMvX9XSlU6Wfky
	VjtDbPtreKXbMM3462vnnQVwjoG7/5DgH9E5NeRodtj/FLh/Nqo4G4WltRc7/8tpuyWdhuOdndJ
	7KnWa8zIVyo
X-Google-Smtp-Source: AGHT+IF/MlB8BdCHl0ldO8DNSajf9qdFhFKV6Dw2L/n/WirZ1lr8IeTXpcehYuwYySP//QrWlHp5/Q==
X-Received: by 2002:a17:907:3da4:b0:b73:7f1c:b8d8 with SMTP id a640c23a62f3a-b7d2324d9eemr2084174066b.0.1766006496700;
        Wed, 17 Dec 2025 13:21:36 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8022f95325sm32549066b.1.2025.12.17.13.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:36 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 14/21] libmultipath: simplify sysfs_get_target_nodename()
Date: Wed, 17 Dec 2025 22:21:06 +0100
Message-ID: <20251217212113.234959-15-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
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
---
 libmultipath/discovery.c | 32 ++++++++++++++++++--------------
 tests/test-lib.c         |  5 +++--
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 31db875..607fb3b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -325,19 +325,22 @@ static int
 sysfs_get_tgt_nodename(struct path *pp, char *node)
 {
 	const char *tgtname, *value;
-	struct udev_device *parent, *tgtdev;
+	struct udev_device *parent, *tgtdev, *device, *target;
 	int host, channel, tgtid = -1;
 
 	if (!pp->udev)
 		return 1;
-	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev,
+	device = udev_device_get_parent_with_subsystem_devtype(pp->udev,
 							 "scsi", "scsi_device");
-	if (!parent)
+	if (!device)
 		return 1;
+	target = udev_device_get_parent_with_subsystem_devtype(device, "scsi", "scsi_target");
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
 
@@ -362,7 +365,7 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 	}
 
 	/* Check for USB */
-	tgtdev = udev_device_get_parent(parent);
+	tgtdev = target;
 	while (tgtdev) {
 		value = udev_device_get_subsystem(tgtdev);
 		if (value && !strcmp(value, "usb")) {
@@ -375,11 +378,8 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
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
@@ -399,13 +399,15 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
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
@@ -429,12 +431,14 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 				udev_device_unref(tgtdev);
 				return 0;
 			}
-			else
+			else {
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


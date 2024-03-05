Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F09359B5C
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 12:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709640377; cv=none; b=iBX/c156PSXH2ESurBMjBHnZwUUCRbjzTAE/LTppAh7ecqZUX2qmhJHolrAzyvu6VP+3uqf1TWtrwUACbxhO7Vv0+PpM3jh8KC+AFdmQefz01u7HOxO4i6tZAwZ0hC2W9ltL4j2OHoAikDKBerrCsqqtiyr4Hcx9U/eg3mGfXuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709640377; c=relaxed/simple;
	bh=tm3q+MzReyLTmDBPPl+Dn11NG2yXpgoVHleJUmbGY+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EacyVnmCC69y+o7+DZbrOKHV4n8crsl1ve1abhci7P+zVrc60fN2mI9J0TbNQpt+X7t9cFTW56ygKYOQ9T0ZN4LikLtMT4i+xII3YJErhNODEb1vbRhihTuenuMaOOKrIIjuw3u7HR+sHfSRW/kiKCdlHK6tW5ppkqXxTq/1SFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A4mePkjo; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A4mePkjo"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-412e4426e32so14031245e9.2
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 04:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709640374; x=1710245174; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpjX0gmY7V/97ZsqYZd7OC8NLT0s7Eb85kt1BdbXCas=;
        b=A4mePkjo7gu0ONo/fKHkJ+EPJA9secQeJcA5I3twxqRIZ+FUuNxQfsw6dOACa9JaGo
         Nx3iQ2pTGLW33rV27+7x15nB8fokc3i/fmHLOfdjI/v1q+RZFGFM/WSdVYcPUEg321lJ
         uQHA/8vaZssaTRoQUHQd4qDAvxRxHfiKtA8nWy2/uJ3Wm8U+EhUSApnxnqA/emFOx4nF
         x/voMg5EDcVKAiBej0k0ElYmpbLSCkTY4R+n6mr5c+mqlR//+9u9NgU12XGFo6gwXhBN
         PN4KvWUQh42guhBcJbR8PoSEPHp2lnLdmP0+Sj7anv0rTgPCs6XnB/Ss0km5ywgwsFnM
         KzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709640374; x=1710245174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kpjX0gmY7V/97ZsqYZd7OC8NLT0s7Eb85kt1BdbXCas=;
        b=u32HEBAW279QFFYdOt32DV5kaRwcKErmg0Hrt2dFTxWRm7LXuVQr1p/g+biu+mPVbd
         E6lKL0lZ730H+NcJoKCLQphbihokizUkmnJrCVbJGLIMzEKBYpz3vvh9yw10BUZAGmN0
         kEIENpH1NZ4NOURpCc4gOOIrKx4/KA74me8Y45Er9YwXuCDWnH/5mdpGxZXzEq3DdA2z
         VFqCrpGoHrjZE6igjfwq0IG34IUOO1NeWmYWPoZA9ddjSM9m6mbgWb3XpMLIHTiAcreO
         2m0hpIcIXxicFXyjDDSa3Nv3j3Lf2xC5NUEkmgIEPZ6FHnvRxLid+xr37LVkkAU69UPF
         lDug==
X-Forwarded-Encrypted: i=1; AJvYcCU2BPF19+p5l8mm8qMfzhnMcejBr0GZMXt5mN4dSYw0aGiSHexwuBqgKA0zPCLbEt1VF1IweJGDekUfHJA5OJyN6SuVja2Tl2M=
X-Gm-Message-State: AOJu0YzbXazH2MbYVa/T9iK9SzRx5IYzUYBQz2v4Ye9huHjue4o8rCB9
	igyXGy+Bq8VHb8hk8E912RIbz6eaSWWr1FnGD/HD7jK8SvqMbq5EyUH2q7kCaOqvD+WPFKwtRVd
	M
X-Google-Smtp-Source: AGHT+IFVZCKdGhcYMT3KeOtoKbf+GtRGjjvUT1jyNbnUedU+LerbE234niK5/qEr4bO5hqaKW/aBbg==
X-Received: by 2002:a05:600c:1e23:b0:412:ebdb:d766 with SMTP id ay35-20020a05600c1e2300b00412ebdbd766mr1366326wmb.37.1709640374049;
        Tue, 05 Mar 2024 04:06:14 -0800 (PST)
Received: from localhost ([2001:470:6d:10f7:9114:d168:fb53:9a37])
        by smtp.gmail.com with UTF8SMTPSA id n19-20020a05600c501300b00412ed1eabc1sm1774156wmr.22.2024.03.05.04.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 04:06:13 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Peter Rajnoha <prajnoha@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 5/7] dm udev rules: don't export and save DM_SUSPENDED
Date: Tue,  5 Mar 2024 13:05:48 +0100
Message-ID: <20240305120550.11617-6-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240305120550.11617-1-mwilck@suse.com>
References: <20240305120550.11617-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DM_SUSPENDED is a device-mapper internal flag, which is not intended to be
used by other rules, and which is determined by 10-dm.rules from sysfs for
every uevent. Rename it to ".DM_SUSPENDED", so that it won't be saved in the
udev database.

Known consumers of DM_SUSPENDED are 66-kpartx.rules (from multipath-tools) and
99-systemd.rules (from systemd). These will have to be adapted.
11-dm-mpath.rules will be changed to use .DM_SUSPENDED.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 udev/10-dm.rules.in          | 14 ++++++++------
 udev/12-dm-permissions.rules |  2 +-
 udev/13-dm-disk.rules.in     |  4 ++--
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
index e5cc10f..fccf3bc 100644
--- a/udev/10-dm.rules.in
+++ b/udev/10-dm.rules.in
@@ -11,7 +11,6 @@
 # for use in later rules:
 #   DM_NAME - actual DM device's name
 #   DM_UUID - UUID set for DM device (blank if not specified)
-#   DM_SUSPENDED - suspended state of DM device (0 or 1)
 #   DM_UDEV_RULES_VSN - DM udev rules version
 #
 # These rules cover only basic device-mapper functionality in udev.
@@ -118,15 +117,18 @@ LABEL="dm_no_coldplug"
 # The "suspended" item was added even later (kernels >= 2.6.31),
 # so we also have to call dmsetup if the kernel version used
 # is in between these releases.
-TEST=="dm", ENV{DM_NAME}="$attr{dm/name}", ENV{DM_UUID}="$attr{dm/uuid}", ENV{DM_SUSPENDED}="$attr{dm/suspended}"
+TEST=="dm", ENV{DM_NAME}="$attr{dm/name}", ENV{DM_UUID}="$attr{dm/uuid}", ENV{.DM_SUSPENDED}="$attr{dm/suspended}"
 TEST!="dm", IMPORT{program}="(DM_EXEC)/dmsetup info -j %M -m %m -c --nameprefixes --noheadings --rows -o name,uuid,suspended"
-ENV{DM_SUSPENDED}!="?*", IMPORT{program}="(DM_EXEC)/dmsetup info -j %M -m %m -c --nameprefixes --noheadings --rows -o suspended"
 
+ENV{.DM_SUSPENDED}=="?*", GOTO="dm_suspended_set"
+TEST=="dm", IMPORT{program}="(DM_EXEC)/dmsetup info -j %M -m %m -c --nameprefixes --noheadings --rows -o suspended"
 # dmsetup tool provides suspended state information in textual
 # form with values "Suspended"/"Active". We translate it to
 # 0/1 respectively to be consistent with sysfs values.
-ENV{DM_SUSPENDED}=="Active", ENV{DM_SUSPENDED}="0"
-ENV{DM_SUSPENDED}=="Suspended", ENV{DM_SUSPENDED}="1"
+ENV{DM_SUSPENDED}=="Active", ENV{.DM_SUSPENDED}="0"
+ENV{DM_SUSPENDED}=="Suspended", ENV{.DM_SUSPENDED}="1"
+ENV{DM_SUSPENDED}=""
+LABEL="dm_suspended_set"
 
 # This variable provides a reliable way to check that device-mapper
 # rules were installed. It means that all needed variables are set
@@ -144,7 +146,7 @@ ENV{DM_UDEV_DISABLE_DM_RULES_FLAG}!="1", ENV{DM_NAME}=="?*", SYMLINK+="(DM_DIR)/
 # Avoid processing and scanning a DM device in the other (foreign)
 # rules if it is in suspended state. However, we still keep 'disk'
 # and 'DM subsystem' related rules enabled in this case.
-ENV{DM_SUSPENDED}=="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+ENV{.DM_SUSPENDED}=="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
 
 GOTO="dm_end"
 
diff --git a/udev/12-dm-permissions.rules b/udev/12-dm-permissions.rules
index a9d4c32..6a69d2f 100644
--- a/udev/12-dm-permissions.rules
+++ b/udev/12-dm-permissions.rules
@@ -14,7 +14,7 @@
 #   DM_UDEV_RULES_VSN - DM udev rules version
 #   DM_NAME - actual DM device's name
 #   DM_UUID - UUID set for DM device (blank if not specified)
-#   DM_SUSPENDED - suspended state of DM device (0 or 1)
+#   .DM_SUSPENDED - suspended state of DM device (0 or 1)
 #   DM_LV_NAME - logical volume name (not set if LVM device not present)
 #   DM_VG_NAME - volume group name (not set if LVM device not present)
 #   DM_LV_LAYER - logical volume layer (not set if LVM device not present)
diff --git a/udev/13-dm-disk.rules.in b/udev/13-dm-disk.rules.in
index eaad972..cb2ce2d 100644
--- a/udev/13-dm-disk.rules.in
+++ b/udev/13-dm-disk.rules.in
@@ -17,9 +17,9 @@ ENV{DM_UDEV_DISABLE_DISK_RULES_FLAG}=="1", GOTO="dm_end"
 SYMLINK+="disk/by-id/dm-name-$env{DM_NAME}"
 ENV{DM_UUID}=="?*", SYMLINK+="disk/by-id/dm-uuid-$env{DM_UUID}"
 
-ENV{DM_SUSPENDED}=="1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="dm_import"
+ENV{.DM_SUSPENDED}=="1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="dm_import"
 ENV{DM_NOSCAN}=="1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="dm_import"
-ENV{DM_SUSPENDED}=="1", GOTO="dm_end"
+ENV{.DM_SUSPENDED}=="1", GOTO="dm_end"
 ENV{DM_NOSCAN}=="1", GOTO="dm_watch"
 
 (BLKID_RULE)
-- 
2.43.2


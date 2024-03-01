Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2105EE8E
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 22:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709332852; cv=none; b=JDBJk4+EwMkT4bEGgqsnDDIT+FEzQ8D4OnbQmrACleU7flyD4D9okxL1cM4TfG32MWCK2V2UGrjFUpZMv1zcuZ1T6MeyAMqL0jZCzuBuvqJCXZiSshjnv0C2MB2ZculyVNnwSfSrq0rNhOjjeGJUjAdG235XZUw8P8gVpQDG500=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709332852; c=relaxed/simple;
	bh=+VjIySEqs5Z2bxfkZzP3umO4/YDX82hwzmKSRMSRzs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exS8Neva7rnDtX2ChotIQCuc4iQ/NAyBSGMJlSqIURcsyCy1m3Tjv9zSDXs54ddxIzrhtY4ofL6I1bYnKKW87OsBRODEEIsyhGuG2nb17CTWF/0lNdz9cK7emcs//pcoy7wKP6spvfKq+HrrUI1R8Sq64q+H8y51BxBx/B/jXV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UiLDXmP8; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UiLDXmP8"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a44cf608a39so15698466b.0
        for <dm-devel@lists.linux.dev>; Fri, 01 Mar 2024 14:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709332848; x=1709937648; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rp9bSioWnoo0g2kZ/DumjS1G4VPkVqOv4pb9vfLKQXE=;
        b=UiLDXmP8g687KweTjZEuKnQHYu/242N+h/tj58xNcznn0CfRt2/rP2LOqn8e5FzcLp
         yxR+BBwOui6wvbFEK/84fUwQ1iROqc6KDzHTQL/1M2Xo/Am3JFf5uzzGaXKfxW6f73sD
         cln5h56OyFamk6VUdjyv48Tl+cfDgyegnWJEhc6fQoSZNGXvhFdXNuSXxTyR2D+bqzMm
         X96f4/UcRJv1REoVOiCMCWId5iKVKbxFg8aSLDsnXkXM8nNQefpBapiEGnf1qPJIoKhU
         dKYXGZJ8GC9n19Jos2MguHtKiFJqbaRIc6U3Z7zcVRpVHckwSy5GV8nuMjHYb/ipd5BV
         Q6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709332848; x=1709937648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rp9bSioWnoo0g2kZ/DumjS1G4VPkVqOv4pb9vfLKQXE=;
        b=l80tF9gQMsSd4205pl7ZmP/d7crc/JjXgQQUrQkYI0hvBKacJOyL2ZdVi+ZO2iZPIg
         nW8KkVb/dttiWRnSeX+00pwlLLtMeyalhX2WsVKexLvMeV7c4MhSwOsSaZtDnXFOk+jS
         lztAFIYuJTehAQ6NzTbzuRFEX9Qz5SEDO4mkPAdlKFqlVrkqTtJic2fepJubRcLogCxD
         EDea4ab1Xu+JtC+uKukCdDP1XAqX4LOeNp8PEfAeGe8O1mwXrBYBDrqrVJXvDrhGmbKo
         SpWcOHpWipANA9Spthl1Fg9Sw5CcTVX3jJaeAu6WO3blAJPZbzoE1rdcPWM6Gi0NDvhh
         XrOg==
X-Forwarded-Encrypted: i=1; AJvYcCXJ+iZTV16ThJFlnRKVfQNTlAdApSvx5K1a4ujSuShpUcXSO2OW63Qv62DtviBZq8wBkBg+eNuOgOWUMUh932FkVReIj9pI16U=
X-Gm-Message-State: AOJu0Yw2bULcp9YfiQoeyKbyKyLdqkR09x+H38Sd4L9p+YKDbdUo7HOA
	0f7Ci4M7b6lOM+yhvCeT1IITkRLjBPq7oYp3J9JneGiDvOwqkiaq3Al6CzhZlJo=
X-Google-Smtp-Source: AGHT+IG6nXTMKfbMTuqrqpcqjnXoTJKydV7ClN57s4yN1iCeIFmuI7VD4dCRG0FR57FRY+EYJKxirw==
X-Received: by 2002:a17:906:a391:b0:a43:5dbc:4bfc with SMTP id k17-20020a170906a39100b00a435dbc4bfcmr2044772ejz.1.1709332848576;
        Fri, 01 Mar 2024 14:40:48 -0800 (PST)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id o7-20020a170906288700b00a42ed7421b8sm2121795ejd.93.2024.03.01.14.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 14:40:48 -0800 (PST)
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
Subject: [RFC PATCH 5/7] dm udev rules: don't export and save DM_SUSPENDED
Date: Fri,  1 Mar 2024 23:40:09 +0100
Message-ID: <20240301224011.11117-6-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240301224011.11117-1-mwilck@suse.com>
References: <20240301224011.11117-1-mwilck@suse.com>
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
 udev/10-dm.rules.in          | 15 +++++++++------
 udev/12-dm-permissions.rules |  2 +-
 udev/13-dm-disk.rules.in     |  4 ++--
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
index ef36209..d30f663 100644
--- a/udev/10-dm.rules.in
+++ b/udev/10-dm.rules.in
@@ -11,7 +11,7 @@
 # for use in later rules:
 #   DM_NAME - actual DM device's name
 #   DM_UUID - UUID set for DM device (blank if not specified)
-#   DM_SUSPENDED - suspended state of DM device (0 or 1)
+#   .DM_SUSPENDED - suspended state of DM device (0 or 1)
 #   DM_UDEV_RULES_VSN - DM udev rules version
 #
 # These rules cover only basic device-mapper functionality in udev.
@@ -114,15 +114,18 @@ LABEL="dm_no_coldplug"
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
@@ -140,7 +143,7 @@ ENV{DM_UDEV_DISABLE_DM_RULES_FLAG}!="1", ENV{DM_NAME}=="?*", SYMLINK+="(DM_DIR)/
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


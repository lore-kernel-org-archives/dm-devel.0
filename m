Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D298280BFC
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707497733; cv=none; b=UtaQKJXcIEM8HCwzFWRY0w78RoRU0X6raIFxAsaSDMjDKNz+V0HOhW3YEbVLS0ZnIqSM0HsuAa5a+5diAZVFvPLvgcTB5pE2/qmVdj+8UUq9LV2fZs5Yx277YR52lz4FVfzRXIdtf5nldW0J8xQ64ZXlww9Yjak/iKhK1FHYMxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707497733; c=relaxed/simple;
	bh=CY+9HPw0UhyXcKqB+f+6KZzsj9LHHgGkJFqDwVC3WJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U64dv+TfbA4erugZGwxfdFRo7RbI+245e1w/E5EzYCP1dEh4LugBifmzXSmQrXMuydWkPIfKr01voBxxJTAFIohVna1NzaCDR6iFZMqxLGjjXKtLvK8xwBmULkFVXbUdpl+66wMi1mZJpfh9RDGIwhYEWYBewc6VoWLjaUspjqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EKo/fTdQ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EKo/fTdQ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-410489e1a63so9800535e9.3
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 08:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707497728; x=1708102528; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZUP3Bt+QfIy4ehAUwbxboZetYw8fr65tINadv9Lme0=;
        b=EKo/fTdQXQTk7qFJN4HrvhiySkWYytrEmk07t69FhyEe90zjWX4V4YXnYxQg5ORoXL
         LrTXidbGoaDcf4+hEGsmMnpA/iqhNRrfE141zevA7vwkUNjqzN2tQ8KLb44f0Dnz/fUi
         uBM1NPRIw+gsR+g7QJVio4oIqpkG99FP5Pd+GMTk+45iPTI1SX4QOsD6zOU7eNoAZHRK
         ak4+GnKkUi+mNnlc5R/Yq02fr7V7EPy1Va+1ExeUze24ay1+KDIRDk3I20n+n47hJR65
         wNdFIv+EgTcG35D8Y3ItnZsv2QpDBb533xQYh0z/TxTUDfTNyRs2RuVUXkJGQ3fiYbMW
         OL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707497728; x=1708102528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nZUP3Bt+QfIy4ehAUwbxboZetYw8fr65tINadv9Lme0=;
        b=n+P2RGuOc/JmuG2WB4RKZHHu27HY9zypHaJKTmqjjijUZ/4ZxAebBCC2M2UBYkfQCi
         I929R3p6KF5GXVMX9NsubKEp+sbYpor144YtMyItU82ll8yQH9sKMG16GsyeA2LYPRVn
         MHC1tXr5+/eIbNZ4EAVeblq4Gtoy8cIzpDWAMowW/Di+Dh7th94mz6crRz5GmCrWDO89
         PFbsfxN8cV9Niyl4notw0EneCbbS9SW2qPaqyKk34FJZdj3tvA2FTdjAMY4U7juosO3J
         e3Z2G3JQd6Tm121AdUlUfiLaBHpxm4TX4Qx/Uh7yaELioaqM/+CSKDAgDtrfdwHozMgU
         YNEg==
X-Gm-Message-State: AOJu0YyLYL9s75akdIJ2Hbr0aRKRRVXoJgqg0XWrsyCXAsw7B7/sx6EP
	vLXY8DgL1DpAbzoxRfHqqRJI1bFBBeCtJXCiZIHKdxc2n2b3/SSm8R4ThtzM+UQ=
X-Google-Smtp-Source: AGHT+IF7z0bVzjket9p0pKC+QRj39zfS7OPCoys65M3StKtkMDl67BebHvawrZPf7oQNjs1gtfXH0Q==
X-Received: by 2002:a05:600c:3550:b0:40f:d43f:3df with SMTP id i16-20020a05600c355000b0040fd43f03dfmr1483577wmq.21.1707497727987;
        Fri, 09 Feb 2024 08:55:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXsKK6gTZRYi/up/dlof5WVgJt9RgJllwU4Pbn38Vaz+CWxqUMJsDIbjwNLBGcsYsNNLucewDEF2SS1syckzt0OUo23YBpAX/oPqYE2aPxqic20Y3g7iGgddtnLU5hb268H42AnLLqZxA9zTukUc5vxefzkr/h/SattD3zcJnyuWjsFKvSh7Y48
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id t3-20020a5d6903000000b0033b2799815csm2229666wru.86.2024.02.09.08.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 08:55:27 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH 3/6] 11-dm-mpath.rules: handle reloads during coldplug events
Date: Fri,  9 Feb 2024 17:55:10 +0100
Message-ID: <20240209165513.7661-4-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240209165513.7661-1-mwilck@suse.com>
References: <20240209165513.7661-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a map reload happens while udev is processing rules for a coldplug
event, DM_SUSPENDED may be set if the respective test in 10-dm.rules
happens while the device is suspened. This will cause the rules for all
higher block device layers to be skipped. Record this situation in an udev
property. The reload operation will trigger another "change" uevent later,
which would normally be treated as a reload, and be ignored without
rescanning the device. If a previous "coldplug while suspended" situation is
detected, perform a full device rescan instead.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 05c4294..3b2c3e1 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -11,8 +11,13 @@ ENV{DM_COOKIE}=="?*", GOTO="check_ready"
 ENV{DM_ACTION}=="PATH_*", GOTO="check_ready"
 
 ENV{DM_NOSCAN}!="?*", IMPORT{db}="DM_NOSCAN"
-GOTO="scan_import"
 
+# Coldplug event while device is suspended (e.g. during a reload)
+ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
+	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
+	ENV{DM_COLDPLUG_SUSPENDED}="1"
+
+GOTO="scan_import"
 LABEL="check_ready"
 
 ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
@@ -49,6 +54,16 @@ ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
 ENV{MPATH_DEVICE_READY}="1"
 
 LABEL="mpath_action"
+
+# A previous coldplug event occurred while the device was suspended.
+# Activation might have been partially skipped. Activate the device now,
+# i.e. disable the MPATH_UNCHANGED logic and set DM_ACTIVATION=1.
+IMPORT{db}="DM_COLDPLUG_SUSPENDED"
+ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{DM_SUSPENDED}!="1", \
+	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
+	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
+	GOTO="force_activation"
+
 # DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
 # Drop the DM_ACTIVATION flag here as mpath reloads tables if any of its
 # paths are lost/recovered. For any stack above the mpath device, this is not
@@ -63,6 +78,8 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
 	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
 
+LABEL="force_activation"
+
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
 # We'd like to avoid this, especially within udev processing.
@@ -105,6 +122,9 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 
 LABEL="import_end"
 
+# Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
+ENV{DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
+
 # Multipath maps should take precedence over their members.
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 
-- 
2.43.0


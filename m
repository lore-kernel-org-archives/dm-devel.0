Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B11338DEA
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 23:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707521275; cv=none; b=AzAHA5USlH5GML2RHIihQqQbJF+e8lCdU3507IjcThBtB+a8lGQImLFH4PsoO3U0V9upR4LgyfUz5wm5hNuvS6RYEG5Erz4j29x+wAkWyUo48UzHCL4voIGutXhYw3lPlnv2r0DMKn5/7pop04w+7vnvZuyhwE6OLbwfrVq9dB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707521275; c=relaxed/simple;
	bh=12ieYLFWUCyht5PrtcRMsrvFspnqj0Y1CNTA9Szvkhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8ZuFK2RUl8jMKi1uG73jdk9f8o2anguTmD7ws02qzBybPnKAnRQp2ChGDyIOzKyBz4ofZqnR/BGnKAvWKhN4iAMA5/ATjUXxefi5dB3O+LPjlFdh/tBqVQKTRkuKC2gwgtsSlMeFonqtyCuu/YK8snOytbbTFSoHqLYy0Kvwgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eY+b9Hjs; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eY+b9Hjs"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40fd72f7125so12232085e9.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 15:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707521272; x=1708126072; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/QHX5dUqpN9GgwHs0h60F5n/zRYHwJWjExBuAqawTw=;
        b=eY+b9Hjs1mzpSVmsrqOzaRHeMS03SUqSbMw1lmMgQO3PRc9TpcuzFuvsxqcxeah4zg
         JQbnI2aJxPTQdPajwpYyoqRpt1d8SfvPEG0yBTf3DS7cmm9LDCfmVLymfNBdm7vJYkf/
         zKH9c0eJz6HuqFaPQuMS6kIHls8lLkHlFmza7PmnvxGgiFgZhewgK0lNw5tpAorzIbHO
         KUL5L77M5R0YJNgz9MFVtiTIaC+zpJWWFU2mF0LqyK0jh6EXAajJWVx6W9VscWqWts0s
         D9Xx65REyd8XsjYdxXxDiHtz1BFd18WpiUVDfL9w43KxUSN5BKVkSk+iWyR7xziG8f44
         rdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707521272; x=1708126072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/QHX5dUqpN9GgwHs0h60F5n/zRYHwJWjExBuAqawTw=;
        b=gfvooVktVouRb6CWChbL4cYVZ0JW0oBY5h+gsWPXuteVPSKb358eLdgE2944tZnvse
         OUJ9S66kUsHKH4Kq8A9fCj/Wq8eP9Zwnv1vPMIChl0fxpBzS00MbPZViJhUNogIgDu0O
         NinvFIlX0kru3dl8tamirX+Cmrt00iZr86oLS6Ng6AIEnOexFDxoNy7mqnUvkmUYOVF8
         8QkTTctpyA17ry1HqZQYNF5ewolGOQ73dQnZndcnVPufGQoDmnj+PJb24mRyq5yZ4jiI
         u7KtEbrmXOxDrdCi52Mipt+80EpdeRAC4fCZZg0ITKtv2VUAoE1OBKCWao7xwnv65tir
         x56g==
X-Gm-Message-State: AOJu0YysLqEDUHlg7oz08LeKGtxRZLc9F9Tll/MwjPxDC0qKDPuLBo4K
	BudwC5mzHd3NsUmFE3W2ba1azZR9grNJjADK8sjt3z6wL6/ogzfw9T/VOQ/JgMA=
X-Google-Smtp-Source: AGHT+IFIqxrBwKZeiGnlGBs31iTEdbQpOgYsNqvQZfnCZLbOfYt1xfMohSW7luPTaoDzj/CSTdAr/A==
X-Received: by 2002:a5d:62c6:0:b0:33b:45e3:d88b with SMTP id o6-20020a5d62c6000000b0033b45e3d88bmr302910wrv.29.1707521271835;
        Fri, 09 Feb 2024 15:27:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXFhBLYHWt4lMU5QYY1kVzx2zZyXX4Iab1UoN4ZebYZn0HBzZhqXPJ4kg+U8NOpZ035NTq73dm8eEl0fNfSVOG9dtSsZXdeE62hFJLUWe9zjFeKDMW2o/fM7MMbqn2/oaCUavt/3OArkwOfxILHZex2KDWbKTIfOA7OIc1uaOAzzEXgYzQ8+zBR
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id ch16-20020a5d5d10000000b0033b58cbf3ebsm381292wrb.26.2024.02.09.15.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 15:27:51 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH v2 3/7] 11-dm-mpath.rules: handle reloads during coldplug events
Date: Sat, 10 Feb 2024 00:27:31 +0100
Message-ID: <20240209232735.9791-4-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240209232735.9791-1-mwilck@suse.com>
References: <20240209232735.9791-1-mwilck@suse.com>
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
 multipath/11-dm-mpath.rules.in | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index fd8d202..54d01a6 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -5,6 +5,11 @@ ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
 IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
 IMPORT{db}="MPATH_DEVICE_READY"
 
+# Coldplug event while device is suspended (e.g. during a reload)
+ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
+	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
+	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
+
 # If this uevent didn't come from dm, don't try to update the
 # device state
 ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
@@ -43,6 +48,16 @@ ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
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
@@ -57,6 +72,8 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
 	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
 
+LABEL="force_activation"
+
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
 # We'd like to avoid this, especially within udev processing.
@@ -99,6 +116,9 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 
 LABEL="import_end"
 
+# Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
+ENV{DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
+
 # Multipath maps should take precedence over their members.
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 
-- 
2.43.0


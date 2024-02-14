Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8045C13DBB1
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 20:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707943882; cv=none; b=avl11qxpt5aq+EgoBZwzQM7LzQgfIlOU7GTApnWorJEWeqERrKCgr4IsArIXY8DiRa9LmZyLWVZ5XG1Ty0l0nMAEfN/1PHkblRJTzQNjWUhdIt1C873yAx4CCULEAoAuGZqXKbOy1mqprrWFkvDOd7obKsAK9HJeTPtaMspNZDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707943882; c=relaxed/simple;
	bh=ivwkGmobRxlL6s9jVzf5flLAPPNnw+75G8gKKeWOpOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7F1+YL0DtvyIW6wsuo6xLwDCfAhGo6VpdTcxi7tKTELOE1LlVZP4RbKOtYT6HjNED4Up1wIGi1AmhbCezRP9EkDKTD+EENgAJugVd3p8BRgxuY+4h/fKKWqcKTN/M2pLLyFDjaphS5zowk4fnfrj+9BHqTgcJ6Wx85nDz6v6T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dL4sbu9B; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dL4sbu9B"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-33b66883de9so84589f8f.0
        for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 12:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707943879; x=1708548679; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sHC3w8hhA56btU+YHtKHI+hkqGd95pZ8G3TkiL54B+M=;
        b=dL4sbu9BYQFLm7BlCfqmHWfCKsaeRfvU89PdZUvmdHDXdvD7oUHokjlnzjefruV7QX
         W49wOLlkEHy0SQPT0T3pMH3eJc5r8rsmwiFVGy+ux+OZNuE27BUbAIPaM1IjUpT9ZkHr
         M+CEKqdLf5k8b5JU9U6iweC1ipRt0T+UA2ix+H+/5ajlsQWqLCrrE3N5VJDYjWvNBM2Z
         1ErSNbEDRCav7gcRWt03LX9MBu5L906m6dIlh94g29rWVqo3XceCVSKpHh5eJBIbQfCk
         zCVIWfjI6NyPFr7EsdbvafmidXePECbcXYwXELWaEjmKbFzxCeMeTjmLnYHvClMEwY+r
         iatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707943879; x=1708548679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sHC3w8hhA56btU+YHtKHI+hkqGd95pZ8G3TkiL54B+M=;
        b=cbNcMNZy+YR5Cs4i5dIvbqeJ6VNuCOvaFF7OykQSyK9WXg8RwEcas39y8dvikTIT95
         MonQWCqrmCrxWxKZcJt+Sb7uNvbNaudvK9o+B22bIfWgaMCgkqsxXMcF22S0Pu8fFXgJ
         kQ1KNzWTnHunQzGRhQ5QDGpOzOizs45pBTyKYbzNN9yWi1EGUGlqHnE+vpiaiS9GBpl0
         GNzMZBAUjeIgZv0RKl+zIdZxBj+Bnr9B32SbKxxmYNYZw+p0DVh9coXoJy+jZ0QAgHYK
         UTnka5NidLAj7FuabQhk41BErXNjSJ8/LwyHcRvo7A7dq7Dzkkk80UwctLzL1aGY8gYW
         85FQ==
X-Gm-Message-State: AOJu0Yykd6kfW14+OqbZb7TpLZgGw4RXmykFa6+asfMj7iOzL4IQRjpl
	aL01SAUfvVH/SzXhilROE6f2jNO71w/sE8+Q0X0cnIiCqHh1reyA29EbabyfgZQ=
X-Google-Smtp-Source: AGHT+IHjlKGp+FVUsXWuJrE/ktOSClTeHkCfkPDR1QqxjtwoVUUId8pnKitYPil7Gk6FP4I1LV8+vA==
X-Received: by 2002:a5d:6982:0:b0:33b:1bf2:18cf with SMTP id g2-20020a5d6982000000b0033b1bf218cfmr2665556wru.17.1707943878854;
        Wed, 14 Feb 2024 12:51:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUR2Klqfxe/x/+xP2ii3L0IpxSsA5sKoU/WfVwnmeHZzV4159G4GcO90wWpvPcDPvBoNxQn4hwYPhDvhvMLAYyRGJL6GeFFkdQJ1fMSH4bTjaPJsTbm0a5grjseJPpaKI0etBVCWmsAtJbNzubFNUc8vYqcG0XlmrSXzROorYcyEmO1hdJJWz5WpLlkKd/dIz9G74nMpGlKlcw=
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id v5-20020a5d59c5000000b0033b8305ffe2sm8947026wry.87.2024.02.14.12.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 12:51:18 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 3/6] 11-dm-mpath.rules: handle reloads during coldplug events
Date: Wed, 14 Feb 2024 21:51:04 +0100
Message-ID: <20240214205107.27409-4-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240214205107.27409-1-mwilck@suse.com>
References: <20240214205107.27409-1-mwilck@suse.com>
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
 multipath/11-dm-mpath.rules.in | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index fd8d202..30d6e78 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -5,9 +5,16 @@ ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
 IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
 IMPORT{db}="MPATH_DEVICE_READY"
 
+# Coldplug event while device is suspended (e.g. during a reload)
+ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
+	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
+	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
+
 # If this uevent didn't come from dm, don't try to update the
 # device state
-ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
+ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
+	IMPORT{db}="DM_NOSCAN", IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
+	GOTO="scan_import"
 
 ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
 
@@ -43,6 +50,16 @@ ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
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
@@ -57,6 +74,8 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
 	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
 
+LABEL="force_activation"
+
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
 # We'd like to avoid this, especially within udev processing.
@@ -99,6 +118,9 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 
 LABEL="import_end"
 
+# Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
+ENV{DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
+
 # Multipath maps should take precedence over their members.
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 
-- 
2.43.0


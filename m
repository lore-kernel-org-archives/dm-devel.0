Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988762574F
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314807; cv=none; b=uzbbrXGKz3+tMAOlhExJUZLbQ5AQ6d63CyEssP7DNxWDwkrPntXTPGLIY8QGdkp2ofyTG4tdurqgJBJbjf/V9SnJEFBdStU4Lbgliv7C39uS213PJ9e8VDF0TghL+bC6AgjJuRMv7x+XGWIOAXaGxKcbUtnOVjr9fn7G3Duvv+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314807; c=relaxed/simple;
	bh=flGXl0Hi1Dynu3BN85Y7QUnUZ1qRsutY95/9lyL9vXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpUYAbxPSEoNnnFVtAqK8uvIRuNIoZgdGHTkH+TrgMAo6ghy0jwpLdpI19D6uKPubtKv035rRn5gB0lpmbXfrbsznm/mQetLXXamjL7woqW48ua+gzrsaODuCoIXDtQ45AWOdpKMohWw+2dzi980wPFtChxEaQ/lFCesWuuoojY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DCnt6iGY; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DCnt6iGY"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a4644bde1d4so501715966b.3
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314804; x=1711919604; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kkz0tjKgFwEiuJl0nT2nRp1M84Hljg2Bir8M+QbWGXc=;
        b=DCnt6iGYZnPNgCHwhIXrkT353WNf4GjU0bLBQUyd6cecK8bHyiTohVR0ebOzTjHJnG
         C8QnPclzCLAKJ1mLJoEyrR+OYsP5tVaZ3qWeqQDUS/q9773R3LDn/6g6TrZEB+CXKwIF
         cXqMfeuUooZy4NO4fCqo5vTRA8UG3blhRKMFT+i9rz72T5ixmDHSRHMA2/4hjzgJ8QR3
         4mI9E67+Mm0rJRd89XROpnlcG568zL0+8uJ+DqyO0y0oeJZcl9O2UbkeDR8jo37Xwxom
         WorBcRkXio3rKjyMaWfi0g40clNoPJ2n7BD4pc8m07ZPJsL70w0zUY6tAr43Cz6Tnw4q
         qpHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314804; x=1711919604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkz0tjKgFwEiuJl0nT2nRp1M84Hljg2Bir8M+QbWGXc=;
        b=d3P05czWWdYgVTGXUpDVNCGOBPdT9TRItyRKkteO5x5nPpDnMsVBvDlkzhwt/9BS5J
         OUWw77R4rsTgnXyPvp9g7PFLJL3kQkxUiVxI3vTd7hIBNH42XXCW6cASDCOrZlsudiDF
         yKpjET4EyzDuv+uNqEq4ortziIwYObWfUYbyIKFJbB4Q9rjrhSZzCLEa/o4ecJtltzft
         CPNQ1QNxsurmi6NdiqHafRoQpMD+2FQE/dmaswDyNAc/xZqdVqYG0EuIfX3Cp1l5/jcM
         9N5m5K4/LFVmfGs3brXuG0fDNJ7Hx3sRDS3wv9da4okclN4QdTjbbFJJzcTohnB10oPy
         sUbw==
X-Gm-Message-State: AOJu0YyTZkyBoW2CuHThqjNeMFjW29nBHQcFO/yo9qzliNlaL+L77lV7
	b+DEGra0Nc9eh/5+fUm+Uf011ZfndEjsY5mMaIyUXlxKWszxiXdIao2eF5+G1zY=
X-Google-Smtp-Source: AGHT+IEevHrVl8l6CMtkxX0/htvNq+2IGVCP/WNZW21S8rIRU8OuGCeaFk2PLc1yOJCkobdaKfyeHw==
X-Received: by 2002:a17:906:383:b0:a46:ed72:6bb4 with SMTP id b3-20020a170906038300b00a46ed726bb4mr3432972eja.72.1711314803959;
        Sun, 24 Mar 2024 14:13:23 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id zh20-20020a170906881400b00a47531764fdsm918392ejb.65.2024.03.24.14.13.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:23 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/11] 11-dm-mpath.rules: make label names more intuitive
Date: Sun, 24 Mar 2024 22:13:00 +0100
Message-ID: <20240324211301.7200-11-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240324211301.7200-1-mwilck@suse.com>
References: <20240324211301.7200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The labels "dont_activate" and "scan_import" denote the same code line.
Remove "dont_activate". Improve two misleading label names.

Substitutions:
   dont_activate -> scan_import
   force_activation -> check_mpath_ready
   mpath_action -> check_mpath_unchanged

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 2285853..526cca8 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -30,7 +30,7 @@ LABEL="mpath_coldplug_end"
 # device below at mpath_is_ready, which is correct.
 ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
 	IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
-	GOTO="force_activation"
+	GOTO="check_mpath_ready"
 
 ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
 
@@ -38,13 +38,13 @@ ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
 # table with no active devices. If this happens, mark the
 # device not ready
 ENV{DM_SUBSYSTEM_UDEV_FLAG2}=="1", ENV{MPATH_DEVICE_READY}="0", \
-	GOTO="mpath_action"
+	GOTO="check_mpath_unchanged"
 
 # If the last path has failed mark the device not ready
 # Note that DM_NR_VALID_PATHS is only set for PATH_FAILED|PATH_REINSTATED
 # events.
 # This may not be reliable, as events aren't necessarily received in order.
-ENV{DM_NR_VALID_PATHS}=="0", ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
+ENV{DM_NR_VALID_PATHS}=="0", ENV{MPATH_DEVICE_READY}="0", GOTO="check_mpath_unchanged"
 
 # Don't run multipath -U during "coldplug" after switching root,
 # because paths are just being added to the udev db.
@@ -53,7 +53,8 @@ ACTION=="add", ENV{.MPATH_DEVICE_READY_OLD}=="1", GOTO="paths_ok"
 # Check the map state directly with multipath -U.
 # This doesn't attempt I/O on the device.
 PROGRAM=="@BINDIR@/multipath -U -v1 %k", GOTO="paths_ok"
-ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
+ENV{MPATH_DEVICE_READY}="0", GOTO="check_mpath_unchanged"
+
 LABEL="paths_ok"
 
 # For PATH_FAILED events, keep the existing value of MPATH_DEVICE_READY.
@@ -61,7 +62,7 @@ LABEL="paths_ok"
 # table reload where there are active paths. Mark the device ready.
 ENV{DM_ACTION}!="PATH_FAILED", ENV{MPATH_DEVICE_READY}="1"
 
-LABEL="mpath_action"
+LABEL="check_mpath_unchanged"
 
 # A previous coldplug event occurred while the device was suspended.
 # Activation might have been partially skipped. Activate the device now,
@@ -70,7 +71,7 @@ IMPORT{db}="DM_COLDPLUG_SUSPENDED"
 ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{.DM_SUSPENDED}!="1", \
 	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
 	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
-	GOTO="force_activation"
+	GOTO="check_mpath_ready"
 
 # DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
 # Drop the DM_ACTIVATION flag here as mpath reloads tables if any of its
@@ -86,7 +87,7 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
 	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
 
-LABEL="force_activation"
+LABEL="check_mpath_ready"
 
 ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
 # Do not initiate scanning if no path is available,
@@ -100,18 +101,17 @@ ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
 ENV{DM_UDEV_RULES_VSN}!="3",
 	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
 ENV{.DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
-GOTO="dont_activate"
+GOTO="scan_import"
 
 LABEL="mpath_is_ready"
 
 # If the device comes back online, set DM_ACTIVATION so that
 # upper layers do a rescan. If the device is currently suspended,
 # we have to postpone the activation until the next event.
-ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
-ENV{.DM_SUSPENDED}=="1", GOTO="dont_activate"
+ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="scan_import"
+ENV{.DM_SUSPENDED}=="1", GOTO="scan_import"
 
 ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
-LABEL="dont_activate"
 
 # The code to check multipath state ends here. We need to set
 # properties and symlinks regardless whether the map is usable or
-- 
2.43.2


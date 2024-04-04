Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A53F12F5A8
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252324; cv=none; b=pv0qNeXwXj97J4I/92+LChBk6cvK2Eaf5CeENEo54XTsRlVoNBVZjmc1wICLcUnehRBOF4vFhX3VVUE9Q2TUgTAWpEsaGfNrfOSM7s4nQwcWka70+EV2aWmMvCnKC+zWb7pJBFBBXhCF720MMx19f1fLH5yoXkRmdoQ7jS9HiZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252324; c=relaxed/simple;
	bh=3lTTk4USFLWrOix7FPQ52jfPlAqrpcTnnoE8JYozIfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkLV88fNzGkclV2G8IL+GLghPSbZ6703JRHYwdadyUpDTa6tEKu74gtIzR98Si54iYU6wjfSUfU3M9/jUfPyLsy8KyU3OGmeQFpEWbaUv7X1b6/la2j3aTeHhZw3tHDzfibsUCv91jrigk8Dgro4PR7RtejPhbBzb4iiDKjMfIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fptFnZzo; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fptFnZzo"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4155baa696eso9409495e9.2
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252321; x=1712857121; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/IJ4vtvUyB3ALEuo0y+SqiYBtgl9q14BdGlkYj1nB4=;
        b=fptFnZzoKQyWbJbXfB49q4f7FsJfmeT1DJVbJoipVmeuaaWybKZS37hzLGLD5f3ZaJ
         WfBECHbbqrA4RJbgReLk+zZIW7IyJvNZavcOxh00IBHvuwJsdkMD4HtzRh/d5fwGl29+
         tiKX40efA+/Yfuwoh7FE9PeUNzLXqH+Bri6mQvJGwiMwr0xeZyT5ToMKh39vYui/epKR
         GFQX+vsC/jRrqNZ4dpl/hLXlqRH0oAr3Y3afD3tV6NiWy6ESBw6a6WCKJrFhWLsu8UF+
         bMBelYzy2mep8LD7e39fDK+8XXntTjLElXToHSkADn2zIfEOTVO4rp3w/Sc/K4Q3fu4C
         xtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252321; x=1712857121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H/IJ4vtvUyB3ALEuo0y+SqiYBtgl9q14BdGlkYj1nB4=;
        b=AH9kC/HPga5x0uvn8QfqdH0+T26kU6/dWwNHOF7tqkXwaFA3vcvr0wZ6KuqqjDEtFr
         NytZk36XIbnIm8pRLCkW3Id+1KB7gMnIifHEUYfDOXqxzCybCjxdaAVZECe11lx6bR5u
         yr4DU62SsMztHmIARWz/KIYUuNtE0D66yZNso5dRPXI4rQoH5y94guUXaq5UNM8q+/u9
         GN38KlJtOT9wWaOkd0JExg+FHaZgbECoY/Nab8TwLZZYBD6kg1pK3BNT/sQuTjZE1CON
         WDd68C8Q424tGBuRShTqrtXgmTux+1xiRGZ/9mgnTjiOEKltwFmdHHj9vwSEC5cNbaPO
         ClCw==
X-Gm-Message-State: AOJu0YxGyzRUAo1DFvLjrD04MNxug0Er5csrUEHmUTii4sX4vY7SpKFJ
	XHzyDTPslgu+sLnkO1ZWhWlHM6o1ReRS/kj55EsoeIhZ5gs3/GDd6RGDLxsuDVI=
X-Google-Smtp-Source: AGHT+IFpIH/vfkFQzn/uYSrQU2sG+ebwA++iKfVMbHF/58YM7NdS32tpsizE5tIFEa72cBKZ8ZVR7Q==
X-Received: by 2002:a05:600c:1508:b0:414:1351:8662 with SMTP id b8-20020a05600c150800b0041413518662mr2566612wmg.12.1712252320959;
        Thu, 04 Apr 2024 10:38:40 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id m10-20020a05600c4f4a00b0041562a58b75sm3379342wmq.13.2024.04.04.10.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:40 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 10/11] 11-dm-mpath.rules: make label names more intuitive
Date: Thu,  4 Apr 2024 19:38:13 +0200
Message-ID: <20240404173814.3143-11-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240404173814.3143-1-mwilck@suse.com>
References: <20240404173814.3143-1-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/11-dm-mpath.rules.in | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 8653081..e1fbe98 100644
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
@@ -100,7 +101,7 @@ ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
 ENV{DM_UDEV_RULES_VSN}=="1|2", \
 	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
 ENV{.DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
-GOTO="dont_activate"
+GOTO="scan_import"
 
 LABEL="mpath_is_ready"
 
@@ -109,11 +110,10 @@ LABEL="mpath_is_ready"
 # we have to postpone the activation until the next event.
 # In this case, we have to set MPATH_DEVICE_READY=0; otherwise, the
 # MPATH_UNCHANGED logic will cause later rules to skipped in the next event.
-ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
-ENV{.DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
+ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="scan_import"
+ENV{.DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="scan_import"
 
 ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
-LABEL="dont_activate"
 
 # The code to check multipath state ends here. We need to set
 # properties and symlinks regardless whether the map is usable or
-- 
2.44.0


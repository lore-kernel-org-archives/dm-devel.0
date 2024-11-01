Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02601E32B4
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 21:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730498338; cv=none; b=UGgy+5XmWJu1bjKDDf0gde2hUqjYP4wnUMQJClTzVmlipBjck1ccyjxvGtz7k+raYt6amyoO31UQ2VeonKpX5m+VOcgdE3bfLbnXNk4mZxJ2Hk/dzrC/Aw3UiWzVRh3jlFHkxu7EOJnkKvYmSAYktHPOpZI+nSUk70tLs1T6cwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730498338; c=relaxed/simple;
	bh=NlxzbDUJ7h4re1FQBK6KOnNcEl2PIZ8Pe8AFnYwfBFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTQV1/Lujx9TG+mDBJsTVMxsSdXfl+ZSsmvlScB9X5XuCR3fSoVVtAzlTXiS8F7XOkloVqAkUcQ8/v+bPyRuwf2WeGM08jLVgAVHk8H0VxRP/7nIZtAA0ummFCuqHdvteKOWcoy/txLB2AwZSBw0pc95qGJNn3HqQuAP7Rdq5KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RvYukJCM; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RvYukJCM"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5cec9609303so289459a12.1
        for <dm-devel@lists.linux.dev>; Fri, 01 Nov 2024 14:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730498335; x=1731103135; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFda3Nv7nkjalH7wJLPTGB48A68kdy2UdMn+L3x+ICY=;
        b=RvYukJCM5k/+gFnMLBnPk9jeq2h/4gL3vjNjUmNEYNFLdICqnvZwnBGEjdLNEV/VRy
         FYgKpCG0Qe6VRIV1oy9DqdC5hRaUrJqDfQa1zrcvmxc+vjbOG9/zBX3GSNWqHz09XwEO
         ThsoNzUhIfZayYKZ6LL6otv/3VRwL8jaZfc/rLFj1F8HZMplxCX+tACe1jxm8Hi4VJrf
         Q7BnYC62Ga5uJWX4FkpBMul1HiBGLpMAvg/k68U4E6OFpdS/n1A4rQfOz28qrQGmIsca
         cx+dQM1PDxPuAguwOIEhPkAI3IHvev8icSAlbEFWQTh1Amkk03Ee8ukW6UAdDoQA+By5
         SemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730498335; x=1731103135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MFda3Nv7nkjalH7wJLPTGB48A68kdy2UdMn+L3x+ICY=;
        b=f7IqO0kyBBZvmXu7oDIctLmcVSH7dYTlfww70rNM3tEC8U8YhMO12ETYmvMXfxAM4j
         uJSUasBLYlRIivWAbOUQHzwwtBXb0Vf+QLlR8q3tje9EIYY7ibz3ZQO7S3HkS6sDNYo8
         RZyCnHwHYtw8xdXDqDpFPOGOHFP9GNcP8jKB+mAVLWps7PhIGy9F7INgNgPcCHrqs+R9
         0b/HeW163U/djpWXcjRf49ula6aFJ9LNhXYpAk3+hiU5Xg9dHqaX2SdzAGaLX28Wi9vi
         pQwNskzz47/7iq8OXho0VS5W2ns3ab01NsNgPMZgJeXEffC+lnO706TOBi8m0K1QdF/h
         mT5w==
X-Forwarded-Encrypted: i=1; AJvYcCVX75IFwkTIU7nD1xwn3Xg3DiHkR8+mPwCJDfdWAAuWoK2IRgjWdf2ukeNItmgDEjlkL3Hp9V0TOA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxD6gZGduKsyMmjAXE1Tj9vq6PgfVHEqDzunNoIugnCh85UHnfB
	B8xMubaXploI42oFIDSMgv0Njj3Nwog292tK/kpcDR19UIzN63Vbme6JFJ24Rvk=
X-Google-Smtp-Source: AGHT+IGOdXCzDyo4I8ygZ3JfPMJ9tV74ocKIdW3h/6aNGVDZTev1/LbCFIQAG29bKvIng0HSJIor/w==
X-Received: by 2002:a05:6402:13c9:b0:5c9:6eea:8e06 with SMTP id 4fb4d7f45d1cf-5cbbf947c0cmr20313727a12.24.1730498334683;
        Fri, 01 Nov 2024 14:58:54 -0700 (PDT)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5ceac78cebbsm1920833a12.51.2024.11.01.14.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 14:58:54 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 3/3] 11-dm-mpath.rules.in: clarify DM_ACTIVATION logic
Date: Fri,  1 Nov 2024 22:58:40 +0100
Message-ID: <20241101215840.1077082-4-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241101215840.1077082-1-mwilck@suse.com>
References: <20241101215840.1077082-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Our code is always setting MPATH_UNCHANGED and DM_ACTIVATION in
pairs. While DM_ACTIVATION is a global DM property, MPATH_UNCHANGED
is owned by us. Just set MPATH_UNCHANGED, and adapt DM_ACTIVATION
when necessary just in one place.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 20f8c6a..a2655cb 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -74,25 +74,25 @@ LABEL="check_mpath_unchanged"
 
 # A previous coldplug event occurred while the device was suspended.
 # Activation might have been partially skipped. Activate the device now,
-# i.e. disable the MPATH_UNCHANGED logic and set DM_ACTIVATION=1.
+# i.e. disable the MPATH_UNCHANGED logic.
 ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{.DM_SUSPENDED}!="1", \
-	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
+	ENV{MPATH_UNCHANGED}="0", \
 	PROGRAM="@SYSDIR_BIN@/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
 	GOTO="check_mpath_ready"
 
 # DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
-# Drop the DM_ACTIVATION flag here as mpath reloads tables if any of its
+# Set the MPATH_UNCHANGED flag here as mpath reloads tables if any of its
 # paths are lost/recovered. For any stack above the mpath device, this is not
 # something that should be reacted upon since it would be useless extra work.
 # It's exactly mpath's job to provide *seamless* device access to any of the
 # paths that are available underneath.
 ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
-	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
+	ENV{MPATH_UNCHANGED}="1"
 
-# For path failed or reinstated events, unset DM_ACTIVATION.
+# For path failed or reinstated events, set MPATH_UNCHANGED.
 # This is similar to the DM_SUBSYSTEM_UDEV_FLAG0 case above.
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
-	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
+	ENV{MPATH_UNCHANGED}="1"
 
 LABEL="check_mpath_ready"
 
@@ -112,11 +112,10 @@ GOTO="scan_import"
 
 LABEL="mpath_is_ready"
 
-# If the device comes back online, set DM_ACTIVATION so that
+# If the device comes back online, clear MPATH_UNCHANGED so that
 # upper layers will do a rescan. Don't do this if .MPATH_DEVICE_READY_OLD
 # is just empty (see comment above the DM_COOKIE test above).
-ENV{.MPATH_DEVICE_READY_OLD}=="0", \
-	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
+ENV{.MPATH_DEVICE_READY_OLD}=="0", ENV{MPATH_UNCHANGED}="0"
 
 # The code to check multipath state ends here. We need to set
 # properties and symlinks regardless whether the map is usable or
@@ -146,6 +145,10 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 
 LABEL="import_end"
 
+# If MPATH_UNCHANGED is set, adapt DM_ACTIVATION.
+ENV{MPATH_UNCHANGED}=="0", ENV{DM_ACTIVATION}="1"
+ENV{MPATH_UNCHANGED}=="1", ENV{DM_ACTIVATION}="0"
+
 # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
 ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
 
-- 
2.47.0


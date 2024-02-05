Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE824219
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 12:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137215; cv=none; b=nGaEIhRAG6TL/SKQi8vLlDPhr+OPGpsOASdPdZD9wA5MCPjEjdJvd6I7hfk4sJO/Wfg6IwAY2P6Bm6Dln3MSacDW7nBUTJVS3suGmCy53+P1uKNaAVMs5MTy8ZRCV9QtB27trBi5TIwGBU39LEY2rws/SBllaL4/Sm5nDDD1qgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137215; c=relaxed/simple;
	bh=n9cQHMwP98CELEkzfrS4l22uQujoD+eSCtIeqpfnQJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXmN3+Qkh8lDL0g3e5i89daXk4E4uPZYltwW54csCo3Lh+icd7Z+n+51uhhSf2yvtYy+icva8HPNzsBJchlZEP3mboll9Wzg3LKNFO82jKOOGmRGHad3TTtqePXOrYydHZHMc42RaNED3e8HKgEe2T5ld8Q9HrayU+ODrgVTJzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HRQ0eq24; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HRQ0eq24"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40fdf17fa89so220975e9.0
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 04:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707137211; x=1707742011; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ju2lOeFQEMu7la/gUeUclp0xy0IYVncQ6eP171nU1lo=;
        b=HRQ0eq24vAy0d5KHcnIiU+j4AhZ21fKvw4nrLKvkoVelgZ4b2NDkkJvwZ/7rg0tOg1
         mzG4BDIMTw+AV0ngN/xpcLWIgu2jV9rRKUXnqAfXix5qJYYAWUN8qg0I9OujCHmpRqVx
         chVYIS/M1RvcQhC9xS1r/sqYSzFCVu5urAXrjtSZaPdSyazuuiVlXGSMrsskTDrwZfkP
         cNUET/Tex2aC7T63Zw4HdFpxtp4IyiQqec6vO9Ikni3kfFYY6tqrOmdT0p/3NmhDMfl/
         ChNYGugfiGU4wFvcT13BYFLeYauImIs21rpTxMyHsGtfPFPEoU+ot92O7gs48iF4dzRt
         qleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707137211; x=1707742011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ju2lOeFQEMu7la/gUeUclp0xy0IYVncQ6eP171nU1lo=;
        b=ahdPPb0G9U8GZadoiF/oVpGQig4S7aR9O+gat3VsEw8kidfU2QqciCGJx36E7FmzP2
         lfKKs5eSFSrOMLhEd0czU6p98JP0rlLuVz/7MmVCBllvS8M5OPT4oILvHyMaRryiwqzt
         dQ51Xkadh7Q+2zEymA6NWRvikG+5gA/ZYLGkwnlcYwr/kYmFo4pWWqb9LytCDu7PKqcR
         +wvg3GFSyvAfXvtVIKquWj7A/2JNWUQpBRUPU1+KN5LIUL7IN2tOzLqnvEsBZc7Usv1C
         przX+I89givjdkJN/put5z0Bv7fuGMT24jyutDD3hk4aRgw7Y/grtoRHun67E8q9lH4Q
         MHUg==
X-Gm-Message-State: AOJu0YwbhuYJgo+vTKKmVetLw/U6O0As6JS5Breoaog1dENA/0WT/v13
	hQSwdVu26vYp5vO9brCEVY+rj1VFgeRw2pV5UsAnTyNI4mCKdj4M8U5G4e52FVE=
X-Google-Smtp-Source: AGHT+IHRPSrgdn6ib08qTTnhbVNC3GNZO7eOIstVvJNek1uu0R9MMcQiFHpxvq4bnN0o0QoNstT8bw==
X-Received: by 2002:a05:600c:3b14:b0:40e:aca0:7b0a with SMTP id m20-20020a05600c3b1400b0040eaca07b0amr4402282wms.10.1707137211648;
        Mon, 05 Feb 2024 04:46:51 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXH5scUH3bj0D+YUAqjGplTvyv90SChT9bgMDN9lLslkKR2t7EMFXGLIY4EVJUixvPLpPc0J0R7VmT20FuMWleSCK8mriNYli8r+yanDuQiflnS1o8xBDcEEnKXDFet6q3z3147GMGtCv/zCkN3Ix+AbDDAStCfsH1yf+3DxPnxb8Jc9f4RJKeG
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id m9-20020a7bcb89000000b0040e813f1f31sm8426652wmi.25.2024.02.05.04.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 04:46:51 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH 5/6] multipath: udev rules: use configured $(bindir) in udev rules
Date: Mon,  5 Feb 2024 13:46:37 +0100
Message-ID: <20240205124638.17877-6-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240205124638.17877-1-mwilck@suse.com>
References: <20240205124638.17877-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows us to remove the lumsy MPATH_SBIN_PATH property and
related tests.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore                                            | 1 +
 Makefile.inc                                          | 2 +-
 multipath/{11-dm-mpath.rules => 11-dm-mpath.rules.in} | 5 +----
 multipath/Makefile                                    | 2 +-
 multipath/multipath.rules.in                          | 5 +----
 5 files changed, 5 insertions(+), 10 deletions(-)
 rename multipath/{11-dm-mpath.rules => 11-dm-mpath.rules.in} (97%)

diff --git a/.gitignore b/.gitignore
index 6890e4a..049ffe8 100644
--- a/.gitignore
+++ b/.gitignore
@@ -16,6 +16,7 @@ multipath/multipath
 multipath/multipath.8
 multipath/multipath.conf.5
 multipath/multipath.rules
+multipath/11-dm-mpath.rules
 multipath/tmpfiles.conf
 multipathd/multipathd
 multipathd/multipathd.8
diff --git a/Makefile.inc b/Makefile.inc
index 06bdd5e..3bcc7c2 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -148,4 +148,4 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
 
 %:	%.in
 	@echo creating $@
-	$(Q)sed 's:@CONFIGFILE@:'$(configfile)':g;s:@CONFIGDIR@:'$(configdir)':g;s:@STATE_DIR@:'$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g' $< >$@
+	$(Q)sed 's:@CONFIGFILE@:'$(configfile)':g;s:@CONFIGDIR@:'$(configdir)':g;s:@STATE_DIR@:'$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g;s:@BINDIR@:'$(bindir)':g' $< >$@
diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules.in
similarity index 97%
rename from multipath/11-dm-mpath.rules
rename to multipath/11-dm-mpath.rules.in
index 2706809..38a0132 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules.in
@@ -35,16 +35,13 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG2}=="1", ENV{MPATH_DEVICE_READY}="0", \
 # This may not be reliable, as events aren't necessarily received in order.
 ENV{DM_NR_VALID_PATHS}=="0", ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
 
-ENV{MPATH_SBIN_PATH}="/sbin"
-TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
-
 # Don't run multipath -U during "coldplug" after switching root,
 # because paths are just being added to the udev db.
 ACTION=="add", ENV{.MPATH_DEVICE_READY_OLD}=="1", GOTO="paths_ok"
 
 # Check the map state directly with multipath -U.
 # This doesn't attempt I/O on the device.
-PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -U -v1 %k", GOTO="paths_ok"
+PROGRAM=="@BINDIR@/multipath -U -v1 %k", GOTO="paths_ok"
 ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
 LABEL="paths_ok"
 
diff --git a/multipath/Makefile b/multipath/Makefile
index 0efb9b2..f8c1f5e 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -5,7 +5,7 @@ include ../Makefile.inc
 
 EXEC      := multipath
 MANPAGES  := multipath.8 multipath.conf.5
-GENERATED := $(MANPAGES) multipath.rules tmpfiles.conf
+GENERATED := $(MANPAGES) multipath.rules tmpfiles.conf 11-dm-mpath.rules
 
 CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathcmddir)
 CFLAGS += $(BIN_CFLAGS)
diff --git a/multipath/multipath.rules.in b/multipath/multipath.rules.in
index 03fa4d7..780bf85 100644
--- a/multipath/multipath.rules.in
+++ b/multipath/multipath.rules.in
@@ -18,9 +18,6 @@ GOTO="end_mpath"
 
 LABEL="test_dev"
 
-ENV{MPATH_SBIN_PATH}="/sbin"
-TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
-
 # FIND_MULTIPATHS_WAIT_UNTIL is the timeout (in seconds after the
 # epoch).
 IMPORT{db}="FIND_MULTIPATHS_WAIT_UNTIL"
@@ -31,7 +28,7 @@ IMPORT{db}="DM_MULTIPATH_DEVICE_PATH"
 
 # multipath -u sets DM_MULTIPATH_DEVICE_PATH and,
 # if "find_multipaths smart", also FIND_MULTIPATHS_WAIT_UNTIL.
-IMPORT{program}=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
+IMPORT{program}=="@BINDIR@/multipath -u %k", \
 	ENV{.MPATH_CHECK_PASSED}="1"
 
 # case 1: this is definitely multipath
-- 
2.43.0


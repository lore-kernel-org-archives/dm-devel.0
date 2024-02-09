Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C9938FA1
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 23:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707521276; cv=none; b=S9iMArt+vw7WCNEQT6K/hWWeWvtGT8FhVliu3HgJNC9uxa6uoT51gKBaGC70MyyF8iw+gkz9bXU2Ic2Us5pSdi0ma/wu4aUocP83m2oWwxHOZdyt1dKdvPKsNQmaZt604H2Mh2Qzn4wlAMBVJAEy5IFVW16r4xZIiKZVNzPqmUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707521276; c=relaxed/simple;
	bh=xoZpVfaaiOlvD1NBovtI8+CLaAQXIm45lEJfsGop2TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icHSZUM1xTXNWnvGSdPbMIEbPV//iJa2cMnE6dn4Hf9tO1L0k+Q1uezofdwG5zct7rkz1FQlOnZzCLyLxtVLPDcJH9YDcS99SvzcgvSQeu9tA9NuHvBCGv3HQPjKGT3AgvehIIF0vuHRoORaRq2IYtBc93OEX9hEPN9Jjjq3jD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fh91HjJV; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fh91HjJV"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-33b18099411so714953f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 15:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707521273; x=1708126073; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6nq1wxtillK0bXwrYEvJV5T8wVUWQuCdStruGZoseA=;
        b=fh91HjJVHJWVlo0Rto0gxnIaYNoAp6U6vaNIWx/M0Fv/L82QM1eUyNW9luJ5tdJ18E
         rZhaiDCE+CuufUDe9EnQaBrAWhI3D7EMB7T62+e4yr824gDZ7wGTeWBGEDo1acElLqzZ
         OajNiq0grRe5eXdCkqw4lLbK3r13vDrFmLjiMKvyAoqF0vdpf3o6F8pl1jaJIFu1+v9m
         jl5uYmgLKH+aYJUclmieDhs+t5F3W/JGhNrUz1nnws6235RUSJydhvaLqiHjs9q8ny9s
         n5EKkukhhEJPVzWKOoThQ/56xZlZBStXEOBfE3iu20G7eM3hwc7e0cGSOktSFMYLXaFM
         z3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707521273; x=1708126073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6nq1wxtillK0bXwrYEvJV5T8wVUWQuCdStruGZoseA=;
        b=D/L5t3k65zBTrQSnX50AWpssGbZArM8ZRPIK2IilWdjUh+5ZwRzjrXQxHfucGvU2gR
         F55qsvIfAbt6Fm2F9eYAOJk0OFIEFGFwv72WKHQ8oDnCTsHO+w6nXj3340OcEFjN9pRQ
         qEAhrRotupW2bfpR67cx6bbZ/aj9oNGidG+uqKfNmBpcvAmc11QmqH1YW2vKRglfwVyh
         96v0MUgjXh8SfMwHbtLc5fbchjBKtY04r1bfDaXxnSHuuixlBUMCDgzdI9xB4OjTjclo
         BStiHZ4MvSsO8QmQ8rses22SYPILxnapsibdAfr6HL+uyQpfbYo2ufWQodmlHMss1mVl
         MvbA==
X-Gm-Message-State: AOJu0Yw5WkA/Yc6L5zyar6MROAnPQnz+L+b7BaXyLKGD8bEmq4i/uybo
	tEclib8+G2dZdm90gOS6/NLaUX3TTRNSzGFBMBtR7Q8e6y2RHKD7/KcWJFPmAt1RehlpLB3ARYS
	n
X-Google-Smtp-Source: AGHT+IHQehVpbnRbdGarzbc6PMpCdXcFUA1qL+AjPdlr8JI3yK3RsxRe3TVeRBhZpJ1YzfnWsSvKDQ==
X-Received: by 2002:adf:fd10:0:b0:33b:4f10:f2b8 with SMTP id e16-20020adffd10000000b0033b4f10f2b8mr270814wrr.43.1707521272879;
        Fri, 09 Feb 2024 15:27:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXx2Rff6D3PZux+R12wPriEs0Dop8/w7PtYlg9yQhM9mhTHMHWjQYUDGReImhuZ40Lpjc+zAkeGOaQLtGuOQCrqq2WCS+tNCp96W7gSQIXokWOPF18apw/y/vSU7KxVVSK4Ew6vPJJAasEI4FQr1WUfJo8vOFjFEFjNIpPB17819vd6LhrYWhro
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id n16-20020a5d67d0000000b0033af26545c8sm378019wrw.50.2024.02.09.15.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 15:27:52 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH v2 4/7] 11-dm-mpath.rules: don't save DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD
Date: Sat, 10 Feb 2024 00:27:32 +0100
Message-ID: <20240209232735.9791-5-mwilck@suse.com>
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

The current rules overwrite DM_UDEV_DISABLE_OTHER_RULES_FLAG and save its
value in DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD if MPATH_DEVICE_READY changes
from 1 to 0, and restore DM_UDEV_DISABLE_OTHER_RULES_FLAG from
DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD when MPATH_DEVICE_READY changes back from
0 to 1.

This is wrong for multiple reasons. For "spurious" events, 10-dm.rules will
read DM_UDEV_DISABLE_OTHER_RULES_FLAG from the udev db and obtain the value
saved by 11-dm-mpath.rules rather than it's own saved value, which confuses
the logic in 10-dm.rules. 10-dm.rules sets the flag if either DISK_RO==1 or
DM_SUSPENDED==1, and never clears it (it can only be cleared by a new genuine
libdm event that doesn't have DM_UDEV_DISABLE_OTHER_RULES_FLAG set, while the
device is not suspended). lvm commands may set the flag, too, but AFAICS this
is only done for certain types of logical volumes, not for multipath maps.

If a previously suspended device is resumed, DM_UDEV_DISABLE_OTHER_RULES_FLAG
would be cleared, and it would be wrong for 11-dm-mpath.rules to overwrite it
with a previuosly saved value. Likewise, if a uevent arrives for a suspended
map, and MPATH_DEVICE_READY happens to switch from 0 to 1, it would be wrong
to clear DM_UDEV_DISABLE_OTHER_RULES_FLAG by setting it to a previously saved
value.

We need to set DM_UDEV_DISABLE_OTHER_RULES_FLAG=1 to prevent follow-up rules
from attempting I/O on the device. But don't try to save and restore
DM_UDEV_DISABLE_OTHER_RULES_FLAG between uevents. Rather, reset
DM_UDEV_DISABLE_OTHER_RULES_FLAG to the value we got from 10-dm.rules in a
late rule. I chose "z0" for this rule's prefix to make sure it needs to run
very late (after 99-systemd.rules, for example) while still allowing some
reasonable space after it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in   | 19 +++++++++----------
 multipath/Makefile               |  2 ++
 multipath/z0-dm-mpath-late.rules |  4 ++++
 3 files changed, 15 insertions(+), 10 deletions(-)
 create mode 100644 multipath/z0-dm-mpath-late.rules

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 54d01a6..e31107b 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -2,7 +2,6 @@ ACTION!="add|change", GOTO="mpath_end"
 ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="mpath_end"
 ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
 
-IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
 IMPORT{db}="MPATH_DEVICE_READY"
 
 # Coldplug event while device is suspended (e.g. during a reload)
@@ -79,16 +78,16 @@ LABEL="force_activation"
 # We'd like to avoid this, especially within udev processing.
 ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
 
-# Also skip all foreign rules if no path is available.
-# Remember the original value of DM_DISABLE_OTHER_RULES_FLAG
-# and restore it back once we have at least one path available.
-ENV{MPATH_DEVICE_READY}=="0", ENV{.MPATH_DEVICE_READY_OLD}=="1", \
-	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=="", \
-	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
-ENV{MPATH_DEVICE_READY}=="0", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+# Skip all foreign rules if no path is available.
+# Use DM_UDEV_DISABLE_OTHER_RULES_FLAG to communicate this
+# to upper layers. The original value will be restored in a late
+# udev rule.
+ENV{MPATH_DEVICE_READY}=="0", \
+	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}", \
+	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+# If the device comes back online, set DM_ACTIVATION so that
+# upper layers do a rescan.
 ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0", \
-	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}", \
-	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="", \
 	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
 
 # The code to check multipath state ends here. We need to set
diff --git a/multipath/Makefile b/multipath/Makefile
index f8c1f5e..2f2569c 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -26,6 +26,7 @@ install:
 	$(Q)$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
+	$(Q)$(INSTALL_PROGRAM) -m 644 z0-dm-mpath-late.rules $(DESTDIR)$(udevrulesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 multipath.rules $(DESTDIR)$(udevrulesdir)/56-multipath.rules
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(tmpfilesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 tmpfiles.conf $(DESTDIR)$(tmpfilesdir)/multipath.conf
@@ -46,6 +47,7 @@ endif
 uninstall:
 	$(Q)$(RM) $(DESTDIR)$(bindir)/$(EXEC)
 	$(Q)$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
+	$(Q)$(RM) $(DESTDIR)$(udevrulesdir)/z0-dm-mpath-late.rules
 	$(Q)$(RM) $(DESTDIR)$(modulesloaddir)/multipath.conf
 	$(Q)$(RM) $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
 	$(Q)$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
diff --git a/multipath/z0-dm-mpath-late.rules b/multipath/z0-dm-mpath-late.rules
new file mode 100644
index 0000000..8574b1a
--- /dev/null
+++ b/multipath/z0-dm-mpath-late.rules
@@ -0,0 +1,4 @@
+# If DM_UDEV_DISABLE_OTHER_RULES_FLAG was modified in 11-dm-mpath.rules,
+# restore it here, lest a temporary value be saved in the udev db
+ACTION=="add|change", ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}=="?*", \
+    ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}"
-- 
2.43.0


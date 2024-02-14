Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9677813EFF9
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 20:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707943883; cv=none; b=iGaeBgHKA69jYa/lmNrX3rRZdD7/miq0ILuLhJoqkxWR13dyR1yeANC1YtsK6/h0Piy/Q4N4zOntosZDKYp5rga58jUuuCy49W0SQyVYu/U+eK2aQ60PADzFMmZUbQvOIRRXvYdmdD121FO36pOU9ZXqjRVS1fwuKY5R6lw6zEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707943883; c=relaxed/simple;
	bh=jgKEgm4ZraICoCHymTIQvfbSA2WbNIfHL33U9oFEpvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKSRPFOu1taZhAlehhT8PPNMcTfY56rzdkMoh4m798NPuqtbdODMgdAiOvQw4wyUVW1oSxlF2FKvyGJUiRqOC19RpXfD7bjpSeeHh0f6IZff5l6+X2BbmMZr9RqeqpUrh5KTOo85I9EMtVELYNxVplrlPeERDhEZ/ul4KN8WXPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OwVgAY30; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OwVgAY30"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-33cda3dfa06so76120f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 12:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707943880; x=1708548680; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ECRVgGd7IM3p72ApRmUJhCPMAqicgF1lw/pIMkF65I0=;
        b=OwVgAY30f77L4TXSE+KsbQow4ifu0Cqs6ab+7FTJd3dfcyALdP+OXOdEf1VNK3861j
         osPvGrER1OpirE23BSbQ/SZ5ZlBdLCiXiVIBjzVVkcZEmwQJbb2JILvt5WB6xKHE3gtJ
         7QGsh0igcnq3C1KUh/AC9ikluRSKotsW6pvsz+UWuRqv0mhrbncytpnSNaukYG5yEMHI
         1Fxespn8d2oFeeM7uw/5OdQGzOtpY4H5d4qXl+5xXnsd4K9GRoQOmX53F29lJ3PxKrKc
         RKEGHLm4SdQsxae14hBNmBzpduNwMW5xaK69J8kugTdNZ+o0NiEGxijhtFaRJeAUoqPO
         rHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707943880; x=1708548680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ECRVgGd7IM3p72ApRmUJhCPMAqicgF1lw/pIMkF65I0=;
        b=BBavjjElzgiHhuZWCLbW/0CdFvu7ERjRx+QwVHRWGyJ8+4ZOn+MSjh8Zb8pJVUzkNX
         Befra3Nb6VlxjAdSrHgHLxeur8Mfaf1odU5wNIgR8AEqSqFNJ+oiwVotGLTx9skqm1D1
         lqM+DVuGPek9eWey3NzQlXN8VGZnti1NamHSlFH0E08IX0PUXw1dC8e6kA0x7r2e8PUX
         4qfiTdEPCHIyRt1oGTSqjkh8jYNlwCDuGwUtLQMF+7/rHnUJZzqRe2TemLpbv3eIC7GP
         eX0qJIwS5oN2DFlTQ54vhmQhGKU4ss0DSb2qiMqxlupN2nB0Axcd7WuwmnWN5HBU0TYk
         L35Q==
X-Gm-Message-State: AOJu0YybKLTOmKtdJRR29tTzscb5GV6KzounQ5eb7taLUZUC6wYcjYzJ
	+inU55GhPQ1cTvoTACZyedmaBJuuGD2lRuS940RuuhMVKZGwlxs1UOgIQyCY1D8=
X-Google-Smtp-Source: AGHT+IHeo3TxfBDiFPozfiB1BCqlasTbJRuoWJDBrcMgGwtUBSFMGJvFT/8wqg7vJ2Cz8a0/2PX2vA==
X-Received: by 2002:a5d:6387:0:b0:33b:60ca:2219 with SMTP id p7-20020a5d6387000000b0033b60ca2219mr2652908wru.45.1707943879851;
        Wed, 14 Feb 2024 12:51:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW3LK+jv8qKatLOClulz+nNp9+SZeQ7P9k1eiXzngyNTOlrKMGtFMy8rWPq8nEJayGnYf/QTiPDosZSi9lj5uJBRqvTzfixOHXoqSFsBXP/a7zsw+v829feFnmGvuNcyOqF3q6fjP++mWCpg8gg6z0TGvf33DlwCFUDU7Re4SAXOF2b+SfGCAzy8PjqskdVnl+wa25HbKbEtTg=
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id bx31-20020a5d5b1f000000b0033b5ee36963sm13592634wrb.23.2024.02.14.12.51.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 12:51:19 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 4/6] 11-dm-mpath.rules: don't save DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD
Date: Wed, 14 Feb 2024 21:51:05 +0100
Message-ID: <20240214205107.27409-5-mwilck@suse.com>
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
late rule. I chose "99-z-" for this rule's prefix to make sure it runs
after 99-systemd.rules.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/11-dm-mpath.rules.in     | 19 +++++++++----------
 multipath/99-z-dm-mpath-late.rules |  4 ++++
 multipath/Makefile                 |  2 ++
 3 files changed, 15 insertions(+), 10 deletions(-)
 create mode 100644 multipath/99-z-dm-mpath-late.rules

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 30d6e78..cada176 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -2,7 +2,6 @@ ACTION!="add|change", GOTO="mpath_end"
 ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="mpath_end"
 ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
 
-IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
 IMPORT{db}="MPATH_DEVICE_READY"
 
 # Coldplug event while device is suspended (e.g. during a reload)
@@ -81,16 +80,16 @@ LABEL="force_activation"
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
diff --git a/multipath/99-z-dm-mpath-late.rules b/multipath/99-z-dm-mpath-late.rules
new file mode 100644
index 0000000..8574b1a
--- /dev/null
+++ b/multipath/99-z-dm-mpath-late.rules
@@ -0,0 +1,4 @@
+# If DM_UDEV_DISABLE_OTHER_RULES_FLAG was modified in 11-dm-mpath.rules,
+# restore it here, lest a temporary value be saved in the udev db
+ACTION=="add|change", ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}=="?*", \
+    ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}"
diff --git a/multipath/Makefile b/multipath/Makefile
index f8c1f5e..67fb5e6 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -26,6 +26,7 @@ install:
 	$(Q)$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
+	$(Q)$(INSTALL_PROGRAM) -m 644 99-z-dm-mpath-late.rules $(DESTDIR)$(udevrulesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 multipath.rules $(DESTDIR)$(udevrulesdir)/56-multipath.rules
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(tmpfilesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 tmpfiles.conf $(DESTDIR)$(tmpfilesdir)/multipath.conf
@@ -46,6 +47,7 @@ endif
 uninstall:
 	$(Q)$(RM) $(DESTDIR)$(bindir)/$(EXEC)
 	$(Q)$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
+	$(Q)$(RM) $(DESTDIR)$(udevrulesdir)/99-z-dm-mpath-late.rules
 	$(Q)$(RM) $(DESTDIR)$(modulesloaddir)/multipath.conf
 	$(Q)$(RM) $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
 	$(Q)$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
-- 
2.43.0


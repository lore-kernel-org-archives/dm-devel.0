Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F577EF0E
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707497733; cv=none; b=JyaPs4OaK1Jwe1Wc/U3+t1ijumFmVwK/JfkoISJSzFEHsh1UN/U0Gd7aZqNagns7K+3ZWuc+FOtA5EirN0HAPshviBq5hy9kec3TGqqZX8Dh0gcjYnVfSanY02EFjX3Pr8y3b31Ue/HBmRr/Q0S6V7mtiKoMNl4n+TRv4RPzNtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707497733; c=relaxed/simple;
	bh=SXYvj1b+MOseL8+lEgF4AvLi170/eT0OY580V1XQT8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHBgrxWidvsE8NO19qVGEETuAMyS0Vgm1vm1zlwSCv3VjZWKibiW3ZTyvYM0VxrMR5q84I/Gg/C+zQlro3vdAsiub7em47R9GMeuslwTRfq0Czh1uLAM0g/nYcODF8RC474g90sXvpZH/r8SmLvbORKgdGpCS8PvFNUY/COQfnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WkLqCRsf; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WkLqCRsf"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4103be6e938so10258215e9.0
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 08:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707497729; x=1708102529; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dqlJLITVZHNFGN83tLwKw1NAwLJPKkkVsxSqbOEAewM=;
        b=WkLqCRsf5ZvHH7b47mXSwty0FOWZe4VfhYLwhCPhsWQ379Q4/zemE3dgegXFYSMVrK
         VFQ3rCZzdgAPXMBE62FlXO/i+qLyaVweZ7wiBnRraSffRKj7a6tfyRn6qKttQdm6RxJC
         yqK2T7FbKF5ZyVdNcyMUUxKITYeZk6qS0CcHkpW+Rmsz3idxSfncYFS1tZCiEWuNW22q
         zd2RDCsQraXazDQgtVmnXSz7l3fTMarwU/tQxvcIw4Lig3gIXuPS197Da447mAjHmHqH
         12bsro/3w5eaOP2FBBor4hmtaSe1IvfEi88u7/er+C8fXkclu3Yb9IQ9suuxEmuDk6Pa
         BxYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707497729; x=1708102529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dqlJLITVZHNFGN83tLwKw1NAwLJPKkkVsxSqbOEAewM=;
        b=sz+klmSnxQPETgS8JR2kj38zWg6Z9SIFfVtQ9CdrXLWTGtZgO1pHHF2vKTW7bdm+dL
         /VatfvtBCHRFPNYCatUSxEkoYLmh4GuJE2tjYkXxQjTm7XVk9V3e77UryOjcq/6OTaTN
         Gz1BaYWfL9Z89m2Y+/3OX6VZiT0Q6ZDyXwRvBiJ4zj9TWbDUjxdQ1OcXVcJ5N9RJNLTU
         YnshTUHy7NGtUkYxxp5LC31tWD34FZ+ykwk18P2a7Ycx8aWe92vtPjaeKTfyEr5zbfwR
         1Ldn2lSPuJxb3nXnZBIiIbP2Ux4TEtEFa44aPhcY6x5nM0a3sf5khkpnUol1hI/0wzU4
         KoQw==
X-Gm-Message-State: AOJu0YxgxFICKat6ofYGL3abuMl8tei2O4fqxLwcPtKG6gRvCjImnxMn
	+QxE1ReYUMkaPdXmtcrK83fiNOa2xQ44iirw8XmedlhzRUN57vXOdr/3qISSFVc=
X-Google-Smtp-Source: AGHT+IGbsgyavA69Vtr/UO+n4G1CmYXSNNEdSG+d3/+/0kv9DkPR2KPaKmeQfLVpoR5fmlDMGCQY9g==
X-Received: by 2002:a05:600c:1c92:b0:40f:d432:c4a0 with SMTP id k18-20020a05600c1c9200b0040fd432c4a0mr1855357wms.27.1707497728971;
        Fri, 09 Feb 2024 08:55:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUdGHfH2JhzVyZOBs1pCt4S2Z12l5nP38cyyHwpB3yvrAl0NuRjGnkuGALVzD2rSRD7wwgJB66i+xyl+ibKKNA4U9yEwXZsfogDjYpXnjhd8dItfsFFrnoWjJ8tYeAnbusw0SMBE8ueR7BiEKnQqm2u7zO9sZZWaMgf42cIcNLf5PcY/09LP6Lo
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id r4-20020a05600c298400b0040fdc7f4fcdsm1166401wmd.4.2024.02.09.08.55.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 08:55:28 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH 4/6] 11-dm-mpath.rules: don't save DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD
Date: Fri,  9 Feb 2024 17:55:11 +0100
Message-ID: <20240209165513.7661-5-mwilck@suse.com>
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
 multipath/11-dm-mpath.rules.in   | 6 +-----
 multipath/Makefile               | 2 ++
 multipath/z0-dm-mpath-late.rules | 4 ++++
 3 files changed, 7 insertions(+), 5 deletions(-)
 create mode 100644 multipath/z0-dm-mpath-late.rules

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 3b2c3e1..b6629a8 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -2,7 +2,6 @@ ACTION!="add|change", GOTO="mpath_end"
 ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="mpath_end"
 ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
 
-IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
 IMPORT{db}="MPATH_DEVICE_READY"
 
 # If this uevent didn't come from dm, don't try to update the
@@ -89,12 +88,9 @@ ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
 # Remember the original value of DM_DISABLE_OTHER_RULES_FLAG
 # and restore it back once we have at least one path available.
 ENV{MPATH_DEVICE_READY}=="0", ENV{.MPATH_DEVICE_READY_OLD}=="1", \
-	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=="", \
-	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
+	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
 ENV{MPATH_DEVICE_READY}=="0", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
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
index 0000000..58411ca
--- /dev/null
+++ b/multipath/z0-dm-mpath-late.rules
@@ -0,0 +1,4 @@
+# If DM_UDEV_DISABLE_OTHER_RULES_FLAG was modified in 11-dm-mpath.rules,
+# restore it here, lest a temporary value be saved in the udev db
+ACTION=="add|change", ENV{DM_UUID}=="mpath-?*", ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="*?", \
+    ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}"
-- 
2.43.0


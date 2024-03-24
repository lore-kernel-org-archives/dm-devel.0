Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA6119474
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314804; cv=none; b=t5Teke4Vc9p4eC41wdiUMT43XtIUuhAh4yFM+PIOIHRhpSOkLVV1d8yzdvgP7al1nbUK+lrFQ78CuSBGQHhoHQlsU1BrMQMSZeEZ4o1zUh+rZCr482f4CYzkbOTid1h1q3s1jdr+vUBStRe0VUnV09r+Ed7P/+Wk5p13CTq1dCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314804; c=relaxed/simple;
	bh=SYYJWUQ2qydQILeTtTx0tx6Z6Mvmx4i8kzINd50YcuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qN4qsegnvws3vLeeNpVA3YQWFs8A5cPyVBhfohq8BZGQVtlLG47yHY1mXvYWRWCX/aDqwDPjSFiMxq8ym9nEQHV/V3Cy/A1RtVAqGXEcaLsJe849CeJVEEdSvoI0AH0AXK3XeG1PcNE3w/eajo0VWf1+MH4r9QjhfzT+8G2kbsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D3jVwlNU; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D3jVwlNU"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-341cce3e5f0so394737f8f.1
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314801; x=1711919601; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVtHWChOOu99KHZ4geynuWw31d3bvRL6ye7n6MeRNfI=;
        b=D3jVwlNU0mPF/CcdRrZSqL6oRB6+Zb8ukMxoHSlrBeKsppW3HshVFGwoFpqeOB0clI
         I4GRI62WoDjbjnE07uewCB1237OyvGWoxU0sT92XZo7dBe1Hx3lAoEBz95ksxDxM6+Lz
         9xEa7Wfu/nmAKWuPqZbjRJscwTEy8WGndSwupYs+Pg/QLMq2FAf5NGb3Oytfn0x6DpTk
         mUdRoef/OcFCt6r6F47nVD0M2YCDZrikVUd/jMazt1xoQmmduU5aGQyOUEzzkR/J+Yg/
         U/U7Hb6v/5K6nFLgmwKvsN+Ec0DowfZx7j9HBVuSF7ZdHFpWDDuOuQX3cR4jB/VHD1/+
         NrOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314801; x=1711919601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVtHWChOOu99KHZ4geynuWw31d3bvRL6ye7n6MeRNfI=;
        b=cZfovv8pJbEXV0tYeJhae2M5M7j2OCCvDUL7+p+dssn1NF/W/UBFyNKOosOP0qGGsb
         AJoVPRO/N52tIttfTtWa7e2wjxBKqbLc5lTzwMB6YoWI0HNrAEBiPAjcQqPAl67QPyjg
         +Bdgxa0ftdvRjnHWhtlBW5f7DdedGdfq6Lxkidu0b3iRxBYNkrnjqfKLFvtlIh8XuCaX
         c+tT5zQjAOCBiAVEMiq7du8kJdF4OpLxObfT1ufxJuRo9LTXZPBHLaEQwudd1zr768U7
         cnEOCkjUiCx55qNKju1tu2hEwUbT4eLwPUqGGPUPUO17AXZMcxvVgqGUjTDMKvKpXw9K
         h/pg==
X-Gm-Message-State: AOJu0YxtHky+54dChi9GWjOk2ZKXzvI8x92Ck5TlF+q3EXqptiUvdzwy
	Eby0qjh/gOrrRGNWQge3trQBQVhLrnI1IHHHg3u7e223ledvsB62H0nUqBlM4hA=
X-Google-Smtp-Source: AGHT+IEoam/fCbz964AWBH/Lz7uGs2y1LMNGHk/AYmzW+7FUnJ0AozM4cekTdqVQahTmUUitkF8ycQ==
X-Received: by 2002:adf:ea0a:0:b0:33e:c2ed:7898 with SMTP id q10-20020adfea0a000000b0033ec2ed7898mr4334566wrm.54.1711314801033;
        Sun, 24 Mar 2024 14:13:21 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id hy8-20020a1709068a6800b00a46c0191306sm2315840ejc.213.2024.03.24.14.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:20 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/11] 11-dm-mpath.rules: replace DM_SUSPENDED by .DM_SUSPENDED
Date: Sun, 24 Mar 2024 22:12:57 +0100
Message-ID: <20240324211301.7200-8-mwilck@suse.com>
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

With the late changes to the device mapper rules, DM_SUSPENDED
is not exported any more. Use .DM_SUSPENDED instead.

Note that although 11-dm-mpath.rules is not a part of lvm2, it
can be considered as part of the device-mapper layer (everything
before 13-dm-disk.rules can), and is thus allowed to use
.DM_SUSPENDED. In practice .DM_SUSPENDED is equivalent to
DM_UDEV_DISABLE_OTHER_RULES_FLAG for multipath devices, but
using .DM_SUSPENDED here makes the intention more obvious.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 8f22954..c4b5685 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -4,8 +4,11 @@ ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
 
 IMPORT{db}="MPATH_DEVICE_READY"
 
+# device-mapper rules v2 compatibility
+ENV{.DM_SUSPENDED}!="?*", ENV{.DM_SUSPENDED}="$env{DM_SUSPENDED}"
+
 # Coldplug event while device is suspended (e.g. during a reload)
-ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
+ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{.DM_SUSPENDED}=="1", \
 	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
 	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
 
@@ -17,7 +20,7 @@ ENV{DM_UDEV_RULES_VSN}=="3", ENV{.DM_SUSPENDED}!="1", GOTO="scan_import"
 # from DB in 10-dm.rules. If the device is not suspended, clear the flag.
 # This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
 # equivalent to DM_SUSPENDED==1 || DISK_RO==1
-ENV{DM_UDEV_RULES_VSN}!="3", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
+ENV{DM_UDEV_RULES_VSN}!="3", ENV{.DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
 	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="", GOTO="scan_import"
 LABEL="mpath_coldplug_end"
 
@@ -68,7 +71,7 @@ LABEL="mpath_action"
 # Activation might have been partially skipped. Activate the device now,
 # i.e. disable the MPATH_UNCHANGED logic and set DM_ACTIVATION=1.
 IMPORT{db}="DM_COLDPLUG_SUSPENDED"
-ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{DM_SUSPENDED}!="1", \
+ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{.DM_SUSPENDED}!="1", \
 	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
 	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
 	GOTO="force_activation"
@@ -109,7 +112,7 @@ LABEL="mpath_is_ready"
 # upper layers do a rescan. If the device is currently suspended,
 # we have to postpone the activation until the next event.
 ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
-ENV{DM_SUSPENDED}=="1", GOTO="dont_activate"
+ENV{.DM_SUSPENDED}=="1", GOTO="dont_activate"
 
 ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
 LABEL="dont_activate"
@@ -143,7 +146,7 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 LABEL="import_end"
 
 # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
-ENV{DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
+ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
 
 # Multipath maps should take precedence over their members.
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
-- 
2.43.2


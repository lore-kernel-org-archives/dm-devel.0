Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F4D12AAE8
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252321; cv=none; b=AdI4R9G9QN5bSsMm9tLIG2vnH6dxGj9Fn1U4638VpA2LJU7oUo3+2czHflmI9ZiuRnv6K9Eo7IpaCbx2NgVRdVReUv2h/vwhuSguU7x3x9+/i5xIYEP+wvp2FkydKWSEytgAo4oLDSmGag/Rv26fT10+m6Zk5bQ0vinR1b1zNT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252321; c=relaxed/simple;
	bh=Hnsf+LRI0nPZPIgr41jHPcScvZCelPJ69ubBwgrWEpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqfeu9NBqzUrw2YOj7ZtrDc38ECEScYiqlYZeBaOnl1LaTSXXOyJpJzdgGvtVw7yLMTA8wl4TRHKxrzS8XEDS8erivXP/XhXVhS2ghtKR9sfPXOEwCLDk5kmwuJtFLZj2WOiO/pmlmrfW5T1Y0rUdqpExpkJ23wMmzxy+us9bPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xh0WsH66; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xh0WsH66"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3438d7a05aaso799664f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252318; x=1712857118; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jsp1jDseGlZ6SwiMmK/e6xPCZfc9cm+A+l9V/XLjg5s=;
        b=Xh0WsH66FV//apVqFbSzn8MU21XKzRVqY/UI792VoK3GEi6FrDx22jx7YRU5fTMaZj
         VFZbNNY7lgfp/nRBNHy8ghyY6T4ZxQBj/iRf95A4gXw4rCenoVl6UcOf6YMTBN/zgK92
         DakD9fOJViQEMH0Dojn0t3x5cQ5CEL1LBV+b3nrF1eIGvd2MMdcFqO01Doxbj3DSSzhv
         jvZQO81Vq1mqBjrbSsBMwyeBwM+1qOlOCYp1p5NyA8dKyf/bEaqtvcAF7id3XBFGuY3N
         8P7klB5jh5uhtaJ9UAUR3Gmpo98WUaqglGNkDvpYeFFzoeX0Layrgi8nUzi0de4QF4AP
         1lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252318; x=1712857118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jsp1jDseGlZ6SwiMmK/e6xPCZfc9cm+A+l9V/XLjg5s=;
        b=ZtYs3xPmIPZWvlqXkxVIRlQqVn8TU9kl/tf0o7DvZVskSWjp2S9IXJ/3Ex1xqCVA4V
         /100ILQOKTOwD8IwiZNcSJnlKfqukxdmH25Z8RdvIZOlDP8EzMmPPiItszc2ocJ7rclM
         kSgJ5QZAdOhj3mJDSPd1aCzCK/6KQRy3zPDypxyknd5DSP1D8QGtgmjqDVThgG9HcM2H
         inZ23jqnI5Hmg+KlUVm/oJtzp6uUFvvWvDmHiqprIoUgn3T1YOVcQT1eF5nQgp5sUY9W
         Z2ZBPCYEpT56gyi5h+/dwlzOmKvw+711tKXIWs3SGa0sd/QccZxB/AGqrpO7ojpHigm/
         6sdA==
X-Gm-Message-State: AOJu0Yw6Mx3zHJpEA7lsSruemt1pu4bVJ9qEBtkpmog/hmb3n5gkXePZ
	1sYnpyPyMW5pgD7iRxkGAD0df+CZsC4xmO7Srvtz0KpljOCL36IblgURa+2NYYE=
X-Google-Smtp-Source: AGHT+IGg9y5b7jhY7nbLeBhXg8SMXJuFZcUc79xbTh0iPvINKAUzA3UfBTXa1w++O4DhFttaMA+Cpg==
X-Received: by 2002:adf:ea42:0:b0:343:d00a:322c with SMTP id j2-20020adfea42000000b00343d00a322cmr154013wrn.3.1712252317969;
        Thu, 04 Apr 2024 10:38:37 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id n7-20020a5d5987000000b00343d504d7afsm665709wri.30.2024.04.04.10.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:37 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/11] 11-dm-mpath.rules: replace DM_SUSPENDED by .DM_SUSPENDED
Date: Thu,  4 Apr 2024 19:38:10 +0200
Message-ID: <20240404173814.3143-8-mwilck@suse.com>
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
index 95126bf..efc6416 100644
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
 
@@ -17,7 +20,7 @@ ENV{DM_UDEV_RULES_VSN}!="1|2", ENV{.DM_SUSPENDED}!="1", GOTO="scan_import"
 # from DB in 10-dm.rules. If the device is not suspended, clear the flag.
 # This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
 # equivalent to DM_SUSPENDED==1 || DISK_RO==1
-ENV{DM_UDEV_RULES_VSN}=="1|2", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
+ENV{DM_UDEV_RULES_VSN}=="1|2", ENV{.DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
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
@@ -111,7 +114,7 @@ LABEL="mpath_is_ready"
 # In this case, we have to set MPATH_DEVICE_READY=0; otherwise, the
 # MPATH_UNCHANGED logic will cause later rules to skipped in the next event.
 ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
-ENV{DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
+ENV{.DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
 
 ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
 LABEL="dont_activate"
@@ -145,7 +148,7 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 LABEL="import_end"
 
 # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
-ENV{DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
+ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
 
 # Multipath maps should take precedence over their members.
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
-- 
2.44.0


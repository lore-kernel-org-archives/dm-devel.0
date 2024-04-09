Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570D47F7CB
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 14:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712671744; cv=none; b=eZGbQGa0BfPUAKSXvYSwbcmi7JA3lNHYuOPpH9XyQ2H3qXB8YhbgD3kntVkkos4/KMOFX+HlPJ17FPP7LlMD/bFkdjSvtzYcmQOZjjryv6SLtxV+GBoApR2dUoI69EJfAgDm4U/nfuzC4z78YaSM+ta/xYMuhtFX01uO10KVyMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712671744; c=relaxed/simple;
	bh=nsouayymzHpejjqvoxjm91S9Y/U6MoroG3ETFpvELH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkQLE8SWLmndwTqB3MnPLIZjh9CZhM9/m0N90G52TDB3r7AxwCKrdVai2v1bympjLPDTB66P4DVz58vEX2SLX4GaXWmuxxrmucJaa7sfb3c2LQwM/I3bubKvP7M1DbO40rlmUOcuU3Mf9ypIxG9zZwalS6a3MzOdm/NdboL5RbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CM6zyTw/; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CM6zyTw/"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a5199906493so561470666b.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Apr 2024 07:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712671740; x=1713276540; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jvq0nejtJaHE3oJJpLbJKkA3Ih1fJXkz5JqAqVxY5/E=;
        b=CM6zyTw/MEbgIrOCYQspQv6xAhjuFkiC+kVtrLAhf0BCWIKe+HoRlbFZSvacIaeFbB
         Mk/ZOfSJCYX5ym+5jb1sT9UiKW8/nuJvOU2YbRPBzjiHsk5f71Na0Gvr7qlvtavHp5KK
         OnzOP5XEle2oCP5SqTkT10tSzwpfhXUwFiYD60Fnrvo5k+bMQq8YWwPEFh7ezQiW7os5
         Wu9+fPhTfmCY5DAFvVHi77gHcjiwYBQICx1swsUjqpj6g/EuXZwqQoAFrkfJxz2b+rmd
         3JkqE35o9gE6yDGfADOg0Mmvwvuekt48L9iJa6qERb77d2b2dLICZA/SkyH2U6t9kqJA
         62bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712671740; x=1713276540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jvq0nejtJaHE3oJJpLbJKkA3Ih1fJXkz5JqAqVxY5/E=;
        b=jDC2MbVF7bY20SFC6zAUahmni+jS8RsG4XL1e8sjZWwOpnCNKDTgtvDZVpZNmmh8RN
         kibxd8RYkRYu2QD9H94PTUn94Q+kKGIUX+au4SumLVmClIwQfVVkZNulZPu8YbOMQNbs
         Q5v139rpHHMlM0BNGFRb/ScnsOLyGIJJXVqMP8xPNFuJrDZu23bapTGDhM9DkUd2/j95
         OuEGXLsSZhzp5JnN7zw7ISHvcVy62l7riJvfa/poi89fn8aA38t/I3wApzYPbxuy9sLI
         ncQYGVZi8KEqUBFNAIC4bu34mlBPNznG1KYP4xpNsMrYQ1yoKbjWay27gjIFnRrMd9EK
         zw2A==
X-Gm-Message-State: AOJu0YyeMwlLLUccnDWa4ylGO9VuJ4PieUGY64ahTCxlBW3oC4mze3fX
	+YX/kwJjhaM8zkudOUmgaIYGVMpAqDwy1C/SZcEAzmlPxFExRo3tCR9WLkGeaNM=
X-Google-Smtp-Source: AGHT+IENSeiV1NqZkT8tlTtQ0flW5a0hpVdG0yq3JiR46o9V4Szk0Vk1oSN1q5G2tkDy2YPLUjp61g==
X-Received: by 2002:a17:906:c104:b0:a51:90af:27ca with SMTP id do4-20020a170906c10400b00a5190af27camr10106725ejc.55.1712671740659;
        Tue, 09 Apr 2024 07:09:00 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id qx27-20020a170907b59b00b00a4519304f8bsm5841339ejc.14.2024.04.09.07.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 07:09:00 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 08/12] 11-dm-mpath.rules: replace DM_NOSCAN by .DM_NOSCAN
Date: Tue,  9 Apr 2024 16:08:13 +0200
Message-ID: <20240409140813.26774-2-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240409140813.26774-1-mwilck@suse.com>
References: <20240409140813.26774-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't need to restore DM_NOSCAN from the db anymore, so we can rename
it to .DM_NOSCAN, making it a temporary property.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index efc6416..3ae3c05 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -96,14 +96,14 @@ ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
 # We'd like to avoid this, especially within udev processing.
-# This is communicated to later rules in DM_NOSCAN.
+# This is communicated to later rules in .DM_NOSCAN.
 # Likewise, skip all foreign rules if no path is available.
 # Use DM_UDEV_DISABLE_OTHER_RULES_FLAG to communicate this
 # to upper layers. With dm rules < v3, save the original value here;
 # it will be restored in a late udev rule.
 ENV{DM_UDEV_RULES_VSN}=="1|2", \
 	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
-ENV{DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+ENV{.DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
 GOTO="dont_activate"
 
 LABEL="mpath_is_ready"
@@ -134,7 +134,7 @@ ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
 ENV{DM_UDEV_RULES_VSN}!="1|2", GOTO="import_end"
 
 # Don't import the properties from db if we will run blkid later.
-ENV{DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
+ENV{.DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
 
 IMPORT{db}="ID_FS_TYPE"
 IMPORT{db}="ID_FS_USAGE"
@@ -150,6 +150,9 @@ LABEL="import_end"
 # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
 ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
 
+# device-mapper rules v2 compatibility for 13-dm-disk.rules
+ENV{DM_UDEV_RULES_VSN}=="1|2", ENV{DM_NOSCAN}="$env{.DM_NOSCAN}"
+
 # Multipath maps should take precedence over their members.
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 
-- 
2.44.0


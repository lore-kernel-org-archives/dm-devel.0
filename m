Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB0612DD9E
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252318; cv=none; b=cDeiylCRNwwpxKraDrqPgv/DYFxAGEkiQ92ql1pk+MEdh9z5yKgvvyIo06oeB2m7g3u0EnZ0Bg3lTI7Z2wglc2D3Z3M5uARRaGXC2rG5udhWwYRMaOAMm1acGwwLa+ozwOT89vmjQVQ2eASNZsnTCqbm8zgHwQNsmqdQuU/rnfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252318; c=relaxed/simple;
	bh=tSEF5ajyfrJpTM9G3NlvA+Hf3juFONGAvTI+LPAC714=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQ3vaz2HGybCHedNeCV/hPqbgdRulKm+u5rKk/eblKQd9NteTc2O1NgQdJLSOvYtZhLF1d9auFmlY/cdU0aDpuP1UB0BrPer1T9j1jItzQlxJXlyEoiRHhetqhgvMs44Wa8Uum3MVE6kh4wCzFsthgc7lTP8WB9Bxltf2qeL9gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aHvkPupG; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aHvkPupG"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4162b5ba333so6176945e9.1
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252315; x=1712857115; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnwGJp8VoZbsDGkxki7wV31tsOolsfomCkz88Ys012o=;
        b=aHvkPupGtd6ac/ZcVPt8O0wM35VQtgpjRXkwr9rfSkT6N0FXXTwABVx2uEdq7PBsnK
         WuCViYfqUclYIO+vWPCvlfymZ+ODHq+eqaRIClsb5jTQFWNphPW44v1ni2QeiH+4yvxN
         h8XqOwbfLQSE+mqDFu14RaEeoMRcoPTqsBSgfW3rImR6SfihbsrqSvBscsABvXjs/0uP
         fGZMM8A5GEW014kZqolsfibINI3S6psXc4T+fmV+foOBrfiWukHvZ/qCgipMhIpa+5Y4
         +79RAohqBwKLOz6oVMgEfO/w4p5dqek41NbOQvmzh+p9ofzZ/mSQdClUVEjvy3RZX20T
         AuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252315; x=1712857115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rnwGJp8VoZbsDGkxki7wV31tsOolsfomCkz88Ys012o=;
        b=gVP0jrXxbIoPyGBzf2dGbX3UkY2lxnHNWzhlXP//LGbyflANhE6ubLPXcij8oBpI57
         j4DXpUWKN/FZLwqk3oTD2CUGb4m0JJrc/+09PNNhiPsW5VhrNjLFBgo/9AF+/xmyX2UU
         oDvJ2fy7Qv6Oklns3pJX7SijCzmMicI7ruyTcbeGvwTMoFEgO+96VRfa4mSHK0GyVfZI
         s89BMIa7ORC1eWbS/ZuUVm5q19IOCrAT3uAY7admVLM2ixlfEer7ZlBtEnTzAhZJTJrm
         rVL0s5zeirNSF0yOPVHuuguJCjUibBSiGM2GYoy0zlndbUIrByGq37Zmg+JryHWQwIqU
         e6JQ==
X-Gm-Message-State: AOJu0Yx5cGlDvf+ZlLAlVLLG7fckFXejdO0S/9Vrkaw95Abk7aOsXqUw
	eirA6gthfZdnnUbeli0iv52op688I5/nqIzIWf5qhIL1qEwPVuCClLrAytSIY0A=
X-Google-Smtp-Source: AGHT+IG/XPElLKxkryJeEL6iPRjvj0v2SE118+fPMe8TXC6soos09a+kfBPKXrqXwB5eQh0YIGot2g==
X-Received: by 2002:a05:600c:4301:b0:415:509d:f756 with SMTP id p1-20020a05600c430100b00415509df756mr2402424wme.10.1712252314839;
        Thu, 04 Apr 2024 10:38:34 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id m5-20020a05600c3b0500b004162d27d274sm325663wms.6.2024.04.04.10.38.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:34 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/11] 11-dm-mpath.rules: adapt MPATH_DEVICE_READY=0 logic to 10-dm.rules update
Date: Thu,  4 Apr 2024 19:38:07 +0200
Message-ID: <20240404173814.3143-5-mwilck@suse.com>
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

With the late patches for 10-dm.rules, DM_UDEV_DISABLE_OTHER_RULES_FLAG isn't
restored from the udev database any more, so we don't need to restore
the flag to its original state before it is saved to the db.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 4386b6c..2f909c3 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -19,7 +19,7 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1
 # If this uevent didn't come from dm, don't try to update the
 # device state
 # Note that .MPATH_DEVICE_READY_OLD=="" here. Thus we won't activate the
-# device below at force_activation, which is correct.
+# device below at mpath_is_ready, which is correct.
 ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
 	IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
 	GOTO="force_activation"
@@ -84,25 +84,27 @@ ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
 
 LABEL="force_activation"
 
+ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
 # We'd like to avoid this, especially within udev processing.
-ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
-
-# Skip all foreign rules if no path is available.
+# This is communicated to later rules in DM_NOSCAN.
+# Likewise, skip all foreign rules if no path is available.
 # Use DM_UDEV_DISABLE_OTHER_RULES_FLAG to communicate this
-# to upper layers. The original value will be restored in a late
-# udev rule.
-ENV{MPATH_DEVICE_READY}=="0", \
-	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}", \
-	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+# to upper layers. With dm rules < v3, save the original value here;
+# it will be restored in a late udev rule.
+ENV{DM_UDEV_RULES_VSN}=="1|2", \
+	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
+ENV{DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+GOTO="dont_activate"
+
+LABEL="mpath_is_ready"
 
 # If the device comes back online, set DM_ACTIVATION so that
 # upper layers do a rescan. If the device is currently suspended,
 # we have to postpone the activation until the next event.
 # In this case, we have to set MPATH_DEVICE_READY=0; otherwise, the
 # MPATH_UNCHANGED logic will cause later rules to skipped in the next event.
-ENV{MPATH_DEVICE_READY}=="0", GOTO="dont_activate"
 ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
 ENV{DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
 
-- 
2.44.0


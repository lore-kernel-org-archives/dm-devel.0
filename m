Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9724D12F388
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252322; cv=none; b=KZE4a0bmPeinaezKpwRENQIrPtZnoymTd6vg3YBobbtmCiwj4wduWSvXG+XgsK1ZOfcZwR6CBYstFxzIUBM78fJwl93wXOPhNM3VtoV43peMD2EKlvYczdRodcT3T5ZOUb0wZ8JOixdkVnw3+4JYMKZ5xWBFuvlRuzKFajPKiM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252322; c=relaxed/simple;
	bh=mcY9kPCt1L3NNdQgHGuxJM9Et7qfEC4IDdcL2bWmUgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=la0zYJgllUlSpEOyojDWhqE1Aha7/ulCNLpZUFipTrSKVE+CZXYhZa1adf5kzMmkAQ4K9WZ08wuYRqiT9T6/YzWdNCKSz2RFiU+AJVTcNSavKQnXmCtG1iwNPIsr+B9pxmOKel9N15KJlgyvbuHSzlwa/m2ELgOpQeEE6Obfh4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H1fWR6ll; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H1fWR6ll"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4162bac95d4so5002945e9.2
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252319; x=1712857119; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+jwIbG+kWcxeDLjLURLQWPdD9yAfx+oI1+kMAbnPV0=;
        b=H1fWR6llFU0370vaXhFuw4RbE/FXieyXjR+izQQWrXlrrTyhetgFz2Ikk6/qZ/9HBI
         b9XgGPjTMCHsp70URzRXq94GEj1bLQunxaooXGssxOh0DFWQiagCYLKSUcmvrwffWWHd
         yDMi21cHfXGZCV9xVl9qc/Zd+EkLQUnOcnVEPXyo11OO+UPxfCrsNaU9S5+viOCPihD/
         NG5quofXbZiiqtG93FCmOhR6cv18k4FytKbNiG4hET/6OuhZuLRarWIMMEagyB/XyvZ0
         XXKKkQMvNapFWn7nMLPpA19egffOf8vQOMTbPIgV+USzpwlPBa+KjhGh/rDgUNYKnZn7
         k6cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252319; x=1712857119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T+jwIbG+kWcxeDLjLURLQWPdD9yAfx+oI1+kMAbnPV0=;
        b=Tn8ef6HG9vnkukA1GgsEezHI6WE1zR8Tjf8TeCFkcARtW9kmrjj2eX3XJWsrMHHb4D
         MolW+SBT94c8B6d+Whvpxe55VNlDc6rVAcFpNqdiuPs4eLCzQxqYOoGJwuNYlfRmuxpZ
         6LKX3Dj7JcHorlydupImo1PlHT6XJMHaZzhKON9i/kqCC6CvQTedlC4hHyN5xiLB56Gu
         JenuUMyChX9hkwUVyqfRsFwCAKKPft1W+Mk18hlRCMuTHmPJ5w/qwYx8xn6qDVsiXAsi
         i0vlNAWViWeeSnoYP03HqmmhZW5IkfUN3PU1wNOftlcmT0lujQtcCMvYk1yfhzZpRfun
         xUkQ==
X-Gm-Message-State: AOJu0Yw+Zi6+fnm0OlzGfF7owVkdZ3svXLgHtOJudZCFaoMBXE7EdcKH
	Ie9T7w/JXBi4PbuyfOUQdIOSoNi6AoD0lPCrOiaMG+h0AEOnVHoN2hYk2gzvynM=
X-Google-Smtp-Source: AGHT+IFdAOI/gv+LQLybx4Lc4pyFPWvCk2qMtwtathbzzqtE0mw2H8zCwXSHMK8rp+J2oQ8MrJRuBQ==
X-Received: by 2002:a7b:c3c1:0:b0:414:8a7b:481b with SMTP id t1-20020a7bc3c1000000b004148a7b481bmr2282968wmj.31.1712252319094;
        Thu, 04 Apr 2024 10:38:39 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id fm22-20020a05600c0c1600b004162bac1393sm1971752wmb.43.2024.04.04.10.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:38 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/11] 11-dm-mpath.rules: replace DM_NOSCAN by .DM_NOSCAN
Date: Thu,  4 Apr 2024 19:38:11 +0200
Message-ID: <20240404173814.3143-9-mwilck@suse.com>
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

We don't need to restore DM_NOSCAN from the db anymore, so we can rename
it to .DM_NOSCAN, making it a temporary property.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index efc6416..ec55435 100644
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
+ENV{DM_UDEV_RULES_VSN}!="3", ENV{DM_NOSCAN}="$env{.DM_NOSCAN}"
+
 # Multipath maps should take precedence over their members.
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 
-- 
2.44.0


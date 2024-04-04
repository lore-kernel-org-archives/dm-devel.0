Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27CE1BDDC
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252320; cv=none; b=jUVgBwhycVZ+sNSr3+1+OhwjtehQ9ToemtZo/jE0op0CKDXmh4+zGd53GnlMzXzIo3rNo9bsmxAWgt5yrcUmPVjFEHKwS1xPbsANExkg1ToLjfausYoUN5EOAs+6PoStYmke+2jiWx2RKQL9EKesqweZvlAJQt3fvhQfWq5xJpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252320; c=relaxed/simple;
	bh=GFKauzS65pdWlKjvUjTMdLIVtuKaJqRGiltpCvza4XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCyn9yZAHc1sxUyTqKnc27NVC2dPU9GNDtbWJcX0kFOjx4w9N3QIW1SIW1CN1NN0k1Tf7lo5IEQmkldBMdEbBBS+kXc/80HvWmoolInbK3ybI6fZlp6vJEZNDrTKer4wy6avEYAn7RLsj7oRcsU1dk5BFv8IcB11/UV/sxmoDJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RZZVGkyN; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RZZVGkyN"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-515a68d45faso1497361e87.3
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252316; x=1712857116; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzkN/Bc98lEcH+fc5bd4t2SvaecS2U2CTEpWKggmG7Q=;
        b=RZZVGkyNPdMS7g+GlNVj016gnE5193GoGfPdSILZVa9PaC/UfaYQ2mmQaM8E8V2fCx
         L/CI7xHj11Bz6K5CTIiBHQ6krpl+B8sk3K5i3UIPOM82QOuWjmgW+CX7bGHQwPJlNFel
         4Hj/CBxlqbAuirCrqJ/rwkCxZQMCvXxyLCwGDU61AxUgVb55dlTo6zSHy19ug7kwanUP
         nLeYB2KKq43jZLy6oXZQ26gzPEpB7FGFfqRnH8Gc51oQgDfETZTxWWcAuFIOhTNxJn1T
         Tf+lWUlySQaUfLo8CInwARcluuH8t45SoPbDx86XBmdJt733iF7QMukXts40W+vY6DAO
         IZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252316; x=1712857116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qzkN/Bc98lEcH+fc5bd4t2SvaecS2U2CTEpWKggmG7Q=;
        b=r6b1ZBspAgPiEpu9JWCBFRB0+YQ10r0E1F7iaEmjoWQWUSdlzldjpkDgAzMETkmg7e
         5mJTOlUMDQJsNDd3ENvgq7TnstDkTgCgfl/1McB+cXPJY7+fIYexk0+rdecKSJN4ZnZW
         mwz5dqkl/r2fm6HRsgChbC6AT91zCICE1AoeVYV1Wh/PNXk3QC0fcMyP+B+BWtzwb85B
         RimKDapBhB3ZMQwDiRaZpeeHAdWVmSjPklJvQghXO4AuwsFANFqnjqmmKZSQwz9mB/lj
         9ul70pyXYN7Ycm8WAdeRCEhWdgAqma2NvO7TiZiHD6NGojkaPtsNR1TwNpgCT/bnCRIl
         2oMw==
X-Gm-Message-State: AOJu0YwCr2ZITQo9Bx7FSX75qeDg1pwIMxs73rfpKtopp7yP9yaVxx95
	YnVh9VYiJilLlBOg6AY5xKJCCBDMzi2bht3STry2/Juzyeb60kZrzpsb4PC2nSk=
X-Google-Smtp-Source: AGHT+IHm6ww/zxZ6Q4wwRmpc/55j7+U7EWXOqa4ObzYH1gt50NyHXSAmBiXWuC1q1nbEv1/HfAWazA==
X-Received: by 2002:a19:5215:0:b0:515:a791:6ea0 with SMTP id m21-20020a195215000000b00515a7916ea0mr91187lfb.29.1712252316041;
        Thu, 04 Apr 2024 10:38:36 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id h1-20020a05600016c100b0033e72e104c5sm18152820wrf.34.2024.04.04.10.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:35 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 05/11] 11-dm-mpath.rules: adapt coldplug event handling ro 10-dm.rules update
Date: Thu,  4 Apr 2024 19:38:08 +0200
Message-ID: <20240404173814.3143-6-mwilck@suse.com>
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

With late late patches for 10-dm.rules, DM_UDEV_DISABLE_OTHER_RULES_FLAG is
never restored from the udev db. Thus we don't need to clear it here
any more for coldplug events. Also, we must use .DM_SUSPENDED instead of
DM_SUSPENDED as input flag with the v3 rule set (other occurences of
DM_SUSPENDED will be replaced in a follow-up patch).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 2f909c3..5f547ca 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -9,12 +9,17 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
 	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
 	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
 
-# Coldplug event. DM_UDEV_DISABLE_OTHER_RULES_FLAG has been restored
+# Coldplug event. Import previously set properties.
+ACTION!="add", GOTO="mpath_coldplug_end"
+ENV{DM_ACTIVATION}!="1", GOTO="mpath_coldplug_end"
+ENV{DM_UDEV_RULES_VSN}!="1|2", ENV{.DM_SUSPENDED}!="1", GOTO="scan_import"
+# With DM rules < v3, DM_UDEV_DISABLE_OTHER_RULES_FLAG has been restored
 # from DB in 10-dm.rules. If the device is not suspended, clear the flag.
 # This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
 # equivalent to DM_SUSPENDED==1 || DISK_RO==1
-ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
+ENV{DM_UDEV_RULES_VSN}=="1|2", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
 	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="", GOTO="scan_import"
+LABEL="mpath_coldplug_end"
 
 # If this uevent didn't come from dm, don't try to update the
 # device state
-- 
2.44.0


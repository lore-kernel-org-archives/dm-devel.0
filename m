Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EEC12EBDC
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252321; cv=none; b=YQ1gdxO+57YzSKRrBUebzIcDsyNJxxR8rmGOfv7mGyfqRO6kVzAm9htyZk/+y4Bm90gRYdHFF9DKRtq7s8s01+0/onHZAaqyEqAv43n7Y0cu+uU+nYql0qE0S6knZi3W3PMhkYiejnmD+e9shnNIEbdYHSrGmuoq4QbLOlWd2qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252321; c=relaxed/simple;
	bh=bB5IpuUg/sKp5K4i3+f0QOWfp55XKjLJht2Wd8VIGOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARqDCKpy2ZlIOC4qK62NuFGoenAsRKl1tyFKp5olD+m3qq18cN0eC4KAUF0e/ZABym2sdiJ0S3IuN0U+AIzINbAHC+6cCtjlEcNjVFPw6RSkW7R9RJk99CO2BuL4bcgREHLm7EAw0O7yBiBqvA0sgnCxvdhB605qG84sytHJZZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a2T8qH9f; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a2T8qH9f"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-516c1fc2128so1576094e87.3
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252317; x=1712857117; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DNEoT1WBh2Y6X8lJU9T55dfj7v3ylzdNlR4IstcJ7kg=;
        b=a2T8qH9fbzQ6TCn6h2JDgVg+nZK9R7Fafn+iWJNLO2WUTVHp6l3FAbxnkO4jgfJYmT
         pidsQQfazcFfK8f0W3jZv75Ap3cpSuY3RMmWjMiEM7TKjZDtZ0xP6v8Vb/QO+gvwKlzr
         OjmT3lgDQMfV74vKxeHezvy7wACiIurzIyKcPPYOPsxL4RC5xtVoR5BkziWBDR6BRz9x
         wuU5pF8vdCsdYIcmikvcaNI0vR0zf5eJnhDprnBNJwg+EKf5VKV9fAcQ19ZRYZWNM3hf
         NnZ/2i6cQq6kEV4q3EahhWq4+MxvVRdXQd8zEyYOfkEIGyn6Y31jXgcDFv4Hr8NVBO0v
         8G5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252317; x=1712857117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DNEoT1WBh2Y6X8lJU9T55dfj7v3ylzdNlR4IstcJ7kg=;
        b=ngeQmGVFpBbc3P6i9ia5AUCWe5lpzNzbL/2oxEoFyY7Cgs/XuIkOC8ilg+ShwJfYkQ
         gHHDUshr/LOMI/AXisHPCpDRxYeKLE3d+3h4yIvGxqENUZz2DJRfVPzQGjiQzpFgsE/5
         ACXf1QJqVK2ir8e/9PTIFta0l3NWJ4KQl7trkdM/MYQzQGD8voBC+57EmcOICWCxPQdp
         r/J7qs5/9Zj7EFqEnilYebsRtH24DJHDQ7Kb+9h4oTwL8x2fOxeQ1ThZquiTBMDSL+9f
         vulZZ02D2gerx2w4xoyxuDMlNQXxI3PGQtpcSzzvIXqVWyRGkxxMxmnKrGrGy9CytpF6
         jP1A==
X-Gm-Message-State: AOJu0Yw9SP1iSzamm0DxQhNwQphDUbXXyhldXYRGp7/EQFEQymlhCsRp
	riweORk/vkPRY/Jepjw3cGt3kGWrYn4bIRVxXoao6roMqo7iHxVaKwEsTkUUHPg=
X-Google-Smtp-Source: AGHT+IEWHpPF40pC21bh677mkrtLK5KQQmpkUZ6tnIXG+G/CLJcWt/RtnD+jGsc8iHoWbSnz9vS/pg==
X-Received: by 2002:a05:6512:3e28:b0:515:bc26:24d8 with SMTP id i40-20020a0565123e2800b00515bc2624d8mr71229lfv.66.1712252317010;
        Thu, 04 Apr 2024 10:38:37 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id cc4-20020a5d5c04000000b0033e91509224sm18032304wrb.22.2024.04.04.10.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:36 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 06/11] 11-dm-mpath.rules: don't import properties with new 13-dm-disk.rules
Date: Thu,  4 Apr 2024 19:38:09 +0200
Message-ID: <20240404173814.3143-7-mwilck@suse.com>
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

With the late changes to 13-dm-disk.rules, we don't need to import any
blkid-generated properties from the udev database, because they will
be imported later.

Except for ID_FS_TYPE, this actually holds since lvm2 commit 94f77a4 ("udev:
import previous results of blkid when in suspended state"), included in lvm2
2.03.19, but we have no simple way to detect the version of the lvm2 rules.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 5f547ca..95126bf 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -126,6 +126,10 @@ LABEL="scan_import"
 # have never been properly set. Don't import them.
 ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
 
+# DM rules v3 will import missing properties on 13-dm-disk.rules.
+# No need to do it here.
+ENV{DM_UDEV_RULES_VSN}!="1|2", GOTO="import_end"
+
 # Don't import the properties from db if we will run blkid later.
 ENV{DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
 
-- 
2.44.0


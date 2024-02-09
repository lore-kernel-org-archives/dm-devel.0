Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F03E39846
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 23:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707521278; cv=none; b=i4p37xzgCWG1JhjSdoFTtVKBA9/AZWQ+Fe3ZkxbyCBbNFSaofdtX+clScMe+X5LIGc7k01LYUkqXsE+LYgizz7UXOGdacS2ye7+pwPdGoRSnAXFDmgu50si3Fgqca/eYp7KOsItdMLR0+GmKEcG43tALq5Kk3ZdXOyhxRMIYi0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707521278; c=relaxed/simple;
	bh=K/nxda3XSG7QtmtMAv/yQX+YIgqIK2tjc55oSeJFPS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZupoLs0G2zwKqVrK83JAdV8e3ctrohuc8dzQDAZ88U8run3gLxq2xxUmFDFJUzp6rZ/oAsZmKrVZl2jGKCSQNHduEWAf8SEqGZ0LZiaCNdxRKsZ86wDUzR6vG/iW30I0meHg6OC6vP+fl3DyFJO7tuIB8++OXK4SR369/g1paBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cQM0EdeV; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cQM0EdeV"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4108842369eso2025135e9.3
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 15:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707521275; x=1708126075; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3nB9e2byooXR+GdNIK3rReu3YzHbGIrVFFG/ndgqM4=;
        b=cQM0EdeV6uHtddvpqAIwELw1trLGZmL+Nzx4/0ZIyXbsPfChc2DYYgbGGapr6yOOJO
         WwasQgObt75tNTD825UyeIh5VorF/rkxApLowoofBMcRWz3MDyuYxmErtldEDxBQXe/0
         TS79zyVUPoDTfI+YRJrZWoHYve9XkAirCu9ZjeyphDSXsYVbXAvYJEXycTlaKNmp9emY
         bl+/pl+e9K1W9/OxaVmvc3dSuwcwUKzyxmsM+h7Oz7X9YCGbYq7igIXWF4l7w8zzIUYj
         uCLlbVxGHYly4gH3nWuHNgLk+97In7ivPTk4Ld3YsiHmgyW9kIcAlDsVXinsHUeNwt5F
         fm+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707521275; x=1708126075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3nB9e2byooXR+GdNIK3rReu3YzHbGIrVFFG/ndgqM4=;
        b=NbXNDvN+uQbo7SnqHwzHkvAxUKvR31wPN7z0Wt2QjVhOCFNmg3rpzTaj//HakJlsOd
         A0SCXndFpdAYLbyUe9XWvhsTmhmoXaFgqfJ06bXXVJ+fl92PaCGP+gTedokqnuPzVCUS
         YXGAYW2OJmMIrF3jvhmlNGLYVg2Rk59LaBusPoCkt/fIGZ8kh+LaydHyXRMXBRDebndG
         JHul58j4vaYxZYiES3oWQVglnYm+A0v9xEZGJwqHmxeMV5+P85EUG0viQluKo2KRYF/6
         BArLrv0+9Sct7cvrx+8wcVULU2aDksofrIWZ/rKry7865iwnPce+eIAdO08DzWjYFgPT
         CnIw==
X-Gm-Message-State: AOJu0YwX5tQTo4Q5tAKpyA145uBkiQM8PW0YhzwPXalExXVrNsj5ww09
	bWKJp4un9P1CDaBXe9g+wGbIkk/JPDYuFmr8LSyOaf4LDO5vVMXqvOZSmWMeuts1eZfnNTaRTaA
	7
X-Google-Smtp-Source: AGHT+IEd2LqqzidXq6iai1eeL5UJ8j5iJ1r5CX7aHdlgaHCMUfyjl4kmEdMpnSMHsGSNKwAnikn/VQ==
X-Received: by 2002:a05:600c:4f48:b0:410:27e7:f6e with SMTP id m8-20020a05600c4f4800b0041027e70f6emr512079wmq.39.1707521274821;
        Fri, 09 Feb 2024 15:27:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUAf4eJiCF5NLA8r5xXRd1AiC3X51JRSkja9HwF6/W0/ZgrKp2pnhEzkhLYZ26y8iUjvmNfcOUrrplGqUFwvJCjqMKCL6xaZdt8KzCi5PK3QvwyKc0e9/FGhOF7wE5Exaz4nW8qJltSKmt8Vj9kat/3ZZOkWJtJPUeCj0/K74AW4Ygq03mTDa/R
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id v8-20020a5d43c8000000b0033b512b2031sm375375wrr.114.2024.02.09.15.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 15:27:54 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH v2 6/7] 11-dm-mpath.rules: Don't force activation while device is suspended
Date: Sat, 10 Feb 2024 00:27:34 +0100
Message-ID: <20240209232735.9791-7-mwilck@suse.com>
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

If paths become available while the device is suspended, don't
activate. Another uevent will arrive when the device is resumed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 8e8741a..4141833 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -92,10 +92,16 @@ ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
 ENV{MPATH_DEVICE_READY}=="0", \
 	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}", \
 	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+
 # If the device comes back online, set DM_ACTIVATION so that
-# upper layers do a rescan.
-ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0", \
-	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
+# upper layers do a rescan. If the device is currently suspended,
+# we have to postpone the activation until the next event.
+ENV{MPATH_DEVICE_READY}=="0", GOTO="dont_activate"
+ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
+ENV{DM_SUSPENDED}==1, ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
+
+ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
+LABEL="dont_activate"
 
 # The code to check multipath state ends here. We need to set
 # properties and symlinks regardless whether the map is usable or
-- 
2.43.0


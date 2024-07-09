Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57012185627
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561195; cv=none; b=rus6LAQ642F70KzKMVT/+z5z3Xwe9YqrtZm4NldedN7GgyliBGshgMUTm6zuntrT2/HRLXjl+zIyAWrdxlPnDFRxcyQawbfvXNV7+yjvJKMQWZdHXCF1TPWkfVjfWayix8SukbuxNeiywvDvogeEiZSqw9qt8Xfe00S+XwsH9tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561195; c=relaxed/simple;
	bh=Z0ojGRReO7vVh+b04uvBgwJhqnol1Xomv0cWmT6tFa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzGm4TWVUvjdkWk95TpX+41nmbIxAIUkuKAnc/Xj6F9AXEjcDVl+3vbJweJEBGfJr7gsh16V/xRNSGF3PSbTiRa+TBWA1obe2D9Z9RDxeya/yn1hqW7SVIn5nvA4v3Okrb2vveK/ea3q8Q7KJCw2BCzdFvIUWqEnMIyVO1sH7yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M7HhizCb; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M7HhizCb"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7523f0870cso692499366b.3
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561192; x=1721165992; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gd6/SC1Kr2RQl3l4c13ae8aa/HTk0fUFNuJ+Ax+4u+M=;
        b=M7HhizCb+6Gy3x8aeqhsqt7BdclNrHxFjJWJzpLna9pm4nGwEAs+61JU8SvmH3rGB1
         Pxjyq9XwGw0sFJH4wIvnKsd9KCyiViKdEFoXzzqx4dRLeJzEE0Uj7/miZ8sfn0ijsM5d
         nWwtGbTvi7a6WZyaCjmdHkwG5hWdvBteHw99gmk+gTg7gE5nT+gLITmpgxu6PzVzpiSO
         lqmSoKeV64jq+q+N+8cmZvgmAUG3Qq/1jfy6S448gF7paJo6uVnHIU9oThysTX4CNSI2
         jdjiIZFGBqLKc/RGuGzHUVnm1gbmeXOaR9vAaXuAb1+mmgawGKSjL0rTuoHuePBbu5qG
         piJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561192; x=1721165992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gd6/SC1Kr2RQl3l4c13ae8aa/HTk0fUFNuJ+Ax+4u+M=;
        b=oeJ+c/13YnFUr/TFKK1T4awUyKltPiFkmYozAaL06XZ9hKvP0PWqRuh3SNgVeP21gI
         0E4ViijF2bYNARjnWfE94G3xY4DHW5PxA4hibp/+Ktne11e3uNu6oXyzxaUwZS97TZ4J
         xgh+NIMftT0WhpF8DTcJ5crppJBueio5801SDWWTZoMp+08II91RmnOlCB0CMblNuKRv
         lJJ6RRr6IbDcTbRqoCSwbXnlXOAzgAoZuN6p58pAQZAxaWAiceC8QqZj0FsaRuJSOVYM
         u6V6XSoIqhKt6o/pXAimhgaZE7G5LsykXXhFpZHlwWg1d0RJQKBmxl+gfAqIPrcfUmKT
         pwcA==
X-Gm-Message-State: AOJu0YxGKSzHS5wDfM2ZZpHSv1HweZKk9fFGRo3AM25hYRXR/TPBSilS
	DptllR0OmbPknCVxS5C8HRyK9gYDx6RqE9i+UBeD9E2XF8X+rgkcWGVKCsOUkrmxr6jb4wEwkCo
	I
X-Google-Smtp-Source: AGHT+IEbmwb7DmBKdIMl59dlucVZkZmzXtvaBoWVaK/5hXgHYtyEFepUYAYsgVlipuD9v1D80M5pJA==
X-Received: by 2002:a17:906:1787:b0:a75:23bb:6087 with SMTP id a640c23a62f3a-a780b6b1baemr221660466b.29.1720561191273;
        Tue, 09 Jul 2024 14:39:51 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a854368sm106989866b.155.2024.07.09.14.39.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:51 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 06/44] kpartx.rules: use @BINDIR@ to locate kpartx
Date: Tue,  9 Jul 2024 23:38:57 +0200
Message-ID: <20240709213935.177028-7-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The path for kpartx should match the installed binary.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore                               | 1 +
 kpartx/Makefile                          | 4 ++--
 kpartx/{kpartx.rules => kpartx.rules.in} | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)
 rename kpartx/{kpartx.rules => kpartx.rules.in} (96%)

diff --git a/.gitignore b/.gitignore
index 049ffe8..355ddbb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -12,6 +12,7 @@ config.mk
 cscope.files
 cscope.out
 kpartx/kpartx
+kpartx/kpartx.rules
 multipath/multipath
 multipath/multipath.8
 multipath/multipath.conf.5
diff --git a/kpartx/Makefile b/kpartx/Makefile
index 7720a74..0d4c798 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -19,7 +19,7 @@ $(EXEC): $(OBJS)
 	@echo building $@ because of $?
 	$(Q)$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
 
-install: $(EXEC) $(EXEC).8
+install: $(EXEC) $(EXEC).8 kpartx.rules
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(Q)$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(libudevdir)
@@ -41,7 +41,7 @@ uninstall:
 	$(Q)$(RM) $(DESTDIR)$(libudevdir)/rules.d/68-del-part-nodes.rules
 
 clean: dep_clean
-	$(Q)$(RM) core *.o $(EXEC)
+	$(Q)$(RM) core *.o $(EXEC) kpartx.rules
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules.in
similarity index 96%
rename from kpartx/kpartx.rules
rename to kpartx/kpartx.rules.in
index 8dd3369..9d87960 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules.in
@@ -39,6 +39,6 @@ LABEL="mpath_kpartx_end"
 GOTO="kpartx_end"
 
 LABEL="run_kpartx"
-RUN+="/sbin/kpartx -un -p -part /dev/$name"
+RUN+="@BINDIR@/kpartx -un -p -part /dev/$name"
 
 LABEL="kpartx_end"
-- 
2.45.2


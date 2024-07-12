Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC82C176AB1
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804539; cv=none; b=DBnQaapkJ51aNhJP7xnXxkcdqQP+orgtElcrxTjdRQDUUAAdNrz+4ys7nSGwtwbkxfAPX/Tcca05AFbERkIUZzkPwTEzwC3CHKqpa2588jvqRVO3QR07dlpbGAasQNoOnf+1m9VkYgFwxL96sDZG5Odv4m+WIB8b3PgzYk4D9mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804539; c=relaxed/simple;
	bh=7yu2FqZf1ktONrE7YCdwTRFBhKkKB09JfneUt1Kk8Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxriNV8wbJTIxH/s55rJHF1OZ2OvoI7s5JT9qIFntnkcIWSWuD8A+k+UnjROANmybEhl1pxfa69RmGvAs6z99ATsZvArQRfcHfHQJxI5X4gyBHPcHeincmtbmMha7ODFoMQHo3H3x6/4GxBUkKGmNFcz7rEmyoDeoYJFkJMr/G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MjjP/4K2; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MjjP/4K2"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a6265d3ba8fso273079266b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804536; x=1721409336; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3IHQCv+CrraQVi20skPR3x5tckU0no605O5x1GaU40=;
        b=MjjP/4K2k9jrzGDiQr+Oe4CeRTM/9oM31LJA+BggEKTNeXTDqU5KWmDy7XgaDAoPXi
         BPh7coASslHtQFtyDj86hW9/CjEhvSNg/ySLj/8heW63BRkJ2RmgT61jJsJ8cMmBY0L7
         54WSacHw0gPMc1FseqQhp7trDePSnpwhe/VpStU2h5DYcow1G8FjS/zxiRjUEN/mHgwG
         i181DXk88DZXitCIKiWRN6kRBtHGZEvgscpdppMxn+grzd6Ys0H+ujy/RNuW0w8ouOx3
         jmn14V5zbaSjvkdZ1zHtgmW7+Rs+A5PWeCPZ8ocM1AnRutK0PyGuLGgGsVEqjRWAzO8m
         c08A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804536; x=1721409336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p3IHQCv+CrraQVi20skPR3x5tckU0no605O5x1GaU40=;
        b=ZHZn6KDEs53WAQ8k9RNrHlJAD2NoKfmfXgszPFKqdERpGXBuXeDxsgcurKhnnPiNIt
         CbqbBYeOU3abV3G+h3tXtu+Cg/klNxLItARpNc9ewhvyr3NuJxWFVIsJH+Iy3H9yYLao
         rBAN8KVKMcb9UeGdFFvJuX4RnBirca884AkP5E3ljnfX2Aud8tnZ7jdIdsUt8Nx4pRaY
         KuOeLsad6tSvwGxNhMv/K1y1dESaG+bqafjmXpBzxiRHogCsFo1tWYasKKpFSMfJ4AuE
         QJZMqhMhrV4qkPVLVOTwAmUjyUGSTAAUN7/xjZcJMd0qdlFU286YNdJzuNSnEubCiTWm
         paQA==
X-Gm-Message-State: AOJu0YzezScJUcvuU2tQRMyix6+HWFyV7GV1lzj454lfHyA7FUHzELbq
	4Zfk7jkYiRhiKz7osQSkDGurHWrF4ChLStHdJN3BW8OtyhtDMRjq0NhjFpKP10s=
X-Google-Smtp-Source: AGHT+IGLcjpJ/Cgw5UyVuX1FhkB6Z8sxktRxYHvMh+0ZBURcVzZ92lYtBlzXa3UrZaDZiyvPNVcrqA==
X-Received: by 2002:a17:907:3f97:b0:a79:8290:ab with SMTP id a640c23a62f3a-a7982900482mr576624166b.15.1720804535751;
        Fri, 12 Jul 2024 10:15:35 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bc693sm362917266b.24.2024.07.12.10.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:35 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 06/49] kpartx.rules: use @BINDIR@ to locate kpartx
Date: Fri, 12 Jul 2024 19:14:14 +0200
Message-ID: <20240712171458.77611-7-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
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
 kpartx/Makefile                          | 6 +++---
 kpartx/{kpartx.rules => kpartx.rules.in} | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)
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
index 7720a74..849fd36 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -13,13 +13,13 @@ LIBDEPS += -ldevmapper
 OBJS := bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \
 	gpt.o mac.o ps3.o crc32.o lopart.o xstrncpy.o devmapper.o
 
-all: $(EXEC)
+all: $(EXEC) kpartx.rules
 
 $(EXEC): $(OBJS)
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


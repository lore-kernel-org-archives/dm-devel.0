Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C366E1DFEF
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804542; cv=none; b=BH9EtfhlktP6rce4VIsU7t5xiH88zhBE/qVwhjaxsBfnHCftlSDwlTMadUcgFAAY0Bzswew4k2dEpkLgUyijBMYsIGpiuHbHkVnNvbzDwlVkrsDSGOp2LZBn3Kx2ThSKXhDWACOZaF3gbXVEFU6h/rtCD/jJ2pFpFZDaK9n/qgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804542; c=relaxed/simple;
	bh=S6huMpydLTZ7DE9RnoBeBxzgQasmLdJ59j0iScYasbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOxzFlKXQMUEC2iAcEx0chq/zg2MS/PzEAjEJCZaZKF3qPZUo/t/p08vJohLWOB1HiLy67lauO8NYE46XIzA3KPM/PvDicq81F8jB//EpIf+ubzXHXZWZjJmUy3kbGJ4jlzKjSqfMr1NwGXp2vYEsJCGnc2y8HjsCHIRlOsJy0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Sihe0eZh; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Sihe0eZh"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a77c25beae1so259244866b.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804538; x=1721409338; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QyOyMsTWf666ToHkixtSQKwrdiNcha08nD2pvn99+zI=;
        b=Sihe0eZh7WioNTek4p1M6Rc+IoRL3qUHva2acI8GcjJiTsFy86xesJYNng58W5CFTy
         CfgeM8RQ5AKibmzpVO5wdeOW7vViCWQQV6dM+awh6KkhyOElvmNUhvebh5B5ZOkipj7N
         kxfbscrZXZWFHtIIDmrzbvj7RiMziNshdgrPd/XQ4rolrWMZARs7NGZDxCZsPWazvqRS
         T6vFD0OMFrn9iCEOqf2gbqD2Bg91UhvAGkWhSrEwWoMJ8Q4QLRXvUWHRWTaw10BasH3P
         Oqt3bb+8TKV0zeQ20PquUPH2KBkH2lSXCAkNapH/41z7tHgIJ/QUAMys2QOS2qyZS/GT
         GbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804538; x=1721409338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QyOyMsTWf666ToHkixtSQKwrdiNcha08nD2pvn99+zI=;
        b=i2PVttMgMGqkXmanQFqfa0sUbL0d8IX7KyklxcEe4/+1sEoLsvK9D5x+jcE/6Szfc9
         Mm451yhPdjuObGQWQ7jPJfmYoVImuteAGoVZHmOP20qPfZ9HiaENIKE52ZFeU+H8N2/a
         VBz9oSoTmEir50rYickOJifdJq39myNDoifscMA8kaox4XZToF7nGOfon1TQlDZx4roZ
         BJ0VBGv02CHO4LkO3NoRwbwAx2WWCZenqLhgVVnItxSwsjgRpagqqp12uO0v3iranRXF
         rnLVL60GPXjzpfdlAk0MrG09O2G4LuO3pPR2EPCEYVbQasPpoxBo8djeIfpZMMvuKvZe
         Y2zA==
X-Gm-Message-State: AOJu0Yyf6KN0jAz2/5JdXZ6f/J/YjkyIm0Ye4dR+bcIkAK+b5s+uZ0Fq
	VTcztd/XCQDbgfRgOdpf8RAzXtHUkyqe2Xe7hhXNRfvYMbnneaELYgoxcAPHZmw=
X-Google-Smtp-Source: AGHT+IEbZ1Pk8oLIhufVOD9b5K/LpHYSQ+i2EyMtJ9pHjyClpl1H0aLJDMuJA2tAASUVId7wTPpW4A==
X-Received: by 2002:a17:907:3f1a:b0:a79:82c1:a5b2 with SMTP id a640c23a62f3a-a7982c1a956mr721349866b.9.1720804537898;
        Fri, 12 Jul 2024 10:15:37 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a72fd39sm364322966b.91.2024.07.12.10.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:37 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/49] multipath-tools: compile_commands.json fixes
Date: Fri, 12 Jul 2024 19:14:16 +0200
Message-ID: <20240712171458.77611-9-mwilck@suse.com>
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

compile_commands.json serves as input for clangd, while working with
lsp under emacs. It's normal for functions and parameters to be unused while
writing code. Therefore suppress -Werror for this use case. clangd will
display the warnings.

Use "make testprogs" to generate compile_commands.json, in order to be
able to use clangd for the CI code, too.

Finally, don't remove compile_commands.json with "make clean". Normally the
compile commands remain the same, even if a clean rebuild of the binaries
is necessary. Put the file into .gitignore instead.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 .gitignore   |  1 +
 Makefile     |  4 ++--
 Makefile.inc | 12 +++++++++---
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/.gitignore b/.gitignore
index 355ddbb..efdbd8a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -8,6 +8,7 @@
 *.gz
 *.d
 \#*
+compile_commands.json
 config.mk
 cscope.files
 cscope.out
diff --git a/Makefile b/Makefile
index 4df5f16..14bbac2 100644
--- a/Makefile
+++ b/Makefile
@@ -83,7 +83,7 @@ abi-test:	abi reference-abi $(wildcard abi/*.abi)
 # Requires bear (https://github.com/rizsotto/Bear)
 compile_commands.json: Makefile Makefile.inc $(BUILDDIRS:=/Makefile)
 	$(Q)$(MAKE) clean
-	$(Q)bear -- $(MAKE)
+	$(Q)bear -- $(MAKE) WARN_ONLY=1 test-progs || rm $@
 
 libmpathutil libdmmp: libmpathcmd
 libmultipath: libmpathutil
@@ -109,7 +109,7 @@ $(BUILDDIRS:=.uninstall):
 clean:
 	@touch config.mk
 	$(Q)$(MAKE) $(BUILDDIRS:=.clean) tests.clean || true
-	$(Q)$(RM) -r abi abi.tar.gz abi-test compile_commands.json config.mk
+	$(Q)$(RM) -r abi abi.tar.gz abi-test config.mk
 
 install: $(BUILDDIRS:=.install)
 uninstall: $(BUILDDIRS:=.uninstall)
diff --git a/Makefile.inc b/Makefile.inc
index fe9f1bf..729618b 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -100,9 +100,15 @@ MODPROBE_UNIT := $(shell test "0$(SYSTEMD)" -lt 245 2>/dev/null || \
 			echo "modprobe@dm_multipath.service")
 
 OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
-WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
-		  -Werror=implicit-function-declaration -Werror=format-security \
-		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) $(W_URCU_TYPE_LIMITS)
+
+# Set WARN_ONLY=1 to avoid compilation erroring out due to warnings. Useful during development.
+WARN_ONLY       :=
+ERROR           := $(if $(WARN_ONLY),,error=)
+WERROR          := $(if $(WARN_ONLY),,-Werror)
+WARNFLAGS	:= $(WERROR) -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -W$(ERROR)implicit-int \
+		  -W$(ERROR)implicit-function-declaration -W$(ERROR)format-security \
+		  $(WNOCLOBBERED) -W$(ERROR)cast-qual $(ERROR_DISCARDED_QUALIFIERS) $(W_URCU_TYPE_LIMITS)
+
 CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -D_FILE_OFFSET_BITS=64 \
 		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(TGTDIR)$(plugindir)\" \
-- 
2.45.2


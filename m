Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED4A187857
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561197; cv=none; b=QAcjq4ExiJxentwW7PxhfhrGwOi2c3cVw9J8u0m200HPp+lVON8Lkqykzho9kIzPz4s/XL3slZqNUCZn1ZaBX6NuXZfmV2dYwaTYmknCEw960nvw5mLVi6AoXTwUWx3gVdorfecczFSXD714DfAT56UYSN9k7k5TJ8QuQRDfOwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561197; c=relaxed/simple;
	bh=tcNzrRNlaL2DEGA/gpw8jkTEWG7AliTexPjJD5eYzwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uN8KJCH7tDcfQrVyYsIS35Q3rjEyXmnrHxIYOZ4hX0w9+z8PNJYNy+ZJnAOegO/XK9eFW2hR/lGe7/vkX2mYkURAcCx4Eiu/EWsF1RfnDcsnpqc3pnSdLJGqAbrWAZAqYyG0JDtmiLXbgIuI9Fs+YX2aSpIp7XJmhYbvqmZRC6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZNWImxcn; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZNWImxcn"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ee91d9cb71so53641701fa.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561193; x=1721165993; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+FoWuXRkK1Fi+XENGyVS9biQJSdbGu2TEIS0VxDKyc=;
        b=ZNWImxcnt6chltm/ec5OCOVdE9pitBdBhlhy/vc8BPKwag7UsJFz/Dbjeyg2kSuRKI
         670fLY6lSW8BaEzKmL5zqqkk4K3zc/JwSi21dRaUko5vyVrWkVyJ9+yq3RZ0ln1GTxKZ
         9ncxu5BD22JI6xyALdAKhMXGN3fR5Xhf/86vow6QMe9pQu2l3iB8TjGfKCTNj1rkL3xJ
         j8Jl1RDTbMW5rfLm0qsvf7xhtFY+NkhjQrTOIHXgUgX17C7T9lD5yx0KRKqW7SUm78JY
         JFPtz5gGCaEAzXieV1ZEmdaaF7x26LlVM2pWceFxRQUThUle5ChZGXat3PF0JDQ+dClG
         WWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561193; x=1721165993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e+FoWuXRkK1Fi+XENGyVS9biQJSdbGu2TEIS0VxDKyc=;
        b=SuqODFMYMPVU3UzuS0whaZpo+UK5IpMEftwewNZPu9jMKvwjR/rMBiffgnq+2lbEcg
         HyMfsao3q+i6rbU5ec4p2dOnW93Rt9ZMIZRgMyPYGBDUyGfgu+zQaGmhIPq0RT2wFpz0
         JBNmEtGs2G1s+6nhXyXL5BYmK1Mtb8uLObHPY11krqEvjjiZGFOhLvQRh4bl/uElxfeI
         jmkuFuwTOhIgWzaRCsomTI8UlbeKPlAHZdspoej3TBk1C3GySoA5Pe3VJCLD5vdhrYqd
         kujVO/tTEC7H+rwVEP/FtWPoBd2YUN5JItlCtnIDvtwZUF/dZsFZlifO+tOO3eYBIy95
         SOgQ==
X-Gm-Message-State: AOJu0YyoV1xZUZGB9wpC6FyzJ3RPX7Y9zj4ErV+6foJoLzuLKaa0DqJx
	3dY1XY87cHJDIs2Ys+tLsQZYdS4J5ZIoZwoo4M7XoUatR/1ITU/HjtK9IR+rsFA=
X-Google-Smtp-Source: AGHT+IETW4QnMlFmbZSXXlowoWgEEj/z+GhCBX0kqHCgC8xAsnE66SawoBlbpIiPtenfndEQJ1qNGA==
X-Received: by 2002:a2e:b0f2:0:b0:2ee:6254:f9ee with SMTP id 38308e7fff4ca-2eeb3171857mr26136471fa.42.1720561192974;
        Tue, 09 Jul 2024 14:39:52 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bbe2d0e7sm1475833a12.37.2024.07.09.14.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:52 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 08/44] multipath-tools: compile_commands.json fixes
Date: Tue,  9 Jul 2024 23:38:59 +0200
Message-ID: <20240709213935.177028-9-mwilck@suse.com>
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


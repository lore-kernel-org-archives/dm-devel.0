Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23CB847B
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 18:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379620; cv=none; b=U6Y0oHfF6X0xdqhGmynoHB7NSWc8WZSfeuBp6TtK5P4KVNLCzOTcbrDlztxQSvbIE82bCl1h9V7SFG/7kAgSo27nmp+sPKbSXGQir71qwCkUz/hL/WyW1FxrN5S9FScPc7kD3MIGwF++GD+dVpQG81s34BchvVqVxHlUHzjb4eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379620; c=relaxed/simple;
	bh=s9dyK21a7pWs+n6tABOXXWZb6Odu9ksSkFib26+qHgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBwTxtRORVKt9tSfrjK/DI1g0lJfGzolgA5YUf/KgmeiPZV6TpbQ1rldr2e8/HlFv1rSbLfDYjKl2w5QO0NvKTU8G2/lMMPePxvDm407xOW9quzfLn3OQOhFVuPJQ9/s6SvHWc1hWat+aXZ06soc/pMQKwaUwFeHvp+0aw32soc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WbFFXmLf; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WbFFXmLf"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a52aa665747so459001066b.2
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 11:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713379616; x=1713984416; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JfrczQHfKohV7iNu1KOXTKLy5m7zYzOKvS0wp3qYKgw=;
        b=WbFFXmLfZOLXLc9iOANEyYtgJfJtyzLxnAxqyiroRPIxHOLlOII8imCCGzL9AekT3S
         neGO8v4zZN1vfq230UPsVnsqkPEDo+pLL61or6JVB5ILpjS9MkNsfGSlu8FHIh74Bvlo
         RGKrcxU+GYh2VdK1UmGrqqFcYh2tETCkRu5hR4VOqVZ2yYJxDnpaCzXufJhoC7jTleW3
         WqhmJzS5FDcrcc3e/xN9TR0r7JboSmbwZj26NkWWGqH30LZt8rtVF/JmIpamD6Qr1hKQ
         0ZqQ3Zaf8BsQ3/2Pz8Cnpk1g1JT4JqsK2y0UMbBh/w3yT1b1VMGDswoEM2FEoRbhhJyM
         GqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713379616; x=1713984416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JfrczQHfKohV7iNu1KOXTKLy5m7zYzOKvS0wp3qYKgw=;
        b=TdoYhT/OlE+jmj4EowviAkAdULggGs74alwplF7VtNh38Ac9gyBGktKZSAGsWAqpZ0
         vECssbAc55TogqCK8w5Hsryd8eq1ycPeeICJnJtB2zR5UBng+wN3cFjai2Hu1NwBx68K
         F4mk6UFUM74YmDUDhUWhX5279h+G/7V+9BmqjEG7Z5hDWXDrWK+HT8wp67D29m34U+27
         UQV+S9OoqWC/kxy7BxQ1297wjzrRUKOVkrxa8aMxF/oCeTk7ZepGRjeznW8iG30Y3FD/
         uA9pAzKC3veyqHbv9GxBbc7MVsKQXcqK4sDtWd9NY8fI461bd6jrXmiM3C5MRinh+F41
         8DQQ==
X-Gm-Message-State: AOJu0Yz5W0MaaDCXU0Y16ld9sypl5zDJGENnKn//YHeqSPdLigM0h9gb
	4RQ6B8r9mFbU5B7DM3dyXZFZcJ+u2udufmVHhQ+aQBs0bqkWjv7naQYlyuvRgSg=
X-Google-Smtp-Source: AGHT+IE9+Ljs4As2t4B5X1m64th49dTXa0foQL7TmjEjFPsZlXWFmHRBM9FaOYuYe19avixJX36oCQ==
X-Received: by 2002:a17:906:b4b:b0:a52:6b5f:fc67 with SMTP id v11-20020a1709060b4b00b00a526b5ffc67mr197044ejg.61.1713379615893;
        Wed, 17 Apr 2024 11:46:55 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id wk11-20020a170907054b00b00a525a18f748sm5217630ejb.165.2024.04.17.11.46.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 11:46:54 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>
Subject: [PATCH 1/8] multipath-tools: add TGTDIR option
Date: Wed, 17 Apr 2024 20:46:37 +0200
Message-ID: <20240417184644.6193-2-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240417184644.6193-1-mwilck@suse.com>
References: <20240417184644.6193-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TGTDIR is a convenience option for developers for building multipath-tools such
that compiled-in paths of the plugins, config files, etc. match an
installation under some optional path. See README.md for instructions and
examples.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .github/actions/spelling/expect.txt |  2 ++
 Makefile.inc                        |  8 +++----
 README.md                           | 33 +++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/.github/actions/spelling/expect.txt b/.github/actions/spelling/expect.txt
index 5906403..fc9f22f 100644
--- a/.github/actions/spelling/expect.txt
+++ b/.github/actions/spelling/expect.txt
@@ -167,6 +167,7 @@ retrigger
 rhabarber
 rootprefix
 rootprefixdir
+rpmbuild
 rport
 rtpi
 sas
@@ -200,6 +201,7 @@ tcp
 TESTDEPS
 testname
 tgill
+TGTDIR
 TIDS
 tmo
 tpg
diff --git a/Makefile.inc b/Makefile.inc
index 5668e63..81b86cd 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -101,9 +101,9 @@ WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implici
 		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) $(W_URCU_TYPE_LIMITS)
 CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -D_FILE_OFFSET_BITS=64 \
-		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" \
-		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(configdir)\" \
-		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DSTATE_DIR=\"$(statedir)\" \
+		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(TGTDIR)$(plugindir)\" \
+		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(TGTDIR)$(configdir)\" \
+		   -DDEFAULT_CONFIGFILE=\"$(TGTDIR)$(configfile)\" -DSTATE_DIR=\"$(TGTDIR)$(statedir)\" \
 		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
 CFLAGS		:= -std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe
 BIN_CFLAGS	:= -fPIE -DPIE
@@ -149,4 +149,4 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
 
 %:	%.in
 	@echo creating $@
-	$(Q)sed 's:@CONFIGFILE@:'$(configfile)':g;s:@CONFIGDIR@:'$(configdir)':g;s:@STATE_DIR@:'$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g;s:@BINDIR@:'$(bindir)':g' $< >$@
+	$(Q)sed 's:@CONFIGFILE@:'$(TGTDIR)$(configfile)':g;s:@CONFIGDIR@:'$(TGTDIR)$(configdir)':g;s:@STATE_DIR@:'$(TGTDIR)$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g;s:@BINDIR@:'$(bindir)':g' $< >$@
diff --git a/README.md b/README.md
index d4f35f5..7207b14 100644
--- a/README.md
+++ b/README.md
@@ -151,6 +151,39 @@ sufficient control. See `Makefile.inc` for even more fine-grained control.
 	On such distributions, override `unitdir` and `libudevdir` to use systemd's
    `rootprefix`: `make libudevdir=/lib/udev unitdir=/lib/systemd/system`
 
+### prefix, DESTDIR and TGTDIR
+
+`prefix` and related variables are included in compiled-in paths like
+`plugindir` and are used by `make install`. Using `prefix` is useful if
+multipath-tools is built locally on the same host where it's supposed to be
+installed.
+
+By convention, the `DESTDIR` variable is prepended to all paths by `make
+install`, but not to any compiled-in paths.
+It is useful if the software is built on one system (build host) but intended
+to be run on another system (installation host). This is typically used in build
+systems like *rpmbuild* to set a root directory for all the installed
+files.
+
+On the contrary, the `TGTDIR` variable is used for compiled-in paths only, and
+ignored by `make install`. It is useful for running multipath-tools in a separate
+subdirectory in the installation host, mostly for testing / development
+purposes.
+
+For example,
+
+    make prefix=/opt DESTDIR=/build TGTDIR=/test install
+
+will install plugins into `/build/opt/lib64/multipath` on the build
+host. On the installation host, the plugins will be expected to be found under
+`/test/opt/lib64/multipath`. If the developer runs
+
+    rsync -a $BUILD_HOST:$DESTDIR/ $INSTALL_HOST:$TGTDIR/
+	
+and adds `$TGTDIR/lib64` to `LD_LIBRARY_PATH` on the installation host, the
+multipath binaries installed under `$TGTDIR` will find their plugins and
+configuration files in the expected compiled-in paths.
+
 ### Compiler Options
 
 Use `OPTFLAGS` to change optimization-related compiler options;
-- 
2.44.0


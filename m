Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF03322B72
	for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 11:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768563186; cv=none; b=ic+ppthedlxT4lO1sjVVfghulJ9KIOhnRF+vISIKC3yDbX9/9/rhyd6prbcMdJOmZSSGCj/YPKuxIiV3knz+ZLtkGOiujkZDbMrIjFoT6MPtlCqNGROvc5OsI9EQDeHlAqwYUxpnsKMNZRVOFW6q2DikurRib6rUgdsuA7PZmSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768563186; c=relaxed/simple;
	bh=r0Uvy4nEKkk9QzN6GbAzZK9zJWBBY9/gokUPAF8+DeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5tGSC5njq2Oo5Wteouh4jEG6yp0h7Gfg99M2CLQ0MnRoztgaw0YcBlG9myuXmA246p99BYjL6Y49xj2rbDLSpdl9vxCuSbKaMYEr6Jb+uzgt5ToEhim9brdxLOZZe3K5owlV4ofzTkWgsYrdYswOYOjNb1WtOP3fKHdCGwxdBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VY1qt+53; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VY1qt+53"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47f5c2283b6so12266555e9.1
        for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 03:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768563183; x=1769167983; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2p+yoCEupgxBFh0/nX3lQMyVC6AnuqdOA06Xmj8UUq0=;
        b=VY1qt+53Gqy7gwHKBC4LxqAGd76X+o8q/0gfgBCQu9k2I4B+mQOVibrRXyboVdc9NO
         tMpimko/rfEUu9sPqDJ9T6/viOsTtbOXIm9rJx5BHOs9OArNtA3ciVHYAKQnKnJYZ1/B
         pf8cUsWwkx82U8vAswia5LWtWjCnTPfXLUuUx+R8AaqhmqwHtHT5LpjyaOvjRNaLP70I
         sphXru7jGJAXjIA17U23ISlhZu9b0d12qSklHYbokOGSVXfmWptPPBOMKVs0mOMJ0BUQ
         pFTZ70VObKsFs3XznQvS+F5asXLULFJnUuAqxSK+87UlWunMkGcqvNU+oTnRDWfliGsK
         r8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768563183; x=1769167983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2p+yoCEupgxBFh0/nX3lQMyVC6AnuqdOA06Xmj8UUq0=;
        b=ZTiDGxb0aiHicSS5kM9+j6WlD5pkGyXcMenYBOGvw+fVglsckmZkWKQtvc6fh1ku4/
         GNc7khC9G5jWYjsj4uuKzD7rXq4IFWub0HbeYXbfXjOwbUTIGClwYUXGOu1J99GmDVbo
         pI1w5+A12CHXBvJFFtZKUZCLI+QH11yP9UBvBxsw12IG5xu4WByofAIjGRseCZRJ2aup
         auS/KD8VeASdMrxEAWVsNC+3dvJEI9SHLsv2AbxEbE2q0tFmUfW8ggtVrJkYQdKZee6V
         Y5dSm4uGbvA3jucUrm3jR4bsAasUjncEPRa7C5XYCI98J12rwcLu1FFz/wKVTBY8MUtx
         lJKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUC0bpWcDQWAA/6yF4H4fGCmB9Z1hk5MUBJJpEXmIjx1tApXvWii90meTuYoHxhpGgm5eRPY/r1mg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyyMQaW6Cq3jRmWlpjym+IiCZADm8g87MfeEgR0Yz6IrG0oSYrO
	sewhkDe59XHrS/BO4ORkdRgSr93tqRn4Aw9Ede6ObYb7ZM5C5kFE1QR7QaW6Xp2l4vY=
X-Gm-Gg: AY/fxX6D+VTFziaX26syeaMW1by9GDh+9g8y+OKdrptQiGOdFpiG4RsXJGoKmrZvJRe
	YC5cKAS1WlPWZsB2see8X9b3pBVTnvDhAinL6R7EEM7YP5d+POcHIcSaATOGzgQQFVFITQq2/r1
	mzutR/9bzrpZskcpaUDxNHz7t0HFfvsW6A1T++I5OxvjfFs2f72dqhifBCfOFCNjqSzX8haLloQ
	oTtBYCdgswuh9DLqHwIwZkx8jY+Ls0CUtnejmA/sWj77tNz/PfXPV8Zz2lC8ONTZ5CTEoQ43Tpr
	wtveQTvJJ0kD325ZMpZ/laFhSQtxv7nsBVT/JgqhOFha4YKdxuRiva7bCa/CxKtLN2WQWDxhk0/
	VZ0VxgVXrqCPF17lZ60CwgtUdoz6fCYT3aOpyoUGZBj27IsPetbRVCadbEnLxjlJz8mrE8X1T/B
	WNIslousdS3oChTv0zIxDpcR4jgzBDQLTOxqozYj+ryzjyuomEdDtxDRAxFzHgpD4AIVzy2r+pL
	Q==
X-Received: by 2002:a05:600c:1990:b0:47e:e712:aa88 with SMTP id 5b1f17b1804b1-4801e34cd36mr33517565e9.31.1768563183449;
        Fri, 16 Jan 2026 03:33:03 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4801e879537sm37764415e9.5.2026.01.16.03.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 03:33:03 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 4/5] Makefiles: add "ASAN=1" make parameter for AddressSanitizer
Date: Fri, 16 Jan 2026 12:30:41 +0100
Message-ID: <20260116113042.140719-5-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260116113042.140719-1-mwilck@suse.com>
References: <20260116113042.140719-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's now possible to enable AddressSanitizer by passing the parameter
`ASAN=1` on the "make" command line.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .github/actions/spelling/expect.txt | 3 +++
 Makefile.inc                        | 7 +++++--
 README.md                           | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/.github/actions/spelling/expect.txt b/.github/actions/spelling/expect.txt
index 0b680aa..29ca8e8 100644
--- a/.github/actions/spelling/expect.txt
+++ b/.github/actions/spelling/expect.txt
@@ -6,6 +6,7 @@ alloc
 alltgpt
 alua
 aptpl
+ASAN
 ascq
 ata
 autoconfig
@@ -78,6 +79,7 @@ getrlimit
 getuid
 github
 gitlab
+google
 GPT
 hbtl
 hds
@@ -197,6 +199,7 @@ rpmbuild
 rport
 rtpi
 rtprio
+sanitizer
 sas
 sbp
 scsi
diff --git a/Makefile.inc b/Makefile.inc
index 539415d..8356254 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -9,6 +9,9 @@
 # Uncomment to disable dmevents polling support
 # ENABLE_DMEVENTS_POLL = 0
 #
+# Use ASAN=1 on make command line to enable address sanitizer
+ASAN := 
+#
 # Readline library to use, libedit, libreadline, or empty
 # Caution: Using libreadline may make the multipathd binary undistributable,
 # see https://github.com/opensvc/multipath-tools/issues/36
@@ -122,11 +125,11 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) $(D_CMOCKA_VERSION) \
 		   -DWSTRINGOP_TRUNCATION=$(if $(WSTRINGOP_TRUNCATION),1,0) \
 		   -MMD -MP
 CFLAGS		:= -std=$(C_STD) $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
-		   -fexceptions -fno-strict-aliasing
+		   -fexceptions -fno-strict-aliasing $(if $(ASAN),-fsanitize=address)
 BIN_CFLAGS	:= -fPIE -DPIE
 LIB_CFLAGS	:= -fPIC
 SHARED_FLAGS	:= -shared
-LDFLAGS		:= $(LDFLAGS) -Wl,-z,relro -Wl,-z,now -Wl,-z,defs
+LDFLAGS		:= $(LDFLAGS) -Wl,-z,relro -Wl,-z,now -Wl,-z,defs $(if $(ASAN),-lasan)
 BIN_LDFLAGS	:= -pie
 
 # Source code directories. Don't modify.
diff --git a/README.md b/README.md
index 530caed..8ff139c 100644
--- a/README.md
+++ b/README.md
@@ -107,6 +107,9 @@ See "Passing standard compiler flags" below for an exception.
 The following variables can be passed to the `make` command line:
 
  * `V=1`: enable verbose build.
+ * `ASAN=1`: Enable
+   [AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizerLeakSanitizer)
+   during build for debugging memory allocation. This is off by default.
  * `plugindir="/some/path"`: directory where libmultipath plugins (path
    checkers, prioritizers, and foreign multipath support) will be looked up.
    This used to be the run-time option `multipath_dir` in earlier versions.
-- 
2.52.0


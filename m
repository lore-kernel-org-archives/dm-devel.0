Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410B62E718B
	for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 11:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768563187; cv=none; b=auaiFHR2TulfUx00MJwzBQxpgHQ8SaqNx+AlJ0kGmixSlAQ57+f3ZJu1utHECAL0I+wq5ENp4lAZE/9Lo9ibDF2j2nyqPeAE7wxlitmf322Gjp0Biv0Y0MmwposYe8KNXLkIWYTBoUgQC7vjJ+9+Ir57qzBFkbz/ZUmw50gV7So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768563187; c=relaxed/simple;
	bh=cIRTiOOwWh2lAqblFKSv6KTTG3uNVoJXppJBelYcMtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iqmz1b5TZTVLMLK4NYdfabg+Oz8LxdaDAGejzJ0F/hZNJXVo0FryNjWl6Qf+X9nL27BpVmHtOMh9tgmuKhuq3GQHjVBmPPWOSbfoP9ftG/lK9h6CseT7nE+ZM34qlyu4ShQLynxhDUMZFV2xfBSadOA9vNCJWWjETOdPZHb+Oa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OQukilxf; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OQukilxf"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4327778df7fso1140383f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 03:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768563185; x=1769167985; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qyZ3gs+mpRSEhX8E1iOtSjmzhodyNNNWLFWBqFIw2sg=;
        b=OQukilxf47yvHYgFfHSjO5WHBAgm1jghDFLc5ZSUgP2WaFkRuDXT02b4p1cZUY7oAR
         fK6ldbicsFkhZIGozFnO2FVZsH7+JGfbEjDQkYd6LMxKnbsXo7/GjuBBsLrcHSSvgJ1d
         AH/5LBSTUgdvARk1j54kh9HFdJDd2KplWd9uR7JvTg9pD0uRIVtn9dgYYJw5goXXVswv
         Oc2+ha8F8GWYMnwtFKEMX4+BV8Xpc+iYOlKxZ+yLiM4N6iriHXuQpIaaf7v373biKbbv
         IjtlbIvVPdTPQcy2JWqKMEGdWC5o2zu/SXyTSNvdQqJ6qQ8w/tP6hcNqY2nJ+JbnSYS8
         d4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768563185; x=1769167985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qyZ3gs+mpRSEhX8E1iOtSjmzhodyNNNWLFWBqFIw2sg=;
        b=pUt28EqnlsrpSJ/0KIREFvgSyXnZo6smgrxvsjKqSAS6rpucRimyYzJ3q6JXnohkMX
         zKrodEF/Gxj62vIue+bx3sFJ6kp0LXmVx/Ushm4Xoz5kWtCYt4vvLopwiXWrhjnKjgi6
         GeF3ExQxiulf8mJ4fJTaFAQ+lCigGrTONrFVaFnLt9HJxFLRPSiYOuHZMl4zb1BqoxLw
         +qCPXx0YzfLHO63yOLqEa3DDawzd+zcS2rvbaEApnNxwifgfSVLC+Nl4cdzRwoCYXj0n
         54/IrdMfzsjCBejXnkkhXjxa/GiVNkFEYKykKAz2Q8eduFBWTiBBzBu8116NADPD4NE9
         GbIA==
X-Forwarded-Encrypted: i=1; AJvYcCUxLlMkY0MV+B7XLyGJWejUTc+NW60wHL7jQOJc3XQuHEwMI0TWVbkiUTt6fy+Mz+BdhWyvgEwBgA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyOArKYNNGZPWK3kEpr4FbY9i2vt2yF+WN4I8RAckmxYkb7+96g
	Qg76dV/YNSFF37OxZ04sSSqd5Kic6HBF9pbwAG44HCrIcHn+3a20HR7AJ3pBshsLhUDjrNsnIDO
	WQK5k
X-Gm-Gg: AY/fxX6HIDzqzVRZeeIzlHYQ6OqdhII/ku7I1+p+RQUk2BdlvjRbinG/GqzMbkWyy2Z
	/zPyi98zIgkQh2Fj7vsOWtEooIvElTqlIIEtFNULl59eRenxwQL0MqoTFCAoRCIpJ0YFpA0uNKy
	grmJgfrFabN3eCixo5Gulrf+rj/Cn0xGkqic7UcNECB6pR64ht6H8pjfIw2xohz2JPJ/59nm1U8
	Gmd3c5eROxPgv0SiFTmd8ZlGeeNgugirL4K8HCqprJ4ne75O4CAAER8WarcQ6aTCSQ4+0bBI4Mc
	RDmsCe2Xmu9JhOc7Ii49VyVEtDnREtgV6TM4TcCXarr4Fds/86MrW8dPXp5Toi5y4KOymodKleu
	Ot0MG3rqyvconniC37ImcrPHT1ft6io23YFVVV8wdo9g4fKGxIqbgb2G2xt5kcW7FgFOy9BH2bA
	sj99krC69ZIJhasuAxuf0Nfh/5ELjQBRzTGs1wBF811K6ZBYqhhc8PBOSNihKL20OP9tVQfgg7S
	w==
X-Received: by 2002:a05:6000:4009:b0:430:f985:a7b2 with SMTP id ffacd0b85a97d-4356a060d4fmr2960810f8f.51.1768563184572;
        Fri, 16 Jan 2026 03:33:04 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4356997e664sm4271604f8f.30.2026.01.16.03.33.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 03:33:04 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 5/5] Makefiles: add "OPT=" make parameter
Date: Fri, 16 Jan 2026 12:30:42 +0100
Message-ID: <20260116113042.140719-6-mwilck@suse.com>
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

Our OPTFLAGS variable contains stack protection options which are
intended to be overridable by distribution build scripts. When developers
just want to experiment with optimization levels, they often just want
to modify the `-O` level. Introduce a variable `OPT` that allows to do just
that by passing e.g. `OPT=-O0` to the `make` command line.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 5 ++++-
 README.md    | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 8356254..c6aa6ed 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -12,6 +12,9 @@
 # Use ASAN=1 on make command line to enable address sanitizer
 ASAN := 
 #
+# Override on make command line if desired
+OPT := -O2
+
 # Readline library to use, libedit, libreadline, or empty
 # Caution: Using libreadline may make the multipathd binary undistributable,
 # see https://github.com/opensvc/multipath-tools/issues/36
@@ -105,7 +108,7 @@ SYSTEMD_LIBDEPS := $(if $(SYSTEMD),$(if $(shell test $(SYSTEMD) -gt 209 && echo
 MODPROBE_UNIT := $(shell test "0$(SYSTEMD)" -lt 245 2>/dev/null || \
 			echo "modprobe@dm_multipath.service")
 
-OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
+OPTFLAGS	:= $(OPT) -g $(STACKPROT) --param=ssp-buffer-size=4
 
 # Set WARN_ONLY=1 to avoid compilation erroring out due to warnings. Useful during development.
 WARN_ONLY       :=
diff --git a/README.md b/README.md
index 8ff139c..888998b 100644
--- a/README.md
+++ b/README.md
@@ -107,6 +107,12 @@ See "Passing standard compiler flags" below for an exception.
 The following variables can be passed to the `make` command line:
 
  * `V=1`: enable verbose build.
+ * `OPT=`: set optimization flags. You may want to set `OPT="-O0"` for
+   debugging, for example. The default is `-O2`. Note that it is also
+   possible to set `OPTFLAGS`, which takes precedence over `OPT`. `OPTFLAGS`
+   sets additional options by default, which are intended for distribution
+   build environments to override. For quick customization of the optimization
+   level, use `OPT`.
  * `ASAN=1`: Enable
    [AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizerLeakSanitizer)
    during build for debugging memory allocation. This is off by default.
-- 
2.52.0


Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD18265613
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 19:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739303541; cv=none; b=q/lxpWBR28b6AHsDv1a/yFR/B4UhCjzGZTwnU701YVsnbIZtye/mS/fOPCht2f4Bz1MiTrjxBvLGjYQLNkjqqYVBq+HSjf4ogmfvKqUuPF+7p/lDP2kKLYpUPCmCGYLsAUfRwG7Ssg9z/KVuRS8AnlfuBw+58kwTOwT+tARX6I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739303541; c=relaxed/simple;
	bh=gsfRaEQ+MUZovEUPpYi50Heby+lYgjlJbsejHk05oJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeuF8BVmXODjvnUOzCdIoDrrk5KTRBRgCTWWICSIUXJYiO2H8DSSxmvX2wQWrf/QgkbQ54xppDpIf2Axv/YyOi17fXqJ4Q936t3eKCb1e+flXlWFRdUMU+5tHYiy1S7iTvidzFYrtpiH+N9KTrO+IeA43oOwBr+PkT/Fa6oGih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XG3ZnqZU; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XG3ZnqZU"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-438a3216fc2so59578895e9.1
        for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 11:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739303537; x=1739908337; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nsrsjdc7JNr+0SgoxViF3GfvDQ3CtbdUMUbljJ6E8m4=;
        b=XG3ZnqZUmEa8BCzYDnUeAuQKg2QtKLHSdr8vRVtI+g/Ax6+Blx9RISFmchJDBoAFt1
         MjgBq/EeTg4HedhcrkKCAJnIEtaj6AfnDaeh92nyyZx4d3quhOAVGnPNmVbhTxGE6xwn
         qqyaOceDmIlgZI83hrZPdvSIwZWqgosALkqAycUhB3J1dFR1VmGQtYIybyojl4dHubLF
         WKO1D1fLJeqlacTotqXPvwh9QNDsfhjCfinDlBTstnGKB8/ZdoFWD37Z0RKLIT1HPswb
         Nfi4a/HBFdSAulLD/A0570C0CqIK9KDOfioIRL6QNIZY2K/fMbf4jYJNpbDLOeDkykr+
         R4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739303537; x=1739908337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nsrsjdc7JNr+0SgoxViF3GfvDQ3CtbdUMUbljJ6E8m4=;
        b=V+7Jv8VkXz5lphLwkiFflwMVZl/494lhpGI2LcKLZbfh9FwvxUE/LDOAzWX9gqIQMJ
         QqB5AFoHQhfcsHRvm1j+rHqwsZSHb2/wDHcUMzm75SzVmSZjVERZn7q52L+WaKnhgaXp
         swFkqoF5XQPlSe6jAdLi3yEBzf1Fc0vjxRbO/6yd70jXJK1Z9bu8le6WNBOdj5JbSDZ9
         CoQu19cvILD+pVQvwNUiTLumgFueAXpPgS3Izaqtj8RUfvlCXi6it0RzWMDpL0+byVUp
         q5Fp6yKMGWKizm06ATxSzYO677tJhyoSi0lJTu63YgcpLhsyZIOfdDhzycRhwc8MnS7X
         Opsg==
X-Gm-Message-State: AOJu0Yzj5/UXQOHZLyOzJHiU0oMgqPqEuxNxrb/lDespo3ZykgHab/Q1
	LauYoT+TNEGWwb2YUaV1Zreo6SSVSNqfp/vBsrT0r8ifsj4rbbw2QMamO4XYy+M=
X-Gm-Gg: ASbGncvKfpd8U3tZeJovGZXjwghl5XwuV0bVhKkF/EhXVc4AvQ5YzgUiV6QYQ/JQuoI
	GG9p99tbI4VhYR7c+yQhtJbDZ35nDU/LY4gHKRKCKWFW07W8QMXiGaWuoaaCWjiqNgmbzfyVdsI
	hBGZDX0oIZgsyVhPtgmQWzn6LzKNTNscGS8ztwJE+BbPOulCU5o9Q1ZhIVZRIWI0HdJR9NRwYBg
	+wY29QDrq6I/IrbLGGXrJxWQ+bS/1RITP+IiPx4w7vd0EHH1QVAtDV5VaMjcbwYZGzlbO64Dof0
	Ag9XVaYXpaQHN50UbFnRPjwYO+9NHPbgZsWdHFnwqW0=
X-Google-Smtp-Source: AGHT+IGN348CzqofaUG/lKMrYaUWpC019/YROB3VOg7xYcdvJJhHvoMdyOGvqRVkyYT13aT8YLTurQ==
X-Received: by 2002:a05:600c:4fd1:b0:439:35d2:ed6 with SMTP id 5b1f17b1804b1-4395816077amr5463155e9.3.1739303536926;
        Tue, 11 Feb 2025 11:52:16 -0800 (PST)
Received: from localhost (p5ddd307c.dip0.t-ipconnect.de. [93.221.48.124])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38de4a0a16csm2686830f8f.34.2025.02.11.11.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 11:52:16 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	afrosi@redhat.com
Subject: [PATCH 1/2] multipath-tools: move DEFAULT_SOCKET definition into Makefile.inc
Date: Tue, 11 Feb 2025 20:52:01 +0100
Message-ID: <20250211195202.116307-2-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250211195202.116307-1-mwilck@suse.com>
References: <20250211195202.116307-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This enables configuring the socket name. A followup patch will
allow using a regular socket instead of an abstract socket.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc            | 6 +++++-
 libmpathcmd/mpath_cmd.h | 1 -
 libmultipath/defaults.h | 1 -
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 729618b..949e7b5 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -79,6 +79,9 @@ libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr
 kernel_incdir	:= /usr/include
 sysdir_bin      := $(sys_execprefix)bin
 
+abstract_socket_path := /org/kernel/linux/storage/multipathd
+mpath_socket         := $(abstract_socket_path)
+
 ifeq ($(V),)
 Q		:= @
 # make's "Entering directory" messages are confusing in parallel mode
@@ -114,7 +117,8 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(TGTDIR)$(plugindir)\" \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(TGTDIR)$(configdir)\" \
 		   -DDEFAULT_CONFIGFILE=\"$(TGTDIR)$(configfile)\" -DSTATE_DIR=\"$(TGTDIR)$(statedir)\" \
-		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
+		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" \
+		   -DDEFAULT_SOCKET=\"$(mpath_socket)\" -MMD -MP
 CFLAGS		:= -std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 		   -fexceptions
 BIN_CFLAGS	:= -fPIE -DPIE
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index bf30c1e..c96fabc 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -30,7 +30,6 @@
 extern "C" {
 #endif
 
-#define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
 #define DEFAULT_REPLY_TIMEOUT	4000
 
 
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 02f7e57..134b690 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -67,7 +67,6 @@
 #define DEV_LOSS_TMO_UNSET	0U
 #define MAX_DEV_LOSS_TMO	UINT_MAX
 #define DEFAULT_PIDFILE		RUNTIME_DIR "/multipathd.pid"
-#define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
 #define DEFAULT_BINDINGS_FILE	STATE_DIR "/bindings"
 #define DEFAULT_WWIDS_FILE	STATE_DIR "/wwids"
 #define DEFAULT_PRKEYS_FILE	STATE_DIR "/prkeys"
-- 
2.48.1


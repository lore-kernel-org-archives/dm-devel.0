Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B86268FD0
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 22:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739312494; cv=none; b=pt6s+ujAj0qb6pNiN/mQttQYILVlwyrTh8uexJkD/brNL/0WQXdICVB42EG/ZsdjVu5Kb1jPXBqppUcsaoMGu7e0EQIq7rZFD9wtt1OtToHO3elqeJw5ZsrKJ8xn89Okka6W+ykRy2R/vOWY2l76USaUhelD7HQczhJiofX1l+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739312494; c=relaxed/simple;
	bh=gsfRaEQ+MUZovEUPpYi50Heby+lYgjlJbsejHk05oJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yy22ihnBNr2VfAGsQlsTiizC20QnHMRMAFAUE/HcNZG8jukZE8BjRnGZKIiyHw3RrwYzrklgeQz0nFCK7LoV+eWQyqKzcBmrixzQzkwBk7xYcV0VDXSLHy/WRMr271lw7Skc320vT70THKnMp6+oPq2jG8SaQULK9YKRGe5NR00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gkYAxkzh; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gkYAxkzh"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-38dcb33cba1so2414472f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 14:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739312490; x=1739917290; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nsrsjdc7JNr+0SgoxViF3GfvDQ3CtbdUMUbljJ6E8m4=;
        b=gkYAxkzhFI30n1MDnDInOrL9hBjOAI0bJS0+BEtkGzVT7AcGocztmySPWUuC3sHpmP
         1tZdC+NvmFdePuBO8kkGz2/JzHHUnn+dwA+yHwmB+V7wVbUtIjmqOYCjKb1kSGObTZaj
         zrCVmkrI/VujQpfEczwNmMehcLdGc1DKO6Olvi7humbicGifqTUiQME6vnoBXWfxrCHn
         LqMqjk2CeAKttoy7A63KErIik2DhVNdcSZTdoXNMCIVy9euQs8WQwN08UlOS0QAWbuqy
         iH7MBr0CZl58oK/ELNBXON7XqAEwFlcJAtwXabmUU+OotzwtMhOGAV3W5ijXy3M7d/Q+
         NmFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739312490; x=1739917290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nsrsjdc7JNr+0SgoxViF3GfvDQ3CtbdUMUbljJ6E8m4=;
        b=YmQgocdUxeHCrkmrit0ndJmlvVjJN9pKr4+HZXZI5zFGLGO08/bnuJOE7qunuz5G3h
         i/5Jrbiim2ExWQujhSlSZ5lCQRVjWV2z0OKsFrJ3DRNkf0Pp5iNHqgCChKfCZL6c4/vq
         BStR5xZI68s8TQlTrOKc9v8OJYshIGKaEzzgzCekJCrrjeqW71oTn1SW6P/qGvD8MOXq
         K7hHM1zYUN7pZ1rzVaDUh2ovUPtyg3m6l7yn/sPAsRANuyFNWBlsi7kkEDr07FdaJ70y
         vve5VDAom4u/q/yKFcAI91Q5ii+ThwIqorEeYi1qLuvd8EVYTV0Rr47rmxF0gAHgHl+n
         4FYg==
X-Gm-Message-State: AOJu0Yz8XLs1bqUq6NpZO4IHBnS5gsvuGxrWfj9CP+uqL1cWIt1Nj15g
	9BJu+rEeuYn2ReutGNTdNRtmwqR6CIB8aO2mvpzHzmOuacsZy6JOmAkh0pzErxo=
X-Gm-Gg: ASbGnctJg2ZhbBcLlAy6p0wPSjIJFRMrPv6RtDBhB56/oKiQPC/aVthmR7XwPtdLfXw
	p6QqiQZBVEYWTf2mzpa+kH3CnUp3hFjSRqnVDiVZJTtMLJ68+TUeg/Gd1WjiLHqsIetK9OGS9JB
	0fLow/IJdTI4YANVhg3+JTreAXAzHWepO7O5crqqvPwNNKGVO04xwxAEnTB4/URD4wCzKXmRtGH
	dIPKvfkf5NBLzNJZacgtSxvCns5BK3m3Vf7SQTsdvUJNsSTBKallcsPvmBmUyUPhlfthC5Lx3jc
	4RYKjFBu2erWyVv5bzHt6rCJUxpJvZT68pKNNn2m7AU=
X-Google-Smtp-Source: AGHT+IE7XmlYdejDdTQHWsoWQ7+jUxW5KO6tmyQIzLVPpwmdXLKuN9U4nzRNrC1RQPUNKqH3/77ysA==
X-Received: by 2002:a05:6000:1fab:b0:38a:8ed1:c5c7 with SMTP id ffacd0b85a97d-38dea2e17bcmr435695f8f.46.1739312490254;
        Tue, 11 Feb 2025 14:21:30 -0800 (PST)
Received: from localhost (p5ddd307c.dip0.t-ipconnect.de. [93.221.48.124])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38dcfebb896sm11981882f8f.33.2025.02.11.14.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 14:21:29 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	afrosi@redhat.com
Subject: [PATCH v2 1/2] multipath-tools: move DEFAULT_SOCKET definition into Makefile.inc
Date: Tue, 11 Feb 2025 23:21:25 +0100
Message-ID: <20250211222126.182370-2-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250211222126.182370-1-mwilck@suse.com>
References: <20250211222126.182370-1-mwilck@suse.com>
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


Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E831DDA18
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571027; cv=none; b=JHXKiv9aJPut3cr1eDuupBKAlSza+pP6/DDQPTz4HyluR26nl5ctwJEkYD6gkBFDWeSmxFUysPa8Rd5n1oyl+ZN+ZGxGOfHdeuwS6Ybpd8mzoWsQO8RWi4UAFriZwLc3WT1y6XM7jtsh1gs3J4ckKeFd0KDg/QXoijBwtfQAcIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571027; c=relaxed/simple;
	bh=CqQWvzMpNs2Yy1U1wRj6dEH064lM+EXAl/A+Qs9L5A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/Mr4yQiYxDZL8f1XLIYy51UfE/rJzFyhUZaR2HiIPvZaTNgwxze73l0GibPUsVa5wQwrbkMBCuvLgztcBguUdKt4TKQrdXiWw8nH0lXRkkkE/Ik219WARQPEgcv0OvuR0FBDzo/wbEsyq1BOtKCpFxy6ES1Q708Zf45R0r8ay0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G70FJ/U3; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G70FJ/U3"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ab7f76aeedbso322700866b.3
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571024; x=1740175824; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ey3kUqeg9uyJ2PtkLSTy0NZEvELl91EqHkDHaUzML8k=;
        b=G70FJ/U3bYhHe7XAm8mpcayz1yHDD30TsJaf9JfDPx+IMBig5PHRx2fpcgv+lpnD8Z
         T5j4UpmhR9JI//n2MfNtYWaILYc8W6Zxv/YsRbx4WgdUc5BpSPKVFTn6RA3okPg9loJW
         NaxWHC7h2966ta7oD3W1EZJIZQ/3RXcSpYkicrPq+Jw9GGcH3aOq7Y6L/e75SKOwCFhP
         nZSPlhF5GY0kQypaCQOLf/GE061k1dphFXcLo1wZKRPI0Qb6SNT+mWX8tO/JZAOZVYnq
         pXF5ZbC+Z+5xq2a0tNofUHqFqyS6i0qigaYAQygs9YOVlJOwtL9ppl0GAnZK8S2dq6Ef
         7eOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571024; x=1740175824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ey3kUqeg9uyJ2PtkLSTy0NZEvELl91EqHkDHaUzML8k=;
        b=GRqEKIcw+L6d4cRbjyYfvDDAyKQsJBse6P0m6PRf5cyYm2rMAd62jBN52EI7CvWa0e
         lJGSAIaWKAlgCf2pqGXXSD/QCtjzgZWv6CGaN25r/vJXDp7S408r+rWkU8MGNCNgzYPi
         4gfQsQu1zhQheasKmp1nGHRRGKljaluS+TIabkCQ3nwUmKEFfU7bqES6i5/zBJnHr14L
         0h1ZnzAeENhu+YSRnSJZQNQKNmi6r3x8G4spV1Ma9DxQ1VS1pXkph8i1wIJmFl7t16gM
         kIk21LBj9Of+k3XY8E+RjKryjItQqnZDlK2j0mmG8HzEPhPkKCfRHWoLkrEzXEcYEgRJ
         NwMg==
X-Forwarded-Encrypted: i=1; AJvYcCUU/FfgpcnDZ719eTDhtRWMf1b3S2aRjsNnLS7PlYmAfa2d+7RCq1YV7zQ4ZGtyLP1OzqzYgDBNmg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLOrf8JY0VnP2Sk7edpej+MbWG+o0QBg7WY1B5rfoPWPqUpOjD
	JYQ6pvUCWsxj0m6hfvrW6FNan+eh/uNIreIDYkhDAsoguoi/kHGbVlzMekcB1E0=
X-Gm-Gg: ASbGncv2hoEHuISMi/nAjou2ZY/ZFCA+BZHsdsuxD3f9fpwGKC5Ywbf/kZ+3GSWNs3z
	jxjQiwEWg8/fsqg1maHyi2EJkuS45GEM5OqsE0L8v4mA0a8DDXMeo+7dEyIjYbHIOJ8qwXhmvl5
	45E9BU/HnznHbvBAVayq9bw9Zu7cWvO9r5ztsPEoLYRx6bgSqq/dCcDWkVUUz43/D3u/pej7Yj1
	IP5ctRKSWNqmqMOzgeodbwwgkRWai3JaV+W0wr51mZbxPsXpbxbD8cYgc42dHhaz6l2l89BtyIK
	oAwAPFIiZbHoxS5TH3tmKVZOx8mKoNyPmO2r99dWYzlpFIil/OXaf29g6xuiOjq0KRgUKRWOmgf
	3NQ==
X-Google-Smtp-Source: AGHT+IHQ/qsp1VUQSf7/mAVh/btOOHIXnABpeyMSwCQalXdmJbZJHSee8dryJXsGdWjM5luyYNJLAg==
X-Received: by 2002:a05:6402:1e8a:b0:5de:5190:cfc7 with SMTP id 4fb4d7f45d1cf-5e03608cb01mr1854785a12.19.1739571023471;
        Fri, 14 Feb 2025 14:10:23 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5dece1d00d9sm3496765a12.32.2025.02.14.14.10.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:23 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 01/10] multipath-tools: move DEFAULT_SOCKET definition into Makefile.inc
Date: Fri, 14 Feb 2025 23:10:02 +0100
Message-ID: <20250214221011.136762-2-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250214221011.136762-1-mwilck@suse.com>
References: <20250214221011.136762-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This enables configuring the socket name. Follow up patches will
add more flexibility for configuring the sockets.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc            | 5 ++++-
 libmpathcmd/mpath_cmd.h | 1 -
 libmultipath/defaults.h | 1 -
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 65f6efc..76efeb9 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -79,6 +79,8 @@ libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr
 kernel_incdir	:= /usr/include
 sysdir_bin      := $(sys_execprefix)bin
 
+abstract_socket := /org/kernel/linux/storage/multipathd
+
 ifeq ($(V),)
 Q		:= @
 # make's "Entering directory" messages are confusing in parallel mode
@@ -114,7 +116,8 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(TGTDIR)$(plugindir)\" \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(TGTDIR)$(configdir)\" \
 		   -DDEFAULT_CONFIGFILE=\"$(TGTDIR)$(configfile)\" -DSTATE_DIR=\"$(TGTDIR)$(statedir)\" \
-		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
+		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" \
+		   -DDEFAULT_SOCKET=\"$(abstract_socket)\" -MMD -MP
 CFLAGS		:= -std=$(C_STD) $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
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


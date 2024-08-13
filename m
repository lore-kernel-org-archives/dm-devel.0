Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB817F4F2
	for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 09:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723542107; cv=none; b=oPRWsmup9wLghUFT7xBYuofgS0PjzVgoWbtuZ/quC1ISHWhl9/RlRZ6sbil67u8B5nZ8zAmi/gKjSe5C6HwPDpCwP3LcSyUxA+qLpojwKdFP+8OXZlGV7Uj+0Yh8NXBm5quSG6Y4klg/hg5Letr48FOfgn6GG79r5dW1ga03f0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723542107; c=relaxed/simple;
	bh=/gzGlUvORML+is9M3KbAn37aGUlG05wEhs98rAuUbwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvEuJY4lEP2Sx5mB+kcTybk2I8WkvG+e4TD7vbcSN+tAbe5ePQAgSrijdAgSexeyLnhEHwB8TNO08unlUMKAcQWgw6SWO+RKZPy4tGpH6ZAMOt9ffIaXhh6sSf1YH5Z7QSX7OrfsNs/1IoysP7+dD8+bKnZOlfTWi6vSx9sbdKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aAeGvr8t; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aAeGvr8t"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5a1337cfbb5so6968421a12.3
        for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 02:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723542103; x=1724146903; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jncRdj7NKphL0xOwvljwl0SQ+kZOAF6WY9y4OO+eay8=;
        b=aAeGvr8twhBs8OUPwGag4cMg63CNK8jO12JZPAIb/FtkBKpkoTMAmsboKI/TK/dl1C
         qxRbtygbQ6fnzekiyUgT/l9lV3eem5VqMgaQLf3bJ/ziJ6V3sflz4Mj/iuGJXg99wxz7
         exB8PTjvE4ixAfD81zJZniEcZYhlOt/URxpAfkOnYl38qkGvsXPwbv4DPdA+qklccg4D
         yKjfcWgsHvkeesMihK7KldOUHn351h8mDpxtYkWMVMn3or7d0exFaCWA8IwtO2OSYoQ9
         Ti2lV2MfKfWu/pfQ4OSbYz5D6sKz7cM/lIegcxIZX0W7/IQ0dvs/Y5Nv3AV+yug3IIPi
         9W4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723542103; x=1724146903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jncRdj7NKphL0xOwvljwl0SQ+kZOAF6WY9y4OO+eay8=;
        b=LJVI9egmXm87t5tonoWAYboQOXXH6gdhA4SWqLEarACa3J/o3SzjVxb6SEA1c45nMR
         eFSMAPeKAHHghfBQU6u9Tno1iiNh7u6lpYAu5AhjLJpGnWk5UfLFQP2ve7v/MP77cdTX
         LN/xjs/jh1/X02stvmXTiy1jJ5dD7hNClFLIjZWunt6kmyp13WjuHUF85Z/tscqkl/jO
         YNuFru+hH9uPw9f9lE9K8L9Bcq1ZV4hLOF0xEqaL0IwPLILCXHX2iXmj2Zgvlm3FE6Z7
         3WGIXhILu/XXF5EkeHG/t1QgA/1VDGAscdmmP54sDt7EMYgBP6yyGPjcf6pZKXkhvkYJ
         XMwA==
X-Gm-Message-State: AOJu0YxodBN2QjhbQ6sNd5a9nxvieNfkqrX9oSEg8SXyVMr32VtMDX35
	E6oqoQ41fgqSBGrwWtV/AkXndl3MpAxCQPMM0JdJy+q3D80UowhNStvW+ZjOhFg=
X-Google-Smtp-Source: AGHT+IGLRRwFs1ebEZHSUsXHRHxjwRT2rq01Psfynrn9++kiloy8mmdKC2Hq6mT6Zi2c67BJhVt1yA==
X-Received: by 2002:a17:907:c8a9:b0:a7a:9447:3e8b with SMTP id a640c23a62f3a-a80ed1c2388mr230959566b.25.1723542102916;
        Tue, 13 Aug 2024 02:41:42 -0700 (PDT)
Received: from localhost (p200300de37360a00e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:3736:a00:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a80f3feab58sm54534566b.95.2024.08.13.02.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 02:41:42 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/2] libmpathpersist: reinstate ABI 2.1.0
Date: Tue, 13 Aug 2024 11:40:46 +0200
Message-ID: <20240813094046.21644-2-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240813094046.21644-1-mwilck@suse.com>
References: <20240813094046.21644-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__mpath_persistent_reserve_{in,out}() were part of our public ABI. Instead of
removing them completely, define it as a weak aliases.
This way, programs linked against previous versions of libmpathpersist
will continue to work.

This shouldn't interfere with general symbol naming rules, as a weak
symbol won't override a library symbol of the same name.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/libmpathpersist.version | 17 ++++++++++++-----
 libmpathpersist/mpath_persist.c         |  6 ++++++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index f467d99..c7ddafb 100644
--- a/libmpathpersist/libmpathpersist.version
+++ b/libmpathpersist/libmpathpersist.version
@@ -10,23 +10,30 @@
  *
  * See libmultipath.version for general policy about version numbers.
  */
-LIBMPATHPERSIST_3.0.0 {
+/* Previous API for backward compatibility */
+LIBMPATHPERSIST_2.1.0 {
 global:
-	/* public API as defined in mpath_persist.h */
 	libmpathpersist_exit;
 	libmpathpersist_init;
 	mpath_lib_exit;
 	mpath_lib_init;
 	mpath_mx_alloc_len;
 	mpath_persistent_reserve_free_vecs;
-	mpath_persistent_reserve_in__;
+	__mpath_persistent_reserve_in;
 	mpath_persistent_reserve_in;
 	mpath_persistent_reserve_init_vecs;
-	mpath_persistent_reserve_out__;
+	__mpath_persistent_reserve_out;
 	mpath_persistent_reserve_out;
-local: *;
+local:
+	*;
 };
 
+LIBMPATHPERSIST_2.2.0 {
+global:
+	mpath_persistent_reserve_in__;
+	mpath_persistent_reserve_out__;
+} LIBMPATHPERSIST_2.1.0;
+
 __LIBMPATHPERSIST_INT_1.0.0 {
 	/* Internal use by multipath-tools */
 	dumpHex;
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index ace91d7..f5267eb 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -127,6 +127,8 @@ int mpath_persistent_reserve_in__(int fd, int rq_servact,
 					      resp, noisy);
 }
 
+extern int __mpath_persistent_reserve_in(int, int, struct prin_resp *, int)
+	__attribute__((weak, alias("mpath_persistent_reserve_in__")));
 
 int mpath_persistent_reserve_out__( int fd, int rq_servact, int rq_scope,
 	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy)
@@ -136,6 +138,10 @@ int mpath_persistent_reserve_out__( int fd, int rq_servact, int rq_scope,
 					       noisy);
 }
 
+extern int __mpath_persistent_reserve_out(int, int, int, unsigned int,
+					  struct prout_param_descriptor *, int)
+	__attribute__((weak, alias("mpath_persistent_reserve_out__")));
+
 int mpath_persistent_reserve_in (int fd, int rq_servact,
 	struct prin_resp *resp, int noisy, int verbose)
 {
-- 
2.46.0


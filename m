Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8571E361DB8
	for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 19:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779908705; cv=none; b=n9YptUvB+QNwLCV2Lk+8snog9KQJPvSzxaFaO2lNgvVL3M+cmaVE/RU2KhFkfVG5EkhwMPkLuqOveIiq8AvQV9t/rEwBigF6sklFHsa/10u6W6FJSdp5elgArYSY3wz052wZr6VMeI9ve7WVoygZRRi/vRO6bKYWTXNq3fN5YVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779908705; c=relaxed/simple;
	bh=BbFBhqdfYRg4StJHGYM+d7LaEbhP2Be0BnzsmvVtqu8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NhgfFOKA5H0/fVl7fFXTPum+SJkJv5StIF0fzxGVERIYhgXHOyQIs7yhyrnrflTWp4BF0/i4yoHSdiqe7CMiIqecs8n01X+J7O+PyT8bZmtH3JtOIIbfir4HwFg8hwMZCZem3lpYsryv7yuLoY8L3rDW6kf0Wly9UI0OYKOtAmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g9+D02XX; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g9+D02XX"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4493cf2f982so1211574f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 12:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779908702; x=1780513502; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lHCIAKeSnXXKARr20yVGngcfrkW0f/jaIU4dzRlR8kc=;
        b=g9+D02XXaPjSELkG23clsd8cUu/JAMv3ylK9WerQgJ2w/QbUiTzQImD/VV+F1IsOK+
         mamY+5ybwRNi6LGNLAzcQat0lI3cfBM8z2vhBOSpSt4J6tr4ldiWJhaRcVzE1/mFY62n
         DBYHIB5BIKnw+c/4UicEXe7+7y9wok22SD6XqHlEncFdEZX6Lui1tAt+LuxeUdiH1+FT
         hM7Ru7byhx0rnZi+4yYXeEWBRkK4aGZdx8sZsUtNP0ZYQxhFg+lnSrn7XxB7OWoYOc3X
         zHwtzKz7+GksF7qN0bBJI0JBKums+lcYeeBO9c45TSe3V+W1phmpobvASedLxiDbgpa+
         QfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779908702; x=1780513502;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lHCIAKeSnXXKARr20yVGngcfrkW0f/jaIU4dzRlR8kc=;
        b=K5yQA3vMVqAkeNLLnAMKCrzNi9aItoIrl2LLKjRJ1+lXTxN9GTLjBI8ErkRg9A5VA/
         Un/6WzIZngAC77114is8CleMM6BDpiLmv+IRvzyGn/NQJnWqNSggAZnpmVTeYp4Owgrt
         uXmzNJA7KFMurfqYFChBYJVIA3frjc7vSdPKzDtKi58BTK55OSe8v11oEZLSUGHE9aqh
         +2WjQMXLPLHY1BInsWSHo12JCaYst5wHxFbeXTIfVVDQO7Isi2B4kXDgtbJzRn59ZbUE
         nbNC8p/DRgZRWitJwK4ifYC3ZoZEqg92NzFKtDRUHx7allFrdBzCtpXjc7LCzSxe8XEP
         Xy9w==
X-Forwarded-Encrypted: i=1; AFNElJ9UHZa8S3Hzy9K1wyQdmWRTcpSu8lWnxVi+326OFQOcrildz1lUxwtwrVgLUOBFNVKAgh9U1RK5EA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1LeGWY5iqCjCtGbs1XZYCJDTyFbx18J9Uydwk9S3vFZLIkfwf
	H/RmVmVqXcXn4xdRh+qtntkPPuc7pRBKi0e76uINhSimrFsGzX8r7QQ=
X-Gm-Gg: Acq92OEaSVMv9s8w6iemxALHJLssulrSqQgPU8tWO94v2GIEh3r8rQS5sCHEtdL+Vxv
	WcT7JVdcLkorxK4xW0ytTzgdbAU0oewQGcVPFbLB/auSX00CGKhscnfIBz/ztXy6jCAPKiJc355
	QybgGxEoQ4cFI8B+QWF0FjIGfBMXVU+7ZL/eRinZG4wOFMC+a5bg0NK9dwHYRX+gDqr23eT4NLJ
	gbyrF/Jd1h8NWl0eW8hrRKEBFVI9DlS/hLdhdbjty6Xj4M88uBMInuM991zsGacFfAYdnQI0d/5
	W4FIJzJsUGJWzkFchWlHGofvEVhQP9ksj2gCdsylet6V/04iN0dCLcjzV1XCueD7CTb2x+W+7em
	FFzX+PEMe8xVCaWdXk6vN1GJs4Zk9VFu5pmD0SJ2oZ9LZ3dPbBdIuxjbtssG0RlLbeP//+GnRt6
	+SV/RYpykfxQlVas32VY/P7ej8+SfS9fSGAMalhk2nllwLErXap83PyMQLxgbO7nqPFEs2F+g=
X-Received: by 2002:a05:6000:26c1:b0:448:8796:9c1e with SMTP id ffacd0b85a97d-45eb33287a6mr19639925f8f.0.1779908701677;
        Wed, 27 May 2026 12:05:01 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5a2a07sm7340931f8f.19.2026.05.27.12.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 12:05:01 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: delete obsolete information from multipath.conf.5 
Date: Wed, 27 May 2026 21:04:59 +0200
Message-ID: <20260527190500.194274-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

repeat_count (rr_min_io, rr_min_io_rq, rr_weight) has been unsupported
since kernel 4.6 ( commits 90a4323ccfea and  21136f89d76d ).
And also clean up other deprecated entries.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
---
 multipath/multipath.conf.5.in | 69 +++--------------------------------
 1 file changed, 6 insertions(+), 63 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 84cd1a0a..e3a9811c 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2025-09-12 Linux
+.TH MULTIPATH.CONF 5 2026-05-27 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -198,9 +198,8 @@ kernel multipath target:
 .TP 12
 .I "round-robin 0"
 Choose the path for the next bunch of I/O by looping through every path in the
-path group, sending \fBthe same number of I/O requests\fR to each path. Some
-aspects of behavior can be controlled with the attributes: \fIrr_min_io\fR,
-\fIrr_min_io_rq\fR and \fIrr_weight\fR.
+path group, sending \fBthe same number of I/O requests\fR to each path.
+
 .TP
 .I "queue-length 0"
 (Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe lowest
@@ -598,24 +597,12 @@ The default is: \fBmanual\fR
 .
 .TP
 .B rr_min_io
-Number of I/O requests to route to a path before switching to the next in the
-same path group. This is only for \fIBlock I/O\fR(BIO) based multipath and
-only apply to \fIround-robin\fR path_selector.
-.RS
-.TP
-The default is: \fB1000\fR
-.RE
+(Deprecated since kernel 4.6) This option is not supported anymore, and will be ignored.
 .
 .
 .TP
 .B rr_min_io_rq
-Number of I/O requests to route to a path before switching to the next in the
-same path group. This is only for \fIRequest\fR based multipath and
-only apply to \fIround-robin\fR path_selector.
-.RS
-.TP
-The default is: \fB1\fR
-.RE
+(Deprecated since kernel 4.6) This option is not supported anymore, and will be ignored.
 .
 .
 .TP
@@ -634,16 +621,7 @@ The default is: \fBmax\fR
 .
 .TP
 .B rr_weight
-If set to \fIpriorities\fR the multipath configurator will assign path weights
-as "path prio * rr_min_io". Possible values are
-.I priorities
-or
-.I uniform .
-Only apply to \fIround-robin\fR path_selector.
-.RS
-.TP
-The default is: \fBuniform\fR
-.RE
+(Deprecated since kernel 4.6) This option is not supported anymore, and will be ignored.
 .
 .
 .TP
@@ -821,28 +799,16 @@ The default is: \fB<unset>\fR
 .TP
 .B bindings_file
 (Deprecated) This option is not supported anymore, and will be ignored.
-.RS
-.TP
-The compiled-in value is: \fB@STATE_DIR@/bindings\fR
-.RE
 .
 .
 .TP
 .B wwids_file
 (Deprecated) This option is not supported anymore, and will be ignored.
-.RS
-.TP
-The compiled-in value is: \fB@STATE_DIR@/wwids\fR
-.RE
 .
 .
 .TP
 .B prkeys_file
 (Deprecated) This option is not supported anymore, and will be ignored.
-.RS
-.TP
-The compiled-in value is: \fB@STATE_DIR@/prkeys\fR
-.RE
 .
 .
 .TP
@@ -1008,10 +974,6 @@ The default is: \fB<unset>\fR
 .TP
 .B config_dir
 (Deprecated) This option is not supported anymore, and will be ignored.
-.RS
-.TP
-The compiled-in value is: \fB@CONFIGDIR@\fR
-.RE
 .
 .
 .TP
@@ -1324,7 +1286,6 @@ The default is: \fBno\fR
 .TP
 .B disable_changed_wwids
 (Deprecated) This option is not supported anymore, and will be ignored.
-.RE
 .
 .
 .TP
@@ -1580,14 +1541,8 @@ section:
 .TP
 .B failback
 .TP
-.B rr_weight
-.TP
 .B no_path_retry
 .TP
-.B rr_min_io
-.TP
-.B rr_min_io_rq
-.TP
 .B flush_on_last_del
 .TP
 .B features
@@ -1769,14 +1724,8 @@ section:
 .TP
 .B failback
 .TP
-.B rr_weight
-.TP
 .B no_path_retry
 .TP
-.B rr_min_io
-.TP
-.B rr_min_io_rq
-.TP
 .B fast_io_fail_tmo
 .TP
 .B dev_loss_tmo
@@ -1855,14 +1804,8 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B failback
 .TP
-.B rr_weight
-.TP
 .B no_path_retry
 .TP
-.B rr_min_io
-.TP
-.B rr_min_io_rq
-.TP
 .B flush_on_last_del
 .TP
 .B fast_io_fail_tmo
-- 
2.54.0


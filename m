Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0647325A2A2
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 09:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760088137; cv=none; b=CZrPQxP20Y1oQ7AfE+XHkcuCEYt3AFW//jnmkKh6iAs4wVwOkTjg6OC3+D0Ga6DKTZvVL5RFgbs6FsPre4jTxKpC6dsuXT5A0VvAS7rL0fAjimc/Yks1G+YX8thEteOE+pv6ZZaQDtaFhZ4ulUQgH3IbNKlQ0eO9u1Ej653dVcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760088137; c=relaxed/simple;
	bh=EiLM/giUBjkHJ32+ISHFoLBOVABZOKfA0fdIDO7mEj0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V4kOXFKnuHrep5WzGN2tKbR+Z9NvrjbyfaTZ4TYfas0Pp2HK4iSDbYhBNgXNGRCKG7extlvFTqpHQ5peGBEJE1G7JLOYg7MqOgRWKact7fUSD/oyN58BMLxsCcWOU8LNE1nTADHfwN0w1iYklspnxhiRPsVYL4Un5FZZGQO6kwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UpNeKfsY; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UpNeKfsY"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e38bd65faso2527545e9.2
        for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 02:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760088133; x=1760692933; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d/3OUiDSq/T91WowevV56U/kD7TsqwxczzR6gtUk49k=;
        b=UpNeKfsYhIdZ1xZad3Z6u3jNnXMkMWeDp1h08TatdzrR3r9EVFq2wX++5s68M0ywjE
         zLOHBjU9CwW4dAl5E7WLp/VJv3hg+vTzdEXjJ5T9LSMAxOup/eSoVEG161RvTjy0jKhU
         g9rc0c/VdXDqdysIeV54SUGjWUjJY8Jaq89lB+Z22v3UT8rg0tXfjL4ajuDjU2SbfzqA
         U1V7gxyDiXEa2ecjmeo94P71KgybYyq69hjy7QqYceeWV4b+JNejDBlCUG4V4SzAkvu2
         omDM4MrrtL/Dc0OHTE2vKr3VvmlNehNy2SIZ4XdWa/3Miow2hafKajAGnENuVWZ5vCuH
         a6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760088133; x=1760692933;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d/3OUiDSq/T91WowevV56U/kD7TsqwxczzR6gtUk49k=;
        b=Ka5b0We7bh0P9MPO05UEczt3Y95OW6l0Thf8H9+nqXMqh2r7EfpH80Axwfp8aRO+Ig
         Nf+77PJbbWXXKM0bnr4VAHJ5sIIAk2SEijEkidZNxapuEkSXBDIB9dVWpn0m0PFAktXS
         Cm9VknrBVJGYu4bRzg8SBv0bbuOrc1TuBktyztVzvD+5TMHGsldyYEOY3SuSDQL2YUAu
         Gs6tQXC63Y2WYZe9DZJhM4uUvfFpd4f25mbouqIJUAYdCisgV6575qFrZ//FF7Km41VZ
         FBzoNb3gi9DJnMR1SNfO3K1nYjdNa/gp59XvYuOAtr41w9OMBXj1ywd7kOC4zfaP4uY0
         c7iQ==
X-Forwarded-Encrypted: i=1; AJvYcCUStnpedIq0eL9GpK86GKnjnJHhA7MH7wbP8yIWu8Gwi9DVmdiJQ+FcrUJ6e7gXNi/2xERBmL4miw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwQAlFpy2lousv0xRZW+U7Ol+3LAM0lEPSxPPC51r/iLs13NTpe
	r6pgwmOwMy+2/iPYrdHGN8fXH6QX6s8JNiTVq+hc0s04JAB/cvJPzxs=
X-Gm-Gg: ASbGnctfymwMwhW2o8mVRmRNPgMa8wC7YaA8rwPN7yf7tqWQTfKtN8A43xlqsHGRPwd
	3cfKkNXhE2QTkN7xNjV9fl5aWJneT/kDH4I+fTzZm7CcMqhnk/cW9x8psTr0euBVJ89vh5gfbnI
	8AW5DHJN4Sw2oB0wnyOYB0i1Uv6674GRn4DKgCkT1y/123QIM7Izri1nQrfaAMrix0V+8zikRzv
	8yHJVmKQ8KXIXfWgakksKf+9BC9OLRK3ocuL9M8Ce+jo/KjelvPd/loqC5sxAdd6V/6md3MhI3c
	0lQBakLp7r4RRiePAFtwrbp7yu2xEnh7Xoya50c7CkWCL+EJdNMvb0Cjf+QkfEvkdTfk7Bwr+FQ
	5fTuTThXisT5cB1bnnaTOQabT+jxcfs/lHrq0dT7sfxZUDDwPpWDuCFPXcQIoOPSPhIpdb0Pvbv
	I0aE8a2rDdqA==
X-Google-Smtp-Source: AGHT+IHomxHiPjvf2CFnrlvzp8W+RmyykhU7rIkk9ZkZEY/ztTuv3p6ITr5dtIAygtdA/rhHGwXlBA==
X-Received: by 2002:a05:600c:354f:b0:46e:477c:e4ff with SMTP id 5b1f17b1804b1-46fa9b17294mr42372965e9.7.1760088132779;
        Fri, 10 Oct 2025 02:22:12 -0700 (PDT)
Received: from localhost (120.red-80-39-141.dynamicip.rima-tde.net. [80.39.141.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce583424sm3197504f8f.21.2025.10.10.02.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 02:22:12 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 1/2] multipath-tools: fix mandoc errors in man pages
Date: Fri, 10 Oct 2025 11:22:07 +0200
Message-ID: <20251010092211.57426-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Output of: mandoc -W all -T lint man_page.X | grep -v "STYLE: input text line longer than 80 bytes"

mandoc: ./libmpathpersist/mpath_persistent_reserve_in.3:26:2: WARNING: skipping paragraph macro: PP empty

mandoc: ./libmpathpersist/mpath_persistent_reserve_out.3:26:2: WARNING: skipping paragraph macro: PP empty

mandoc: ./mpathpersist/mpathpersist.8.in:176:2: WARNING: skipping paragraph macro: PP after SH
mandoc: ./mpathpersist/mpathpersist.8.in:219:2: WARNING: skipping paragraph macro: PP after SH

mandoc: ./multipath/multipath.conf.5.in:93:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./multipath/multipath.conf.5.in:134:2: ERROR: skipping end of block that is not open: RE
mandoc: ./multipath/multipath.conf.5.in:134:2: WARNING: skipping paragraph macro: br at the end of SH
mandoc: ./multipath/multipath.conf.5.in:135:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./multipath/multipath.conf.5.in:1311:2: ERROR: skipping end of block that is not open: RE
mandoc: ./multipath/multipath.conf.5.in:1610:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./multipath/multipath.conf.5.in:1807:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./multipath/multipath.conf.5.in:2020:2: ERROR: skipping end of block that is not open: RE

mandoc: ./multipathd/multipathc.8:23:15: STYLE: whitespace at end of input line

mandoc: ./multipathd/multipathd.8.in:571:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./multipathd/multipathd.8.in:691:2: ERROR: skipping end of block that is not open: RE

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/mpath_persistent_reserve_in.3  | 1 -
 libmpathpersist/mpath_persistent_reserve_out.3 | 1 -
 mpathpersist/mpathpersist.8.in                 | 2 --
 multipath/multipath.conf.5.in                  | 7 -------
 multipathd/multipathc.8                        | 2 +-
 multipathd/multipathd.8.in                     | 4 +---
 6 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index 4ac43fa3..6d7fe129 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -23,7 +23,6 @@ mpath_persistent_reserve_in \- send PRIN command to DM device
 .B #include <mpath_persist.h>
 .P
 .BI "int mpath_persistent_reserve_in" "(int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)"
-.P
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index 3dbeae1f..f49bf444 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -23,7 +23,6 @@ mpath_persistent_reserve_out \- send PROUT command to DM device
 .B #include <mpath_persist.h>
 .P
 .BI "int mpath_persistent_reserve_out" "(int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)"
-.P
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/mpathpersist/mpathpersist.8.in b/mpathpersist/mpathpersist.8.in
index fecef0d6..62f3c5b0 100644
--- a/mpathpersist/mpathpersist.8.in
+++ b/mpathpersist/mpathpersist.8.in
@@ -173,7 +173,6 @@ PR In: maximum allocation length. LEN is a decimal number between 0 and 8192.
 .SH EXAMPLE
 .\" ----------------------------------------------------------------------------
 .
-.PP
 Register the key \(dq123abc\(dq for the /dev/mapper/mpath9 device:
 .RS
 \fBmpathpersist --out --register --param-sark=\fI123abc /dev/mapper/mpath9\fR
@@ -216,7 +215,6 @@ Remove current reservation, and unregister all registered keys from all I_T nexu
 .SH BATCH FILES
 .\" ----------------------------------------------------------------------------
 .
-.PP
 The option \fI--batch-file\fR (\fI-f\fR) sets an input file to be processed
 by \fBmpathpersist\fR. Grouping commands in batch files can provide a speed
 improvement in particular on large installments, because \fBmpathpersist\fR
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 3c9ae097..c7e944c0 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -92,7 +92,6 @@ the indentation shown in the above example is helpful for human readers but
 not mandatory.
 .LP
 .
-.LP
 .B Note on regular expressions:
 The \fI@CONFIGFILE@\fR syntax allows many attribute values to be specified as POSIX
 Extended Regular Expressions (see \fBregex\fR(7)). These regular expressions
@@ -131,8 +130,6 @@ vendor, product, and revision.
 .B overrides
 This section defines values for attributes that should override the
 device-specific settings for all devices.
-.RE
-.LP
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -1308,7 +1305,6 @@ The default is: \fBno\fR
 .TP
 .B disable_changed_wwids
 (Deprecated) This option is not supported anymore, and will be ignored.
-.RE
 .
 .
 .TP
@@ -1607,7 +1603,6 @@ section:
 .B ghost_delay
 .RE
 .PD
-.LP
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -1804,7 +1799,6 @@ section:
 .B all_tg_pt
 .RE
 .PD
-.LP
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -2017,7 +2011,6 @@ as integrity failures or congestion with so-called Fabric Performance
 Impact Notifications (FPINs).On receiving the fpin notifications through ELS
 multipathd will move the affected path and port states to marginal.
 .
-.RE
 .LP
 See the documentation
 of the individual options above for details.
diff --git a/multipathd/multipathc.8 b/multipathd/multipathc.8
index cf7ae5be..3396576b 100644
--- a/multipathd/multipathc.8
+++ b/multipathd/multipathc.8
@@ -20,7 +20,7 @@ multipathc \- Interactive client for multipathd
 .SH SYNOPSIS
 .\" ----------------------------------------------------------------------------
 .
-.B multipathc 
+.B multipathc
 .RB [\|
 .IR timeout
 .RB \|]
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 8815e099..2aaec2f2 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -568,7 +568,6 @@ The device appears usable, but it being delayed for marginal path checking.
 .I undef
 The device either is not part of a multipath device, or its path checker has
 not yet run.
-.PP
 .RE
 .TP
 .B %s
@@ -687,8 +686,7 @@ Overrides the \fImax_fds\fR configuration setting.
 .
 .BR multipathc (8),
 .BR multipath (8),
-.BR kpartx (8)
-.RE
+.BR kpartx (8),
 .BR sd_notify (3),
 .BR systemd.service (5).
 .
-- 
2.51.0


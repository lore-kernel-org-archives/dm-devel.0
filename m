Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FB7212564
	for <dm-devel@lists.linux.dev>; Sun,  7 Jun 2026 10:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828722; cv=none; b=R+5Dwz+v4bnihuDcwp5Gedm7o41zT7JJLWaDxSjnAXMkquIc7oYUtQ/hsLMxyjxTq9Y8adtHzgmF1KNRypC9f5xHHOTtHgWJarY/SYblISFKYel4ibbxTHPWSVFf2NjQUt8DD+sY2PzX9zmjysxripD+mZJedSND7nx+Z/gTuec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828722; c=relaxed/simple;
	bh=jCeG3MmW3w3jDf6sVFt0xB9B/ZtApvwqLOF2YmPzmFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbYiwxMtmnNIVHkJLBdwiMIA6M8ACmwnh6NGnKW60BWORYnhD6xiHMuEZ5QxR1eH96xaEqzzTN5kpcyWuQZmMbWRifFqwD+rJTycEJLdEo/meLUhugWueTa8RcXXKRPWWh6W0K7x2LWQZuHTlOgdxOQ24loUo5dBXP8sUwEQMI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fpgJl+1Z; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fpgJl+1Z"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490c28f84fdso4310495e9.0
        for <dm-devel@lists.linux.dev>; Sun, 07 Jun 2026 03:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780828719; x=1781433519; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X020RibPCNJA4nnS/DkZoMEizWj30GZTc24UrztNoMI=;
        b=fpgJl+1ZZIRU86+ME+Qc3lyVOE2xd8ZxHL13e2oy5EfB/K8KdCUeFvd0eH2wmXwoou
         m3dCl3AN+fHzZ/FtKw9zUu8xcVJQqIfo3uUKjqgsy5MCkaBwWTrGvCfq7xHJV0kXfbxI
         mCHaIBdwi7CfPNAHq+xt5umzfT4vv9VfRezGwREEa4EIvm+wIZ/ULFC6zj8pilzf12C8
         OAT2Ivb6Apn79imHuFRhCwi2qZjQs1IUsfJ0WQWo8PEAVSqWxqZtoCE7Vo7acKR2PAZL
         yky2AT+wlADAPli3qrU9hwhWtbPiQcilF2OeJDsKtAMI4qmO/3mHZBQBJGYyQ0EErkYt
         +/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780828719; x=1781433519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X020RibPCNJA4nnS/DkZoMEizWj30GZTc24UrztNoMI=;
        b=MkoyZJf/ckwoasPh8bWbud8JuiGhuj6wRPlqD0vPUnoYk5y8Xvgj7fg2cNxpdzMFUV
         OH7lh/mpjYlTbmmmWEasCC3km6+PJWhwAqmBs6D6i0GmoiylrgLSSno4j08J/5jwAgwv
         vMldg06HIl8LTfuOVaUbua5MJdTzx1t6PSkzK5JEHx3XBGJfZYdlJy1zgCFl6HvTejTD
         xv7B3sJTiQakmrvCgGjkIBvrSd6Hsuj8fwHQcS6Zbw293ta4wllh6wMdoTUD17FEZz0W
         BeKTUcUZ/xz7cvLMjO34b7GSmnr4H/upjYSYds9P5jPCJedVqs8e4xQj7IR2bP4kLYq5
         rFuw==
X-Forwarded-Encrypted: i=1; AFNElJ+O9Qrs18tS2BH5mw0kiWJzCobXEx1/hoaKDb4YGl6Ani8Cf2xQCjkF70+9qXIqipmMEOVdoBrYqQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwawQA5vWkLCU8r4N2GPa8mIvBEhRp33w47K8bcQDEU2caMuDUo
	QfUZiEEQhAny+hgBy4FZo3oI7YL8JeA1oSXmeDbj9V+RviEdkJYlR38=
X-Gm-Gg: Acq92OEAgzReHpJKsLp6yZZGq1EBzjMrZqypjdY6HMSmx+7Kow5Cl72AbGuZaFkyzCC
	GFEvA5b+16kaU50oc3wxE2M0wFEGKvGFo8x1+FnQHbiIJ6S8E8UwMed64qMWxcb4ms3dYigSlKv
	WWQEBRSg3IFlP0FyA4eKbABVIVSH9x7Avh8DWSUvW8Sl0NjXC6MbkaKbgIhqEX1yIymyqfQGFCN
	AiLFUeH7rxQc3kjzKBJhh7oEPVcdarqlvFGLmsyDWbZ25MO/Dfb1wqKJUNAHz6eRfEKuxB7YGZw
	2gb7rYEzMIT764+yky7VVYpufeuZ2AtH/ohZTeO9U4VERvn88S3nGPU8ilp9/SaxVFsYMUPSP32
	eL59b6kFooRXDU/x8+bFLTUx+p731gg8YcppmL8NSTsKBSn6k5VFoAXCTulxRG9w+UrwVXLbA6Q
	KVaryc9bakWH1CpF5sgPU7qlaQjFTUWlI9ZS9Hs+i5CR1qAfWl2M/w8wKc6r/ZqhwKo/RvnyQ=
X-Received: by 2002:a05:6000:298d:10b0:456:3af2:852e with SMTP id ffacd0b85a97d-460302dc63cmr4965468f8f.1.1780828718909;
        Sun, 07 Jun 2026 03:38:38 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f368e9fsm41428034f8f.37.2026.06.07.03.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 03:38:38 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 3/3] multipath-tools: remove explicit widths from macros in the remaining man pages
Date: Sun,  7 Jun 2026 12:38:23 +0200
Message-ID: <20260607103831.336833-4-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607103831.336833-1-xose.vazquez@gmail.com>
References: <20260607103831.336833-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

This allows man/groff to calculate the width automatically, preventing
excessive whitespace and improving readability on various terminal sizes.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/mpath_persistent_reserve_in.3  |  4 ++--
 libmpathpersist/mpath_persistent_reserve_out.3 |  4 ++--
 mpathpersist/mpathpersist.8.in                 |  2 +-
 multipath/multipath.8.in                       |  6 +++---
 multipath/multipath.conf.5.in                  | 10 +++++-----
 multipathd/multipathd.8.in                     |  9 ++++-----
 6 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index 4ac43fa3..871242d5 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -35,7 +35,7 @@ the DM device and gets the response.
 .TP
 .B Parameters:
 .RS
-.TP 12
+.TP
 .I fd
 The file descriptor of a multipath device. Input argument.
 .TP
@@ -57,7 +57,7 @@ Set verbosity level. Input argument. value:[0-3]. 0->Errors, 1->Warnings, 2->Inf
 .SH RETURNS
 .\" ----------------------------------------------------------------------------
 .
-.TP 12
+.TP
 .B MPATH_PR_SUCCESS
 If PR command successful.
 .TP
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index ab1f923e..bf44777c 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -35,7 +35,7 @@ the DM device and gets the response.
 .TP
 .B Parameters:
 .RS
-.TP 12
+.TP
 .I fd
 The file descriptor of a multipath device. Input argument.
 .TP
@@ -74,7 +74,7 @@ Set verbosity level. Input argument. value: 0 to 3. 0->Errors, 1->Warnings, 2->I
 .SH RETURNS
 .\" ----------------------------------------------------------------------------
 .
-.TP 12
+.TP
 .B MPATH_PR_SUCCESS
 If PR command successful else returns any one of the status mentioned below.
 .TP
diff --git a/mpathpersist/mpathpersist.8.in b/mpathpersist/mpathpersist.8.in
index fecef0d6..9a5a716b 100644
--- a/mpathpersist/mpathpersist.8.in
+++ b/mpathpersist/mpathpersist.8.in
@@ -50,7 +50,7 @@ various options.
 .BI \-verbose|\-v " level"
 Verbosity:
 .RS
-.TP 5
+.TP
 .I 0
 Critical messages.
 .TP
diff --git a/multipath/multipath.8.in b/multipath/multipath.8.in
index b88e9a4c..0b170101 100644
--- a/multipath/multipath.8.in
+++ b/multipath/multipath.8.in
@@ -100,7 +100,7 @@ The \fBdevice\fR argument restricts \fBmultipath\fR's operation to devices match
 expression. The argument may refer either to a multipath map or to
 its components ("paths"). The expression may be in one of the following formats:
 .
-.TP 1.4i
+.TP
 .B device node
 file name of a device node, e.g. \fI/dev/dm-10\fR or \fI/dev/sda\fR. If the node refers
 to an existing device mapper device representing a multipath map, this selects
@@ -195,8 +195,8 @@ creating \fI@CONFIGFILE@\fR.
 .BI \-v " level"
 Verbosity of information printed to stdout in default and "list" operation
 modes. The default level is \fI-v 2\fR.
-.RS 1.2i
-.TP 1.2i
+.RS
+.TP
 .I 0
 Nothing is printed.
 .TP
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index ef08ed2b..6990d2bf 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1527,7 +1527,7 @@ the same WWID in the \fIbindings_file\fR.
 The following attributes are optional; if not set the default values
 are taken from the \fIoverrides\fR, \fIdevices\fR, or \fIdefaults\fR
 section:
-.sp 1
+.sp
 .PD .1v
 .RS
 .TP
@@ -1704,7 +1704,7 @@ has no effect.
 The following attributes are optional; if not set the default values
 are taken from the \fIdefaults\fR
 section:
-.sp 1
+.sp
 .PD .1v
 .RS
 .TP
@@ -1782,7 +1782,7 @@ section:
 .
 The overrides section recognizes the following optional attributes; if not set
 the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
-.sp 1
+.sp
 .PD .1v
 .RS
 .TP
@@ -1878,7 +1878,7 @@ exactly. The protocol that a path is using can be viewed by running
 .LP
 The following attributes are optional; if not set, the default values are taken
 from the \fIoverrides\fR, \fIdevices\fR, or \fIdefaults\fR section:
-.sp 1
+.sp
 .PD .1v
 .RS
 .TP
@@ -1969,7 +1969,7 @@ increase and the threshold is never reached. Ticks are the time between
 path checks by multipathd, which is variable and controlled by the
 \fIpolling_interval\fR and \fImax_polling_interval\fR parameters.
 .
-.RS 8
+.RS
 .LP
 This algorithm is superseded by the \(dqmarginal_path\(dq failure tracking,
 but remains supported for backward compatibility.
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 38a243e3..d766dc65 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -416,7 +416,7 @@ appropriate device information. The following wildcards are supported.
 .TP
 .B Multipath format wildcards
 .RS
-.TP 12
+.TP
 .B %n
 The device name.
 .TP
@@ -521,7 +521,7 @@ the configured one).
 .TP
 .B Path format wildcards
 .RS
-.TP 12
+.TP
 .B %w
 The device WWID (uuid).
 .TP
@@ -548,7 +548,7 @@ sysfs states, it shows "running".
 .B %T
 The multipathd path checker state of the device. The possible states are:
 .RS
-.TP 12
+.TP
 .I ready
 The device is ready to handle IO.
 .TP
@@ -693,8 +693,7 @@ Overrides the \fImax_fds\fR configuration setting.
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
2.54.0


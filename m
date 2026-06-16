Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CD5303C9C
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 12:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612961; cv=none; b=f3UkS59arA3F5FrYSgk5LJsFj/eztwKzo4p1wnPq0cnaAjDRTiG5TkXe981bhC/v3Q4XAlpzQznIEZdvZPiTrn1QV0MXWWH/IHtOi96nMbDIr+yINdki7g0p7ftYeUr21jPcp8uv9PsmiYUgpTjyIzIKJ2PIyKo7OELNY6okPkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612961; c=relaxed/simple;
	bh=jCeG3MmW3w3jDf6sVFt0xB9B/ZtApvwqLOF2YmPzmFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dS9p5Yk/rU6CyLxTE8YYeV2bl1shiGluYFCdvEjplTpNdTMEG6ok+w7vdU8NReP3Lo77LcANk9FW38/aC5PxAl4CaiNVngxzmw4npblhMuwJAIYJZ5CXc8Cdwypl7RTNhhEqiZxO2hWYUexQIQSmODoCNVVEFWznXCC3PAI2+Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CsmMBLOq; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CsmMBLOq"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-45ef74860bfso239121f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 05:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781612958; x=1782217758; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X020RibPCNJA4nnS/DkZoMEizWj30GZTc24UrztNoMI=;
        b=CsmMBLOq1BbQXspe//uJQ9pPoWYnYHGIRDNUnkhoKxZ+WLIQYg/RKD3+mIWOUhrgRO
         KJABCrlFaqOKfY/vBfW7SuJfrWmOIpPLy+Ghzstlwyk43s1ZTXkzbirqWulm+mrMI9OB
         sNS2kUs3ddcH2x2y9FxlWHtFBuPFLeE+GqHEDYb+QEPDG2WUhILdWuKN+jg0ymVC0PMy
         WxzZ1SESigU+5dKVdBDH4ZVVM9MYiE9gAn5CiSpC88JH31/dy2nAR+UVKr8OPzKrsnjk
         +WlNHsy9cwVm+TkJatNZgEuRh3TwW7RAbDkTBlr5i+Gv/9nmjVisMJ+ShZdhu7FL/xW2
         xrcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781612958; x=1782217758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X020RibPCNJA4nnS/DkZoMEizWj30GZTc24UrztNoMI=;
        b=D4yPMTQfWFjUV+OdQCVmilO8150RffefeDLm+9+vCoBplPf+MNLK+6SIyNgVAAthaA
         Z6ivMIhtY8l4aGfPylnQrBgFo0x0/Y+1Aec2EEnmjdo4UpcJoa2qmtEU8uiJNbQaWO1d
         s8vd75WBnFkO7i2Q19IfZE5mIvZyPUK2osBwRpL3c8HTZ2dP2JcdUoFn1w35VbdhackL
         GkKIo6Bq62rDkLVNg1DyAKdubcbGvLmVkhYiVs8UYgpI9O9GJyyeSHV+8hOmSPgTEJ19
         ptlslgzu9QsV2KmqVGYkDRGKDmzx6TKpUnDij/22fxMjIvjTTfbwg3O2dki2zKu5dBQt
         l8fw==
X-Forwarded-Encrypted: i=1; AFNElJ/NQmtVY8S6ALt+9Uy579OkczOoGQmADEyU9FT5wDyRKHJglhKjb91R8QnXysYb1+zWgCuGefv/Ew==@lists.linux.dev
X-Gm-Message-State: AOJu0YzbMgSeFmIPttrfe6lxdA4aNOUWxjum3fe0Jhjf1/ReEKGbUgP+
	Blbz6ptwzEU4jjMP1tUT1QAdQSsjmdaxaI1S7/NK2OSuipsDcSZLBtg=
X-Gm-Gg: Acq92OFahmziwgeTVmqNkVWqZaGJ0q7963Du/lOcYvlpKBlIAtsFirXcc5NYVRUCeUD
	/83zlESWAt19CW31gAp/Jm1KVZvTQepcnHaKZ2nr1x3fWWF+J18gM28CKLMHJ3Z/2HdH4ip12RX
	spEMI0OVrFwDJ8PWnm5nd2A9OsOEMDA9/s25290N3REq+IEgWpSPXlfyit9YZ0nZ+nzIU05szXd
	wok0h3V1eXFcqAvZpEG3XTSU2Q1LpjG8rhjra2hau/ig8igKJc6xw/SQJrod12+Yq/orymxRn4o
	HbSvXLY8x7m6oqCLTtTkanIgYKO8NRzogY6Wr0KY3BWxAS0HhUCBvNtULnLjipxeNFabc4qdaM9
	IflpIcflIr8D5XZUpY98PcaHX3faO9Te7hlMRV6j4sZEjy/fjlzsj049KDHlNH0HhUT4ff/mnP7
	1okmyPqAPJLD0b1Aj5/cOMuKFrcF8lpzOTnsrrILj8T/D2myVYknSTRV7WYUz7TGvO
X-Received: by 2002:a05:600c:c042:b0:490:a2f4:c497 with SMTP id 5b1f17b1804b1-490ec504abfmr58035555e9.7.1781612957952;
        Tue, 16 Jun 2026 05:29:17 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95b274sm421745365e9.1.2026.06.16.05.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:29:17 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 3/8] multipath-tools: remove explicit widths from macros in the remaining man pages
Date: Tue, 16 Jun 2026 14:28:59 +0200
Message-ID: <20260616122909.244619-4-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616122909.244619-1-xose.vazquez@gmail.com>
References: <20260616122909.244619-1-xose.vazquez@gmail.com>
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


Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA03395DBE
	for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 13:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781356209; cv=none; b=FdiaFh+cy5HSi9uskrofVBGaa6wB8g5W7ZR3NOA784t6Kfck1ztR/s85Bf8j2DszusmWC/aKDuaAknzS50nh0nR+lvHQ8ErFXqApy7g1pqKZnoKuxsl6WuRwtLHOvYMxB+AmEXKHZl8i56WgxTaOTA7+IRrjBUoeKTQ4Q19sxCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781356209; c=relaxed/simple;
	bh=ECBm+Jp1C8f4qQIa39bKaZbsY5dyqdVtixclBlCYNB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N43TyqwECemYqTBsxIMi+kDqx7jtDAGusxuKr/2HwsLsb/j9k29jSmII+O2KnbM3O15NBt8YCfspjWdy8rOUmKiwzta16HsfFZi6qLaHLLnBuSUrN4FCbnGi203DNlvtWcMuedzTbHdZM5W8YnjDP0KsFIrUjiknpqheQKp7dOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a7PZZFis; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7PZZFis"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490a78fbd7bso2139375e9.2
        for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 06:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781356207; x=1781961007; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yr7K4XUU1Vfs2g8JEa26ljqM6VOXFbuAjImXPsUro1Q=;
        b=a7PZZFisMQuwjzF5FcJF3gSdst2sweCmETrw7wGRrOMNBpKbDIFyaqATtZ2dOHlqq0
         FKm0IfqDgmMOExKAuGoe3KC77z1tNbr/MF0kOuua9xfsHkldN/crztxMx8HDSpoKpTXc
         h1HBeJGMu4VchYgOT3G85lDOKyqFiDoFGuF15Ior55wTpF31fc+2s76o/uGAvglh374V
         AR7vfm/V8CJ7S+sVa4yXnKEFTz6LbdK2abnPMdwQTe4I2qXUgj2JEO0/yVsABzxUsnbr
         vaYP6DkXn8JVpRAv1jas4DR/4H2BemPZ3iiV6A3RkFZjegbAwcC/N4dZH2Hx60H2I1Zl
         Xheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781356207; x=1781961007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yr7K4XUU1Vfs2g8JEa26ljqM6VOXFbuAjImXPsUro1Q=;
        b=J0eVlN5cHsSuKO+udbfK8snyUZ5o3aIN877bVYG/ltP/wrLA6qgL8xF3STilN6Sqh5
         UU69SW8xJ2Igfv+K6WfV0JJ+VMxEKcLKgCHDjJX4NnWr3OR9mjfketa4KgXfGVDyYiqA
         ew7FBRfSjH00SLNScPLmOyJk3DhHqMMQIpFJa/ykcArurI/vThhCJhSk5EZ5uWsd36h8
         lRec46tAIicPoZDOIWeiDD75FShFLj8fVjfYma7MaBo/dH/5eESG6lcuTUyWVgW1/CA5
         EdIrghOh/n3j86F7ewfWgjGu5FM8dWS5xNZytw8howFhOiqG34xqE7hjjykfN0DOLz0p
         Dtiw==
X-Forwarded-Encrypted: i=1; AFNElJ+JUYW1pwa41+KGv9sh9/vOkrDw0pDL8kjUQl183sT5WbsbgBtcN9ypiNVjvgvg3FEUtfix/DFufg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzBs0OsYIkR0z4t+1ZJDEX79uqSb5qIEDA+MK3sCHqKl/D4nn7H
	0I9J0ajZqn0NEWedVqEo7RHC8euDp9/EiK/INAbUeuL1rHQElHa9kjY=
X-Gm-Gg: Acq92OE8XNNytkFarqdRZmEehinIzDbnBNcn1XNXxcQQGzR0bc0rOWH8s14LydmVV88
	JTw5wOGJ3WYjz+t7mlf0Bzm8DHQtFyNSBPO4tDvlwdMcy/R4AxV81VcaaY1Q+vUweqQE6cDroRl
	i5QNusFuBip8JwEAlXpMT3gPbI31f6ZBmU8iLVkCEw2pxxWkOdaFAWNYgGt2HNOqgF1smN28vDf
	1idFsD1ZNuJswVyljQM5vsuKzVO/CaOGXBJ4/11WABICXGGdLaS2H4eZo70Zj2jrf75lvHkcwDO
	FCdZR2JAKtOzwbFuhuLIri0FmLHNT9VNmmh7RvnxqkYf7i6xHR3MQlAwqPLP9pTtPhHkU0ozN3R
	/rWypg6LtPsK7s2pwntFBmAg9cNgXFBBnDjazFC4287MWcqlDfQDXvczHakfMhyfMwJyitz6Z4d
	ry/Zz1cQ3yYtVxaSFtR80E6tStO8Gmo/Icd87vkx2zpX74kVE4TIbGLe1OYmT+jjZz
X-Received: by 2002:a05:600c:3550:b0:490:b4d4:5c16 with SMTP id 5b1f17b1804b1-490ec5320eemr45691165e9.8.1781356206510;
        Sat, 13 Jun 2026 06:10:06 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492202e5cbasm65017075e9.2.2026.06.13.06.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 06:10:06 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 3/5] multipath-tools: specify file paths using variables and add FILES section in multipath.conf.5
Date: Sat, 13 Jun 2026 15:09:58 +0200
Message-ID: <20260613131002.144263-4-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613131002.144263-1-xose.vazquez@gmail.com>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Replace hardcoded file name references with their dynamic build variables.
Also, add a dedicated FILES section at the end of the man page to clearly
document configuration files/dirs.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5.in | 55 ++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 287441bd..9289b244 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -27,7 +27,7 @@ or \fBmultipathd show config\fR command.
 .
 .PP
 Additional configuration can be made in drop-in files under
-.B @CONFIGDIR@.
+.BR @CONFIGDIR@/ .
 Files ending in \fI.conf\fR in this directory are read
 in alphabetical order, after reading \fI@CONFIGFILE@\fR.
 They use the same syntax as \fI@CONFIGFILE@\fR itself,
@@ -831,11 +831,11 @@ to the end of the reservation key.
 .RS
 .PP
 Alternatively, this can be set to \fBfile\fR, which will store the RESERVATION
-KEY registered by mpathpersist in the \fIprkeys_file\fR. multipathd will then
-use this key to register additional paths as they appear.  When the
+KEY registered by mpathpersist in the \fI@STATE_DIR@/prkeys\fR file. multipathd
+will then use this key to register additional paths as they appear. When the
 registration is removed, the RESERVATION KEY is removed from the
-\fIprkeys_file\fR. The prkeys file will automatically keep track of whether
-the key was registered with \fI--param-aptpl\fR.
+\fI@STATE_DIR@/prkeys\fR file. The prkeys file will automatically keep track of
+whether the key was registered with \fI--param-aptpl\fR.
 .TP
 The default is: \fB<unset>\fR
 .RE
@@ -1152,9 +1152,9 @@ detects a new device. The following values are possible:
 .I strict
 Both multipath and multipathd treat only such devices as multipath devices
 which have been part of a multipath map previously, and which are therefore
-listed in the \fBwwids_file\fR. Users can manually set up multipath maps using the
-\fBmultipathd add map\fR command. Once set up manually, the map is
-remembered in the wwids file and will be set up automatically in the future.
+listed in the \fI@STATE_DIR@/wwids\fR file. Users can manually set up multipath
+maps using the \fBmultipathd add map\fR command. Once set up manually, the map is
+remembered in the WWIDs file and will be set up automatically in the future.
 .TP
 .I off
 Multipath behaves like \fBstrict\fR. Multipathd behaves like \fBgreedy\fR.
@@ -1513,8 +1513,8 @@ this is \fBnot\fR a regular expression or a substring; WWIDs must match
 exactly inside the multipaths section.
 .TP
 .B alias
-Symbolic name for the multipath map. This takes precedence over a an entry for
-the same WWID in the \fIbindings_file\fR.
+Symbolic name for the multipath map. This takes precedence over an entry for
+the same WWID in the \fI@STATE_DIR@/bindings\fR file.
 .LP
 .
 .
@@ -1598,9 +1598,9 @@ for more than 100 known multipath-capable storage devices. The devices section
 can be used to override these settings. If there are multiple matches for a
 given device, the attributes of all matching entries are applied to it.
 If an attribute is specified in several matching device subsections,
-later entries take precedence. Thus, entries in files under \fIconfig_dir\fR (in
-reverse alphabetical order) have the highest precedence, followed by entries
-in \fI@CONFIGFILE@\fR; the built-in hardware table has the lowest
+later entries take precedence. Thus, entries in files under the \fI@CONFIGDIR@/\fR
+directory (in reverse alphabetical order) have the highest precedence, followed
+by entries in \fI@CONFIGFILE@\fR; the built-in hardware table has the lowest
 precedence. Inside a configuration file, later entries have higher precedence
 than earlier ones.
 .LP
@@ -2028,6 +2028,35 @@ specified the order of precedence is \fIno_path_retry, queue_if_no_path, dev_los
 .
 .
 .\" ----------------------------------------------------------------------------
+.SH "FILES"
+.\" ----------------------------------------------------------------------------
+.
+Default paths for configuration files and directories:
+.TP
+.I @CONFIGFILE@
+Main configuration file.
+.TP
+.I @CONFIGDIR@/
+Directory for configuration drop-in files.
+.TP
+.I @STATE_DIR@/bindings
+Bindings file, used when the \fBuser_friendly_names\fR option is set to
+\fByes\fR to assign a persistent and unique alias to each multipath device.
+.TP
+.I @STATE_DIR@/prkeys
+Persistent reservation keys file, used by multipathd to keep track of the
+reservation key used for a specific WWID when \fBreservation_key\fR is set
+to \fBfile\fR.
+.TP
+.I @STATE_DIR@/wwids
+WWIDs file, used by multipath to keep track of the WWIDs of LUNs for which
+multipath devices have been created in the past.
+.TP
+.I @RUNTIME_DIR@/multipathd.pid
+PID file.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH "SEE ALSO"
 .\" ----------------------------------------------------------------------------
 .
-- 
2.54.0


Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E1135E1B9
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 12:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612960; cv=none; b=TpojqD+3A7uGnmUC55cD/EVGxYTr9/sd1G4xH0XDvG3Iila8UyXyCHU3Z9Qs0ZZ/LGyNB0On7xEsbK9PQlMrVgqBbycxWH4Q60sSsgHh/eQ0Q1nnQMLpCd2iDbzTLzWECe5/UJoBTaGKPBgmFTz7QW3MVUf/S+fuw34KEa5v45c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612960; c=relaxed/simple;
	bh=D4HmTwvaZpFloSCIAg2OWDEC2MjPIYdBkLXO+h9L6aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWIrFCgYYU0rhE9TUDs0GN27Y6e3suYI+wha9P9U/7uRckWPRTOgSwYpjFYBL0f4xUkViPKeBD5sEs1rQEJW/7ktJ9iMfxbNNc1AnW7I3XktY4FAN/WBrZQC/yS2bNAqQOg9+UA683GzrK/t1K0+9fzKMCOh1CL+WKPUaPX9/fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bxAQtFZS; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxAQtFZS"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490a767521dso3440195e9.1
        for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 05:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781612957; x=1782217757; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zANJzgaOceE3XJAdkvJlLwYtm4O+EYkTvINlGBXXUmU=;
        b=bxAQtFZSKG8Xktx28rF6T3n70mjZN5mD/Z3rtsS5KV1p91ZQoJSqIeA3jyYXuBdPXT
         ilZLBcdMzGQJ6c3ib4tmQtViaDFS1E//NBRjo8MqYMuwEVSwiaq46EcFvUod3uf2lwsp
         nPi0acABukrOcaaghZtEKfFBLNI2lmXpdF4FJYAF8KxLVn/uEvfFPFLJTtLzPJO8w+q+
         xM5dORulNSnJmUsKXi7misgZ1jK29uMjrb7mUEAh/pMn+qslU8pqg75/Y5LEvt9Hr1QW
         s1wt3dOLD1ScdplHH0NrGSagjOZjAhqb1kGWXaMbaKCTMQ5E4Wwgw88mKe3nifx7KTt/
         /LbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781612957; x=1782217757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zANJzgaOceE3XJAdkvJlLwYtm4O+EYkTvINlGBXXUmU=;
        b=gffEHIqiB3cr2g0JhGbYaG47fm6FNSzLGkxL0Vb7763fKIosmBcGmo69c9d7Vy3dHM
         GPmMROAbwXbzm0a5b9MEAAHu2bL0PGfwNI4kGXdnky5qyNAowMlLKw9vhFZm0pWMRSlT
         EGvxjj/o8AuxmT7AiudKo+t4iiVA/DouBr0rH97EEY0i6zRC1RmqOf1JMp/lSBuV7WVA
         pWX/3Pi67vHEU8Ux5BgCG4YFIUOXTTxMvqFNrwAynE6sgNAEs1PgC/VskAKEuJm/DTpG
         wrAuZ68aLY4G54j5aF0Ujt+7FslMO9TCZwlI3jwSUUK7APOMPvT+Sx7NdPdCQ0ht3Ekl
         FgDg==
X-Forwarded-Encrypted: i=1; AFNElJ/qGY0oI43S+9/QwZ/8zEQ4xj4dNW7gHE0g2ug85pphUwhqJtYPldBKz57A1Ale1xRdycbMooP9Qw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzUFjJPnUilzD815L0+5zm6MyYHOR11vzSZQKKKQtTlzX7P4TK7
	LGEX1CPItNa7noC2+0ST4UJR80NpKm1glcU2IaZ/EHSfXI+rzM7YBqg=
X-Gm-Gg: Acq92OFfYsDtVgBqsomX2AeYxZnRKnKBuicIXLZbMsYnsAx2AxPDFvMfbOssZ3vlLfg
	T81poM31HkBYFfi8OyI1pi3BpP7yFyOE1b/zUw0Os5Mgn5XPblMZ+AECf8WO4agboPmjb5yRZWk
	knl6MGhfqHiQAe+M54xc1Q8cZgCXswRrRBlI4Z3mhuxrtNal7yW/Wz2LQuHjyPvqrViNiQsfMJP
	aE8Oav4WngcSbTNhTdpL3IKdL7CwnejyhStJZcux4qjZkmKvwJN8RRLYNRJ12MicIwm+pnGE1TR
	1Ftwi48dQWxL1F71S1lIoXPQHlk02RNYiNwzo7s5sk2tE59aGh6dcXX7dkkdq2iu3taZGDq55ew
	G97JJnmZHIYAAWpwD+9H/oJ70ax0IaTKxUzQCgBWfOgkgetPcTcMY35DtoFn0sZywnM4gNaBlbX
	TmELKQDMJ5A2G+20UD/GCM/aUb+wNZinlQF5scaNPKRy27/N49gtj/tvFDL8tfLoA+
X-Received: by 2002:a05:600c:2a93:b0:490:e190:39b1 with SMTP id 5b1f17b1804b1-490ec50a6ecmr85780365e9.7.1781612956765;
        Tue, 16 Jun 2026 05:29:16 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a96b47sm49956195e9.13.2026.06.16.05.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:29:16 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 2/8] multipath-tools: remove explicit width from .TP macros in multipath.conf.5
Date: Tue, 16 Jun 2026 14:28:58 +0200
Message-ID: <20260616122909.244619-3-xose.vazquez@gmail.com>
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
 multipath/multipath.conf.5.in | 56 +++++++++++++++++------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index e3a9811c..ef08ed2b 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -103,7 +103,7 @@ matches, standard regular expression syntax using the special characters "^" and
 .LP
 .
 The following \fIsection\fP keywords are recognized:
-.TP 17
+.TP
 .B defaults
 This section defines default values for attributes which are used
 whenever no values are given in the appropriate device or multipath
@@ -142,7 +142,7 @@ device-specific settings for all devices.
 The \fIdefaults\fR section recognizes the following keywords:
 .
 .
-.TP 17
+.TP
 .B verbosity
 Default verbosity. Higher values increase the verbosity level. Valid
 levels are between 0 and 6.
@@ -195,7 +195,7 @@ The default is: \fBno\fR
 The default path selector algorithm to use; they are offered by the
 kernel multipath target:
 .RS
-.TP 12
+.TP
 .I "round-robin 0"
 Choose the path for the next bunch of I/O by looping through every path in the
 path group, sending \fBthe same number of I/O requests\fR to each path.
@@ -223,7 +223,7 @@ The default is: \fBservice-time 0\fR
 (Hardware-dependent) The default path grouping policy to apply to unspecified
 multipaths. Possible values are:
 .RS
-.TP 12
+.TP
 .I failover
 One path per priority group.
 .TP
@@ -333,7 +333,7 @@ of this path. Higher number have a higher priority.
 \fI"none"\fR is a valid value. Currently the following path priority routines
 are implemented:
 .RS
-.TP 12
+.TP
 .I const
 Return a constant priority of \fI1\fR.
 .TP
@@ -408,12 +408,12 @@ NetAPP E/EF Series, where it is \fBalua\fR). If \fBdetect_prio\fR is
 Arguments to pass to to the prio function. This only applies to certain
 prioritizers:
 .RS
-.TP 12
+.TP
 .I weighted
 Needs a value of the form
 \fI"<hbtl|devname|serial|wwn> <regex1> <prio1> <regex2> <prio2> ..."\fR
 .RS
-.TP 8
+.TP
 .I hbtl
 Regex can be of SCSI H:B:T:L format. For example: 1:0:.:. , *:0:0:.
 .TP
@@ -430,11 +430,11 @@ Regex can be of the form \fI"host_wwnn:host_wwpn:target_wwnn:target_wwpn"\fR
 these values can be looked up through sysfs or by running \fImultipathd show paths format
 "%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
 .RE
-.TP 12
+.TP
 .I path_latency
 Needs a value of the form "io_num=\fI<20>\fR base_num=\fI<10>\fR"
 .RS
-.TP 8
+.TP
 .I io_num
 The number of read IOs sent to the current path continuously, used to calculate the average path latency.
 Valid Values: Integer, [20, 200].
@@ -445,7 +445,7 @@ Double-precision floating-point, [1.1, 10]. And Max average latency value is 100
 For example: If base_num=10, the paths will be grouped in priority groups with path latency <=1us, (1us, 10us],
 (10us, 100us], (100us, 1ms], (1ms, 10ms], (10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], >100s.
 .RE
-.TP 12
+.TP
 .I alua
 If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
 set will always be in their own path group.
@@ -456,17 +456,17 @@ set will always be in their own path group.
 .TP
 .I datacore
 .RS
-.TP 8
+.TP
 .I preferredsds
 (Mandatory) The preferred "SDS name".
 .TP
 .I timeout
 (Optional) The timeout for the INQUIRY, in ms.
 .RE
-.TP 12
+.TP
 .I iet
 .RS
-.TP 8
+.TP
 .I preferredip=...
 (Mandatory) Th preferred IP address, in dotted decimal notation, for iSCSI targets.
 .RE
@@ -481,7 +481,7 @@ Specify any device-mapper features to be used. Syntax is \fInum list\fR
 where \fInum\fR is the number, between 0 and 8, of features in \fIlist\fR.
 Possible values for the feature list are:
 .RS
-.TP 12
+.TP
 .I queue_if_no_path
 (Deprecated, superseded by \fIno_path_retry\fR) Queue I/O if no path is active.
 Identical to the \fIno_path_retry\fR with \fIqueue\fR value. If both this
@@ -520,7 +520,7 @@ to respond. The asynchronous checkers (\fItur\fR and \fIdirectio\fR) will not
 pause multipathd. Instead, multipathd will check for a response once per
 second, until \fIchecker_timeout\fR seconds have elapsed. Possible values are:
 .RS
-.TP 12
+.TP
 .I readsector0
 (Deprecated) Read the first sector of the device. This checker is being
 deprecated, please use \fItur\fR or \fIdirectio\fR instead.
@@ -574,7 +574,7 @@ Tell multipathd how to manage path group failback.
 To select \fIimmediate\fR or a \fIvalue\fR, it's mandatory that the device
 has support for a working prioritizer.
 .RS
-.TP 12
+.TP
 .I immediate
 Immediately failback to the highest priority pathgroup that contains
 active paths.
@@ -628,7 +628,7 @@ The default is: \fBmax\fR
 .B no_path_retry
 Specify what to do when all paths are down. Possible values are:
 .RS
-.TP 12
+.TP
 .I value > 0
 Number of retries until disable I/O queueing.
 .TP
@@ -1154,7 +1154,7 @@ blocked from further processing by higher layers - such as LVM - if and only
 if it\'s considered a valid multipath device path), and b) when multipathd
 detects a new device. The following values are possible:
 .RS
-.TP 10
+.TP
 .I strict
 Both multipath and multipathd treat only such devices as multipath devices
 which have been part of a multipath map previously, and which are therefore
@@ -1421,7 +1421,7 @@ by multipath-tools.
 .
 The following keywords are recognized in both sections. The defaults are empty
 unless explicitly stated.
-.TP 17
+.TP
 .B devnode
 Regular expression matching the device nodes to be excluded/included.
 .RS
@@ -1511,7 +1511,7 @@ from later entries take precedence.
 .
 .
 The \fImultipath\fR subsection recognizes the following attributes:
-.TP 17
+.TP
 .B wwid
 (Mandatory) World Wide Identifier. Detected multipath maps are matched against this attribute.
 Note that, unlike the \fIwwid\fR attribute in the \fIblacklist\fR section,
@@ -1530,7 +1530,7 @@ section:
 .sp 1
 .PD .1v
 .RS
-.TP 18
+.TP
 .B path_grouping_policy
 .TP
 .B path_selector
@@ -1587,7 +1587,7 @@ section:
 .SH "devices section"
 .\" ----------------------------------------------------------------------------
 .
-.TP 4
+.TP
 .B Important:
 The built-in hardware device table of
 .I multipath-tools
@@ -1623,7 +1623,7 @@ for all devices in the system.
 .LP
 .
 The \fIdevice\fR subsection recognizes the following attributes:
-.TP 17
+.TP
 .B vendor
 (Mandatory) Regular expression to match the vendor name.
 .RS
@@ -1666,7 +1666,7 @@ and \fImultipathd show paths format\fR commands. Currently only the
 The hardware handler to use for this device type.
 The following hardware handler are implemented:
 .RS
-.TP 12
+.TP
 .I 1 emc
 (Hardware-dependent)
 Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX families
@@ -1707,7 +1707,7 @@ section:
 .sp 1
 .PD .1v
 .RS
-.TP 18
+.TP
 .B path_grouping_policy
 .TP
 .B uid_attribute
@@ -1785,7 +1785,7 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .sp 1
 .PD .1v
 .RS
-.TP 18
+.TP
 .B path_grouping_policy
 .TP
 .B uid_attribute
@@ -1899,7 +1899,7 @@ which paths belong to the same device. Each path presenting the same
 WWID is assumed to point to the same device.
 .LP
 The WWID is generated by four methods (in the order of preference):
-.TP 17
+.TP
 .B uid_attrs
 The WWID is derived from udev attributes by matching the device node name; cf
 \fIuid_attrs\fR above.
@@ -1939,7 +1939,7 @@ pathgroups will not be used until all other pathgroups have been tried. At the
 time when the path would normally be reinstated, it will be returned to its
 normal pathgroup. The logic of determining \(dqshaky\(dq condition, as well as
 the logic when to reinstate, differs between the three methods.
-.TP 8
+.TP
 .B \(dqdelay_checks\(dq failure tracking
 (Deprecated) This method is \fBdeprecated\fR and mapped to the \(dqsan_path_err\(dq method.
 See the \fIdelay_watch_checks\fR and \fIdelay_wait_checks\fR options above
-- 
2.54.0


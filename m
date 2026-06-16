Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C18D35CBD7
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 12:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612965; cv=none; b=DY9LVv7vHxT8KLzJU6cWASwiIVYn+DKor+z+yqj9esUzhS7F879Rn9n7n/LvopjfQ76O2j0u2/JgIMSVzYDD3JwP1Qpm8AwEV4khnK9h+ab0eFtZXZEdxC16hv4Se08luDl4tRUsFPL59g+c+c8+sH/79q8N9TMF83Gv0tNmsGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612965; c=relaxed/simple;
	bh=Ejc32cEqeNgd8v+WxwqcN9SrRJzhpw4k/egB3SYTb4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGm4KAiOf9FcmCn6Rwsaa2AKyVfqAck9zJxhX8XSmD3mDdVymHsTQpqiupxRrkYy7BxcFVQVF13jPlicfuZKjtvVJTCxIyeykk+XIUbLm4mgBYQBxpYyqIJpGs1ZCL9oO+4J69UZlAk2z8Y3kFAnsszKf8lhB/LbflTkHrQMt6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z+duybTE; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z+duybTE"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-45efb47aa6fso317514f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 05:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781612963; x=1782217763; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5JSXibEL8OQqB1sAXtw7LTjVxlXt0OiLOY7IBzPLWt8=;
        b=Z+duybTEj15cbWrJ6AJCdDVnTifQgNM6OhyPX/Im1RUl5mj16lawRLZp8hhviqrPdy
         JMrOcIixI8ftGN6RIPQBISj+pyQBGZe4SOISB2UeE6ok9Z/uRvijEXf6Gq/M9JuKoAIH
         EpYRUQXeyixHq4qxN0wEmvzolZ5s/FSWct+HIYeyylXlMbWpeAo7798WFP8Vs4W1vmWi
         J5kqsRvegNMANm6Ow2py+XaF+mru/A9pgAw4OMv7qCxgtwRBpIrcNgSfd1L7I8/4hBBK
         4Z0ZXR6GE9HiHYvsY1MRAL6wlPEMYujAgYK4dvzLTuooNmEeFcIrfsqU9z2VJarlN3xC
         0UAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781612963; x=1782217763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5JSXibEL8OQqB1sAXtw7LTjVxlXt0OiLOY7IBzPLWt8=;
        b=qDx+3LnUskOuDh1emR9V/04xICzEMXV1P3idAK1PBwfiaPRcF75GGmc+5flM0OYNPJ
         j8jLV60ZK21mtdVbvdN2bTqAzTRJUtY5wdlx76UCepzsBC1z3Gr9ojSAW4nNEloBL07i
         ztX7JroZ9ymVFc3Uj+RWQv22v33FZnE0HZh2YjFguORWoE8E6aagIidqr88VdGjmfGX5
         92aDGLoyU2yHHoHJQlTAWDljPiHVRCOWxZBQ4BY49X8V3RvJwwgWTN2swJfaiEIIcNu7
         mbLK27bjNFZZGX3iwJu24nb8GD3oJj8wjogq367Ivy5nRH+UuxxIOqp3Zep8ObFQaB8n
         Wy7w==
X-Forwarded-Encrypted: i=1; AFNElJ8rr/Cp3lwp+t+iuQN2q3FIKCDKsM36JAnE3mwbvWJe3OdWX+pwH+dThQ3g1DC4SCgf2N+E48vwYw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/aQ1E/NW45Wd+TvPRF3G0EhfEWcO15isuhPF5gH7InGl4FmZ4
	hU+kOBVdtpuQYMoELsXgz3v1muTjasfHNABfsbMEwQcj+XL6ZzSp4mA=
X-Gm-Gg: Acq92OEZhRN5zcuPnPMTt14zTmjrvV1bovHWf6HsBqyPqXvhJm8d72SDus2KPAZlwMP
	MBq0WCtyCr/b0xs0bg5R15KU3zb3GnlAhOzHeUjOoSI0KDlAINtxdf6WJx8VvCIrsO9r08FwZeB
	QelqIszKMaVk8jFopCCoZEQG8Sc2i5IvF+3ayw6Mvh0dFL+QOschGjt+mdn/mLB6JtnJhz/XlDw
	a5SWZ2lIQgBiE97XKhHak99N57vhO5XK2qCdDwkBQh6qnMpIaHFZgrrRYIZ/XT1DfwcOlBd00p0
	qfyJuYsj1A3nu3OlbkfSgZhbaI9Fc0lItkDvqzSwPny4QoVQPWupa+Lu8gCCXjJb9bvdzQULqJR
	R0M4+f0RMGIZQd0Aur1lr7wW2P+zilyMs7A+E0Lkagh+syjV5o1YrbvHt6FoISR2HC2qIn1yT/Y
	60Vq2VvcWU7MaoSVRZ54rMvC/Ukqzhuk10hyp+M0lir8DQETwzRE17CK7wvrEn6I+2
X-Received: by 2002:a05:6000:200d:b0:460:6b68:d6c with SMTP id ffacd0b85a97d-4606dba10acmr12844626f8f.6.1781612962484;
        Tue, 16 Jun 2026 05:29:22 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c3fcfsm39312699f8f.26.2026.06.16.05.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:29:22 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 6/8] multipath-tools: specify file paths using variables and add FILES section in multipath.conf.5
Date: Tue, 16 Jun 2026 14:29:02 +0200
Message-ID: <20260616122909.244619-7-xose.vazquez@gmail.com>
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
index 5b730801..de6c21b5 100644
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


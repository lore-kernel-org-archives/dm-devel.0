Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537273603D9
	for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 13:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781356211; cv=none; b=l5mJ7FHmr9xvksf8o3wo9BPDmY9ADmIT7OMAMjHduKSdAmv8hJBRmYCOPjvp0Wo/2zrKR4CCDUAGoHeIV+OqP5x7BVMEjv0bzlvEEAsdTDJFrLFn92zRuoxvV6q7ZcJXdvMjOBU5EhFxpI6PPiE48bmWdeWyoe+Q6MW5ixPt5LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781356211; c=relaxed/simple;
	bh=zDtvLeWS504yQ1T1cEc9yx+tOkONAYNaqvlWHdhtm3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGCeRO+z5BbVeQfr7dWUZZe1SDWBfNlOda7srtT/LOeJU+jDhyfbWzRQ3t4myt5/m7caWAvvg0oL2fcU3Mg2czz4xRzDkbPjrdzpBJ0P0HwvW/Uh7x5tsl3GzkghzOAyq0nAGexg2TqNHRMjR3ENjqGPHY2ExPkPHwq1MP+wfeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xppv6CpY; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xppv6CpY"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45ef5b33e73so217648f8f.1
        for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 06:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781356209; x=1781961009; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sPU5gRSuF6IBvfOfHhDYLeYhvmWpRDMF6rmyZfN8TXY=;
        b=Xppv6CpYR5FhXK4aUisg4eYY4bNEcaTBEMOkAiWGpK4VCp8CXrm6aVPma24OR1XF1c
         gaVnHZKx2hx5LjZtZzW2Lnq+b4C0QV4HaH6s843lgxC5ab0weKS60QH2C86k2VzYlYkO
         YdotAiBeAmjV/vCKB7ExJs/4bv++MOSBV4zO+M98W7mdn1qNOVId7g3nBdI6pluTwA0N
         tlaEN5DM3CmggJPVLnnoyWg4l3lfg/h/ijLFryvLK1TgPg2gGnX3P+0jtB8dUfROuJXs
         RMPAzu/Z/OwnLCjCP3JPJNPhPBqvhMnF0gJeD0mzRpaYhYfUvsewdlCrCXvYp5yEnr+U
         ni5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781356209; x=1781961009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sPU5gRSuF6IBvfOfHhDYLeYhvmWpRDMF6rmyZfN8TXY=;
        b=IoisK9g4YDqZQPXaLFz5qZslj7emfV8TgdJQ5D1ZWbs9U6ynQwQ0j2s/SHt8nBN5Tw
         9uMsJPeCDNYrx7TVmp9dj00BOUq9+YcfrP9AF6NatpckmdeQAM/7bHzl3np9W/GC5QgA
         xvjA5/UIqoWsvy/vGFBPwMx7KywfrUQ0bLoAGFx8R9aXqcFXuDRYTAocMqYG/w3nrpeG
         SrNB/u3AUOOMwmR1fdmtCxQOaGCtvOHnk+kZk1JODKn8COGqtIOkEiX+SycF/2P0adt5
         2cITakYKIO7jps/ftiHu42Qo4OhaJcR+mc057IKZNl6eqGoC6vNrfp1HTa9iyhVpNnt2
         SCtg==
X-Forwarded-Encrypted: i=1; AFNElJ81u2MPJ/vM02JR76U3JAz8O66nlhquRB56+KGnT0YwfpYXYsisAntY933o4Q3ojuYwhRCBmHR+iA==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywpa6fmQf3QjWa1JDv0Dduy7p4I8JuknPPsVY6/dcULAmyZR+LT
	URdan920jTdcdKe/d/ZiSgnte6PwcLelAclrJQ4j34kpQN2IMa/VmYs=
X-Gm-Gg: Acq92OHa1CH8xBRT4YkjOIfd5gdUukVD9qmbnkkNvo3xg2aWqjmI5rDHmm7bE9MGLuP
	pRXVOMTUWTKxrf8gIsR/GdTt6/kvdDh5zh1HiVZtavyqK0eKhk9NmdXhn4TKP9OrzhWxDofRclO
	v1tc9yjVF+fGNWLVUadOFkh708G8iWbZXv2drEpnKBPBBqrND/syBmjOOHdkShq35g7nwaFTDu1
	fzCq3HidkCBQ+dO4ISOXMVI56MjKSSCdZiZ2MwRNNnekKOnLSa1+wiucuzYypmhK/83WqIqVBNi
	StSFK0zkmWG0JIHfjQFBIpaFQkiFI+QOhTC/IfmO7b+CBNGIRNh4sy9vOm7/RKGTj+n5gcG0hCU
	krAmuT69u9PizZD8NzU1u9ygAfIx3LsZKJ0EcpDGDT5QJqXZ7kOYSDISi19+CrkTvvv0R3vR+IH
	oxQ/EEGV5pW3duu9iPHSDPkLS3NrhcK3BvNobtfpv4CIIr8VK5XSGIDsRkcsuFoLsm
X-Received: by 2002:a05:6000:4212:b0:45e:9520:d73d with SMTP id ffacd0b85a97d-4606dba478bmr4733436f8f.6.1781356208611;
        Sat, 13 Jun 2026 06:10:08 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26392esm15410334f8f.3.2026.06.13.06.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 06:10:08 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 5/5] multipath-tools: fix mandoc errors/warnings in man pages
Date: Sat, 13 Jun 2026 15:10:00 +0200
Message-ID: <20260613131002.144263-6-xose.vazquez@gmail.com>
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

Fix the following errors and warnings reported by mandoc linting:
$ mandoc -W all -T lint man_page.X | grep -v "STYLE: input text line longer than 80 bytes"

mandoc: ./libmpathpersist/mpath_persistent_reserve_in.3:22:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./libmpathpersist/mpath_persistent_reserve_out.3:22:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./mpathpersist/mpathpersist.8.in:172:2: WARNING: skipping paragraph macro: PP after SH
mandoc: ./mpathpersist/mpathpersist.8.in:215:2: WARNING: skipping paragraph macro: PP after SH
mandoc: ./multipathd/multipathc.8:19:15: STYLE: whitespace at end of input line
mandoc: ./multipathd/multipathd.8.in:573:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./multipathd/multipathd.8.in:573:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./multipath/multipath.conf.5.in:130:2: ERROR: skipping end of block that is not open: RE
mandoc: ./multipath/multipath.conf.5.in:1979:2: ERROR: skipping end of block that is not open: RE
mandoc: ./multipath/multipath.conf.5.in:89:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./multipath/multipath.conf.5.in:131:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./multipath/multipath.conf.5.in:130:2: WARNING: skipping paragraph macro: br at the end of SH
mandoc: ./multipath/multipath.conf.5.in:1577:2: WARNING: skipping paragraph macro: PP empty
mandoc: ./multipath/multipath.conf.5.in:1770:2: WARNING: skipping paragraph macro: PP empty

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/mpath_persistent_reserve_in.3  | 1 -
 libmpathpersist/mpath_persistent_reserve_out.3 | 1 -
 mpathpersist/mpathpersist.8.in                 | 2 --
 multipath/multipath.conf.5.in                  | 6 ------
 multipathd/multipathc.8                        | 2 +-
 multipathd/multipathd.8.in                     | 1 -
 6 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index 5109fb03..36cc7815 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -19,7 +19,6 @@ mpath_persistent_reserve_in \- send PRIN command to DM device
 .B #include <mpath_persist.h>
 .P
 .BI "int mpath_persistent_reserve_in" "(int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)"
-.P
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index 09708b93..1a2b9511 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -19,7 +19,6 @@ mpath_persistent_reserve_out \- send PROUT command to DM device
 .B #include <mpath_persist.h>
 .P
 .BI "int mpath_persistent_reserve_out" "(int fd, int rq_servact, int rq_scope, unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy, int verbose)"
-.P
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/mpathpersist/mpathpersist.8.in b/mpathpersist/mpathpersist.8.in
index d5f5a452..2208008c 100644
--- a/mpathpersist/mpathpersist.8.in
+++ b/mpathpersist/mpathpersist.8.in
@@ -169,7 +169,6 @@ PR In: maximum allocation length. LEN is a decimal number between 0 and 8192.
 .SH EXAMPLE
 .\" ----------------------------------------------------------------------------
 .
-.PP
 Register the key \(dq123abc\(dq for the /dev/mapper/mpath9 device:
 .RS
 \fBmpathpersist --out --register --param-sark=\fI123abc /dev/mapper/mpath9\fR
@@ -212,7 +211,6 @@ Remove current reservation, and unregister all registered keys from all I_T nexu
 .SH BATCH FILES
 .\" ----------------------------------------------------------------------------
 .
-.PP
 The option \fI--batch-file\fR (\fI-f\fR) sets an input file to be processed
 by \fBmpathpersist\fR. Grouping commands in batch files can provide a speed
 improvement in particular on large installments, because \fBmpathpersist\fR
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 74447f8c..ff4eba4f 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -88,7 +88,6 @@ the indentation shown in the above example is helpful for human readers but
 not mandatory.
 .LP
 .
-.LP
 .B Note on regular expressions:
 The \fI@CONFIGFILE@\fR syntax allows many attribute values to be specified as POSIX
 Extended Regular Expressions (see \fBregex\fR(7)). These regular expressions
@@ -127,8 +126,6 @@ vendor, product, and revision.
 .B overrides
 This section defines values for attributes that should override the
 device-specific settings for all devices.
-.RE
-.LP
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -1576,7 +1573,6 @@ section:
 .B ghost_delay
 .RE
 .PD
-.LP
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -1769,7 +1765,6 @@ section:
 .B all_tg_pt
 .RE
 .PD
-.LP
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -1978,7 +1973,6 @@ as integrity failures or congestion with so-called Fabric Performance
 Impact Notifications (FPINs).On receiving the fpin notifications through ELS
 multipathd will move the affected path and port states to marginal.
 .
-.RE
 .LP
 See the documentation
 of the individual options above for details.
diff --git a/multipathd/multipathc.8 b/multipathd/multipathc.8
index 5e97fb81..2187d1ed 100644
--- a/multipathd/multipathc.8
+++ b/multipathd/multipathc.8
@@ -16,7 +16,7 @@ multipathc \- Interactive client for multipathd
 .SH SYNOPSIS
 .\" ----------------------------------------------------------------------------
 .
-.B multipathc 
+.B multipathc
 .RB [\|
 .IR timeout
 .RB \|]
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 93625a90..632cbe40 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -570,7 +570,6 @@ The device appears usable, but it being delayed for marginal path checking.
 .I undef
 The device either is not part of a multipath device, or its path checker has
 not yet run.
-.PP
 .RE
 .TP
 .B %s
-- 
2.54.0


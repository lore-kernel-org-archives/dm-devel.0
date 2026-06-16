Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EE6303C9C
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 12:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612971; cv=none; b=V/r1RTtzJ+ivQxOGVRUov7WmALsz22lhiakcoK9eq5MpkknQfgeIPiiXNYuXQtdfD3GektTqdkKTm8AHgKP0vBylKDrrYhqjqkV16A5w0QZdpkOK++Q7sG68wMF92rGQ0Gu7+N24CC/9jcbCe0E7sZSszgw+3SvA+m2EabQcqpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612971; c=relaxed/simple;
	bh=z2Nki3K2/mx+BgKkQ0yxEBO2bqahaCRYz5ZF5gLfSYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQ/28/5bOE04nkFbwv1dAg7tsAU+XhzcHgJEahoQ37/Te470WPEBJ1oOrcAYdozMWlWUa22ln8zTFV0mB9zOt48K1YUAVYTjD8ecTVI9kijPPYt/gZUHksFCG+hGfs7Lhn65j9jQ0DY1bgJAm1+bxJj416a9IbHyitBa2EJWH0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RYeX3v+V; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYeX3v+V"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490c28f84fdso9963355e9.0
        for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 05:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781612965; x=1782217765; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=InJJHH60iNGCLAoJjX7vcbdTdu0kkD5JmnZ/K1EEXOQ=;
        b=RYeX3v+VVdEbQ0x8rzloFvZ4kPv/PvRjVDsCgrtljTpc5nbyrq/3rSBQe9wAzqetlK
         aAbd5yGF9nn8etjR5yEFjy6XGsihj/uEKTk1LhubFOIWiLuhpG5p8FTcZZ1vgvhDOhJX
         Wo85ylO7SvAH7kISiRbMBzBIENPuDnVibihRr/jLV/cOG4GYY1+DbXSSdbhyzFM2+fRi
         J8TGAeyTisP+lK/afN4Dqkgo9kWRR7U/czyHU7g3TWSkNCcPk/Z/IyTnLjvRcEwAO4IX
         ZrurDL7uNwRFWAhODbRy9Q0vDbb8Fgu1Zg1Os7MmXg4ESQZYLi/CjLMd2FiRC39AVObH
         qa+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781612965; x=1782217765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=InJJHH60iNGCLAoJjX7vcbdTdu0kkD5JmnZ/K1EEXOQ=;
        b=cVgb34k8L2LhahDkmzSjpQr1Kjz49fzES7pXBtg+IPuErWnElv3mF+0yXoyBTeSPF3
         1sz+Hnk/756RH4QawCotbL6anaHX7P8o7FKJorhOtI7BTEIStyjpEFzbnRe3IQeUPBg4
         f3TEo2jwpNER0nwHDanAbAPme+umk6waG6MbxC6QvGTDQHOdxnlGvmkU9gW69UKmM6hh
         ulCH3gp7d44B3bRyJNPTblu6144L5DPCCJ2bpc8M9YGXCoZsRB+zwgf40bbG7VbnMbNL
         FeHBwpsLiCpwtD+sEVohhhrmnpsM+292ZmDtS/L5n1gO5gJGylniIty5ISbrvNiX1bfK
         NLVw==
X-Forwarded-Encrypted: i=1; AFNElJ97Mo42oKqHpdhbLJra8DUNQNRfwv55vBxIjcoL9hahMzJOztfeXVmKQeJHjzeyqM1qhFEak95pIA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwqsrfHmESRQBnVtuiQvO0Z4V1DhJ0+89/gD2/dvVTXuTYpicVL
	Wdh+CQtiFYl7xEtwoVIPD8nRw4/woAtW2n+dDvJZSEbJEYN/OqROltLftGPgR+on0Q==
X-Gm-Gg: Acq92OFTtqBlWsZyDiWB6fB1bjVX4GRdSMcjZg2Gr9O12J2Y6GjsjSRcL5UeZhnh2cs
	q8mU7MiOotDYHOwcC8MZ5qBRDGR4biWH8CMV6kCYJBw/1AYvpQ3IfeFoVPZYhd+F4QhuDTZV44f
	+fBaEzfLoSpMw5whf9O2ReH3zxUHg1AfcpNKv+4mzEVNLgE6XCrNrR3Edoc0T14EskWjQxr6Ehy
	fs6KjPDWtI6GgIHSdcLX/jWn5L4B84+J5souDMSmK899Q+zjVc9+DPVNQDJBAvUr9la2OqG+h8c
	nROaaWzWYRdEoz0hsveCRXqN97GS2RtKfo3M/zJuC0F+ZhEu84rRo5aUQFBue4q2McWRsZyw9Ze
	06yA8a0zdLdLIXLgVBYniTNDVWJst6cQkbTX9pLqPx4SwSdlyjO//qDgGvbfxftzSxFPZgkTZ5T
	packTAyQOMn81uTxbAtGBJouEG/B/fH3RKYG2yLJeKvOreiNFbULNA5+e8sV+RnMBg
X-Received: by 2002:a05:600c:820c:b0:490:e170:b812 with SMTP id 5b1f17b1804b1-490ec4c3f4amr122135175e9.2.1781612964708;
        Tue, 16 Jun 2026 05:29:24 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95b274sm421751795e9.1.2026.06.16.05.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:29:24 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 8/8] multipath-tools: fix mandoc errors/warnings in man pages
Date: Tue, 16 Jun 2026 14:29:04 +0200
Message-ID: <20260616122909.244619-9-xose.vazquez@gmail.com>
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
index 165d3df3..c55d5d40 100644
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


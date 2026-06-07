Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616C2212564
	for <dm-devel@lists.linux.dev>; Sun,  7 Jun 2026 10:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828719; cv=none; b=SoSvgzD0Gn+vUTn4GnwaoiEBXycZzsByKic3MMv0XZpMXtXH5iR50IZWXalROym1sakJcMABGfoOCD4Tq+UpHMON79B6jB3A7L70KET1ysnZNATxyA94WA18nfeL4xFcEPrSlaBWGoVWkPiwLCkuJzCfCVZuOtlgXHzeMFMPagc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828719; c=relaxed/simple;
	bh=QYnHfvDGNrIjUV8iMMbT/ERkkU5EFcQDyXeJJStXOVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIcBNkKznsbkwejeEYFgBdGgXxI1ZpEmGDAcA+Y+n/Ppt1nOOsiB1j2whDzpmMbioDJWbs9TKGzThJEvlgrb9qzNIYoYJJcF5F+L+OSsuWasgOX4xhxKuJGWEF5Z7jq40h8wikpjQ0SHH+dmlTuxynpy6vIlYHw+jtiryIh97Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvugIJFe; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvugIJFe"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490791a3e92so4232715e9.0
        for <dm-devel@lists.linux.dev>; Sun, 07 Jun 2026 03:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780828717; x=1781433517; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0R6XIO+PrbpcJw2/DSeHl6enSkWRi0ninkEchc+xBQU=;
        b=bvugIJFe1FsgJwozpGU4A59JiUtqJf6RTluoQ7ESwjfjDW0sDneK4TVAuKbt1a/Wqy
         qoEJ/uD+LQ8msCmkzj/ClTrxs6buuR3YznJ3fKxaaVBRPBRaRkPZP3f/5xuRsF3osTkZ
         Dt+r6TMXzD9PqEg8vTZ08lo/NkdvnxUevZZC7psFrVw//Ae37xMyu/brF/cZGL3Lshgp
         XwJf8IZgkniJHtnYpUp/eRdcQPQx4/ZpNvA3NWhaC8dfSOhR6SirLRj6cmc9WbdTfHdA
         hm7Tzc8o7G0d61JDQHpzY18fxnc942o1YsmQQH2fa0ffBhyVZ/b0039e6QbQj9jmR3jE
         ZyVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780828717; x=1781433517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0R6XIO+PrbpcJw2/DSeHl6enSkWRi0ninkEchc+xBQU=;
        b=OlCrkTBuG/sEG/Tb7YRsEChq4mRwzHkGkx+Av3iZTvG/0mGL5C3EY2K5l9SXYsbufR
         vydklRxjb2FhJkVxJUXEQeC+iKSMa08ltpcliAEoFzi8CU8I+OXCHxzXeCvIGSTTQN+1
         IyLFZPzyVOJn5M2Jy5dNoxXjaq0LiwFxyjnEGCcEwhghMyAZ1ofm8zFAqcnWEb4FRNLZ
         UTBs5I2NyYZ3Udt7MOmeinUaALT2oo1cbXJ584j5XK93mlGXjY71RD85mBTt6Tz8lzs6
         +O8XYc3+KWLUP7BmZTcn4u60mT1vXrNTd+Ik0AxnruBNJXLMozcUWw0H+CB8JzFyhrzi
         caYA==
X-Forwarded-Encrypted: i=1; AFNElJ+eQ7CGDIvZmSvaTt9h0GUqoS1KeRE5rnWoJwaea3Ffw6SwPkVPaZ3ioijmnB7DKBPJ9uZb5kvivg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6FMRx+t3oja2344Y1T32CqYK+xar3kUxwBJaFEiTth3abEwaq
	oUuupes/4hOC4VcmxTks0Y1TpHhI58paqedNwr2NuCvfyqNlQ5mah58=
X-Gm-Gg: Acq92OGGHPPsp9g9vb2GsjrLAJrBvoL/b1Z3vw/qUYaompiCAVt2eEeOw56w7cLaJ8L
	Pln5tghlopGhWgdYXLB1pC4OwR2tF2q9t9AeY2SNLYl4RA2yqbBoR/Fi43NSf9gAiyl1Y6xjm/k
	wOt/3rb+ivt+6Qjbzs2Ttnb4t8wiQpNWxKcBDCkrdgsA7cU9nPS9d3qHctqQGKzCNUwdFrecARv
	K1SZFNU2xf5SE2NeQsxS+XMBAwWfomW/qs8INhFDZf3KPPQ+R7bgfwPPBn9qCjaTNqfjrc86Qmv
	fg8lgCGt2kqgdotHA/mJLqjJukxzQ1mRAvkO2/3hgbsJRuPjpuJ3/iqhrF+4KlalIJJtwLMwSLl
	G4gtMbS25N16vxKRvVCD7twdzYTe8ap79dnCcN7hLQsuhMkLvWVxZJmHYhFXFsPT7UOkvxib+tD
	PBo0GycJnW+dWih5oHiDY507lPlyMF98ha2ASTNC5q/LNXQq/fh+QNpx715EHsbwg8vqJHKbQ=
X-Received: by 2002:a05:600c:8b0c:b0:490:6e0f:29f4 with SMTP id 5b1f17b1804b1-490c260d263mr70826145e9.3.1780828716653;
        Sun, 07 Jun 2026 03:38:36 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2e4004sm42616229f8f.9.2026.06.07.03.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 03:38:35 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 1/3] multipath-tools: delete obsolete information from multipath.conf.5
Date: Sun,  7 Jun 2026 12:38:21 +0200
Message-ID: <20260607103831.336833-2-xose.vazquez@gmail.com>
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

repeat_count (rr_min_io, rr_min_io_rq, rr_weight) has been unsupported
since kernel 4.6 ( commits 90a4323ccfea and  21136f89d76d ).

And also clean up other deprecated entries.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
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


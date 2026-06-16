Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A54E357D0F
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 12:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612958; cv=none; b=FzUpgR8LG9lOL8Pvvi4mKEsCFrcSwHGZbR2YUks3u+te1DvVKBtGCMu01joqlcCld88x3a2tBxPrvz5Bda9raHFJuBFFtk5QFqM2f4vqnvv1FXqphq3XrYMZFZo1hRENy2/WQZCFMzI4JhKBuzSgCvfEdt3L6NJzTEeeNPbpBDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612958; c=relaxed/simple;
	bh=QYnHfvDGNrIjUV8iMMbT/ERkkU5EFcQDyXeJJStXOVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROpde7oM6M3UbkWUZtMTCcY2JBZngndCGXaHNlF/Bk4hBXYMcL+PZ1HYSvjpbH4+W3SGxDrUuHQ/osTJbH5KeGmgroIFnTFBvvMtnnIsvlfpIEEV5jmsMi1WH9VqPQbColq0WuHpXuoTi8u6xHzm4qAmvZTrHZhIHd5qv+ni5x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KqMzjKGO; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KqMzjKGO"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490a762c8d5so3093275e9.0
        for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 05:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781612956; x=1782217756; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0R6XIO+PrbpcJw2/DSeHl6enSkWRi0ninkEchc+xBQU=;
        b=KqMzjKGOSuZSoRe0/MOlPZhmnLNfxnzm+7jI7T096H9aC7FuIU6so0WWfJoAR0Teyq
         TVJ92EutGWZag+86V/2Iv5x4aOspq8x2bn39yLLNWJYiytbAd+u5RbYTBfP8Cffcp8qb
         vAeh6go2YFRN0vxgEMEOjQLKLAU2vsWQfqtBvbA0tG8u2jIHx+Xco1wcIypgxffg9f4n
         p0mDpXrjjz6gh1PrdUnhyC5MiKjUhh9IeyOISk9u8d2Hqq+AVIdynpO8ejALoFPtrsEO
         KU4/DVpOR3CU/mjZsfzMCrZWH2xmoc693ePzrqPZA+UOmc1EiCZpAMwxoGFrqfDyvXMq
         lwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781612956; x=1782217756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0R6XIO+PrbpcJw2/DSeHl6enSkWRi0ninkEchc+xBQU=;
        b=Nl5iwVlBL8Ihy1MIMYWEoSXNOyzNetpgmwscQMyRH7K68bIw78deCt5sJKwmggLe2A
         OCHHI+T3qPOw2SIqMteuAimegi6pqR6f5KcLEXTQ672ZHhQzX6TYDIxeFfESk4CDMGuN
         le0Wh6SIz4ANIsn0yfnAv0iuoesrViacaaimBN9brMFpMDCIwM8MbvHiC2hPg5GPOlvV
         Ji+PcWsK9KN9MaD1hJ0BcS4x/d+aMdGmtR/KAUBygZheUDu9nJ1Clce7QSNLCU5AgGMO
         kL5ait+PnG60qF76IZ5+/IGrIPe96kcTNqEyducIKixz8z/tzAd0MNojB/tiZ2qzDSyw
         cFOw==
X-Forwarded-Encrypted: i=1; AFNElJ9O8nlnW32pvlKTp9vVenBTFd7stGb2NT1tHsLJM97tYshBT5kGuwsiu6+ghBU36efD9ORj2V9scg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLlS3o+HVDEVc9aKuaZdOtXgeC1v0xLdlc0D5+RsVpnre0LZiY
	nsRXecBrMd+4otOeLyP+XbofAxLcpIRgczb8BT4ZpIbO1f663bWRLO8=
X-Gm-Gg: Acq92OGtJviS2Hxfs+ApVVWM/OtiPb8PSv8LQ7T6fWmVtlgogLMzmmeqYOh0RitgFAe
	o4KZb8BtFg2Wba+AC1fwSCSe6uWNrJd56JkbzD/Tvcml0W8KTuKHjpKGEeaf3EcWzn1xY+IXPk+
	7OfuLv+x8dAAHYI4/42ujDrQO1E1g7uAr9rhz1XePXU04Y3zdiyNq5kBTNdHFVDnoxsWTgyFq7M
	cL2j5uz8/e7jL/jDrBbg+OIqmSS41pLLc5q+RhxX2HFQDqv/EpqjdbvzikuKd3HZHj5gNRZw/AT
	POf0dXZFqRZPEuIsnZ5e22p/jM+b0TFKFdvGt0Kj2ItN3jofdA26OCTVbcSsFW23jwJtipRDRQ2
	R5kFgYJ42byggyjFtlvKSyr9xCIw+qMsrSaRay7bSikUBuwt/FurXFfzvJJGJlsa33WTf3yCNZh
	vVX97+IrkltcD+2u859U2Wcq4J4bzL59QAipB+iXBKuDiR5WC/ZRmvwiT2GQtY8m8ZVB4QB82ef
	UE=
X-Received: by 2002:a05:600c:8b0f:b0:48d:1021:e5d1 with SMTP id 5b1f17b1804b1-490ec4f25f3mr129675815e9.3.1781612955579;
        Tue, 16 Jun 2026 05:29:15 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95c51dsm298091975e9.1.2026.06.16.05.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:29:15 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 1/8] multipath-tools: delete obsolete information from multipath.conf.5
Date: Tue, 16 Jun 2026 14:28:57 +0200
Message-ID: <20260616122909.244619-2-xose.vazquez@gmail.com>
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


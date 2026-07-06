Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9286E31077A
	for <dm-devel@lists.linux.dev>; Mon,  6 Jul 2026 13:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783345861; cv=none; b=nam7Uun/kAoFqkf4Im9QSCv4LNfYsaL+1D5dF4BPW2CY8u20Bhi3fE97an3T0UIQJCvof9AP3LkqaH/0JiLR/XXIA2b+ecqZsz1GHUSIfK/XuU1zOHkoLWJzj8JFemEW55DDp/lHrrNg0RkU6aziugPkkkcKNojLjOrZnohZfrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783345861; c=relaxed/simple;
	bh=s5FYu8ve5PLVawVvLXvj66iw0B6Au3VI5uvcc4S/kSE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=abW5GtMYbS1S7JVgIf/8Yq6QKifKJAg6Vjvel8E60C0I/D6xBUaHqf67x8mEumPBFM7AEULdF14mJT/fCb4NhpIyvK3Nzq8W/38FLVg1ErG28jb0wXfuxwHhJYu41g2V+6nfSPVkBeHF0Iyc+g7pv19JCSiKDJ62fjHtWEKv4CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y1Xvalx6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y1Xvalx6"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493c2b3dc8bso21282065e9.2
        for <dm-devel@lists.linux.dev>; Mon, 06 Jul 2026 06:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783345858; x=1783950658; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vEHUZp522leGRaIfBMmgEDr49u4099an2x6jOaxKZv8=;
        b=Y1Xvalx6e8DAD6x0BodvBf+cVdRwqQOb6UcEs+WeBTOrjB9ghi7idliuEAeTrpiTYe
         fIbktj81H8WG4dnChp92bASKB+UalSsJG2IHWpbf1lVbPoL/7K55SOjJQjkw07VHqqBb
         +1vRCR0WkrE5u8QrzMOnnzK6/q+0wUMBEb7zm4Ur6mhx+bDvGUY87RTzCqtsFH7XrpDu
         0ljlwvDLuM0gh9TqdxSndv9/GV7SH5hPxImrb6gmZYcjGR95rou30+vzGrGUHqdUbhix
         rInxZeT6vmI44fds/be1xVdYQlZcM3nUmifGF6GXuYIcYqBRGoKrvQRR2lM8hu2IuAXF
         JexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783345858; x=1783950658;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vEHUZp522leGRaIfBMmgEDr49u4099an2x6jOaxKZv8=;
        b=FBwNg4l8g6Dkr5YcaeFQPpS8LcZBNALz9pzo2f1VQlPVnDRMAlR8ie1ANzFGZfCY5K
         t46tELiDC5aO9HyEgJkNP4KJjdRTHUAISVVGv69l953cDDu6W1nsJgzuh+yxlU6GDpAO
         AmiXrq8+8YH3JPtgnIoRiyLGA6mSEsKDQ9znzJYzHUqRTMHIQ8ziLZ3QG9reUXrb1oVi
         6UUWpfFQnUnoh3yCWx2ziX621dbAFAppjMsCm9aVGu0+hijRaWbj6yQMsq8gCl2pqTOU
         njbo2K1Xc0ZhgDiHkK9hu1S7WTm80+2NM/qWrDBRyZjkrErA+vW97sh8WpbAs0XnSE2f
         RAeQ==
X-Gm-Message-State: AOJu0YxMf1ukRvUDByjxL4OX87cVAEnpdzFx/6LP8WR3oEj8RjxTIIOG
	UpH1dEllsoH4ACx1S4V37TywnSpHS531vYOjrX7TEOkaTKRfDsdjq1mQEqVsHQlMAzk=
X-Gm-Gg: AfdE7cmHPSFAYBzDsy5txFBjC59Y2PbWl+VDnkoEwzFb53oyBOMi5ZvpJZh/vd327Wp
	EUmyMezHRnzx859OIbrukQVzDY3xk1Tno9LmTSmoSAm/J7q6JQ9Tb4BsAY/v527OTP93qMu9Uo3
	ilNguYc2xNI4GAngp2j56gjM77WtjtkBP/X99HohiZZi8Or3W+qPM///kU0TpVQdb3VGdsbb+Gf
	fqdBN/XEIk/NFAqCgZ5F2ukdelVFZt8UiHKkoszvidPEfyVGE3TVncz9XcL1wmuhjlVQke2dwa0
	PzeCY1/sJZVEG07HM5Wpr2Sj/lt8x9q5RekV2q92BLPny5vP3u4/VmETL0T++vqAXtuQ7CMYTaU
	EINj7MZZy8BE+q2PGOig4qAzL56pkmwzBTSfjjL7zGf1piV4RwBkyxD1CMZXnKpI9KjQTNOU1Ib
	2RJxMT4vo9xGTR2W9ZB3UMTgREsTUy42rX2WXdZqhzmlPLhL9wbTyu2bQ7Cz95Qzlq1RbDKsk7b
	n9I
X-Received: by 2002:a05:600c:6297:b0:493:d26b:1575 with SMTP id 5b1f17b1804b1-493df099bedmr7074725e9.27.1783345857750;
        Mon, 06 Jul 2026 06:50:57 -0700 (PDT)
Received: from localhost (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-493ccdab3a8sm305067855e9.6.2026.07.06.06.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 06:50:57 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH] multipath.conf.in: Update path_checker and force_sync documentation
Date: Mon,  6 Jul 2026 15:50:49 +0200
Message-ID: <20260706135049.724071-1-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the fact that all path checkers are now asynchronous by default.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5.in | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index e6b4fc0..2ea78fc 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -504,12 +504,11 @@ The default is: \fB0\fR
 .
 .TP
 .B path_checker
-The default method used to determine the path's state. The synchronous
-checkers (all except \fItur\fR and \fIdirectio\fR) will cause multipathd to
-pause most activity, waiting up to \fIchecker_timeout\fR seconds for the path
-to respond. The asynchronous checkers (\fItur\fR and \fIdirectio\fR) will not
-pause multipathd. Instead, multipathd will check for a response once per
-second, until \fIchecker_timeout\fR seconds have elapsed. Possible values are:
+The default method used to determine the path's state. Since multipath-tools
+0.15.0, all path checkers run in asynchronous mode by default, so that
+unresponsive devices don't pause multipathd. Use the \fIforce_sync\fR parameter
+to enforce synchronous path checking instead.
+Possible values are:
 .RS
 .TP
 .I readsector0
@@ -905,7 +904,8 @@ The default is: \fByes\fR
 If set to
 .I yes
 , multipathd will call the path checkers in sync mode only.  This means that
-only one checker will run at a time.  This is useful in the case where many
+only one checker will run at a time, and that multipathd may pause operating
+while it is waiting for a device to respond. This is useful in the case where many
 multipathd checkers running in parallel causes significant CPU pressure.
 .RS
 .TP
-- 
2.54.0


Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9951A256C
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 21:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733262440; cv=none; b=FS1TJlrMOgKNyC5hWznmrD4GTc3MN8WLU8lvzjfnjc8bf1omVyy5wbACnURjKivbOGub6sfgW0p6xmY5s86bFT79TM/qsb7hQAgL++g78MvqqbasCjC0J9F/3CCC04xF51bdMIv96n3bODw5OtT1CtGm8CkTM3CbF+bCEc+yhDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733262440; c=relaxed/simple;
	bh=FZnSpUGzUi1p2tC9xFEfjUupvzrBcjsofmHIz1i+VpM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oh2z6qtll3vpiHiKRlw89u8L8Rc9ELrqLgir7cFXSFiNWn/ZMiG3y73wHincVZo0ZWjYKhbSyxW3aLS4KlIgvaeYUe84dURu6GsMGYy2TpLp1evKJAMSbhZcGC4soT6ocR47jHgvHfafaKZDQ7XBG9EKWgQh+l1lFdKaNEE3WnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OiLi57lX; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OiLi57lX"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-434acf1f9abso55836515e9.2
        for <dm-devel@lists.linux.dev>; Tue, 03 Dec 2024 13:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733262434; x=1733867234; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=krH+QR7yJAREMDnKO9KXDRcqEAuf/Z7N04mC2uc/W2k=;
        b=OiLi57lX9nEE134oo5LnCrmXcBQZwFvVJ+Yog32EalS1i66/STj0fwXW1L7n9pm2U0
         iA2fH9EclhL4X/01Mm1rki+E+gPUcI+KA0gLsqcLsUF71mLcJDGFdoqtlfY9o6esGUd5
         ZBi4tpRnIjPluXRAWFRP7xMUk1nGcnwNMFvA1uqP+a3gesakUViUVhw76OHbojU3EOLG
         H9dPf/U3RcCksGDfpoamelJjhJPnErmDlmLUplT0KDWR2NeMBbArFktF51nx/RSPyNSV
         s+tL/MGWPqlCxkUG6X2++ELhgrDn+BVKR7JswLMXbmYSPspugIU3Bs2X0fXLCFm/Blc6
         3i6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733262434; x=1733867234;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=krH+QR7yJAREMDnKO9KXDRcqEAuf/Z7N04mC2uc/W2k=;
        b=QcXvVj6/RlR+nPF8BpOFAaseaHH2Njt2XEWHoDjyDKYc6iO6NLGnQilBsDbEoWbYIB
         bZiD1/FoBBgjH0XoMTchqrNl1iTMy3AstFdmP6SJaiZHB0ar28rYbP7i5Eqa1g3hM4gZ
         tOmc2gow3quPVp3gaXYgWqvT/hfUI4u6B48hnYawCdi6j/asJPFrpV913BK3WlTMUVTC
         0S5s89+I3uJRR4xskbRWei+jsZsA2Svroy9hKvSmhw6cEDZMdraf1Ox4y9je6lnDWpFC
         iUXbCohMiE/IRVpR0FOazDEvdjdcooSAqgXOpqJyuRBr2Qd/PlHSDjVV+SUQifs6OU4C
         YgVA==
X-Gm-Message-State: AOJu0YzHQdjdENIeb0nNLYbbBdUfC/lmS85S451gom6W5yOAsZGcHCpm
	y8EMbZrY2d/H9QbvdBdLP0CYILNc3rqRfLvs3WhEELEesxIWxmR9vWJBIl4Pkxo=
X-Gm-Gg: ASbGncuoc+C/66lssQEdzKLnzJYk9geIeHfsn3WltPYJ80ftk8aeP6e/QzvtL/m6TS8
	218wVL1fhWC/ApSQarhal07hAR9XFGSTwz1x/Yk0WN6NeY0vApRucAMvn8inSRHoKRxM2OsG6lz
	aAHG/SKDXFXng1GI1GsKmLMooc+38HSYz/92nr9+v6HaWQ/YXlYCB5lfTUfwdmpPM1ERoq53PYI
	9hFhRBOPrFm0xFiSFPR3eD1U0CxZ88Hz/Jj0zVisjymS3NJZ4TxjNG/L/SXvJXUHWpZZvELL4IM
	kCOSDgeqhVLarAgtNAVTdnmVE1zh8dUVlDHq
X-Google-Smtp-Source: AGHT+IGRlp8QwJeqgdMwkoz6Gj1LyqcQFfX5MrVhVEYU6cx+QnZIOcAvJGoE8y1S5wdMS7CNBOA7wA==
X-Received: by 2002:a05:600c:46ca:b0:434:a2a6:ed0d with SMTP id 5b1f17b1804b1-434d0a23a81mr35633065e9.29.1733262433670;
        Tue, 03 Dec 2024 13:47:13 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-434d52cbd72sm1182085e9.44.2024.12.03.13.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 13:47:13 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 0/8] multipath-tools fixes
Date: Tue,  3 Dec 2024 22:47:01 +0100
Message-ID: <20241203214702.107918-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Re-sending only patch 5/8 after Ben's review.

Patch 2-5 provide a re-implementation of pgcmp() without relying on
pgp->id, as discussed during the review of v1 of this series.

Changes v2->v3:
Removed two superfluous NULL checks, as noted by Ben Marzinski.


Martin Wilck (8):
  libmultipath: fix handling of pp->pgindex
  libmpathutil: change STATIC_BITFIELD to BITFIELD
  libmpathutil: add cleanup_bitfield()
  libmultipath: move pathcmp() to configure.c
  libmultipath: re-implement pgcmp without the pathgroup id
  libmultipath: trigger uevents upon map creation in domap()
  multipathd: trigger uevents upon map removal in coalesce_maps()
  multipathd: improve a log message in coalesce_maps()

 libmpathutil/libmpathutil.version |   1 +
 libmpathutil/util.c               |   5 ++
 libmpathutil/util.h               |  10 +--
 libmultipath/configure.c          | 121 ++++++++++++++++++++----------
 libmultipath/devmapper.c          |   9 +--
 libmultipath/discovery.c          |   2 +-
 libmultipath/dmparser.c           |   1 -
 libmultipath/pgpolicies.c         |   6 ++
 libmultipath/structs.c            |  31 +++-----
 libmultipath/structs.h            |   3 -
 libmultipath/structs_vec.c        |  15 ++++
 multipathd/main.c                 |   6 +-
 12 files changed, 132 insertions(+), 78 deletions(-)

-- 
2.47.0


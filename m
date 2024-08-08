Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280AF19149A
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130839; cv=none; b=DqT19UX5Oy0y9LKcnQLUI0E87S0U96osjCjcxETIQekQr/IoAqOy3PJDVrlDB/E22NByp+BQVTmTUisrh+vwM4Qp3W8y3/nOiTSJ5K9h0r7FAflWfw5WbROhNPMISdxRSAYKq6oti84bicJ6MbMu7qxVzq3P2pnhE1g9y3CR9nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130839; c=relaxed/simple;
	bh=KMh6jOHpznrGPn5hBBpsveX1kGU0fn18OXDXIXQ+R0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmJFcS4fE0PWh/o/imnzIQo/gBMzb9IZDBccleT36qj3EohgUVuhlkCFlBbVHX0BBr9Rf7/LP/2NjJpVLltQMJJFNGsMAoM38jAahMzYLyLzV+t6HJp6VIa4/kGAxDMK/p+gmsq/aABRUZWBulPaVw22jL0BKKAhqnXZi2VYIH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YBZJ8KbK; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YBZJ8KbK"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5a1c496335aso406878a12.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130836; x=1723735636; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+FghxUhQ4dkJ6SUz2TWE4xZEXRmDMMFe70BL8EAfarA=;
        b=YBZJ8KbKcd1nBuEa6Av1jtVNJx98qxQimp+W92JptcSC7shI6lUcyEMVD4d8s+Bmim
         xgh6szAujZlP2wQg9eKzNaLARLVC2f8KtHHc2/TGU4GWpW8Ivb+Vin2ECe8vofTD8fbX
         /7dUqDrLThqKvzxUNFz6gfWBEhXNQjsnFPDYnvHEQehy795OniztTvl9kUGTef/PJFB2
         eF8JcMCO/p+O9hvradAXhJD6FxEnWOUWj8hArRIsR6GuyxGKPt2N0TgT8R/8R7xeOqGH
         jokjVqiaThNAbRro0DLReIPgxvH8tchsrSxIKSPfyawNTwvG9lE5yYlVUw8V7goOVAjf
         GhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130836; x=1723735636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+FghxUhQ4dkJ6SUz2TWE4xZEXRmDMMFe70BL8EAfarA=;
        b=o5e+2hswzll2gev030f3ypcw3yNIH9sBG0N/WRUpI5Za2DAkqI9W9EyPUbKi5PexfA
         XAaTuUE4Zu4P+9lzNZYQpp5BaYyZJhNaSFtAERlSLJm4fko6XG63I419y8NXbx7u53Zg
         Tod+M4VNlNVgYO4in2Y4riprbsdubvnpP5OHvjzed23bwRHEfLRu+/sN2uep4OGZUiVU
         G25TD/Ai7Or/4eR4LcpAEHWcxNSSyFrKN42tK8m3HmjFBGV35GGmydGxoq9ip6ckHBwr
         bD2vqiuFiYaHVVZkMTnMSSIInrw1D5X/LbxoabiuahAgv954QmmZ6ewopqVA3BmGhdBc
         gmog==
X-Gm-Message-State: AOJu0Yz+qvUCPj0d6vYaZc8kLOKkSkPiCXoL1V8l8AGndYT0d75jx+qw
	epZKFsZKb6TvVhQ8xsI3oxUQ6b6Hp4TTZ6/LFN4GNlz//I4P5GnTxdIVPN2ylcQ=
X-Google-Smtp-Source: AGHT+IH39pRylZiWZEkIE/B/jdTQ7jWKLn6vOOgXuaH03H8znnko9zI2XrNCokZuTTzC/9kHOXRDvg==
X-Received: by 2002:a05:6402:50d4:b0:5a2:80f:a6dd with SMTP id 4fb4d7f45d1cf-5bbb234551dmr2291630a12.14.1723130836104;
        Thu, 08 Aug 2024 08:27:16 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2bf8666sm733909a12.9.2024.08.08.08.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:15 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 41/41] libmultipath: don't define __user
Date: Thu,  8 Aug 2024 17:26:20 +0200
Message-ID: <20240808152620.93965-42-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This may have been necessary in the old days, but it isn't
necessary any more now.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/alua_rtpg.c | 1 -
 libmultipath/sg_include.h             | 1 -
 2 files changed, 2 deletions(-)

diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index dd2224c..e53f447 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -21,7 +21,6 @@
 #include <libudev.h>
 #include <errno.h>
 
-#define __user
 #include <scsi/sg.h>
 
 #include "../structs.h"
diff --git a/libmultipath/sg_include.h b/libmultipath/sg_include.h
index 43bff2d..443819b 100644
--- a/libmultipath/sg_include.h
+++ b/libmultipath/sg_include.h
@@ -1,6 +1,5 @@
 #ifndef SG_INCLUDE_H_INCLUDED
 #define SG_INCLUDE_H_INCLUDED
-#define __user
 #include <scsi/sg.h>
 
 #ifndef DID_OK
-- 
2.46.0


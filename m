Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2356190041
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130814; cv=none; b=d79lFwOv2bqQzBv/yhgWWe9+hzcrJAKhphRxg3O32Qddqu0I8fSCHJIIOmWNLpr11ev4tUDgNurX2ZOuy29adsfw5P6sqhJhMWzw/8XzQ/6V2eVNfJUHA29rMSlLNWcwFnI8FAVkz2fODh5NtvKDM9MUnndbjkl5kylNBut1Alk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130814; c=relaxed/simple;
	bh=jVNMjNYh8DIX8/zMlpgMWQMvFlWG7FKqJG2hSM66f9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etdjdkW3mLsDMkm5dgwsJA/aaLvcfJ5rGyEKT65el0hLBmG0TheTKfio+RxmqtqnWIhkiWfrIte1xwFlguUIqt6KKXAxzFWwa19lMlFdI+s3wUjJSZTv6/y+uYSsrvZpkIM+8Y8HkQxTPpyTbvBTVLG9OdZB4xlg1/xzPdiBnAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IvQ53vA2; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IvQ53vA2"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5b3fff87e6bso1186378a12.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130811; x=1723735611; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQ8Io4PZNzNemtV4/C7X6xf4DKOlGmmFVM4qJyKEro8=;
        b=IvQ53vA23NqYISlXLwXWjiCdID2HFGxDC8gv6147HibHl9Bh2lvVittuvIxmqn4yWi
         6GRtK+n3d02D1kVG73EMO2JaiC1i4dDkOSqSAsQlFq+AQ4seW+v6TfyuIEIV8mwqoxOG
         RGhtu6ZLCsZmJoewAxS//V5QlCDKbpsaunU3PbNXlGBjlmCvLfEBFOBhV/tZnN9dgfM7
         3x73Uek+upt8332QHeGunYPNoUzwW60XEQkiT3mu6r2kiZZGp53104C781po019TRIaG
         PFrgsYh7o9oEu4UwK+sJCbczkDKQ6UrL4I7KkdVJ8iCrj0eeA8EfT8oBJqfrDIeP4wG+
         JePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130811; x=1723735611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lQ8Io4PZNzNemtV4/C7X6xf4DKOlGmmFVM4qJyKEro8=;
        b=RqWRZBSYDfUQJl9qRGmRsQQlZ3QXnyCMG2Jk9hLw04P78Ywi8k3yiCVrOjrJqNst5d
         ueKgSUAr1/9qJPSjKSKb+btnAVyjuto6lgNdK/lPbmylygDfpDNEm3SzjFg1LrJcv24Z
         IexNFmStxNSec27JhBwSv8w3f/gMiGWht27oUi0MfoQJI3zXXvU+7ymkxqrMRW0bpoyE
         C9AqO9W6Ip9eiyxBdbSdDSM/rBpMtLv2kkE90if6l016vu3nzHjLXCvad00Iunj2SoyS
         dMr63YNmzyY8EOi/SoPC7Rznr76F5NWqJ6IViyx+L3bE+spmMWj2sg98drfBgO1po5zC
         Lqcw==
X-Gm-Message-State: AOJu0Yyhyu6ir94DYqDLUa61vduh+lfkc//XE+2WEQRNfngDEjBGLkUC
	TePnopnOG58aEc9hPZSf6NFrafFHQ09w4qa05ORR8K/xgAweix6sjDq7WpC6Jsg=
X-Google-Smtp-Source: AGHT+IERl3n3QWHDgGlvhs8TcSZiZt0ytZE2e1U70cQ+8bHljjVPv35/IndBNC/Nb3HSsZDycKuBNQ==
X-Received: by 2002:a05:6402:2114:b0:5a2:84e2:c88a with SMTP id 4fb4d7f45d1cf-5bbb21acbdbmr1783462a12.12.1723130811076;
        Thu, 08 Aug 2024 08:26:51 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2c41ec9sm767502a12.42.2024.08.08.08.26.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:50 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 17/41] libmultipath: rename identifiers with leading underscores in discovery.h
Date: Thu,  8 Aug 2024 17:25:56 +0200
Message-ID: <20240808152620.93965-18-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 5bd35ca..c93abf1 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -62,24 +62,24 @@ bool is_vpd_page_supported(int fd, int pg);
  * discovery bitmask
  */
 enum discovery_mode {
-	__DI_SYSFS,
-	__DI_SERIAL,
-	__DI_CHECKER,
-	__DI_PRIO,
-	__DI_WWID,
-	__DI_BLACKLIST,
-	__DI_NOIO,
-	__DI_NOFALLBACK,
+	DI_SYSFS__,
+	DI_SERIAL__,
+	DI_CHECKER__,
+	DI_PRIO__,
+	DI_WWID__,
+	DI_BLACKLIST__,
+	DI_NOIO__,
+	DI_NOFALLBACK__,
 };
 
-#define DI_SYSFS	(1 << __DI_SYSFS)
-#define DI_SERIAL	(1 << __DI_SERIAL)
-#define DI_CHECKER	(1 << __DI_CHECKER)
-#define DI_PRIO		(1 << __DI_PRIO)
-#define DI_WWID		(1 << __DI_WWID)
-#define DI_BLACKLIST	(1 << __DI_BLACKLIST)
-#define DI_NOIO		(1 << __DI_NOIO) /* Avoid IO on the device */
-#define DI_NOFALLBACK	(1 << __DI_NOFALLBACK) /* do not allow wwid fallback */
+#define DI_SYSFS	(1 << DI_SYSFS__)
+#define DI_SERIAL	(1 << DI_SERIAL__)
+#define DI_CHECKER	(1 << DI_CHECKER__)
+#define DI_PRIO		(1 << DI_PRIO__)
+#define DI_WWID		(1 << DI_WWID__)
+#define DI_BLACKLIST	(1 << DI_BLACKLIST__)
+#define DI_NOIO		(1 << DI_NOIO__) /* Avoid IO on the device */
+#define DI_NOFALLBACK	(1 << DI_NOFALLBACK__) /* do not allow wwid fallback */
 
 #define DI_ALL		(DI_SYSFS  | DI_SERIAL | DI_CHECKER | DI_PRIO | \
 			 DI_WWID)
-- 
2.46.0


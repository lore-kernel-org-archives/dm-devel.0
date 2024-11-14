Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF0E2FE33
	for <dm-devel@lists.linux.dev>; Thu, 14 Nov 2024 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731595362; cv=none; b=My01U5CbVDdDc6jG3RXSmk1cwzb71p047ZiWfNFIW4l8TY4upyaqeBisH8c+fbpihlrdj0gS3Ohl/1F+CHHpVW+AGA+K18s2DuI17PxUj4MOx7UvIp7yR3uas6eoblhEi0BbEIfwKVEN/zcSZ/gJW9bw3mdnE/OpuGy2ysU6yHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731595362; c=relaxed/simple;
	bh=Dz7cvLq4LYAOlB7mTnsx9sdEa/ddbqHMoBBYrlH+rFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iV2OkuNNml93OD8PaEZAd6/yzUlc0VwMrMjz1qD4bB9walvq/I8aXT2DT4kwymwaKgfjLdHJctDJz2cZvpO50O73X2xz7aqMGFBGQ4f+PnmwuEeB4wTiD+yqhtT+p0XYPgGzTv/MrTMXkL/I0X5jTOFKPKKUNCuV9wraW4qovC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hhz3Ut7V; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hhz3Ut7V"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53da5511f3cso651788e87.3
        for <dm-devel@lists.linux.dev>; Thu, 14 Nov 2024 06:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731595358; x=1732200158; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Ob7OKEo+ClsIU7yWKh0/QMz/ftFWrfp8Xj8xVGqngM=;
        b=Hhz3Ut7VYY0KGAtcEI8m/kSdKdl7NF6kNzmGGGaJmjjeaJFRBZft4wtW7Dq8aqjeuL
         k+p34N7EbyqB+5xC4+F0FabqkwnxLn6VLG+OmmUxgUb6DlFP646GPgi7zJ5IHddc+1Vf
         DT5lznb2pHXTruFjfmgdtTQx35omBUMXvTW4xQsrWMpjy2WpuFJyG8f2LYoM9I2FnP5p
         BOusiQBBIWCaWnwLbbkeWupMshV5gKpWjndhFJ/drNg9gBrRcO2ThFmnxFEFudp13zoO
         FFm/gMPRNHoQOtbIx4+L2u6Mj48/mi0wD1ec9RiFnQC0F+DBA9n7u3kP1Vimhh10ydAp
         5K/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731595358; x=1732200158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Ob7OKEo+ClsIU7yWKh0/QMz/ftFWrfp8Xj8xVGqngM=;
        b=SeUlXGl2/GWucBW0dXPF94cVAJRtIBewTdx7FEPgi0z1kGuvGCQTbRBcRluCuewIJA
         uCR67pYgVOqMIGffnIpt6slD8eHuLWhciAuel5HDRCQsstWhVm2/gzmjcRTRKb2fjkBL
         WRjhaDXSwiKYiN71kpYDiY5wGtPSYoLKz4At+/E8ggWaQJl4wUGGYY4clVxZ7IK6BFXr
         h/2wx1Q6+59UsWD2GKFl01XW5sN4r33eSgiCKYo5AlZAC+B26FG7vPmctx8uuOlXGgZJ
         csgY029PZQTSQnckqq5jFzo87kJIiInNCY6VL8GoKMLaa8e09dNGMVQ4+vlgGqNC37g3
         kE6g==
X-Forwarded-Encrypted: i=1; AJvYcCVq0HcLLYGq57+F5K9rxg/mN4n8c0SZfgU7ICK8M2+YT4xF5rkYnSUyqLLvkPBNEV6ni0+Y6nNYLg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxQo/PgP+QQ0m/i3pFgrX4L7SBYrer0uLlrYhCtPcyT64M8mwOw
	/ZqhEiFkxB3cnBV2hW6sMvB3De4t9RO8PWZaE7q+u6ER8piOVSeoKRMQ1HWT5P8=
X-Google-Smtp-Source: AGHT+IHX+pI1/EcwbleE9DNztsWbvxZdJ8aKkCphv+4ytpGWMvMw1Ks6sANH8UGMQq4dS7fnWe4qbA==
X-Received: by 2002:a05:6512:3e0e:b0:539:eb82:d453 with SMTP id 2adb3069b0e04-53d9a42dfc4mr5936868e87.39.1731595357918;
        Thu, 14 Nov 2024 06:42:37 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3821ae154d9sm1683394f8f.82.2024.11.14.06.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 06:42:37 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 3/3] libmultipath: cut watchdog interval in half
Date: Thu, 14 Nov 2024 15:42:24 +0100
Message-ID: <20241114144224.248606-4-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114144224.248606-1-mwilck@suse.com>
References: <20241114144224.248606-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to [1], a daemon should trigger the watchdog every half of the time
that is communicated via WATCHDOG_USEC.

[1] https://www.freedesktop.org/software/systemd/man/latest/sd_watchdog_enabled.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index bd199fa..4d457b8 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -877,8 +877,11 @@ static void set_max_checkint_from_watchdog(struct config *conf)
 		if (checkint == 0)
 			/* watchdog disabled */
 			return;
-		/* Value is in microseconds */
-		checkint /= 1000000;
+		/*
+		 * Value is in microseconds, and we should trigger the watchdog
+		 * twice per interval.
+		 */
+		checkint /= 2000000;
 		if (checkint < 1 || checkint > UINT_MAX) {
 			condlog(1, "invalid value for WatchdogSec: \"%s\"", envp);
 			return;
-- 
2.47.0


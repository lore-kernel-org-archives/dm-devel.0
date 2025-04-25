Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9813597A
	for <dm-devel@lists.linux.dev>; Fri, 25 Apr 2025 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745588774; cv=none; b=Itd4ZpItN+9IbORCVRO7wPVzV/tm2Cge5atcUJPtZmqPp5oY8uaJP9x4ZQiqSNi9ZJECLmyISMBXenek7Mw+eywgqjxGz6q/ujmZ3imnn/84M2djQnD46JJReBER9O3ytsRGibTNLczpPZOa516JBYhewu+alhS1qIU5xVdBFMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745588774; c=relaxed/simple;
	bh=0H8bbTPo/PfAEvjI9PoZPZ3NHX4i3xV7zu4kIGw9DZc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WuF/sm0yNNkNF7Ia9BuWVpWWOfXtbeOL1N2SkrFuYUj+1pYbl+F/x2UK3DriXP5mEIE/jdbebBeZj8bqMCAqFaf5SaVGJL/55ZfDShXKa4ejDMMiOocKLIZpgL+Z8GHM5rCSsKO57hngn8a9AkYC6lB9hTF3SviwG9YaahUFhxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S1YdI+5t; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S1YdI+5t"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cfe99f2a7so3281025e9.2
        for <dm-devel@lists.linux.dev>; Fri, 25 Apr 2025 06:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745588771; x=1746193571; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bOdLROu3wJbojscQhoZPo16E581e+G0ZmtJgxB9OnKs=;
        b=S1YdI+5tFhcDkgs18G6V5W6zyZWnPRfx5KScTIaz9Ulo646z0DdOswexLQCOFFZEJQ
         ZQ9Tbh633Q2q2+fZQn0LrafPCxe3AswAp8c+iMHCYB6CH6ot7H+d7lmSUZwK+K6uqpb5
         OXlRg59YaQ2zwuvjwtoBNcUubfybUvAwWMHr6VpjjQdgvESzixKHssHqfW6JpWR94Btr
         4CGFYwosr4R/A9myn+lMxZPvSuzIp1KScDxJA+OwaLjH7u/UJtoCovHk4ba7YA/qq/26
         0dClA4/EKu/A2zJ8YKgOyfJNqFERkjIEvVM5E/5NZ/XK+phPQ+87+x5ORNGrVeg7tCsE
         18SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745588771; x=1746193571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bOdLROu3wJbojscQhoZPo16E581e+G0ZmtJgxB9OnKs=;
        b=mRpQ332AF9iE4duPiFSuYQyIaj5CPG389tqoNd00chE2/sVIyh5TK14kpZ/6zIGKa7
         oIPkh/AxYsbm0avu992hGXs3LgkIYNHWP1491QyvNiIM1trqVlXVoaJjyRX+40oJZ037
         RHNnyS2FzSXWD8MIGCEOaA8Wnv4sFqr5sSXxz0vdds9sPL7rVfRCaGiRIRAusHvXRcZw
         OUN8aT0slgz9lY8Hi0v5wOmuy+6rsJ6RHLVfqU00QVaH6YAFFQtR6rPo+gnQo1jqOyXz
         yNc81ZptVcRfExDgLgQsjVO55H7I/17sMZRCvchqnUgBMUAWloxwiWNytWdgRmny7w2S
         hYUw==
X-Forwarded-Encrypted: i=1; AJvYcCVtvcDe1pBCDBsG/bWCQSQlF4pUdPec7+8CQ5Mexz/HSRwKU6PcEHUZ/4q/anowUIhIxYqy+4ciAg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+nvepR2PZDgf6X+w4em1c5bAM5u7N8UIVxr5oPpvbO8snlxl9
	xlfhW84G6fcAn6nLr6YLbIX/j0PnCZNcDMlPVFQYHIdDoKE2MXv00rKAVLb1MQ==
X-Gm-Gg: ASbGncshenvWtnJ3pYIo0v7BdCIZ6BduqKBaibdeX3rqtEXbFct5dqb4pWP99Kk1qLN
	zLnhv2nJChouJQMDl60mrHRDTyRMZzFrz+6WY3zOGCaouSFpu8fz8l3/ES7KoPTaMfnixqklsYt
	hL6XiJmb6j0+9c19Gl/kXJlpxu22FFmYt5SFLSKwqSwiDRBvNwU8aQLbwSVTcEueHwW3f2g/sSc
	PwZD9uMUGxe4ttwbCgWbaynBHhBplGJBqCI3b0m/MbNHo27l4nakOjkmiy+ZoO9/pw5c1i2MziS
	bTfQuz/uD2lhC/dOsh2q8MP/hgrNNO0XBS1YwThXsLCkoEatE+iW2y1/RpiFQmPvHcG3c/bUi8R
	AGGyI8MKh
X-Google-Smtp-Source: AGHT+IFSE3K7T1HytnoUqVYecWQclynPNbJ9cW1twGEoEF0s/IOy53MBr1VkhcBRlGGFqcm6A4B2ZA==
X-Received: by 2002:a05:600c:2d53:b0:43b:c0fa:f9bf with SMTP id 5b1f17b1804b1-440a9edb7c1mr2204295e9.3.1745588770783;
        Fri, 25 Apr 2025 06:46:10 -0700 (PDT)
Received: from localhost (234.red-80-39-170.dynamicip.rima-tde.net. [80.39.170.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2a0e7esm59906705e9.10.2025.04.25.06.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 06:46:10 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add Quantum devices to hwtable
Date: Fri, 25 Apr 2025 15:46:08 +0200
Message-ID: <20250425134609.186615-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Info from: https://qsupport.quantum.com/kb/Flare/Content/appliances/common/InfoHubDocSite/shared_SN_appliances/Topics/overview-MultipathConf.htm

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8001d5be..8b43c14d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1322,6 +1322,36 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 30,
 	},
+	/*
+	 * Quantum
+	 */
+	{
+		/* StorNext family */
+		.vendor        = "Quantum",
+		.product       = "(StorNext QX|QXS)",
+		.bl_product    = "cvfsctl",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 18,
+	},
+	{
+		/* F-Series */
+		.vendor        = "QUANTUM",
+		.product       = "^(F|P|H)[24]",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
+	{
+		/* F1000 */
+		.vendor        = "QUANTUM",
+		.product       = "^F1",
+		.pgpolicy      = GROUP_BY_SERIAL,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+	},
 	/*
 	 * EOL
 	 */
-- 
2.49.0


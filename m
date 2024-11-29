Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886AE14C5B0
	for <dm-devel@lists.linux.dev>; Fri, 29 Nov 2024 12:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732882163; cv=none; b=mxyfheO31dzyvu+8XU4kJJfZcBz+8gr+LtmKuGfP0vk942l2CXGGpAj+BJ/JWZR+F1I/iYNlC41kxSKU+qsaDfapmoTzO185ch7zV1BB3oBzKeK3t4vVQup6NdYGMI7NfIE3IyELYZgFyGgKJDk6153Vz+KulEhtExSBPpw0xx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732882163; c=relaxed/simple;
	bh=Bhk4LQGqJnZP8PHt+Ge0MMbUddNyHKw+g1ptfQtxvNs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sV1ZKvO/IHG5kj++5WfTJG0ZX/chns/zdFa8bXjdO2IVMD/PGOQWY9jo84v0ukJkVD9zNkF1ATEwAcspvjN33nSEa65wWwcRzFXkcDe7mQAh35FfkDJDX+6uZWi/QGFX6sXRvyqoIyI/qIxAz588/yA+rrJeLr8FRKh1UJr3Haw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UtqGPdZI; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UtqGPdZI"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-385e0d47720so27141f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 29 Nov 2024 04:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732882159; x=1733486959; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=03S5f46/f3Zkh7Z6rIvSnBORp+M4h7ZiyRqDhfToEdE=;
        b=UtqGPdZIPH98gydHds9VUMg9xdZT5up1cV/F4/AvWIftIRNFYh/EFCqsJjyFR/7pbQ
         Lv37k+yj98t6N0o5b2n+Qx/NvfI+LknCeFMhXJOD/0jmSsJG8imHmVUD48kSx0OQCzxz
         96LLFiftE6EIS/nQZUEc4tHyvwS39Ia2Bij3jYopfKw7w5z5GA0BgRNK7m8VGoPuRUNw
         y0/v0xzx0O3eMdKUwQlThNwt0k41KR44qPP448eLZEl7LWt98vqFtqU4jOkC1V5GE1j7
         UmRxoIEd44RuVZ7V31pcqGtvjHdSbyWRVBU4glRgwJ8RyFGtvhCQfHmNDq5I6wsLVGR0
         aoYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732882159; x=1733486959;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=03S5f46/f3Zkh7Z6rIvSnBORp+M4h7ZiyRqDhfToEdE=;
        b=ZP/lFPE7FhfTSIKKsRq3Bpv3pEjtjqZkd4GOMo4HBt+EUvt+FSNbAAzrJ+mhvvrV6z
         2X79qrosB6dVue4pfXQ6D5EDp4qK74UQbVJma/fpq8OZC7JJF+PZQKGC+XOmJennYB/k
         dvsM0hRVvNPM8otA9yy8TStY2lQFvg/Q6oOnIp3u0GaMVm01EziwZCEQcK7JuzoFshhT
         XaEwVq4xUe51+HrUvsI426xWOsZf/BnFXjOo0JI7gAjgGk/wuZHbZZ7AGhzmlrMJD4Io
         KqDg0q6pCXGntkJqvidIaKV8xhW6xpLW7DZH+kLBFmUPqGwBH8+8POx6k/CTYXEIeOSE
         d+qQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQCZspzGzi+4GP0wO1bNCIvJ2bvXpWFrSCXpMpny403xbueM4MvPHnsyNpQu477wYwg52AnxN6dQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0UHvY+84qySDe/QKPoSq7TwWaxw0vjMHq/ggzNWgYxdUOrYhr
	cUcC8SJ/onOCSumWQ8DAIsJY21u4lBNwwXKnCoHyqpJq1PJur2M=
X-Gm-Gg: ASbGncvk9y/zOXB3xWpPC0A1rYksuOPqGCbG+mOiemPZG8f/2jXxj++LSxAWSbO5fk5
	G6oFoiMmRx5i5u/hb6/5p/TK48CoDovWBrFPlDq5Fxi2P/1FzCzE1INAiz5UsNeCZWWf+Q+QOV2
	GmP9CjfHG7QuHNDQaxiiDiTkUplnZWW2JI2l/2JWLnB4Nsr68w/4M39wnelmcs28LwVW06e+k7G
	iu3WvKjrVW6g10hNQhYVAF6DWDYWRCWv9CSdCiz7RWpI7yylPycKICpsxjAh+URJi//OmRFI/oA
	pPRDqGevO6U=
X-Google-Smtp-Source: AGHT+IH3R0oDS/Rgwa+fmwXuYzUGNzfXrWVuCPh52CnPpWXgsYpyzlu1BxzXRlKeBOEYzmdKudFz1w==
X-Received: by 2002:a5d:64a9:0:b0:382:5295:b354 with SMTP id ffacd0b85a97d-385c6edd020mr3813660f8f.13.1732882158485;
        Fri, 29 Nov 2024 04:09:18 -0800 (PST)
Received: from localhost (89.red-88-27-19.staticip.rima-tde.net. [88.27.19.89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385ccd7f934sm4384106f8f.88.2024.11.29.04.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 04:09:17 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Gleb Chesnokov <gleb.chesnokov@scst.dev>,
	Bart Van Assche <bvanassche@acm.org>,
	Vladislav Bolkhovitin <vst@vlnb.net>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add SCST to hwtable
Date: Fri, 29 Nov 2024 13:09:16 +0100
Message-ID: <20241129120916.302317-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Based on: https://github.com/SCST-project/scst/blob/master/scst/README#L1905-L1908

Cc: Gleb Chesnokov <gleb.chesnokov@scst.dev>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index cf39a50d..8612fb21 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1036,6 +1036,15 @@ static struct hwentry default_hw[] = {
 		.checker_name  = DIRECTIO,
 		.detect_checker = DETECT_CHECKER_OFF,
 	},
+	{
+		/* Generic SCSI Target Subsystem for Linux (SCST) */
+		.vendor        = "^SCST_",
+		.product       = ".*",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 12,
+		.prio_name     = PRIO_ALUA,
+	},
 	/*
 	 * DataCore
 	 */
-- 
2.47.1


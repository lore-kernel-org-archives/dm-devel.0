Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B0B2DE70C
	for <dm-devel@lists.linux.dev>; Thu, 21 Aug 2025 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755794997; cv=none; b=HxHJYGRRq145bNCpbYe+aNtscYCaEMCX+pzwS8GLg+Je9Bj4q1FlkZcJSFX8r+LX7rdBk2sus1noBPsvgcqIZhhfPO1eqyFMxRxLfork3UixCob9VV3LL4GKEwT2ceg2gDSIog+RR6XHjhcyKrdH9bVe3VU/WggZNWO5dENVI7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755794997; c=relaxed/simple;
	bh=j1HPu+xf82+sSceY4BTW4wlDho9OJP75SC6covMR4QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GYZpmeNmQpjq7GkZq5Xs6FEumrLS5GTHQgVnGlE/tR+acS+7khnswW0xMHFutY60mEtSoeJ143NfO+/LlJOkj0H8kM7QJrtgRoeQa0Wmx642WrmhLv2ejzxnuu00mDFuq3wEhzXJIb9kNPX0hE68JAAWSt64bPLkOWKMSrh3B3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bLsyd+p+; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bLsyd+p+"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b46158e11so957375e9.0
        for <dm-devel@lists.linux.dev>; Thu, 21 Aug 2025 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755794994; x=1756399794; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f7t2f88agrRS1B1iAJwzfiSnfOHeW10+a3UdQ2eynTw=;
        b=bLsyd+p+OQT8SVkETG8P1X/1tSi+3+70mvLLFp0mnAtr9oRpj+YX55UB/qZssah3na
         lE1p+ydxg4qHj8ZglLIhBr+faOP8yzURIlRjnA6pDc8El/3fkDhjL1Uky1BKq33L3Xvs
         LdhjW1sep4dCvETB7JRxzuiZvOD7rHoCzSmnrp5K2q449SZ1AXX5IooOrQ9ltMQ8EpBX
         W7a1hwTse/k4BR1lF82486Aoza2HhK1sdGMexwKHyV3fZtssc0Y0LXy3t72NeFtlPt7M
         N0o0jv64HLEOk40OGSJg1wgej960lBwowoYkhSgLSRA7JtrzhWmnqp5iPv3m/SoncxTX
         AQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755794994; x=1756399794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f7t2f88agrRS1B1iAJwzfiSnfOHeW10+a3UdQ2eynTw=;
        b=OAKKFIH2nIRB6EMdMglNwJ5Orz9YyyjlsrCNDdWYQXR352MqDfwmew8sosuRoEhkMv
         N2JRrfBW8FW6rLYW7GEYuRDu6orWXOl0XKxoFFc9y0wJ3QO4fd/3mGRiEZ7b8bBzeIJ+
         HGBIefp/pHpnjODqD+iUzFFHIuRsdAMm4mHuR8OjajfaUgPntXYmByXIOS4Q3UHgorwJ
         wlPeO22zamtcN7PgjgFVio0gvPyHQRhVc51E7iVa0LhQjZM4nb4yQ3JHDt9FQWxntI6M
         j8LL5r8E39u2QP0QCuGgPklNC5FTiJut/4dVEeltY58N9BXpnq5zIezaRWW/mtnnvqmG
         at3A==
X-Forwarded-Encrypted: i=1; AJvYcCWNeqq6KAIYoBBxqijDXWqpbjK8eLnvOMrzv5BW1F0trcC/SgL7DqAjB9Q/vTcrfb0TQNdJbAirZA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwnYbBCzEM0RdKO8AstUpLmtqhavK17pyVm4iOJPMQjfuFaDsKD
	7Hp48/EpIprklFIFYUTeFAsNd30ZU8vQpIcMJcEMatXo3ZgWzQ6wlgw=
X-Gm-Gg: ASbGncu/GgnFT/bqf8/GLNoKOFHBQBfn0Qtg/SgfLKTkZMuW0mMQdr9Z5rh60frkEcd
	qmXWzsNz4T8dzM+YQiOT0fJegzDQNUbbXX6PcNsyDp3YD98b6+mZPLVpZXfjIINi0exYvMJUGe1
	qpNxhO7X5AzANtSq+uM/k5tkyQdEKWxJeEQqW8bZUIps9za7js0ZbNEpkloCJmkKn0I3KeC/1bK
	6wC/5qQZvfOGxyRO1IKF+zsfXykSg64675ZQXWUFl7a0hLozOvy3L2j8Pjw7gAGvJNi124N/hiR
	3VE5BPuekMGK/W1nWrXinmQ3Z0pqPZjifZ5sgrEp3eGpwhrwQrSPFLAleDEfIxA3Hd0Z7eIdgXW
	bSh2UGI6Pv9Yvk1ZOygtMAwg9OTwBUKUniqyzK7GuCnmfF/N3ORS2GqyLStvp
X-Google-Smtp-Source: AGHT+IEFCzGcsgNZSCK8jgQNmnNP6XuCcbIjfi+E7Ny9nmr/AplG4StiUki6eZCbqEcqFRU22rFM4Q==
X-Received: by 2002:a05:600c:a16:b0:459:ddd6:1cbf with SMTP id 5b1f17b1804b1-45b4d74b053mr15281275e9.0.1755794993528;
        Thu, 21 Aug 2025 09:49:53 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50dea2b9sm3562025e9.15.2025.08.21.09.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 09:49:53 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Daniel Wagner <dwagner@suse.de>,
	Daniel Wagner <wagi@monom.org>,
	BLOCK-ML <linux-block@vger.kernel.org>,
	NVME-ML <linux-nvme@lists.infradead.org>,
	SCSI-ML <linux-scsi@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] nvme-cli: add 80-nvmf-storage_arrays.rules
Date: Thu, 21 Aug 2025 18:49:51 +0200
Message-ID: <20250821164952.148153-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Missing from previous patch.

Cc: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@monom.org>
Cc: BLOCK-ML <linux-block@vger.kernel.org>
Cc: NVME-ML <linux-nvme@lists.infradead.org>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 meson.build  | 1 +
 nvme.spec.in | 1 +
 2 files changed, 2 insertions(+)

diff --git a/meson.build b/meson.build
index 3afd8ba3..8c0877e1 100644
--- a/meson.build
+++ b/meson.build
@@ -270,6 +270,7 @@ udev_files = [
   '71-nvmf-hpe.rules',
   '71-nvmf-netapp.rules',
   '71-nvmf-vastdata.rules',
+  '80-nvmf-storage_arrays.rules',
 ]
 
 foreach file : udev_files
diff --git a/nvme.spec.in b/nvme.spec.in
index 5f7645d7..fa921f81 100644
--- a/nvme.spec.in
+++ b/nvme.spec.in
@@ -36,6 +36,7 @@ touch %{buildroot}@SYSCONFDIR@/nvme/hostid
 @UDEVRULESDIR@/71-nvmf-hpe.rules
 @UDEVRULESDIR@/71-nvmf-netapp.rules
 @UDEVRULESDIR@/71-nvmf-vastdata.rules
+@UDEVRULESDIR@/80-nvmf-storage_arrays.rules
 @DRACUTRILESDIR@/70-nvmf-autoconnect.conf
 @SYSTEMDDIR@/nvmf-connect@.service
 @SYSTEMDDIR@/nvmefc-boot-connections.service
-- 
2.51.0


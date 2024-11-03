Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6642A18C32C
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 22:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673850; cv=none; b=UEyaiNpcfad5/+TJruaMMDBg1D1ITrhhpgGn0gXllWUr9rRkJRboJ9pQCYoUDQevqWlLyYw0gRtfUeLPySO5E12v28cMkMzaM+xnDZoIWPMKNcxjTfPOR+0eQQl4akpUaF3M/NPKNiyxL6bPlhIomzPZ7mz6VaeCE5UYi3AGJSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673850; c=relaxed/simple;
	bh=XmJOM3nmbilBHSQPDYyziI41V5kBaIerveFfvWSNRGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvWzB1ZAb7gWxVl1VVBi9rO22rLtrP7MQ86ci/clJWxYz4Sh55Tl7t8at9lCp0Ek7r4Vg69//i6mmZsT7PwH0V8BVMgvoklQAsu+Cv/gzZsW6wI/QX3VucWncmwdZGPeOBTDyXp5I5cu0bJlC30oyHAul0iYZt906m5guyEur/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XR0INfUo; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XR0INfUo"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a99f646ff1bso471128766b.2
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 14:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730673847; x=1731278647; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uwlxkyvYzOMdEgSK8PhXxXKls25vwVgjE+wEgTZZ54=;
        b=XR0INfUoP389lsf/GRqeJ+mMmgXISNv22RqKUq0G9wCSP3GeEhDQMkzRQqoeLZsaOz
         IqJhEGm8Q3k3jNPW1o2/WuiCIJxT72pzx/SuNh2386FCOb6bV8BDIMzB7s4/JBtn7uEo
         3NPBe2h/fQRxHUhglH2qXJuFBIMGINCzUba4T5vTJ8OLWyV1HK9hFEdi/dHRsjluyf4y
         SuT7aH3tQkZ8daaHpGSZf8ZvWq2RkV4zv7x0mqZATTb41RBk/FN1BAxze6kX0VLBOm87
         bwEZYDkZSUYkYWNTDvecn82Agne0FfoDbej2+43nsYRga1XvV33qTYDBXC1UK5X2MXr1
         Vx/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730673847; x=1731278647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7uwlxkyvYzOMdEgSK8PhXxXKls25vwVgjE+wEgTZZ54=;
        b=MkVuxLlI45WJuJRF8imcwt5tBP1LAiuw026ptl+GgiGK9mei0sJlZz604DrkSQjsBe
         DUjmk+uIq2r4f82UFbkaw6tBFuy1svC3f+gFiGVS3B4lD96Q8uMRHWKDs34kNbOQC9uN
         iGEMCpkbReg5QmGT4VNXhagt57EEZaQ8PmnybmUqAFMVrVzCeBroVn5S/lS89R2RANfX
         xAmFc9r2pPOxbXReF+6EVM/dh9x444qScABcd2zzuGYvnhgjKHom55v0K/Pudok/XaIc
         HZcnrKjyp9Q2Cu3Bho+RRf+TXuvtybGlNLeqtTHvgFG5tkhjV/q6n3dvoH2P8qQbBpeC
         2cBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuIGKkPQE686ypO959dnd520Tlvkv/xI0Vkd1cZlNUJA0OmSZv6N4VcJ1RmccVpsKtT1VkCRtdlQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzgsxHua32nKWq6vPoR5zZhDKBVwMtvnhyOQw0ZgZ1zoYHgxqR6
	+8GTM026oRJdFTqvzBsmJRc7b0d1jmHMweW74hpASL7bJC1nJ1jdKRzPFUIAheo=
X-Google-Smtp-Source: AGHT+IEZreKfFWDAqXk2Xvf+A/ocvBDBtPPr6oboxzVjdEeeTQGn7nOFOlKnch8yXhBLFgRaw4TU1g==
X-Received: by 2002:a17:906:db05:b0:a9a:3fd8:9c95 with SMTP id a640c23a62f3a-a9e3a6c8064mr1761886166b.47.1730673846401;
        Sun, 03 Nov 2024 14:44:06 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a9e564cbc39sm471794266b.86.2024.11.03.14.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:44:06 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 5/5] 11-dm-mpath.rules.in: set .DM_NOSCAN if MPATH_UNCHANGED is set
Date: Sun,  3 Nov 2024 23:43:49 +0100
Message-ID: <20241103224349.42582-6-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241103224349.42582-1-mwilck@suse.com>
References: <20241103224349.42582-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When multipath reloads a device or fails or restores a path, the udev
rules disable LVM scanning, but since .DM_NOSCAN isn't set, blkid is
still run on the device. When multipath devices that are set to
queue_if_no_path lose all their paths at close to the same time, udev
workers can hang trying to run blkid. The blkid results shouldn't
change when multipathd is adding, removing, failing or reinstating
paths, aside from avoiding hanging udev processes, we're skipping
unnecessary work.

Hence, set .DM_NOSCAN if MPATH_UNCHANGED is set, to avoid blkid from
being called in 13-dm.rules.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 79227be..a816edb 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -145,9 +145,11 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 
 LABEL="import_end"
 
-# If MPATH_UNCHANGED is set, adapt DM_ACTIVATION.
+# If MPATH_UNCHANGED is set, adapt DM_ACTIVATION and DM_NOSCAN.
+# .DM_NOSCAN controls whether blkid will be run in 13-dm-disk.rules;
+# we don't want to do that if MPATH_UNCHANGED is 1.
 ENV{MPATH_UNCHANGED}=="0", ENV{DM_ACTIVATION}="1"
-ENV{MPATH_UNCHANGED}=="1", ENV{DM_ACTIVATION}="0"
+ENV{MPATH_UNCHANGED}=="1", ENV{DM_ACTIVATION}="0", ENV{.DM_NOSCAN}="1"
 
 # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
 ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
-- 
2.47.0


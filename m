Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574572;
	b=L22PsWQlFGBsfxhBckDzkrfaYEnGFV1iNtAe9u3VjP9qx4fS+9muFZbhDGoCOqCpGBJS
	 jWKL2kNk947BcvfFzRnj8sNszBpG+FkdktnKTgIX7Y6Eqc7z8nBURuWj2TVbVtIul0rMp
	 SRjJfnUB7k3A3/SeSS/8+xL44c2wNNXASwA5PQYKjDX/sduBiENop50mmlVtPVjUBQJOD
	 /qFqnDTFHUKUBOzJ0PEW55IAwx7orP1WMo5gmUuvyNovuTQMarf37CHFjwcgg6snnOSoc
	 ErWCDlbp7ggIzfqP+1J9Dh9mIrpUBTXJucygJKsBsecPpU+EtZkVuVxt6uVPStApLnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574572;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=+tuekhg2o5DtfkLSDAwATadtJIH3nuaaIn20dJGj7SA=;
	b=UxYAxs0UeDO7XBDi47RDgOmauVOAvXYmVvt7OWKd37qLMGw5yzyLjfJjdh54x2XdqMH7
	 E5mQByxmIbRkPp8vEdndrPR4utQRWNc4q4fJrOTeMvjONyDwpYm1bh1hUCeWYWOUXbglN
	 bgXWptsmEwGH8oPZKTV+wFHBfcDz4B+RZweVZT5m0pwUySEsgpdVAVx0logXBh/PGTFAS
	 Z4paBszc+iVP6PA8axChd8pLvrKbmEW3b0wL2Nm+7Ycwa+O0UWEULqWqHFXploEEG7TED
	 1nfUVw/BH8wJhcZAI7pD+jXbO+jj2HJwSMKssSonkNLa4AhZw1X3BKvNXjjdNRcnhhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B+10DiLv;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C940606A333
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C940606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B+10DiLv
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a78ec32fadso1684495e9.3
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574571; x=1795179371; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+tuekhg2o5DtfkLSDAwATadtJIH3nuaaIn20dJGj7SA=;
        b=B+10DiLv/ZVnXs9C8bx5oxNgNG2DcEGtIVwTR86wl3VJvoJgwBVhdM7ilhlJLXohQG
         xrOOkSqaA6guEKVIwdqBByLH3OxUhGnz8RMycgvlMyOnPucitYYCmTj2DQodhNjkDPJb
         C9yFzHPj591yFFGliwWCvHC2lBVnyJkjknpIRzYb6oiFocjPEtYfsexThUwhIpMP0lqE
         qH9+mD3KPC/waITyeoOglxztDSlUXTvXvq3XuyusS6in3TWw2IWZThRJitBgFiLflDyf
         Sg+bPr8rWtHbghlzpmocgKqIf8S4EZ+V+Teg8xppaPxPqxT9bdazDRGpNYngncEkHtXM
         XZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574571; x=1795179371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+tuekhg2o5DtfkLSDAwATadtJIH3nuaaIn20dJGj7SA=;
        b=ffZW89GtgIxZ/2NKPcZGTL4+fCzw3RoSDJrA/K+acf+RR001gGprhQto+BefX38Xp9
         yJmQREKlEdj05Egf30XayCKYzho0X66HTkOAn4YEDI6ivey+5KdnZBnJhbX7/+3X0GCS
         r2VwiL5IGw/04SNF9sxISI1cOun5w1OLfCv8tjd/w32W3zP0on+UfxlK0NXJUvu4oxw5
         OdVC0pruAosJIWWZetVAW1otMUI1X704IO0kVQgP6nlQyUkpf2YJ5tal6tSrbzn9LTWU
         e33jhp3LrIiR0cGJZMf3zK4xYVJI7FllCDhRIQ09qRYzo/RCUeR7oYtCmoMu2LpXbKCA
         HkDw==
X-Forwarded-Encrypted: i=1; AL+hErELNZB7yz2gnddSKK75SBXGtRS+ESTVCTtOWjX694hnbKo0TrZSeILr9ViCxrqffM9eHyye0N523Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z9yEswuO7HvpfstX+u9E+nvbTg1qW4UXVOSCwZmHNKp2PV0gMwn
	rNvvkrrHFHgPyxV/LMQNwcOOEniywdG+oFs0o1DV+h9f04jEiTvflz0=
X-Gm-Gg: AYBFou1x0H6k0dvtnkEAqjrlpvMY0ncm7FdvldbGk9ztIKseTk7Xh+85kaFBwMjTFdB
	jg76/Kq2diEFW3wCIk5f7g/MYW9CaYtg3kky9aLisLFPF53qTACwuDEWGswUAq6hSDEPiDbgrgn
	t7qQC/gKqCMsYGwyiezoQiNMNu2J4x20U9osuKsHaZrokmMpjRR/9NSRDna5TE78GXDMdyQFNw2
	+5lJGpETrPS6hpa9HlvarI8l4udCOYX9x78BlYJYJy8kL3jrnfvZhq3NIiKz13DvEWzlyvignpe
	1LSC4IDWTArG8kR/Ba/RT1YyMI0LA/L6oLM3/BdXFgni1qZVYCluPsZQWmYUl5snpVJ9OVlH4aS
	TPkphz45MeqzVJaZxxSmuKzLj8eN7tU+QOgErBgonh8Y7psnURA8jKuiN0PkOn+lYZ5EWKuREzO
	ndAH2UtxyXHnOb9GOs4wyvhJeXV/6NmIzzngLjeNnHzLwlspUoX352bY0tCA+sW6T3nOql4S8F4
	R/6tttcoL2WhjyNQuReHRLjN4nZB3sYVDZhcTY4X5Mye0FBaABYa7yWQUMkfZH7LYypRqQ1vO63
	lRWi/R/HH10YL9Nl52wXfgbYqSOeRJbTx1fbTd6VzMcDf2D4Hh19mEoa4MNUt+fuhw==
X-Received: by 2002:a05:600d:644d:20b0:4a1:b027:99ef with SMTP id 5b1f17b1804b1-4bb55a3f05cmr41333945e9.2.1794574570473;
        Fri, 13 Nov 2026 04:56:10 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e252f7fsm161939365e9.2.2026.11.13.04.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:10 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 04/13] multipath-tools: add EMC VNXe info
Date: Fri, 13 Nov 2026 13:55:36 +0100
Message-ID: <20261113125549.504780-5-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

VNXe does not support PNR mode. Only ALUA, just like Unity.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c        | 2 +-
 multipath/multipath.conf.5.in | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6371a626..9c07183a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -336,7 +336,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	{
-		/* DGC CLARiiON CX/AX / VNX and Unity */
+		/* DGC CLARiiON CX/AX / VNX, VNXe, and Unity */
 		.vendor        = "^DGC",
 		.product       = "^(RAID|DISK|VRAID)",
 		.bl_product    = "LUNZ",
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index a577dfc8..cbf9a878 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -531,7 +531,7 @@ Issue a \fITEST UNIT READY\fR command to a SCSI device.
 .I emc_clariion
 (Hardware-dependent)
 Query the DGC/EMC specific EVPD page 0xC0 to determine the path state
-for CLARiiON CX/AX and EMC VNX and Unity arrays families.
+for CLARiiON CX/AX and EMC VNX, VNXe, and Unity arrays families.
 .TP
 .I hp_sw
 (Hardware-dependent)
-- 
2.56.1


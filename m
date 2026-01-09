Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC6827B32B
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983975; cv=none; b=E47hO7UI952/8LcAEW4UJZSv6DX5PufpA6KMNUU2wErDnsrqkbbGSpARoenfyCOg7Qx1i2v6dwgc22P5GDCmiRarddF/74sAzqz1ho6CKnf63+f66PQsQ68mKzcFAdmcht3cTNMjuSXA8IvSf3zatx4T9jl24931NN1iidRcDrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983975; c=relaxed/simple;
	bh=DN1gv5VZ9MovCdQVw1BCs/vwGbvnLNEptMNSphd4WGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQkqEBMTDAXtG0G5aGbeOOztrJZL/VCOTG9tnQiekBoq9M4LoA6yO9Rg6ndkQZaHDUSVtorUGNQ79hHmk3/Scyddn8UY9bQwB0GFi4hzrZzUmTfOiNXAq6QMakRWz7MLtDOeSkuLvOu9/8PYow8qM2qCrTsqWqA1jRL8whhdfAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ebv6Q4yf; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ebv6Q4yf"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-432d2c7dd52so1525496f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767983972; x=1768588772; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/w5WtYfoLgD9b5pDsuspZFbKCpqy3tKeCLkZh9N4mZY=;
        b=Ebv6Q4yfDRDjUGRp2HsoT8AqFgQdammJliuYT8e4XU6VU5iIngnbPK/rix66sBiENc
         xiJkW3QqVgIZ5KfEJoWxUuD3NU1ziSWwO7qPGotPCOFg+5IzMNSp2zP/0pbL5AZUqLrp
         RxJL1NdoPeC69QVeoDzqtEvIVc1yKbvrOpqUi920V66kjHsd7rTMjSmOBBv0mIPu9j9n
         cEZlxU3y6xJo883Sq8DtGt5MFcF9zC4sbhH1vcQ3KWCKfYiieypCKYzwIhgqNqhZNh77
         C58CjGdMPHHmr9r/01DiicDQ30ggFkG5GOgWdpTW3K4nIDFKlAPHK9vuhtfSpDKUyexJ
         bTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983972; x=1768588772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/w5WtYfoLgD9b5pDsuspZFbKCpqy3tKeCLkZh9N4mZY=;
        b=G5E7x62yenxFES3IJGEBy/WveSsJVD/iCjE5UNRF4mS0aPTdzpsVj2n5mwtY6Cu0Xk
         7HmPFGHg4heJduoP7eixgX32YOEgUbyNmJ3T2in0Lr1xF86f+CDwXIS+dEN/qFKb4rbI
         ZEglOAIpUTI/6xVlrXcREXxWsYv8TR8Nc0Qfn5dBGr7c0KTBWnctV7O4EPCJUINEs0N4
         ps3mErpvZA/NkRLoqMi1yKJEtELtTYn10bWKkEUgslpdoNVyj1ND5VqB1we843OeuoRA
         /AKALQ069AqLkPBm7Hcp8eZZeNSV0pecr+usKkRRCQtbQVi5IrFgWzuCzfWyxtnwmORI
         hBsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLfLbmz6F+cYnipfRGibSJ9gu7hG/iGvzwynSI2DltAEI49cdYJZ5SI8VXsOsRuTqwcbzRZ3ag1Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3XvuEug/IIe/MEllPaltufu4YIYqUa1/3M8PDojnyadeiNOG6
	wVce8fPxNJjRa+DIpPvV5MTGjFO/QnmKCT2nGG8nQFNVL8MNgnliNwtp7b/3rPJk1Ce+ypad2VN
	cwMjn
X-Gm-Gg: AY/fxX47u+oMWtEKI55N+jlZ6iwprTXbrqoQ2PNQyvAfEIa1VhFnvzPwpk9kok5Z47v
	KV/HEXg/ceYGvLEKnTUGuO4yvSSLZO1u0r44lwqQ68rPHzwQK69eEk5XZQ6aFf81sA4mrV8mH4F
	KExEDRncecb6/LLBZpuNZLYh+2cJjXefyicHNCCJM2Madyxhv1Nhe9Vrhzl2/1mMruaE5n5qPq9
	E3JOcS0qw8P8+y5dsfTLBQXbjy2h3tTPKpHdgK3GJMWuiH500ACN2EXY+Vjk/8yOyjPlm0957Ae
	X4+yT03eEWIRzSCdUVJn5N+qy77aIInklcibFf3d1P9gay/wa10I4sxjvn2MX6joG/fmA2l6sk7
	NGSKZAtlhwrRxpZhWXQBTTbkzBydGaC92u9TR8jgDM+let8ABbkOKHZjl/tIjvayLalca+3cfzz
	jgpI4u13LKmtL8oVRip1wfYimRCzVA5eA7cds4HewZ4/u3xIS1qqvfxlN9ps1V7T7MknOR9stSD
	g==
X-Google-Smtp-Source: AGHT+IF+bV+SKV/LM8nwwtsaPczsrJ8Xdt2hdpyqrOo2RZFf/yKfzR1oxgELuT2HwYCihk2liyfwKQ==
X-Received: by 2002:a05:6000:2908:b0:431:a38:c2f7 with SMTP id ffacd0b85a97d-432c37a7d86mr11961154f8f.59.1767983972106;
        Fri, 09 Jan 2026 10:39:32 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd5edb7esm23434572f8f.30.2026.01.09.10.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:39:31 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 4/9] libmultipath: log error when freeing path that refers to a map
Date: Fri,  9 Jan 2026 19:39:02 +0100
Message-ID: <20260109183907.201250-5-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109183907.201250-1-mwilck@suse.com>
References: <20260109183907.201250-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We want to make sure that we never free a path that still references
a map. This error message will hopefully never be printed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 29c0008..f441312 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -170,6 +170,9 @@ free_path (struct path * pp)
 	if (!pp)
 		return;
 
+	if (pp->mpp)
+		condlog(0, "%s: INTERNAL ERROR: path %s references a map",
+			__func__, pp->dev_t);
 	uninitialize_path(pp);
 
 	if (pp->udev) {
-- 
2.52.0


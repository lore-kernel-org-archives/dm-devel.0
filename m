Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C629176256
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804549; cv=none; b=SE3vHPCJifsQANIUMO82qH52/GTsdvkHKrHRTRLgR//O9UTvF+HM8q09gn9rlidEba3TuNutVZSUctNJRCKtQF++XTjc7eWIT7NnVCa+CMBOxtcmCrIq4mBq+rKbdW/dOeBLq9PvsbUQM1M+W+e/iMIaKA9mE0QyomvuaO2bO9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804549; c=relaxed/simple;
	bh=KmzolhYSqPZa4mjb8XegQnSn9CbgsYBLPLQXdZbhyC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qw/BRYsGQ2xiBYdhj3RMXOVhO8qJpPNd1EQ8etCUsagUV1QefB5z+KSO31CFaJ+jEAPKBlaBxSYL2YPZv4/xlCaNA0Gd9dtvJpzH0DjSIfeVLezawDUE4Jvmf7K24+6o446cjgJvw7DwQ0o3SibTFMlHk5o2S56ijq5j9fY4yHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CYFnZK0X; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CYFnZK0X"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a79a7d1a0dbso87981866b.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804544; x=1721409344; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9UDYTV9Sr+10JeObUXODObNAZnhUpdDLyTLHRJjE+w=;
        b=CYFnZK0XKIlogzKtf4yKKB4LbzOUcbVa3nVFLtC4Ym5DQ+ryCMj4TUFt5yvdcN7l75
         t+cvMSVAKototJN4y9GnyTx5nZQBbCgNPvAINQJURcDNTT3GRIHDbCIwURVgVlcBypqZ
         nkldN0PaqDfCOfb1RgR1BeOgX1da2IcqjFfmJoQk3HoXc9/29FTylHWFqCXhQXmd+98D
         2RlDJOizbJpOzWMkKsiikFHSpgdxobibNPQHdNpxjcNXgIwaZMqPjTEy/dZk6fR+7TL+
         LSN8KMnaBMiimWYi5nXlY4LGC3weKH+cTyPqwNZjVGwok8P3X7+u6YucNVep/GuJOcSR
         UdOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804544; x=1721409344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S9UDYTV9Sr+10JeObUXODObNAZnhUpdDLyTLHRJjE+w=;
        b=XR7va9JhT+X051hlhzT+RE8pSytBfHPZghX62MWkOu5aXBhqb/RpuDmFdB5sNJbS6i
         X7tpvoIgltVxeTVNSlrCYn2iDieBGvxXzPaJaYst+3Q0uY+/m1MjEzzybBIa/uqzOUgJ
         4YTIakIcpADnPg/KMo1Xl2xlzW88PFTjEZQefLbeucGdfBnoXlYGHcLbZInnRCr0Esz8
         9ZOhczqB2bi7+/X4/9L63IJxJJMt9wjzvdqK7c6TRMaKsSa8RNXxmIKbYoKHJrXzRSqt
         5rlS8ruitxWQ4y0U2CLgOqI+z9ZvlW3pw0DlYYqdkLIWi0hm2iSv8FJ+W8dIE43HoAcH
         yDnQ==
X-Gm-Message-State: AOJu0YywfZ/ofF0D+6vcm2XQ8FH1dMc+RlcjJP8gcKPNRssW+a6LlmSc
	A5lHNZWy9+TYTzVDtcLq7jWk9N9sIf7RQvo8Byq5ugx7tuSXC0rRjE+eKIVaPFU=
X-Google-Smtp-Source: AGHT+IH8DDj6XDRIdNcOKVIwmM2GTtBy9TRsQelKkz+1a95XilpzLZwCwFrODcZlWHB23nPiVG4B9g==
X-Received: by 2002:a17:906:68d7:b0:a77:e0ed:8b9 with SMTP id a640c23a62f3a-a780b6889dfmr766930866b.6.1720804544396;
        Fri, 12 Jul 2024 10:15:44 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bcc97sm361763566b.35.2024.07.12.10.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:44 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 14/49] libmpathutil: add cleanup_vector()
Date: Fri, 12 Jul 2024 19:14:22 +0200
Message-ID: <20240712171458.77611-15-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/libmpathutil.version | 1 +
 libmpathutil/vector.c             | 6 ++++++
 libmpathutil/vector.h             | 1 +
 3 files changed, 8 insertions(+)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index 86450f4..cb05231 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -136,4 +136,5 @@ LIBMPATHUTIL_2.1 {
 
 LIBMPATHUTIL_2.2 {
 	cleanup_udev_device;
+	cleanup_vector;
 };
diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index df59db5..7c3ce43 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -169,6 +169,12 @@ vector_free(vector v)
 	free(v);
 }
 
+void cleanup_vector(vector *pv)
+{
+	if (*pv)
+		vector_free(*pv);
+}
+
 void
 free_strvec(vector strvec)
 {
diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
index c0b09cb..a41f157 100644
--- a/libmpathutil/vector.h
+++ b/libmpathutil/vector.h
@@ -78,6 +78,7 @@ extern vector vector_alloc(void);
 extern bool vector_alloc_slot(vector v);
 vector vector_reset(vector v);
 extern void vector_free(vector v);
+void cleanup_vector(vector *pv);
 #define vector_free_const(x) vector_free((vector)(long)(x))
 extern void free_strvec(vector strvec);
 extern void vector_set_slot(vector v, void *value);
-- 
2.45.2


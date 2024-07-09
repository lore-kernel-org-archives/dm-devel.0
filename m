Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339FA185602
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561201; cv=none; b=VmQCaqyLeUR7rvcWT3mks7THgWia+GTSXaF4kKbMwd3IUFWuYmcbsILbsdBrhA3Jmcfl4/r+IE6LneNR9/bvGL33+37qDO4dnhjlcnSoXDhlJSDIcxMlXrRW9xL5H4FzCYWPY7+ystlw8L/HKG6COTy0Zoo1Uv5R9lA1t31MQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561201; c=relaxed/simple;
	bh=VGlYTCKrCqco/vCM5HtDVjkHJwmoigh/CImyzs21U9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=st1SAmrX8KKb1pIZwBxPvq8HwGwcrgO3pZipas2KiQSLmt9vJwwsfPrZ8QKVIK7qp3xZNfLPDzB8uv9XfdhiMNVvR/MjX7zTWbjXtAF9IXfiI9AkV8t7VeWZEPC8XH5h74L1/yxGU09401Aj1OLtDoHMC1PJO7SBPrXDkNtlwnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IJge4Edf; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IJge4Edf"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a77d85f7fa3so27642266b.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561197; x=1721165997; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkuSh099XPosLb+KkONbyidSZ7ibozcji4aNB9K1PtI=;
        b=IJge4Edfe4FTRmNLuZFhLMmhEFdOE3Zn5xQkMJywxqsX6nTvR6XP1oc+Pgd8AYuAEJ
         q6hEWFtiNIWVh+WTjF9EEwPV1X9KL8Ud8C8JtAEyOpuR5meOo8T+23ERGlbnSK34DE2M
         Agl/92w1nxzSvZi9ty4O5T+7RT48DGirYq4hfb5cN4h5M2jp2YrjapexgPKUYqqQbwSv
         a3ano0NlPzjc4SAUFiPSPcWMaBc1NOWLwzBGKo8rhtw+FGXYYrIMLIMIq2D98yOpb+0P
         x0p0lp4tT/HAlJS1A4mTFaT2wSKw8JEFZW+rCgGlLrEzfStQu1BnA3CCsjF1FTCZ2wEy
         N3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561197; x=1721165997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pkuSh099XPosLb+KkONbyidSZ7ibozcji4aNB9K1PtI=;
        b=Cf0qNOXLm/Zn/Jh2npFmHTMcbOp+JqN/ELgWh2FfFyavI915UEF3Wh+LlEcZtzQVBK
         LMuGRIVFeOxRIksluzmyruVFJ6PAWYkiobyEjhxRd1BsxedLiWnYwZ+3IS+rpEeNZe5q
         wxNOqAZijOEeGlB0cHtX/6MGXE974J/VCVMHBzy5GTQisxWzbPQHLZYVOUH9KKNdzIsh
         /eFikBWWbeyjYsSuEfcb5Jkyd+OgFFOzWSygftU3pRU2RMx7AdKyzYgtTBG5NG73Yl4c
         zoWUrHBkI2alZTCIZLNk/H9HXfBec/pzTMN+a/GxcdaSFmSsIaitWzm2OYl53DXYvXCr
         m9FA==
X-Gm-Message-State: AOJu0YwazEGJJjT4uTf96jWwINml5AK750mnBMaSUxP3SC7TZqSy0Xmu
	a5hLib0Q67B1WCKmNFH4m01Stsc02Iy+CeDuWYawbjUYpQgW0ad6XQAxaw1Y938=
X-Google-Smtp-Source: AGHT+IGYd/uUsfxWmjQWTTC88BCKbMc+aokoz/hfjdiMz13bEkfYmaoM+bbIZfj2kcTcytKJcS2d5g==
X-Received: by 2002:a17:907:76cf:b0:a72:5967:b34 with SMTP id a640c23a62f3a-a780d267c19mr257472366b.22.1720561197450;
        Tue, 09 Jul 2024 14:39:57 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bc57csm107556766b.1.2024.07.09.14.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:57 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 13/44] libmpathutil: export cleanup_udev_device()
Date: Tue,  9 Jul 2024 23:39:04 +0200
Message-ID: <20240709213935.177028-14-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function is useful in multiple callers.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/libmpathutil.version | 4 ++++
 libmpathutil/util.c               | 6 ++++++
 libmpathutil/util.h               | 3 +++
 libmultipath/print.c              | 6 ------
 tests/Makefile                    | 2 +-
 5 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index fee74a3..86450f4 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -133,3 +133,7 @@ LIBMPATHUTIL_2.0 {
 LIBMPATHUTIL_2.1 {
 	libmp_basename;
 };
+
+LIBMPATHUTIL_2.2 {
+	cleanup_udev_device;
+};
diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 23d303f..67db3c8 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -373,3 +373,9 @@ void cleanup_ucharp(unsigned char **p)
 {
 	free(*p);
 }
+
+void cleanup_udev_device(struct udev_device **udd)
+{
+	if (*udd)
+		udev_device_unref(*udd);
+}
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index 4997fed..c19f749 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -10,6 +10,7 @@
 #include <inttypes.h>
 #include <stdbool.h>
 #include <stdio.h>
+#include <libudev.h>
 
 size_t strchop(char *);
 
@@ -139,4 +140,6 @@ static inline void clear_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
 
 void cleanup_charp(char **p);
 void cleanup_ucharp(unsigned char **p);
+void cleanup_udev_device(struct udev_device **udd);
+
 #endif /* _UTIL_H */
diff --git a/libmultipath/print.c b/libmultipath/print.c
index d592001..b7af913 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -436,12 +436,6 @@ snprint_multipath_vpd_data(struct strbuf *buff,
 	return append_strbuf_str(buff, "[undef]");
 }
 
-static void cleanup_udev_device(struct udev_device **udd)
-{
-	if (*udd)
-		udev_device_unref(*udd);
-}
-
 static int
 snprint_multipath_max_sectors_kb(struct strbuf *buff, const struct multipath *mpp)
 {
diff --git a/tests/Makefile b/tests/Makefile
index 4005204..8afa8c6 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -53,7 +53,7 @@ vpd-test_OBJDEPS :=  $(multipathdir)/discovery.o
 vpd-test_LIBDEPS := -ludev -lpthread -ldl
 alias-test_TESTDEPS := test-log.o
 alias-test_OBJDEPS := $(mpathutildir)/util.o
-alias-test_LIBDEPS := -lpthread -ldl
+alias-test_LIBDEPS := -ludev -lpthread -ldl
 valid-test_OBJDEPS := $(multipathdir)/valid.o $(multipathdir)/discovery.o
 valid-test_LIBDEPS := -lmount -ludev -lpthread -ldl
 devt-test_LIBDEPS := -ludev
-- 
2.45.2


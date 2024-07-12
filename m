Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D02176240
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804547; cv=none; b=pK5s4u2Em7MpSWMTPwJM/dMdIOASwa/9FN5tVTut+/L98QXqrFgmEo3BXDkoaI8Rhc21MwdBDTlkebNP4NxVyUtctaTAXG/X3ETyCfSr1MHbgKlAUBJUgfTeoCTkbm4pp/x/56Q9imWSd01WWeji1nklCKzQYR+tPCIbQSbgIqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804547; c=relaxed/simple;
	bh=FbifY8meWERMdy+RSPRDICc394kBtMfJTYhYIEkVzqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIMyYULAl6dDrbLlGeHOJJ2rJ0Xnto6htrLKCFugIcsgZFccKEiZznCkvceVCgKmcXeXoM2J3LSzbjccbJL59w7UUvt5oXgF02LkQivHAW8AZq5RVZaUnv4nNmIdArg9hYUfPEivk9snn748hnkRju3FtZlZ59o+HzA6wA6QHQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ew2tzFs2; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ew2tzFs2"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-585e774fd3dso3054509a12.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804543; x=1721409343; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2fZ/Ks44oEMJt4fpgSvTODnYSB0uj/8LMWxAsP0vGNQ=;
        b=Ew2tzFs2CqWOvYBdeIuGkjAH5SN0jP/GQMpj1IJL9+gkv97SHUzF1otXR2lcyTo54S
         J8+C4P1OCLl7gZ1fNCE6GfRctvGXzLIZ0SUvxJ8S0avlNddEuxCKrp31AqXtv6y7drOJ
         GnIP/l+Box6TM87z4gdrwE1CSZ8oxEIW5cPxGDM1nw1fxQgWNji5R/j6n+0obPSBrAez
         5GxjqiPGiIFwMPvcRZNnUDdE8paCGdSVoVyejPPc0eGLPyXaKqrrkNe49SWAuqLWVdSj
         xDAbzGQ7sQAJWzujeRJay2MUH+3lWCo/Wi8nUirhqQUgCJ8z8391MYYgg2LvV60SxTUw
         TNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804543; x=1721409343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2fZ/Ks44oEMJt4fpgSvTODnYSB0uj/8LMWxAsP0vGNQ=;
        b=tXVjnE4AYUhZXtEKkqZ7Yd6kHF9athB1+dkiY+DNn9O0/MdY82iY7kTgQTc2C8YBSS
         qTgjLEiegI3qsJt+t5mz9eOz158RmlCcjBSThOfasT8CkEjCrrJGONNrvFgATr5IBEOp
         GUjqD/IrtfbYX4m9aL0YDlKbkGcabuzh7A4MorW/Tgc39AlYwsQTlIU6MaqFCnBpcoao
         gLnH7hY8u869iw6+8dn9C3rinAcII8UeJPYtkTJtaadFa5sXBEV1xHiw8mwgZzT0PKv4
         9khqt4QpgLkY4YBYwli2hITFi+/JiGYwkRt4RbXtlzdPGWf4yqqt4i8yh89knsu6nHVR
         MoYQ==
X-Gm-Message-State: AOJu0YwWttTfvbA2oJvXXBA2swhCh/WlBtqNZAvjihQ67BKzuswNmwvx
	FiWmGlIK5T1znF87HSAqaBqrBYbcTvXxCi6V6ZCgnhp7+ePzUla43yd5HvSbQ34=
X-Google-Smtp-Source: AGHT+IHQ31NO3gt/tDBUvsqHaJO2aFF66mnJSYezbTo6yIVTJnNSPQIG0joZj1nXvuPIHgK7ltY38w==
X-Received: by 2002:a17:906:6c93:b0:a6f:4d6b:c779 with SMTP id a640c23a62f3a-a780b881c6fmr713735766b.52.1720804543145;
        Fri, 12 Jul 2024 10:15:43 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bc57csm360189566b.1.2024.07.12.10.15.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:43 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 13/49] libmpathutil: export cleanup_udev_device()
Date: Fri, 12 Jul 2024 19:14:21 +0200
Message-ID: <20240712171458.77611-14-mwilck@suse.com>
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

This function is useful in multiple callers.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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


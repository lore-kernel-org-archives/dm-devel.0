Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F692ED853
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006499; cv=none; b=VBs1TNNNkkMOXhFzFih746gZBBbFnOHDGuEs0ShiA84I1xBVGIEUIFTGspl+u5/W/Iae/9UuJzgHOhjjY5Qxz83CCYssPAd+wLhczV3V8XcPlKVq1ro4GYpqja2Yr37l8DRM3IAp0p9JPBt18YWaXAptTMVk1onZ12pIzIizEMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006499; c=relaxed/simple;
	bh=qHp9dl7ChSpzXMx2YbKFB4lkHo0OA9/VphQIs+6ChME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paJdBlaMJH4t02jiKF6Ve11Cf5xo91MvTR5oPVFf2w+IfCNWL7vUT2cVCEaOtQ0HmFAQQUbepGAYNa8qPUDRKCmX1BKbW3o3NObus/S80/sr54uBofJ6G7FPGdyM1cAwhvROJ3jab1opYkhxexCSgQTB5Vy/cS0ApmCDwmuzJug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AbsUtMZs; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AbsUtMZs"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b734fcbf1e3so1246040566b.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006495; x=1766611295; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BxjA2Jy6uWuDrNOhw3BEpXtc1EhC5M+3v+CghW9oIB4=;
        b=AbsUtMZsJcNzyklwKTkE0fJ4P+9n40ewyUyiaiiIrIU6FOPkTqoU/riCFaJ60AlkQ5
         JfOOdXymN5sXLlw/G5vvxuSZFXe/nN4sG+i/ANeulTXgbr50KEhAzXon9xn6VhOFfvuq
         hcuWW0V/mLZV35Ta/9jh8cPc7tC7I4Bwh4mQwb5JZKuaCcZnglO2beu/swGf2aLsPjyn
         LkyYpaEATx2cGvMnlzJmrvNRMeOXs1GvsgrR5oIXFdiwviMqcDveGict9O4mhnHF/C89
         uNdHVe9WnuLgQE5rouNN91uqdAx9429fMgmMJj3lzNn+i6G0rUGpwu1it98W2De84Y0z
         ibuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006495; x=1766611295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BxjA2Jy6uWuDrNOhw3BEpXtc1EhC5M+3v+CghW9oIB4=;
        b=BLXXSVeLsRYi5QtEjNOAX85kgndoU7LlWN6JLXQalffV7WUUaeCV91qYiXUvRiFjQk
         jjhP277uaTCgMzCusyxwonOb1ZiiCSzM2Fa3fYoMjkVHlqoYIQa66/M9wbW0LqguX77r
         SqJ2C662gCujOoRqI6rkI+t8BQQArzifCFjxRdCQPE/lN5rbaXM6JB8FmxnuisTVYYX1
         1LlfcbRfIQhxz6OeQuKmxlOxB13DrmRiWA23Z2qO4NA5ktV4xi2qYGqHmteRxmJEYkIA
         MTYrgMuOCKRK5pbxCtezVlmW798YH8ZK9CbrerWU7awDMahK4NW2/fySdN/ZZTaI9NNF
         pgWw==
X-Gm-Message-State: AOJu0YyZpH4YUVbgZqG3KfNidf1PDAKB3zD1gq3Vb28hjc719Jl5DG+s
	7LQU7qs2Cd8dLKxRfVgcGMDn2fN798/mmyViE4iVMKV2nBN/VwXwW9PIGVZh9v9pDLY=
X-Gm-Gg: AY/fxX5yM9mJkVHgx0njEvVuWTJD2Q7fYAJNLuf7hqxanVXhQVpeVDa2IGUCEe2Bxbq
	RXe5CDXLJIX/zEdSgpASYFR7mUdGoLZeSzXxyWi1xQ8F+/gygu01fLa+yMp+U/I6XgBVZlY7Q9d
	UnnF7QTUxBRGKJ6sSIiiQkOP3Y26RSncl6du5i7oI0HF0IhlmLFCS5fZal4oAOsRnA4E9+El0oI
	2dg8EE2t8oKXV0TjIskVXskvNRUMnY37Dqq4zWGmhJPFPBvFtef525aG4IofZXLitkQELjcG2Ni
	jiWt6YBWzl8BPPuXBJBo1vMm4dV0tuGGLiLybFowSA6+M2uk1QNlBw8TQsHwDsBJukDY2CpREyK
	51mRw0mkxu9zuPoURabI1AAVt0IcgCLrDGG1TiXCC3KQi/cGpI8y6mQpR/ulyhIh2YBevvy7CUC
	GQ7wGEtp+/kLgsGB1EdACoLRRvFd8zY9PcyMwTp2fx8iiI20QnZ3zGoiX00tTDvkFssFE8AzAaF
	w==
X-Google-Smtp-Source: AGHT+IFT7BHTnOQ5JvYxd+vn8usvLl3WX10WF5wWgghsvu7jaMasb9WfYkCUoSBo2+WmIQgR9RU9mA==
X-Received: by 2002:a17:907:7b8a:b0:b73:5c12:3f8a with SMTP id a640c23a62f3a-b7d23698224mr2080519466b.18.1766006495468;
        Wed, 17 Dec 2025 13:21:35 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8023466e33sm27082866b.32.2025.12.17.13.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:35 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 13/21] multipath-tools: Fix ISO C23 errors with strchr()
Date: Wed, 17 Dec 2025 22:21:05 +0100
Message-ID: <20251217212113.234959-14-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ISO C23, memchr, strchr, strpbrk, strrchr and strstr become
const-preserving macros [1], meaning that the return value
inherits the const qualifier from the function argument.

This has turned up a few glitches in our code.

[1] https://gustedt.gitlabpages.inria.fr/c23-library/#memchr

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/parser.c | 2 +-
 libmpathutil/util.c   | 2 +-
 libmultipath/prkey.c  | 2 +-
 libmultipath/prkey.h  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmpathutil/parser.c b/libmpathutil/parser.c
index 131a5ed..bf7c411 100644
--- a/libmpathutil/parser.c
+++ b/libmpathutil/parser.c
@@ -144,7 +144,7 @@ snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword *kw,
 		const void *data)
 {
 	int r = 0;
-	char *f;
+	const char *f;
 	struct config *conf;
 	STRBUF_ON_STACK(sbuf);
 
diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 38e984f..37412c6 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -38,7 +38,7 @@ strchop(char *str)
  */
 const char *libmp_basename(const char *filename)
 {
-	char *p = strrchr(filename, '/');
+	const char *p = strrchr(filename, '/');
 	return p ? p + 1 : filename;
 }
 
diff --git a/libmultipath/prkey.c b/libmultipath/prkey.c
index 4fbde5a..ebed0d0 100644
--- a/libmultipath/prkey.c
+++ b/libmultipath/prkey.c
@@ -50,7 +50,7 @@ static int parse_prkey(const char *ptr, uint64_t *prkey)
 	return 0;
 }
 
-int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags)
+int parse_prkey_flags(char *ptr, uint64_t *prkey, uint8_t *flags)
 {
 	char *flagstr;
 
diff --git a/libmultipath/prkey.h b/libmultipath/prkey.h
index a89a617..806795e 100644
--- a/libmultipath/prkey.h
+++ b/libmultipath/prkey.h
@@ -15,7 +15,7 @@
 
 int print_reservation_key(struct strbuf *buff,
 			  struct be64 key, uint8_t flags, int source);
-int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags);
+int parse_prkey_flags(char *ptr, uint64_t *prkey, uint8_t *flags);
 int set_prkey(struct config *conf, struct multipath *mpp,
 	      uint64_t prkey, uint8_t sa_flags);
 int get_prkey(struct multipath *mpp, uint64_t *prkey, uint8_t *sa_flags);
-- 
2.52.0


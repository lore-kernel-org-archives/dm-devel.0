Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C791741FE
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804534; cv=none; b=QIl/y5jo2mK+hCvh88QqqDww4Ws09AnMTQtyzphPlDaBnjviECWeM0trUdf0puC4fItyq0WSrqotMOTapP5OQtjUmsY/ASohxzv1l/bLzrBqqz87ZgT4SZmn5P9BUR7O1w4AILa+Nq5a7H7Ho2e/xTtG7Qr1JHgUGc4zRq1zi9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804534; c=relaxed/simple;
	bh=lrE5nAEnTXOTGAJDgbqB1wnOa8mj/YBYNdfzgHgFexg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ir91s829UoSLMWp1S9m2on8o2Nj2XmBxcvww4/0saqrDXs+NfNccs+1QIwiIvvdSQ9xgTlYghH9H71OkamLBI/Fofu8EtaeCXjI5hX2sYhPSNyE0gdpExih6SF6j858JuJg7PwY8uGublc+H67foi97V9SKOI14Hm/7RqskWPCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Da33KnE8; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Da33KnE8"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a77e2f51496so313310566b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804530; x=1721409330; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ivbZdM3R+FX1L2KmRZ3BQcmEiZdEEqW/Q42IbE6QDg=;
        b=Da33KnE8JrrDm5/SBQBoNTpOlYgwaL78ce0sFSbO97BeBx6h9Omf2rOURKzU0x5Kxl
         RRzahLoMtUhn0gddLlLG2wnZmjxbGCxJ3R9hiZtcpmQTjbqPseOMuKcxbhcosl0+veb7
         6RbG/FkD/WMZ6cmfC8ob8b/OfC6Nx9PoZ+lBm1K/Lthh7ayNoesrPloQAF+kXJu999Ma
         iZjEbPOha6S7h2Sv6b3ykIc4waOc+DZ4OCNDON5Q+AuWYDq9YAYYUwudpxxK8Xmx0lCe
         fGMfEHM1jtHs4Tdr1miQHxDFiNUnFgpD99BlQlCcNxPOiyEx5MoOXPS6ySntWWSwi4Jk
         lBqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804530; x=1721409330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ivbZdM3R+FX1L2KmRZ3BQcmEiZdEEqW/Q42IbE6QDg=;
        b=EOQyDyP6gb4ZJuner2eojXQyTKhl4IbGhmLpxOT0AkAbFsLt3hMuyHdchUh1r4Ubgx
         mYPIfexT3ZR46M67nyaed52bBtOEb7X6fmDj5CU8eMXmQ/ApzMDLBOgt8pLMxYFlKjII
         nQ+j5t6neydjxooS2NdVg5HbIP8sUeh7ig0hsfxJyQJ3U4CqbCyFUBP3eTOO/gXPPWAJ
         44WWCUPkylRd2x+YmtpUW9u7pSIqCI0bl4nY3FfeS+Gmbiob9e5OQfbSixXZoQ3CvOxd
         CMxAB3gviqTA2StHVkFnsbJpp6pNgxIKor5mKzyFkZggTzk6ShdGVJaK5IdPCp1+TUNZ
         cAyg==
X-Gm-Message-State: AOJu0Yyd4cehY+IO69Lw+0MKdoBcHvUOP8C4a3mRiiYQ6dW7xtFr9ZEo
	zkrs9Mv67xUNgeiB6cSvGEI8zdZlhl5IQWu61wJ4GrNgzhgRc/tnAM6vZSDbxoQ=
X-Google-Smtp-Source: AGHT+IE+FNmUw+lsZhW2TJaPxdjn07+eTP8YhF5BYtmibQUydG7qU3UX30krgvSsX3iL3NmEEC8phg==
X-Received: by 2002:a17:906:f58e:b0:a6f:501d:c224 with SMTP id a640c23a62f3a-a780b883529mr1124233066b.57.1720804529437;
        Fri, 12 Jul 2024 10:15:29 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bc897sm364000666b.39.2024.07.12.10.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:29 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 01/49] multipath-tools CI: more fixes for arm/v7
Date: Fri, 12 Jul 2024 19:14:09 +0200
Message-ID: <20240712171458.77611-2-mwilck@suse.com>
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

The previous fix for the CI under arm/v7 was incomplete, and actually broke
the tests under openSUSE Tumbleweed. Closer examination showed that the issues
were caused by Debian's move to 64bit time_t on some 32 bit architectures [1][2].
This effort causes _TIME_BITS=64 to be set by gcc internally, and introduces
symbol redirections for libaio [3], on Debian with gcc 13 and newer only.

Fix the conditions for symbol remappings in wrap64.h.

[1] https://wiki.debian.org/ReleaseGoals/64bit-time
[2] https://salsa.debian.org/toolchain-team/gcc/-/commit/d82fb8a8ab7b84f61fb8290a2c3aa2e3f54e7b8a
[3] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1062218

Fixes: 6a7524a ("multipath-tools tests: fix CI failures on arm/v7 with glibc 2.37")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/wrap64.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tests/wrap64.h b/tests/wrap64.h
index 7e43420..af6cc2b 100644
--- a/tests/wrap64.h
+++ b/tests/wrap64.h
@@ -2,6 +2,8 @@
 #define _WRAP64_H 1
 #include <syscall.h>
 #include <linux/types.h>
+/* The following include is required for LIBAIO_REDIRECT */
+#include <libaio.h>
 #include "util.h"
 
 /*
@@ -47,7 +49,8 @@
  * fcntl() needs special treatment; fcntl64() has been introduced in 2.28.
  * https://savannah.gnu.org/forum/forum.php?forum_id=9205
  */
-#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 37) && defined(__arm__) && __ARM_ARCH == 7
+#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 34) && __BITS_PER_LONG == 32 \
+	 && defined(_TIME_BITS) && _TIME_BITS == 64
 #define WRAP_FCNTL_NAME __fcntl_time64
 #elif defined(__GLIBC__) && __GLIBC_PREREQ(2, 28)
 #define WRAP_FCNTL_NAME WRAP_NAME(fcntl)
@@ -60,7 +63,8 @@
 /*
  * glibc 2.37 uses __ioctl_time64 for ioctl
  */
-#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 37) && defined(__arm__) && __ARM_ARCH == 7
+#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 34) && __BITS_PER_LONG == 32 \
+	 && defined(_TIME_BITS) && _TIME_BITS == 64
 #define WRAP_IOCTL_NAME __ioctl_time64
 #else
 #define WRAP_IOCTL_NAME ioctl
@@ -68,7 +72,8 @@
 #define WRAP_IOCTL CONCAT2(__wrap_, WRAP_IOCTL_NAME)
 #define REAL_IOCTL CONCAT2(__real_, WRAP_IOCTL_NAME)
 
-#if defined(__NR_io_pgetevents) && __BITS_PER_LONG == 32 && defined(_TIME_BITS) && _TIME_BITS == 64
+#if defined(__GLIBC__) && defined(LIBAIO_REDIRECT) && __BITS_PER_LONG == 32 \
+	&& defined(_TIME_BITS) && _TIME_BITS == 64
 #define WRAP_IO_GETEVENTS_NAME io_getevents_time64
 #else
 #define WRAP_IO_GETEVENTS_NAME io_getevents
-- 
2.45.2


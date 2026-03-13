Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5103938553D
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 23:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773443698; cv=none; b=c4XMwhZGW7YeBmQ66kUnJ5IsIoR82Ufp5Ihqrqe/GUWog77O2y6JvICcjnH2bWpCL+g+febh/M9HpbLr/A4WPgZR9gLGN33RoOPSQvH6wgnl97bDtdbQbQy4jlrBy3yvLCTUMgdvXW0dahX5ZpM/f0B9P205hfprokr0O4CQnUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773443698; c=relaxed/simple;
	bh=E7Rnjcu3xc7jCUUrPfIo1zrwhYjgCiPTJbyvK9BDFV4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WxvspLIEeAV0/Tg/JtYG2+lkVWFdYLRlBku2uU1xRBxjsyFY/uzqwrTpY01g2Tbrz/igjvI5QgUEjAoq6PLS3z2i+j6ZiAWBgI3vV/1w5+wAE6a7xnAPV4kAfPuvR7ok0dsUqVe4NqVTx698jGhrGLF3C6FtKUnCgMizD3PvuJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C3/PdLmm; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C3/PdLmm"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-439b7d4a843so238595f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 16:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773443691; x=1774048491; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OhpyJzyyBtdF8j1cOzmDiH0pJj8UkzVrenuDeF4Vba4=;
        b=C3/PdLmmEzxeX/q1q41Lt4lCGH0Cpy5gnpSDpVpqQs02CzDEaYwx1YT+wMO6IJX+72
         2aHRmXnDfD7nXhApIMtX/YtyNS8Qe/p/aKiIjQjnsymcaHiQY8snFhVZD7NPc7V30Zu+
         V/qr1WqLD/evuE1ohhr/Fhej743NMDdyCTjy0L5BPSH0ZrOBJ5iaf5tPS7mKsBs9c7Ov
         8Xvj7/sBbtM0AO7FYPMxj+Iar28S0DxMtX2lI1UTDrTp+i/86UvjBkJHF+dm5RzBnCu9
         Wbipl5LQGLhuIOPHjrz8+xk2kJ0Uun0lBZZxP5dfu32E2qhfEM+dto1ADSQOiD3U+3wh
         xNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773443691; x=1774048491;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhpyJzyyBtdF8j1cOzmDiH0pJj8UkzVrenuDeF4Vba4=;
        b=j7QYC+a6lxPq0SziKrY3N087MbpjNPT+X36KakTgvp/A73NO7ejC8H1DWTxoJwqqFu
         ubHasHUwyyUbXzIvRj8cKNWZFrfHWoIw7TavwekdY/pIsyy1/RaBV1HKcXQh67fW7jRx
         N5QNLUHgiqPbiT14Ftec2+bsO8QwH2xmAY64w6OMwLkOvS3Qt26S9dEMIKyc/VJT8S89
         5qxqasoW1+k18QUmZ8GvUDHKhWMKp0GbEn+7UYigDxVLCI+wZUJKdVdxWtGjx/gMjp/R
         kCR1XawseXxvYdzPcs0SB7jYqZusCH0siUR0zVC3K8MqfpP6IaKdkoWHrbHKHa4giHPj
         9D1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVZiJgkQNFJqLHkTFiu+P1XvHA9OeecjvxO1r4Zj8chT61DQixzFo+k94mm0Y4+tWtzFF3cYYgC/Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxdIk/j4Lt2jJTrY5MlVijk2R5z/lS1KNuY1njPcgcS8RBpHo1/
	gSoXgiHXTECSGZnnwAWc9wiKmjjuRIldRb+wwfkR20If7uE8qY903LI=
X-Gm-Gg: ATEYQzzwHRDU5ds6Gv+iJvO/wAy+MjFOE5ynxiRHf2O+0VvYvz3BfGIRGZR6KxT5q5S
	H25/T7Ap2YfXzesf89hAGaWH5G1SrhkEJPhX/RgDxB0yDTp3jOSb1zZxJQDOx9gvdN7W/fvUx6W
	CmtZSnKOBxG/mvBAj9WUjuxSX0Qr2iIOKtw5osOpDm2wAf/8P3ecIdJF15hm/Ljx5EMUhv4h7CK
	MrwY7Ovr3Cv1S7OYOGRuxUC2uF7FRjsU679yN2b2L0vfsHntLqn7lQWQcStqB7lmiJAG1LcPQ6x
	ZrtNKTi720Jx5kRy2Ujlv0h7DnXMj1lp2wnHvKU77WkyY4RHmPDVFD6pQCRhyzcBGvKOA4prMio
	p/emSwfaA0kefYPe3GPpHiHJmlWO0xmS+u8xndYg308yeVPJbNYEAFAmaPobFQWithvEm+3hq/A
	BRdkA2Yjc21xOOWCVABB72uiREMYNX8rSu1CGMELY3koyMPMdfdFe3FewQfvL2
X-Received: by 2002:a05:6000:4287:b0:437:72ce:8954 with SMTP id ffacd0b85a97d-43a04dbcb4fmr5581255f8f.6.1773443691245;
        Fri, 13 Mar 2026 16:14:51 -0700 (PDT)
Received: from localhost (99.red-80-39-36.staticip.rima-tde.net. [80.39.36.99])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe19ad9asm21827905f8f.7.2026.03.13.16.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 16:14:50 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 1/2] multipath-tools: add SPDX-License-Identifier tag to libmpathutil/util.c
Date: Sat, 14 Mar 2026 00:14:47 +0100
Message-ID: <20260313231449.79972-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

This file combines "LGPL-2.1-or-later" and "GPLv2 or later" code,
so the resulting code is GPL-2.0-or-later via the LGPL conversion clause.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathutil/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 23a9797c..2220f4ab 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 #include <assert.h>
 #include <ctype.h>
 #include <limits.h>
@@ -34,7 +35,6 @@ strchop(char *str)
 
 /*
  * glibc's non-destructive version of basename()
- * License: LGPL-2.1-or-later
  */
 const char *libmp_basename(const char *filename)
 {
@@ -219,7 +219,7 @@ static pthread_once_t _lvc_initialized = PTHREAD_ONCE_INIT;
  *     if (get_linux_version_code() > KERNEL_VERSION(2,2,11)) { <stuff> }
  *
  * Copyright (C) 1999-2004 by Erik Andersen <andersen@codepoet.org>
- * Code copied from busybox (GPLv2 or later)
+ * Code copied from busybox
  */
 static void
 _set_linux_version_code(void)
-- 
2.53.0


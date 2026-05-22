Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319ED47799E
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468306; cv=none; b=M5aZF7Z1RlSam+ZXM5TWaTuc0kxtzP+VGRYPvC5b5qwAcRFV0froxed4qdk4alG04s6gfHRjFbOwpQoin161uE+tGmAp0NdF7Tr2vBF6IiI18WEZcMO5Q9FyO/vC4eKAOSN6TDMHftJyuCljFtdbG0bDd6IhhaW7rc+dvGS0lsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468306; c=relaxed/simple;
	bh=Q55nSKwXWAordZISfsbMDsJTao+i+7ryUeJH5DFKxKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj9WlE97LtE6GM7+YXMvELUMNAYWb2LVW5hbQRh3Q9oG82vyYySgXJnneQtIO3iHTBm6JvT/QWO56UMWe/i9DU3qbtQhKp3AH70CGxy03PH2tM4PK5SDD07hQkxfTVz1X377d3vR0Xj9dm+QVgV8lGGSYP9XXYxXx8kluWYakHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OMfIyjpt; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OMfIyjpt"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-44e1ebb3122so4715670f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468303; x=1780073103; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nqPPX5KaqmLHvojBuYwTmeGceoegGvhb9w9KBnk7Yjo=;
        b=OMfIyjptEWSdBacZRHp238AN5p7C8mn7frUOLp1I7EutCcCz5ehmjvD2qg1I3AY0LE
         DkDPMB1p0ap2l0iXkimnFxeaipV5NwpOhgZkPSZ0YGMNLNqMuTUJ1jMZAMg5IZ9FKBzr
         jxljr0d0lOZIOKF10pGpBeFkXHOcsF3xa08mKqSW7m/8LhRoGKoPLdACXVBW4icgPRIh
         mOEa036hbInuot/9MBaxjb7Uxbwxdw4GiUcUCgG4edqK1tRmDQHtMSUAHsz5riXs0zQP
         /pAHUViFI9TT/Hctf3mP4QkAqIMIYunHy1tB3wWKNXe+TRcZZVRgeNrU6rkON1RcS3s+
         v3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468303; x=1780073103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nqPPX5KaqmLHvojBuYwTmeGceoegGvhb9w9KBnk7Yjo=;
        b=GLlMGQG3D7SIwIcXoRKl8CryDa4fMU23xPBZ4ayt8aG5i61iMdofsFzaEWvilyXOvS
         En8GLJX+TihrVhp9C/oO+BisXnmYIczvEPgXv/L8daom8OZnRyz50qMdkwT23KhmiJx1
         +QK8HujBDa8cq6KiiKZiB2JlfmXSDE1tZgX7jQfhtzlv22wABxZkwO8fFijyfPBkSMxX
         Xm8HRFzXRRExzumbRd9Sbp1sKlXObZp1wv9EAxliRFg9xvIrxyqEkLyrEqa0T/RS8N9o
         X2B9NM1wgGtXoCFO6WKHjXfSY15UyuwmBsFTUp30QSOo3tRJLKcIeIqhowtVNA2vn9rZ
         A6xg==
X-Forwarded-Encrypted: i=1; AFNElJ/8VSyhS9ZNr6uBNV7kS9q97v3ud4Db1XMEF1HTQQ4h4RlRHJ1Qy5BeBMFGQnr2DeDDre0D6e4hrw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzz+Fi4v/lFl6Ay/E59857CAH7bj8k7tsd8Imqwx/s8SMoisuSv
	tUgs1uW95jGrIDEDTOwFBeJagw+WPrLtsCAvk4hysEkR279oFuxCxqL/8sMKSvnWAUI=
X-Gm-Gg: Acq92OECzv1NaDyJQ/gr4Mf6eG8vuPSHVK8U1FdZgqHi78wGxSOjuJXlu8C+yquuaYu
	1ZevY3z3CE0tsaysKGr8udp0ffW+Ds+z9Wist4Z9RN39/l+AHJL9vNvoh73lq2vBo+LNFChKLb3
	NwAA8scna6BSTnSTvMvijs3b0ee3gInCU1JRpXlsBQndE8RUagRgrMrnEyl0PMu7Zmy7f4lvUmZ
	DdJYAEH5a0ZcCN7EHR2yhvkpM3Pa7akieKlsab3F9U9cYdgWxPYQrTfn2sKvy9N5ChMMGV6xQUL
	BwYb0v7u3CY+zjqfJeSj2x6MCc1QjQcVOYRhx9m3FcenkZXUP7vSUM4n8/0BOBlqDEFntQKhlyy
	lku5U48efPhAlK6JiwYnmbD5pGw63a1F8Sr1ajf8fm2SlrYzQDy9T/uAQoOG60Ep7GynC8RZb2J
	bgiE+OLG1T9AAcRaGLxRTTiuuVh4R7Ic/a2JvGXWeEtpLo6l0u1szp8mn+YGcBX0GRauaoku1+x
	Zg9oIFCYbWUZg==
X-Received: by 2002:a05:600c:3496:b0:48e:6f39:f7be with SMTP id 5b1f17b1804b1-490424a683bmr63738415e9.10.1779468303339;
        Fri, 22 May 2026 09:45:03 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45eb6bc5479sm6520705f8f.0.2026.05.22.09.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:45:02 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 17/19] libmultipath: convert RDAC checker to async checker
Date: Fri, 22 May 2026 18:44:13 +0200
Message-ID: <20260522164415.846589-18-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the RDAC checker use the async checker framework.
The function libcheck_init(), which was used to set the TAS
bit, is converted to libcheck_async_init().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/rdac.c | 38 +++++++++++++-----------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index 87b8872..a0f853e 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (c) 2005 Christophe Varoqui
  */
-#include <stdio.h>
-#include <stdlib.h>
 #include <string.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -15,6 +13,7 @@
 #include "debug.h"
 
 #include "sg_include.h"
+#include "async_checker.h"
 
 #define INQUIRY_CMDLEN		6
 #define INQUIRY_CMD		0x12
@@ -55,11 +54,7 @@ struct control_mode_page {
 	unsigned char dontcare1[6];
 };
 
-struct rdac_checker_context {
-	void * dummy;
-};
-
-int libcheck_init (struct checker * c)
+int libcheck_async_init(struct runner_data *rdata)
 {
 	unsigned char cmd[MODE_SEN_SEL_CMDLEN];
 	unsigned char sense_b[SENSE_BUFF_LEN];
@@ -85,9 +80,9 @@ int libcheck_init (struct checker * c)
 	io_hdr.dxferp = &current;
 	io_hdr.cmdp = cmd;
 	io_hdr.sbp = sense_b;
-	io_hdr.timeout = c->timeout * 1000;
+	io_hdr.timeout = rdata->timeout * 1000;
 
-	if (ioctl(c->fd, SG_IO, &io_hdr) < 0)
+	if (ioctl(rdata->fd, SG_IO, &io_hdr) < 0)
 		goto out;
 
 	/* check the TAS bit to see if it is already set */
@@ -101,7 +96,7 @@ int libcheck_init (struct checker * c)
 	io_hdr.dxferp = &changeable;
 	memset(&changeable, 0, sizeof(struct control_mode_page));
 
-	if (ioctl(c->fd, SG_IO, &io_hdr) < 0)
+	if (ioctl(rdata->fd, SG_IO, &io_hdr) < 0)
 		goto out;
 
 	/* if TAS bit is not settable exit */
@@ -122,7 +117,7 @@ int libcheck_init (struct checker * c)
 	io_hdr.dxfer_direction = SG_DXFER_TO_DEV;
 	io_hdr.dxferp = &current;
 
-	if (ioctl(c->fd, SG_IO, &io_hdr) < 0)
+	if (ioctl(rdata->fd, SG_IO, &io_hdr) < 0)
 		goto out;
 
 	/* Success */
@@ -133,11 +128,6 @@ out:
 	return 0;
 }
 
-void libcheck_free(__attribute__((unused)) struct checker *c)
-{
-	return;
-}
-
 static int
 do_inq(int sg_fd, unsigned int pg_op, void *resp, int mx_resp_len,
        unsigned int timeout)
@@ -288,15 +278,15 @@ checker_msg_string(const struct volume_access_inq *inq)
 	}
 }
 
-int libcheck_check(struct checker * c)
+int libcheck_async_func(struct runner_data *rdata)
 {
 	struct volume_access_inq inq;
 	int ret, inqfail;
 
 	inqfail = 0;
 	memset(&inq, 0, sizeof(struct volume_access_inq));
-	ret = do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq),
-		     c->timeout);
+	ret = do_inq(rdata->fd, 0xC9, &inq, sizeof(struct volume_access_inq),
+		     rdata->timeout);
 	if (ret != PATH_UP) {
 		inqfail = 1;
 		goto done;
@@ -340,17 +330,17 @@ int libcheck_check(struct checker * c)
 done:
 	switch (ret) {
 	case PATH_WILD:
-		c->msgid = CHECKER_MSGID_UNSUPPORTED;
+		rdata->msgid = CHECKER_MSGID_UNSUPPORTED;
 		break;
 	case PATH_DOWN:
-		c->msgid = (inqfail ? RDAC_MSGID_INQUIRY_FAILED :
-			    checker_msg_string(&inq));
+		rdata->msgid = (inqfail ? RDAC_MSGID_INQUIRY_FAILED
+					: checker_msg_string(&inq));
 		break;
 	case PATH_UP:
-		c->msgid = CHECKER_MSGID_UP;
+		rdata->msgid = CHECKER_MSGID_UP;
 		break;
 	case PATH_GHOST:
-		c->msgid = CHECKER_MSGID_GHOST;
+		rdata->msgid = CHECKER_MSGID_GHOST;
 		break;
 	}
 
-- 
2.54.0


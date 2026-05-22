Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976B5421A1C
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468302; cv=none; b=ZTKkwzbLJQVSC9t01qpTEov5uHJgOwgQOhJsE4t+18DLrMqLJ0cG2hmTNNldGrhKizcaBmrfK9JVvA3AD0vC+YiHqJpLztSWGhbq7Ls31L6xlFmrHl3/L9z571y2EeTCIRQJYtFYGX8aQz1ADTX3gLPYNk7gsRsPnLI3XRGkYf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468302; c=relaxed/simple;
	bh=PEZ+X4Hl72FJfdDkwER4fan64HGYocKWB5JPCI7OBqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reDsq1e/UW9HU2qs12D6r1alQ3tx+Q+EuYO9Zae+N8TUNoTeY1C9Jf+yvWX7lm+qlxUWEteTAoAwBJwz/dyaBUZ+F07qJL/8+xmjUTGWWha2l4h/EALxLTXRQxbQK/aJPI235R7ZMwvue3XW0gnjLbMBXQsbLhdAezftF6T/D6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VzkdpXI/; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VzkdpXI/"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so103153735e9.2
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468299; x=1780073099; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwFXC758QYV5rwv2cvHQhDXidjdh2M0RENVliKYe5yc=;
        b=VzkdpXI/350DZbEVQdAHYs8DgM067YjWNcFqDB/mXA2r/Bhim7Wf90oy7heqTE3mHO
         CfTpth7QTW3mdd56WJTW68Gen9qKfoHzjqji/UOeDms3wejN9OP23y7Ddx6f2m8lwalO
         2afqDeJo17MLsOEuHOABhrfcDebvTMsYQTmp6wSvgGgJ5ViL+Krg2Zf3KAmjPK6mRYk5
         4jnq9hTTXBrOv2JBo3+pKAZU6uisfjAfqR7udRBgKdoidiA6IsXpZnfex3cePzcoR/XZ
         tNahzoNYBu64Rj3yOkHgSRlqwykvi7qu/UczLEqmsLAfTQq4q+tfz9y1QbdqbNu1kOnu
         wUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468299; x=1780073099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LwFXC758QYV5rwv2cvHQhDXidjdh2M0RENVliKYe5yc=;
        b=MX0owncwU8hHu/aKwHmhu9brLDDUZjcIK6EA81+rK0f4W6kACLpSdmVtT2WZBhvqd9
         SbFVsZ/3fGZKW5THZ755PGGw5DAZ1Natic6cEMIfylXQHBqRyEpTXhJTfF0ZuDY/Rphd
         R044pmZdVpgY+BNdaIFAm1qYHav8XC06n9hEkfvYToIUP8uNdJs3JcEaBx9encvYUoVx
         SPsOoeAVW5EUBwqF1NxeIZP8vdCQk7VF2yVtl/Bsg//obLUmf2GuYYxtbrUxZa2XVBYm
         /F40z2TOHy1nw5sd8oHgPmWXRpY5ZiLU0KrqWQSnf7wWm++BxczTiTQFfk1JTWU2R4iq
         vZVg==
X-Forwarded-Encrypted: i=1; AFNElJ/add53aAZs5K+ByhVySBeyPe6Ks+DfvA7GlFCKwJuQgC83CwGcrCuqnKHbupxYDWwfgLv+RRfSnQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxz6OQp3hYWXyOYGuzHI/3v/jZOsTmoeJ6E79jeouYPE+KkFwDQ
	qqD7zz772MNMXlJF1fGLwBu2ka1GSQrgAVc6KItlvvItjxZG1ypeQAhhIlwIGPZe0E0=
X-Gm-Gg: Acq92OFik8Z+Ne+NC/XP305x8hVho2FwqWXxPOZkI0qZFzHtSdWZYlvPxH0SWW11nmV
	5r0jGn5SdgX9Vo+ui8NeXKDGDuzWmPHy0xNws7jZJ7sBvkf1GcX9QAPZw3W4C/h00QIDevEhGAs
	V5Zf8gYRb12GJ6TiNzoJHXV7+45uNHHmBGN5/Wum7oiSDlSeRFhouJjNrVuqju3fiojwhlbrtce
	MdxW94mE03RMGbEhoxC9G9BINfSLqqM2Bs4QgCFXcrPzsSd7PdZPR6/bEHJRD077myA0uOFZkGf
	1u6TGZMQoqnUYYK5T7WdmoSIXx8qHuMwAw/rXrUycCWehQci/fKwgneEevmNZ6uIZmRdcSZxO2n
	zsY8BXfYH3FGWRvSc/C05h0qDnnbPnyCCLL9S8LCM9HOGCHLO6BvM6vD+e9qenS9Ki2L2Go7HPW
	SqGBqutBgoc9usIHsSZWcEwqp2PLx/rUXlB9TlgfyBe/j8q4JlGbIUZit1HBp3hY6Z3ZWGFk9Fm
	DrvxTUKGEGuS5iI6NPG2Hrb
X-Received: by 2002:a05:600c:8210:b0:490:4663:691b with SMTP id 5b1f17b1804b1-490466369f4mr50364175e9.7.1779468298770;
        Fri, 22 May 2026 09:44:58 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490454a0cd5sm65882465e9.10.2026.05.22.09.44.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:58 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 14/19] libmultipath: convert readsector0 checker to async checker
Date: Fri, 22 May 2026 18:44:10 +0200
Message-ID: <20260522164415.846589-15-mwilck@suse.com>
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

Make the readsector0 checker use the async checker framework.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/readsector0.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/libmultipath/checkers/readsector0.c b/libmultipath/checkers/readsector0.c
index b041f11..fcc4ad1 100644
--- a/libmultipath/checkers/readsector0.c
+++ b/libmultipath/checkers/readsector0.c
@@ -1,41 +1,27 @@
 /*
  * Copyright (c) 2004, 2005 Christophe Varoqui
  */
-#include <stdio.h>
-
+#include <sys/types.h>
 #include "checkers.h"
 #include "libsg.h"
+#include "async_checker.h"
 
-struct readsector0_checker_context {
-	void * dummy;
-};
-
-int libcheck_init (__attribute__((unused)) struct checker * c)
-{
-	return 0;
-}
-
-void libcheck_free (__attribute__((unused)) struct checker * c)
-{
-	return;
-}
-
-int libcheck_check (struct checker * c)
+int libcheck_async_func(struct runner_data *rdata)
 {
 	unsigned char buf[4096];
 	unsigned char sbuf[SENSE_BUFF_LEN];
 	int ret;
 
-	ret = sg_read(c->fd, &buf[0], 4096, &sbuf[0],
-		      SENSE_BUFF_LEN, c->timeout);
+	ret = sg_read(rdata->fd, &buf[0], 4096, &sbuf[0], SENSE_BUFF_LEN,
+		      rdata->timeout);
 
 	switch (ret)
 	{
 	case PATH_DOWN:
-		c->msgid = CHECKER_MSGID_DOWN;
+		rdata->msgid = CHECKER_MSGID_DOWN;
 		break;
 	case PATH_UP:
-		c->msgid = CHECKER_MSGID_UP;
+		rdata->msgid = CHECKER_MSGID_UP;
 		break;
 	default:
 		break;
-- 
2.54.0


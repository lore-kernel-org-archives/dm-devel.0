Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ADA27A47F
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468297; cv=none; b=ApKbLqxxV+iyqxoeYVgC1YslRFwxlA7cH9Rkyr2aFyP3ElZRA9uqaz4qoPxx7YMEc14yTcjtoABYdiMcA8eZyLYK7VAz7mhUITNCgsdf69sycBxgIyF6fwa/mo0rBLtJboCdIKf4VMja+ElQShrW4KZSTo8zFmFxD71uBS3qusk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468297; c=relaxed/simple;
	bh=x2tu+IkNoXY92Ydv5wnjWmP9gRkBSNgVdcVBxLznUWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TC+UsApEpiDcacBwxCjkjYil74vEq9+vlrLrmau4Rf+QbLcVpUUSyAlzKqDCJruqzDx8ZMd9m6TR0cfIfas2wlv/cV7T8HjvinjifqPh+WdjmZhdFlRTPMWZX8GhdURlCrlvi/WUzEbifX4e6hrTKqLGQwA61QCsUBTBj67rLos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C5QOInbE; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C5QOInbE"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-449de065cb3so7177937f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468294; x=1780073094; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Grel0fqV/Y6s/BLKriNFDG4P6sB2qt8Zvb0lp+A3DQ=;
        b=C5QOInbERkBjyoE4GQCFf0zoPT3bM+1d2yobhe16ImSfM1vVWPCnB7kltWnSBAOC5x
         DEr5jmSWIoeZYKIP3OyOuP+b2bPYglXMd4dkf81uRSt8JmdyUU79XUQO1qzNmU514CL9
         HZ2I7LmRHbMdh37nxTLQ9Jkyhb2ZVUNjBbvWMAsDrvFm/m0uHbd05/me6T8kjJ3KSXAL
         XfCkL3FmgyCWWy0ebB/T4usP5SaOoxOPPnyK6uCbR9Dzf7+dMz7mOL45GdDvCtX9Gm2c
         Ok9L4mDRsqyo1Ftxmdy0QCjI78JRSC91TAcppmxPE1gZDt2fQ3UNxQWmCDVEQ5yAquXq
         fxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468294; x=1780073094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6Grel0fqV/Y6s/BLKriNFDG4P6sB2qt8Zvb0lp+A3DQ=;
        b=fxx5nROmXSsmRjOHZbwlt2PkhBMolPEXlrDj2siTBwa6fvXdc0mOAI297NrhEAuMt+
         z3BKHfbixenOtd/y4P9oyBBoKkQJxRQMEShw54BRJsdhMp0DIpFL745Wk8KdytzC01QC
         xFPdd5QxFulelQHh6X73qzspoz/KaydShGL0RbY/tSCvzpeM5NrYje00VFEKITMkvIU8
         XGigizMpWOryHE9n4Ebim4DvaaZbtBq5UWuysZV+20xAV6pp8a0C9BvshbvFhXNedmKW
         q/fR7uL1sPuAqeSte9HyX0d44k0UL2OEAFK5JZTgIj+CJDOGvK0eRHGt7nfom7YX4cp3
         bcVA==
X-Forwarded-Encrypted: i=1; AFNElJ9tRKUYTUobhd0jhwwhPi2rMGKyocylFCxSLdpo4AFgku+RQM4U58Op6V7Ci0Ry3UFedmw1fkHqBA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzqwb7fivQR96oBBtbA/RKc7mH3JPjJr89EbrOmtBCVbxLmrDgQ
	h2BbNgY6JBBUOVWFiLr/oUaNWqH33QlnEBofEJnQecBSpwqzVWXYwROAtBIJklgpX2k=
X-Gm-Gg: Acq92OF5fW4yQIWz3X8pbQ4m5hwx7Da/M8nJY7iVFnm7W2VJbXvfp4JwWb4N2IeH8CS
	PQzjSHHfsHt9K+KN91xfKq8XRjrxWMpfYE0BzsSSgFsfqqgFpooKZrn0KlhiJJyjEVYOzQmMHPA
	trqj7B6hTjRCrecFF2R1XYqNU+u+7ZQKIuWmm+AD0sfAny7YQmlsII4/YpKcZOjE2ol05J4Z5tw
	H48jWaGFJsmDoiSKA9btO60kGWaQxKNuYFfDOvRdATSUnhy7JYKQOiTq1C5PuCtfTkOOh96XhUq
	ajU0de8M6LABSra7KY/8Q3GDfMZBaTWSplgu9uti26FMIjT+SawlQEDXcezOnlZbDUn4Kb3o3tr
	mdirzKsgV6DPjNoPDlNogEg8V75+9Hc7rHbhsHZ8MmQGCOEosKX6gwBwWIFEMKKhCMwFBKor4ow
	gIYXTt1SC+dNzrMUIAZR22koqOi7hfocZJ7/FdkmBmcBSAIHgeOxNyKQqhSVof6/78n2u6zKoPQ
	2+WB/bfxir5Dg==
X-Received: by 2002:a05:6000:4804:b0:44a:be4:d0e4 with SMTP id ffacd0b85a97d-45eb36ac4b7mr6946607f8f.25.1779468294253;
        Fri, 22 May 2026 09:44:54 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45eb6d5e363sm5727189f8f.28.2026.05.22.09.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:53 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/19] libmultipath: checkers: add support for async checker
Date: Fri, 22 May 2026 18:44:07 +0200
Message-ID: <20260522164415.846589-12-mwilck@suse.com>
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

If a checker shared library contains a symbol "libcheck_async_func",
use this as a callback for the async checker functions, and do not
read any other symbols from the .so file except the message table.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c           | 51 +++++++++++++++++++++----------
 libmultipath/libmultipath.version |  2 +-
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 3a1663f..2f20b25 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -101,6 +101,18 @@ void reset_checker_classes(void)
 	}
 }
 
+static struct checker_class *add_async_checker_class(struct checker_class *c)
+{
+	c->init = async_check_init;
+	c->check = async_check_check;
+	c->need_wait = async_check_need_wait;
+	c->pending = async_check_pending;
+	c->free = async_check_free;
+
+	list_add(&c->node, &checkers);
+	return c;
+}
+
 static struct checker_class *add_checker_class(const char *name)
 {
 	char libname[LIB_CHECKER_NAMELEN];
@@ -129,6 +141,29 @@ static struct checker_class *add_checker_class(const char *name)
 				errstr);
 		goto out;
 	}
+
+	c->msgtable_size = 0;
+	c->msgtable = dlsym(c->handle, "libcheck_msgtable");
+
+	if (c->msgtable != NULL) {
+		const char **p;
+
+		for (p = c->msgtable;
+		     *p && (p - c->msgtable) < CHECKER_MSGTABLE_SIZE; p++)
+			/* nothing */;
+
+		c->msgtable_size = p - c->msgtable;
+	} else
+		c->msgtable_size = 0;
+	condlog(3, "checker %s: message table size = %d", c->name,
+		c->msgtable_size);
+
+	c->async_func = (int (*)(struct runner_data *))
+		dlsym(c->handle, "libcheck_async_func");
+	errstr = dlerror();
+	if (c->async_func)
+		return add_async_checker_class(c);
+
 	c->check = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_check");
 	errstr = dlerror();
 	if (errstr != NULL)
@@ -158,22 +193,6 @@ static struct checker_class *add_checker_class(const char *name)
 	if (!c->free)
 		goto out;
 
-	c->msgtable_size = 0;
-	c->msgtable = dlsym(c->handle, "libcheck_msgtable");
-
-	if (c->msgtable != NULL) {
-		const char **p;
-
-		for (p = c->msgtable;
-		     *p && (p - c->msgtable) < CHECKER_MSGTABLE_SIZE; p++)
-			/* nothing */;
-
-		c->msgtable_size = p - c->msgtable;
-	} else
-		c->msgtable_size = 0;
-	condlog(3, "checker %s: message table size = %d",
-		c->name, c->msgtable_size);
-
 done:
 	c->sync = 1;
 	list_add(&c->node, &checkers);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 5deee32..c091ce2 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-LIBMULTIPATH_32.0.0 {
+LIBMULTIPATH_33.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
-- 
2.54.0


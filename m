Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD8A48A2D6
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995841; cv=none; b=brIjfCurRZ8wDgm0fwCXWhxAS8bX5mnBeivL9Weu15tjRYwrz+0CB4OK8FBvOtIHhpYo+pZinGxfeA4eCYAuq2CEuiFF9IhORCulRWWJ1ghrkEiwS0YVQTH+e/J2NobpgYzRJFoBNUoe2R2Me3k1sr6ElRx8kL5HcGi/N9AloFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995841; c=relaxed/simple;
	bh=hzVFSRAR1OD5QIHlJMqd4tT6dhu4YJDAoB8s3Bagjco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kF+IBHMTl3Hw6NeNiW/3Y0BfjyRqc6vh/d69zEyXubvu50wXj2wSbfyKNSCJB6JlDf1AZzDUqHjpsynDsPWOWb6yJfmfViHHeY0PscEWMqoxykvEk4rTYa11G9JasZVbvRDk5tXkjbQhL9NkLVBDMPY9MiGwErRxCdxBxmaeL98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D6MmEVoB; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D6MmEVoB"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48a563e4ef7so52430185e9.0
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995838; x=1778600638; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogP480h5In236yzJU/6YPtUqWWV3hL6EipFFCJsxdwI=;
        b=D6MmEVoBCAix/s6301fOi9mTyciZFOwBsDtGeBeiuApUk+p9AciftLXXgvsy9bwLHd
         tpbnpApGb8JxejVq8kPTusij6iafOoK72/HVBoN5W2wab4P/Ezh4Bc77zU1VrILn8vMT
         lh0oq5LyoSt7m4hMmCWC5TjCI88iF+kYqTJEfQ5HwPvlo8cpCeff6kcYmxIzR0/h4uPu
         cipF5cupzgEYRjv4MOchkvXXTHemp19/tPZK3qelqM9WMOVaftJf+3Ln/XsNvscgfOD9
         VsdJMcyNudupr7LCpLjuvMQiyBpNxTXhpLuOUC+IeIVWOad7ucaVE6OJMQEgeIiVKMbU
         ol3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995838; x=1778600638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ogP480h5In236yzJU/6YPtUqWWV3hL6EipFFCJsxdwI=;
        b=dCB39+Yk/NRfTiGVOTRq3e8MiDBWMQQB5jSXFTovT53A/I1p20UDVOBqI4rU6Glloo
         oxBbmgXc1hXHWXC/cdj1gHvxeIO3EX9Lsw3d8+k7rDu4pX0YZ/M2VUoYLTwkQAOhbu3P
         lDqiRG/I0BseZNbTwa6sZJ7nZpPHZJiU83Ry0pYgo6bPsAEKRvGbsIIgLt1wZueWBQ20
         PXWPSkKjdJHWbNSl8ZdJ2tPbwarWb6qK8iA9h5V/uae3OSwLWGg84Gok4DNTNgkm7aJ4
         w0QXVXamJt68Ti6iOxVLxfq9eRZpSHAK7yeavKHQioJ3abI9QsMN0p5sRb25VnYqPYtD
         SX9Q==
X-Forwarded-Encrypted: i=1; AFNElJ8+4UXTZJstht8IgOEdgKnxDYIKUJhAJjTZELVuVyoUxcscYD025Va2gMA2DCXqog97nwjZa55FiQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxc1xCajmjsoWGdQM0EvaWwUEVldVqTVa5AZ2tFWxWyWOM5Nr75
	WeglpKr/el+xIwY9IweRhJKjf9tT0ymRlqJEEuQXG/un2pnNJQdk7W+mqxVYv8hIzmg=
X-Gm-Gg: AeBDies0zwW7GLMFkyrMg/DXuS34sVQuU3KYSuxOXuVo5IZx103d593fJFLJxrOkjnb
	dLsIHB/0xON6P+xpJSIqGeX/i3rOf1QgQAtwe4oRTVJ06tdwZHzi/NlCqiwm81omuHTqCDI83aI
	S5Nt9bq1L6FkDcwDU6KMcjCqukgh6HmFMde+rHKg929J/SStwO/34iRDMHri+KhUVpV+7KkvBZt
	IsMa3H/G69Ju5rCNQg5p3+UXAOhoqpplLBBXuuPyDL3ayLibwxud6steyS3qLmSy8Lm9J0510bK
	uYRB7yFZVcV9G1+I4n+iniZqEzdsQzKS+GIcF6SvnrhW9Xp3oDPqyH6qGVi0HN0OGFEpeiVwscv
	sFAxm0E3FyBBozZX3ZCSJD7wtImVrCMMkkFh8gIh/GmZPhEIB+vTza+gCNiF7Dfg61t0Laz6JnJ
	cUtipmSzcxdklK5UkBhdvccIUWOj39zhvTrMC1SRY77cyOq+LVKiZjC1ogadgov1zcofIJcRm5R
	i+WUiEwEGFcByVOvkd6lfji
X-Received: by 2002:a05:6000:18a6:b0:43d:7b7b:ab77 with SMTP id ffacd0b85a97d-450041b05abmr7105113f8f.11.1777995838082;
        Tue, 05 May 2026 08:43:58 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45055960902sm5976324f8f.28.2026.05.05.08.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:57 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/18] libmultipath: checkers: add support for async checker
Date: Tue,  5 May 2026 17:43:24 +0200
Message-ID: <20260505154332.448054-11-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
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

Checkers can provide a symbol async_context_size that will cause
the async_checker code to reserve extra space in runner_data for
the checker to use, and a symbol async_init() for initializing
this private context.

Only emc_clariion will use the latter functionality.

Signed-off-by: Martin Wilck <mwilck@suse.com>
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
index 78fa2d4..5e8dbda 100644
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


Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4066176FA8
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804571; cv=none; b=kuGlbts9Mqt/SSJ3uXC0SZTqrwwAgzEEY9fjuejkFnAObbjRrr1iHvTFHnKUk+Aq4NwT0So1CIjWYqvY2bFIgL4aVzMbknJ23uHsZzLrzJuzekgdE7vVPGePX2oT+8XDreRHRUtpvmH3uovNbe3YhV5/Aq7ODObCEJEeyHMQ3Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804571; c=relaxed/simple;
	bh=rdSG7FmxdyXLeAq25o3hQE3nxP+IUBdsYier13bmL2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGovh45DyXi5MYYN/WZX5JzAJXh9qyHzHCdUw4FuscEMJtMDErQ+mPszC8w0NTiYJvOjwb2mCFFIYuQZa4m1+0VWQjJO0c8WO8HE0zUoJHnIQDCPteqMe5A7mDpSpSNffVWfedwkzQMHJMwHaYVezLGKwhgd4V7y6iURMPMRQq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZM2jmq0q; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZM2jmq0q"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-58ef19aa6b3so1408253a12.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804568; x=1721409368; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6nDPc0IZERQmxcZS+rTSoQQ2RUISh07zFf1sF58B3Q=;
        b=ZM2jmq0qmzm1aWDv+RUoGQUwUhKeO6cdhjr8hgCGbyXsrQSc7Jn8CEF011KNOOhIUl
         tPGqfUMbwTrUR2mflmNDP5bDdiRQSpUkM4Wd2L1UfTTrshZYRy7qYoUezMa1MhYjT5po
         03SWClEWan3Z9qMOvy2jlrWZkqHY+QFmfW5tpRkk+L0p/A540o3y6KeEYz87wj/7G7xu
         A9AOtCsAnhXJ2/KZdAikOQoRhbhT8i0nzeRJu4WffrE0df0WFfwH4UJEyfqkVj4isg/R
         UJ++wRu2jiaGuf69O3UgZTFMB1+iOJ/IV7sJGVxn9I42kwkbpcEZn0agggXx+eoKfTkq
         vYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804568; x=1721409368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E6nDPc0IZERQmxcZS+rTSoQQ2RUISh07zFf1sF58B3Q=;
        b=OYZJzW8Vb439IyRr7nYgrmxsVa9tCWNim+TN4gInwcJBoYDtU4egJ6mllRv1tKN5Ar
         mSyZ/z3sUE+ppk6p3gBieOMS8OXT431As1tYEke/X3+en+cZ0oAFHCbZQI7wBBQ4AY+2
         T9BPnB8KhLoMp1ppiDBgpoy7GIXI6K6rLx6utAEJScbEXmgaiB2leBNh6IdABW9Vevp9
         gM7XKCwPB7BRGoAgPeBD3BHVfKv7kqWef4XnrlzQQ7pJGOrnu10olrJZNVajC632J90E
         bn/JfyBwuSJrKJh/w36c9YGvjc1NTnPYFBYeS+vShkH6WLLiywk5DTbLdf8WblVcWc9N
         R7ag==
X-Gm-Message-State: AOJu0YwEMA7WGE+a26CYj2L9duGOd8pk3n2kLsvVkemlc74uETYFm46X
	OJ/2BE1U8BuRgXgs82tmXQ3KnVTeVrVk/OeBhJyH8b+ZmYcolmk8/C7BnTsLeyWUXUWjRs0jgVZ
	8
X-Google-Smtp-Source: AGHT+IEg2iiRb/ljCRJ1xSpw2ZofL64rUrY0OTDuNYh9MPVW/dWz+TtyVcxEs66AswwrDlwFpl24uw==
X-Received: by 2002:a05:6402:348c:b0:58f:2087:7983 with SMTP id 4fb4d7f45d1cf-594bcba842bmr11035265a12.40.1720804568164;
        Fri, 12 Jul 2024 10:16:08 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bbe2cc6asm4703919a12.24.2024.07.12.10.16.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:08 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 35/49] libmultipath: add dmp_errstr() helper
Date: Fri, 12 Jul 2024 19:14:43 +0200
Message-ID: <20240712171458.77611-36-mwilck@suse.com>
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
 libmultipath/devmapper.c | 14 ++++++++++++++
 libmultipath/devmapper.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4ad84dd..e51c2f0 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -79,6 +79,20 @@ static void libmp_udev_wait(unsigned int c)
 }
 #endif
 
+const char *dmp_errstr(int rc)
+{
+	static const char *str[] = {
+		[DMP_ERR] = "generic error",
+		[DMP_OK] = "success",
+		[DMP_NOT_FOUND] = "not found",
+		[DMP_NO_MATCH] = "target type mismatch",
+		[__DMP_LAST__] = "**invalid**",
+	};
+	if (rc < 0 || rc > __DMP_LAST__)
+		rc = __DMP_LAST__;
+	return str[rc];
+}
+
 int libmp_dm_task_run(struct dm_task *dmt)
 {
 	int r;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index a10821f..7231a98 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -34,8 +34,11 @@ enum {
 	DMP_OK,
 	DMP_NOT_FOUND,
 	DMP_NO_MATCH,
+	__DMP_LAST__,
 };
 
+const char* dmp_errstr(int rc);
+
 /**
  * enum mapinfo_flags: input flags for libmp_mapinfo()
  */
-- 
2.45.2


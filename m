Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89E4187848
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561222; cv=none; b=WfChQS//E17gOuMRkzr6eoyVSou+ynr9ogw4ZHvxDTZSw5hKAhc3bm3j5fiw4Ijg0x/xVYB1ZytzteM70UrbW1950WkInwfhVF1CRVtL7U6fRJXOCJ2fyuZNRKnWSyNsjh1/Y2ExZB5C2BtdyybpPEjDMmAF4blbMI0fUwa1QP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561222; c=relaxed/simple;
	bh=ywGguZ7PqxtN/Ez/vq9Wli4uXIDg8IvxoP159atQrcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nk0qT4C5R1tmjMob/cDyxPRsq7QzL1EcoUozb/8NFKlEARaHLbJekV8rCh+JU09wxcLPIrArcQppP2drNdUp2Qcd6sSL2S+kR7pA31vN1/vCFo6e//pVH2jJOgIsnOh5Y/p/G1d2WXu2AKkI99QrtRM+ACVFZzx7Je37yk078HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ANZvhzS0; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ANZvhzS0"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77e392f59fso418550666b.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561219; x=1721166019; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t9lLw24Qvkx8cZGgwoGnciNO/PuwztxJ1g7PZxEdVek=;
        b=ANZvhzS0xylo9zdSAeFDJZpK+IUH9CkoEchwMWjpqQtrlquejnDI4LqQPB8zY3H7iU
         kgzqOWNeO0TwdmfCHMINi4aHTMY5mdfLDexenayi6cEnVSXRY05VJa+GXAnyAX4AtJsP
         BMcDCIxZrrPGxeKv621M+XVy4OttXchnwGUTCQf3N/qPp0xN9O3wrlXa62Vb2A8kcmGA
         it3QoADcuyMZvtPULspaAQ8aAf+ApzgxxCBzJcQDOQgE5F2byEfZ0frtBLVYXPiwlIuk
         9aGX/r09nBGp+UewjIh3t1up/Yo1FV8ede4nChyhciODkJ0FAXiE6o9R5qxRrXVtIrxm
         z+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561219; x=1721166019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t9lLw24Qvkx8cZGgwoGnciNO/PuwztxJ1g7PZxEdVek=;
        b=AIwWsjlsd54+F6jQgAv4uyr38okVPbWGf2yXGjmo45+ZhclkczB/kULZWn4O80RTX4
         vlqw7aW6YTYcnuNTN7h29a+Vv+I5p5zls4IJGvGRPXhud9lpRC2eJSlyOy+GpN1tHr6f
         DsAc412YIrxLKnXWq4PGe+WxDEblFEPsK8DhWBGDMSxe3Y3rbjqAz8M8Mwn7fX18uP5N
         KnIMdiGDJTbn2wR+G0NQ5d09l73Iusp3fK2culdRqfwHeoy9bLQNvGtGtq2X8mVo9MgB
         aiju36O9NWqDXVc+pQ67nQolTNUIxlKiBmIN7HoVbDJGFlfAfv0xcyj0T3ffmNBJCIyd
         5zNw==
X-Gm-Message-State: AOJu0Ywfxn74+IbQctXHRIPJi7VfG/vVhaWyCEloMTRYsaslB3JByeGC
	4HUaAteuANMAluv5/jJ2z6SnimyH0GeyvlYOZXfA+qJXfEyhcwGQHCMKCFesdXI=
X-Google-Smtp-Source: AGHT+IFbfmtnOV8JBqF74xOdMB1mthck9ALpcVz4me4aZ3KgSWmw8p6HNtJuk85s7DqcBIkMvUQZ7Q==
X-Received: by 2002:a17:907:3f19:b0:a77:c548:6456 with SMTP id a640c23a62f3a-a780b88608amr298707266b.59.1720561218893;
        Tue, 09 Jul 2024 14:40:18 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a72fd39sm108850966b.91.2024.07.09.14.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:18 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 33/44] libmultipath: add dmp_errstr() helper
Date: Tue,  9 Jul 2024 23:39:24 +0200
Message-ID: <20240709213935.177028-34-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 14 ++++++++++++++
 libmultipath/devmapper.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index d321041..f7ad7a8 100644
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
index a2b2837..ed5e866 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -33,8 +33,11 @@ enum {
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


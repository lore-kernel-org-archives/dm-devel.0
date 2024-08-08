Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1BD190462
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130820; cv=none; b=D7v1VznfRI9A0xUdChyeKZRKx7mMZyxwZi8NmTyHsb2B3TQtrm16zWtWFYNoECF/MqP8GB0tSGDoJfLZkl2DQwhrgeY96XL9B76nnCOXE8e5zY4nPPhb0L4bx6oGPdJE3KiPkXExw/F98HxYJl33T1aY21tIOESVjqaMqwjiqpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130820; c=relaxed/simple;
	bh=SferSm7gQwjsvs1jIhc24SVw7F61Gi1NOCeCqlS5+ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYtMLdjCpztELVM9ycBaLGCZDxLilKh4rGWHoE2MH9jMKB2IVHpem8UTkdhlv+ewhANf66mKYIF9PkMF9GzCOlQtfWZ7Z7qEojsswgs2DMmYCtZwM3TIqg5ulUBOBIUBg5jIqUWdgFPySSSUl2cpQRKPu4Vxp+LmOyvTmTLMkHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gNvRVMSf; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gNvRVMSf"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a7a81bd549eso97608666b.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130816; x=1723735616; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3NlI8fwGm6fP48uLft8EtDunzL17dsF5KwEJj9rj2VQ=;
        b=gNvRVMSfeSMFDb4EdsOLO4kjIciXf7LLI0detHcMIyfQQwrkbF0+yIYWfONJHXZ8g+
         Ehs6+OULsFukmQRZy/4NYZcmJOlm+mlav/rkS7vL13xWUa6B15VkpMjsNRAXH5KOd4/f
         memLx3QHuhAZzC1fy/aGWWA1J/OiuIAXttLx6O/wly7Xz2RDMkIUAUZpkAwjoLv0wVF4
         MusfeORsJlSfGegsSmCrraDxsYietOmrGRDjgohmYwOlpSmO++J8rcE6QIP4/HCDunkB
         SQMVGAVR4vnsQ2ogKADHtAPJPypSN4aHqEW1mQ5zg7DQLpYiDtlbylmClSNOIucy423Z
         Jq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130816; x=1723735616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3NlI8fwGm6fP48uLft8EtDunzL17dsF5KwEJj9rj2VQ=;
        b=gexLuiiEnlG2PrjAoaMATMIB/woQQyDuf0e6ZoDCoE5xRtm0BH9vUrwh6d2TEMpkow
         r89rvfeiuwz18n9HWw0dRTqCuBGWL6JuwpIyCO6lHUpVHv/3X2CDhVKR5Xy5G9wi2xQK
         iYYoR0pqn3El6wslyOccPPYTUlZ3n7jQUv9/dBcuE3Yhtlw5cFkbVUaoQmtBWEShT0d7
         d9gt5fruvYuZ0Sgc+iPudWpA6pzd0njzpfS3hLA1WmSXlJvdylIgHU1VuA4wYEjfCJAU
         SbRP+B7zyMPm1PnGUdLzEvQwBbL82QTDLK8kQsOU4p5r5/g3ZJwMnKDcF7oWPOeyReLu
         AH/g==
X-Gm-Message-State: AOJu0YzUcMuFL+tLdrW9zXftDGu33VNIEd2a9I+w7o4oTaSlZW79M+Cd
	vi3qB5+PRlnYIr8yIKPAc3xrYV7uhLgwxOaUhrS1JbYGCpbqU8fqejUktyDnH6E=
X-Google-Smtp-Source: AGHT+IGcPE9QOek0xmRzSYylBpWGVTB46OdgyivCPHSwe0GUGYRL2JN9+cl1aL3s1DOr5Po4WdJ2sw==
X-Received: by 2002:a17:907:f78b:b0:a77:c043:5b5a with SMTP id a640c23a62f3a-a8090db1dfemr174689966b.39.1723130815994;
        Thu, 08 Aug 2024 08:26:55 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9d437bbsm747852066b.121.2024.08.08.08.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:55 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 22/41] libmultipath: rename macros with double underscores in propsel.c
Date: Thu,  8 Aug 2024 17:26:01 +0200
Message-ID: <20240808152620.93965-23-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index e2dcb31..a3fce20 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -48,7 +48,7 @@ do {									\
 	}								\
 } while(0)
 
-#define __do_set_from_vec(type, var, src, dest)				\
+#define do_set_from_vec__(type, var, src, dest)				\
 ({									\
 	type *_p;							\
 	bool _found = false;						\
@@ -64,11 +64,11 @@ do {									\
 	_found;								\
 })
 
-#define __do_set_from_hwe(var, src, dest) \
-	__do_set_from_vec(struct hwentry, var, (src)->hwe, dest)
+#define do_set_from_hwe__(var, src, dest) \
+	do_set_from_vec__(struct hwentry, var, (src)->hwe, dest)
 
 #define do_set_from_hwe(var, src, dest, msg)				\
-	if (src->hwe && __do_set_from_hwe(var, src, dest)) {		\
+	if (src->hwe && do_set_from_hwe__(var, src, dest)) {		\
 		origin = msg;						\
 		goto out;						\
 	}
@@ -660,7 +660,7 @@ check_rdac(struct path * pp)
 	if (pp->bus != SYSFS_BUS_SCSI)
 		return 0;
 	/* Avoid checking 0xc9 if this is likely not an RDAC array */
-	if (!__do_set_from_hwe(checker_name, pp, checker_name) &&
+	if (!do_set_from_hwe__(checker_name, pp, checker_name) &&
 	    !is_vpd_page_supported(pp->fd, 0xC9))
 		return 0;
 	if (checker_name && strcmp(checker_name, RDAC))
-- 
2.46.0


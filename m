Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB1F187867
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561202; cv=none; b=qCQVcv3DvXNfKtiJHvn90Cm7Wpygt6Y4qIzH/O5siXTYpg3Faqwuqt5MXVbiavGu1LxHc6cdPGNbrKeUEL4TlWGagyXzqX2pBNzFNFRueKdnVbPY5hqMuhrjDEbyBUakM3pYp7XvOyRsCjwVDpoAFBORVlSisFDuoWGq9y+jOzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561202; c=relaxed/simple;
	bh=GDldV01uGTNRaexJfgKczXb9VyPOzdWvLzZt6Z62E5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0zwrixNO/9ZF97V4CgpGihvS13z66koT65bNYeYoFFfp+Ms+J2j0bZ37bNnlgXYjCm676oxYW6o22IR/6F862F/+DESKL+xpdFG0+GRCAZGVoELOCtVKQx32rxMZirgbag3xQZOcGy8HOnxZ3ZlIFLrZMEC79CqLON5bswRNXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gXRLQ6E9; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gXRLQ6E9"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a77c9d3e593so506269066b.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561198; x=1721165998; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AiwVbARJ+bNfKHdGZqEy7QI5EKPnlZNS0bFBF3MmDmc=;
        b=gXRLQ6E9bs2j3cXhSjBxS1ZiIJL/o50u89wofc3lL6W6P91ttfQJE5ee8Xzd0ueBtg
         LJKeXDzuJXfDwp8lN11eNVRFWGy1n3LPNUNeNkf36SStjRg+YjjL6yfCnxoNB/i4xk4L
         9hJjPvLAqO0d9VZBBdkovjj7ZbSCSWa7GReNRn/d8ViR6trJa+jRX/R+NoxClzFnxDso
         x9ewpIF/1tz+3IGzYP4IXMgq7XrNqxe312xV03Fo7ZJUsWV5JMmAXTQ4+DCNw324ykaG
         xiiRdhkquoBTrYfs7q5hjpsGMbaonx/lKAWS1oNW03/nz9Fet71Dmb13fOc1K0+XfW4A
         LNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561198; x=1721165998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AiwVbARJ+bNfKHdGZqEy7QI5EKPnlZNS0bFBF3MmDmc=;
        b=ea98lTKJWvJcG1D0wvI4o/4iiDmpMQc+Wnl9vx7aSpKIStVYHdXg83YBCYpltb1V1c
         idbvPniV5YDNrGaxQO4J92td/2r2/Hq5/CWmKRCr/J1iK5AxJURQk3rYicK3jiFUaEX5
         icIgzuFhm3XmxVnQExFm9nR/gaCowpSUq560ZPFql1vHejD4SH8jp8ytckeqcFVCVybn
         33xkQmbiZE3Z9icniw9YS8FcTFZ381D3K9wDen4/xgvDG9QFn7BF6bNbI/jOLY+r2BPJ
         MhqG9bbLcBmkyCFw9r1Yp2loYKUdjqBlZj2ZsAUscpotSwxG+y0OBiVoH7sU8bwHuJpp
         zSaQ==
X-Gm-Message-State: AOJu0Yy+r83mTqJDMWPec55peZsgpVTenSTldSAOOUB3gOKNLAU/EuZT
	TGtfiPv/Bb1d8GqN2FGfsZIqf1iA1WGyZRsiqlRF5c8mJCYjqfAkMw4bsSBK+nU=
X-Google-Smtp-Source: AGHT+IGA83X5RXxUi1cJCmoJWJYU32YLO5zSjQN1JS5TgOECo1LjqzXbOVJfgrHIFGVsw5E0leqFIg==
X-Received: by 2002:a17:906:2b57:b0:a77:cca9:b212 with SMTP id a640c23a62f3a-a780b7050dfmr269056366b.45.1720561198234;
        Tue, 09 Jul 2024 14:39:58 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7fef9dsm108968766b.99.2024.07.09.14.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:58 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 14/44] libmpathutil: add cleanup_vector()
Date: Tue,  9 Jul 2024 23:39:05 +0200
Message-ID: <20240709213935.177028-15-mwilck@suse.com>
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
 libmpathutil/libmpathutil.version | 1 +
 libmpathutil/vector.c             | 6 ++++++
 libmpathutil/vector.h             | 1 +
 3 files changed, 8 insertions(+)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index 86450f4..cb05231 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -136,4 +136,5 @@ LIBMPATHUTIL_2.1 {
 
 LIBMPATHUTIL_2.2 {
 	cleanup_udev_device;
+	cleanup_vector;
 };
diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index df59db5..7c3ce43 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -169,6 +169,12 @@ vector_free(vector v)
 	free(v);
 }
 
+void cleanup_vector(vector *pv)
+{
+	if (*pv)
+		vector_free(*pv);
+}
+
 void
 free_strvec(vector strvec)
 {
diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
index c0b09cb..a41f157 100644
--- a/libmpathutil/vector.h
+++ b/libmpathutil/vector.h
@@ -78,6 +78,7 @@ extern vector vector_alloc(void);
 extern bool vector_alloc_slot(vector v);
 vector vector_reset(vector v);
 extern void vector_free(vector v);
+void cleanup_vector(vector *pv);
 #define vector_free_const(x) vector_free((vector)(long)(x))
 extern void free_strvec(vector strvec);
 extern void vector_set_slot(vector v, void *value);
-- 
2.45.2


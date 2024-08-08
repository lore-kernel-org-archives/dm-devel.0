Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733A1190496
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130827; cv=none; b=StQnz32u93Rg49dyTk7vzy9poVuFeHWcMLziCEXkxll5abNGQSyU+5o4iyVysToDiqhIHdNOPQzk6lwxcR3E0jdK2KtHHYwTUYL02ag+AtRk5gwrjmSwFFtbQ5qzbEpcp3C+AW+TGNDorKsk0jFYU31Rn4bv23F9q1tv6JBZYJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130827; c=relaxed/simple;
	bh=PcutuV9sz5YtjKCa0x2seiyTjzDv6DIDETTcNWXqq08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr/jdMsj/upmW5KjCJfLVoH7WmHtiUtcaUXvkqfKCF+ZCAp70O+qLvIaIfcDPJZpsXfNilS32oxbFBfcJDjSH/hpwgKn2t1UpZ38ctDZN8vs/KoAELIhg9PrseHm99Yz4nAYpcwAA9ZGU0vcLo/0y3aEdPuEVA1LxNem21zam2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OFzHTzoo; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OFzHTzoo"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a7a9a7af0d0so138534966b.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130824; x=1723735624; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=htcux0/wSrySG9BnaIiMFLDdx3wbC4yP7Itv73hPvNc=;
        b=OFzHTzooMZn7gYeaCdqiwymNUK37vzHV/R6qlqDqBkuaEOxy82KinIAzLXLNWIvr8E
         5FcT1lqEe7DdkEf1KfP/XdfJp84HWuxCSsFTFEEeJeEEO2FLdNn9nx4dawxVxoXhQPHM
         qRFVqQNKcQ2/sf91wntRm8hPoN8QgCXHxSoRmqxR8wKSyi428i13bNB+5f3pbA7/TG3a
         FcweLfpRKbbzcYRzxLyAAI8QV6rYL2nAclC3lktcU3Tc3/T0zl0PQ1gxy9liYYu0QUNt
         cdj//lnlD0UmBDGUqGwTduvLyfhmeTFXLuQjAn/CuaFdBojV5mS0RNmahJbMb6Jy3F5H
         de7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130824; x=1723735624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=htcux0/wSrySG9BnaIiMFLDdx3wbC4yP7Itv73hPvNc=;
        b=SovocmltQ+/1liES1X+H+vItV4lw1Cq90QvUTYhKYu6yfgQkWeJFJJ44R23zO6/cPt
         AU2+A+JYYW92d4tz0H5se8KB3yqyby+s1UzoESKDH35eZQwvDUSav9ulp58ORANZq4pq
         P2nzJkWLbXxRhksqeOwPPtxSS4uvqhZlbrYaswg7d6Yd6fBqPlhjBqjMRnZWs4TYiUcl
         TMDQHDH8GoEd0S1WVp+aEnc41fruqb7rI/45CQiTCuAhK4ZWSrQ0wUnggcaPEyVZFG9I
         pmVUR4J3bVn33YI329xta4UyC1ckfW8DpfEXupvA9Z3/0IN6yMOyUQXf4FqLNebGyHXj
         pbrQ==
X-Gm-Message-State: AOJu0YwUXlnDoQRjtSb3oVA/HIC2G5eJb0IU6M1Tg9Es8Dst0vQTITc+
	mfnCPAqZCmkj9mgfYJIt2/uA/HE32FztM2a1c6dqc1LhrIh43tHk9sWgX0oxaB4=
X-Google-Smtp-Source: AGHT+IEZUEsjLUdbWUQU+8b64llVNEUmXR2n7xj4zPLa8VGvVZQzsPrCksN2wVJ9ASMOuhQiyMC4ug==
X-Received: by 2002:a17:907:f71f:b0:a7d:340e:43a4 with SMTP id a640c23a62f3a-a8090da5fc3mr164443166b.31.1723130823621;
        Thu, 08 Aug 2024 08:27:03 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9bc4230sm753344966b.32.2024.08.08.08.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:03 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 29/41] libmultipath: rename _init_config()
Date: Thu,  8 Aug 2024 17:26:08 +0200
Message-ID: <20240808152620.93965-30-mwilck@suse.com>
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
 libmultipath/config.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 34cbb43..b742fb4 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -879,25 +879,25 @@ static void set_max_checkint_from_watchdog(struct config *conf)
 }
 #endif
 
-static int _init_config (const char *file, struct config *conf);
+static int init_config__ (const char *file, struct config *conf);
 
 int init_config(const char *file)
 {
-	return _init_config(file, &internal_config);
+	return init_config__(file, &internal_config);
 }
 
 struct config *load_config(const char *file)
 {
 	struct config *conf = alloc_config();
 
-	if (conf && !_init_config(file, conf))
+	if (conf && !init_config__(file, conf))
 		return conf;
 
 	free(conf);
 	return NULL;
 }
 
-int _init_config (const char *file, struct config *conf)
+int init_config__ (const char *file, struct config *conf)
 {
 
 	if (!conf)
-- 
2.46.0


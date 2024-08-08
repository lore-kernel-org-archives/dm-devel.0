Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9068019047A
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130822; cv=none; b=aQUTg8gTvoTZv7NVQ/3JV3J3Wpt6RrajIz7RiAONPzLHy8A6LuUnFQuaeOi5iaeiKKr681rJ/3TUu1/NRsu7cRqUfy9gru0GVG8/abclaGGSHEM7gHkJJacFApom+tlT+GDXSi8bB4s3TUdfgDEKqPefCKj63R7YxX+1jV4QIA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130822; c=relaxed/simple;
	bh=gmRae4yZF0mXEA/sR1Wi2TDfcVj/DykINmRNErNregA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1kCZhbxGXEkjcyJ1y1HbWH6MZsJkuu/VDfxCXSc4Klqq4xdH9NRHX7Jkkw3nSJFKLSpGG7i4v+NuZqeBbTdaqEZ73bfm43edjSaZS/YjFLBGdG5iSofWH6wm4g9gke0jGxFP1+5fuYdoTgPVWzwZntONENvLvz2WDj0h4YL7ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bFHGBJtn; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bFHGBJtn"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5b8c2a6135eso1652042a12.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130819; x=1723735619; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KR7siNlYC4ymS5QtLxgHnwNoHyUWhkIPVBQGWioywrY=;
        b=bFHGBJtnb3MB7WFQyMrSe8w+Ps8FfIjE+HrPjl8aIB1r5+e1zxewSXtaIpy+kH4UrY
         MZD3B5+K2T03p8AgwKirQdPhD5tyYEGCSIhj0dYd77cSB8XfsuAN/bZOjB8XlH4HNOiv
         yiiTlpMfHfRozRHwjW784bKXvv7AG6OannccClBP0s0wPaGiP661VHPGevcudnuqPQFi
         QZC17sHUAsOVpEuFVSDf6zL+kKHIoS8I4hHOFUgRqwe2inA1a0gTGyCG9PjtDD2+SEHH
         H1C17f6C1/GgjcmHVktxpeWBVb4NSt4wDERk0PDzNzi9SnGQQY/GrZ0kOrqfWPy6esBX
         zc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130819; x=1723735619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KR7siNlYC4ymS5QtLxgHnwNoHyUWhkIPVBQGWioywrY=;
        b=rbyFYVRsMxxaI7ssE7ev0Aku64IQALLW4ILs3K/gtP6N85BvmVqkleivtAtQOByy3L
         cvKM3VG28FgA3x7qRvwTVupnV7xzaGxVHNvADBYHjHCxODSpeW6QnnQaK8Vr8sasIgyy
         uGZUUTNPhENBJDNvvigoyqE6muUhhNrWb0IVF9WvZ2jvp53sf3QXquItumo/c7zeLRsE
         YtwJKDe9gijhdhGXx/FEby6bvORuEgmTOl2fjey9+YuJkI63rZKyTWoWcYwjqSzdixd2
         QPbAllZEJ6Oi69x446BaV/saovwtHxCzYY2NNhnWGmaEL9d+GQenbLemaToWdtx4sF8D
         uT3g==
X-Gm-Message-State: AOJu0YyDUCctKK6CulVZOq1WtotH0fyVD0rdE6WXI+hAEB7p/KNlc7H7
	7qWjD7AgobAWRSEGtn2GY3JNyQqwZm6wrO+swbw3W69sOHJXCx4Z31+GwIAUrV4=
X-Google-Smtp-Source: AGHT+IF9Qjxsdd/XiouIid6BTsTld+p4cTGvd3/0+QEulYfRSfelHWGieTaLZyGtaQLMV4MfviF60g==
X-Received: by 2002:a05:6402:11cc:b0:5a1:5c0c:cbd6 with SMTP id 4fb4d7f45d1cf-5bbb3c18a79mr2168147a12.8.1723130818837;
        Thu, 08 Aug 2024 08:26:58 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2c1fc20sm725694a12.26.2024.08.08.08.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:58 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 25/41] libmultipath: rename __internal_config variable
Date: Thu,  8 Aug 2024 17:26:04 +0200
Message-ID: <20240808152620.93965-26-mwilck@suse.com>
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
 libmultipath/config.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index a59533b..34cbb43 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -72,13 +72,13 @@ void libmultipath_exit(void)
 	pthread_once(&_exit_once, _libmultipath_exit);
 }
 
-static struct config __internal_config;
+static struct config internal_config;
 struct config *libmp_get_multipath_config(void)
 {
-	if (!__internal_config.hwtable)
+	if (!internal_config.hwtable)
 		/* not initialized */
 		return NULL;
-	return &__internal_config;
+	return &internal_config;
 }
 
 struct config *get_multipath_config(void)
@@ -734,7 +734,7 @@ static void _uninit_config(struct config *conf)
 	int i;
 
 	if (!conf)
-		conf = &__internal_config;
+		conf = &internal_config;
 
 	if (conf->selector)
 		free(conf->selector);
@@ -791,14 +791,14 @@ static void _uninit_config(struct config *conf)
 
 void uninit_config(void)
 {
-	_uninit_config(&__internal_config);
+	_uninit_config(&internal_config);
 }
 
 void free_config(struct config *conf)
 {
 	if (!conf)
 		return;
-	else if (conf == &__internal_config) {
+	else if (conf == &internal_config) {
 		condlog(0, "ERROR: %s called for internal config. Use uninit_config() instead",
 			__func__);
 		return;
@@ -883,7 +883,7 @@ static int _init_config (const char *file, struct config *conf);
 
 int init_config(const char *file)
 {
-	return _init_config(file, &__internal_config);
+	return _init_config(file, &internal_config);
 }
 
 struct config *load_config(const char *file)
@@ -901,7 +901,7 @@ int _init_config (const char *file, struct config *conf)
 {
 
 	if (!conf)
-		conf = &__internal_config;
+		conf = &internal_config;
 
 	/*
 	 * Processing the config file will overwrite conf->verbosity if set
-- 
2.46.0


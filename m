Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F14518FC6F
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130811; cv=none; b=p8T5aw1dR5Wwv22tQ549CmjMPMfwmAMe9J1ePbEvAKCvZqxlyu1KMKB7gX3w/SbP/Cukw+Qxw59PZLzoL1mqCbbX+i8aN83gmc6UbpGChfjPciitF85+fX2naj0VAYBZqSgdioYC+fhy2q/1na+eFx2rxFh+FKGNAi/Nd6TBTuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130811; c=relaxed/simple;
	bh=B7wxa5VAA64K0YpQx20Vd4jGmopW5mxCZkbRI2VVeD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lapmo+yL+zlxJHsb9Z2LV9YKWcUQT43acFdpkTLLBvGXYnOufQOFNehkaDKdMVOqRS3R9QpvTSe9VxK81xdFWstbo+f8/AfDKIxxbBYUCw8p06HCye9fmw+ltGiZqBqMBPZCd0nJB5yvXWTqzIlF5bDc198xhngpyflyGT87Qeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ov415A4c; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ov415A4c"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5a79df5af51so3318995a12.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130807; x=1723735607; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CgJHEUA99Sx0/Yi7Y9dOa4xvmTc1yGwR6cPnqVMTx2s=;
        b=Ov415A4cIgzX7v93cfThXOmj9eTdr6WIod00cNY0Qn3Befm5ncHlp/Bhli9TnIJ3Fc
         9TSFZuPLpcHQ9mdMU5Zqm9FYYl+B3AwXFdsusoGGvupnz2/hpo/RdggI3j2sjfsmId9e
         r8UdKC9NHvGzxCapZWbJmhfczPborFPeuIteSZdn5wFri447Se5DDNw231YuRCd471pC
         xlSwg9iaxAZCspyvjN+ie8aaS94sSxvwT4E4NFY19esMBl5RGMgQ6Rnz0UuQ828LT0N0
         /3h87TvtB6bOZXwyFIflEFi0pmpp/v7r2wnjngycTea0rfoVCSxtc+fimK2qkWyoDzkW
         DIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130807; x=1723735607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CgJHEUA99Sx0/Yi7Y9dOa4xvmTc1yGwR6cPnqVMTx2s=;
        b=Rykku7mmXn2RQet6xQ19Q2/83+LPvSGbj9wKkPXy4yNqkJmR4qoGfLKwU2TAWi5BKo
         P3a9JwYAkF+p6h/ZZ47R1EJbj6e0FJuNp+bR0E//Rb9Un6dI532z1g6CHw3Gy0xET5cd
         8YPj3LJ1yPoRhRRdQujICjoCScy/mBRopgiFTpXtfz2wNfekkA/rrDr3DaDA15je/BmE
         biYDgMYIZh50Clzh8S9x/0nZC8ifm1Cr9JQiyd3FWYprCUSdc8tn2XNlAyuOlSjlWiIm
         P9Y0rFSm2KrdIpfXJCEe5Gp2kvNHsaGUk4wHjneijTNW+JDJqR4yyzNJ69RYUeH1RXlf
         N6hw==
X-Gm-Message-State: AOJu0YwrkLthzmxVXceFW1q0XF+yyCqsUuLaJjyeoT2Q5EU1CRCknJpD
	g0XqP3eRwuHD+4iCPPpLyWfhpf2CouWHZwfMBd5F2k+3i3teiKfwUs2mR5XBJIs=
X-Google-Smtp-Source: AGHT+IGzWVxDyag2G6LBueRxMsTJQA2a/SfzFaBZWD4Y3LSZXlVApC7nhLB+rDcjGLAUIVgAmlcHWQ==
X-Received: by 2002:a17:906:478d:b0:a7a:1c7b:dc17 with SMTP id a640c23a62f3a-a8092016e3emr176634666b.22.1723130807125;
        Thu, 08 Aug 2024 08:26:47 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9e83ec1sm752036666b.182.2024.08.08.08.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:46 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 13/41] libmpathutil: rename _install_keyword() to install_keyword__()
Date: Thu,  8 Aug 2024 17:25:52 +0200
Message-ID: <20240808152620.93965-14-mwilck@suse.com>
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

Also, remove some superfluous extern declarations in parser.h.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/libmpathutil.version |  2 +-
 libmpathutil/parser.c             |  2 +-
 libmpathutil/parser.h             | 28 ++++++++++++++--------------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index 2dcaa35..fb92f72 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -76,7 +76,7 @@ global:
 	get_strbuf_len;
 	get_strbuf_str;
 	get_word;
-	_install_keyword;
+	install_keyword__;
 	install_sublevel;
 	install_sublevel_end;
 	is_quote;
diff --git a/libmpathutil/parser.c b/libmpathutil/parser.c
index ab7d1aa..217a877 100644
--- a/libmpathutil/parser.c
+++ b/libmpathutil/parser.c
@@ -70,7 +70,7 @@ install_sublevel_end(void)
 }
 
 int
-_install_keyword(vector keywords, char *string,
+install_keyword__(vector keywords, char *string,
 		 handler_fn *handler,
 		 print_fn *print,
 		 int unique)
diff --git a/libmpathutil/parser.h b/libmpathutil/parser.h
index baa9c55..179aeca 100644
--- a/libmpathutil/parser.h
+++ b/libmpathutil/parser.h
@@ -63,22 +63,22 @@ struct keyword {
 	for (i = 0; i < (k)->sub->allocated && ((p) = (k)->sub->slot[i]); i++)
 
 /* Prototypes */
-extern int keyword_alloc(vector keywords, char *string, handler_fn *handler,
-			 print_fn *print, int unique);
+int keyword_alloc(vector keywords, char *string, handler_fn *handler,
+		  print_fn *print, int unique);
 #define install_keyword_root(str, h) keyword_alloc(keywords, str, h, NULL, 1)
-extern void install_sublevel(void);
-extern void install_sublevel_end(void);
+void install_sublevel(void);
+void install_sublevel_end(void);
 
-extern int _install_keyword(vector keywords, char *string, handler_fn *handler,
-			    print_fn *print, int unique);
-#define install_keyword(str, vec, pri) _install_keyword(keywords, str, vec, pri, 1)
-#define install_keyword_multi(str, vec, pri) _install_keyword(keywords, str, vec, pri, 0)
-extern void dump_keywords(vector keydump, int level);
-extern void free_keywords(vector keywords);
-extern vector alloc_strvec(char *string);
-extern void *set_value(vector strvec);
-extern int process_file(struct config *conf, const char *conf_file);
-extern struct keyword * find_keyword(vector keywords, vector v, char * name);
+int install_keyword__(vector keywords, char *string, handler_fn *handler,
+		      print_fn *print, int unique);
+#define install_keyword(str, vec, pri) install_keyword__(keywords, str, vec, pri, 1)
+#define install_keyword_multi(str, vec, pri) install_keyword__(keywords, str, vec, pri, 0)
+void dump_keywords(vector keydump, int level);
+void free_keywords(vector keywords);
+vector alloc_strvec(char *string);
+void *set_value(vector strvec);
+int process_file(struct config *conf, const char *conf_file);
+struct keyword * find_keyword(vector keywords, vector v, char * name);
 int snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword *kw,
 		    const void *data);
 bool is_quote(const char* token);
-- 
2.46.0


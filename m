Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E18633859E
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817145; cv=none; b=utNJllHtsE5STqEG7gydz+DV3DWeeN8XYkfSRKrhYWliSGUfVH6CJ0wCwfoh0sewNEOrpNfUUNkC6rUjcvf2lvZWW0g7TWaWCAxR4Ba2cUb3xvlibbaO/KklsQnsUoWrx8i340Q8z3AVAh6P+wyhPX2rj7J2bNXl1ogUGlFG+Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817145; c=relaxed/simple;
	bh=NesLQV9bR8hXgNnAHK59HoFYwWCmMo6gmi3tAOO+rfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltniwipgNjdPcqkqwjuUxkWUakrkRNWUf6JBK0TZ0dJJDj/8f+ARpZtkKepH6igU07TFhSuM+qQ39vcnXA3vBEwaT/hrnAfhyUZZ65Chsw02fdZe5AsIaPvR5GYvfkuasH8Y0uTfWrWVU/zHy0DxViN6HJCBPIQxdc3uNdFurOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gLw5iLhI; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gLw5iLhI"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64d30dc4ed7so4748532a12.0
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817139; x=1768421939; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iNw+z1T3C9iRpuCnvLBLi+biH1NMqLzbW7ORWi74Wtg=;
        b=gLw5iLhIALnrJME5ipVrKXJMBKqMvJuTl7LO8/RrYZV0f1TSTVXicSYe8CuH0cooJp
         /mvirPhoJQ0BgP9sA+3lKRyuCAU3TKU6hc30igPLfkeV03IDPYDEao6VqEK9VfWqur+z
         hLU+CH2AnY7mq2mdE+lyFeUlIocJY7FN4UqdPjL/i5GTjWxNl2WNQQWnVIwmVOGBXhry
         shGBzv3FT37ghZjI1jJQXKYC8Q3YreY1v3QnsKnm6Ww9n3VHQjvmhDeHCPBfJc4NC+Yb
         NviBitHOYbOLNnykfXXvX+wwYecQ6xofU68ew4DllVeMRvZih7JC1m1ga/MQJ0Yy5IJL
         nNrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817139; x=1768421939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iNw+z1T3C9iRpuCnvLBLi+biH1NMqLzbW7ORWi74Wtg=;
        b=FQyWhuoxfK8trc6khN9AuvKJzG54RMXDcamHw1zAwBx4+o6EyUAg3GCWs1mq81MqJq
         hHeauB533UBYK/ca4IfLhJ+q7R9qGaIX1Hb4oTrAHS5YXcy2T9v9DR+ARwd65i6ix3vH
         un1OeyCs5J6MofZEKdbW2KlUViQN11TGKrHnEy8bzKib9GLt/no5xW191V3GRO6hZtLC
         XaCPdZU5DUaWlet6UWHrQR8cmUR0srA6YgPsuynSltRh452JjdrPrdqaZJ9fT6LVy95U
         w4aR4eNwEudOChZWofe0egU41545fvcnZPhk/lMHs+C5OA5Ssyc6UppDL275M1Oguwug
         ZEuw==
X-Gm-Message-State: AOJu0YzlxuVnv0MjSdlABQW+/rjE/TGVE0+jyF+Pzuf0HzKJ8aVYom4v
	9qiwgJIqlIxg9PKDkjyR6RHvo/OaU3f9hRdGdOpGeMT5qAdE44SKYJdnfNoPdep2w/OWvtfharo
	2EPgO
X-Gm-Gg: AY/fxX7PKmPRF9fx7wXqVOz1ybLUePc2VLa3hlrhlhnTdye7etqsUluL1wW764WpwZl
	Q94QOm53H9W9lwGMMMVDBhXPrIJs4abo3i/EHYlG4p63mMBnKOaswcBYxbpP6lxe9irQlA7Gsln
	Wx/6GRZEYGZlBbbdLK8DA/IfM3NW+QtkbnG9RWsrmM1urGfOtc09dnd5Eia0mGNHccF4jdczdz7
	rRj7RrghBCj5zDYqJZg3hycM/TsKz4Q0Khwnt2GUcEwftqoCRyILzjXg+30cLVJbIYe4bsQFtnu
	p8t5SWl7lRassNhERxIz78k8fV6WAeByERci0hk2oCmGnR1mhFkqD9Fs0sCV08R12yqDseqmDJF
	OP55ZOgGJD9TxN1OZOKMUx5kS9xuSkhwwPHiGvFn4RyBNRESmSQM75d7gW7Kby+1jLC4UCl2WKn
	9J42dLpnvaJ2MbWmdoSxKJSI4lwz18tIPwLrKEZ0Zg77WOkqX38qqUQrdr2bEV0XuyAom8zjpl9
	g==
X-Google-Smtp-Source: AGHT+IH0MALfFpB0aRgflQ0FSrVXVS7/Fr80jggsdcsxnI0bTSIIyqeAT0N+7Q97+MUX0Gnu+ju3fA==
X-Received: by 2002:a17:907:3d0b:b0:b7a:2d:71af with SMTP id a640c23a62f3a-b8444f4ab6bmr346435966b.38.1767817139133;
        Wed, 07 Jan 2026 12:18:59 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6507bf6d5d4sm5516511a12.32.2026.01.07.12.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:58 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 18/26] multipath-tools: Fix ISO C23 errors with strchr()
Date: Wed,  7 Jan 2026 21:18:18 +0100
Message-ID: <20260107201826.323977-19-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ISO C23, memchr, strchr, strpbrk, strrchr and strstr become
const-preserving macros [1], meaning that the return value
inherits the const qualifier from the function argument.

This has turned up a few glitches in our code.

[1] https://gustedt.gitlabpages.inria.fr/c23-library/#memchr

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/parser.c | 2 +-
 libmpathutil/util.c   | 2 +-
 libmultipath/prkey.c  | 2 +-
 libmultipath/prkey.h  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmpathutil/parser.c b/libmpathutil/parser.c
index 131a5ed..bf7c411 100644
--- a/libmpathutil/parser.c
+++ b/libmpathutil/parser.c
@@ -144,7 +144,7 @@ snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword *kw,
 		const void *data)
 {
 	int r = 0;
-	char *f;
+	const char *f;
 	struct config *conf;
 	STRBUF_ON_STACK(sbuf);
 
diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 38e984f..37412c6 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -38,7 +38,7 @@ strchop(char *str)
  */
 const char *libmp_basename(const char *filename)
 {
-	char *p = strrchr(filename, '/');
+	const char *p = strrchr(filename, '/');
 	return p ? p + 1 : filename;
 }
 
diff --git a/libmultipath/prkey.c b/libmultipath/prkey.c
index 4fbde5a..ebed0d0 100644
--- a/libmultipath/prkey.c
+++ b/libmultipath/prkey.c
@@ -50,7 +50,7 @@ static int parse_prkey(const char *ptr, uint64_t *prkey)
 	return 0;
 }
 
-int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags)
+int parse_prkey_flags(char *ptr, uint64_t *prkey, uint8_t *flags)
 {
 	char *flagstr;
 
diff --git a/libmultipath/prkey.h b/libmultipath/prkey.h
index a89a617..806795e 100644
--- a/libmultipath/prkey.h
+++ b/libmultipath/prkey.h
@@ -15,7 +15,7 @@
 
 int print_reservation_key(struct strbuf *buff,
 			  struct be64 key, uint8_t flags, int source);
-int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags);
+int parse_prkey_flags(char *ptr, uint64_t *prkey, uint8_t *flags);
 int set_prkey(struct config *conf, struct multipath *mpp,
 	      uint64_t prkey, uint8_t sa_flags);
 int get_prkey(struct multipath *mpp, uint64_t *prkey, uint8_t *sa_flags);
-- 
2.52.0


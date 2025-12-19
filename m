Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FFD26ED25
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155300; cv=none; b=sPZg5D3V8SXdMquyD/g8j+aKbWEe6sf5xabn8mrAhFk6qb1L2qYovuMLjKF4Ye+JYCUfXqxpv/VpDgxbi+xIvN5whTxRWgSdYXQz4xxOico2OS+nfxO2DdYZng4pl67f0NhNLM0oBu7g2aCdlD/wgDE5jBV2128mVBMTZZKAtRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155300; c=relaxed/simple;
	bh=NesLQV9bR8hXgNnAHK59HoFYwWCmMo6gmi3tAOO+rfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haCYoff7fvp6O3Tbhrq+9UO0MfI6dn0DVYMy881u+9DZSUquWn5TdaY6Jp10iAd9r8vmFxNhVG5VG7nmdf+g18PIa+DYo6DlqEfuDOSdw0Qi5WVHzmYefwGV70k0ONZbX7SGUTtk8tHgMvz3iCEBgxtmiwXlXaN0upqmd6b/sFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b+wzkUl3; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b+wzkUl3"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64c893f3a94so383596a12.0
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155296; x=1766760096; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iNw+z1T3C9iRpuCnvLBLi+biH1NMqLzbW7ORWi74Wtg=;
        b=b+wzkUl3sN64VshAilpUqUDw1BTCxiPJoQCC7pgvlkBjwdEGIlWjGgQAJ/1czFUTb9
         18IQLT5/Nb5vnnF3pzwOkCWvgzZAgzBOiJFrTTDA0xXroqHL6fp/I19t1/kQAdGXQhEW
         ma5EJJLhexnCQVKSaSciiKu6YDk/CrH4KGQ8wfszY4d9Ei6WRxm9PWscNqYigKCW3DAH
         kUKREKrPSags3+LRh+5HVDEZ9pAsnqWb5LgHM51oA++imWoNgf/oyuNFlCzOgZ23zTAl
         QStfL0NUlZMshJMpWHGSFKWy4sThePHOIwvCFrx4CF0jruHq+x36JxOaKaskU85031gp
         jfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155296; x=1766760096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iNw+z1T3C9iRpuCnvLBLi+biH1NMqLzbW7ORWi74Wtg=;
        b=hROnWzkZn6KeX+PLbb0r2fvFyK6DR9S0CEDVYWHDmo9qBVVmvRZLCQ89qxyaRGYONI
         5WSYCAZNPkII0qbF8FH378AWDZn1pi/8ru2+RjRzKts8ax4NdFIyqPUa17ZJStQY8pYA
         DA8Gj8BLnzs7afqt4OiD0hqcNAVZgb/0kb7grjeVYXQhHLrHzbXp1yPWtyaXCgVc2RJN
         kgy2ETGrZacyh/oTS7UQLiYmz4/knbazetO0X11opPGKx8bjkCg0c1jNZq+CO00o5A/L
         sDos8GgGS6vM/j1VERwX0oWKwydvb7T3AtVldR8L6Cg3fNoLCnDGft46IHXB0rJIz3Ke
         PrpQ==
X-Gm-Message-State: AOJu0YyVFy1kciLKowvznccl6A1U6/NCIn3EH+ANOYJeh9XVg6KhmN/2
	EAITk1l/b3kXdeZXn7G8Tsk+pCxPar0jKT8967bJusdKUdkcVqsHcLBtnlMy1wLE6e4=
X-Gm-Gg: AY/fxX7OWeuq9gZqnTrWwNqlctst/OjchXHDmLjzP5/P4FwCOdN7nmJScZFXV0GpfJH
	S76P2jVQYsEW635pgbiQjIq3GKTNnZ8aB3w+D6GJRFl7iMl4Wnu3LrgsHEUfPIFSDesjpHo9pku
	UcqzVgXlYr5PRg9lgvTq7bpDaF9LINw/d8DKhr34MH2CMud8NQAbBrz2u22Ncr+pV84rmtLOR9D
	7qXPYNbJebiSdE9ncZDJQGnjxXNjw2ASh6Ke1irmojVSagKQK7zkIa/Qku53B0oWrtZtZwZ2ghu
	heLYjZBiH/CPCOKqjRhGLiAnYNzDMJP+/Y+DZvBqU+vGjYwPATrODNxuaAlCbJGj1B6mS+zo4U4
	QdIAZY+btbldYQwpSrv7Ur/59GpKax1gc0JEMidVTys3aYiY1EcAMJvDpGD3wOy6twUPJdFgNgo
	XQutE+BtIOSn2KGY6hFJfBSCusAyy+BbXEbUiRaPWNhhobmQIFA76ve28k0OIUn7mh4D8v1Cpls
	A==
X-Google-Smtp-Source: AGHT+IEW1qPSjz+QYyxmlc+d1HPXuFxkh0xZL1CtcfX2RITuMkaXM++F+Y4ZcWPP9sAK+yICkm+3Lg==
X-Received: by 2002:a17:907:2d23:b0:b46:57fd:8443 with SMTP id a640c23a62f3a-b8035794ac9mr377594166b.24.1766155296410;
        Fri, 19 Dec 2025 06:41:36 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037a5bdf3sm252484066b.12.2025.12.19.06.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:36 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 18/26] multipath-tools: Fix ISO C23 errors with strchr()
Date: Fri, 19 Dec 2025 15:41:00 +0100
Message-ID: <20251219144108.237928-19-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
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


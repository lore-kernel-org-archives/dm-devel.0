Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE8918F2EE
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130801; cv=none; b=NOCeU5yNuQgP3xlDuXlJJVkbL3Hr2S36bsIhEtRkJuvWBweSopeQBKo2SV7QYSO7YGwEQKHwKwVD22Nwj2QO+dYOPJpthG0eoUq45nZFD5OTIJWcR117e1+IPpOBOc74XyihuZNl6k5+WdZPBQTYbDkqRqTpRHpr7U/HWBPxVVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130801; c=relaxed/simple;
	bh=h5HxFy5tNXsY6O2j8C3p+C/c9/uMC8wOQGCv8ZItPH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HS5Ip2E7GsIwUAZOhUvd3Q7pKOWISnBxLFDknPuFMvMDcC1M3g9+9T2jfjwJQHVdem6RONAblQ9tXQzX9Owqh7CLKSvhk2ziSf0QwoMH5mRiuLt1teVE8L37xGnifgHC93mfGk+QGAKPUtrmXZI0mbvsKTqZYqtNDBUUN3R7MmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MLxh41NM; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MLxh41NM"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-a7a8e73b29cso114780666b.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130797; x=1723735597; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+g2fgHo68V+z+6A3o8FNX+wO8CeXqUdvIDXO4qmZJnc=;
        b=MLxh41NMD7UPHAlLXJHz344B+8YZsb9QPDvR9m9AVgceAtWy1abJ1XQI26c9NSSKBN
         QlXKqd7UP7hgHkfvlUL7rJx0Lymp0zb6mJT6p0LLA+nFIeWFRMZak463A2DP+lsw9eUy
         KLGJzkmTa/QunxzbbQn2EErT01CRlm+fporK+1jH+kPI05lklJjyRdOUrIH4ODZOIwOO
         7L5KhG6gMMdOpg+qwPJnpgQni3wsEwgdgD9F3LJ9DjiXDuClgz+cwW2xXTxzxZjgOGEh
         lZWIFy9I1zqvPUjs4NwtG95PX7kLHxwuTzmIinb0m2UexZqeswQ4WCgylGiGf6s7oZF2
         d2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130797; x=1723735597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+g2fgHo68V+z+6A3o8FNX+wO8CeXqUdvIDXO4qmZJnc=;
        b=kbhQmUxbU04INN94TnNWMkNlbHBZBxvC1x4mb3X2TeJBzjVRmEd1dNCcW7ttI136Ar
         ds3dGVRp9/9w0DmYPbXkR5y1NdhWVvH+raGTc7q5OsOPnwE5Hp7oPBr96iUWnGpD38RW
         4GAZzCTs48/XT1UW8T3CLut1/q5hAOOgHXgZVcZ7BOJY9jp20EMY4019JqvfNTv5V7/6
         eyCgTa6vYjrkJ+QkTr1sHcGXX0LYzyg0k7WsG7DT6wr/HZxPVZM1BQbqcstBkxQV7u2a
         sLYwizZlGyp+jZHQcG112LBVLPVK3ppNrM9KLI414bF9gCSsfEopuBAnTkju/brku+Xp
         2JYw==
X-Gm-Message-State: AOJu0YxhUE4RBLF6HJ4c4VXt2TDe7hbW152CTje8WLaMExhxgNRLyIi/
	5CNwFVBwkXpmRS4mlqyXH/8xVRybzVKyn+SmdRp0nuxF5LvJY04QXTw46pdpFStwC7vropPDrCK
	wcaoFbA==
X-Google-Smtp-Source: AGHT+IFmKjxsNk1qT49y69dIWpKHrHxPgdBGzKjg5XHSDVGy/rhuaystNpdSVi52F5ktOI+j5XTexA==
X-Received: by 2002:a17:907:a08a:b0:a7a:387c:23f8 with SMTP id a640c23a62f3a-a8090c3256dmr176461366b.3.1723130796539;
        Thu, 08 Aug 2024 08:26:36 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9d89a9fsm746899266b.156.2024.08.08.08.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:36 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 03/41] libmpathutil: rename strlcat and strlcpy
Date: Thu,  8 Aug 2024 17:25:42 +0200
Message-ID: <20240808152620.93965-4-mwilck@suse.com>
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

User programs are forbidden to use names of functions provided
by the standard library [1]. Since glibc 2.38, strlcpy() and strlcat()
are part of the system library. Rename our own functions to libmp_strlcpy()
and libmp_strlcat(), respectively, and only use the short names if the C
library doesn't have them.

It turns out that msul libc has always had strlcat() and strlcpy(), so use the
system library function with musl, too.

[1] https://www.gnu.org/software/libc/manual/html_node/Reserved-Names.html
---
 libmpathutil/util.c |  4 ++--
 libmpathutil/util.h | 15 ++++++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 9c422f1..136aa59 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -121,7 +121,7 @@ get_word (const char *sentence, char **word)
 	return skip + len;
 }
 
-size_t strlcpy(char * restrict dst, const char * restrict src, size_t size)
+size_t libmp_strlcpy(char * restrict dst, const char * restrict src, size_t size)
 {
 	size_t bytes = 0;
 	char ch;
@@ -138,7 +138,7 @@ size_t strlcpy(char * restrict dst, const char * restrict src, size_t size)
 	return bytes;
 }
 
-size_t strlcat(char * restrict dst, const char * restrict src, size_t size)
+size_t libmp_strlcat(char * restrict dst, const char * restrict src, size_t size)
 {
 	size_t bytes = 0;
 	char ch;
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index c19f749..7bad855 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -12,6 +12,10 @@
 #include <stdio.h>
 #include <libudev.h>
 
+#ifndef __GLIBC_PREREQ
+#define __GLIBC_PREREQ(x, y) 0
+#endif
+
 size_t strchop(char *);
 
 const char *libmp_basename(const char *filename);
@@ -22,8 +26,12 @@ int basenamecpy (const char *src, char *dst, size_t size);
 int filepresent (const char *run);
 char *get_next_string(char **temp, const char *split_char);
 int get_word (const char * sentence, char ** word);
-size_t strlcpy(char * restrict dst, const char * restrict src, size_t size);
-size_t strlcat(char * restrict dst, const char * restrict src, size_t size);
+size_t libmp_strlcpy(char * restrict dst, const char * restrict src, size_t size);
+size_t libmp_strlcat(char * restrict dst, const char * restrict src, size_t size);
+#if defined(__GLIBC__) && ! (__GLIBC_PREREQ(2, 38))
+#define strlcpy(dst, src, size) libmp_strlcpy(dst, src, size)
+#define strlcat(dst, src, size) libmp_strlcat(dst, src, size)
+#endif
 dev_t parse_devt(const char *dev_t);
 char *convert_dev(char *dev, int is_path_device);
 void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
@@ -62,9 +70,6 @@ struct scandir_result {
 };
 void free_scandir_result(struct scandir_result *);
 
-#ifndef __GLIBC_PREREQ
-#define __GLIBC_PREREQ(x, y) 0
-#endif
 /*
  * ffsll() is also available on glibc < 2.27 if _GNU_SOURCE is defined.
  * But relying on that would require that every program using this header file
-- 
2.46.0


Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D238930F938
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006502; cv=none; b=JMHreMJevZc2O9qmYI+AEo5Uecf6GIvRm+B3B5Cc0OnWaex0MyU56hEzImx8eVUQA1s66wKGeHKSeIl2IerIAjxZ/bNV8Z/kZnFmBEpRlNIJDNByX1fXFLZ45rToyENDg3NnTCIwug0p4TZALkKszXToqxaQMqk8NJ3K7b/wKwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006502; c=relaxed/simple;
	bh=A6fYENpB0GNWgxtj2reU7P58QSUok9G1zzDdbmTB/XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToWdi6VfqwXVjyLLqMWPiO+cXHAx9rTYPXDt9pYvaLk7D9ofloPqcNxNTbZ/yzhiODyAfOsQcEyYliXh6q8MCjBgl0K2PhsNi0p6G6qXURJrrc16wrVNQ8dfAsSrYCQkj8T19fOslsDTWVPcPjjkf914LR5up4kBbANbRJSEQBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MbG9Mfd2; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MbG9Mfd2"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b735487129fso1087283466b.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006499; x=1766611299; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4eSruQ/eC2xGOXhXwvnymiY6vHUTtWedrswsj9hoiE=;
        b=MbG9Mfd2hq01/OdTJ5PWXmmLPJ1uUqsrpPl9tOIdVPzwEEslxJbJlPD55AM+qH4heT
         Qm167R3nN0GCE9VX6P9YVlXvMA63yFlRCeJN9q0dnsStiRxt6aXbEv10A/FtVORFJMwx
         emQlAjHkoIQfdK+8EV78XETHvQRS+Z/b7UNYPtOucWsyWfVGlQLH06MrnerxLW8J3Aud
         azE5SH2I04s/zB4Nyavb9xLvrOlPh/15Xh6M/Juhkgr4z7PNE+LRj36ZyPN3NvUQNOea
         6HTtbFaraPlqrF2xbE9IHu80gAqRvV+oaqjb0wb/iQgqnD+XINzm0wJ/tTrtImLQK6BF
         8WOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006499; x=1766611299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W4eSruQ/eC2xGOXhXwvnymiY6vHUTtWedrswsj9hoiE=;
        b=GEmQD3Z7Bq4infCIKKggS4YPy45oKHe3O2k4SOxwhO3pndgdvfCCqQhetLN4cJYg29
         q45Dq9wku5kddqWOfdk2ez4eXSsF1BKzIAfSLC7d2feWQZ0g6gW5vdtIDPacwh9kDIad
         QzodfQ33ZFfZNTg/ZU6LNJocI/JHZUvV3fvOjAHCz/AA3FaqoP33icuALabpmVw4qUm6
         GOxELthC15jiBLFH0m9D+h5zu4WFwTHGHwRkgLZzVDfyc9XqESutkLhtXUvprn2Vs3QT
         6zDk9u8OlClbnAry6VmNhyDgoiugHP8idogHexNTsNX25p0ULHR/NvYu7B24EhiYsofY
         tD1Q==
X-Gm-Message-State: AOJu0Yyn9PyzYHW9Py/pi7+8XJUVoiucVYOfQR0Pvc3kXUnvOe6igBcs
	GFWLUF+e8UV4+AdJkZc8FtbK4op3a9NVvpqJVsDTnoi9S6Xcoq3JrK5nqgYSeQ0X6a6vqze72Gt
	fQhsy
X-Gm-Gg: AY/fxX4BQTHfJYuLNyYVTWGJQPhLpw7y81X899Er2nMWhbjloOgRU0F/U0/ZP+ITRN3
	5Ee+WNVXKCgiAxo4zhkXS8Fv15qrqXjzDYZDFTt8mxUg13geNIwIuRMa+B0IccR1iNSbxh3csJ3
	C+4SHcu961f6BI6VLIhCwuKfTulxTY7tsjYV5EezR6sE7+2pTEbu5Dry8n9C5ZZDp0sqr0P4/Cz
	PCzPO89S8AJw2sSJF580r1QYLUHZD5W23Hn+DQSXOW80oXOv3kNR5dzdarf9fubXKQNfC/7Zd6A
	lKVRAWcZvzkLh0MUKKb7lQmFpyuXRtpVJ8fctexwOCyCDMUQCio3Dn4f9fWi+iaI5aB6kcmZ1SC
	L+yIsHaqB6VHr1AtgB6RZB8XwwPEnwYv8U9JPVWvakdT91oaQjR77tDEEYynjsTgBT3g4lJF6Hb
	tqH3whIeLyARGCm/lQ5Vc0CiXcb3fG72Xl0YsC10s8rC6Nsk0BUobkjpeWsu6E9GNTiUw/qG0CC
	Q==
X-Google-Smtp-Source: AGHT+IHj0GPgPN2fAoUeD9Twh9Jwxy28sTT3hsce5qHGaGL3uRZf+chzTtN0ZgGAIYHhfD/a20gjfQ==
X-Received: by 2002:a17:906:4fc8:b0:b7a:5bfd:7fe4 with SMTP id a640c23a62f3a-b7d236323admr2091771566b.18.1766006498995;
        Wed, 17 Dec 2025 13:21:38 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b80234a2786sm27258866b.49.2025.12.17.13.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:38 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 16/21] kpartx: fix some memory leaks
Date: Wed, 17 Dec 2025 22:21:08 +0100
Message-ID: <20251217212113.234959-17-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These leaks were reported by LeakSanitizer.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index a1495e5..f5bf396 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -227,6 +227,11 @@ xmalloc (size_t size) {
 	return t;
 }
 
+static void cleanup_charp(char **p)
+{
+	free(*p);
+}
+
 int
 main(int argc, char **argv){
 	int i, j, m, n, op, off, arg, c, d, ro=0;
@@ -237,10 +242,10 @@ main(int argc, char **argv){
 	char *type, *diskdevice, *device, *progname;
 	int verbose = 0;
 	char partname[PARTNAME_SIZE], params[PARTNAME_SIZE + 16];
-	char * loopdev = NULL;
-	char * delim = NULL;
-	char *uuid = NULL;
-	char *mapname = NULL;
+	char * loopdev __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *delim __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *uuid __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *mapname __attribute__((cleanup(cleanup_charp))) = NULL;
 	int hotplug = 0;
 	int loopcreated = 0;
 	struct stat buf;
@@ -292,7 +297,9 @@ main(int argc, char **argv){
 			verbose = 1;
 			break;
 		case 'p':
-			delim = optarg;
+			delim = strdup(optarg);
+			if (!delim)
+				exit(1);
 			break;
 		case 'l':
 			what = LIST;
@@ -674,7 +681,6 @@ main(int argc, char **argv){
 		if (verbose)
 			fprintf(stderr, "loop deleted : %s\n", device);
 	}
-
 end:
 	dm_lib_exit();
 
-- 
2.52.0


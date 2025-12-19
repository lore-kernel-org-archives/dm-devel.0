Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B124326ED25
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155303; cv=none; b=qcc9r+SFGMUsS3W65NvJEH0u+P5euunetI59mV7yPZHEnkVNo8grZauzOx7/bx3cJgDTHLmdFDdDAo9SGae/B+gtzf8/AG8lB8zJDFOycG3MMVdA9a67iEweIiY4vKFLvy8HLB0m3C2UUghCqkP06uijz+nJF8s1BY5ja1aGMHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155303; c=relaxed/simple;
	bh=hWj4k+Eb6o10yIVA79bRryNDUQDy/D24TlaSFjlOoTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOsWSz+3NslmaL699z6TFMpkt8U5zTkLvB9BBhdQgUZPEgzF0dsUD8O5+jgFiVYElUNc/CmdY8q6JQ5uxjp98hwaQyJb8yZzSE9WqRjUp5vJdbYlJToJQhdC9OMZcJNqQQ3SjZjWD2abMW8p08FYzZrIgFmxr0b940IybJu4hkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N7qdgKbo; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N7qdgKbo"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8010b8f078so131456766b.0
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155300; x=1766760100; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIPn8JplPpaVUxxk26ghN8vPEcnBnxv1u53Sqc4WOew=;
        b=N7qdgKbosSPDHE2JgaCGha6PHFrL8S3j/MA7LMwLPZ3k00Mf8Zo5SCV0vK4gXHEjoe
         q1TFgH6IC9W6qcWK8Ucku+BRjTdknbF7uNwlbptWudGkYw11nHrVeZCeaRRs4/YCF0L5
         b9LxpQ/jMT2Nst357TgPqUR1UlFjoYB1qMgqyt6rvK4RczcTkWK4/tuGRrn34h+AFU+9
         Ls9n/QE5+cn3kYA/iWx7Jvu+Q2T4xIIpVSsSr657blaLqc814TLwunenDm8KGevSf8cq
         EQ9f5RiSNWHw5BG+LS1tS1VAfwGYKeGifK3W1eMP9/lalGG2hNMyr1cBCvK+hUB/AXhy
         vAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155300; x=1766760100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dIPn8JplPpaVUxxk26ghN8vPEcnBnxv1u53Sqc4WOew=;
        b=Ot8UCTmSJp8CLY7mQM4MZE6Zb5n44dLSbfquLySHcDF0sW+Lgcg7MkFRwZLpftAXdX
         EVSxlgwUjWdIjTMAbGygILpLTJ47OiuBI4giEOekUwh8UlbCpiEuEyVmruqrDt2CKkwG
         3fWKSNa7kroz3X1dR7OOQA+tlV0rqvO3u0WO3ETeJLj04r+aY6/GFn8NpPzTnCp0oMjy
         UDguUHfkiVUvnWG/YZbXI+IRHjxrMjrqoe6XZMo17Vm/GS41nCycDCFSgNpeIJln5mph
         XuYcKFLMJrzrNR2LUPGohsGaR6HNumMmMjh84ABrgp9fyq812G7h956ESCVGp6Hz5xQm
         UYTQ==
X-Gm-Message-State: AOJu0YwQZSKTzrteMI5BlEPrKqsGG387nR37Nuv8HnQUNXSpbQYAkt71
	3KlPeVE3XjFuaW9LquSMXIQ6RC+XpGDCFz8T+PqWjbjA1IuDVEkFgEq/aqHdiv9LfLaUsjV0ASH
	/IRtg
X-Gm-Gg: AY/fxX7ju40vbAAiCioTaHJx6yyUuSAExN1vAW3LvTa6KgiaPjDlwNDQgTMbDdhEz+B
	MnCU9F8ZLfKQfMQuAjmElwcoTNI0geTL1iuglqct8S7VwIYznfozNP2+e5h/gFfFLYC19vTaof+
	Ny1/YWSwMwFUc+gpCesIU/9RlmJk04RcZdVWiY/ZrffPLUkr7sh40APl/HmjvkjSCtCrjE6uTCp
	PT0buTajKOymZYWM7J9y1v9vhd30oI2r+kj5ytz1/YHoPvSb0qfzc2hfNGKgeam3SyESd9xPuCY
	GIsUanjSaUz4EZqD1V8fG2huqjXID7Qxc7Cq3uQIFBq+2wSaVa2b5cwXU9BMWy4d/nBZm5X/IJW
	MkBhHrgiNUjaWmbc/8twZxx6sf1RSHBd3mnFtbeBIn80ZOp4XUymsryvEggc4iJWyeclReAvYW/
	eNvcM4HDp56JS6zTnISL6jZlxiDqDfkU7vcemPES0YojLacRspUDAeBtrK/16CC6zoBe6v+1nv+
	w==
X-Google-Smtp-Source: AGHT+IHRFPe7iYbR4V9kVkB6siXtrNzhINyJMa8duoOMrpqSnGqT2myAmgWPGitJB3ZsiEDqnD3IzA==
X-Received: by 2002:a17:907:7f05:b0:b7c:fc5c:7ca5 with SMTP id a640c23a62f3a-b80371d32a0mr308923566b.49.1766155299789;
        Fri, 19 Dec 2025 06:41:39 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b80464e01d9sm55689466b.42.2025.12.19.06.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:39 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 21/26] kpartx: fix some memory leaks
Date: Fri, 19 Dec 2025 15:41:03 +0100
Message-ID: <20251219144108.237928-22-mwilck@suse.com>
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

These leaks were reported by LeakSanitizer.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index a1495e5..7ec89b4 100644
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
+	char *loopdev __attribute__((cleanup(cleanup_charp))) = NULL;
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


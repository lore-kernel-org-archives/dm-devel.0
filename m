Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5D83385A5
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817147; cv=none; b=uX60uk4HAR4JBAhKSo7Ffxv+1A3vgNA4ORoPI/1u4O/XR5me/kvx89CvaG0N44iC6FV3JtUzLW0zdZi5A8zXHUqNpZsno5yGywzDqr794eJIqRnPGAdn/GcGlyVdpM2vTvPV56f27gCNmTrV3vwwHkdPg/eiNqpawrFEu4ZnJPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817147; c=relaxed/simple;
	bh=hWj4k+Eb6o10yIVA79bRryNDUQDy/D24TlaSFjlOoTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jr2xvY2DgLuYoD3P/DgyQ9wKCw/CYiMxjsgsdaAU89KulfHo5VK/yPrmSydRYgA5Pi87Mq4u8DI6x0VzPl2nsoy1Vdoykr9XITkQOjpQgZjMMQz8SayblFu7gfKPoQnUa+823AzWt7wNoQnoDAnqHK10wXMiRmFwspsSJaE/bN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FrZlVNB0; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FrZlVNB0"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b79ea617f55so512009666b.3
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817142; x=1768421942; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIPn8JplPpaVUxxk26ghN8vPEcnBnxv1u53Sqc4WOew=;
        b=FrZlVNB0nLIkW5ZXfEEFToaEcA527lkZ7uDgxVZQvj8epgXXjv0kN6y8JCRWx18MhY
         yqFPRLxQv3I+3ZrpSgWSBdyUcCx3sRj4jtDG6MvylGSQQvCNvdyryAOqlQ3LHZDkp7H9
         ym3EsoCTh+Va10sgSGirqkj4dM0h0o48Mx59gWILdlbfuIh32IsCsK+MpBRr3/sEHsfI
         ebHvPm2N/OTEpsW7kba1O0EoUzG0pV/pM1tooZARYv6Sth0sDm6ePtGEAezmo7KD//Hp
         BFZFXJSB+r49EFRwAra64bwGDuU5SE/xuIIb4aDeC7U2WfHLYYNaRonHsKke9NiW8fHq
         TGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817142; x=1768421942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dIPn8JplPpaVUxxk26ghN8vPEcnBnxv1u53Sqc4WOew=;
        b=ne5/W2IoJ7BspL2djEbjlN8NTDqHkFcHpYKnjo7XTPpHRAD4ucMtjogfHBKPJdd6Rn
         3O3nv8vzMLa1gXd8VGIN5Eyt7VSfr23Nc/gcT/2Ss3ePdyKOyS1/0O2mElSLzPDICCiY
         iiRZ3gbjJh+/D7XOXIaa2I8q8IuwGiBIpAIUMeu4Q0Jywpx44QEACsM1S+grXk9DIgNc
         AvKjeqWhmjdfzM8bmAY9ZGTvzYyjjuyGZRQa2Hr1rawLMWXofdXEsRNDFcNWIrhHLxoV
         bN9NbqiecW+NFYx6omHdnsmYk/TkH0Uyy9M+GN5AUB3HRjwUSmjbn/ZzolSO70pXNRXm
         lwRQ==
X-Gm-Message-State: AOJu0YyJIblRbf0x4eM9jRVOzEOTqiVZrpuUqacQT3TSPohTWYd3NYbB
	WNMYmXIUgl+mU+xEg9T4tc5Hq6iEWca0Tm95PsxJJvMc8cI8N1qSn0LtQnWnZ4QPAco=
X-Gm-Gg: AY/fxX6Bm43ZxNHDZThSRWMYb4eKI4GDqGiodWBWsm5AePi6xbPA+RfQhH9EpV808ai
	j4bH6D13HaWElFd6ywaupL6ajHA6lOQfAWifNScRPAqLvt/IGWAITnOEW0ZltOUOluXBrqTtxSz
	MN9qp7X0SyL0CbqAV7txNFYS7rFB2MSHI/uXHGRXEq2b2I+RfQVyUQl6PDAvZjqkVGZFPp6beon
	C1XvkWiLaRGZO3ADUYxPQVaJoDgqjprihqJw8US/lzU5NhOqRxvzOVz7g/rFxGVP6hbARHtIiH9
	lhyA3+BCV7d7ThDX9/Tk5uSFL1K4uc4qjKGnVIgj4iWr5ray2fnkBua6Ki5wQgAXsO2oYhDKsnd
	SEZiatjhQLQwihr7LLW8+HsD3CA8byl/FFwceC4EYXen4+5Danw41Kjb0OYtXvdi2Yh9s1+MDwy
	tIFrkjz/lDrEMn81q9X8v7SuU51SkZ9bL+EuOFS6Xrmvf9+Dfpnkg8wSwdlTraIbqan6AqV7WZK
	g==
X-Google-Smtp-Source: AGHT+IEM7uTSi7oZUs85/YZOqcYV12TlL4ZDgJiG4e0fSVAO/c5I2gRYO9cKHTv9y5X6GzaZXwyNhA==
X-Received: by 2002:a17:907:9615:b0:b73:7f1c:b8d8 with SMTP id a640c23a62f3a-b8444898aaemr383136966b.0.1767817142316;
        Wed, 07 Jan 2026 12:19:02 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6507b8c4484sm5715820a12.7.2026.01.07.12.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:19:02 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 21/26] kpartx: fix some memory leaks
Date: Wed,  7 Jan 2026 21:18:21 +0100
Message-ID: <20260107201826.323977-22-mwilck@suse.com>
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


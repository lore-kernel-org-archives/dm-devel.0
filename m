Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE33728E5E2
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 19:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644786; cv=none; b=S8q2fUTDurQHlNyUbZrjve+ByqC9Nt2BL/YFFWFi3Y0+xaXZ1Iha6sALdxcy3j7a9nDtWb5bTLxMTY0+mU9k12Gw2lOpsdVxErdMXiAc4aFL/2UIV4xLBULdM47lN7+EJwX/i0UKjvgCtVkiSbGTT8/Uscyqwen5gVAfaQ02WRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644786; c=relaxed/simple;
	bh=5EpQnfC5Pz6jXmfuJ99T6SD3NdltNqSMHF/Z9noWxTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsuiX1lUOedyGE9Sfoj41R1dbMzsJJQ1itMXkT89c4ZvfO/cPTgrmzB2l3lBily3Fu7af/ZFpSwDKLGFFLKpZHm//d6ay5XvS0Xqdo9QUKbraW/9/EsG8GPOkRkjVs8t7lmha/5ZjTePS6IdNO6CpgDHJKG1yTix+gePPTfWUKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NvyBG/0u; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NvyBG/0u"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43cf58eea0fso1214435e9.0
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 12:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746644783; x=1747249583; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFyduVSXquMCI6S/GQpdqtmZnjRenn0sldoQ0FWRTpo=;
        b=NvyBG/0uAg/NnmTm+21JZ7u0HgZ2Ep4m6rnNdWRYsGTRpn/lfYX9bpteFXoVuil6Mp
         P/ES1V5a64hUn4w233O5e5UlmwmB/IFQ2//sEzKl4Q+rl0oqJigS0JWOdwNDEtGVIopj
         GzMrKDx9VMgoo2q3kGq9V5N/AVEgPD3qKJKCBoWd5JqJrp113ytxmlRfJUjG03xUFAAG
         qwA8Hv1agVGm5gMrvKUmOrxuSjClangHXpV1DNfc1h165U8E15VCT4K+mpROzPq4oO42
         oUov0ZMCY16ZyrEmElICPbNj3NYBasgdgOvOIx08GaeE5nGrDzdX7ClNCuNGwuYiHcUm
         AIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746644783; x=1747249583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFyduVSXquMCI6S/GQpdqtmZnjRenn0sldoQ0FWRTpo=;
        b=uZ9Qtt1BKPC38gG7ksZvwy/mZ7AnihteR2QZpPh9oNK8PJ/xl6zeqez9w7GsJX0c+G
         ZAA1XQmMrwKTPE1YM+hPQj8sgVlY3S1NjBDSQKlb6WiNvGsEvq5+xKzjlXLDPcNCFWe4
         dJUzKMJ3UzgiGkKwRiYrwg7fLVT8eLQyd8jB3bAmWPQTq5SOuJ46jFhB6vILce8ZUgZY
         9jk/LbAe7KdPLYVxxOfCWVzbpxeF6TzIg6v1s4DC6VmvJtd3x1uIPU7nQU68TuBETk4r
         VrovOxiRk72esDkgMNRP/Reqv19IDYpk2UCx2ZTgDADkgDoA3300kf2TST0kUOSa0f1J
         fCBw==
X-Forwarded-Encrypted: i=1; AJvYcCVDcswpJ2Fp153Nw0c+qQ3wRPIXToN8Y1kk20KcKarFb+krXnPwZPhtNDSNO+uxPl5BmLBKrTWUdw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyE4PXNvFi4ZWjAsAj46metKfpfjsAgg4vCuN4Rz7hvRKwTt5Cx
	w0Sg2BWbWHCAhTuN1FzQjlmjjcfk8Ok8vApCP0kZrInIaiVc04Q7uJ1Fj04AXRQ=
X-Gm-Gg: ASbGncswX8kgFGfumB6pPyW5KllOtmbYKrHnUeQxEWtyu8+G0a2Qk7XzO5GmOfgmeER
	yqwYKiZSHQ7MA7icKfDFSTVDMU8CsqyPWpqNYFPUouu7/xhfx8KGDdTBfz2gNkgs1AtgAM/fzkC
	M41aAXV8eE6ambB8BG46D62W63yZv8nqew6IadAXggiNuKf7oSjOQWzguqqhi7QmvHl0rQxHCWA
	Er/nxyK9x7V85d/hrSxVcbXRNFZeFv30xYu44jzPvEotzqlrK45pElSiHf1yRl7p5QB88vediDz
	ZFot6uqoU60n3Dw3y/CY+phI3VqGZ/FY76+nvqkYVW52Xc1xoixrFFpPtCviKWqmWmVUokmfQVk
	EcT/nFE4Ol1KeSBwuczY/rH1gd6cr
X-Google-Smtp-Source: AGHT+IGJNNi7davpA/afBCv2X7PJWOitt5jsWkkBrFf76lmkog0cdDAP+uoJX1oUcCjIeBBDTW22zQ==
X-Received: by 2002:a05:600c:528b:b0:43c:e9d0:9ee5 with SMTP id 5b1f17b1804b1-441d44c92f6mr42629895e9.18.1746644782812;
        Wed, 07 May 2025 12:06:22 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a0b990d669sm475349f8f.68.2025.05.07.12.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 12:06:22 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 6/8] libmultipath: prioritizers/iet: fix possible NULL dereference
Date: Wed,  7 May 2025 21:05:50 +0200
Message-ID: <20250507190552.209637-7-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507190552.209637-1-mwilck@suse.com>
References: <20250507190552.209637-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Found by Fedora's static analysis [1].

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html#def68

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prioritizers/iet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index f3bf64c..f5fdd42 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -101,6 +101,8 @@ int iet_prio(const char *dev, char * args)
 	char buffer[BUFFERSIZE];
 	char fullpath[BUFFERSIZE] = "/dev/disk/by-path/";
 	dir_p = opendir(fullpath);
+	if (!dir_p)
+		goto out;
 
 	// loop to find device in /dev/disk/by-path
 	while( NULL != (dir_entry_p = readdir(dir_p))) {
@@ -135,6 +137,7 @@ int iet_prio(const char *dev, char * args)
 	}
 	// nothing found, low prio
 	closedir(dir_p);
+out:
 	return 10;
 }
 
-- 
2.49.0


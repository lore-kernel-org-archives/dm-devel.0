Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EFE19047A
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130826; cv=none; b=cYRPlJS0QTmaMG+1avS6+7jvI2PvdPIj+2ZSJjza6OzLJEkSt6RKnuxLHQQCW+ChScRRVxNmHffPvs26TOMbKpH/J4jiGVFNGLJYyyhJEq6Vh3qkVTJqCUiJVKkznxMfhHIql0gh+tHFIbLFRlDBCObsnKLKPUjO8vhNBAWSCNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130826; c=relaxed/simple;
	bh=U6/9sLjbgduDGLMiK+4pq97jFMOBkVzT/b6K+Ka2txk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+jgG+7imv6C9ti4wOpUu0duvxpegN4GlLNcqB07aGy7N+tfYxKYjNc/CkQitfOsdpuWrFV3jCPpKXoLUAgCc+xAr983r15KwvpwAD9z+9hOmj6IFyAVoszbezHcKAfLCDzLYq6vGTvSfFUYKSPMuHFIj/D8OWQM9pCjib+5s/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fcKfamPE; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fcKfamPE"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a7ab76558a9so166416966b.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130822; x=1723735622; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Si9FSarNrsIrF9LJFUeb3R9ppHt6Z4HgOoqYsocg2gE=;
        b=fcKfamPEYRDyFiF8W2jXH0+3HWHvhhTry1xs5+IUUSyNdCTU4nesInVmVJhd5FujZV
         iSh5fFXGpt3b51/ozy7RpzJrJYyDYnD4Kpf7dNyV5xi00cxGQOwYTK/6uQwWetMwfjjg
         sOMfCCMGp1gftYACYWKhWoEcnlv3tim9y5kf41VadfFSeeujpa2hFPtiAtY1HJz2RFct
         LqVq9SXj62CwcP/pu+R9pXUq7y1Q0iGiwbYWUp0NG4D71Ssbr2tQ7kdhqnk+8ahKpSbk
         EM5+eNOLJzeVxvlicDpC2XfIxnUDTNwhi3OPjtCKrBHOHn0M+QAIrfm2BwtPMK+28aZa
         c0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130822; x=1723735622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Si9FSarNrsIrF9LJFUeb3R9ppHt6Z4HgOoqYsocg2gE=;
        b=rKIoQRM0dMeLg46ACg2FwQ6usmDi/lICfqgaxD4N5uhP/YZv9kUI90WsR1nDvN0YoO
         SouVT564nglAEqbeMBon6JxJ9eZo6KZA9ZNtaMvTZM0tZPvkJquKC+2aIBhWJYbYi/sC
         KCukZCtEaxZ1L7oOK5ShWL0AFyYYiL+5/+UEuf5sCJjeI7ydWrRNImSGQ1yUwd3zCkfM
         4W+WNkhOJbsNRPD75XQKAVFQkd48J8YzoRop78RTCcUKDXMNZ02XfOOZhRUlTUCQH6tR
         PRHAFUbf0gYlOMdPd6Rtvkb7zoN0P6ju3r4AABT/SCcR0+JcJwEf/REpsnAib92oCUkg
         GukA==
X-Gm-Message-State: AOJu0YyJKpfKaHG9adScqFPBSTdc8LwmSXQ/vnGJ3cKXwDYHeZSvnHPf
	tO4DtstEHD9gLIwwsBiRh9mPu+MitsO8DLB02bQAqjcbfrCRrgDCkTVCZvD6/wiCF0BZ1VopP/E
	CbKQ=
X-Google-Smtp-Source: AGHT+IGTp3VMmUslrrPreS4xy1gci5rI7IpgJC2DHoJmzXsUbNwwLhnz8zaSP4Zs5Q+R+rdSUF/OCg==
X-Received: by 2002:a17:907:d843:b0:a7a:a557:454e with SMTP id a640c23a62f3a-a8091ed389fmr201441666b.2.1723130822286;
        Thu, 08 Aug 2024 08:27:02 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9c0cca0sm751327466b.64.2024.08.08.08.27.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:02 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 28/41] libmultipath: rename _cleanup_foreign()
Date: Thu,  8 Aug 2024 17:26:07 +0200
Message-ID: <20240808152620.93965-29-mwilck@suse.com>
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
 libmultipath/foreign.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 2a42df5..5ec2d0b 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -84,7 +84,7 @@ static void free_foreign(struct foreign *fgn)
 	free(fgn);
 }
 
-void _cleanup_foreign(void)
+void cleanup_foreign__(void)
 {
 	struct foreign *fgn;
 	int i;
@@ -103,7 +103,7 @@ void _cleanup_foreign(void)
 void cleanup_foreign(void)
 {
 	wrlock_foreigns();
-	_cleanup_foreign();
+	cleanup_foreign__();
 	unlock_foreigns(NULL);
 }
 
@@ -164,7 +164,7 @@ static int _init_foreign(const char *enable)
 		r = -errno;
 		condlog(1, "%s: error scanning foreign multipath libraries: %m",
 			__func__);
-		_cleanup_foreign();
+		cleanup_foreign__();
 		goto out_free_pre;
 	}
 
-- 
2.46.0


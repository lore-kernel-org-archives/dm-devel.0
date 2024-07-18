Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B02145A1C
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 19:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721330071; cv=none; b=E2FKTy2TQiDjmv4wLLlPNK+//wk97K2sJqtUHXZmKZ+I40cGNcddQppJplk5n2jVqGPim7MroBCa+dZ4M1fCorWrceBlwZmNyO8x6DeIbS4ZFASuwkJlt758qKUPCXde8+R2oAKFFNS6XPt2ry5Cp6tMf8ex1B4QjAi0vGY6Fjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721330071; c=relaxed/simple;
	bh=8W6vsdN86mClo99esXRdC3/jAL5K5Br8Z4kl8fFK8VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5x8ptjyLxYFr3ZgDbEA279zyYKW5mZWunVFtktE++3oSRKy+UaDMXjLcQ240wovnUstdpJ95Qf8vtXA+t/gpPLU6XICFEIW+K0t1jy8ZFjLj2Wgjc8uaW9OXpNX217b/7D5Cehi/QzMqICipvacKHjM2PNEOGkc/MWMTZhpe7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TC+3vaHI; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TC+3vaHI"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ebe40673d8so15189981fa.3
        for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 12:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721330068; x=1721934868; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWURQ6/hqvrXHEWST7ku8P4rUskhLBLuPDjw9+eSQyI=;
        b=TC+3vaHIYl+WtpQ/TQRGLTFK1HSqLrCzCw16rwqjvQ0FpC1ELX8Gycz0bQEbshZdir
         DvSInBIQqaLPr19AeKDKlYahN01/uHJ8YrWiPFLIzYJOVagm2aQ6AkjKNm+SBYfC2fuA
         CXg/lXh/8b/vbmC2RdVMBTUVWzx0q4HXwwyh4W4DJzR1+Iqv+ESAHmluUXOAEi80ZanB
         Zi2If5essCPKuYcL0qWa5LWcNNf41E+EC28157sEvZGxcvl+7v5X6n0UsUMZNKzbWZ05
         9451beQM6a4SYE9EMk75ZjunV+7aheM8kLVdNd6O+L2PIHOU9p2ioDSydJd5gvL6npqo
         eRNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721330068; x=1721934868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vWURQ6/hqvrXHEWST7ku8P4rUskhLBLuPDjw9+eSQyI=;
        b=ZVK3cwneNa48WZ0gqhlBJZ46FjgcIqcSLR9RowKoZrktgSs4ZTa/m3OSsEMz9XTH6j
         C6lwn4mIetKyPdGrNxSYmdcYPvro20VnJQ+IgCNFlRv6OsAPKYC/dzayTDHlj9KbA3yO
         yA0d2G30rV5/g90YaS8NrV38lzbL4Fa0Es3Ckqo5iuDmpr3+w1qEontGcQnpPiVCtFhT
         2lfHyOCWnHzcmkTNK1UlP0FIQv/D/2Gtmkw6UJN8o5x60ipV4vXGtwN+z7N5aMVKl31z
         Fqxbx6fKuO9xxri5ey5B0m7J00yXoRD5hJ23vThANqMTaRlIKn1uiqZK4AcmVcauJacN
         FLpQ==
X-Gm-Message-State: AOJu0Yx2Gh3GUzo0JFZPhjdRoDfS1NXYIVsHynD3rCYLM1yl4C1kUZsN
	1ofCR/vAhA2KpyegpLodx67UfvA5aNS1xenckLEGJY6Nad+1LuwHXCvxQWX4jHM=
X-Google-Smtp-Source: AGHT+IG/uIkkRptEDhoZcRMKa4ub+LN49HyKx3/XFBlARQHSKObwYih/UEW/9hnyLlUWEDgE9mNoyQ==
X-Received: by 2002:a05:6512:6cf:b0:52e:9ec8:a407 with SMTP id 2adb3069b0e04-52ee543ff4fmr4319616e87.63.1721330067958;
        Thu, 18 Jul 2024 12:14:27 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a79bc7f236esm593036666b.138.2024.07.18.12.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jul 2024 12:14:27 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 4/4] fixup "libmultipath: use libmp_pathinfo() in update_multipath_table()"
Date: Thu, 18 Jul 2024 21:14:21 +0200
Message-ID: <20240718191421.110487-5-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240718191421.110487-1-mwilck@suse.com>
References: <20240718191421.110487-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to check for NULL before dereferencing mpp.
Found by coverity.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 731b1bc..d58ef5a 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -504,11 +504,12 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 	int r = DMP_ERR;
 	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
 	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
-	unsigned long long size = mpp->size;
+	unsigned long long size;
 
 	if (!mpp)
 		return r;
 
+	size = mpp->size;
 	r = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
 			  (mapid_t) { .str = mpp->alias },
 			  (mapinfo_t) {
-- 
2.45.2


Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7611428E59B
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 19:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644783; cv=none; b=HSWlRTqGGesEOOBnRlBInMJuJp6KswCyPLZxtIN2+JWEKF7UAbquvKqlTc48+IN+/0wd/dMDS69wa+rVMzYCJKjCeYYsSJRTwszfwQ94RqH3KZiGYBRch3MVV1YzPjr+09CrnnvYLYijCPSJsXp9/jGuxitkrZzdiTBvfNR3+dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644783; c=relaxed/simple;
	bh=QE1hEekrXAuFKFst7lFWpMoAZew5UlzbbepPcDX2rUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiJqKvaD2Jvim18N/QopO+rJoIpucx7v7UWgCcMIH8eK4GnshVJvvBqqx7CQ5tp/35R2NCCE552O9366v+GjqTQqrkVP9vWijf+mfjK4/VkqriuQxEhHQFH9HCsjppFetTCeeeWacMGxLB5E1cmA8278z3vigqF5mVZfBHNgXU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bd7AKof2; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bd7AKof2"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43d0c18e84eso1091485e9.3
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 12:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746644779; x=1747249579; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aZ2UGzVhNqlIymWcO+rUsPJuwPdSv00cZi3OlnKQqx0=;
        b=bd7AKof27ZObAZQDjbAVgt5Tv9cI7adMIoZr7mXu45NsMb9AIpbLt81cef2Anyl/xq
         cj0HDhfS6PwGNFF1UOqDmBrDl/FDg8/E9Vu0bi4sjN61IMJ6zsb2Bxkru3r/Zj4RLVEb
         fLXRaqJeEuvVxSbWD/a+8BnfOXIO4jOhlEJ/GcUown2YjbEulwsFHYx8c+PhDFS7L0au
         5yz+34w8iEDjnDHJhRShoXPx/htylkpBeUAvG+Qne5dsPteCTtchWNwMIgNpbnnaGd28
         xpQOfX4KCTuN+bL799kxky4Ey1YuhqdvQu37yJ5OnW3VMrnyDRkAWitFqErccOwoIjiu
         /ucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746644779; x=1747249579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aZ2UGzVhNqlIymWcO+rUsPJuwPdSv00cZi3OlnKQqx0=;
        b=UpvmwPAgVnesE+Ek58BtI7eynEQvRbTYGU6Azn/KNi7RPzk6gA8eLWu00wc3RP+NKW
         kAqFEYoSJ9YcbMYc2bH/9xQPnGcYuRFjA737HMPta7UB7RO8BOuX1IjruP3ZW3m4TNNn
         CIR06+kRGOOVWSQ5v/wMr82O8G/db+7Ef4VgY7uxt1GKJNF4U8b9xsJ3W0DGinG72JRu
         H0JZg2yvYnCM3ICSaSbU8EvWsosTZbs2cejf5dzvVLYw5zd67Pk3drFMtYoHMwMrGtvl
         P6UqdFrKTNlVxqBS3VJHM7lwwvDYVVxYfkN5G/E/X5K6mc0gR32SvbOwtL/FDs2jiuqU
         aolA==
X-Forwarded-Encrypted: i=1; AJvYcCULvq0hJLnvEOqLCMEeOGOZjad7AMvdz7gRw2Tf62XTsjnD6CTvzQIki9QsvIw8kwsUXRp3FkKxPw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwUCPqrcfGuIRSRzS2yS65ZkVQRtDFmJE/XkLwytkWAdG22vKwj
	5l4nSeL7X53epUoQZprq1t87v9aL5qsagfyTZUSywNOJNH0LsfiQebnuXQvUljY=
X-Gm-Gg: ASbGncuL1UsvggM3wZjN7Lin/TFhX0ZVNAzTArbKX3rD+usW8j4ycQ+bceFvRUkv+ST
	gSu3EEyEx+hnWnZURB8RXJonNcPZ5ddQzPoLK1uPgl36XzR66fyG6ZH+OTZbgqoTrf8sbK7Yb3i
	8fTRg0hlDbY8gDfkd2ySM9/uP4kDg6gbbkW1RXYbeJ2p+zVQ89zkTaU8JPckYx5IZAbtzYnSyjp
	lxPXzUeP8dGDZ011aWmHZK4YOyBEmwPUi3IXK/7VopSYplcREArYkmZWNGGLxm3Ev2uDA9//r++
	5gWGp3mgEHkuzHXQHHjiNEBIjZt9XMFpXj6juUvGpHVm2VVqVlh47XyTikJ5g8UekRN+o49Ygmt
	GsdnIh80zlKNozMU1t9SSYE4EY/3N
X-Google-Smtp-Source: AGHT+IGd1TIk2YKr3lu0O+aiZilNnC2aav6bKwkPTDfmmkX9/XibeyG6HyELp4wn7KjwuJYk6j1zmw==
X-Received: by 2002:a05:6000:4022:b0:3a0:88b0:b81e with SMTP id ffacd0b85a97d-3a0ba0f6faemr188069f8f.36.1746644778587;
        Wed, 07 May 2025 12:06:18 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a0b494a214sm3606641f8f.25.2025.05.07.12.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 12:06:17 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 3/8] libmpathpersist: fix memory leak in mpath_prout_rel()
Date: Wed,  7 May 2025 21:05:47 +0200
Message-ID: <20250507190552.209637-4-mwilck@suse.com>
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

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html#def44

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 0576429..0c5cd60 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -450,10 +450,10 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	int count = 0;
 	int status = MPATH_PR_SUCCESS;
 	struct prin_resp resp;
-	struct prout_param_descriptor *pamp;
+	struct prout_param_descriptor *pamp = NULL;
 	struct prin_resp *pr_buff;
 	int length;
-	struct transportid *pptr;
+	struct transportid *pptr = NULL;
 
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR;
@@ -560,7 +560,7 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	pamp = (struct prout_param_descriptor *)malloc (length);
 	if (!pamp){
 		condlog (0, "%s: failed to alloc pr out parameter.", mpp->wwid);
-		goto out1;
+		goto out;
 	}
 
 	memset(pamp, 0, length);
@@ -570,6 +570,7 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		condlog (0, "%s: failed to alloc pr out transportid.", mpp->wwid);
 		goto out1;
 	}
+	pptr = pamp->trnptid_list[0];
 
 	if (get_be64(mpp->reservation_key)){
 		memcpy (pamp->key, &mpp->reservation_key, 8);
@@ -581,11 +582,10 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 
 	if (status) {
 		condlog(0, "%s: failed to send CLEAR_SA", mpp->wwid);
-		goto out1;
+		goto out2;
 	}
 
 	pamp->num_transportid = 1;
-	pptr=pamp->trnptid_list[0];
 
 	for (i = 0; i < num; i++){
 		if (get_be64(mpp->reservation_key) &&
@@ -629,7 +629,7 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		status = mpath_prout_reg(mpp, MPATH_PROUT_REG_SA, rq_scope, rq_type, pamp, noisy);
 	}
 
-
+out2:
 	free(pptr);
 out1:
 	free (pamp);
-- 
2.49.0


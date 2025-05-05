Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF06197A8E
	for <dm-devel@lists.linux.dev>; Mon,  5 May 2025 16:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746462632; cv=none; b=coV6WuRtCKHlIn7jG/3Yyg1r1FwNuiCMRpW/Hv02/Y+jzT5YJwbdOs5rBQRMrsyttHUSv5Kv8bopqeDWYzQ5j8Hu3HMBlcIhRMnc0IhRM+iZAtdoeS6auPJiwQTt0Vs2y1EskyGmZuAG11zYbxySZyzHxKcaQ5+B7sCbNAn59DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746462632; c=relaxed/simple;
	bh=ubMiCPzBA421cq9AAIynA0oZV9SGlwY6doSJnE2Kr30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SubQybgetG3UdJxi3t8+1i7FcmpNZOyhF2FjemFbfWATdu3ksr2mOcK5uen03R1joc3iO+m+I2YlesBGtnjKFjHWygNcS0Gtath1LszNgDTg8NDSLscw4NK22mVSKvDRolZcblMVFd1+gTaVRe9BvLrolH6/jsugkXm1Y2kfL70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Psplz9iL; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Psplz9iL"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cef035a3bso28658765e9.1
        for <dm-devel@lists.linux.dev>; Mon, 05 May 2025 09:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746462628; x=1747067428; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=26/oSQkR51aFybusItyaLM9opzEKDLRAnsHHRHqt+8w=;
        b=Psplz9iLFHZ4j4Y/bemO1byJ0Mg5nva5XKSW3r26YX86evQZ0tVCMtD+B+zrDIYZ9X
         7161l+ii1CAmGi2+y4AHf4//dIsd2WR175IbPTq7s4LAAk12dR9N9cp8zGc0pvN23fXr
         VQxP6Otfo03zRzV958xdjS9Ni64KAZMnuv9YAkqZEOTUQFh7G9KRMF7nNnkuCoaxauMc
         wDHDQCLKdOO0a09WJDGN1ZNcbeEp8IYG+27t2Ydm+m3bqXbD5xh31Y+cm6aIeCiphCps
         sDG5eqwMP/1EcKVQfAGSFG25kAfli4HZxzyJDleUJc1X+w4nKImWZKSG2k5vAt45MCwe
         b1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746462628; x=1747067428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=26/oSQkR51aFybusItyaLM9opzEKDLRAnsHHRHqt+8w=;
        b=Yi6nZMoy+99NLDsAqb59OEfPaLBSLEE6DUNViZfoXbSMJK7g/Vjg9DgCf1K+/WckO/
         7u7Es97XlDnGxZXeTnfC3aRvFWLxfwLtQ9vGMs+Z7fRFv2sjOtud5BbhxyfSYNJ6uIYT
         VulOq6oJPw8bqpy6ylS1cmNaQpXJZvmQ3Q+GXydDMcbrFO/Mp2en7gjwqODuHhkDAfqH
         VD370q6hDdifkL1fTDfxNgtLvzMuCpojKxmJgXwfZ8btV+eazii4HOgzKp6rNHfTihxO
         BypeAne1TJjsccnx0IS88NKK2CvGFgMflwjD3mRPxHBnEwBsNLszqZkVrZo5dolc4/7X
         VXUw==
X-Forwarded-Encrypted: i=1; AJvYcCV7PjIj2rdS2EC9qUl6hCDWnBv7VVrrQe/HLfiL1Gp8jNInWQturYMKFkOBWfzM1Kcnh3Mg/j8KEg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxrNETfmq+ktEwdzqBERqaZuEkV8bTIemb8uq1FIwbt9gk4N/sy
	onyvoU6niYl9SJKWZ+gAuOO87/jhSrKozNxjmTUPmjNcYm8vz2H2mzkCGwauek8=
X-Gm-Gg: ASbGncuWIAYuigqe8a2Qv7JADuHFu43Of8EsTYQ5khRp3IvZUenlzfI/WHoH5WzaOue
	tLi3R82hD4736b5YhJy9kRgwf6DBBy4mhn32shZVRm8FDSdavlB+Uik8I3W0IjbkcsN7/s2bQyq
	LgqFhyCVM3i9mkLgDnmV6e29nuiS12/apQ3c5BumlJ/L1X8/pdkBqukVGeuEPRO9QbTsLFxBNLx
	ER2e99uH2jIQb07y0bRMkSK+J0U8EgOD9ubMzXdTac4nk9d2BhCjfMkF0SwW1RosRQxPJ2Z0zsb
	A+CEN2OCTw41t+l4eKFCjj4EUS6Pt++9Ow2Hkss8i4ifmNPJMoVYb6mjOBeHyRpeNnqD3mQ7aXi
	1idI+ityxbMBgSLyfipcyK5WXA5BhUU9FqOl82dg=
X-Google-Smtp-Source: AGHT+IFXyF6D3iwZsYpkDVPRHi6nOZ3QelvByRmwKZP4uSzx+4H3HoIK9Z4LoyCNNPLWJiB3TIAv/A==
X-Received: by 2002:a05:600c:a41:b0:43d:94:cfe6 with SMTP id 5b1f17b1804b1-441c48dbdaemr66599085e9.16.1746462628073;
        Mon, 05 May 2025 09:30:28 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-441b2b20a65sm183150705e9.32.2025.05.05.09.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 09:30:27 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 3/6] libmpathpersist: fix memory leak in mpath_prout_rel()
Date: Mon,  5 May 2025 18:29:55 +0200
Message-ID: <20250505163007.59352-4-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505163007.59352-1-mwilck@suse.com>
References: <20250505163007.59352-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Found by Fedora's static analysis [1].

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
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


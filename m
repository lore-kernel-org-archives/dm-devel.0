Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D235C3396F4
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817141; cv=none; b=cvUtfyI3jLrv9aechU9eftddE6/A/dGwSSJPRIvd4LfSBuBTqsCC3XH9U5x0+VW89pmVKKEwyEOjqD7/A+Z2DI4KFf1bfdiqOK8BrCgSEvrcGN+DNayDqtSM6qvAitnF0BO9mUFVhHqdqGVi5oQpJgBFHWUsOvlq+3mRweycP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817141; c=relaxed/simple;
	bh=CT/bDR/F4ugjStTsuNDbQ1bVAWmGKTFJ6uBq/pcgNCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/lln65pJTGdCIQj8ZlSR9t2EnlQGBJxEInTgPaL/GeLI8MlGlGEWlnAlK1BBx21msxZKLiI73l8t0oyX2npcbRViiiXDWUCNm16rHx+7FWKX2mXO8y+asOugyhRW+fVEtYyxGdwlEVCJfMFA3SrA2dkNKK9KloaH8WFqNu7/f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=THp1xVp8; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="THp1xVp8"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6505d3adc3aso3804619a12.1
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817137; x=1768421937; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p6T1L0qkXf4MUc0T6lsxhl70nvDv7By4N/ST/H1buKo=;
        b=THp1xVp8r3lUOQB/eBmGoinGVOMh9qnOI8Z/oUT9veYhQs6eNZfnU9XJVRSVbkNKAz
         O8497B6y89mRMkHXfKXQrCubzh2SXB9bA9yfjR3ifjbrT8iGiJSmM25TahN9+Pkv9CF1
         jC4hc6/7cmfRsHy8pD205i+CQsWMKQVPqZUkT5Bfb5RhrRTFVUMm/qlv4gAYGWjvTNHW
         afaIs+LUlC+CktUtT8CB02rsCg4FCVxFErqZ4qFRoJ/1q/RsPzNqbFUuVzMjhWefkSu8
         8wJYbC6hAhfwmS0HTUru8ILHoLdNoZMML+VDcWrf/AEz0afT88uFWSub7c1qYp55fCvN
         xGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817137; x=1768421937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p6T1L0qkXf4MUc0T6lsxhl70nvDv7By4N/ST/H1buKo=;
        b=v4G54a4Vj4cPfTEQejUznXlWBKV/Z2LmAJc78s4Z6EtInIdredAlxeEM36jR1leESZ
         GR3NyIBAOG67hf5RM8BmxtbpklXg/+pfsVoVqAEm0Nl5QiKcTdmWCim9OztR8aW4elrg
         WprP5smUexFKJHdYZm/Kee3/c2QkkdEznuVOlJbqEOa0vJspa7U3Q5ubq+KnXs7/KfIO
         cNuNzkxewZCz1qZbC99E+bm+OfmC+QhVckxqmqwdAxrlgRlGeSxedFUubU9YnO5EqAAg
         p2zRSRRa/ranoiF9rDUWLP+t8rWWE2Ck23vLYh2qVhjG3Nb7dZD49RMRyUhlVK8Q3aha
         MiPg==
X-Gm-Message-State: AOJu0YyMHSBv+es9iFI8s7zl6RlnOq/vtWrS3UFIRODk7ovChY+lkiHb
	mH2CBnXO1208GwKslbgKLZDpu7BtqGHYedLxExMN9aT7K0mAdI6IasEishMyzEI79B4=
X-Gm-Gg: AY/fxX4mxKf/Hv2Vk/g8A1X2TIIgxQ34RvicFZbLUzsmMt2YmCFD5hUmJ9IWAcQpINt
	Uit5notVUBZ+enCMYD5mgOQbgZFicMHbSJUBTWf6RVFtEwA6oDrwgNQPJjUVRvwxfDp8GBMOVpy
	Ndq38XvEa9bEwTloygrJc5iRTgaXxJiKkUGtgKUb0GAmrWt931B32ZV+9IvMrhASmjRuGoqMS5H
	/CZhdjmc7P1FzpTq1v34P0r420AWEcwblP10fmFEJgCKnmY/8hG1fLJ8ciZuj61U26JzfgJNYBY
	WHjjSKgLE1IWNxFtDv+g182GmIGMvvYn6d2RyDyrsKu8c85vFYc2DtD3VlHrsyGUfJnF4FjPsDk
	ttdtJ4TC0TzGTD0mlxyOthw3QSCvlfpS/lELixhOsyY7epqAy9vXU+9j34cgxvD+JxSyPmqQGN1
	PObEi5NGDxHKNSWkfMJ1CIQc76Vul/Az3grRdzxFlLY/n/zOS7nU//ZW9xFQjYAfo2UESHfSS03
	g==
X-Google-Smtp-Source: AGHT+IEavb7r2Gy60zT+19kQPcd07DtisjoQaE/t8tBZk6IHFvP4EYBJoWt70FhroVk/QwZL0FeIKQ==
X-Received: by 2002:a05:6402:51cb:b0:64b:9fa4:ade1 with SMTP id 4fb4d7f45d1cf-65097df569bmr3235744a12.14.1767817137113;
        Wed, 07 Jan 2026 12:18:57 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6507b8c3f89sm5840896a12.5.2026.01.07.12.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:56 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 16/26] libmultipath: remove cleanup_multipath_and_paths()
Date: Wed,  7 Jan 2026 21:18:16 +0100
Message-ID: <20260107201826.323977-17-mwilck@suse.com>
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

This function is not used any more.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 1 -
 libmultipath/structs.c            | 6 ------
 libmultipath/structs.h            | 1 -
 3 files changed, 8 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index f62b4da..3778816 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -69,7 +69,6 @@ global:
 	cleanup_bindings;
 	cleanup_lock;
 	cleanup_multipath;
-	cleanup_multipath_and_paths;
 	cleanup_pathvec_and_free_paths;
 	cleanup_udev_device_ptr;
 	cleanup_udev_enumerate_ptr;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 0af46a2..45a3192 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -336,12 +336,6 @@ void cleanup_multipath(struct multipath **pmpp)
 		free_multipath(*pmpp);
 }
 
-void cleanup_multipath_and_paths(struct multipath **pmpp)
-{
-	if (*pmpp)
-		free_multipath(*pmpp);
-}
-
 void free_multipathvec(vector mpvec)
 {
 	int i;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a637af7..251e672 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -582,7 +582,6 @@ void free_pathgroup(struct pathgroup *pgp);
 void free_pgvec(vector pgvec);
 void free_multipath(struct multipath *mpp);
 void cleanup_multipath(struct multipath **pmpp);
-void cleanup_multipath_and_paths(struct multipath **pmpp);
 void free_multipath_attributes(struct multipath *);
 void free_multipathvec(vector mpvec);
 
-- 
2.52.0


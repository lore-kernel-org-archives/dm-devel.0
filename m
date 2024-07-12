Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E5717C6B
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804582; cv=none; b=SS/5Dk28tYLyqv8mkz98C/7+C/XzLRFg6OLS6gVwBYSoTFkhScSDUBAZ0i4+kZ2x4kScO/n53TO6sUYvZCz0RoBAP8uFpr4dQVUfE046RE0yV3/tMeOuQKoJ3dhNvo+rW/jbfn/2lD9SaySeMHCUH0RtVVDcd3vElAYV701Ru7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804582; c=relaxed/simple;
	bh=T/i/sc153Kwcqe/xc9wim2PKplEdEYDvS4pzALkFB4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wyf/Ddi56d9Rlpd4U/f+npMQxUab23hiLow2Mtg5ooINL2KbN2oPCU7Ce9fAL42tHlw2KJRhh/XHVVlR2lRuMlTpRJodmO9va1xaAtNvGfK5oeU2V8Y67pSkre50w4X+pq69+UaWpkBS3DP/kn04HV/j3p/aPZE2ifi3hpXiqMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Mg4KkFcq; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Mg4KkFcq"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-59589a9be92so3191091a12.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804579; x=1721409379; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qdKfvUMTtKRdoi/pm6nNvKWq+FKnlTr/ZC6Ww7KpRoU=;
        b=Mg4KkFcqAKD+dkNSZFYCXIQohLnntK8C1FrK4okpzisLVDsMjq2Siq1LqDLgoGPC91
         P2D+9TCbGojs9PlP/WxyWIQQbFmVtBuxRXW/NEiP5a8wSaTeOvk7q5ZUSd1PnT0blJ7B
         Ya/1WhPgrepF12j8GGvNt4o0tQaW1QyQdobBX/1NPGzV9KV7a2olJyhZk4I7qajCH8/x
         vjbhGDJdrVdM9X4/pL75hT9VUWC2/kI297B6fYjLPxO24Q9OFEI4LzAJYNN6dXFBDUla
         P3QNh6gkKYysrYKl6aTEISDkSTSKKeHMMZkgtRQs8+km+Z+EVBLb2iFgNC8B1FoAk2Po
         u3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804579; x=1721409379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qdKfvUMTtKRdoi/pm6nNvKWq+FKnlTr/ZC6Ww7KpRoU=;
        b=ZOPTmRoVDBsofM1ELccZ6ZRVprb2qpcINMB2FQrDbFk/NpLOd4KQ8ETiOArKIe4BuF
         Rr48hSzadeGcHu3pmk8nEnxicvVjWYJMYupGS2ZZWOxYMoKuOzyu8qZ4iZVrGfPcOblx
         ag6ncIVqp5G+HRleC6HDotKa/a35ksbV+yygOk2pOuN0QDKLhMQpK5Fm8v9ATQRamJ4I
         2EgAd+1hfz+VKypM/iJGwMiL6LrKJbtXw1E4uhVDgUQFRim9kX9HXrdE/HJP5FPETne1
         0f8s+EJCd9tRC7fSM9xCFOqT1sF/Ozq9lFBg/m6zZYw7luTGCx5MY2nhl2RVw+9tduB+
         T5mg==
X-Gm-Message-State: AOJu0YwusLXynt3rmSlujx9Pek2FI4DrH40ej+vkdNj2czhiq4dFLe6/
	qsGP3JAkKnMsNk5fPygEWZUnvquMAVaYb079IcI7aYVoEY0cxb5bNxj9XSoGgpc=
X-Google-Smtp-Source: AGHT+IEsWbnhKuqHHtJuuTRBb5cfiZaFJYPf+5OpppNcyhzb0alNzlSootY+0GfBLZqf2racKni8wg==
X-Received: by 2002:a05:6402:35d0:b0:58b:73f4:2ed with SMTP id 4fb4d7f45d1cf-594bcba7716mr8574176a12.35.1720804579069;
        Fri, 12 Jul 2024 10:16:19 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bc4e8255sm4733405a12.48.2024.07.12.10.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:18 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 45/49] libmpathpersist: use mpp->alias in do_mpath_persistent_reserve_out()
Date: Fri, 12 Jul 2024 19:14:53 +0200
Message-ID: <20240712171458.77611-46-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The extra pointer "alias" isn't necessary. The mp vector is initialized
by dm_get_maps(), which will allocate mpp->alias for every map, thus we
can use it in do_mpath_persistent_reserve_out(). This allows us to simplify
both this function itself and mpath_get_map().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 38 ++++++++++++-----------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index a3eb80a..807415f 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -154,8 +154,7 @@ static int get_mpvec(vector curmp, vector pathvec, char *refwwid)
 	return MPATH_PR_SUCCESS ;
 }
 
-static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
-			 struct multipath **pmpp)
+static int mpath_get_map(vector curmp, vector pathvec, int fd, struct multipath **pmpp)
 {
 	int rc;
 	struct stat info;
@@ -205,8 +204,6 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
 
 	if (pmpp)
 		*pmpp = mpp;
-	if (palias && (*palias = strdup(alias)) == NULL)
-		return MPATH_PR_DMMP_ERROR;
 
 	return MPATH_PR_SUCCESS;
 }
@@ -218,7 +215,7 @@ int do_mpath_persistent_reserve_in(vector curmp, vector pathvec,
 	struct multipath *mpp;
 	int ret;
 
-	ret = mpath_get_map(curmp, pathvec, fd, NULL, &mpp);
+	ret = mpath_get_map(curmp, pathvec, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
 		return ret;
 
@@ -649,12 +646,11 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 				    struct prout_param_descriptor *paramp, int noisy)
 {
 	struct multipath *mpp;
-	char *alias;
 	int ret;
 	uint64_t prkey;
 	struct config *conf;
 
-	ret = mpath_get_map(curmp, pathvec, fd, &alias, &mpp);
+	ret = mpath_get_map(curmp, pathvec, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
 		return ret;
 
@@ -670,21 +666,20 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	      (!get_be64(mpp->reservation_key) ||
 	       memcmp(paramp->key, &mpp->reservation_key, 8) == 0)))) {
 		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
-		if (update_prkey_flags(alias, get_be64(mpp->reservation_key),
+		if (update_prkey_flags(mpp->alias, get_be64(mpp->reservation_key),
 				       paramp->sa_flags)) {
 			condlog(0, "%s: failed to set prkey for multipathd.",
-				alias);
-			ret = MPATH_PR_DMMP_ERROR;
-			goto out1;
+				mpp->alias);
+			return MPATH_PR_DMMP_ERROR;
 		}
 	}
 
 	if (memcmp(paramp->key, &mpp->reservation_key, 8) &&
 	    memcmp(paramp->sa_key, &mpp->reservation_key, 8) &&
 	    (prkey || rq_servact != MPATH_PROUT_REG_IGN_SA)) {
-		condlog(0, "%s: configured reservation key doesn't match: 0x%" PRIx64, alias, get_be64(mpp->reservation_key));
-		ret = MPATH_PR_SYNTAX_ERROR;
-		goto out1;
+		condlog(0, "%s: configured reservation key doesn't match: 0x%" PRIx64,
+			mpp->alias, get_be64(mpp->reservation_key));
+		return MPATH_PR_SYNTAX_ERROR;
 	}
 
 	switch(rq_servact)
@@ -703,24 +698,21 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		ret = mpath_prout_rel(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
 		break;
 	default:
-		ret = MPATH_PR_OTHER;
-		goto out1;
+		return MPATH_PR_OTHER;
 	}
 
 	if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_REG_SA) ||
 				(rq_servact ==  MPATH_PROUT_REG_IGN_SA)))
 	{
 		if (prkey == 0) {
-			update_prflag(alias, 0);
-			update_prkey(alias, 0);
+			update_prflag(mpp->alias, 0);
+			update_prkey(mpp->alias, 0);
 		} else
-			update_prflag(alias, 1);
+			update_prflag(mpp->alias, 1);
 	} else if ((ret == MPATH_PR_SUCCESS) && (rq_servact == MPATH_PROUT_CLEAR_SA)) {
-		update_prflag(alias, 0);
-		update_prkey(alias, 0);
+		update_prflag(mpp->alias, 0);
+		update_prkey(mpp->alias, 0);
 	}
-out1:
-	free(alias);
 	return ret;
 }
 
-- 
2.45.2


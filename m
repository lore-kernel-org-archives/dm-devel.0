Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413BD189F55
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561232; cv=none; b=XvO2w/xnTSDeI04nveGXftd/XNHOxJhyJKCBgsIsFU4CuPPBVd7dQiNndmqWA9c/wcN+MPcTeQ9j0vy8xxnhhszlm7dwb3BBatH1p/dkA2JBT9Vp9L5uzZSLL635o/Ov+hLpo6FXk6oCi+7s++MRZ3HrTZ3y7lU+UrZ4hUj3HjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561232; c=relaxed/simple;
	bh=gBScydWsal066e+s68/FVaFk0ZB/zk2tyS3dnyadIp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvMEI+B9ILykAZVHM2xIPalxMQJB2VLMppRvlk4KA6X31sdEpv6OY4xjFicStEu1MJsqoKR9BMUaDkOIk+hLK/smiwTpD0YmH42i3+hpjwixwZRwaja7zzMhmFFLQMI8Xf6p0Xaat3XoCAKGALME4Xjtdn+5ceGS5w+T+WGlhKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WDTlY6Du; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WDTlY6Du"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-595712c49ebso1355500a12.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561229; x=1721166029; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQO26Q94ipdYm+1sxSUKwYiA6okhz+QNoEFfs3lnvH0=;
        b=WDTlY6DuUOV7v0ikvW04N2Z9A/ceiTG5U2hYyvCKKhr+bPj51kmuEIqQQpL3pax+Fp
         nmWezehh463I4rfXE6QjSxh5q6Zf3JbSdTe0nVHVizXXXu5EbXUzCZFgRsNTPljwBF9x
         lGmzZSzq0nQGoQ/cZyPIfY0kMdt8Z+Xg3suczaDUgf0jAv2v5r+9i0QetFTMcbRy3CNb
         fj2j2f1kV2wXuamQGww9OJJJ0O4B0jeCCtcQ4qCA7EJrX3FJ/m+p9+tgSDG+BY4g7t9i
         SEK8U4OZIP8mTfWIuusXaFMCJA6nqb/nGVbbqnEHx0d9HZlLdXnaeYezFlmqo6oJPpIl
         L7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561229; x=1721166029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CQO26Q94ipdYm+1sxSUKwYiA6okhz+QNoEFfs3lnvH0=;
        b=UNzyisqEyNgH4QIeOSjN6ENtZA9R/1TJEanPpmRiPEYicvXDVWYtssIhtjgf3FBIrM
         8wnwgdxX/s6lJwvhRrB5RTHMrSIjWmzkA/nogCHfQ+36iMdYkNAWcrx71JFByud8xXkJ
         pk2mpDHx4YJBtXc6rPHTO3O16s4l+ifQE6OZDmzkGx6AiQrDasyviUU1OVtyZ+5E/bFM
         SEml0SfHs3iyxILPv/U3/p0Qk3liaWJyVA35cmEghHzSeqVvVwWViiYBjzX8w5JHNhog
         twcwwJyhklkYsU/gZhyZ0TeqSRxw+iMBwXTX6tNAqge5OSpDpp3K6dhR8lZSA82+ICrm
         Wgww==
X-Gm-Message-State: AOJu0YwPKoshJtVD9OuSKne7V24dJEpXb8ffhDsGW+em9D9wXFBwZ8BW
	UjqYaWPI6SzOzGdg2esR7/iRQeKj0MvA0AIJ0OmpeJl5d8KlZX5B+vNiqCPKVak=
X-Google-Smtp-Source: AGHT+IGu3FRXnMBpP46mZlxbHYIvn3iLoOQ43wy4dQDrGUugFEYPERoG418wHweE8RTZ2fLX8F4Mjw==
X-Received: by 2002:a05:6402:4309:b0:58d:249c:5de9 with SMTP id 4fb4d7f45d1cf-594ba98f432mr3024081a12.6.1720561228490;
        Tue, 09 Jul 2024 14:40:28 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bc4e80c6sm1501634a12.46.2024.07.09.14.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:28 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 44/44] libmpathpersist: use mpp->alias in do_mpath_persistent_reserve_out()
Date: Tue,  9 Jul 2024 23:39:35 +0200
Message-ID: <20240709213935.177028-45-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
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
---
 libmpathpersist/mpath_persist_int.c | 38 ++++++++++++-----------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index a3e7bd8..d215543 100644
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
@@ -206,8 +205,6 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
 
 	if (pmpp)
 		*pmpp = mpp;
-	if (palias && (*palias = strdup(alias)) == NULL)
-		return MPATH_PR_DMMP_ERROR;
 
 	return MPATH_PR_SUCCESS;
 }
@@ -219,7 +216,7 @@ int do_mpath_persistent_reserve_in(vector curmp, vector pathvec,
 	struct multipath *mpp;
 	int ret;
 
-	ret = mpath_get_map(curmp, pathvec, fd, NULL, &mpp);
+	ret = mpath_get_map(curmp, pathvec, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
 		return ret;
 
@@ -650,12 +647,11 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
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
 
@@ -671,21 +667,20 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
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
@@ -704,24 +699,21 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
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


Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4C43195E4
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155296; cv=none; b=oWzz752YEff5OJgs1jJXbK2eD+tmGXMDIbtUjjlcwko2P9VKNo1yH+R+q5P/m0tDVOSZcAmaMzBntvBV3H4S9ygzZP3DDsphAiML+p/znhJK/3VNYhCBFONwwIVj17pTAGPbFBdlBZABnrVYFeyqkONkNu3FYn9nhitC4zJ03+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155296; c=relaxed/simple;
	bh=Ih+6RE++jpwqBN91W8uEcYPhhd4ckh7aYrV8AISsJcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=petrGYFAPp+Pw2z7Kr55i9mBk2Cd3IcTjsm889FKXYv/H7z3QumiRKfBnB2csvt5z+4j/B48JhtYjg8gbfZsx56Stq/z7hFL9tnwUES0yIr90TEXn7dDsM/Hz9rp8RWtADHWp/Yx22wIXVW1sM69SzsUdWB25STPD2hpFAdEjrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WawZBI6/; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WawZBI6/"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so2989546a12.0
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155292; x=1766760092; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FJoTJ5keJyNz2jWjKGida6ETlS7tTaJHDFsFEwkU5eo=;
        b=WawZBI6/OyYELqg9+UyIExU+zmpZk9CSDzC6jWqbq1HTuTa7UieYBna7h+SlrXPqzr
         tHE9MbASB7NcNuydh2SI9OHbHuOKJBaf32IVZ6BdnLMIqbmMChY6/TznorMjcYr7+3Iu
         14WKtnA5aKdxnkXRh3u+mXqRh7CF5cSJvHDWvkG7fEWvi3QRkyNBihOkoVIPTgKMgvXE
         kGHUiVG7sGjZE0kpgWEtvdqxzJbwPgHUblHrohLsZZ6W2pKVYwL9LUY1bgmUTZoQf4lf
         llpRdraA3/78Em0Qot35WHdb/7uo+EQ8tAsJkWMl7rtYnz5kVMGhp/LoS9tMXd8Lue0H
         IUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155292; x=1766760092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FJoTJ5keJyNz2jWjKGida6ETlS7tTaJHDFsFEwkU5eo=;
        b=dWtRgJVYDxL55G+nv5Uwu2hMWNb3En7n2LjLvXDAb37+m2RlOUPPnxWxidTGXfsotd
         DZFHTF76k0tnxOblsHWAUh9ibt5J6jnTRBQzJAWsbOSnQz3mY/kAXTmqeEAUzg2hx7iH
         YYzW3CG8W/OAHYtmIdr75M3DER/iJpT/mg/QkxN1dm6ANI1F9MqZUCIt1IqobMgTY2/h
         Udccb17e671VXxIEfmKjwhCv7eo5rkV5XaqMtF52yE1XP81koKc+81lCRrrbavHcUOoO
         KEUJSbeycaguYwbzOjH/dQDZLkB4XBGR3NoJmsTfgfr8xhRXOG/IkVcsW7ry5h+tha5z
         JXyg==
X-Gm-Message-State: AOJu0Yxwmu5PVeds5JCNGWwGqQlpzV4jHX9P+yVEW0TSFQBCaohoIRAj
	9fq0fHE5sjznF+fZZml/88BKNUH/UFk2OFVrDn6lh4oyaL8xsSMz91QPbgOpXjwsXdk=
X-Gm-Gg: AY/fxX6xvJsFpwy0UMMVipFv7B57h3s7CHWXvoLrWpwIYYGw7s0tmbY9u3EwQEVv+Z9
	Sqa0FaYIB00SPHW8JpQlASNf0TyJiQdHspHmtc4paynRRvaIJ+JPCJfMMw7ue3cu3kvPYZSW20V
	Kr7ZT5lfPJPfgl/WnGLokqW6Xznuy+iP6AxDx0AJSF+U+/cDYkhsaoAIYKe1sK8sFAe2mMQT2rJ
	jQoF4XSG95USjPDU5f4A7vcWc3kvKAJlKfjLHpWH55aZKEO2MO2VcY4uHu25dvc6iwtOncRCEOR
	i5f9MfyHmlNqFWqmy1DZFtjlQqEBP9MJkq0a81EHYZogVc2CJCurMS0PLkfbshdQfatztcng2J8
	FQoFDR2WF4Hl6qFn4zCWf+CAHNVyMoxYCR+3ukEzp4v2wTMbTXSIS/UE0C9eFV0ZSQ+yBz8Q4Wc
	lNWUOAmJu/TCNJOii+Di8sN/NhF83974d4RndWg/DlAxPYKZ3ITCao+a4lW5M6S2kQpO8cJLk6U
	hUTZsMX37Lv
X-Google-Smtp-Source: AGHT+IGWKyzvK2jcXY/9s7XaI7aUX3odlQB/jimEy9fIjYO63bNzUBz++GK+Lvj88TM4BxHTs9moBw==
X-Received: by 2002:a05:6402:510d:b0:64b:6a7b:5996 with SMTP id 4fb4d7f45d1cf-64b8edbbf99mr2644471a12.30.1766155292426;
        Fri, 19 Dec 2025 06:41:32 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b9159a6d0sm2354448a12.28.2025.12.19.06.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:31 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@suse.com>
Subject: [PATCH v2 14/26] multipathd: add_map_without_path(): orphan paths instead of freeing them
Date: Fri, 19 Dec 2025 15:40:56 +0100
Message-ID: <20251219144108.237928-15-mwilck@suse.com>
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

If add_map_without_path() fails to set up the multipath data structures,
don't free the paths associated with the map as
cleanup_multipath_and_paths() would; just orphan the paths.
update_pathvec_from_dm() will handle the paths and see if they
need to be removed.

Suggested-by: Benjamin Marzinski <bmarzins@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c03546b..7b522e8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -771,8 +771,8 @@ fail:
 
 static int add_map_without_path (struct vectors *vecs, const char *alias)
 {
-	struct multipath __attribute__((cleanup(cleanup_multipath_and_paths)))
-		*mpp = alloc_multipath();
+	struct multipath __attribute__((cleanup(cleanup_multipath))) *mpp =
+		alloc_multipath();
 	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
 	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
 	struct config *conf;
@@ -802,11 +802,13 @@ static int add_map_without_path (struct vectors *vecs, const char *alias)
 	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
 	put_multipath_config(conf);
 
-	if ((rc = update_multipath_table__(mpp, vecs->pathvec, 0, params, status)) != DMP_OK)
+	if (update_multipath_table__(mpp, vecs->pathvec, 0, params, status) != DMP_OK ||
+	    !vector_alloc_slot(vecs->mpvec)) {
+		orphan_paths(vecs->pathvec, mpp, "failed to add map");
 		return DMP_ERR;
+	}
 
-	if (!vector_alloc_slot(vecs->mpvec))
-		return DMP_ERR;
+	/* Make sure mpp is not cleaned up on return */
 	vector_set_slot(vecs->mpvec, steal_ptr(mpp));
 
 	/*
-- 
2.52.0


Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3A519005B
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130816; cv=none; b=rODNnbsP1PvwxjyAc2Iy4pZBQgVWR0g5X2431P9IQhLByRWyTxfmTtRiyVbwFfXf9/OEBALHRplw0ZhoVyxQlxntXLsFy4BJMQT+6rLSAGqqIH/hBWxAP4mHfDPxzN3FHZ7tk4KkUgQyqzuk1PPLwaWAG6X8ePARu/Fq/eNNdEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130816; c=relaxed/simple;
	bh=mkGScmdJynrBKwx3JmeN0py9dV31iwO32WMNAfUFQqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTvs58/GCTO9Vme1yatU7wlmPR73yQbDhEU/1ad0BXc9wcnegpCWxOaWKTtPYbiojgrX7kzwKFPo7lmaKJy9fiUphc/gwYYZNkoAhBlqiHnV1a5bE/Ox7HTcmQfg4f6e5iujnLtBj6InawYt8TUs8qEnXRD78Uh405f+FPmbnME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aEvB/mHg; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aEvB/mHg"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52efba36802so1451510e87.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130812; x=1723735612; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XzHM0hHl1e9L8dGMQraoB4i51ObhifWg1qysQO0cEC8=;
        b=aEvB/mHgAgrRPjCKnPFz1+YcJ8QBA3zghKp60NZDncEb/g/BPagFUwBKXnt03MD+j7
         3EmFK/7PTqgIQ989y+9D3GG1RrPSa3I5Cy8ZOA2BVMuLijU17TwZJ0CsTzNXJWMIELA+
         JEO3t10D4LRPw+Jy9E8TOBtynKyhRn4JQsTlphpWGI3D6lbndgN3lsex8k167tVL6h5G
         +U67ySEoGcy4J5RE+a74YkH58yVlsMCzUyi+9dO3fcBdshgEDY0ob5VXBm84cx+0QBih
         cBPjoUyq4vCvkparwEZKqFnJzGvXnh2HSR5kJTLXAiVgHJzuzqwpulxOZc3lFuGWSRHE
         kB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130812; x=1723735612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XzHM0hHl1e9L8dGMQraoB4i51ObhifWg1qysQO0cEC8=;
        b=hHCCr9kVeDlaaVKMIHHXIkkTTRP84tTdIQSqgG7Ni5GrAPkLnpiu7BxmFphfIqk8vg
         9g1dft2nvqGKGJRaJNv4WWLdfN3nxA97eWF8qJLeVFunZYpx0tUjF1r9Kb5w/L+y/7rT
         p3Dioj6IQhxcCh44PQZZcwe1eOPcdKRQpvF0XiJGvHnaVScwCEhrsk3KxDT9OoKQcnW9
         5bv3X9+erjQwqMN+nh9e4Nr3PnDry2EjAnRVU5hQa6khKB8b0TkLGn3rlViZr3AgUbpf
         +Kdf3yIJ/Tb5D4zM1mEnuHvp/N+z4153PGiPyuwFjaWflhiV1rpOPeOGVe1J5QfbnWEx
         D3gg==
X-Gm-Message-State: AOJu0YwcVXtxpS2ovrMNXbMGVFbJpqb0mpvIIvDZHF7sVJOrSoyTo5am
	ggCqHOZmFChSijIdtcnvidqP01OYTPPP03o6H/30/p38aBYvo8obT4Qb0yc27RktjXTaL4DRH6p
	7jVI=
X-Google-Smtp-Source: AGHT+IHGiVHczHB4LjHqyIIa0kmElgHn6+MmJCwbI2h7pVutHyEv2Wxyx010KljEFfScNLmXO4PgRA==
X-Received: by 2002:a05:6512:1391:b0:530:ad7d:8957 with SMTP id 2adb3069b0e04-530e588b63amr1617998e87.49.1723130812104;
        Thu, 08 Aug 2024 08:26:52 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9d43913sm746741466b.105.2024.08.08.08.26.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:51 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 18/41] libmultipath: rename __snprint_config()
Date: Thu,  8 Aug 2024 17:25:57 +0200
Message-ID: <20240808152620.93965-19-mwilck@suse.com>
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
 libmultipath/libmultipath.version | 10 +++-------
 libmultipath/print.c              |  4 ++--
 libmultipath/print.h              |  2 +-
 multipathd/cli_handlers.c         |  2 +-
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 0ec4527..e6c6daf 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-LIBMULTIPATH_25.0.0 {
+LIBMULTIPATH_26.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -74,6 +74,7 @@ global:
 	dm_cancel_deferred_remove;
 	dm_enablegroup;
 	dm_fail_path;
+	dm_find_map_by_wwid;
 	_dm_flush_map;
 	dm_flush_map_nopaths;
 	dm_flush_maps;
@@ -172,7 +173,7 @@ global:
 	should_multipath;
 	skip_libmp_dm_init;
 	snprint_blacklist_report;
-	__snprint_config;
+	snprint_config__;
 	snprint_config;
 	snprint_devices;
 	snprint_foreign_multipaths;
@@ -241,8 +242,3 @@ global:
 local:
 	*;
 };
-
-LIBMULTIPATH_25.1.0 {
-global:
-	dm_find_map_by_wwid;
-} LIBMULTIPATH_25.0.0;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index db0aa35..b911802 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1908,7 +1908,7 @@ static int snprint_blacklist_except(const struct config *conf,
 	return get_strbuf_len(buff) - initial_len;
 }
 
-int __snprint_config(const struct config *conf, struct strbuf *buff,
+int snprint_config__(const struct config *conf, struct strbuf *buff,
 		     const struct _vector *hwtable, const struct _vector *mpvec)
 {
 	int rc;
@@ -1934,7 +1934,7 @@ char *snprint_config(const struct config *conf, int *len,
 {
 	STRBUF_ON_STACK(buff);
 	char *reply;
-	int rc = __snprint_config(conf, &buff, hwtable, mpvec);
+	int rc = snprint_config__(conf, &buff, hwtable, mpvec);
 
 	if (rc < 0)
 		return NULL;
diff --git a/libmultipath/print.h b/libmultipath/print.h
index eb4cbc2..4dd2ef2 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -40,7 +40,7 @@ int _snprint_multipath_topology (const struct gen_multipath *, struct strbuf *,
 #define snprint_multipath_topology(buf, mpp, v, w)			\
 	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, v, w)
 int snprint_multipath_topology_json(struct strbuf *, const struct vectors *vecs);
-int __snprint_config(const struct config *conf, struct strbuf *buff,
+int snprint_config__(const struct config *conf, struct strbuf *buff,
 		     const struct _vector *hwtable, const struct _vector *mpvec);
 char *snprint_config(const struct config *conf, int *len,
 		     const struct _vector *hwtable,
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index ef5f53e..2efe23f 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -165,7 +165,7 @@ show_config (struct strbuf *reply, const struct _vector *hwtable,
 
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	rc = __snprint_config(conf, reply, hwtable, mpvec);
+	rc = snprint_config__(conf, reply, hwtable, mpvec);
 	pthread_cleanup_pop(1);
 	if (rc < 0)
 		return 1;
-- 
2.46.0


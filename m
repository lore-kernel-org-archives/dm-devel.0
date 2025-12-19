Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ECA329E7D
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155290; cv=none; b=CHvPeaG/m5Npe4fMemV7MVA6KEpevgJAjMBYNOD105qI8ZwX9iK1xwcmRhJK7LEm1C+POdrEQvdifeG5uE14+OaateWv2MbXzGJSJu4n1u0e2TEowDPhU8cpj3FSx57vky7E0E4eBCfxAVna0LuiOPQnEE6bcHOt0VE2lSvfIn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155290; c=relaxed/simple;
	bh=gG/lBkmLAt7OiQ5y800Mg19IBo+cIpz28IdhBcQXHfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sbwkb18pWX4Wu7EQz3DQSb6tZobu3cuJ4kWM3OHwIlzT0O0RQHtEBhMHc4gjh6ZmUl667Qc6SknlI66ySz/aV7SMcIhsbDpZxhjXpi/hvwzk5WDgTOjRiC83Ulj/66c0dBAm9C3py/af5ThJ4FTT6i8vaHukYlKFdhjdSBXUd8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IdwSXWSL; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IdwSXWSL"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7277324204so307416566b.0
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155286; x=1766760086; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5c+VNYLLzBBvjDYZnTFJSrPuU2e+UvcaSJ0I2bDMkc4=;
        b=IdwSXWSLrHDO07nfvdMvg0mXuI6PLgpSRHOu9VMNJodhSUZQD5jFBoNpGJ6OzAx/1M
         SmZy0sHzks5f1utZBMwKgHlGnyTq3uF0GBITko0MscaGCu6YM1HQCVXo4wt/26Ep/Kdl
         jA6M6tDkGbi274k8z5lR21UtTNxUJyeeoDn6R68NR04uUCE7pORE1K8kjMCA24U5UJNj
         Q82qJ5lPb6DEtzF+oxqcNzy3XVCWFngCTNRKd/c32SQ/4Uo5+ue8YD3lF2sHGr7ivSE7
         SLDyoAnQkaEtXce+epGFCidNUUMoRNd1XHN0h5A2hdecz4XF2nGxPkuKe0kZuFEDmZmJ
         K1Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155286; x=1766760086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5c+VNYLLzBBvjDYZnTFJSrPuU2e+UvcaSJ0I2bDMkc4=;
        b=jrcKkEC8up6YyM8+Xr3tYObarl1wCshxfa25efqyuUj4qlD1NAizdVCzRTgJrS3Erh
         V2GRUW/cw63MzG7Sut7lJOJPS0QKLSqZ938C10hKQRUbIGslqGDzKB3tiCG+whIlLzhU
         efxvIWXv9UjIJ5zDxwA8PfM1+gXn8SqzOuPr/IddjuLrGcdC7jA9DAU0u/524DpdvM1D
         ebZhozgYgNK5tEU2SvGfevhsALk+ZyI0dGyAS8pbsnHWO34WBhuGN0fmq6uGDVoUYj1z
         S3tx0LbZZ4yGfWdhjb0V9N/Fc/+5DpB/KNxQlR7TsXLwYx8KKC49xsjHDK1iK0QkJiuu
         JAEQ==
X-Gm-Message-State: AOJu0YyD2iQAKutP98Ef2MAcHWhoJgj5IymgNt1EDmZ1XZqZux+QLDum
	mLv448b+uSkNum1tKa29F72u02Q0/vrgzbeq00hjEY58O71U6DcA3dBSlFU7V/Ageks=
X-Gm-Gg: AY/fxX4nrvNZNdu0yqaGbNddfdb/aO0PcWXDcYtWivdMPtJQQQJnrWsgWlhQa5xHgFy
	Uz9p1Yzm5CCFdYIWlur6TZciusIao+V0un3YvQBSW7YYg+WCkthoZ593o8fkv7lA8HXYxM7r8YF
	LPlZ3gWNgBu0q+ubOz8T5knTzBGRQ94+b1HZ59kMT2bkecjmG6oA5k4PTz1f3lAKcfTaF4JItxb
	33qFl8DRCciHrfWqbzQ/5bhJXzvO5FvPJ2ymPEj5FAUPr6S0fgH58FUxwC/sjglG4j2ov/vMQBx
	Wzf/mThJoLeBt4D0GTww2ZR+9nxmBcZaYPSnDTnLTguMeNBhVMYRW3GVscs25mjo9K9B8Yx3jT9
	qkaxOp/jT0SIG//OTaKcVyyqjIQDSVIv1C+cetViEjU0/LGJQVTINDjckh+ZSAjjffreKEO8sPE
	taqAT9kyZHgI7r4m4aQ3NFzBIv/ildqb30IHMOz3/lb98OljShq3KUxk16quXkuo3KAjXDxGW9C
	Q==
X-Google-Smtp-Source: AGHT+IFaN8wtlmLWeoHMegckZc8t/iURh3tNYk9Oisbax1gpAL+WXT0vULRf5EIjy4T8qk4taIVnUQ==
X-Received: by 2002:a17:907:2d9f:b0:b80:751:ee5b with SMTP id a640c23a62f3a-b8037257594mr308512366b.49.1766155286358;
        Fri, 19 Dec 2025 06:41:26 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b90f53c70sm2333063a12.6.2025.12.19.06.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:25 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/26] libmultipath: don't free paths in orphan_paths()
Date: Fri, 19 Dec 2025 15:40:50 +0100
Message-ID: <20251219144108.237928-9-mwilck@suse.com>
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

remove_map() should just do what the name says, remove the map.
It is unexpected that it also frees the paths of the map, which
can happen if these paths are in INIT_PARTIAL or INIT_REMOVED
state. This is particularly wrong if remove_map is called from a code path
where other data structures are still holding references to the paths in
question, in particular configure() -> coalesce_paths().

Don't free paths in orphan_paths(). A follow-up patch will make sure
that these paths are freed from the checker loop.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 0717888..1259aec 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -383,19 +383,10 @@ void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
 	struct path * pp;
 
 	vector_foreach_slot (pathvec, pp, i) {
-		if (pp->mpp == mpp) {
-			if (pp->initialized == INIT_REMOVED ||
-			    pp->initialized == INIT_PARTIAL) {
-				condlog(3, "%s: freeing path in %s state",
-					pp->dev,
-					pp->initialized == INIT_REMOVED ?
-					"removed" : "partial");
-				vector_del_slot(pathvec, i--);
-				free_path(pp);
-			} else
-				orphan_path(pp, reason);
-		} else if (pp->add_when_online &&
-			   strncmp(mpp->wwid, pp->wwid, WWID_SIZE) == 0) {
+		if (pp->mpp == mpp)
+			orphan_path(pp, reason);
+		else if (pp->add_when_online &&
+			 strncmp(mpp->wwid, pp->wwid, WWID_SIZE) == 0) {
 			pp->add_when_online = false;
 		}
 	}
-- 
2.52.0


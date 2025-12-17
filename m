Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610142494FE
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006492; cv=none; b=gto/gt97C4WLkBROJ5YRaefIVb8k+5zaIF2O6Pc95/uYh/n5+MuOlFWVPc6lKansUk2wBrfzpN6GfoXNmJfEOzgtpafE+ukwgFTU0Rt0Gl8byptMVwPm2DU05pacLFBcA4taffCWcrXHomCzI2GgXW8j9u5OP7U0CX47JoltUAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006492; c=relaxed/simple;
	bh=8u91xg01X3bqj9M7toFohHVkijfo2khCOY2+liCFqHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUkYNr5bEhBVdv2V8ZbEJoFNqECnwGarGrIZFkPK3clUALC5d5zo4uB2GelJfZLMokk8n7pbuE2/YM/13TpdOI9yV+nHgGstH4wDTu/7tUXnCWrPgNHQBzeL/QbJ0qRURpVRKIA70dOPKzyT1UeEqrHm8+FNu74jSA1uMeq5gzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gL2r6nTK; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gL2r6nTK"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6492e25cd7eso1687012a12.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006489; x=1766611289; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e6PYmo7dcJPxeMG5kDnP6CvH7P4C3xihOR6gnKmYl+A=;
        b=gL2r6nTKfoSi7bKrZ2zpNUuTmvztP3Vuq5lWpCvNsMgZ5YWCH+ssLRXzW1j16hFNjz
         MStJdDAO0+K0s2PpBEfG8HyUBQmcets+erBWVeH4x3Jj/8ZdtZAUf/ZJNuAD2nk51j9/
         WGowCjNDSbgSooFpCdPCOA6TBPVBsIDbERDu03Nvui1x6WZ5b12AmkJr7TPrxNgbhn67
         fbz8+obhcibk57PwBg6x/cUW3VEUUoCETd+pANTLAjzWhm81KoIQeno197h4uU9G/tvT
         BKUmpZfMESsSUqdD5OM2CsheJ9Z6te6TsfJFs2Y0XHSos669W8zGq7M2FMLMZDREYGlE
         4zZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006489; x=1766611289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e6PYmo7dcJPxeMG5kDnP6CvH7P4C3xihOR6gnKmYl+A=;
        b=LOLB/0yVsotqunNgjQ8xQfpTtdb05ktEv3TgMpiC9IzYYOHuwSdHRwXj/oWve0rYzJ
         LHzRfi/M7oAinr81rfzx3Pj1krSICdMzPWQmljEab6SARHqxJo4dfpbnLqGu3krEo5ZO
         We+NgsV1BO/szQQUHctbD6vckmHDKpHJlC8wjcfFrm06yzCH9LUiBZg0PZdCaDEh+fHD
         n3uKNiZ4xWYfWG4OL32bE2HFKMldLIYIMF+D3TP5TBsKHYnE/ujgIa7Jzea21cKH1Dsw
         lAJXyPmFNLqVaLzbxsBpJvDg79dVym5OvBdXW5NJxQQorcpkfF5y3Y8WcvMlVuXFHwkb
         7qVA==
X-Gm-Message-State: AOJu0Yy7SDT0cSDmjtPxc4z/b/eSPc7+6RcTiqPz2W6iVT6+pP1pZ5bF
	sHELii1n8RTFrCxbMhusf1sbwufzmOdgqAG0norOyVskZR4RSjyygfk/xFuASFv/YWM=
X-Gm-Gg: AY/fxX6O7d9RYwU6cXc/YwJoGbRv1rF/vwb62Jjv3u37bVI5FZQVUIVs+rLt6UitHA3
	dGxdsW2eTFsd3tWjxmhBvMz3wIxGF6YgbAGC+NoIDT8KcHKEb515Vvh93dbvBT5ClEjiIDABjbq
	CnLu3FaJOiIz7RMsBV60MwDOgWEvbzN5soLJdLuHD3zPZTHJ3k/d2lZ7rPiozJr1BowgdYk4quV
	4XnhjK0vL2KFhi7K5sCXdyMdt01l+H55QnwlPh/DzZqr1ECUBPxvFLN6UFYgBua2d61tPSPhPeN
	Lo28P0kFIwoQiHNFO2gqirkPe7XzKEy1gCLBGFzBAO9Oq+RzSrkiB3lwudguY3cmX+18vHbTbk1
	fcgsylKtTY9ZCebvZBJ+PRAGyV3ZPZa9YlqtDhf94RSSOC77wzBKlyKI2uqnvKqaob3swO+lwSi
	+Js+ii0f5M6MblTBs0q6FsyB2JBPryaW3sl/zNLzhCZ12rIBDXQveY6GMZ6bAZmM/JwYRp6THLm
	Q==
X-Google-Smtp-Source: AGHT+IGJkrCg1jnJOdJ1fzskvKXbjLcDhjwxiQ+ely6YMykdhWxv4VQFg9CS4G+TpyjtTTvcKYcRsA==
X-Received: by 2002:a05:6402:2346:b0:649:21d1:9c76 with SMTP id 4fb4d7f45d1cf-64b584a3088mr748197a12.4.1766006488833;
        Wed, 17 Dec 2025 13:21:28 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b58884fadsm511006a12.25.2025.12.17.13.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:28 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/21] libmultipath: free orphaned paths in check_removed_paths()
Date: Wed, 17 Dec 2025 22:20:59 +0100
Message-ID: <20251217212113.234959-8-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We free paths in INIT_REMOVED or INIT_PARTIAL states in check_removed_paths
if they have an associated multipath map but are not part of any PG.
We might as well also free such paths if they aren't member of any map
in the first place. This can happen now, because we don't free such paths
in remove_map -> orphan_paths() any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 3344005..58c785e 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -569,10 +569,10 @@ void check_removed_paths(vector pathvec)
 	int i;
 
 	vector_foreach_slot(pathvec, pp, i) {
-		if (pp->mpp &&
-		    (pp->initialized == INIT_REMOVED ||
+		if ((pp->initialized == INIT_REMOVED ||
 		     pp->initialized == INIT_PARTIAL) &&
-		    !find_devt_in_pathgroups(pp->mpp, pp->dev_t)) {
+		    (!pp->mpp ||
+		     !find_devt_in_pathgroups(pp->mpp, pp->dev_t))) {
 			condlog(2, "%s: %s: freeing path in %s state",
 				__func__, pp->dev,
 				pp->initialized == INIT_REMOVED ?
-- 
2.52.0


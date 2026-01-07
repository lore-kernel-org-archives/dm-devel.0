Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F130338F52
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817146; cv=none; b=WK2W0RLKkkkO7kinBqmw5pvSoKVlaF7y264JAGhBMxtiQXL4wzjmPG490kjheWB+kwAN7vJLQCxk8PHc0s5Qz6shufbehF0H+Uz0/t0ukG2JRkTQZV+qltYwxmuf1FYqziGax1ZewkcYGUL22PmkvIDIBJF69uNKWsu//74DgjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817146; c=relaxed/simple;
	bh=O6ikUev0qKIJAG3tijOEIfvTN4hSQU2XNsXxK3/Mfvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Em4TnuYexzlzOXyh8rraTR1BY610WLy/W7VW7X1VOO26aTzz+uG4k5CwoWlsU07N1Bjt5MRyJqPb2LPS5avy2iCxkmcG2/XxOM2T0oxhYrcBze1Gq9lvPvtVvxkAgwjNuuAZZQZWTja8yW7xD7aBHYWbpAsUrVYQhOkViked3nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f7CxX9QD; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f7CxX9QD"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65089cebdb4so2337661a12.0
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817141; x=1768421941; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmLHYySltTC/e+TKTilJ0exq6Sn0w/luOg9q+nBD6RI=;
        b=f7CxX9QD2Pdf5fNpjIdHDaHoc+jXdLheOd2F7567TVqjdiuixTSt69BX9YCkxWqq+P
         JUdKFcr0rWySfXyCLgSnHGLleCQosp/usxT1QxoqSt8Tl4mE4q6Js3drXo2GV845cT1K
         DAhQxhA7kULkEr55Wk3zISiLfyLa+ZrtaYhfvnU7lGT263Zz+S2ZJuZzuLQ6Of/0hdlT
         qU5Gb85pI5WHkRI4rW/Cjb1OB5gDEy3G5FAiaXRor8vSFRtp63vBfgpywB2Rz2QUFxbV
         SQ5Qh8n1UZ1iepSTJ0dBoiXbjfNwCBGmRZaVKAmYTWigGfDUvNeZaK48iEONrMI4eKpT
         TZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817141; x=1768421941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qmLHYySltTC/e+TKTilJ0exq6Sn0w/luOg9q+nBD6RI=;
        b=JspJQpN5G1kakB67v/erjdTuRBrClhwBbQW9nUlOPyC6H5hLE0ezW18sncOo1ceVPp
         dE686vW8SZhWTrHIL/9tCZFJXDD127GkQolI2VDibG9XdzGtny1na6BxcZ7jSdVdy/+s
         aXdaLkYMKqZ7UFUZ/jK3lADbx9ZZQLGMqZQhkWMd3ind1+YMvcdU23+telgy8569Xj/m
         yR2oBHdPVLyEBP5BqAKumWpwwP4twmqzd9Vn5WHu4T72Ye7wKfzNduuH50OcBnDBTwTD
         OPgAJzCkT+utxhVqO3yTGu0ZokCuTNGGXjBhUFZCQWpXL0HjUST8low2C94O8j0UU3P5
         27pQ==
X-Gm-Message-State: AOJu0YzaWyKjRxH36Pv4iBtMSzRivz9QEfYvK26CnrpVO1RDxf2HIJ1H
	cHKp3YTiOrabzsDqyo2tb16vk/Xcm9FD3TBpPZbTXLmR/il6/3KMf9UmoepRVM/YGCM=
X-Gm-Gg: AY/fxX6x1ouuHTtBPxxSRXHaHhpiscTgb9UHAo46XeO3rIqh/RFq0zcfWj/ZM48mCXU
	OyuZO9XWuJDyz058aiVa1LuJdsinmZ968ICPyquHiItzoi2PcIeIHOjFHkIBzn5J474ipvaOL81
	/5bipLWxcS+9Jj3kUBGQWgXr0lnMF/IVil3CsBcvPW7jdXy0pr4r2WMEMc/WwxQYHE4oStcOEKE
	a/cH4qBx5UOtuQYi1Rh1XYqoPIVkYf1qA+6o9FY544TGdQMCIuqhghY6tcAlhOyXUHsoxdRs4qL
	ssWlqcj9kSjh6mCL9fuLzwPI3gkkfJHgiMYlYiywo9lQDUgpUXQ8/VUNbiVmEgL2j+I0PKOM6/8
	1FagLj0VDW1/g8OMw3AcLqR7DVLsCWn/a75cWC1blhO7aGnXJjCCkkmtQDMHczqzSbz0iJXG4oF
	3Ly2oxiTN3FaOGz4zIrXt16WjUW6I1uLJUj3Qk49VYfYHogUw7xnmRc73bIjWvxDKpy0rCK91I3
	A==
X-Google-Smtp-Source: AGHT+IHvNIh88ekN6yedFmeTCtlXpatXBx61XVfZYjg2JZ/Sw4k6GJ81iZfvgwknzV2tMCoEC3/niw==
X-Received: by 2002:a17:907:2d88:b0:b76:7e90:713f with SMTP id a640c23a62f3a-b84451692fdmr420903666b.10.1767817136143;
        Wed, 07 Jan 2026 12:18:56 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a5118e1sm601126366b.54.2026.01.07.12.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:55 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 15/26] multipathd: add_map_without_path(): don't free paths
Date: Wed,  7 Jan 2026 21:18:15 +0100
Message-ID: <20260107201826.323977-16-mwilck@suse.com>
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

If add_map_without_path() fails to set up the multipath data structures,
don't free the paths associated with the map as
cleanup_multipath_and_paths() would; just make sure that the paths
don't keep any references to the freed map, which cleanup_multipath()
now ensures.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c03546b..34dedeb 100644
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
@@ -802,11 +802,11 @@ static int add_map_without_path (struct vectors *vecs, const char *alias)
 	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
 	put_multipath_config(conf);
 
-	if ((rc = update_multipath_table__(mpp, vecs->pathvec, 0, params, status)) != DMP_OK)
+	if (update_multipath_table__(mpp, vecs->pathvec, 0, params, status) != DMP_OK ||
+	    !vector_alloc_slot(vecs->mpvec))
 		return DMP_ERR;
 
-	if (!vector_alloc_slot(vecs->mpvec))
-		return DMP_ERR;
+	/* Make sure mpp is not cleaned up on return */
 	vector_set_slot(vecs->mpvec, steal_ptr(mpp));
 
 	/*
-- 
2.52.0


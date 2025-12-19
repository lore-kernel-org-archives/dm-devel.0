Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FDD32E6A8
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155289; cv=none; b=tDN3bH2GdRD7+LGXAiFjFqCbNz8ZBhAC+6f245Eon7/CgTd4HJQCiUaEBtbm9zpDVr4aWL/JgAYuvQ8w1dYX/RdCnSOeLSprfhhb3FQmUc9k+bb1JuK0qieY+sAk3y9ibv/qJiD6A96/WgryGop3uHck690PrVFYYaBIxDdzxvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155289; c=relaxed/simple;
	bh=ejP//zBjikt+NRD0lIA8uTDcJrP1iNNCNwQlHIx8LUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCdFx87oSmdZBP2k50ZhH33/TeO0/M/cC3mnAqcDvq/BnEdAqrTSE+hKGwjt1V8/BkVy3h6pIfHKvt83+6wa+czkPNtPpmOyjrfq3kdkRwqbDUK30AFiI7PaIxbS/lHxj6Lh/YvwkglM4YEDqi4WAUklev3v3Uw/tL4s0b84OwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eFw49aT5; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eFw49aT5"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso1261100a12.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155285; x=1766760085; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=re8206gNsf8LeQuQjfGhX1Y9zvfQrdjKAVdsFtfeAxA=;
        b=eFw49aT5voFWEdgDpZU3ZSNr4BrauxgB+lHaBi6FzmLXEV1NEpl3Z38AgCxk8/iFOb
         xq9IXGB1zcJlxVhZQ5HXDOQhkWLUk2P7Hzuw/2cutvZX6z+f+SoZOyCcpPRyL8AE2hS8
         zE8D0iPgrKZTs6+6qNOU5r8m1AURGOEN8dBH4K+gw6ngNYVAQBhdEge/OVBIgM/+qR4h
         OEtr0P/PFop9W2MnUe3QuafVxjJb2sQEBkv7m8ii3i2N2MAKRqt8J03fmTE1NkDYvpIk
         1n+39j7DVGwgxsBIFAeb0T/zbmqI37yu3CtACxx8o2BwnnJC6YRsjyOdFQfrMo/+9MRJ
         kAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155285; x=1766760085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=re8206gNsf8LeQuQjfGhX1Y9zvfQrdjKAVdsFtfeAxA=;
        b=O4Cxx/Y7q/uX830NgGya4DPO7ZbN52qqilkPR7qikw2vCMbk964ZXZbX35EU8omUy2
         9bVhz3Gbng6HXhYS1hHggDpFIfLvYBxZ6LEvK9W/f6G1lNfp+prLfqK1H/1yc6ECwLAk
         slrQPCH9pUQy0GkKRzjcuMb2moMjTTttjKVIMxRcpNxMxms60RQjz6hPWT8P0WgoLCDA
         9z/OsYHPCMVoLplaqegWg65eBNALvQJYkBn7L+2PtDkSozcr+rTTOSMt+pTwcHTBYk5P
         hpEThXNeAyUlIjO+4jn0gP3fRaDKV6GClHs9ZIUB+3m6Xb00dzLSEvkRj+Nccu1bBHYf
         QLEw==
X-Gm-Message-State: AOJu0YzSMoXM+svC7fUhcMjenHIXEhaGE/1pRChDrkge45Qe4thg5ewx
	d++8KGo4n8rF/E+x0h2xj7KcoaUsNuHkhAfE3rwdUNGShhuds5oT6rPLJ8DlzcfGiBI=
X-Gm-Gg: AY/fxX7WHbBBTUaVfKdqsnPXC9NuCqPN5tWhymMYAGVUqB5/+YdhtE97/SjShhUryai
	OTywDOebH/q9Do7VjTVpyunrKSQXjPD33E81pvfzFP3nW3aM1lMaLKXKzFHqakoQf8FFvDoEhHM
	PQLDCk5EtWv0LUpsCVXUGp7bibTaaNRekgaDV0Pn0ZKYfBAlbYbqbXLjFjY5JJvTteA3OeMNDia
	SPRdeMS8OXWxutbpb6k6Rnampd2eHIQ+eH/8u/Ybl1OOxcoZYKA6CahgYUS6hedDnGOfYBGNqfZ
	zysLGFMldHEwtZZE2xgZCuzwBeyui8WUK58SkGF5cSYdQWXQIRt+1ZK8NTXOcZbYich55Rcew1z
	Byirjg4vmDHYiS/geQvxWcwELco6tkg55yiJPeIPqMhT5OZWlzfDkvKEKxiOJUcNHhXg7YTUwOP
	8ymOg4fXSVuD3RY63iAK17kKN2rGvNlQkgSu8Scov4YerZnpcrviLChWBD4kivjy1+AebbRG6Xm
	A==
X-Google-Smtp-Source: AGHT+IEmmTgBWGZ5E08Db0ASq6dNpzhjMy/Ds00ZonyAchJkeaSqIblnFmOxFBrYxvrp9deboN9jsA==
X-Received: by 2002:a17:907:9408:b0:b73:8f33:eed3 with SMTP id a640c23a62f3a-b8036f49371mr278729266b.26.1766155285355;
        Fri, 19 Dec 2025 06:41:25 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037ab7f86sm246166466b.17.2025.12.19.06.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:24 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/26] libmultipath: add cleanup_pathvec_and_free_paths()
Date: Fri, 19 Dec 2025 15:40:49 +0100
Message-ID: <20251219144108.237928-8-mwilck@suse.com>
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

Cleanup function for a pathvec. Will be used in a follow-up
patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 1 +
 libmultipath/structs.c            | 5 +++++
 libmultipath/structs.h            | 1 +
 3 files changed, 7 insertions(+)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 1b67b16..366b829 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -70,6 +70,7 @@ global:
 	cleanup_lock;
 	cleanup_multipath;
 	cleanup_multipath_and_paths;
+	cleanup_pathvec_and_free_paths;
 	cleanup_udev_device_ptr;
 	cleanup_udev_enumerate_ptr;
 	coalesce_paths;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index cde5991..08d8b87 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -199,6 +199,11 @@ free_pathvec (vector vec, enum free_path_mode free_paths)
 	vector_free(vec);
 }
 
+void cleanup_pathvec_and_free_paths(vector *vec)
+{
+	free_pathvec(*vec, FREE_PATHS);
+}
+
 struct pathgroup *
 alloc_pathgroup (void)
 {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index e7a0585..d89582c 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -577,6 +577,7 @@ void *set_mpp_hwe(struct multipath *mpp, const struct path *pp);
 void uninitialize_path(struct path *pp);
 void free_path (struct path *);
 void free_pathvec (vector vec, enum free_path_mode free_paths);
+void cleanup_pathvec_and_free_paths(vector *vec);
 void free_pathgroup (struct pathgroup * pgp, enum free_path_mode free_paths);
 void free_pgvec (vector pgvec, enum free_path_mode free_paths);
 void free_multipath (struct multipath *, enum free_path_mode free_paths);
-- 
2.52.0


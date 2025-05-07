Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBF81CF5C6
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 19:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644784; cv=none; b=T+HcQHkOGi4TkWJXWpOgryhuFcuwZw+AQXeK+7C7ZWHjuT1/wqIS8XfAj6cYTg7k+zhdduz8woMsd3V/4oFMYMh0ghQd/2lPVt1eWtoRH3LrqvAoItkdgFioBzYejTrmvyGCQO0R7AIQWMwaWHvh/aPgQLAGC4a+FVvE6W7dH2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644784; c=relaxed/simple;
	bh=Ut1nt2XNtM9BVxXJwzot+mdQwUSRUV3UAXY5BQU3JTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvFwyD5IKfOZuryPvU9upgwzew4nEg2D8f6g+gvS50OtXW9WX/6ZbORMd2VQl5AnRnRTBOTpaCsdEiC8knuNOiF+tY7TIaxiDSL/6GFSEj8hjyBb8TTNAjdYdgv1rR24GKA54S9reHwRkP9M0OwfcuDOT4LSO/dFMDFQkjRa6Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N9p+zaiG; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N9p+zaiG"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a0b646eff7so167848f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 12:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746644780; x=1747249580; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2eHUcfY6dvEMyMRkg91EERPPNObc0RlmyvFvXM122A=;
        b=N9p+zaiGvyT0DVXMa+07Jep1qhnvNGSTFFX/O+wAqDEsNtEHvuDydL/xQ1PmwOFy6h
         cLSSBFHih3hGuXRv37ey2K7EdrfJisDPwoWZA7rWaI9L8nxqCdsgJc4PtdvYtvur5Z1C
         C7zKYZg5laWvkiTMPU5hxS1ktFx2j03+pNjtOOgX/dW1bcbpxdb2OyoCZENFPkg0ItsG
         1tIWFa+5EhCA+EX+ypidni094FPi31Ecy03EPtmls/3EU076SVkhTTBMcQyGgz4VdGcf
         R0lgjsnYsVBFmEntlk6MNgEuh3c2K1lbUzTsVMZwF4U4uG/nYpaDWXSCsilkoLQVte6T
         6NhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746644780; x=1747249580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P2eHUcfY6dvEMyMRkg91EERPPNObc0RlmyvFvXM122A=;
        b=J7IqsMbqM69LES/E/ha5t9gUE6w07ELHie0No/0Z0EJhziMai8PIXkvVC5eHlkmhs0
         ADwOnuDZhzRXHiHvmd6eA0E3fmUQqift9EIscj4Mhd3b14oK5JtUOTRnLdIEDwUTXtJ1
         uHRcS9wbqMkizKRvxsGDKsKqOJ7BR+s87pLVckbU7QzVXkMh95B7589e+m6IoVvbZGNa
         pOh21e3xyTU0QLF7tSLl1B/7B27qWxmOjZwV8RoB2xSRBJfIOZ3Y8aKadRKdcdklwaRv
         FnSSsBqC2EFrd7SF0nOfT9KODqhCVWcohxZb/ToJI23IcwuUgLwEw0Z0SwFYw7Clro/6
         jCJA==
X-Forwarded-Encrypted: i=1; AJvYcCWhyzi8a8FLM2S7CwIoSgm2f9s9zhjYJ8dReYRDEkc+R5JJWGuHAk8P7nsaxG/RU/ljv1faCQaelQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyfGFW9XnQjoKSXgH4pMvOM+diQKOWUIP3RjRMJ7nAi1vpn0nhZ
	OIQxFMnQpmbcQrq1b+pEmh7v5MpRy3+kYiQI0jrFax9URLeNn/+NC9+fTIPOrD+QYIEO6hgw9q8
	p
X-Gm-Gg: ASbGncs4QcpMzyhQpTft8Xs3mXGMje0HmZVv4gFwBqDk2fpVyJ5EKR3VdawVK3NaSDV
	q9SLROmFurzBTg3UV7jw4FYE/pone/+xqGq5E3BjGkf6dGm8TfCPLFulZWzEEnomvUH1CL12zet
	f8QbU8MpmVpmhIML8YdjnpKi5uhFFaQOf12T1wgK97FPJNt9gbQVxKS0LjPgRnJyHfeOxA3OsCl
	XJMZuQvWPHJHzxTxNkj+AffmYcZi3Lvp5Tyxk/3X3X0he3sNge9RDDaaNSia9Qtrk7zCiL63u88
	Wb4FalQl8Lyo1KIp5X090kCRI0lLl7gSepe9UXD4TFOdBfQ2akrIQQZjNrDTo8FPZsUW0EsHMLf
	rPc3C6MJcFgXpKwb5FEDN0pgqg2aR
X-Google-Smtp-Source: AGHT+IGLpoXKtfKGgw4jY+bXys+jufUp5NMtOGbLLk5oHC9O3WD0z87yemAmv04pAV7wrz6L1blXZQ==
X-Received: by 2002:a05:6000:18a7:b0:39e:db6a:4744 with SMTP id ffacd0b85a97d-3a0b4a254f0mr3762931f8f.32.1746644780168;
        Wed, 07 May 2025 12:06:20 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a099ae0bf6sm17955793f8f.18.2025.05.07.12.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 12:06:19 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 4/8] libmpathutil: vector_del_slot: modify v->allocated if realloc fails
Date: Wed,  7 May 2025 21:05:48 +0200
Message-ID: <20250507190552.209637-5-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507190552.209637-1-mwilck@suse.com>
References: <20250507190552.209637-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We use v->allocated with the semantics of "length" or "number of used
elements" of a vector. If realloc() fails while deleting an element,
we should keep the previously allocated v->slot array but still
decrement "allocated" in order to avoid accessing invalid vector
elements.

The next successful realloc will bring v->allocated and the actual
size of the array in sync again.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/vector.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index 7f763cb..f69d644 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -113,7 +113,7 @@ vector_del_slot(vector v, int slot)
 		return;
 
 	for (i = slot + 1; i < VECTOR_SIZE(v); i++)
-		v->slot[i-1] = v->slot[i];
+		v->slot[i - 1] = v->slot[i];
 
 	v->allocated -= VECTOR_DEFAULT_SIZE;
 
@@ -125,9 +125,15 @@ vector_del_slot(vector v, int slot)
 		void *new_slot;
 
 		new_slot = realloc(v->slot, sizeof (void *) * v->allocated);
-		if (!new_slot)
-			v->allocated += VECTOR_DEFAULT_SIZE;
-		else
+		/*
+		 * If realloc() fails, v->allocated will be smaller than the
+		 * actual allocated size vector size.
+		 * This is intentional; we want VECTOR_SIZE() to return
+		 * the number of used elements. Otherwise, vector_for_each_slot()
+		 * et al. wouldn't work as intended; there might be duplicate
+		 * or stale elements at the end of the vector.
+		 */
+		if (new_slot)
 			v->slot = new_slot;
 	}
 }
-- 
2.49.0


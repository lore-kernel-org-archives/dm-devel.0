Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2385299931
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983984; cv=none; b=Qx+QwC63pB6y2kJC5KcL0mf2D00xl41u716TPDmk5mCTyAqdHDJn8JyOkSWgvuFV+l6mkY5vkEK3r09WshGHuNKQtb0H15l33P8t7s8R9vNjOB11aaaZdn43jmHsapozgWJuu5znj8meym3mxromvHimD+SkFnZpkDB3YzJ+kgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983984; c=relaxed/simple;
	bh=RAMdYJm+Ndjt1W0Mru+MzRqwONvSXmaYKek4jkV3qO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/C3x67+tqhnstWZKkSFpN1mpMLbYWRqhb9DFnannY1mU1NOkF2g3Cy6ZMAgpRSeSYCd//i66uMp3rBvIKxfs0Qi1HQ8tjKr8cUBsX3EI0obnQUNprlVBXfh4SJDP0oHcb6dw+ERZVlF3Q7sr3cJjR7tJGSW9a6NfeSZLKGHFbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OHrQxEji; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OHrQxEji"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso41911815e9.3
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767983976; x=1768588776; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DVD/egMSeK7WqNaqcTJDL6g7Ms7KGrtFT+iVTTQyqyc=;
        b=OHrQxEjiAtN2d6piyVBY9zC4mg3w/jFq1ammYylowsh+S0uZTLD9W3gan2q+MzJeau
         oXpB/Zpaq0mrLPsFrVY1o7UeX5tEUEkKv1EAFVeys8X9ogvgV7zxEw3zPj3CvrHwiCwR
         eHqyO/cN33wdVaIRO9naIOrQOGTuD8hQ2Lsw9og5tE9UMROVt3pRjd0sKLH6cDVgUTY+
         szD35G54EWpLNnCYJvKPMSGlEm+sk9Nrv6KvzvNoaaDWJsovC0kRnxrLT3nCtJCsD4OP
         Ar59BAj8muIunqnAs2mJUaegeiQXHHbO0BlpquQzihgOau0vjKWke5scl6lSdnfkzgFN
         f9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983976; x=1768588776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DVD/egMSeK7WqNaqcTJDL6g7Ms7KGrtFT+iVTTQyqyc=;
        b=lAmk4jbDs8nqo52BUeXSmwiqTJ1IC7CWsFS8rv85Fc5ZrxpyTPhk4ZkcrSnVQ0+KUZ
         p8yFW5Nd24RMJI0TaRliz58jODHO+6dI4fwmEWfeJSVyPswlZVXIbLLLsCwCMmrHoXO5
         lFqw+RGJPbGElwsn2Nt6YAsLAyko+m0ayZ8/AkYRaWySyHyqMWC6O51T7mGVj/JR2obj
         7HWloR8jZVfB/+9XCRC84lUGO2JxtgQGB2rLEsarUmGzopxd3HWwScJXBPdB2aQsjkVQ
         uHtum7k0yNsLsu4ft689/YnMLXl/rTJon3Oe34hmyO2GzDn/AektocqFSsJbPrEzQKxr
         TuhA==
X-Forwarded-Encrypted: i=1; AJvYcCVACbR8tqmQ52KUiFqeHJjG246AaAe7b733bG5Ne3OCS2FqDC6AOAe7Elb68LT+EKBwBzQqK+rfUg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwCo0o01aoBDCMBKo5nCkZ+MEa5W2P1/vsftXMz/hi+wgc23Z+4
	pd+Qj2KiVZ50uD1R4bde6bhZr94Z5HQpXgrcXRRM5XLzMpYWhcJGqzGPLdC3yYhFmis=
X-Gm-Gg: AY/fxX4gT9qcMx2cjmlKqN5mKCY6xAif9N+zvRx+PB7M1z463xCJZuUMeuaIwpsSvqC
	r4NSYUiK7L6nvccgSPqly5i0iQw4RXEfNtA34xNapbVtiVgvPcdJaLmiUmBmUKvQy017uCjZe09
	/kqrIUHY4HQqjNQz2GDO1UIai/Fq3qapHUnh591/oYqN+VByMSrFkvaZvyOzrC2QJO/4ja+BsEA
	wZm6SPlY09QH0LJyiqdszxx/9UJvtJ+k+He/35ND1sl7CXNxk18zEGYVnPR7YRrMKXhPXRyVFGX
	MulNjAE1nB82jGiUPrVi5VENa7AqW6DH893SM+9u5XetQ1HSnSa0tPKfGMYceT6oFDFlKB4WxCq
	PnzBRk5RRNJn/va34oIHXDdO55wqFnviY4MwtEZBbpMD1clLKLlALUeaODBt02NTaa1aS0UYqQ7
	6gK76CBZJxoteKzw6sb07gvjOKMlswlOlW4yFvTUAyBmDHYlhrtT+zDwy9dazdTIgK4bh6Q1X63
	w==
X-Google-Smtp-Source: AGHT+IHTcYEQP39mtn0QJklZ2+5oCrKV8CzWGZtFUjUCeO2ccBKKnAHzWUmjYs+F6kZXTJ2r7rP+OA==
X-Received: by 2002:a05:600c:3152:b0:479:1a0a:ebbe with SMTP id 5b1f17b1804b1-47d84b18db4mr125190085e9.14.1767983975885;
        Fri, 09 Jan 2026 10:39:35 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47d8384646fsm188593155e9.15.2026.01.09.10.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:39:35 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 8/9] libmultipath: find_hwe(): fix gcc errors at high optimization levels
Date: Fri,  9 Jan 2026 19:39:06 +0100
Message-ID: <20260109183907.201250-9-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109183907.201250-1-mwilck@suse.com>
References: <20260109183907.201250-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With -O6, gcc complains that we might pass NULL strings to the "%s"
format specifier. Make sure this can't happen.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 0717c83..d0a14c9 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -168,13 +168,19 @@ out:
 	return retval;
 }
 
+static const char *avoid_null(const char *s)
+{
+	return s ? s : "(unset)";
+}
+
 static void _log_match(const char *fn, const struct hwentry *h,
 		       const char *vendor, const char *product,
 		       const char *revision)
 {
 	condlog(4, "%s: found match /%s:%s:%s/ for '%s:%s:%s'", fn,
-		h->vendor, h->product, h->revision,
-		vendor, product, revision);
+		avoid_null(h->vendor), avoid_null(h->product),
+		avoid_null(h->revision), avoid_null(vendor),
+		avoid_null(product), avoid_null(revision));
 }
 #define log_match(h, v, p, r) _log_match(__func__, (h), (v), (p), (r))
 
@@ -203,7 +209,8 @@ find_hwe (const struct vector_s *hwtable,
 		log_match(tmp, vendor, product, revision);
 	}
 	condlog(n > 1 ? 3 : 4, "%s: found %d hwtable matches for %s:%s:%s",
-		__func__, n, vendor, product, revision);
+		__func__, n, avoid_null(vendor), avoid_null(product),
+		avoid_null(revision));
 	return n;
 }
 
-- 
2.52.0


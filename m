Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8930E48A2C1
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995831; cv=none; b=f/mL+NjjC49dRdVKqxntBxL7EpzYcC1xY36gH9sVTGPLs2D2vBvqnxJjlRftE1W8CatVXt81JtwkhhnLd7IC9XjCplKuNMVd2WZAPnKSMOd33buUfYCwaFHhdUZNu6zYDo1gJCJHJxHg0PpESbyTmwuALIRvb//XgQjICDPXu2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995831; c=relaxed/simple;
	bh=TUa7oSpNj1eNMkniP93X3INDtUSmE5PxmJxmfQSrUDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+qGIa7CJNKpobrLgt0Pv9mHnNkwuXcm+kY56Ge6xfmV3TzqxhFrJbozWfKZp0rNLzPOfrUE8YcUIsq9jdDg91COUheCl3cnQP9UaO/ZGxZC8YZqlbugMsIwhxz+aXqHWYCi/YdP4buA20On9SVaygNJuN3RehP5x1zkUUbEn7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D7gvncmb; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D7gvncmb"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso38692975e9.1
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995828; x=1778600628; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ai0RY7b4mUqkPY4+OBoNLY2g+X7WdZRe1cuSuIe5q+0=;
        b=D7gvncmbw5OGgUeCpscIQTdt9YHBiemQSHnl6se35GkK2UTSluTzzSV2/nWkY0sbMW
         eaf+2AF4D7tdPeZJ9toJXUoczsMFo6fn0HfF4CShWQb9BTDFu0BtyW1X2927HsrGLD5u
         gcOZlp7vM7kSehgP+lPkXTAYRBq4lsHYwMuw/MLmqFjwh+SOGzjMe9SVzOsiMB2kmy9B
         m/5rFSFXX7rZ3ipUHY7y0Jyjck+K2EsXu6INOdgmnZmI92OBRX0vln1rnMzKnXDxQreM
         1VjVsrOElvZH6Neb2Zs3Bga6bZ10/29U+4AB+C6y6tcpokA3uu8ERr9EgnExXVQqWafy
         BMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995828; x=1778600628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ai0RY7b4mUqkPY4+OBoNLY2g+X7WdZRe1cuSuIe5q+0=;
        b=nrRpWqlVBRX3lbeCdaEoYK+KiIORiK7ks/gU4D5n59SCfRH8faCmOve7H6EK3R+YZK
         0Bpy+LLbobcr9TBvut41it2KnSU3CUWrdjR0pya7L/1TELT6McGgPzSkI7dajRwQsxKC
         gVRFKPr86YpkZlHU1m7OK7C6DtmEvrkdlOsmFHQDdtb9yU8xKEf9rgzqcjtzpT/H41Te
         pRis4cU7tVhNlf3pKLZzzXbA98UueTZummWtL5JOm0c1U1D0OZ/mkvAo6tUI5bsYd4tO
         ycIs8+BCn43ywV4KBSVINVAHKeySHUvcBVnTaeFRojmJKit0ZtPEusTXQevV+l+LPNRK
         Kw8w==
X-Forwarded-Encrypted: i=1; AFNElJ8bIMS/YM1TVAfmzG7twU45IejkDXMM8yAO8QqWM6bRL4OgVOIsDIPGU5Ay7oi5/41PMk9GuWdPwQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxpQpiQwa/r1P7pAfQKIgHZFmuIGe89g0Bb31OftMchkWzt3pfX
	f6MaKqiwY6WajfW4xesY+g+30Yp5GxPwJ7IAm4Fwa3YcBBTqPUW9elTEFWs0ABwBCC4=
X-Gm-Gg: AeBDievWCZWQY+7F0scnnF0DJYbxqM2pAYG2SnEk71MJYVcIeZj3bF7Dlfq5X7H/EC/
	C3JlnpAqY4gHY/9jxThiTVPmZS8gxaTf0nP0C+S0/PJkKOc5+t2mRg4Y7GsRtOZURZgpuYt8YHJ
	YOsrQ2Nf6o/admhjiZkCC4Rf7iSz3XCa8w/CXJJuQ+NRhMRL6LSb404hRhTAw9BFW4p5dxAx29c
	daDdfM0TF9SJYHWLtx9lRfhz5A990zU9pU819GC2v49afpBr6dDnthK5Vj55OQVT3IeVVe3fI0c
	rk6NVt/cQEaWzdxW0a1nAXcFxeP79c2d2ov+HR6BnzjZqK9TJzweecQjOMWl55FzLrddYXxTNBa
	1IZmDL55Uz21XiFlyvi5ZOTZUE/IHpCHC6RqN45jN7Nn4wFwot7nEYrfrJ6WXS0IlfyE2MWe3ke
	Wq9iF/EalOKS/Wrwb8O4IOfivr3Gz2Ls4UfzsIxtBRTpA2UVAvCdHO9aSGv4parbHhWn2zqU5kC
	6eu/D7K7SCi13Hjn8J/0S6z
X-Received: by 2002:a05:600c:1991:b0:48a:75b9:5e07 with SMTP id 5b1f17b1804b1-48a98871a03mr243013565e9.11.1777995827813;
        Tue, 05 May 2026 08:43:47 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a81ed6bafsm733286935e9.2.2026.05.05.08.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:47 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 03/18] libmultipath: checkers: move checker_class definition to checkers.h
Date: Tue,  5 May 2026 17:43:17 +0200
Message-ID: <20260505154332.448054-4-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the contents of struct checker_class accessible to other code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.c | 18 ------------------
 libmultipath/checkers.h | 20 +++++++++++++++++++-
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 8a90ade..8f18ca6 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -14,24 +14,6 @@
 
 static const char * const checker_dir = MULTIPATH_DIR;
 
-struct checker_class {
-	struct list_head node;
-	void *handle;
-	int refcount;
-	int sync;
-	char name[CHECKER_NAME_LEN];
-	int (*check)(struct checker *);
-	int (*init)(struct checker *);       /* to allocate the context */
-	int (*mp_init)(struct checker *);    /* to allocate the mpcontext */
-	void (*free)(struct checker *);      /* to free the context */
-	void (*reset)(void);		     /* to reset the global variables */
-	void *(*thread)(void *);	     /* async thread entry point */
-	int (*pending)(struct checker *);    /* to recheck pending paths */
-	bool (*need_wait)(struct checker *); /* checker needs waiting for */
-	const char **msgtable;
-	short msgtable_size;
-};
-
 static const char *checker_state_names[PATH_MAX_STATE] = {
 	[PATH_WILD] = "wild",
 	[PATH_UNCHECKED] = "unchecked",
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 2317cd1..694dfa3 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -131,7 +131,25 @@ enum {
 	CHECKER_MSGTABLE_SIZE = 100, /* max msg table size for checkers */
 };
 
-struct checker_class;
+struct checker;
+struct checker_class {
+	struct list_head node;
+	void *handle;
+	int refcount;
+	int sync;
+	char name[CHECKER_NAME_LEN];
+	int (*check)(struct checker *);
+	int (*init)(struct checker *);	  /* to allocate the context */
+	int (*mp_init)(struct checker *); /* to allocate the mpcontext */
+	void (*free)(struct checker *);	  /* to free the context */
+	void (*reset)(void);		  /* to reset the global variables */
+	void *(*thread)(void *);	  /* async thread entry point */
+	int (*pending)(struct checker *); /* to recheck pending paths */
+	bool (*need_wait)(struct checker *); /* checker needs waiting for */
+	const char **msgtable;
+	short msgtable_size;
+};
+
 struct checker {
 	struct checker_class *cls;
 	int fd;
-- 
2.54.0


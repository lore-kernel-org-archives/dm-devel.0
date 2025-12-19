Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117D321C160
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155294; cv=none; b=tjabzIuvnziKDE0wmaK2DcuwZfUlHXZURsYf8sUCrGSU3PZgEN55CqOeoQl4VJOeNEUKNAq5YlFoVorlG0Pr2YZ5rDckAz5Rtlpgfm9KhDhKybsnU2H/d+d0PYClVpVdsWBUYUDNk9pPqRhNEsdV6mPbIJ0Bs0j9jhb4Xrz2Tm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155294; c=relaxed/simple;
	bh=Pp2Ov9lI5Q4i0BCkiJzBigUH1nhaxj200wCEfwCGFBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnAEQh+ezW7kR+Ej3cY7KO+bC7Kt6jShpff9xMJiZ4klvSlKOld65N8kJOONRAS5rN2xuDtBLao9C7NS2v6vQ7d3+uUfbzSf6huUQLjiWPHAK0T+sE9rV2ZKggALnNIkZsP47iEd8mIPoSHb0X3WLAXayGxHoQBwS2KOLMuEvwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UqpCrjP2; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UqpCrjP2"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64b560e425eso2292149a12.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155290; x=1766760090; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ZEVt317TIPV76PUIvKw2fSPAmywXgByAsXdcHrw3jY=;
        b=UqpCrjP2eZhLmVbVwUTBvUzLBOJdDTqg+d3Ah2EcAWZQ+pLTfQ3/4cI8O3YeeAl6FZ
         JZScy7YTZqGwW9R+E61oRhLh74GV29PdW4ioGdBaNNaBWfK5I1oFkH7vBsRWKk2ysxI6
         hpVVCq1YGLE4LybZFd4e2wzZYYmWF2Pi1oA9SBhKHnWkeHG/4Py0L5mweRD8JH0oUgkP
         ZMxoK4xJod+kgCzhlTCU9tImvToHYi5epRuR/PLBQ5xng9/KbPKicgY1xzQ8un9OJX5x
         6amKSAIYVRmNI4V2FG7/7/C19mh8pUPad1Bz8IzvlLE1rHzXvLNB5BcWyQmmkTtQISBo
         awVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155290; x=1766760090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9ZEVt317TIPV76PUIvKw2fSPAmywXgByAsXdcHrw3jY=;
        b=Plf2B6BwRqJJ4t7oU/9ibTgtb1qBjJGUKbZsnijzoApFDImHE8HRwsEFjn7s34KZm4
         qoDbApUqyIl4jz++0kGo9QIiN58XK0wbGRV8A7cG/pR07nzllhxDgVEQDmTR3m6EGrPH
         KrUGNhJg2nHJBAVcv+rQxIZqaD5GO0B/504yQ4ku3diPeWt6gUkibvERW1eCaBNiC20U
         lMCzavyWQi+rLPFDUivvZ2j0ZVnAUbcrcI/6ME828ddMuNv21FT9RWoyDVv7EeMu8K/V
         8T3TLtHS6LBqlpRY62X6z7OC93u7MN2XykbSMcoDU3NzP5v2j03wwFFJnrFhiR9bf3dx
         2Wpw==
X-Gm-Message-State: AOJu0YxhvUM1Pu3AaBz3OSjy33PfaUogVlsTGOhu7xYhVY6bq4bGKBe2
	bY0/S5WFkhq/F9+GXX8DoP8YJx27MWs10y9RxnWOSMq9TuFXSA3CzE5Fi1Fz1EjHLAw=
X-Gm-Gg: AY/fxX7VYCTy2Jg8OKO/ctLCboclRr7x0isREHaCW3ljw6x0PVgbi6yB43zu4NxM46e
	9oekJkkjnFxXe+9to3QckSwoBfUJfUq1h50ZlUgf+nclrUPjtiq0NOUIJ94+73JhQWuiQVFgTo2
	FLiWeg7wXP0UEmVLMT2lGJ+1k1JXL785bYOf+1OK3LdzlCl3doGPY6x6dXZpBUx4zxXVgXQVPzM
	fkddGQay6uCJXG9bDpIebj2h8E+tJbzj6nNQWAj21cMuvk45nnfgRvyEU5y60+FvgaqeEyOIFYw
	tvX28hdIAbB9U7ocuN/UWeyfAREPq2TwFk4G6nBJf73Aat29r5jWLGVuiXjveny7S+0MauYv/13
	9M3BH+nzyU3Vfa2GsSszUXirs5Sfo3zIjN5m6rQLRI6CsnHZTRAvgm3pzJfuyhMb+Szw3YFF9d7
	5/FI8jBPIRrzKpMYTEfHMd85qhSfI2y7HpfMM62oA0K0Ua5tZyUtuIFGvjqADQVQtmUXdwdgsLe
	A==
X-Google-Smtp-Source: AGHT+IEcTo/Nh3qhTvqGZAwcg8mDFouAZKYy7SqDOMmlZOMvpDC62aQAQY4JkR5/B2HUwpoCJmbVYA==
X-Received: by 2002:a05:6402:5107:b0:649:64d3:1554 with SMTP id 4fb4d7f45d1cf-64b8ea5cda2mr2924838a12.15.1766155290278;
        Fri, 19 Dec 2025 06:41:30 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b910601c7sm2400995a12.14.2025.12.19.06.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:30 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 12/26] libmultipath: remove free_paths argument from free_multipathvec()
Date: Fri, 19 Dec 2025 15:40:54 +0100
Message-ID: <20251219144108.237928-13-mwilck@suse.com>
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

free_multipathvec() is always called with KEEP_PATHS=free_paths.
Remove the argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 2 +-
 libmultipath/structs.c          | 5 ++---
 libmultipath/structs.h          | 2 +-
 multipath/main.c                | 6 +++---
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index f5267eb..e786e91 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -76,7 +76,7 @@ static vector pathvec;
 
 static void mpath_persistent_reserve_free_vecs__(vector curmp, vector pathvec)
 {
-	free_multipathvec(curmp, KEEP_PATHS);
+	free_multipathvec(curmp);
 	free_pathvec(pathvec, FREE_PATHS);
 }
 
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 511173d..ec8779c 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -346,8 +346,7 @@ void cleanup_multipath_and_paths(struct multipath **pmpp)
 		free_multipath(*pmpp, FREE_PATHS);
 }
 
-void
-free_multipathvec (vector mpvec, enum free_path_mode free_paths)
+void free_multipathvec(vector mpvec)
 {
 	int i;
 	struct multipath * mpp;
@@ -356,7 +355,7 @@ free_multipathvec (vector mpvec, enum free_path_mode free_paths)
 		return;
 
 	vector_foreach_slot (mpvec, mpp, i)
-		free_multipath(mpp, free_paths);
+		free_multipath(mpp, KEEP_PATHS);
 
 	vector_free(mpvec);
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 064a76b..b16bd9e 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -584,7 +584,7 @@ void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void cleanup_multipath(struct multipath **pmpp);
 void cleanup_multipath_and_paths(struct multipath **pmpp);
 void free_multipath_attributes(struct multipath *);
-void free_multipathvec (vector mpvec, enum free_path_mode free_paths);
+void free_multipathvec(vector mpvec);
 
 struct adapter_group * alloc_adaptergroup(void);
 struct host_group * alloc_hostgroup(void);
diff --git a/multipath/main.c b/multipath/main.c
index 58db288..4b8d7dd 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -436,7 +436,7 @@ static bool released_to_systemd(void)
 static struct vectors vecs;
 static void cleanup_vecs(void)
 {
-	free_multipathvec(vecs.mpvec, KEEP_PATHS);
+	free_multipathvec(vecs.mpvec);
 	free_pathvec(vecs.pathvec, FREE_PATHS);
 }
 
@@ -580,9 +580,9 @@ out:
 	if (refwwid)
 		free(refwwid);
 
-	free_multipathvec(curmp, KEEP_PATHS);
+	free_multipathvec(curmp);
 	vecs.mpvec = NULL;
-	free_multipathvec(newmp, KEEP_PATHS);
+	free_multipathvec(newmp);
 	free_pathvec(pathvec, FREE_PATHS);
 	vecs.pathvec = NULL;
 
-- 
2.52.0


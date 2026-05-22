Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F53478E39
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468287; cv=none; b=bvDVeuENbD/fjMpd+43X/SaA9auwFeESHmLgfBjI+YSDE9NIj2nwGl7CodRqF1xXyy8qFCz0Jc/FAOQ/EmUS2z/F7wLRipIil8fgUUwkJ8agn9X6IzCvJK5Y15FG3o6DpevrybVdnXbVvQat53YLxm0tZqQqrT+qClKRycRBTf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468287; c=relaxed/simple;
	bh=sAPq2SBJqBQVIIbNpy/XaOtWGYf9mRoFioGb2f3xviY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBiIykSobTIIhg4fRTQiCdmxsuZhFxX0oQ4qUrCka0x5uWaDILuqI5kla59nfgrYAzRLVhklgy+dS56r8QkUeOveLOMFcipg/DwlPqADqwf6W1BsTUp3qr3VSBciheBZtnGp7q09T3gf6bMZlYVGQfAWtdYcuL3XPhq2l3jkvmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fG8yQ+FM; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fG8yQ+FM"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4904127c32cso8684555e9.2
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468283; x=1780073083; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vy/sISKhrGSqFly8RsF5Q27zr88fnb1GUfclE7z1Zw=;
        b=fG8yQ+FM3qwISOKpTtczpiC/tLS7w0CSKMNxlLI6wjtFdfU7/r2g5bqPKfCNxpt6od
         4GqMYIT9IGdNiYueBhDG7+8i8YvS5cefdI4dkT70mjD1aaNPdgpAN4/yn/YA0nA30olA
         /uVE2ekvu2eMvBgTqpomGi//Bjd39jfBY7ZIa0J1S0q9Kr28wel9gysFZifnC3ManXEI
         GJssoMt48Z/dyQOrohaCnSEIq9V00r5g6YibLwbRyEon+5YNv6vNHUz6z+/4jSaRNFL2
         +rSuoFh1OfBMSXhJVLJ2RpQ4pjNyS9083oACke5sCYLpa1JEDvbimsyUPe2Jk40OHyUK
         hXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468283; x=1780073083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2vy/sISKhrGSqFly8RsF5Q27zr88fnb1GUfclE7z1Zw=;
        b=WYkHCdlbdJ3uznfLTcJwknTQC+pbu/okhK334dW6Ak0sJuATyY0m157b1IF3HMqw3u
         ysRxigcIzWtpT+UNzMPfMDGUJt+53Z4d2WyiTd5a26bAo+0aAWv9zX/QQnW3QVd/CKfl
         6N0QQHvTbXDH+Wa34fszap1naXAd7dWY3zw1zzc8VN2tP8fL+oxu5gjCdkfMe/An3l3p
         DqOz+Nh2hCWq1WC55HzjZjSs4K9YTSP598YeqUELiLWHum9udUv7OfPV/U7c+iOiEOJr
         E3w/qITr71YZagED0yp2t76BNPDwkIEQ3c9T1hl9aXYszAZ36kNJ7JAoPvtECQWEMHs8
         G0Hw==
X-Forwarded-Encrypted: i=1; AFNElJ/aFL1sevq32ecceAcNbeg8iJWvVehIb7uYopC1o4+hOxANjalt9Gc8sQmvfhIa95lPh5sxpNzOvg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyjBemf5idEURCXHRprWzUW92U/cJ2F3pmsOiszOKq9O2CEYtbY
	nlzJUmK6vO58dsGAcu2kFcj0doVMeAPeUVMjVpqc3pDmVrQCwtUCL6uv7pM9ueNQK7w=
X-Gm-Gg: Acq92OGZbUmQqyDETLH8mgxjtVTXuneo75ChdA/hgT3I7YTvE8DjY/KcdsL1dE+rcfp
	BVlMlv9lKlQvvIYfhw72P5Za/cfDGVb44QZJpF+zmOjI+zsiOy5GXvHXKswXpfr+B09Oi392oLL
	A9hYqdccgE5KYwC4oEly3W45mi0RygDBwf/Op1sOBpDDT8w111ibqBGLF4Qc+Y7KPtnP91djqKV
	BHFPXZcgGtG0gm6+A2NlFhMcxANiv6KV+tG8cN5xHfb+gvrX1TeZZptXouDIAr19Z+RUKTI86T6
	EExquzCxOPWfQ2FMblma0ZHi1Pq/i9PJ6mYLxDFhQjxGUiydgc1gQzofK6S79sCTFSfbb/5g2PI
	QZ1lESdIeGKC1Ocj3QVVauDJ7dK6w73suwKBhE6Opjh/KSaTG2JPRw2JDEOm/xYi2VsCMVLyzku
	f5IRr0UfPZoAaC2k8KfVr4i4LK+55qqDEMgGj/dj3HgXO2TesbkLFatEEKRQeUvsRnN5icVhXnD
	dYvrk694Yj4IUyk2YLHyIK8
X-Received: by 2002:a05:600c:4fc4:b0:488:ae6c:42c6 with SMTP id 5b1f17b1804b1-490426aa52bmr60897125e9.14.1779468282990;
        Fri, 22 May 2026 09:44:42 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45eb6d70d89sm5744956f8f.37.2026.05.22.09.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:41 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/19] libmultipath: checkers: move checker_class definition to checkers.h
Date: Fri, 22 May 2026 18:43:59 +0200
Message-ID: <20260522164415.846589-4-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the contents of struct checker_class accessible to other code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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


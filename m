Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6DC19005A
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130816; cv=none; b=TryemRnqTIJZ4J0zakf6EWkdzSmdAkDW413v1jRLlCcnNSF/UQFEpgaOOLThzbqUtFZ7Vtw8CF/FQU+aVkylWLbLuYcUFo2GqUSSPhh0vD+e8OE4WEt0qvoLxO3+mbcdnhTN/+x7DwYIHgHdjv9RrjfAZX1MGuKPSPSKFeJ1hkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130816; c=relaxed/simple;
	bh=pVXZWXSrQua8n611Zt8EOmtsCxSztxQLTwrSRRnANXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n17rjRqMjNKRGF/oInS16Y1We+vaIErdyAuONY32JuZzOMckU4J8m7xfqvsM+jbCzlstzvzKJp4M5xDVlzTgkWggj1AxFmFnPQe+Gyh/gnNcQMCWn3NadFvA7ZJgbR3eYobL8SKy9LtdSuRvglOrFup+uJsF8z/vsIvBfUZboVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BbvV7tsk; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BbvV7tsk"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a7aa086b077so112660566b.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130813; x=1723735613; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n5VGwngPIXWYCglSqN/1VkCUDMpbzk6R3QJTBWgXJtg=;
        b=BbvV7tsk4CobnEem2CF/WXX+vRSxN8MkyUGdUzw5m7bNGOTxc5yeNW1jHfmwGl4Y0b
         kVC3WMJZjyebHvPOIjyuNG6QhQSwVvRzqh7l/NZ10vBz4VY++cx58/yguggHLaIxxagX
         I3pek8lDUQt4LtbgOtReiYgDmoGY3OqdpdFqWdE3SmNFiw8OLxKNNziEySc2x6yigD4B
         rbibrcPpMo2oaFvKOcNi3gmTo02sGTDZo4KVkAwUBpB9Lzoz7DlD6ltF8VCcM7ETUQbt
         lc6C64WfBNP12g9ZURBMWdWrvb8uo/lp8Oe+OJSfr1uU1I9+wP4P3MLPR2IAvkC4NZI1
         QlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130813; x=1723735613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n5VGwngPIXWYCglSqN/1VkCUDMpbzk6R3QJTBWgXJtg=;
        b=ZrK2HAvBxrbFd5Mp/ll7VgGcmvg4hcdqP1DwuEubqLIxErgxVAKFcjq6p7bGL1GYvB
         cnch2dfRDRZ6J0d0lrbQ5CKf+8pUQPgi/tYYeRDCyQSPa0Z+NGqajeKBj1QRwQr9aH/v
         X5YyAaOtTUzeswJvpC0HwvFxiLFnV6H2v0W4O/R64122nA48sIa7JdecLn4XQsQs9c3X
         ZKrzeczlRQCHxASvW09lrQVT+Yo6oq4+q1qERFQ43uFTQ/uJvJWMfP7wWkaXnD8AQDBg
         SnDYLeYpKvTXjaVCz93cJosVdmmFfv+KCDvoJmw0HIFMVHWDZ0N8Pt6csegK/KjG5bAG
         N2Jg==
X-Gm-Message-State: AOJu0YxVu29as+oT4YXFA9peBEZloz52xVgkKbZIXdcddyNtCo/f16Mw
	E89NN5/E/F0jvIAWmRJzTOPzyT+/Dsttx16CxMF9Pb3M4w48k++Gf/Zb+kqN6MOYvAYnXNg7W14
	FrCM=
X-Google-Smtp-Source: AGHT+IFPZ9KOEaC4plyLBKjOGzdPJKq8rsTxj8L4+lHmphPFNNPoaPl1xfWWhsZfqSEpu9g7s2I2XQ==
X-Received: by 2002:a17:907:d59a:b0:a7a:c812:36c8 with SMTP id a640c23a62f3a-a8090c6b841mr169195266b.18.1723130813098;
        Thu, 08 Aug 2024 08:26:53 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7de8afba6asm606988466b.66.2024.08.08.08.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:52 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 19/41] libmultipath: rename __unlock()
Date: Thu,  8 Aug 2024 17:25:58 +0200
Message-ID: <20240808152620.93965-20-mwilck@suse.com>
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
 libmultipath/lock.c | 4 ++--
 libmultipath/lock.h | 2 +-
 multipathd/uxlsnr.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/lock.c b/libmultipath/lock.c
index 93b48db..4d18d82 100644
--- a/libmultipath/lock.c
+++ b/libmultipath/lock.c
@@ -5,7 +5,7 @@ void cleanup_lock (void * data)
 	struct mutex_lock *lock = data;
 	wakeup_fn *fn = lock->wakeup;
 
-	__unlock(lock);
+	unlock__(lock);
 	if (fn)
 		fn();
 }
@@ -14,5 +14,5 @@ void set_wakeup_fn(struct mutex_lock *lck, wakeup_fn *fn)
 {
 	lock(lck);
 	lck->wakeup = fn;
-	__unlock(lck);
+	unlock__(lck);
 }
diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index 1c05a77..38473a8 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -50,7 +50,7 @@ static inline int timedlock(struct mutex_lock *a, struct timespec *tmo)
 	return pthread_mutex_timedlock(&a->mutex, tmo);
 }
 
-static inline void __unlock(struct mutex_lock *a)
+static inline void unlock__(struct mutex_lock *a)
 {
 	pthread_mutex_unlock(&a->mutex);
 }
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 198f382..d74bb35 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -527,7 +527,7 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 	case CLT_LOCKED_WORK:
 		if (trylock(&vecs->lock) == 0) {
 			/* don't use cleanup_lock(), lest we wakeup ourselves */
-			pthread_cleanup_push_cast(__unlock, &vecs->lock);
+			pthread_cleanup_push_cast(unlock__, &vecs->lock);
 			c->error = execute_handler(c, vecs);
 			check_for_locked_work(c);
 			pthread_cleanup_pop(1);
-- 
2.46.0


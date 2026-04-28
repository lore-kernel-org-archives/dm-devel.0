Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3343F0A9C
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 11:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777377003; cv=none; b=HQcOk5YbMh8lWJARB+If8Zr3iOBjgFXdcNuDlTVLnaJWk3aN3dHKI0ZfhAvDklkogQr9awt42tORb8aW48VyFWZTDePhC387XsIaAAe+T+vaE4jHkGG29tDfqll//Jrn78JsLt365kRcAW/bmQytfRvNau6JLWyB2KYF6Ce82xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777377003; c=relaxed/simple;
	bh=gpFJQf4AObFOsHtU3IA9lsz0sUbxgDKdPGTv0ZQmIJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6/USU9MKPeMUCceiocFarExBbK+s+uieLLEaJPYpBuu9pdarc/2qZv6RKvCrJGu4lyjSOe8z9WvX/UsifNYwdqMbhSxEwMw1ILsZkYRn6PDpQXxLOqX4dovy08wFf3koTcn9+0uwPEoRv7lDD/Ij9303lkb4HnG9+i1dtfISo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N10dDUR7; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N10dDUR7"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43d77f6092eso7905963f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 04:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777377000; x=1777981800; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g42lhnlNINcQZBZhJheMtnCHh2B1q42zmfChjsOMSHU=;
        b=N10dDUR7DsqWC3nroMDD8kuMMKK9fr/Ea6rOvC+ivhCrwrunLygE45hi92Ur1TEw2H
         sbAVHT7GXxxeTIrdz9AIfIQUzPUD//T7B5FJ5beieyKjAUydfOMg9ufDNpYC3YgLcbTJ
         WDOTr48dlIYfb5vcYQXeaj+KY6pr3u/TtVP6aCzpti0uSSNBDbxR1R7pfH4kTU5eHH4+
         bnCEFnueaBv2hCqtcsciybgivlVEIfYED1KR3qKBKxYwy2rDABn3MUbIG0KFkqjJH6RE
         nqg+dUPC3bNxgUFKLtxCKB9xmeI4hLJxzSMJouO3nnw/ylUMBnrSzfWlQZRcNadcIUoQ
         89uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777377000; x=1777981800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g42lhnlNINcQZBZhJheMtnCHh2B1q42zmfChjsOMSHU=;
        b=coYMcurSWcbdpqvpW+nRujxoh/mTIg07peiZLJXZSx4ImFM5LwxmIa+gh4TWd7nLdN
         dzziK2FpJYQFuQM/aIgc6D0tTU3IZvaGi122qkk7ikjVlA711JHZtwqaWb8ZZp9Q0LYh
         QQBuS+wzWp07txJ4l+F/qm41L51tpYGe88pQvCgx5jewsKh2IEF66Hw8ok/f7t/33Y9y
         qXMgVn6IYncOITal72iatp/NK9ro4cg+rphgDeYsamutlzlHa5oddnxKBxSvmKpkHFyn
         HEBL/GgVMuqCoMqiG4P5z9h9rIGJ28Lr+WgX1NYTCGYWYYCR66KD80f00seIoEUmfw6x
         8QEQ==
X-Forwarded-Encrypted: i=1; AFNElJ+BcOmGs9Viydt05svmjYl7zMTcEj2JAaww7CuTYk4xOxhqLM8JxwH7fsgV42M4ltlV1Z1fEGXCww==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7rhai1J4ravVHAS/Oehllh/m83o9lrgVW4kU2ui5SdsNj2eNb
	SbakpODm3uEu5diqoXh5xwqzRGZCF/h1pVCgpKhGXzadh8t49wV5U8ilT5Hzv60zTuE=
X-Gm-Gg: AeBDietXPr63bQdYdgKYtH0wVC48vZcFZ74jR3fZFTh1V1TafZkRQGUenu9QRt4O7rx
	NSl6zevE3AJZ3bRDSK01XdMhyt9j759QowB5BKe79TRUY9c6ziHE2BSfOZYKcipVOPLD2r3Iqmn
	iGxgwxznnN1y9RabSpdi3zXRw3MH9QOEIr/K1rIBs3Ab77F+QgniEn21np6eXfLunrpMVCssQbk
	bEzQkCypWcDQkA17BgwJis8atq+IXJI8GL2qQcHUQY20wcU0tv27eABXaKHi+4y5fqSDFwTZmAz
	ZsykwWtwFtHoitOFxej/UUZUATvvI1nNScMMhOW9MWmjeBiv2vgY58R2muNNg+/3d1aDJLWJXc9
	+ELQLHDkHWCWNkhUPEE1E9jHHecXgrGnxjESVLtdcsTfNWRJKHSipcHsp7hEUmbTIjvmFr7g+Me
	Iu3EKUKYA8KUWBnMOPouWs+McntgutQYm2Iea5PoigL62dJ6dVqbgTXYyk+KwpxdcFxV8TZ4/xC
	TlNk04GyeeHnFYXS+yrW0Hn
X-Received: by 2002:a05:6000:15c2:b0:441:1cf8:ca00 with SMTP id ffacd0b85a97d-4464aced6c6mr3532347f8f.26.1777376999487;
        Tue, 28 Apr 2026 04:49:59 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4463d4fa52bsm6130227f8f.15.2026.04.28.04.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 04:49:59 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 5/5] libmultipath: tur checker: improve tur_deep_sleep() test
Date: Tue, 28 Apr 2026 13:49:42 +0200
Message-ID: <20260428114942.292307-6-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428114942.292307-1-mwilck@suse.com>
References: <20260428114942.292307-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tur_deep_sleep() test serves to test the behavior of the tur checker
when checkers time out and cannot be cancelled.

Up to now the checker timed out on every TUR_SLEEP_INTERVALth
invocation. That made it impossible to test the MAX_TIMEOUTS logic, which
requires multiple consecutive timeouts. To fix it, invert the logic, so
that the checker just succeeds on every TUR_SLEEP_INTERVALth call.

Also, decrease loglevel of the messages from tur_deep_sleep().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 0a312c7..6791172 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -214,15 +214,15 @@ static void tur_deep_sleep(const struct tur_data *tdata)
 	int oldstate;
 
 	if (tdata->devt != makedev(TUR_TEST_MAJOR, TUR_TEST_MINOR) ||
-	    ++sleep_cnt % TUR_SLEEP_INTERVAL != 0)
+	    ++sleep_cnt % TUR_SLEEP_INTERVAL == 0)
 		return;
 
-	condlog(1, "tur thread going to sleep for %ld seconds", ts.tv_sec);
+	condlog(3, "tur thread going to sleep for %ld seconds", ts.tv_sec);
 	if (pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &oldstate) != 0)
 		condlog(0, "pthread_setcancelstate: %m");
 	if (nanosleep(&ts, NULL) != 0)
 		condlog(0, "nanosleep: %m");
-	condlog(1, "tur zombie thread woke up");
+	condlog(3, "tur zombie thread woke up");
 	if (pthread_setcancelstate(oldstate, NULL) != 0)
 		condlog(0, "pthread_setcancelstate (2): %m");
 	pthread_testcancel();
-- 
2.53.0


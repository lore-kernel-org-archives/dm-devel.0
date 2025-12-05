Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3708338935
	for <dm-devel@lists.linux.dev>; Fri,  5 Dec 2025 08:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764923302; cv=none; b=NCv0h4DTtWrkNizXLeGrYa3LJvyk7XzqbRfG5v5BDd23b1Q/d6CegOzBp3mr4iCKDcDstMW29/byRnFpK6ENGySNIb0ormTD2HivtFRZcr+IvoD7a5YRfqOYU5sW98CSQPB4aj9M+7TTRhkYU5J9rMcbsluxDN7DSGraWWeoMjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764923302; c=relaxed/simple;
	bh=Wdqk/+AZgd3BVbTwZalMj0lsp1Fs3VqMII12mGYJT78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jDG1aH4eHi5loYeFperRkazV65xZo0dSl7coegpqmceTp488qIyZrXV2VLNJHvSrLS7AwusrouWKIg7TBiyUzhjzePQcpMHDgIFUBw/4U6oHOHlpy1YuZ97QReaoCxloVhnDyXNliGedMNU9zOdLknK1rIIMVYLQCq0wSvyA3oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SlFOlNBk; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SlFOlNBk"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-429ce7e79f8so1197761f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 05 Dec 2025 00:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764923294; x=1765528094; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6PCCiJ2KgknX76legxecoxGwC9s69M5akoKPjWJBK3k=;
        b=SlFOlNBkXTjI65P1d3zMF1VSEpbGV/Ty6B/sRJjSb9vRu0NAEAqzOaw7xBZdNMQ663
         R2spL8KngnrFTUbNBQT4mFVbfzSeYn1K1BG+OE5Wc447Rx+nv1F6V3vL6aGIjz9IIveO
         7hbu6uhVytTpbAefewsXnXCBEpDzziSwp5R5pG/lldkvX+SqDvxBSTXkLv4rbJGOm9ue
         iX1dvohgFf1nUsu+am96127Y4GY7vxpXht0qwSU9nb+tbjX5Ia7UGa8Gx9SX7Kqpanje
         Qs0be6KvX+GgKo6s72CQUq63bgjlIxOsgOORNMfe7Ry2PJS1X5xfXa1D6Y1LvfFOEmoH
         qcXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764923294; x=1765528094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PCCiJ2KgknX76legxecoxGwC9s69M5akoKPjWJBK3k=;
        b=HjrBomYlQjOMXcS6+TZqh8cvWo5c0JXM9rxTPW0Z8B3OKB9LItK7IquYTS0SJIiAsB
         5rfqr0cbsMPVL9BH9NkvbUc5aMq+f3zT6qkoOZ8aSH7x1LB61WCR4xRuGgvM/T8WvtaX
         25ZRAWcNSkMR2PIDLJTB6OEMQynzgRQPSi08Pb/NwQjrwVmdWITr9nJu/2etA/NDPiXG
         ZosOrO8jdvI2zRWwCdgP0hMauFwPDuSpusVG9fjn0nBPA8qnwQY4yyH2LWopixOBDkkT
         R9SqE7J/gNZDmnraFJXOBVZ20rjK7j1e4+vWRVA1KUlEtmdwPOu1QaErj+693ecks4ft
         +Y7A==
X-Gm-Message-State: AOJu0YzYmgsTUoY4LZ+1v9ynQNeQfvk5czTMjyvKxTsSL6Tpy9ok8pQH
	fl5VqDH/ofYW9z0YysNQUnkB4n9vy2ZaoD/pBRE1dTu8tf6idz8rq8oKKvNUZNwA
X-Gm-Gg: ASbGnctgF5JGP3/wSfdRiIDTPN6o7vwaLmmOzqs97Pm9rrXAANqEvVY6s5jSwpT7PqQ
	2YZPwVE/97XDbiZNL/p0XokxEzWj1qNwTsPBx/HUiMewvWYT+6Ri692cMvN1LVI8VRk+88AsnN8
	yjcFp4hdcrX5Te6v/MkoL5O8PmRgGYykJcxBCWFYqwd1qtQUE0vpfwzSr9oV2hM5j4uYrKLhtkO
	iQNH1cbTu0NSDMTrpNbRqhV6UtorqBm755mDuWBui6URgjpa68r7+EWFT75R+zz1XMsyGoe9e7l
	aI+T6NaNMSNad4yVo2r8BdF0DFVhXX+LQYQuJOkwakefeMYmyHgKOdbMjUca+0MeeV8wWbfTd17
	PLTr4Gq/fXtIVDqSqXUy0Pqbe4enGTZk2tmWIaSJ+iVWICNXVqQcrrFMaWxWZv4rEnb9bCGqooQ
	fSlA==
X-Google-Smtp-Source: AGHT+IEI737peIgbyJzFyh89ut/xQIGyMP7MG+fyo6psND5iKiEmdzU6TqT9DhYmfyiED8U5ML5mFw==
X-Received: by 2002:a5d:5f84:0:b0:42b:4247:b07e with SMTP id ffacd0b85a97d-42f79804086mr6036508f8f.25.1764923293642;
        Fri, 05 Dec 2025 00:28:13 -0800 (PST)
Received: from zeus.lan ([79.112.74.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbff352sm7491010f8f.17.2025.12.05.00.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 00:28:13 -0800 (PST)
From: Itxaka <itxakaserrano@gmail.com>
X-Google-Original-From: Itxaka <itxaka@kairos.io>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	Itxaka <itxaka@kairos.io>
Subject: [PATCH v2] multipathd: Dont pthread_join twice
Date: Fri,  5 Dec 2025 09:28:06 +0100
Message-ID: <20251205082806.3649593-1-itxaka@kairos.io>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Currently it seems that urcu would already call pthread_join when
calling call_rcu_data_free since a couple of years ago (since version
v0.14.0)[0] so calling pthread_join on the just released one is
problematic under musl systems. It seems like under glibc this has
several checks in place before trying to dereference the thread but
under musl it has nothing in place to validate so this causes a coredump
on program shutdown.

This is currently present in all version when compiled under musl,
running multipathd -d and sending a SIGTERM to it, you can see the
coredump happening at this point in the code.

The patch runs only the old behaviour in urcu older than 0.14.0 to
maintain the same bahaviour. In higher versions its not neccesary so we
skip it.

[0] https://github.com/urcu/userspace-rcu/commit/1cf55ba47342156cdf25335264b9774a16e0bb2d

Signed-off-by: Itxaka <itxaka@kairos.io>
---
 multipathd/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d11a8576..b30b151f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3739,18 +3739,21 @@ static struct call_rcu_data *mp_rcu_data;
 
 static void cleanup_rcu(void)
 {
-	pthread_t rcu_thread;
-
 	/* Wait for any pending RCU calls */
 	rcu_barrier();
 	if (mp_rcu_data != NULL) {
+#if (URCU_VERSION < 0x000E00)
+	        pthread_t rcu_thread;
 		rcu_thread = get_call_rcu_thread(mp_rcu_data);
+#endif
 		/* detach this thread from the RCU thread */
 		set_thread_call_rcu_data(NULL);
 		synchronize_rcu();
 		/* tell RCU thread to exit */
 		call_rcu_data_free(mp_rcu_data);
+#if (URCU_VERSION < 0x000E00)
 		pthread_join(rcu_thread, NULL);
+#endif
 	}
 	rcu_unregister_thread();
 }
-- 
2.52.0


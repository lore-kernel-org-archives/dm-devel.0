Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C774145A12
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 19:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721330072; cv=none; b=KIxt36AWmCdRjGwvemDMaHBAddyQaPoW+1aFEYHD20kR72R65aPM9w98Y9fghBjpR1v8Wn1wPl94Jg0Pv7EPiWLVy8liN1RtGcFOaL8/CSYRF1QNmNHt/Y+VjPKjxl5KJ7wrOf3/vwfETGkEolOiAxbnkOUFHC5OOSa+pv8ZEnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721330072; c=relaxed/simple;
	bh=nfAj7YTzofZYIU+z28DQZbdhsiA6ApZ5o0hBnk+PE3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDZynwETq8o/6rpA/PArOFiwewNsgq7ZtE8Dd3C/PKGuqt9i7KP3LUVkiE/FezlKCoijJfDmMFwVmW/rJDuaGv0zmw9AbAh4XKjh2qoByh6ALI4/BqUTRezivGh4XSI2Cb/Pj4eLE2Yg3/lx+WIBTc24yb35Z93L8vIjjNhabfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Gqb/j0Y8; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Gqb/j0Y8"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52ea34ffcdaso815323e87.1
        for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 12:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721330066; x=1721934866; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9WJCFuN1tvI6IUVsLnHSr7Ls9KijzOlDzyxqa86w6A=;
        b=Gqb/j0Y8au5LJdsHjGyXGCFHkb6mSk24lWmpQbwfnX2SiCnzEesVI65w2UTd8xtjPa
         PuaoBAj34mnj2t2k//sTmoVNcD6ig6hwWD6zCqo8c55HHSNyI0pOpshauBPWTAXuvwFY
         MPB0hft7Q9rpG59e7/r82V+alRCghbwI5X6+c9n1nbuRi7k/XJ4Mf4EP5u8rRjXVWfVZ
         Eqh+3gMjUjJ46Zn51C5TEoXThxh5efWFGxsZD2Z5McYVtt07FyA+0ex9+7AptD7tNOc7
         pGv2Mz/UywXfZ8+1XsM0kN9ERUa1kEMgpbf4HXz3d1HycMywJqpQKsurtGa8TmUotn5e
         ofBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721330066; x=1721934866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d9WJCFuN1tvI6IUVsLnHSr7Ls9KijzOlDzyxqa86w6A=;
        b=DUHIO5QcJ+oLmxEGNtn9WQyKB4/QaPkO/2t+71TxYbvGxaOdokhIGk0/3lfT4sxUEd
         DDiTpKon1oxvWBav103AiZ+lvmJQYxKPFeWtKjiC+84nkMY8WTmG7A7REzDePvJNd4Nl
         jIcw9mAGowa+zH3f0tPCa4Smh+CQZCdb/kbamYFOVUrMPLtZvBVON7wTYB/hHuZhzbjH
         +9tLZQ1HkOti15epXB9paldhdlVwzXugMIGX5x4U7SpzW1VRdbf6xFrOjYd6aOTbe3Wz
         nyEmRULSd3BVeL67RZ+db3O/ai3G6sULuHH+Uc8Q2EVLjqdebifMsYWrLAwZxno2s5Pr
         DqjQ==
X-Gm-Message-State: AOJu0YyLLnowMBFuf/gyuJGdOA+Mm1n37zw2m9RNFgxWGI+aOrXraV0P
	CdGkw44majSLxXNpOc6YyFVDYr1c+HFiO9vMTUQjr7mvp7XNdrb5tGlRbvVsgSQ=
X-Google-Smtp-Source: AGHT+IGpM2+ZRFY6uLXCVXBoPMqF/HaNWZbmwoOGAKTWawEwdHQtiRUPbYWMZR/+x0yvr4uN3mojyQ==
X-Received: by 2002:a05:6512:1318:b0:52c:dba6:b4cb with SMTP id 2adb3069b0e04-52ee53c3e0amr3736987e87.13.1721330066160;
        Thu, 18 Jul 2024 12:14:26 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a79bc820e92sm585436766b.205.2024.07.18.12.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jul 2024 12:14:26 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/4] multipath-tools: use signed loop variable in vector_foreach_slot
Date: Thu, 18 Jul 2024 21:14:19 +0200
Message-ID: <20240718191421.110487-3-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240718191421.110487-1-mwilck@suse.com>
References: <20240718191421.110487-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we delete entries in the vector_foreach_slot loop, the loop
index may underflow. It's not a big issue because we re-increment
it in the next iteration and use a cast to int in the loop end
condition, but it's cleaner to use an int here.

Found by coverity.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 13ed6d0..be35038 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -762,7 +762,7 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 {
 	struct multipath * ompp;
 	vector ompv = vecs->mpvec;
-	unsigned int i, reassign_maps;
+	int i, reassign_maps;
 	struct config *conf;
 
 	conf = get_multipath_config();
@@ -1748,7 +1748,7 @@ static int
 map_discovery (struct vectors * vecs)
 {
 	struct multipath * mpp;
-	unsigned int i;
+	int i;
 
 	if (dm_get_maps(vecs->mpvec))
 		return 1;
@@ -1970,7 +1970,7 @@ static void
 mpvec_garbage_collector (struct vectors * vecs)
 {
 	struct multipath * mpp;
-	unsigned int i;
+	int i;
 
 	if (!vecs->mpvec)
 		return;
@@ -2014,7 +2014,7 @@ static void
 missing_uev_wait_tick(struct vectors *vecs)
 {
 	struct multipath * mpp;
-	unsigned int i;
+	int i;
 	int timed_out = 0;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i) {
@@ -2039,7 +2039,7 @@ static void
 ghost_delay_tick(struct vectors *vecs)
 {
 	struct multipath * mpp;
-	unsigned int i;
+	int i;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i) {
 		if (mpp->ghost_delay_tick <= 0)
-- 
2.45.2


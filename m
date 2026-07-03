Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070AB1917FB
	for <dm-devel@lists.linux.dev>; Fri,  3 Jul 2026 02:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783044574; cv=none; b=W44fNWtadgvRT1XZJE+mvevrofGNYiLIql57EaGZfv587swXQqeI/VeATLmq4dv85u3QKjyAApwBzBkRQ2hsMANwXZaMNypFTI6HyNnHpTXD+yK8AWFTm/60F6XTPy6JcDkrUFryoXjGgzf1No600mQsnkKzKbtcG2H5iNwAUYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783044574; c=relaxed/simple;
	bh=AwHh06WUuyhBQBoDOa1+i90MPPyULcw/U/Rkk+ADDxI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=udoFgsF+Aj0bSPuUwcVEJPacF3iJeuxQkt4or+MliO4aCPntrp4TCJO6tXir0TYxLtvBimfl1J1Fnx6WGS9eCwBBfcQcYd/NZ3oYKxBaJp4cJvUIzrdastGpBJLzYIkldIPtkMllKTAmk5cGDV+G404b+InjFrvX2ZUSZfqsMQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CnzIcOIg; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnzIcOIg"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-847a483e344so62879b3a.0
        for <dm-devel@lists.linux.dev>; Thu, 02 Jul 2026 19:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783044572; x=1783649372; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mpHH2Bk0G92IhA+zOEFgRvW9nM8wHQ+j2eGIv35HORI=;
        b=CnzIcOIgsOi3o4qSskiydpKEUB0yR1Wg9TJBBGNHXQ46eI0mnxOZiPN1ltSNznaS96
         Pgjb0V1LLz+f9q3ju3iOqBdsgmcUHgfWoJK7pAiO95Cp4NM8v7zjHqaZdjqShoHqxoFz
         CpE4ywdtNFaXG32Cbjwjg1BenZnRBjPSSBg+Q002UXj7LbjECqBN8659e2U4B3fGpKHp
         wWVPjFY93L53PdsJE76OEbDvnpwnZmt73rs8EaOSUXrx7x5RAizcNufu4q0hrQxXE6Zd
         0BQ4BKdJh/ZfVmUTepaZrcFbcCax0TXm98I8nX1WrHfK1WHQJbrMbKWvRkwG827lpBXS
         qVlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783044572; x=1783649372;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpHH2Bk0G92IhA+zOEFgRvW9nM8wHQ+j2eGIv35HORI=;
        b=q0HqT3lWnwTXk7eu2ezenBf+oLEcIp1a/IatKim+fUafeRHELwo1XKtpj4diK7gtPs
         cCinaBeT3kMMf7CeflYD4IShNczJ+pFwEw4Dm7zsn6tqNhPJY6gSyBpyg29DaMo0PgXi
         mXoGZ8vzheYWNUWwT9Ouq2n2+kIPKOfYO5CtDTar4jGHu6mL/gw/m1LGjmI4Aw5HDUdK
         T4FUD1K2h+zRZnuY/oXKfzz+VwtbfOJ9iXQhYoewDqX0vORUGiHDdaVjWinXO0r8GFgj
         Go8gVYfdCLo8sS1hSI1QxhLtk847kMjeA5Xk+30yYZ3xCvsL8WmLK1laGAFo85Epx77b
         r6Sg==
X-Forwarded-Encrypted: i=1; AHgh+RrskKgZglt4GxQ+NdTblGerBl9GlAupTBwrozwI+cEMN4+SxzRR/N94rqJVdzazDZe1aVP6OdVpSw==@lists.linux.dev
X-Gm-Message-State: AOJu0YweatAgUH7lg/Xzuu6hj2pnFt9cGmtFnk6dh7R5E9sxYtn/e7OM
	3lThpCUr+4dC1KPGxaVaXqfxxuCXMWop8mUD1jJZ5t4cTZUzE8dQueGx
X-Gm-Gg: AfdE7ckUtr1tQSIzWY38cWWlmr0tFt4jxhQJOsNt58e8aPLXaz/6ev7UG0+t8PVg1Mn
	OBvn9BGJgsZk4dPBTUzGpDgtCWp2VBAN5nc17oiuCS1jWE3esHgdv+eamiqIjLKRcbQYVeQ+nQY
	8yVWH7HVuN7kEHnRso00FheHLuJM87nJu9PM+QVcBulSfilJVFyynj0ZR9LC+Xzf+JBFK9OVvwE
	S8tDdUhyHBHAH4YypC1YwuaVrzn6zbKNjPWipmrGDmN01vP8SHVwqZLF1CrLlNYPFaEMShhc0GS
	x05AtZcE3V60Yn9fyD3kgo3z0Bf3ps/YeVDIspevPYqrXz5pKUq9su4oHX4v9fuqsl8VUvQVOwz
	+CD9Q/RzIfgfywAVLyDwDuWcEP0dyPZVoj03vh012Fs26KrCSA9VkmxnfJVn/a9MgzcD302buCy
	8npRvrLHrh24bjs+Hpg9lelvGjjNXdvG1KygvZ8kNXAatvdAqWa/VUqNdofQ==
X-Received: by 2002:a05:6a00:2912:b0:845:df4a:2a2c with SMTP id d2e1a72fcca58-847e1769167mr2030708b3a.8.1783044572045;
        Thu, 02 Jul 2026 19:09:32 -0700 (PDT)
Received: from phuc-desktop.. ([183.91.15.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb6dcd7esm2178310b3a.11.2026.07.02.19.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 19:09:31 -0700 (PDT)
From: phucduc.bui@gmail.com
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	bui duc phuc <phucduc.bui@gmail.com>
Subject: [PATCH] dm: Drop redundant nonseekable_open() return check
Date: Fri,  3 Jul 2026 09:09:18 +0700
Message-ID: <20260703020919.7958-1-phucduc.bui@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: bui duc phuc <phucduc.bui@gmail.com>

nonseekable_open() never fails, so the error check is unnecessary.
Remove the dead error handling path.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
---
 drivers/md/dm-ioctl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index ac77dc0ca225..11574b1e2017 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2273,12 +2273,9 @@ static long dm_compat_ctl_ioctl(struct file *file, uint command, ulong u)
 
 static int dm_open(struct inode *inode, struct file *filp)
 {
-	int r;
 	struct dm_file *priv;
 
-	r = nonseekable_open(inode, filp);
-	if (unlikely(r))
-		return r;
+	nonseekable_open(inode, filp);
 
 	priv = filp->private_data = kmalloc_obj(struct dm_file);
 	if (!priv)
-- 
2.43.0


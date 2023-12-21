Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045F03C1E
	for <dm-devel@lists.linux.dev>; Thu, 21 Dec 2023 02:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rj7v0cod"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3b9f8c9307dso271884b6e.0
        for <dm-devel@lists.linux.dev>; Wed, 20 Dec 2023 18:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703126315; x=1703731115; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UfY9jeYlsk77JaUJRyJU7d/hp/FEfhghnlYnZPjzujg=;
        b=Rj7v0codZCmcUgPA9m192yYvnC8TDxHZtx2cCPERIj/iFrCxGZxXBJZmUcn5EVEH5E
         czMcUSwnb4aFJYE+22fFszfckOo0s+SnK0m9g3noWmmM70pPtPe3pvjtIX864mK1LbOn
         rUWngbwa17rT5BoUbLu+PLEu+RbpggTrqlOFf6Hyxafcr3Dm89SEUiH9f+pwHOy5S/1d
         bDmMUSC4xUj9yJlCMvYFUz9MO+LuMihzgfa6e5uZdi1QT+xzIe92FTWP1v3XvM2gO0If
         RGVPEU/V8L8JygkO2MGQbiE1g42+kLWmc3LAFxRVv2nZaEURRZH6Nj/DmnqQySETd8ae
         gKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703126315; x=1703731115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UfY9jeYlsk77JaUJRyJU7d/hp/FEfhghnlYnZPjzujg=;
        b=eY5PrT5C42/2kbaomLc+WZl6UIk7NiQKHQuAhBpXv4iIR0z8zM7tf1tMZdgF/5gc+R
         ekOzEPtzptyxyxzqaPz3Sl6HpPPpmHTbjZlrH6hSx7vxi4YNuRL3RYgIk3P/elWaaEsB
         zqPqEoCviSzfts/goTMRC7Y6ZGsA46jfDNABwxxXR6qWSyc81qBBtOcuDIgtQKQbWcQM
         azp7Dy7u6HVwdI7l6o3yhhEUIOcAFcuq1HBh/xUUzxDR1w6YLhzx/sK4n/7fdl+uS2IX
         CYHKZpPI/vnW0nmL2zEsXRtbB7cy5qCARuCOhjxOdU0kt/59t5ZSGmSlV41Vcn9azK17
         JoOg==
X-Gm-Message-State: AOJu0YxK98qWaw5+QZh0KxBRsvXHDBDezEUgZ4J0cGxsF6DrxoR/W5wM
	VayCScJLXOF9Qlc8VKrkHmM=
X-Google-Smtp-Source: AGHT+IGzHzNzPdal4g2XzDYrWhsPKlwDpk6NRRYnZ6NXG+Dm677WUA20RzyoEuPfY/JRqy12JwTIPg==
X-Received: by 2002:a05:6808:640f:b0:3b6:da98:437c with SMTP id fg15-20020a056808640f00b003b6da98437cmr26614809oib.0.1703126314984;
        Wed, 20 Dec 2023 18:38:34 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id z65-20020a636544000000b005b856fab5e9sm456447pgb.18.2023.12.20.18.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Dec 2023 18:38:34 -0800 (PST)
From: Kevin Hao <haokexin@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@ucw.cz>,
	dm-devel@lists.linux.dev
Subject: [PATCH] dm-log-writes: Add missing set_freezable() for log_writes_kthread()
Date: Thu, 21 Dec 2023 10:37:56 +0800
Message-Id: <20231221023756.556995-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel thread function log_writes_kthread() invokes the try_to_freeze()
in its loop. But all the kernel threads are non-freezable by default.
So if we want to make a kernel thread to be freezable, we have to invoke
set_freezable() explicitly.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 drivers/md/dm-log-writes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index f17a6cf2284e..dabfc856443a 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -432,6 +432,7 @@ static int log_writes_kthread(void *arg)
 	struct log_writes_c *lc = arg;
 	sector_t sector = 0;
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		bool super = false;
 		bool logging_enabled;
-- 
2.39.2


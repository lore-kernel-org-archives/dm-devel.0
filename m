Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46E515B57D
	for <dm-devel@lists.linux.dev>; Mon,  6 May 2024 21:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715032550; cv=none; b=tB7N5gNewbFfs9xGmbglfBEU06R7ykL73P6OKLEP3ajVc3vMdD804yHDVmVA5mX5/eqCVoON2wLVXgHJ3nOR6Sd9RYLULCILYKSyHL4b8kUGJj/MRZ95fnZF49YRu5HblkQAHD0Fhpqno7xhXFWgBCkTZHQ2NcqYmEXtD7aw7yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715032550; c=relaxed/simple;
	bh=SA8Jtq3Nmo3MmYOvGQLJ+kBvTLo1Lye9cx4hkFxUG3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eplmNchbO8AKK3fXOlZZ6ZKJwXi+Yryu3eBpxCP6koVEX38pIl+G5e+Ww4MPVR+W6KBVvwyRXOzsM9/wsdS5vj+b6AaByDDjQNFLjcV7b3jldwi9d9M7cu17CFgj64wdJqXkg7NpeqGJczxFk5ubnkQKbdrZ0/aHrP/+Nc2pzTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YWiOqay6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YWiOqay6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715032547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o9UvXxpw4TcNlgBW4XWGTOE41mSSMmsofazmjQit2kM=;
	b=YWiOqay6GJFNUTMbZ+JecvGHvg/I2cw5Hc3gfXWjdW6WCEvXoHw04rDQNGqZDv3McGL4yc
	9oQRIwTvBIaURPm6PmQYCCjJUu6McXNI0XwjnjwgNCJ0Jh9yCMckeoCfAJaqtKjyVd+gXE
	6eGvEutW3UKhu0NTENq1s0G4t5HwAI0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-f2UE1TvCOeiGrbUsf7Z9nA-1; Mon,
 06 May 2024 17:55:45 -0400
X-MC-Unique: f2UE1TvCOeiGrbUsf7Z9nA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6AE11C05154;
	Mon,  6 May 2024 21:55:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9792C2026D0A;
	Mon,  6 May 2024 21:55:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 446LtiXL005349
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 6 May 2024 17:55:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 446LtikD005348;
	Mon, 6 May 2024 17:55:44 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Christian Loehle <christian.loehle@arm.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-delay: fix max_delay calculations
Date: Mon,  6 May 2024 17:55:44 -0400
Message-ID: <20240506215544.5340-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

delay_ctr() pointlessly compared max_delay in cases where multiple delay
classes were initialized identically. Also, when write delays were
configured different than read delays, delay_ctr() never compared their
value against max_delay. Fix these issues.

Fixes: 70bbeb29fab0 ("dm delay: for short delays, use kthread instead of timers and wq")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-delay.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 5eabdb06c649..1c424983c042 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -240,19 +240,18 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ret = delay_class_ctr(ti, &dc->flush, argv);
 		if (ret)
 			goto bad;
-		max_delay = max(max_delay, dc->write.delay);
-		max_delay = max(max_delay, dc->flush.delay);
 		goto out;
 	}
 
 	ret = delay_class_ctr(ti, &dc->write, argv + 3);
 	if (ret)
 		goto bad;
+	max_delay = max(max_delay, dc->write.delay);
+
 	if (argc == 6) {
 		ret = delay_class_ctr(ti, &dc->flush, argv + 3);
 		if (ret)
 			goto bad;
-		max_delay = max(max_delay, dc->flush.delay);
 		goto out;
 	}
 
-- 
2.45.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5648C157A67
	for <dm-devel@lists.linux.dev>; Wed, 15 May 2024 18:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715798918; cv=none; b=fpw+AXJOyo5+TMUu8sjPJKi0D32EK5B5UOVeDo5v8C28HKIC8nYrJd0DM5j80R+A27c9AoPoUxjoJcuy/d1Nu4MHHW+cZIxnlFlnoGlATr8YAT6Xo8zbHjgfj4tRqk2wcMReHO65wu+OPRibs0LWxqyVuf+9Vg3BztUHWbv4Xvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715798918; c=relaxed/simple;
	bh=1AYh4AZgud8pZ5jkp3Qn10r7XNQRpR+F9hEdfptzNH8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Z7Nvah1QXxWvRLveqKU6sfVH4LV46pYpBUmZRmrNJuHjeuNvdmBgglMBO/17GHaW0jZ7Ok6Pub/ddVZA98t+19qUagrY9BuZQ27kGSS5zEiwMGJ4Z2PGrcqxdUbkZ6dkwAkEfLYGynZBs0/uY+5kYt+kq2l3m5qeIxoGpqDeEvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ss7IIDyf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ss7IIDyf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715798916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xd+R8/9IDMX4r9RGDIR4YxH4ubN2ckUYViNmkbcyxK0=;
	b=Ss7IIDyfLrZgGAzyBhQv1zDgzVaZ272OShbVCUdozJ8CvqspCt2iARxLT3xOpaYfTXaHjg
	XEwpW2kW/OAZ7Ra91MBGqOJsMc7YUUoxuKRPNHVi6GXYvAUFAHAiRwbu28OrYsesiGapvL
	PlS8HOtVwX8srnQvIZ5aCNXvx6dmO/A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-637-UE48TvaAMwu3Ly2rP-IX5g-1; Wed,
 15 May 2024 14:48:34 -0400
X-MC-Unique: UE48TvaAMwu3Ly2rP-IX5g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A0743C00096;
	Wed, 15 May 2024 18:48:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08A5840105B;
	Wed, 15 May 2024 18:48:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44FImWIB121958
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 15 May 2024 14:48:32 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44FImWan121957;
	Wed, 15 May 2024 14:48:32 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: remove unneeded kvfree from alloc_targets
Date: Wed, 15 May 2024 14:48:32 -0400
Message-ID: <20240515184832.121949-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

alloc_targets() is always called with a newly initialized table where
t->highs == NULL.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 88114719fe18..d124e37dfb00 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -117,7 +117,6 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
 	n_targets = (struct dm_target *) (n_highs + num);
 
 	memset(n_highs, -1, sizeof(*n_highs) * num);
-	kvfree(t->highs);
 
 	t->num_allocated = num;
 	t->highs = n_highs;
-- 
2.45.0


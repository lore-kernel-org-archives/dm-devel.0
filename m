Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA792904
	for <dm-devel@lists.linux.dev>; Fri, 21 Jun 2024 03:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718942134; cv=none; b=VQZlJeEuC3X4E0yZHEWQ0lOizgLkkjLMFMeqvHBHXLWI2WraZwNywu+Ua9Yatf36qkAnAh3L2ttrQmciMZcv2rHrNE+Cn0TGkSwz0U45RmzAhiNUVOUXIh/dJH+uCwMD9waZ2z0UN131wwqcCN/FG3Wo/mIYbZ61YC8rG7nBsGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718942134; c=relaxed/simple;
	bh=BUShC/j5ZJOltmNv9bSy5MavE8zdoZcZSVKHoSMMyNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uCa0fJsIl+JbqhSXIPNL5eT/fi3vr0MifpJtVL7Lqv1vbhqGruiBIHbc5veEPPZcEQ1cNdamobZT829DPjtoS3u3p3wsoauLnVHtBUM1BhV50TblQ4kj+qOFOp5R16extAD9vRGyKnWjz3yz+s4CSeLy+sG5f6bC3X9o8HmilQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ux6t7iBh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ux6t7iBh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718942131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=13YS93zueXmgu148S4IJJCOQ3CHgvWUqYe0RJFBv8wM=;
	b=Ux6t7iBhCCW0J3dXZY4h9h42LyGHUVdseMKtMWo8RdsvQG2LymWoJApRmpbTEGoI9y0JYY
	2WrbuWJa6SuAHs2gEIm6T7D9x2NBxxT1Bk4Fo/SA0VMt5edRdv/ebAIEc/njzr6nVBM3Yw
	EY3N6ZjrPts/9IXAlfXkIKIp+EZqu98=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-rvsGZ0_TNWGSJz2ernCmew-1; Thu,
 20 Jun 2024 23:54:48 -0400
X-MC-Unique: rvsGZ0_TNWGSJz2ernCmew-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D46519560BF;
	Fri, 21 Jun 2024 03:54:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFE3A3000218;
	Fri, 21 Jun 2024 03:54:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45L3sjOg1194270
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 23:54:45 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45L3sjmW1194269;
	Thu, 20 Jun 2024 23:54:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm init: Handle minors larger than 255
Date: Thu, 20 Jun 2024 23:54:45 -0400
Message-ID: <20240621035445.1194261-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

dm_parse_device_entry() simply copies the minor number into dmi.dev, but
the dev_t format splits the minor number between the lowest 8 bytes and
highest 12 bytes. If the minor number is larger than 255, part of it
will end up getting treated as the major number

Fix this by checking that the minor number is valid and then encoding it
as a dev_t.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index 2a71bcdba92d..b37bbe762500 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -212,8 +212,10 @@ static char __init *dm_parse_device_entry(struct dm_device *dev, char *str)
 	strscpy(dev->dmi.uuid, field[1], sizeof(dev->dmi.uuid));
 	/* minor */
 	if (strlen(field[2])) {
-		if (kstrtoull(field[2], 0, &dev->dmi.dev))
+		if (kstrtoull(field[2], 0, &dev->dmi.dev) ||
+		    dev->dmi.dev >= (1 << MINORBITS))
 			return ERR_PTR(-EINVAL);
+		dev->dmi.dev = huge_encode_dev((dev_t)dev->dmi.dev);
 		dev->dmi.flags |= DM_PERSISTENT_DEV_FLAG;
 	}
 	/* flags */
-- 
2.45.0


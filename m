Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BBB19478
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850718; cv=none; b=HHmLUPeHz/VutAIDiRbxtGQ08PwW1xP2V5by5QfWkS1nYJygkOYNoEsNfYk3skX+Ih9id40mNUAqQnUV1n5A7B03V9vQ7X8SXyOX66cXVwjIAOUwdu0z7gCl2uv1fcvGq8j7hHF5qVJfkYQonCT3b9SXarwKQN9feCkpxndYbv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850718; c=relaxed/simple;
	bh=ZKHDUZJy1OIWdQDzl0hD/hEmcyAcrjhR+4vKf7TXLmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WcqbTvTNyWDMs9fxa69gQ74i96NRVG2mdvCDOBfqdJ/mgx65jEjghkSLXAPUp72JexaLsrNOVHoNQfgJRRcgzOuFnZ5olSqhe1oHR+QPYNBycAmKpc+V4L9qax6jFs9e9moZCj4eZbDXb1JiMa4gyfhPRG4Tce16OR8FOEmD8v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cz09yXXc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cz09yXXc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PF0b7A/ozjZrD5535kI+QlzRaSCtmp1I3uKUQtdRyj4=;
	b=Cz09yXXcQHTMPcyY1c1tcYwqLt+9W7RExJJ0F4hikRo/ulj4d1lXH9oo3ezrhpYUBYsjaj
	HjI3rp2nqr5y6cLmsCBOMaBBpQVLdVjbu/pYMih+KyiME4f45w2LnS0k7TV8dLiRe2Yc3i
	3+kjK7rxuvdfZ2xRS+PycIy/Z0q7OEY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-JejWUkEcMDOU8YPNnRVDdw-1; Sat,
 13 Jul 2024 02:05:11 -0400
X-MC-Unique: JejWUkEcMDOU8YPNnRVDdw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87F8D195608B;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BEC61955E80;
	Sat, 13 Jul 2024 06:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D658na2015526
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D658Xp2015525;
	Sat, 13 Jul 2024 02:05:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 08/22] multipathd: check paths immediately after failing udev initialization
Date: Sat, 13 Jul 2024 02:04:52 -0400
Message-ID: <20240713060506.2015463-9-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

When handle_uninitialized_path() moves a path from INIT_MISSING_UDEV to
INIT_FAILED, it has already waited for conf->retrigger_delay seconds. It
might as well check the path state now, instead of waiting for the next
iteration.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d6f4704b..234fbf7d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2672,7 +2672,6 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 			 * place.
 			 */
 			pp->initialized = INIT_FAILED;
-			return 0;
 		}
 	}
 
-- 
2.45.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8786172BD0
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 23:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629781; cv=none; b=cvDeXSwKMwkUwTD9wc34azw2aOLoz2enykiUPHUsB7Um4F4zOBtWvc5BuB9BBf/EMaWCcIkfnHfBnVpkpmce/TJ3FXykcP7A3/fCxjxQX8gfu+GSy+/Syj++6HKbL2N2svf1e2QgfF1h+99TvzxFaszUwdg6ZS+ppRSay48gMXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629781; c=relaxed/simple;
	bh=iXNr76swc7/JyTsfXNMPbKiu9pZQPgks7bCpE5fVZEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xb/5Gn3sJBZ8vpcGz6QTp0zb9WgHofRkxyG5xf8R6XaWfgaXGZrRwUaH4C0UQkJbjhjg3GSg8OEEPW00x9r/U4sBohHHHdydD/hzc1wH+4qyxWiT1yQ24P/BoimqnxpjnsMp7cnlZN69qrZzBLw4XAXe1+pTUEEM8xOMVvkzuLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WvYxGqqE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WvYxGqqE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717629778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NwXm/+DvWFd7HxEM7exrWjAjSiUWTrSP5Ahy1nMeo6Q=;
	b=WvYxGqqEQEovRigypVO5Z3BHk7mOmMDo59yl1sV7jVvdSHzC7JLmJyKVSf7semwXOcmoO/
	JojamNsp71m67d/TeDWHUZmB7SnFwddDA56bBP+fxMN5kWD7JR6eG4ykhN1KWTwcCfFChM
	FAtFXPQqvrtwUsqIk4F8YXPxE3z9plE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-vpFLB0eBOY2A_gkyRB9X4Q-1; Wed, 05 Jun 2024 19:22:55 -0400
X-MC-Unique: vpFLB0eBOY2A_gkyRB9X4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48E91811E8E;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 420152166AFA;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 455NMtPf623314
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Jun 2024 19:22:55 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 455NMt1N623313;
	Wed, 5 Jun 2024 19:22:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/7] libmultipath: check for not PATH_UP in detect_alua
Date: Wed,  5 Jun 2024 19:22:49 -0400
Message-ID: <20240605232254.623290-3-bmarzins@redhat.com>
In-Reply-To: <20240605232254.623290-1-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Previously detect_alua was setting pp->tpgs if the path state was either
PATH_UP or PATH_REMOVED. Setting pp->tpgs for PATH_REMOVED makes no
sense.  PATH_UP is the only state that path_offline() returns where we
should set pp->tpgs, so just check for that, instead of checking for all
the states where we shouldn't set pp->tpgs.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e2052422..380e0e95 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1087,7 +1087,7 @@ detect_alua(struct path * pp)
 			return;
 
 		state = path_offline(pp);
-		if (state == PATH_DOWN || state == PATH_PENDING)
+		if (state != PATH_UP)
 			return;
 
 		pp->tpgs = TPGS_NONE;
-- 
2.45.0


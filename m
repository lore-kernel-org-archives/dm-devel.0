Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C21111183
	for <dm-devel@lists.linux.dev>; Tue, 16 Jan 2024 07:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UN79VwIc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705388713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pMnQZG7wDXglE+rhv8J/VfMeFAl/3dR3jRBTo2QuoTE=;
	b=UN79VwIcdjuBf8ij7DS8nmk21N2DswVYQW1zfji/aPBN/ihQ+CmBJTTHpYrCMeBocldOdx
	FCvqPKobXzbZS3cBJjVPhPIQnQpbzLhfQ5gq5PHBNRfZdi7wZ6mxpjkOPBF2c+XAiPf3kT
	wluQra6kH0TdAK7MeINmjNBmZT7y8NM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-l7oqMDEDNmeXVS4JELoHIQ-1; Tue, 16 Jan 2024 02:05:08 -0500
X-MC-Unique: l7oqMDEDNmeXVS4JELoHIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25B5C811E9C;
	Tue, 16 Jan 2024 07:05:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E864112131D;
	Tue, 16 Jan 2024 07:05:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40G757Z7010578
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 02:05:08 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40G7573b010577;
	Tue, 16 Jan 2024 02:05:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/2] multipathd: fix null pointer dereference in uev_update_path
Date: Tue, 16 Jan 2024 02:05:06 -0500
Message-ID: <20240116070507.10563-2-bmarzins@redhat.com>
In-Reply-To: <20240116070507.10563-1-bmarzins@redhat.com>
References: <20240116070507.10563-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The Auto-resize code added a check that deferences pp->mpp without
checking that it's non-NULL. Fix it.

Fixes: 981b83ad1 ("multipathd: Add auto_resize config option")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 74f6cd92..fbc3f8da 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1630,7 +1630,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				}
 			}
 		}
-		if (auto_resize != AUTO_RESIZE_NEVER &&
+		if (auto_resize != AUTO_RESIZE_NEVER && mpp &&
 		    !mpp->wait_for_udev) {
 			struct pathgroup *pgp;
 			struct path *pp2;
-- 
2.43.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9AE1DF983
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309904; cv=none; b=NpIimOQvWmuyOpTEASM8Fcs9QcNKxCdCFW0hUW/ndDQZdOj4SpA2kLnRuh4FikQMkEsoJfxvupUinkvl/0rpfZ2+lJQuLIghMEHdWiJMF5ADuNAlyZOVJbOkUNGzDRTCUspQHru5gvvEoiR5XiPgwrvKKDIGRp1wI9u9X2sFExM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309904; c=relaxed/simple;
	bh=JUIzH9TzWSydGAH5Joqz9z3FY7nSKxo3remZW+zTAo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Iskk3iW9ZcAYfRVcZjpQfThtPV52mGprfidfkXYmgD38joKek2WoLt85YzAUSCU5X1l/zy9fjdoLQhF6KYEcMv5BA3dlIOwJZeXMnmKAf2QRIDhpFO7WHa4u5RuKydek3FCnVwJdfAFCF6GadpAgDRz7Rg+nEvro16ciH5fBQAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HBt4Wqk9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HBt4Wqk9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aj0lv6ee3CDib+HrfiUTl7DmMB8KXKwTOZuG+o3CZFE=;
	b=HBt4Wqk9KWx5PJ+2IKJ0fYj0Oakh5q6iuN1akhKturYSPcDaAtrnS0PMcS2gV8oXdUyL0D
	S5Ughac0wy3xiv7Nug/V8dXguSOS+6eMOgq5dnrL//Z9BE6p5mvXlvOs5/168LtJqUS+gD
	i6rOHe8ZGP1XuFm4vcVYRHsEFpMzN5w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-1vyqTDsDOR2Lw6nQ4qzTtA-1; Fri,
 22 Nov 2024 16:11:38 -0500
X-MC-Unique: 1vyqTDsDOR2Lw6nQ4qzTtA-1
X-Mimecast-MFC-AGG-ID: 1vyqTDsDOR2Lw6nQ4qzTtA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9095B1955F42;
	Fri, 22 Nov 2024 21:11:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 502711955E9E;
	Fri, 22 Nov 2024 21:11:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBaFm718935
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:36 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBaAx718934;
	Fri, 22 Nov 2024 16:11:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 13/13] libmultipath: reduce log level for DMP_NOT_FOUND
Date: Fri, 22 Nov 2024 16:11:33 -0500
Message-ID: <20241122211133.718861-14-bmarzins@redhat.com>
In-Reply-To: <20241122211133.718861-1-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y9FXtC0NVBOQ8-ogbkpRkyIbmrGB9nYD8gudHr8wBMA_1732309897
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

multipath make many calls just to check if a device exists. Don't warn
on each of these.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c96e4b22..d4dd9540 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -727,7 +727,7 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 		condlog(2, "%s: dm_task_get_info() failed for %s ", fname__, map_id);
 		return DMP_ERR;
 	} else if(!dmi.exists) {
-		condlog(2, "%s: map %s doesn't exist", fname__, map_id);
+		condlog(3, "%s: map %s doesn't exist", fname__, map_id);
 		return DMP_NOT_FOUND;
 	}
 
-- 
2.46.2


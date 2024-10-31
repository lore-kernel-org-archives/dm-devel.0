Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D361B85C1
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399592; cv=none; b=XlsylIBiTL88tLlTzs2pQW/pXcKtFehXfQBGn6CVHVNRHiJ61+YZuDkOmitoZWyht4BO9ANLjMQzXAq6h2IDAaxPNbsn03tQXwEx57onO5EOhTuiuOpq5U2rz4OjAoioxdzhvMfD61vBu1W/GOnrytd6AurTmGcMJjcANn4tg8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399592; c=relaxed/simple;
	bh=hPSRmMQsP4gqCzJFSirN+h9nNoTTArk52xeJDAsIhc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oFQHSwheFgOkBOJBNJUtMgWqfpYYCjfs0i+s5KIKdyTUFtz88uoqY4iEV8QH975qV/TnSA01lAre9dnZG/64duwmTuy3ix2TwH2a9HgIYABVinOGjybn7xDB0tdsilPwc1xj4HMK3iK23t5UTtQxnOHNFKAM3WQvNIhHRKURWnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=biIPqYUA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="biIPqYUA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730399588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8f+HC8MXwj9bgRGiMLAXIG750/pq/jxT9ClhMMS/Skw=;
	b=biIPqYUAt+KwCMmQ/J/kMrjT2DeL430HvDfNLN4+r0EGvMmlWgFN7+hqUHTLUscnYM6SLr
	nJ2x8uJIatKimheloZvXlXTw7FnpBzp03xKMD4+7Kxxv0CqgyY/u6++0WO5omgsxK9bW+R
	kahPzQOzgjTcW038LBrDfV/eiptq2Cg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-kL8CmqoUMFqfC3K2luNHZw-1; Thu,
 31 Oct 2024 14:33:05 -0400
X-MC-Unique: kL8CmqoUMFqfC3K2luNHZw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6798319560B5;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 120861956054;
	Thu, 31 Oct 2024 18:33:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49VIX2AO391445
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:33:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49VIX2ke391444;
	Thu, 31 Oct 2024 14:33:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/8] libmultipath: Don't fail dm_get_maps for DMP_NOT_FOUND
Date: Thu, 31 Oct 2024 14:32:56 -0400
Message-ID: <20241031183301.391416-4-bmarzins@redhat.com>
In-Reply-To: <20241031183301.391416-1-bmarzins@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

DMP_NOT_FOUND is not an error.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 41c6ae4d..33eadb12 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1265,6 +1265,7 @@ int dm_get_maps(vector mp)
 			vector_set_slot(mp, mpp);
 			break;
 		case DMP_NO_MATCH:
+		case DMP_NOT_FOUND:
 			break;
 		default:
 			return 1;
-- 
2.46.2


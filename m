Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C1F1DE3D9
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646554; cv=none; b=g7I9ovOzqKVm0/DsMnoDVRMzfIjspcdZ3QwBkkP+mfXXW8nDDf3zzKneCMZGfrWVQxZisWObGDIO/w/nsa6Q5WkQsj6175YDSD3ckdGgOc3YIfq1cLkwQnFMjOffYLd3tDoNeJMLbABImMNRuFlU6ys2fxl79OmhtROsTYCCnEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646554; c=relaxed/simple;
	bh=rxv/lhjNtXKLxdKMn4Qx7CUIQs+Uimn2lRRa6OK9IvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=aq8sZP9/8PJdEU7hsOiUJMsuWUTDEvSTgoufgapeMia/7CjieUuXTAa/+ADZP39YCVUZ4b3maRsDGTLxXWqdJv+5TFqb6E5mDlcRD24aWOIrK0d+7kPCSYWOuoZAd7kVRQhloLwv2V1nCAJDBE+q2+Ns1+viLLgPSo1HPqu3sss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O9zfNhGg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O9zfNhGg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732646551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DY8bc34GU0/tnbshqYoGeUcxS87DW1VgPbW8NGk3b2w=;
	b=O9zfNhGggfYcya6bB0kxcRZ46yDzNJqm4OioOUQPhPWVK/L+K/JT2OpTKmaewAsHgiyVJU
	zMi3RGrNsluZX6L05O9gIb/sb/M25qbgPbeY+9X3Q+nPKpg+BWBfvnxWLlix4BbkjY7Kk0
	viyTb8458zaypad1Tq4QZLHX3m3jLgs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-0Olx5CJ6PRqS04oA4K34cg-1; Tue,
 26 Nov 2024 13:42:29 -0500
X-MC-Unique: 0Olx5CJ6PRqS04oA4K34cg-1
X-Mimecast-MFC-AGG-ID: 0Olx5CJ6PRqS04oA4K34cg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F3731955EA7;
	Tue, 26 Nov 2024 18:42:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C392E195E483;
	Tue, 26 Nov 2024 18:42:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQIgQnr855520
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:42:26 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQIgQkj855519;
	Tue, 26 Nov 2024 13:42:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 10/12] libmultipath: assume device is in use if dm_get_opencount fails
Date: Tue, 26 Nov 2024 13:42:22 -0500
Message-ID: <20241126184224.855459-11-bmarzins@redhat.com>
In-Reply-To: <20241126184224.855459-1-bmarzins@redhat.com>
References: <20241126184224.855459-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3TiXlaUbiQTFspfsM9IQkQXSV2v39DDsrDC7NKKTqX4_1732646548
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If dm_get_opencount() fails, open_count will be negative, which means
mpath_in_use() will never fail. However, dm_flush_map__() will
eventually fail. There are multiple callers of dm_get_opencount() that
run when trying to remove a device. All the others treat a failed call
as if the device was in use, including one that will later be called
directly on this device. So save ourselves the work, and exit early

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 751b45d8..3667c51b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -961,6 +961,11 @@ int mpath_in_use(const char *name)
 {
 	int open_count = dm_get_opencount(name);
 
+	if (open_count < 0) {
+		condlog(0, "%s: %s: failed to get open count, assuming in use",
+			__func__, name);
+		return 1;
+	}
 	if (open_count) {
 		int part_count = 0;
 
-- 
2.46.2


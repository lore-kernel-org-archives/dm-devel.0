Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502D81DF27B
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646555; cv=none; b=Sh+pJprvmhgmZ0IxER/4rvQhET2eq93keRw6f6hvu7x+5BxvAWubVIQGOB2zW6pa87hLLzimYSOuxLKlFB+ZOQTxM68keeeWM5uk4fyweGdpNb0I2sISgEU5LLvnkX5YRk2rgdYCW+M7omnEOSKUGIkZokRvsrd9RPDhaoHehks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646555; c=relaxed/simple;
	bh=rIiLbbUT7H9Lh0o0CFq7Vy+5KpS3C/gWag6s792YggA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=kelKCyaFf/r3eDy1ZjB5+GnupawW2OareknGLhZgv/xaehb4kbmk6yrRXOJs9wYmO6TagNvIT774s/oWjNQMbilEdH9URhIZ36Leen569flR5RZKoBpOYkq40wqhygrLhyCcXMaX+cS4t1V/qjdLk0phGGCdGLjs/Qx/5LoJoqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TrHcjUMJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TrHcjUMJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732646553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EfoinIm5zgtkMK2QuGDp7usZuCqpFZVxx3W5145qfx8=;
	b=TrHcjUMJdP78QyBP8evJMsR7bOtC+Qcb8tMB3hzn7mKbc0oKG4KHK7pb7/eW2U54eOyuMQ
	twm+Pg99exOuYba7YZ1ecI8RT3ZUeDqghmdNasgw9AIoIlDmruwuFfgK5Xpop+rQ09XUPr
	Qoh+rVDbphY0p9Qk3/BVJJLnbvYfK0c=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-zAAFNF1kNi6VhtaINQjfbg-1; Tue,
 26 Nov 2024 13:42:29 -0500
X-MC-Unique: zAAFNF1kNi6VhtaINQjfbg-1
X-Mimecast-MFC-AGG-ID: zAAFNF1kNi6VhtaINQjfbg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89E8E19560B0;
	Tue, 26 Nov 2024 18:42:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49A80300019E;
	Tue, 26 Nov 2024 18:42:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQIgQ73855528
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:42:26 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQIgQvl855527;
	Tue, 26 Nov 2024 13:42:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 12/12] libmultipath: reduce log level for DMP_NOT_FOUND
Date: Tue, 26 Nov 2024 13:42:24 -0500
Message-ID: <20241126184224.855459-13-bmarzins@redhat.com>
In-Reply-To: <20241126184224.855459-1-bmarzins@redhat.com>
References: <20241126184224.855459-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JAWP9opAxKqATRDsqk4wsh-cTVkplUJpJK9kbrPFSxY_1732646548
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

multipath makes many calls just to check if a device exists. Don't warn
on each of these.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
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


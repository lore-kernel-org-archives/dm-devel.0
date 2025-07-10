Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFA72E612B
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171548; cv=none; b=qmQPf4Zkw6MFet40w+tcCR92Tn2qXsnzxG5R/acOjW/0dFJ2xCiRHIdIzEHd1YXpiig+iHBDneQ6ZlM3yHuTFZpD7gvmKXrCKHIV+OfpaEqUuTm2h/UegishIiPmDkB8taQQTnFDkxFxc9cD6H/gRV31HfoXn243iAHovc1N+vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171548; c=relaxed/simple;
	bh=69SG5cvmQIt8J50BQg7i2SAaZJJi8Ga/ZWQByJmT5BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=bgtO2Nj52FcLtZVjfZUPgq94AZhgwOoZsOa6ouXrZeuwAx4gq0VoE/DGJQiPtS/vp0rPHG8OoDCN9hB4FhBA2TGZP/XHfavXxaHHo+zk7nM7x1mVnwgXDlh+5kP03fBkrqzhd9I6UicILEa6iPcY6XNYUqhJryzj9XZUlNNALTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=abBL+f35; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="abBL+f35"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=beksmprv3q6l7EEOY9nHci6hV8ADDyjOXFbor6YUEQo=;
	b=abBL+f356OeW62e2p//hfoDm/7gaTkO5c94BNwjT4Fq2QpTOn4EzyEf11ySZHDeGEvqmM7
	5GaXrOwZHup9ldh7mYgXBfM+qOaNgolrXtG9cLNIFuqsJqxTwqgywUqPt9uMGHkMGTCsR5
	Z6c7J686jxdgt/aDVfya8lJJknplglM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-82-_xvRh2GJN8GjNwVC-Nyjgw-1; Thu,
 10 Jul 2025 14:11:04 -0400
X-MC-Unique: _xvRh2GJN8GjNwVC-Nyjgw-1
X-Mimecast-MFC-AGG-ID: _xvRh2GJN8GjNwVC-Nyjgw_1752171063
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51515180028C;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DFC1919560A3;
	Thu, 10 Jul 2025 18:11:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB1LT3997791
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:01 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB1YX3997790;
	Thu, 10 Jul 2025 14:11:01 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 02/15] libmpathpersist: remove uneeded wrapper function.
Date: Thu, 10 Jul 2025 14:10:47 -0400
Message-ID: <20250710181100.3997759-3-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: audbR2-Xul-IEoh0M18XAMMbaM-kHX1QrYcktJehMUg_1752171063
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

mpath_send_prin_activepath() just calls prin_do_scsi_ioctl() with exactly
the same arguments that it is passed, and returns the same return. remove
it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 9ed9f5a7..612bbed9 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -49,17 +49,6 @@ struct threadinfo {
 	struct prout_param param;
 };
 
-static int mpath_send_prin_activepath (char * dev, int rq_servact,
-				struct prin_resp * resp, int noisy)
-{
-
-	int rc;
-
-	rc = prin_do_scsi_ioctl(dev, rq_servact, resp,  noisy);
-
-	return (rc);
-}
-
 static int mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 	struct prin_resp * resp, int noisy)
 {
@@ -80,8 +69,8 @@ static int mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 
 			condlog(3, "%s: sending pr in command to %s ",
 				mpp->wwid, pp->dev);
-			ret = mpath_send_prin_activepath(pp->dev, rq_servact,
-							 resp, noisy);
+			ret = prin_do_scsi_ioctl(pp->dev, rq_servact, resp,
+						 noisy);
 			switch(ret)
 			{
 				case MPATH_PR_SUCCESS:
-- 
2.48.1


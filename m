Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AF81E1E1C
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376011; cv=none; b=Ec957D9PeU1sC/XagMsteFSC8ZhQxyCR1XaUZUXlDkpox/tEB8HlvfxFQgfXkRsV9QkTI5dnihH99gZzvjETCP9AzcXwMQ3r4NhrMfwvyze48WLnM6Smi3KS9XFgXVAY2DYiBo9QJ2zUscJ1WMqD+9dXBKLRkmzgHwdz76ncrjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376011; c=relaxed/simple;
	bh=m3zYH8d2mKk5ELs2lc/5Cv95RmkDQeWSD/tjoAGmoSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=PSVR8GeQxTpnBEa8MkmzBFbE3kIV7Am+pDbc8+m5UOrG1zagmbwXNJS3QNaEhE6zAZgVXs/d3qRMg5U5HVLFFTnnIkPOBpZrUzJgzAjWIYGh38/h7+HQ2L9hcbKKFrvW7sLNdii3sW36feZquTgCD3MX+iExrbd4PuqVNkP9BIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Scz9N3R4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Scz9N3R4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYWPasNOUHXUdk77Qd/dW+5fm1TspVDg6boME0d6rNc=;
	b=Scz9N3R4qV/lvYcxQC7auWVo3Vct6i/4xNEz5zMMikPzYBW78N3UaZvrr24KFiBnyWMmch
	BdBmli529GbeAUGr/SqxXHaxHnTRahYZ+ExqvKAXJ0LlIRmO86R83E319c2ob4lxD3wKtv
	Ju3WYcMC+WioUO4YLsee8S5txnF7j8I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-UBRcfoZGNOyCiJXfoI5cmA-1; Mon,
 08 Sep 2025 20:00:07 -0400
X-MC-Unique: UBRcfoZGNOyCiJXfoI5cmA-1
X-Mimecast-MFC-AGG-ID: UBRcfoZGNOyCiJXfoI5cmA_1757376006
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5608A1800576;
	Tue,  9 Sep 2025 00:00:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BB5130001A4;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589004Ja751112
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589004Dg751111;
	Mon, 8 Sep 2025 20:00:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/32] libmpathpersist: remove useless function send_prout_activepath
Date: Mon,  8 Sep 2025 19:59:38 -0400
Message-ID: <20250909000002.751039-9-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5j4QVUE6-c5JoFaXwI5CbFHADmcGobRdBsUfZRKHZfw_1757376006
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

send_prout_activepath() creates a single separate thread that just calls
prout_do_scsi_ioctl() and it doesn't take any advantage of the work
being done in another thread. Remove the function and call
prout_do_scsi_ioctl() directly.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 39 ++---------------------------
 1 file changed, 2 insertions(+), 37 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 15add218..36eb6f35 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -363,40 +363,6 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
 }
 
-static int send_prout_activepath(char *dev, int rq_servact, int rq_scope,
-				 unsigned int rq_type,
-				 struct prout_param_descriptor * paramp, int noisy)
-{
-	struct prout_param param;
-	param.rq_servact = rq_servact;
-	param.rq_scope  = rq_scope;
-	param.rq_type   = rq_type;
-	param.paramp    = paramp;
-	param.noisy = noisy;
-	param.status = -1;
-
-	pthread_t thread;
-	pthread_attr_t attr;
-	int rc;
-
-	memset(&thread, 0, sizeof(thread));
-	strlcpy(param.dev, dev, FILE_NAME_SIZE);
-	/* Initialize and set thread joinable attribute */
-	pthread_attr_init(&attr);
-	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
-
-	rc = pthread_create(&thread, &attr, mpath_prout_pthread_fn, (void *)(&param));
-	if (rc){
-		condlog (3, "%s: failed to create thread %d", dev, rc);
-		return MPATH_PR_THREAD_ERROR;
-	}
-	/* Free attribute and wait for the other threads */
-	pthread_attr_destroy(&attr);
-	rc = pthread_join(thread, NULL);
-
-	return (param.status);
-}
-
 static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
 			      unsigned int rq_type,
 			      struct prout_param_descriptor* paramp, int noisy)
@@ -416,9 +382,8 @@ static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope
 
 			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
 			found = true;
-			ret = send_prout_activepath(pp->dev, rq_servact,
-						    rq_scope, rq_type,
-						    paramp, noisy);
+			ret = prout_do_scsi_ioctl(pp->dev, rq_servact, rq_scope,
+						  rq_type, paramp, noisy);
 			if (ret != MPATH_PR_RETRYABLE_ERROR)
 				return ret;
 		}
-- 
2.50.1


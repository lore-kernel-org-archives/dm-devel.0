Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCC92FCE39
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171071; cv=none; b=buNUa9toBapqo5swaK4aIKtEB4FbE3JOF1BAWYkoQrJ5okjXPy9xDximnKsTLPGCmpcoQuzh9Z2QT0HPSpljGr8h11r/NcgwD8RLFjJDu9bu+mMSdjwYvnYpPiddGGspXs6yq8dorof96NQBWR3WPyrlSbo3TGrtSSQZw8NWgz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171071; c=relaxed/simple;
	bh=c/pxS8VD8bndHicEWLDaDe2vmrb02G46ksR+ghzPjZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=FSLsOnFNrgcRj0V9JU/xWomfSMf03Dj/i89hjl7mHjYpeZzRs3fVCAn8HBVtzHJ2/yXDq7D8BRkITP2WzXCmTU7OBrh4xf748kfloN9sAjsVxubErSF/E/QXPUjiqsbHu3Ecn/SN3fJD6xU4eUgIMl12kfPb51gheNA3Q6wtG4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KJ6MfC3F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KJ6MfC3F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0SWcYuUP4lj+rC4m6yKcNJTVK3nEweGOd/wM+vF+89I=;
	b=KJ6MfC3FGU0qXisTvNcNKOV1TsoRYwosov8lMUkQrg+6jLSzen3eWvBOPkGhhb5lVPxGXf
	FSNKk1nAdWEF6OjLPqalligXNUPQFM2sEhKjHa2E6piujfzO5vYE2l9r4XKv1GF53G5bbe
	x0vYp743lAFqP0rI/PuIgPzlr2slC+k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467--4yk83QYNim4dUZp5nc8Lw-1; Thu,
 10 Jul 2025 14:11:05 -0400
X-MC-Unique: -4yk83QYNim4dUZp5nc8Lw-1
X-Mimecast-MFC-AGG-ID: -4yk83QYNim4dUZp5nc8Lw_1752171065
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 26AD4180029F;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB24719560A3;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB28b3997815
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB2hI3997814;
	Thu, 10 Jul 2025 14:11:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 08/15] libmpathpersist: remove useless function send_prout_activepath
Date: Thu, 10 Jul 2025 14:10:53 -0400
Message-ID: <20250710181100.3997759-9-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vVw4TRjM_Tqzi4IoQPCYOdV806NI6kOxbH3mV4d0zR0_1752171065
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

send_prout_activepath() creates a single separate thread that just calls
prout_do_scsi_ioctl() and it doesn't take any advantage of the work
being done in another thread. Remove the function and call
prout_do_scsi_ioctl() directly.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 39 ++---------------------------
 1 file changed, 2 insertions(+), 37 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index e312d577..13829742 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -364,40 +364,6 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
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
@@ -417,9 +383,8 @@ static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope
 
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
2.48.1


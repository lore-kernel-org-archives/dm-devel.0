Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D436F20C029
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 03:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764644542; cv=none; b=J3sk9ZkVr6+TlooXGUpzGr5VUEyiA19/aTJmya3U67X8GNsyeBgXbuKPq4TPPQqOIgM8HKyJweLgKt4JPJm6mR7YsKGOOnC35o43EiIWmumJlSRw/MoZ4bHuQHlafSPQZqaC6FFD8T/QSVMd7z6O4NM0q4iU0sTyyfCWXNrH+ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764644542; c=relaxed/simple;
	bh=b7rvVD3YG1UHsFEmWpEbWohRIOV+YmKusdHySt1amy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ZO4xeaaMEcgDn0lC3vegIJ4Nmuzi4/pSB+07LzoRRz4dCLlUv0q8UWnvsNAv5XmiKE+jDzOo0azlkJM74dv7ZbhJmVmBcbxmTQhrI/i9bNzCcFNvgZGqbHuJskNjhAT/fgnhjBxQmOoNcBKKwjdGsca2WUMUhJGIPGxedePNogw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VZ0w1TRU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VZ0w1TRU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764644539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v/Kai5wPy6QUVDPHCaar7KgTki0UnkuQ3g4Bdr5gxIU=;
	b=VZ0w1TRUgGWHbEenBmDh3YFZUbKhwkiKNYgCWfzeNegc3GMVnAjHCCDBrD4pVyK2P3RcS6
	ycK5CqFYCGK1mg0BrJqfhyb7IkOph2zEoBwi5eYsH4wxRsuPtlHsjGEaghBlgySTx0EaJ8
	CtlcslgsK8VVM55QsARmckdgDKRGtSA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-669-f6yFwQBpOqunqAL_ZB3hfQ-1; Mon,
 01 Dec 2025 22:02:16 -0500
X-MC-Unique: f6yFwQBpOqunqAL_ZB3hfQ-1
X-Mimecast-MFC-AGG-ID: f6yFwQBpOqunqAL_ZB3hfQ_1764644536
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0113195609F;
	Tue,  2 Dec 2025 03:02:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DCC130001A4;
	Tue,  2 Dec 2025 03:02:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B232D971432981
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 1 Dec 2025 22:02:13 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B232D6J1432980;
	Mon, 1 Dec 2025 22:02:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/4] libmpathpersist: fix register retry status checking
Date: Mon,  1 Dec 2025 22:02:10 -0500
Message-ID: <20251202030213.1432964-2-bmarzins@redhat.com>
In-Reply-To: <20251202030213.1432964-1-bmarzins@redhat.com>
References: <20251202030213.1432964-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5zXKO5XEPzjOkc19ot4Qpqfwh_3ixA0BCVZBwX9itfo_1764644536
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If there libmpathpersist failed to create a thread to retry the register
and ignore command, mpath_prout_reg should fail. Instead, the code was
simply ignoring the failed threads. Fix that.

Fixes: 2a4ca250 ("libmpathpersist: change how reservation conflicts are handled")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index ea8d65ea..91c53419 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -536,19 +536,19 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 			}
 		}
 		for (i = 0; i < count; i++) {
-			if (thread[i].param.status != MPATH_PR_SKIP &&
-			    thread[i].param.status != MPATH_PR_THREAD_ERROR) {
+			if (thread[i].param.status == MPATH_PR_SKIP)
+				continue;
+			if (thread[i].param.status != MPATH_PR_THREAD_ERROR) {
 				rc = pthread_join(thread[i].id, NULL);
 				if (rc) {
 					condlog(3, "%s: failed to join thread while retrying %d",
 						mpp->wwid, i);
 				}
-				if (thread[i].param.status ==
-				    MPATH_PR_RETRYABLE_ERROR)
-					retryable_error = true;
-				else if (status == MPATH_PR_SUCCESS)
-					status = thread[i].param.status;
 			}
+			if (thread[i].param.status == MPATH_PR_RETRYABLE_ERROR)
+				retryable_error = true;
+			else if (status == MPATH_PR_SUCCESS)
+				status = thread[i].param.status;
 		}
 		need_retry = false;
 	}
-- 
2.50.1


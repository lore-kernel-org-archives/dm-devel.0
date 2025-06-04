Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019FA15665C
	for <dm-devel@lists.linux.dev>; Wed,  4 Jun 2025 03:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008113; cv=none; b=c9sl5HSWQd2OazEgnkTsqnjEPnBltHqOsoMKivKDQN08UW13sp8TE0ctC1HbSgvgfPVl69LzBn7bat0rCCOoFWGPX4TW32kdsvAb8JuSsGyILxFVkO+ARtri+N0NvC+6rhToCt0MocOqW1kxoJeCdGgFMvqvjfA0gqqSrj0CXSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008113; c=relaxed/simple;
	bh=jMf8QIbn2TA+kvp2dGZZHBOd82KvWLoYY3RZq8gyPCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=NUO8wuARolmzJjNLeRcs0+W3k3yLJW8QeBxzngMFv0KscMAGqnNbmKnvZ0DIud1XB8ugz/cQCoiTcfpxtLX2b585YFVuhyKX6+85BP9USxaOHRlESWN8riEhfca0Z6SrZAnDWHhRorkEVbFn5zdHLK8KzXNQL1rVibSokLz0ObA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L1CoBZI8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L1CoBZI8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749008109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wFYfTR0T/SYd75HB3LlQLPS4DS6sY2tt2teZOGKFInY=;
	b=L1CoBZI8ZdDpEeK1GoPTiue3PBbFqhnFN8fP8JrngejJQkS1tSojOg43WVfJUdlqxg87nz
	2UoZD8X0Noyr+QnBW8P2YY+7kaXuXeNvQ1yQszuNpjrnx5ZlEdAZhoGC4wejDUJLHPIQyF
	lDIhOH9bsIbmbYqb+guPUnecUkBjdlU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-uY0QXgjCMYarewEm0HiGtA-1; Tue,
 03 Jun 2025 23:35:08 -0400
X-MC-Unique: uY0QXgjCMYarewEm0HiGtA-1
X-Mimecast-MFC-AGG-ID: uY0QXgjCMYarewEm0HiGtA_1749008107
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 11578195608D;
	Wed,  4 Jun 2025 03:35:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF2C519560A3;
	Wed,  4 Jun 2025 03:35:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5543Z50s2121581
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 3 Jun 2025 23:35:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5543Z5042121580;
	Tue, 3 Jun 2025 23:35:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/2] libmpathpersist: retry commands on other paths in mpath_prout_common
Date: Tue,  3 Jun 2025 23:35:03 -0400
Message-ID: <20250604033504.2121566-2-bmarzins@redhat.com>
In-Reply-To: <20250604033504.2121566-1-bmarzins@redhat.com>
References: <20250604033504.2121566-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T1kxfelNv7UMNqnZ6ssbhEtlIWZ33zBgaLTCyOr_Fnw_1749008107
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

mpath_prout_common() will only try sending the prout command to one
path. If that fails, it will give up. There are a number of cases where
it is reasonable to assume that sending the command down another path
could succeed. Keep trying other available paths in these cases.

Do do this, this patch adds a new error code, MPATH_PR_RETRYABLE_ERROR.
libmpathpersist will not return this error to users. It will change it
to MPATH_PR_OTHER if it fails trying on all the paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.h     |  3 +++
 libmpathpersist/mpath_persist_int.c | 13 +++++++++----
 libmpathpersist/mpath_pr_ioctl.c    | 24 +++++++++++++-----------
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index d94205f0..32aa7ffe 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -62,6 +62,9 @@ extern "C" {
 #define MPATH_PR_THREAD_ERROR		14  /* pthreads error (e.g. unable to create new thread) */
 #define MPATH_PR_OTHER			15  /*other error/warning has occurred(transport
 					      or driver error) */
+#define MPATH_PR_RETRYABLE_ERROR	16  /* error that might be succeed
+					       down another path. Internal
+					       only. */
 
 /* PR MASK */
 #define MPATH_F_APTPL_MASK		0x01	/* APTPL MASK*/
diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 7a6992c2..b838a014 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -92,7 +92,7 @@ static int mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 			}
 		}
 	}
-	return ret;
+	return (ret == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : ret;
 }
 
 void *mpath_alloc_prin_response(int prin_sa)
@@ -372,7 +372,7 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	}
 
 	pthread_attr_destroy(&attr);
-	return (status);
+	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
 }
 
 static int send_prout_activepath(char *dev, int rq_servact, int rq_scope,
@@ -416,6 +416,7 @@ static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope
 	int i,j, ret;
 	struct pathgroup *pgp = NULL;
 	struct path *pp = NULL;
+	bool found = false;
 
 	vector_foreach_slot (mpp->pg, pgp, j){
 		vector_foreach_slot (pgp->paths, pp, i){
@@ -426,12 +427,16 @@ static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope
 			}
 
 			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
+			found = true;
 			ret = send_prout_activepath(pp->dev, rq_servact,
 						    rq_scope, rq_type,
 						    paramp, noisy);
-			return ret ;
+			if (ret != MPATH_PR_RETRYABLE_ERROR)
+				return ret ;
 		}
 	}
+	if (found)
+		return MPATH_PR_OTHER;
 	condlog (0, "%s: no path available", mpp->wwid);
 	return MPATH_PR_DMMP_ERROR;
 }
@@ -635,7 +640,7 @@ out1:
 	free (pamp);
 out:
 	free (pr_buff);
-	return (status);
+	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
 }
 
 int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 093ec71b..bf3a817d 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -52,7 +52,7 @@ int prout_do_scsi_ioctl(char * dev, int rq_servact, int rq_scope,
 	fd = open(devname, O_RDONLY);
 	if(fd < 0){
 		condlog (1, "%s: unable to open device.", dev);
-		return MPATH_PR_FILE_ERROR;
+		return MPATH_PR_RETRYABLE_ERROR;
 	}
 
 	unsigned char cdb[MPATH_PROUT_CMDLEN] =
@@ -123,14 +123,16 @@ retry :
 		goto retry;
 	}
 
-	if (((status == MPATH_PR_SENSE_NOT_READY )&& (Sensedata.ASC == 0x04)&&
-				(Sensedata.ASCQ == 0x07))&& (retry > 0))
-	{
-		usleep(1000);
-		--retry;
-		condlog(3, "%s: retrying for sense 02/04/07."
-			" Remaining retries = %d", dev, retry);
-		goto retry;
+	if (status == MPATH_PR_SENSE_NOT_READY) {
+		if (Sensedata.ASC == 0x04 && Sensedata.ASCQ == 0x07 &&
+		    retry > 0) {
+				usleep(1000);
+				--retry;
+				condlog(3, "%s: retrying for sense 02/04/07."
+					" Remaining retries = %d", dev, retry);
+				goto retry;
+		} else
+			status = MPATH_PR_RETRYABLE_ERROR;
 	}
 
 	close(fd);
@@ -342,7 +344,7 @@ int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int
 	fd = open(devname, O_RDONLY);
 	if(fd < 0){
 		condlog(0, "%s: Unable to open device ", dev);
-		return MPATH_PR_FILE_ERROR;
+		return MPATH_PR_RETRYABLE_ERROR;
 	}
 
 	if (mpath_mx_alloc_len)
@@ -488,7 +490,7 @@ int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
 	case DID_OK :
 		break;
 	default :
-		return MPATH_PR_OTHER;
+		return MPATH_PR_RETRYABLE_ERROR;
 	}
 	switch(io_hdr.driver_status)
 	{
-- 
2.48.1


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7271F3BA9
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502347; cv=none; b=GSFGKZ9oXk5ETYMPadhbT+yyV1yC92RobXqRamScs8fP+1+O4ZbZq9QE8B68nnYJ+u+JbhID6M6NlqMWxAvp1058WlKv3W/KCeFPrHt+Q+Vwh0wk09rJddeiQxY/ZTb2wUQIiF3pP8ta3JLuvSZ5nJy/3sijpIryLFqHl+dEbR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502347; c=relaxed/simple;
	bh=A65DL6+F3V+TddsQoXAeNllkYikMeUrDuno0vZPAEOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=qS6b+FE3qFP86bAOgWlan08srPKnr8+yW0o/ilW2ktxIAVN0c7tVFE/nxpb4gGF+Ni2xGgG5Gbq4vS6Wfgx+pRi708VQqjsX5Q8sDQ6+CN2ar8r424LKiW/LHD/OteY4/O25N/ASAEwBTLRp3u4iOvH2R1srfvVctn73+37SQ4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dT4VUgS5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dT4VUgS5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GKn5hg+OHuRB1skxMAxBbC6LuCzy8fR4jYRdSeA7ycc=;
	b=dT4VUgS5EbrA2/84p7IcbmI+bVK18II+tACoGU1WWNful97T0i7+pRTqyVNQ2p5k9j2Pfg
	7qJa8ojPoLO1lng06G+eSWExi1przFfvr7j4URYuKqmE7DWC1McL4JEKmw6BKIcvYu3v4j
	yfHjxTU5zSUzEn/R43FmElTUeyY8IuM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-340-JT9nZIdeOWyqASRYr8smbw-1; Fri,
 25 Jul 2025 23:59:01 -0400
X-MC-Unique: JT9nZIdeOWyqASRYr8smbw-1
X-Mimecast-MFC-AGG-ID: JT9nZIdeOWyqASRYr8smbw_1753502340
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F2C4180045B;
	Sat, 26 Jul 2025 03:59:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E48DD30001B3;
	Sat, 26 Jul 2025 03:58:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3wwr4363365
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wwBx363364;
	Fri, 25 Jul 2025 23:58:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 13/14] libmpathpersist: retry on conflicts in mpath_prout_common
Date: Fri, 25 Jul 2025 23:58:54 -0400
Message-ID: <20250726035855.363290-14-bmarzins@redhat.com>
In-Reply-To: <20250726035855.363290-1-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MellYira4bq8sZrD8SxzpHdK-6T_FeRtPw6GvhSeGqo_1753502340
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

mpath_prout_common() just needs to execute a prout command down one
path. If it uses a path that was down when the key was changed and has
since been restored, but multipathd hasn't noticed yet, that path will
still be using the old key. This was causing mpath_prout_common() to
fail with MPATH_PR_RESERV_CONFLICT, even if there were other paths that
would work.

Now, if prout command fails with MPATH_PR_RESERV_CONFLICT,
mpath_prout_common() checks if pp->dmstate is PSTATE_FAILED. If it is,
mpath_prout_common() assumes that multipathd has not yet noticed that
the path is back online and it might still have and old key, so it
doesn't immediately return. If it can't successfully send the command
down another path, it will still return MPATH_PR_RESERV_CONFLICT.

Also, make sure prout_do_scsi_ioctl() always returns a MPATH_PR_*
type error.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 14 +++++++++++++-
 libmpathpersist/mpath_pr_ioctl.c    |  2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 06747391..d3c1a789 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -207,6 +207,7 @@ static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope
 	struct pathgroup *pgp = NULL;
 	struct path *pp = NULL;
 	bool found = false;
+	bool conflict = false;
 
 	vector_foreach_slot (mpp->pg, pgp, j){
 		vector_foreach_slot (pgp->paths, pp, i){
@@ -222,12 +223,23 @@ static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope
 						  rq_type, paramp, noisy);
 			if (ret == MPATH_PR_SUCCESS && pptr)
 				*pptr = pp;
+			/*
+			 * If this path is considered down by the kernel,
+			 * it may have just come back up, and multipathd
+			 * may not have had time to update the key. Allow
+			 * reservation conflicts.
+			 */
+			if (ret == MPATH_PR_RESERV_CONFLICT &&
+			    pp->dmstate == PSTATE_FAILED) {
+				conflict = true;
+				continue;
+			}
 			if (ret != MPATH_PR_RETRYABLE_ERROR)
 				return ret;
 		}
 	}
 	if (found)
-		return MPATH_PR_OTHER;
+		return conflict ? MPATH_PR_RESERV_CONFLICT : MPATH_PR_OTHER;
 	condlog (0, "%s: no path available", mpp->wwid);
 	return MPATH_PR_DMMP_ERROR;
 }
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index dfdbbb65..6eaec7cd 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -103,7 +103,7 @@ retry :
 	{
 		condlog(0, "%s: ioctl failed %d", dev, ret);
 		close(fd);
-		return ret;
+		return MPATH_PR_OTHER;
 	}
 
 	condlog(4, "%s: Duration=%u (ms)", dev, io_hdr.duration);
-- 
2.48.1


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6E531C572
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376019; cv=none; b=sMtOEg04rPY+82NWDIWcS8eF5YkaAUm1orNfEWroYh3bfgL87Gvdfl7VrEfVkFEgTpZI3GtL7BxEawxNI6J87nkp3suZvja33kDHO25VnTVv1QrZtDqyB2+sFxtNl30kYF2mGikZHrtLhNy9sanipO7BCFPW/s0Z7dz+70eBpbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376019; c=relaxed/simple;
	bh=lzsE3B0LDxhnfpmxyUlXPffjdfWzv1eiguOCs/PqBAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=dLBFymFuq1/aCzHasqAfVSmX6SABey6G02JOu/52vWK5PFNvLZ58modHUaWp8uuTBT2g6SMwrZNwF3iOdUQ6EHfm5y7Zr63M7ynD9PP43ikPoe6uoJEzhDSH/9AgZv3hpC+AshVSccXa6mF3S3X9TFG3VlX/ggdJCjz4gCS7ImQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M0RGhpzq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M0RGhpzq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=78S5ogwTGxrdEFzfAvxBRpU1d7rF2aOsqQoArHLsUbQ=;
	b=M0RGhpzqUsmXh6ESWTsVFgPYqX7jwgQCDpirZXkwbNiWA5/LVLMfCCwptPmai40MewooIw
	Bx5uQZbMd6inAEeZxrsgny+EltpaX/PoxlUYS6OMWsiedfWxatLWzX2Hrg3/1PynK71Ecu
	bSwep14JXZZV43i+XOPOMjSLILOLh/w=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-WEUkz7AVMoKF4SP21Nx_Cw-1; Mon,
 08 Sep 2025 20:00:10 -0400
X-MC-Unique: WEUkz7AVMoKF4SP21Nx_Cw-1
X-Mimecast-MFC-AGG-ID: WEUkz7AVMoKF4SP21Nx_Cw_1757376009
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FC2919560AE;
	Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06D9519560B4;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589007kS751195
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589007Kq751194;
	Mon, 8 Sep 2025 20:00:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 28/32] libmpathpersist: retry on conflicts in mpath_prout_common
Date: Mon,  8 Sep 2025 19:59:58 -0400
Message-ID: <20250909000002.751039-29-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fCgLhTkOG-tP63m7TNpjebVPCDpn0Na1u34WNpSDTyM_1757376009
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
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 14 +++++++++++++-
 libmpathpersist/mpath_pr_ioctl.c    |  2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 3419fde3..f7a75889 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -206,6 +206,7 @@ mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
 	struct pathgroup *pgp = NULL;
 	struct path *pp = NULL;
 	bool found = false;
+	bool conflict = false;
 
 	vector_foreach_slot (mpp->pg, pgp, j) {
 		vector_foreach_slot (pgp->paths, pp, i) {
@@ -222,12 +223,23 @@ mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
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
 	condlog(0, "%s: no path available", mpp->wwid);
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
2.50.1


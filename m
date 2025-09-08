Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E685E3112A0
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376013; cv=none; b=tSP+9Grmrkt8CzN7yFARKTl5CQQw0DH8YAONt5c2rRcrpUWTW9HbPFPWmO2/R/CdRxjTx1bblZ01JzPtjgKDBMqFqUtYww6C9gsopkCG1iNo8iZPzroBgIImMhBpS/zGdGZivxpsNUClXHqq0BEXSUsalEBYM4TGQljqsJrjoMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376013; c=relaxed/simple;
	bh=Hbmy5l8avnnjKgf8oUhC6eGfb5ydlSHfQJAOtB8170o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=kQXuJovLpay1WH6TpX62XdLodNVnekZcRuS71tOoAj+HqU88MTUA/YK7svfqrd9fIz30KvJVQg2+O8RQL7LrRhp25We6OjQKc3XtROr5BNKQECua01mXnF7I15qpCKdVg6vLlvEe3Xo7CmLhJ5iILpLSWjtzc/CyHGliqiOUJWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZHRQVZdy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZHRQVZdy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mb0ntAFMJVgpWapUXH5cTsHMYsmkF+CahLMTXlZaLM=;
	b=ZHRQVZdyHO0fNQdxeQ6xMx/GMJOEmKAVV1ikiS62YLHQFOj87g/dlaZAgA1E/NU2K1XfOk
	hZkk0AlB/WY9g64lz2I9YnOEyhNbVUvifNzO/zg7TzBICiNO3cMwkD29oi5Pfdqlmryl6y
	uuX0K5Fm8H521YAXyo5kpPlTNL3R62U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-9pHvpU6HO02V5LtGuxYYcg-1; Mon,
 08 Sep 2025 20:00:07 -0400
X-MC-Unique: 9pHvpU6HO02V5LtGuxYYcg-1
X-Mimecast-MFC-AGG-ID: 9pHvpU6HO02V5LtGuxYYcg_1757376006
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 227991800578;
	Tue,  9 Sep 2025 00:00:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D47401955F24;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589004x4751104
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589004L6751103;
	Mon, 8 Sep 2025 20:00:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 06/32] libmpathpersist: limit changing prflag in update_map_pr
Date: Mon,  8 Sep 2025 19:59:36 -0400
Message-ID: <20250909000002.751039-7-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A0enQ23wXdf8msCYcFVKtLKWLHL0xmmn6gNHNwZwSw4_1757376006
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Do not unset mpp->prflag in update_map_pr() unless the device doesn't
support persistent reservations or it successfully reads the registered
keys and discovers that the device's key is not there. Also, nothing in
the libmpathpersist ever returns MPATH_PR_SENSE_INVALID_OP. It instead
returns MPATH_PR_ILLEGAL_REQ if the device doesn't support persistent
reservations, so check for that instead.

Also, do not even check for the registered keys in update_map_pr() if
mpp->prflag is unset. Otherwise, multipathd will set mpp->prflag if the
key was unregistered (and thus prflag was unset) while a path is down
(and thus could not have its key unregistered) and then that path comes
back up. I should note that the above issue can only occur if multipath
is defining PR keys in /etc/multipath.conf, instead of the prkeys file.

If a device has no registered keys, it must unset prflag, since that
means it's no longer registered. Possibly its registration was removed
by a CLEAR or PREEMPT action. But if a device has a registered key but
it is supposed to be unregistered, it should remain unregistered, since
that key is likely one that libmpathpersist could not unregister at the
time.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 71245e49..15add218 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -73,7 +73,7 @@ static int mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 			switch(ret)
 			{
 				case MPATH_PR_SUCCESS:
-				case MPATH_PR_SENSE_INVALID_OP:
+				case MPATH_PR_ILLEGAL_REQ:
 					return ret;
 				default:
 					continue;
@@ -727,6 +727,10 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 	int ret = MPATH_PR_OTHER, isFound;
 	bool was_set = (mpp->prflag == PRFLAG_SET);
 
+	/* If pr is explicitly unset, it must be manually set */
+	if (mpp->prflag == PRFLAG_UNSET)
+		return MPATH_PR_SKIP;
+
 	if (!get_be64(mpp->reservation_key))
 	{
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
@@ -747,7 +751,6 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 		condlog(2, "%s: No available paths to check pr status", mpp->alias);
 		goto out;
 	}
-	mpp->prflag = PRFLAG_UNSET;
 	if (pp)
 		ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, noisy);
 	else
@@ -755,9 +758,12 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 
 	if (ret != MPATH_PR_SUCCESS )
 	{
+		if (ret == MPATH_PR_ILLEGAL_REQ)
+			mpp->prflag = PRFLAG_UNSET;
 		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
 		goto out;
 	}
+	mpp->prflag = PRFLAG_UNSET;
 
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
 	{
-- 
2.50.1


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107192FCE26
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171071; cv=none; b=rYxNgU01dNhyjIw+gc9QxdoNaBKW/RwG7c8wdKHlb2k8jE5hLYsgyQ0nNk1voJHLSthWSjzGfdO8sHZI5G7cZFUlcVAq/KhLL5dhDp/WGWqQYEBHnHQpDSzgu+y6JDIB9hpiF/QhojA+MzgcA9lwQSxVfQDWla1XZdhdwBK2Vwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171071; c=relaxed/simple;
	bh=WlC7l9td1vNVhqMX32ubnq8q7JiBX7xHWJ94PXYpMMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Cz6a3lKBztX2WtOmsgPmUHVczxEHwm7wJqwBQzbe18UdgQdjg2FrNsPavFbn/PDyrb62oW4nwh1TlwR4051ocnaGZgzupkP8L/dqQjVY1cpO0H8fRdaKeQgtNCzaJVW6QpWDepbeTfamWI8EkrHJEhQyty2idRttOtks1Va9l/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R9mwsCah; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R9mwsCah"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kyhJC8Q3uM+3AMi8ZN5s3qCH236PXd/RBq0maKcE4tw=;
	b=R9mwsCahhZ2431z0voOGWBUEkPkIzXVxltzVTah0U1VVoyVke9a143POFUwhOjF1vHBhKX
	xIDD2P1MO5nmUQpzuK08xvNTzsKZyxhEQxvnzNlP4kYONV4wzAckYYdQdxP4fvDA3bTQ83
	uvPFLKwWkU128GoR20CJBrfyZuHVPBU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-SJM_Flj3P1evNcSwUjPN1w-1; Thu,
 10 Jul 2025 14:11:04 -0400
X-MC-Unique: SJM_Flj3P1evNcSwUjPN1w-1
X-Mimecast-MFC-AGG-ID: SJM_Flj3P1evNcSwUjPN1w_1752171064
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4EC618011EE;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9AFC81956094;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB2j63997807
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB2MU3997806;
	Thu, 10 Jul 2025 14:11:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 06/15] libmpathpersist: limit changing prflag in update_map_pr
Date: Thu, 10 Jul 2025 14:10:51 -0400
Message-ID: <20250710181100.3997759-7-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kqqKpjwt5gT0npy6jwlxqRAI31sxgfesiulztIkxKNI_1752171064
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
---
 libmpathpersist/mpath_persist_int.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 92c3ea7e..e312d577 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -74,7 +74,7 @@ static int mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 			switch(ret)
 			{
 				case MPATH_PR_SUCCESS:
-				case MPATH_PR_SENSE_INVALID_OP:
+				case MPATH_PR_ILLEGAL_REQ:
 					return ret;
 				default:
 					continue;
@@ -728,6 +728,10 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
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
 			mpp->alias);
 		goto out;
 	}
-	mpp->prflag = PRFLAG_UNSET;
 	if (pp)
 		ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp,
 					 noisy);
@@ -757,9 +760,12 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 
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
2.48.1


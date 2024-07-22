Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906168F5E
	for <dm-devel@lists.linux.dev>; Mon, 22 Jul 2024 23:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721691386; cv=none; b=NPRLxbPlxr9H31iI03TNkD9AFbQ0fZLzL6inWOdawc+NlCKsOBKY7gy1Zq+ABF0bX32dZDYcFN5nDGqiITqbslV1JwUk1cc2dPBMwlXXMlwXAVpHWA3mmaipTaQqODebpZGD+r+K+8Ww1GvrTSAD76yIUNbMF34iB7RJ+T94hh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721691386; c=relaxed/simple;
	bh=34dozahHIkEEC2Cj+s7fjdII6eTi/sDZidYOmJbadnk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BUZkJJ42BIQR0FJvHekyccprIvkVlJbfsY5kXHj41r4zFRMLsIVpijMUAOj/Oam9BFpLvjXBrAFep1c7YSt2xKkq+Pq7y4mRK+9agL7ZjaP/a07qYEAiNB7CJdpbezv44o23JDpdUnXmw+uP7C9Q7ZgizbgHqiJetudvr61pOgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gN9OSax/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gN9OSax/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721691383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1zm5ZBkiy6sBufXDEz1K/3UXdiXYiJ1S03CF77yHwfU=;
	b=gN9OSax/MebhtjnqNOMSleGL6QmsNIWhlZjdWisZUzVnNIRLnEqserCzzhNaSRb68+ufO8
	4hlM6ncWEc4Iq+198WMCHPSFu+3qdvZtE94jAPwLbTtBijoaZ7hdBqVdZsa0AHxVsWd4Gp
	3lw3D7Y2eXriYNBjj7sBK0vPSj8OdCs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-8-a6wwncN92PSJMwNz8GFw-1; Mon,
 22 Jul 2024 19:36:19 -0400
X-MC-Unique: 8-a6wwncN92PSJMwNz8GFw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEC8619560A2;
	Mon, 22 Jul 2024 23:36:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C75A195605A;
	Mon, 22 Jul 2024 23:36:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46MNaGPa2496286
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Jul 2024 19:36:16 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46MNaGk82496285;
	Mon, 22 Jul 2024 19:36:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmpathpersist: set mpp->mpe before selecting reservation_key
Date: Mon, 22 Jul 2024 19:36:16 -0400
Message-ID: <20240722233616.2496277-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

libmpathpersist was not setting mpp->mpe before calling
select_reservation_key(). This means that if the reservation key was set
in the multipaths sections, it wasn't being selected.

This appeared to work for many commands because of an error in checking
if the correct reservation key was used. If mpp->reservation key was
unset, then it would considered to match if either the RK or SARK was
unset in the command. mpathpersist should fail if it doesn't find a
configured mpp->resevation key, with one exception. To make it easier to
remove old keys, if --register-ignore is called, and the command SARK is
0x0 so the device is being unregistered, allow mpp->reservation_key to
be unset. The code already allows mpp->reservation_key to not match the
command RK in this case.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

This commit is based on mwilck/tip

 libmpathpersist/mpath_persist_int.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index f4d9e7c8..5cae3fb7 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -652,6 +652,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		return ret;
 
 	conf = get_multipath_config();
+	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
 	select_reservation_key(conf, mpp);
 	select_all_tg_pt(conf, mpp);
 	put_multipath_config(conf);
@@ -671,6 +672,13 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		}
 	}
 
+	if (!get_be64(mpp->reservation_key) &&
+	    (prkey || rq_servact != MPATH_PROUT_REG_IGN_SA)) {
+		condlog(0, "%s: no configured reservation key", alias);
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out1;
+	}
+
 	if (memcmp(paramp->key, &mpp->reservation_key, 8) &&
 	    memcmp(paramp->sa_key, &mpp->reservation_key, 8) &&
 	    (prkey || rq_servact != MPATH_PROUT_REG_IGN_SA)) {
-- 
2.45.0


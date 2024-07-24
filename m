Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D9A26AF5
	for <dm-devel@lists.linux.dev>; Wed, 24 Jul 2024 18:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721845042; cv=none; b=L/rIbTQM8g3CHqW2D872gMR/0rGV2forFKmQDjd6/G3o2cyB1a6IHpvlBHxC+qtchjeyEiF+5Ckryi6Y8dE0C43kgLzh2Ik1KNt8ZTdKwhtC84B++1ktgEEQF2cVaZLAcNucvAjp3i3wDydNpN5i7v9iBpnPIqeUB+R9RbGOha0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721845042; c=relaxed/simple;
	bh=BEb+Wkf/iK+pLxcsCf9DigLZ0qrgAWggb3QpPlOx9Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZAb/UN5GXO3MO2FM5CgFV6TtUe9SO2y8/BflPFoHTEsDInHmX6ZvbFBapwtuzQKLl0BCg2/e8O8tLMEXNlhEE+eiALTYAHXhMHX0MqkLrmvJm886OZwWiA2onLN+qlS0VT0SlBAwY9gu+4R8saBkeq+veHi8evLVdcHd1bgV5vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a517HsR4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a517HsR4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721845039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e63k7kDUj1iLQ+o0ozOFlqqFodcwMIQOXX89xhUoQ3s=;
	b=a517HsR4SHD5b0L1kP1Xhke4yHB8v7vME1tbef/QH7Au4myIB3pVLAVdCP3MdoNseERp2m
	o4K/oaRmIuNwt5V09F2j71rZYRGqJ5LHmLIXpUNFftgOp3GH0z7v+V1DXL8ZMIIYF6VXIj
	/FqpZ7cpvtA5bLm3VCjUBuSH4FQcGs4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-q58t1IzGOd2rFQdtuef7ug-1; Wed,
 24 Jul 2024 14:17:16 -0400
X-MC-Unique: q58t1IzGOd2rFQdtuef7ug-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EAC711955BEE;
	Wed, 24 Jul 2024 18:17:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7042A19560AE;
	Wed, 24 Jul 2024 18:17:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46OIHC3d2565147
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 24 Jul 2024 14:17:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46OIHCqp2565146;
	Wed, 24 Jul 2024 14:17:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2] libmpathpersist: set mpp->mpe before selecting reservation_key
Date: Wed, 24 Jul 2024 14:17:12 -0400
Message-ID: <20240724181712.2565138-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
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

Changes in v2:
Actually base patch on mwilck/tip

 libmpathpersist/mpath_persist_int.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index f4d9e7c8..95bbdcd8 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -652,6 +652,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		return ret;
 
 	conf = get_multipath_config();
+	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
 	select_reservation_key(conf, mpp);
 	select_all_tg_pt(conf, mpp);
 	put_multipath_config(conf);
@@ -671,6 +672,12 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		}
 	}
 
+	if (!get_be64(mpp->reservation_key) &&
+	    (prkey || rq_servact != MPATH_PROUT_REG_IGN_SA)) {
+		condlog(0, "%s: no configured reservation key", mpp->alias);
+		return MPATH_PR_SYNTAX_ERROR;
+	}
+
 	if (memcmp(paramp->key, &mpp->reservation_key, 8) &&
 	    memcmp(paramp->sa_key, &mpp->reservation_key, 8) &&
 	    (prkey || rq_servact != MPATH_PROUT_REG_IGN_SA)) {
-- 
2.45.0


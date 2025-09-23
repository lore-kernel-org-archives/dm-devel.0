Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E0130F7F2
	for <dm-devel@lists.linux.dev>; Tue, 23 Sep 2025 22:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758665585; cv=none; b=T9Ax9u5ekTxP1LqINjwt+UN4T/PsuQqFVyiWc+maQG53c8otdKLkkmnnmr2+oSpY6LvPLMTtp28jzxy/p44fPmZzLsPvhqDtqP4EmchQ4QmB0SPog66xoX7xUj4ESXkX8/swFtNsggPXa8xZalEiJEZtikr/mi2bXCUNX3RVoZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758665585; c=relaxed/simple;
	bh=kpz0tNI0xhb/ZQOG0ua+wGqBM0yIubqnjsOh2iwWYUI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=qkeLEgFtmLZw9GzOkGWi3C+0A7Pv9VCrmujaRzdMaaOOWMuKZ5yYxgcRBDLFYbs73Yyc88I/pCapY/eDqLT0yxZdmxVT/3qMiAw2tWd6GQ0h2KLNjGayA2DIAXW2VRF2erX5+Kj1UXHF91UcwgFQdMRSfg1yWQItVrwGNV4oa5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wd/FrDtX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wd/FrDtX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758665581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eEGlN9RV4Obs3BUNFJeNg80Ekc3TCT7UgKho93f49rI=;
	b=Wd/FrDtXXAYwP6V6dBWtHRcQMO5VLBp5QWn3ybn6fywuJpJpWzbzUlQNqlijuAeKip9wbh
	4T/a7p8K6AEg2OI/sSYFB1nWLPpgrtCspV9+1Ka4pe9SLYZfe8DQ3O1ckJ3NolMgk0NbYU
	nLrmAOBDI3eNJHsMW9Dz1F4pnViZHC4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-202-IV3l77SzOW-UK3VFZFendA-1; Tue,
 23 Sep 2025 18:12:56 -0400
X-MC-Unique: IV3l77SzOW-UK3VFZFendA-1
X-Mimecast-MFC-AGG-ID: IV3l77SzOW-UK3VFZFendA_1758665575
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4005C19560A1;
	Tue, 23 Sep 2025 22:12:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF14719560B1;
	Tue, 23 Sep 2025 22:12:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58NMCqbb1411700
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 18:12:52 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58NMCqeV1411699;
	Tue, 23 Sep 2025 18:12:52 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/4] libmultipath: Yet Another PR patchset
Date: Tue, 23 Sep 2025 18:12:48 -0400
Message-ID: <20250923221252.1411687-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aQDLhZ_0-UOYx3qx_8inwUphSxj5ZAvIFFQ_zk3puzw_1758665575
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patchset handles 4 separate issues:
1. The self-preemption workaround for changing keys using REGISTER AND
   IGNORE, while the path holding the reservation was down was broken
   by a recent commit.
2. mpathpersist was failing a RESERVE command issued on a multipath
   device that held a reservation, when the holding path was down.
   Issuing an identical reserve on a device that holds a reservation
   is supposed to succeed, and multipathd has enough information to
   know the device is actually holding the reservation. So if
   multipathd says that the device is holding the reservation, it
   should not fail, even if the path holding the reservation is down.
3. mpathpersist was not clearing the reservation when the key holding
   it was unregistered, if the path holding the reservation was down.
4. When unregistering a key that holds a reservation, depending on the
   order that the paths got unregistered, there was a window where
   IO going to the device could fail. This should not happen because
   the reservation should be removed and the key should be unregistered
   atomically.

Benjamin Marzinski (4):
  libmpathpersist: Fix REGISTER AND IGNORE while holding a reservation
  libmpathpersist: Handle RESERVE with reservation held by failed path
  libmpathpersist: use check_holding_reservation in mpath_prout_rel
  libmpathpersist: Fix unregistering while holding the reservation

 libmpathpersist/mpath_persist_int.c | 199 +++++++++++++++++-----------
 1 file changed, 125 insertions(+), 74 deletions(-)

-- 
2.50.1


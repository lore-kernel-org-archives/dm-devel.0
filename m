Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CEC3321BF
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 21:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769029401; cv=none; b=M1AojFqFm8CBfrSa+t62b+FWL87Zx45hwIjQfx1ORxXtkdpWY6d5PasT9rByEzYG6bYwdn+4D51UBFpiYa0NE+DIncr8O4Lw/6bm5GSFXbec8bc986cp2df8rIn3CioeSyJ94NmlIDCU2aoEicNv+DvpTYz0zQAeK3R8eb0aU4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769029401; c=relaxed/simple;
	bh=am2r/h9MMvqUX0r/u/5CMJUGrRy+5OWfCfIbmyoTNxA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=nC5xRlglHg+k33SG2ScQXO9FodRp5mmUluwRltGHM0h2V8WnMJATKJNiL/uTka4kVmStAF6cIbEx2F/cukwD77cThBehGpucBVilvHYp+UIOXd14Kph6SsoN1+fSdRN4LnZN6OZXOAGCmLFYzpoLvJzs04Bedg8MASUhBuQctIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DlPtWxPH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DlPtWxPH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769029398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qkJEN0meROpaSAmj+tpTUnFiLVHIEyTMnbe6aQRRPQU=;
	b=DlPtWxPHhUSE7Gi8WWBjbOwC2vkdgPuuMIdzJ+MpCmoSbWul8b+hN34/toyl/+O7gVEjG/
	l/+K3bXvQo/uf+Je6qESvKjk+/oEAFigNEOkO+tqRUeDOYGZ02ZhceoxfZ6DRDm0DdD8L8
	0TnYzkJ6Y34yssjT44cEcARK/qLU/LE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-d19FioNlMCqxcsW9HJsx8w-1; Wed,
 21 Jan 2026 16:03:17 -0500
X-MC-Unique: d19FioNlMCqxcsW9HJsx8w-1
X-Mimecast-MFC-AGG-ID: d19FioNlMCqxcsW9HJsx8w_1769029395
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EBF51954B14;
	Wed, 21 Jan 2026 21:03:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9B4519560AB;
	Wed, 21 Jan 2026 21:03:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60LL3DYC3942740
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 16:03:13 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60LL3DK53942739;
	Wed, 21 Jan 2026 16:03:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 0/4] multipathd: Miscellaneous fixes
Date: Wed, 21 Jan 2026 16:03:09 -0500
Message-ID: <20260121210313.3942727-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aewygHs4m3RzaAMOYxYWUy21By7gYTJDd7u_vEC-C5g_1769029395
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

These are a just collection of unrelated multipath fixes. The first one
keeps new maps from adding non-discovered paths in configure(). The
second one makes sure that paths that were offline when multipathd was
started or reconfigured get the pathinfo checked and get the proper
initialization state, when the come online. The third improves the
"busy" state output in "multipathd show status". And the fourth one make
sure that multipathd prints the "path offline" message for paths that
are part of multipath devices but were offline when mutipathd was
started or reconfigured.

Changes from v1 (as suggested by Martin Wilck):
2/4: Switched to using size-limiting string functions, and refactored
     the code for rechecking the WWID
3/4: Stopped accessing servicing_uev as an atomic
4/4: switched from checking (pp->sysfs_state == PATH_DOWN) to
     (p->sysfs_state != PATH_UP)

Benjamin Marzinski (4):
  multipathd: don't add removed/partial paths to new maps
  multipathd: finish initalization of paths added while offline
  multipathd: make "multipathd show status" busy checker better
  multipathd: print path offline message even without a checker

 libmultipath/configure.c   | 12 +++++++-
 libmultipath/discovery.c   |  2 ++
 libmultipath/structs_vec.c |  3 +-
 libmultipath/uevent.c      |  9 ++++--
 multipathd/main.c          | 60 +++++++++++++++++++++++++++++++-------
 5 files changed, 71 insertions(+), 15 deletions(-)

-- 
2.50.1


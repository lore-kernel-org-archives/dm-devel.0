Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB9A153BF9
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 23:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714088122; cv=none; b=OFU9eKHq7p0jUROZsgwjSJeDZRpieAo1/Kladi8eGq2CDjb+cReWG+MnXWeUjdVPcQlPw9cRAwF9T3+vHFa1rrxUrIYLr0D/gphWiQoHTHUsBYCFCUtqfFA28YA20wg7ol9aKy3GSCN1VhdImZq1shbiHyZUujrQkDxQPz/T768=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714088122; c=relaxed/simple;
	bh=xroxsJxKBKScy7iZ6nzyfvvU14Dw2tn6gBPg2EWDQj8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WlbFWWXgdZlOxu+qvQGulnXiWUalDPKi82NCTOdBgH42t/R1V5+zzoosmVJWzDkp1vJ5PPKUyv2MCSEsOnPTGi9KMqciikKxl7v4Tn053p3npJP4JwrMeouejadB/wWCU1SY3KbcIlPeZI95o1l5mbglsZ7HT6+j/4af1JxaHM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h+8j7rm0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h+8j7rm0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714088119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+DHM6gviwKZsuWRsO8AFXs6rBXCvz/eFHF96i8sv67g=;
	b=h+8j7rm0j7PPsX1DX+kCEgGeY9BIqK5mPhsfGzHICDUOZIMCIdeVUkJvgwvvpNj3+GyhoS
	w9epv/vQEGk8XA5RVgzCAMnwupjELiyzhUxoOUYqGkMgwqKldLWr+aso7FYEPIwksj8GjD
	ERC6qRwvb+Fx1rXVflTmwuQTI58iS68=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-jVXF8F7FPxi0JsBj8o3N7Q-1; Thu, 25 Apr 2024 19:35:18 -0400
X-MC-Unique: jVXF8F7FPxi0JsBj8o3N7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06D4B8001B2;
	Thu, 25 Apr 2024 23:35:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDAFC730B;
	Thu, 25 Apr 2024 23:35:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43PNZHUX2125156
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 19:35:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43PNZH3l2125155;
	Thu, 25 Apr 2024 19:35:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 0/5] multipath: fix hang in flush_map_nopaths
Date: Thu, 25 Apr 2024 19:35:12 -0400
Message-ID: <20240425233517.2125142-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Commit 9bd3482e ("multipathd: make flush_map() delete maps like the
multipath command") fixed a multipathd hang when trying to remove a
multipath device with only kpartx devices opening it but with
outstanding IO. However that commit didn't deal with autoremoving the
multipath device when the last path is deleted. It's possible for the
same hang to occur during an autoremove. Since this remove is not
initiated by the user, multipathd shouldn't just automatically disable
queueing. On the other hand, multipathd hanging is a big problem, since
that stops all of its work on all multipath devices. This patchset
handles the issue by changing the options for flush_on_last_del to give
the users more choice in how to deal with this situation. But none of
the options will allow multipath to flush a device while it is queueing,
which is the action that can cause it to hang.

Differences from v1 (from conversations with Martin Wilck):
0001: Since flush_map_nopaths() will no longer need to know what the
      deferred_remove setting is, only exported partmap_in_use.
0002: Fixed up the commit message. Removed all of the code treating
      deferred removes as special in flush_map_nopaths(), and made
      sure flush_map_nopaths() skipped the autoremove if disabling
      queueing failed.
Original 0003: Dropped. flush_map_nopaths() no longer needs to care
      about the deferred_remove value, so dm_flush_map_nopaths() does.
0003-0005: New commits based on suggestions from Martin

Benjamin Marzinski (5):
  libmultipath: export partmap_in_use
  libmultipath: change flush_on_last_del to fix a multipathd hang
  libmultipath: remove redundant config option from InfiniBox config
  libmultipath: pad dev_loss_tmo to avoid race with no_path_retry
  libmultipath: fix deferred_remove function arguments

 libmultipath/defaults.h           |  2 +-
 libmultipath/devmapper.c          | 21 +++++----
 libmultipath/devmapper.h          |  1 +
 libmultipath/dict.c               | 72 +++++++++++++++++++++++++++----
 libmultipath/dict.h               |  1 +
 libmultipath/discovery.c          |  5 +++
 libmultipath/hwtable.c            |  5 +--
 libmultipath/libmultipath.version |  3 +-
 libmultipath/propsel.c            |  4 +-
 libmultipath/structs.h            |  7 +--
 multipath/multipath.conf.5.in     | 20 ++++++---
 multipathd/main.c                 | 39 +++++++++++++----
 12 files changed, 139 insertions(+), 41 deletions(-)

-- 
2.43.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55F0143860
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 22:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713911141; cv=none; b=Ufv8sMDAEP2lTw4Z+GALyEAP8IjEr34LRLsd3v55xA3XaDaVVeMuQ0/zq24dzmUW32r6TZpG2lpwua+bmfKE1TeXiiBgV8s3eyVpOSEGqDxauAw53x/LYa+EfrMfmzoaAy9KLaCbq5Mnrydi621la/CpF6CqTYmWBWjMRdFLiGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713911141; c=relaxed/simple;
	bh=lXT1z6AkrCQYH2bL9ciTcb4AeHAZtpOtqaU1OKYClHA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gSk+KpiYyYPAN7X2XvJGVJ1aS8FZUhFGchAURM50XkMY35UIdjdlf0SjGmT9YuXPfLv+v/d4W/JmTobAgoqEkHYXF1NNoddDhJBH6kDl4VaQ/9R1YzbghQ/XrmI64+RQ0LpkQ8CyKtJQuhQqPIB2Afd1WU2/mFH/ufrAVazy5dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qlev/9am; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qlev/9am"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713911138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fnI04WB2nbOPoMqQO3mtAiWTnhxYsKtNzRo+Vhb/L1o=;
	b=Qlev/9amSkAPSSGvxOyrNNyzUTviE66Z5TMzzTqdZxIEnkjm8/dv5T1rPlwAPgVyqapJr0
	y3NKwrSd0MSPcRaG9fQTeuOwIiT/yIEQLD7ra/rAzpCIMvQIQvl9Y2n6ZQvouUg6tEx3zp
	uL5gPpUjXz2yRI673yf76ktJan8lN+E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-Wt5ep1ooO0m1QuyJAAP-fQ-1; Tue, 23 Apr 2024 18:25:37 -0400
X-MC-Unique: Wt5ep1ooO0m1QuyJAAP-fQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 103D5812C56;
	Tue, 23 Apr 2024 22:25:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0355A492BC6;
	Tue, 23 Apr 2024 22:25:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43NMPa412096498
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 18:25:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43NMPaQK2096497;
	Tue, 23 Apr 2024 18:25:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/3] multipath: fix hang in flush_map_nopaths
Date: Tue, 23 Apr 2024 18:25:33 -0400
Message-ID: <20240423222536.2096486-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
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

Benjamin Marzinski (3):
  libmultipath: export partmap_in_use and do_deferred
  libmultipath: change flush_on_last_del to fix a multipathd hang
  libmultipath: simplify dm_flush_map_nopaths

 libmultipath/defaults.h           |  2 +-
 libmultipath/devmapper.c          | 23 +---------
 libmultipath/devmapper.h          |  6 ++-
 libmultipath/dict.c               | 72 +++++++++++++++++++++++++++----
 libmultipath/dict.h               |  1 +
 libmultipath/hwtable.c            |  6 +--
 libmultipath/libmultipath.version |  4 +-
 libmultipath/propsel.c            |  4 +-
 libmultipath/structs.h            |  7 +--
 multipath/multipath.conf.5.in     | 20 ++++++---
 multipathd/main.c                 | 42 +++++++++++++++---
 11 files changed, 135 insertions(+), 52 deletions(-)

-- 
2.43.0


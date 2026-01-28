Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72E8288D2
	for <dm-devel@lists.linux.dev>; Wed, 28 Jan 2026 00:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769559153; cv=none; b=RZlYgJF6l/vpBsRELPmjZzyDaFRF+bogjGAGp5lj3z/ag3GW+ggFvBgNvBtKSrhpdyPXjp9ye3RTG7dJ18Cwdz+MBA7kRsGdUuaaC+brEp4QgBF5kHRheerwudDYAzHjAZimGhwkFEZYKfrRcAdPj5DzLyzbQhOC8US8lOaIsdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769559153; c=relaxed/simple;
	bh=hTgrQM5eGetR1hGQp+BvRN41YRKi7oP2moObL9bjKtI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=oGZ5jLjDwzIlYloZLcTdj0v0012JY5EeArgmACD/ljL3yBqXNXFyn6eX9N5u6C1lzfgEEgaLPHFuHHuPnRlNtbUaTeo+D6HLyclIH6fGnNCOgSompxoIFhtpGNci9flgJEGhblarqOkI+i0OWrCxfDFKnS8MBzQ+R0PT0DnThZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CZHKRfzB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CZHKRfzB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769559150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8q05zXFVDmNeK4H26Afg28j9Dybf0VLuB9jOtvZznEc=;
	b=CZHKRfzBaBtZYm/7s/yE34jHA4UgvH0/Jwxj8rD0JS20jYeBcaKpknTiFp2nBdpOcvX6pt
	m/O5hNyTQ+EBzAn08INxnM7jDWRhV0CsaVUvBlftC+8p75sgmn3ey0czb8WAQalDLfwKDG
	XWc3MY+mtwjc9jV97jGoU4rTD06b0CY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-lY6w9Ri8P2SiwHccaKAxkg-1; Tue,
 27 Jan 2026 19:12:27 -0500
X-MC-Unique: lY6w9Ri8P2SiwHccaKAxkg-1
X-Mimecast-MFC-AGG-ID: lY6w9Ri8P2SiwHccaKAxkg_1769559146
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84A2318005AF;
	Wed, 28 Jan 2026 00:12:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DC8718004D8;
	Wed, 28 Jan 2026 00:12:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60S0COW1462758
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 19:12:24 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60S0COlt462757;
	Tue, 27 Jan 2026 19:12:24 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: [PATCH 0/3] dm mpath: Minor multipath related cleanup
Date: Tue, 27 Jan 2026 19:12:21 -0500
Message-ID: <20260128001224.462746-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7zly_u_vFMxU_tETz-0g93e0DJnoWGznCpI0Pq399aw_1769559146
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patchset fixes two minor bugs in creating multipath devices, and
removes some dm locking that is no longer necessary after a change in the
multipath code.

Benjamin Marzinski (3):
  dm mpath: Add missing dm_put_device when failing to get scsi dh name
  Revert "dm: fix a race condition in retrieve_deps"
  dm mpath: make pg_init_delay_msecs settable

 drivers/md/dm-core.h  |  1 -
 drivers/md/dm-ioctl.c |  7 +------
 drivers/md/dm-mpath.c | 22 +++++++++++-----------
 drivers/md/dm-table.c | 32 ++++++++------------------------
 4 files changed, 20 insertions(+), 42 deletions(-)

-- 
2.50.1


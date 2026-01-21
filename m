Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E14F374160
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 04:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768969414; cv=none; b=OOhGF06hGBOGI1oKYZkaTfMO3WpW+q7aHuAM4fUuTL5qzg0VXmcwzc/+5qCPWf2le7wCHQvDulxqk17CqGOdgdnwNG6XnwEeZd6ATkPbUgS6His2M/toftE8XQ+aLZwG4dsGpdhkdtQF64afzAnPtmTf4RaZ6drBMMGj9gQYODw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768969414; c=relaxed/simple;
	bh=AahwDtnm7Fg6wAxbCejORCYg9ZR5ohkxlenE35m7TBU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Y4a0x0pGGp9jNFL0TsGt3dR7d10ZXJZfwhr0CUliiTEe7ce4MGceEO+F8/AaWL61qkj2yjPDGKIuYGzBzMKBb8FIeEc8LNuSrAUb84FSXb7b9MQX5FMuZHaSYLYquUNZe6Ir8GDihdHVn+AOdYgRPpcSU4U7u6WikGhnq/ANZ7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WpuAgHdZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WpuAgHdZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768969400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vwpITb6jxVn0w9HhUt67eMBlAaa/t9aQV5jW62Caa8A=;
	b=WpuAgHdZgyOk5dntjLiYUS1V9rKolg6B3S8ewE4Krraz9czY/FQ2TujKpXhwYtw5O8sFe5
	sTyy3ahVApvKzD0G16d8Py0gHiko0Pb+9qVyKBQr4RIHQ5pq3rX0tmjGjgZ6sCQWqDHNE0
	/V94AdNFhIuzPGs+qf4J6xiMO6PMk40=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-106-Lv9ZjQ1MN1St6yJgQTxBqg-1; Tue,
 20 Jan 2026 23:23:18 -0500
X-MC-Unique: Lv9ZjQ1MN1St6yJgQTxBqg-1
X-Mimecast-MFC-AGG-ID: Lv9ZjQ1MN1St6yJgQTxBqg_1768969397
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FBDF19560B7;
	Wed, 21 Jan 2026 04:23:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F9BA19560AB;
	Wed, 21 Jan 2026 04:23:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60L4NF2C3914720
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Jan 2026 23:23:15 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60L4NFFI3914719;
	Tue, 20 Jan 2026 23:23:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/4] multipathd: Miscellaneous fixes
Date: Tue, 20 Jan 2026 23:23:11 -0500
Message-ID: <20260121042315.3914707-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: av56dMhl0hFCFvSk86kKY_330Uz2rkUtSeATejY5LRE_1768969397
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

Benjamin Marzinski (4):
  multipathd: don't add removed/partial paths to new maps
  multipathd: finish initalization of paths added while offline
  multipathd: make "multipathd show status" busy checker better
  multipathd: print path offline message even without a checker

 libmultipath/configure.c   | 12 +++++++-
 libmultipath/discovery.c   |  2 ++
 libmultipath/structs_vec.c |  3 +-
 libmultipath/uevent.c      | 17 ++++++++----
 multipathd/main.c          | 57 ++++++++++++++++++++++++++++++++------
 5 files changed, 74 insertions(+), 17 deletions(-)

-- 
2.50.1


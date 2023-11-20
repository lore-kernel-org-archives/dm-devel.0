Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2033A292
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W98YmQ/I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700519398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5O6myGB6q4nREWviTwNap7R5ybGY4l7+GblWS52Zp/k=;
	b=W98YmQ/Itck/vZLC7HlGT+wsOOVkKXwTlEi/5/KbPKbWPYRl/4H/ofixQ77zVzppvpRBFC
	fnhy7JLvLH3yLYbB5upaECaKB0vlPSqgYln+mWi76KSfWlWL3w1C7er0KRH+4oZujWnch2
	vTpQsGnYLbFruzVgyVW775NGpiKVjKc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-5-7CZTjMOc6IgsIIf_-HDA-1; Mon, 20 Nov 2023 17:29:57 -0500
X-MC-Unique: 5-7CZTjMOc6IgsIIf_-HDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05765185A781
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:57 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3C2E2166B27;
	Mon, 20 Nov 2023 22:29:56 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id EF63251CD9; Mon, 20 Nov 2023 17:29:56 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/3] dm vdo: clean up hash maps
Date: Mon, 20 Nov 2023 17:29:53 -0500
Message-ID: <cover.1700517230.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Remove duplicate pointer-map code and clean up int-map interface.

Bruce Johnston (3):
  dm vdo: remove pointer-map
  dm vdo int-map: rename functions to match device-mapper name style
  dm vdo int-map: remove unused parameter from vdo_int_map_create

 drivers/md/dm-vdo/block-map.c     |  12 +-
 drivers/md/dm-vdo/dedupe.c        |  50 ++-
 drivers/md/dm-vdo/dedupe.h        |   2 +-
 drivers/md/dm-vdo/int-map.c       |  29 +-
 drivers/md/dm-vdo/int-map.h       |   9 +-
 drivers/md/dm-vdo/io-submitter.c  |   8 +-
 drivers/md/dm-vdo/logical-zone.c  |   4 +-
 drivers/md/dm-vdo/physical-zone.c |   8 +-
 drivers/md/dm-vdo/pointer-map.c   | 696 ------------------------------
 drivers/md/dm-vdo/pointer-map.h   |  81 ----
 10 files changed, 57 insertions(+), 842 deletions(-)
 delete mode 100644 drivers/md/dm-vdo/pointer-map.c
 delete mode 100644 drivers/md/dm-vdo/pointer-map.h

-- 
2.42.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DA4481A4
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267194; cv=none; b=KAZrkrS5MaTZBvubME0PhkT/GG+QMk+MjpvoCw9tGUBkXMelL8Mc993Le6BDkqQmKFY1dsIc81QR85TJfVZs7JpKgmYeKXx4x+y5v9O12AmN1nYFXsVhBT0Suy5gIbQehaQli1lOCRDkmeIngA7T7yyEWSAP7MQujDPPwokGFpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267194; c=relaxed/simple;
	bh=PB4QX1vMK8uKUuKpZZoaypoZa641WVoj4cfS8lfY2EM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O1TyluTQ9bvDMQzdPGxA/+cls7SewWF5zWfvuLVuSOHH2sMmeBl7igGN9qq1Wt6h7PwbP1Ir1GAo2ftHJCpSudnd8Uv/VW66qtTe5y3bVaC4tHeGdu/YYgObTGkdQEirsOHOvg1MvDs9badfcHJ127imxr/2k7SxkRCwnMxR8GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CbPBYSKI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CbPBYSKI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OWCBxzOfuspB1/c0LqFN0yebb3OuOffxPU5PjaHQa9o=;
	b=CbPBYSKIXSv1ZQ1VcYJ0Vx6+/ZjFhGf/UQqK+iVW9d9sQH8XIu8XH0UV7KAA6pZDqh2sc6
	aBJZYxTPkE2ZeWVtkMezjj4+oYpBdPORU+RlSWHM6f2Dtm7FGSkm1Pv3Tv+TT2loiV1/Hf
	Ebr2JjuMm1NSJxhJF6AkflVOxgMjuhI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-282-R9W0F8ZaO3yRPafHt3_-3A-1; Thu,
 29 Feb 2024 23:26:30 -0500
X-MC-Unique: R9W0F8ZaO3yRPafHt3_-3A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7CFB2999B26
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:29 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD7824D903;
	Fri,  1 Mar 2024 04:26:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id C45E2A15C9; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 00/11] dm vdo: fix minor comment issues
Date: Thu, 29 Feb 2024 23:26:18 -0500
Message-ID: <cover.1709266694.git.msakai@redhat.com>
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

Jiapeng Chong (8):
  dm vdo: Modify mismatched function name
  dm vdo slab-depot: Modify mismatched function name
  dm vdo: Modify mismatched function name
  dm vdo: Modify mismatched function name
  dm vdo: Modify mismatched function name
  dm vdo: Modify mismatched function name
  dm vdo dedupe: Modify mismatched function name
  dm vdo: Modify mismatched function name

Matthew Sakai (3):
  dm vdo indexer delta-index: fix typos in comments
  dm vdo: update module comments
  dm vdo: remove outdated pointer_map reference

 drivers/md/dm-vdo/admin-state.c         |  2 +-
 drivers/md/dm-vdo/dedupe.c              |  2 +-
 drivers/md/dm-vdo/dm-vdo-target.c       | 11 +++--------
 drivers/md/dm-vdo/encodings.c           |  2 +-
 drivers/md/dm-vdo/flush.c               |  2 +-
 drivers/md/dm-vdo/indexer/delta-index.c |  2 +-
 drivers/md/dm-vdo/indexer/delta-index.h |  2 +-
 drivers/md/dm-vdo/logical-zone.c        |  4 ++--
 drivers/md/dm-vdo/physical-zone.c       |  2 +-
 drivers/md/dm-vdo/slab-depot.c          |  6 +++---
 drivers/md/dm-vdo/vdo.c                 |  9 +++------
 11 files changed, 18 insertions(+), 26 deletions(-)

-- 
2.42.0


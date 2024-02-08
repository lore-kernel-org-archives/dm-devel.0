Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF49823DB
	for <dm-devel@lists.linux.dev>; Thu,  8 Feb 2024 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707415761; cv=none; b=TOVSFp4pFtmZgNBu6Tq84h4aV2t0YWVBerrdKNOH0d3c1PFOMx9WIr/+g94gbhs9PKQbbSN2PbxuVDQQjkHsmEUdYLHUtzsDB2AbFKWpimX9yIJpq1qeura12tmfHs+P1aJx9pXqe99lwCrHMDZBLYJ3IDpnxSG7X9moHsyKcPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707415761; c=relaxed/simple;
	bh=FVmDLzGpOnIKgb4xBU/bxSTjDK7uT2/M6uIz1JASi1w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hlL+h1u+HoQ//JAK3XaQBb7k5eO+yOJwSEolaPkLDToN4FV+MAvlUC9L9lhrxlceTToo15ng4ZrSX1UXftusVDam4hXX7AgKEtB+d8uEQ5NHUaP9GmfFcjK8TwWZ+2zBQExThweklRVsLf4q1fGsRGyOY43lQuRgLgfEfct0z/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YrYNH10H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YrYNH10H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707415758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s6uGsChsvAm4adQlKfFlJTV3eBatOm/QTkHe8dbfQYY=;
	b=YrYNH10H3hVI904/3hORLqTja0tacqFuSMi80m9uwwrjLVyKwqDMswkNvIIOwxfVFphg1b
	PQv192BZD752VZg43148D53mhQm6KTOts9VkEw0v7xLXaViF9VNQ4h3QvwfLc6JHDnlr8L
	wOnPNE5dZzW6O6fOiHvebe1JEFNKlaY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-dxFB6hsDMe2pvs4813wlYA-1; Thu, 08 Feb 2024 13:09:16 -0500
X-MC-Unique: dxFB6hsDMe2pvs4813wlYA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1560E85A59C
	for <dm-devel@lists.linux.dev>; Thu,  8 Feb 2024 18:09:16 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C8282166B31;
	Thu,  8 Feb 2024 18:09:16 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 0369556C5E; Thu,  8 Feb 2024 13:09:16 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/3] dm vdo: improve documentation
Date: Thu,  8 Feb 2024 13:09:12 -0500
Message-ID: <cover.1707415327.git.msakai@redhat.com>
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

Add details about I/O handling in vdo, and details about
concurrency and locking. Also add vdo documentation to
the device-mapper doc index.

Matthew Sakai (3):
  dm vdo: add vdo documentation to device-mapper index
  dm vdo: add vio lifecycle details to doc
  dm vdo: add documentation details on zones and locking

 .../admin-guide/device-mapper/index.rst       |   2 +
 .../admin-guide/device-mapper/vdo-design.rst  | 674 ++++++++++++------
 drivers/md/dm-vdo/block-map.h                 |  15 +
 drivers/md/dm-vdo/dedupe.c                    |   5 +
 drivers/md/dm-vdo/recovery-journal.h          |   4 +
 drivers/md/dm-vdo/slab-depot.h                |  16 +-
 6 files changed, 483 insertions(+), 233 deletions(-)

-- 
2.42.0


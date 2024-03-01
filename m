Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D62245BEA
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265189; cv=none; b=mgXhNhyOL4aWd++LUVSM+qecsOweiOBNaTJsGu+hAyUtBlNnfInZ5Ih86i8XN1sIuFUizp3xBxSbEvmjpP6MWpeOeDvJwEyMk0OQGVGAPvHWZotmcRE7B+lFHm6hwJyc8sRURldwkY1W6qv8UDfDSsDauAIDFpxSZ5xveCuzkXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265189; c=relaxed/simple;
	bh=ltnj2DV9F6MAkZBpHGNx2vGh8qxNdSk27gxvVGffuY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NP8WG1WufvLpq2ef7rk5K+SoZJa3hGJ+B+HqRAU92MOdOl9f4KChQ9pHF0CkV4GWnsjE+TctRFyAfLBIoRriKPJtMxfxsSmHrdoLmw0f5CUpS03A/edQHdgyPdHu1j49HY3aRIVEQFTbnUMv5JE7HMfceVtwOKWseYq9azHiGsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VoQpk1ds; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VoQpk1ds"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4O59QkcxQ2LexOdlqiAIxEHaPTpGXpYBXszbeK+v1pE=;
	b=VoQpk1ds74cDkU1DavuKeYu38zQrLxgza8z/6reDfOjJoJBi20ImJlO6d0hY8dh77WPOBB
	vgpQx+PehPyyMhDqvhqI91ErjzBvMZy5sN4Q9zd/BgU1HZANm2/+D/trr8v1NCnBDMW3Tn
	/C1UFnd6WDkfsGx7fiBNOGfIhwarGDc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-YbO9Ai3DN7iCR8uP8pH0iA-1; Thu,
 29 Feb 2024 22:53:05 -0500
X-MC-Unique: YbO9Ai3DN7iCR8uP8pH0iA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50E401C0513A
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4BF8E492BE2;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4308E9EB21; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 00/13] dm vdo: clean up and simplify thread utilities
Date: Thu, 29 Feb 2024 22:52:52 -0500
Message-ID: <cover.1709264538.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Rename uds-threads to thread-utils, and simplify thread and
synchronization utilities. Move some utilities closer to their
only users.

Mike Snitzer (13):
  dm vdo: make uds_*_semaphore interface private to uds-threads.c
  dm vdo uds-threads: eliminate uds_*_semaphore interfaces
  dm vdo uds-threads: push 'barrier' down to sparse-cache
  dm vdo indexer sparse-cache: cleanup threads_barrier code
  dm vdo: rename uds-threads.[ch] to thread-utils.[ch]
  dm vdo indexer: rename uds.h to indexer.h
  dm vdo: fold thread-cond-var.c into thread-utils
  dm vdo thread-utils: push uds_*_cond interface down to indexer
  dm vdo thread-utils: remove all uds_*_mutex wrappers
  dm vdo thread-utils: further cleanup of thread functions
  dm vdo thread-utils: cleanup included headers
  dm vdo thread-registry: rename all methods to reflect vdo-only use
  dm vdo thread-device: rename all methods to reflect vdo-only use

 drivers/md/dm-vdo/Makefile                    |   3 +-
 drivers/md/dm-vdo/chapter-index.c             |   2 +-
 drivers/md/dm-vdo/config.c                    |   2 +-
 drivers/md/dm-vdo/config.h                    |   2 +-
 drivers/md/dm-vdo/data-vio.h                  |   2 +-
 drivers/md/dm-vdo/dedupe.c                    |   2 +-
 drivers/md/dm-vdo/dedupe.h                    |   2 +-
 drivers/md/dm-vdo/delta-index.c               |   2 +-
 drivers/md/dm-vdo/dm-vdo-target.c             |  30 ++--
 drivers/md/dm-vdo/encodings.h                 |   2 +-
 drivers/md/dm-vdo/funnel-queue.c              |   1 -
 drivers/md/dm-vdo/funnel-requestqueue.c       |  10 +-
 drivers/md/dm-vdo/funnel-requestqueue.h       |   2 +-
 drivers/md/dm-vdo/geometry.c                  |   2 +-
 drivers/md/dm-vdo/geometry.h                  |   2 +-
 drivers/md/dm-vdo/hash-utils.h                |   2 +-
 drivers/md/dm-vdo/index-layout.h              |   2 +-
 drivers/md/dm-vdo/index-page-map.c            |   4 +-
 drivers/md/dm-vdo/index-session.c             | 138 ++++++++----------
 drivers/md/dm-vdo/index-session.h             |   4 +-
 drivers/md/dm-vdo/index.c                     |  54 +++----
 drivers/md/dm-vdo/{uds.h => indexer.h}        |  30 +++-
 drivers/md/dm-vdo/logger.c                    |   5 +-
 drivers/md/dm-vdo/memory-alloc.c              |  12 +-
 drivers/md/dm-vdo/sparse-cache.c              | 105 +++++++++----
 drivers/md/dm-vdo/sparse-cache.h              |   2 +-
 drivers/md/dm-vdo/status-codes.c              |   4 +-
 drivers/md/dm-vdo/thread-cond-var.c           |  46 ------
 drivers/md/dm-vdo/thread-device.c             |  18 +--
 drivers/md/dm-vdo/thread-device.h             |  14 +-
 drivers/md/dm-vdo/thread-registry.c           |   8 +-
 drivers/md/dm-vdo/thread-registry.h           |  14 +-
 .../dm-vdo/{uds-threads.c => thread-utils.c}  |  62 +-------
 drivers/md/dm-vdo/thread-utils.h              |  22 +++
 drivers/md/dm-vdo/uds-sysfs.c                 |   2 +-
 drivers/md/dm-vdo/uds-threads.h               | 115 ---------------
 drivers/md/dm-vdo/vdo.h                       |   2 +-
 drivers/md/dm-vdo/volume-index.c              |  44 +++---
 drivers/md/dm-vdo/volume-index.h              |   4 +-
 drivers/md/dm-vdo/volume.c                    |  59 +++-----
 drivers/md/dm-vdo/volume.h                    |   4 +-
 41 files changed, 328 insertions(+), 514 deletions(-)
 rename drivers/md/dm-vdo/{uds.h => indexer.h} (95%)
 delete mode 100644 drivers/md/dm-vdo/thread-cond-var.c
 rename drivers/md/dm-vdo/{uds-threads.c => thread-utils.c} (70%)
 create mode 100644 drivers/md/dm-vdo/thread-utils.h
 delete mode 100644 drivers/md/dm-vdo/uds-threads.h

-- 
2.42.0


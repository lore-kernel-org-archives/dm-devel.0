Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F671C6B4
	for <dm-devel@lists.linux.dev>; Fri,  3 Oct 2025 14:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759500621; cv=none; b=RmzSJO4nN2d1q0lJufmGSJrLBcp5llUqZRTdZ2mSVqf58hNL9O3oA/Qeh9zrfsENHcM1SDMeuF7s64VXqbh59SUcaZ76Oxyor4K/ZCY6C4T4VW265bHNWHO+eTUP6+OIBA6riD/5IFVQU8Lqv70Jp0W+AfvRa9VintztAkDVRr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759500621; c=relaxed/simple;
	bh=WJIm4ZTekmonlosaD0lFOeIeFsOIR4sAGmdfyRQmA7A=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Seq0UkxiwR1Yd9TrVn+yFnH/omgS9dey0GoOjbZ3neTHj5tC9A293/qye6Aytx/SpI1PquGohytYXbV5EVrPVIcL0nD3U6sxTTcnRHuZRV4yXSVH1U8WNZ8qrrSacEx6myBfBRN5FwIgrUS5LwjrqQfa/EVtHuMMiHf8LQGWqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IumnivV1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IumnivV1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759500614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=sY9qTu6zv/BZbTEQhVr3CtzTWvRCwcCo2GBBQ6QUbYg=;
	b=IumnivV1JhILJ26xLxjqayLrT3OdxD5RSlG8Z2qZCAsi2Vdbzz91YXxcKc5ttd2ac2hU4X
	YWpabsDwcML3b+fymSDGILO3n/x8NP6rj6DbGescZIIdDUsSYSqT88iSTvoHCJYFt9kwmZ
	qDEY2ZpLHiEMYkhNbbswIdEl7uiSRjc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-WS2gTV5HMP2idvlsRZrfdg-1; Fri,
 03 Oct 2025 10:10:11 -0400
X-MC-Unique: WS2gTV5HMP2idvlsRZrfdg-1
X-Mimecast-MFC-AGG-ID: WS2gTV5HMP2idvlsRZrfdg_1759500609
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35E441800447;
	Fri,  3 Oct 2025 14:10:08 +0000 (UTC)
Received: from [10.45.225.152] (unknown [10.45.225.152])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6CDC1800982;
	Fri,  3 Oct 2025 14:10:02 +0000 (UTC)
Date: Fri, 3 Oct 2025 16:09:55 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Bagas Sanjaya <bagasdotme@gmail.com>, Bruce Johnston <bjohnsto@redhat.com>, 
    Dmitry Antipov <dmantipov@yandex.ru>, 
    Dongsheng Yang <dongsheng.yang@linux.dev>, 
    Heinz Mauelshagen <heinzm@redhat.com>, Christoph Hellwig <hch@lst.de>, 
    Ivan Abramov <i.abramov@mt-integration.ru>, 
    Qianfeng Rong <rongqianfeng@vivo.com>, 
    Shubham Sharma <slopixelz@gmail.com>, Soham Metha <sohammetha01@gmail.com>, 
    Xichao Zhao <zhao.xichao@vivo.com>, Zheng Qixing <zhengqixing@huawei.com>, 
    Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper changes for 6.18
Message-ID: <b85c04ba-3708-82b2-72b0-63d026c4d7c0@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GRQPidpxKVdZmk22IIJsT6wgDGUONNWdu3fI5VFD-Pw_1759500609
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.18/dm-changes

for you to fetch changes up to 55dcfdf8af9c38cce6f5b2058d3b58dde25e5020:

  dm raid: use proper md_ro_state enumerators (2025-09-23 14:51:04 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
dm docs: fix typos

dm, dm-ima, dm-bufio, dm-vdo, dm-raid: small refactoring

dm-error: mark it with DM_TARGET_PASSES_INTEGRITY

dm-pcache: a new target for read/write caching on persistent memory

dm-request-based: fix NULL pointer dereference and quiesce_depth out of sync

dm-linear: optimize REQ_PREFLUSH

dm-vdo: return error on corrupted metadata

dm-integrity: support asynchronous hash interface
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaN/T8RQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbdPWAP9JEpnq09RzwneB/FdCE2WsjInsAaas
eYqKrkgoatVzOwEAoqEzYb9IUrKMZbFPdWzEA1aXUBCH+UAKhm+G9WG5Vw0=
=dCXi
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Bagas Sanjaya (1):
      dm-vdo: Promote dm-vdo title to title heading

Bruce Johnston (1):
      dm vdo: Update code to use mem_is_zero

Christoph Hellwig (1):
      dm error: mark as DM_TARGET_PASSES_INTEGRITY

Dmitry Antipov (1):
      dm-ima: more strlen() drops

Dongsheng Yang (3):
      dm-pcache: add persistent cache target in device-mapper
      dm-pcache: remove ctrl_lock for pcache_cache_segment
      dm-pcache: cleanup: fix coding style report by checkpatch.pl

Heinz Mauelshagen (1):
      dm raid: use proper md_ro_state enumerators

Ivan Abramov (1):
      dm vdo: return error on corrupted metadata in start_restoring_volume functions

Mikulas Patocka (10):
      dm-ima: drop a useless argument
      dm: optimize REQ_PREFLUSH with data when using the linear target
      dm-integrity: use internal variable for digestsize
      dm-integrity: replace bvec_kmap_local with kmap_local_page
      dm-integrity: introduce integrity_kmap and integrity_kunmap
      dm-integrity: allocate the recalculate buffer with kmalloc
      dm-integrity: add the "offset" argument
      dm-integrity: rename internal_hash
      dm-integrity: enable asynchronous hash interface
      dm-integrity: prefer synchronous hash interface

Qianfeng Rong (3):
      dm: use vmalloc_array() to simplify code
      dm bufio: remove redundant __GFP_NOWARN
      dm-pcache: use int type to store negative error codes

Shubham Sharma (1):
      docs: device-mapper: fix typos in delay.rst and vdo-design.rst

Soham Metha (1):
      docs: device-mapper: fixed spelling mistakes in documentation

Xichao Zhao (1):
      dm: fix "writen"->"written"

Zheng Qixing (2):
      dm: fix queue start/stop imbalance under suspend/load/resume races
      dm: fix NULL pointer dereference in __dm_suspend()

 Documentation/admin-guide/device-mapper/delay.rst  |   8 +-
 .../admin-guide/device-mapper/dm-pcache.rst        | 202 +++++
 Documentation/admin-guide/device-mapper/index.rst  |   1 +
 .../admin-guide/device-mapper/vdo-design.rst       |   2 +-
 Documentation/admin-guide/device-mapper/vdo.rst    |   1 +
 MAINTAINERS                                        |   8 +
 drivers/md/Kconfig                                 |   2 +
 drivers/md/Makefile                                |   1 +
 drivers/md/dm-bufio.c                              |  10 +-
 drivers/md/dm-cache-policy-smq.c                   |   2 +-
 drivers/md/dm-core.h                               |   2 +
 drivers/md/dm-ima.c                                |  70 +-
 drivers/md/dm-integrity.c                          | 359 ++++++---
 drivers/md/dm-log-writes.c                         |   2 +-
 drivers/md/dm-pcache/Kconfig                       |  17 +
 drivers/md/dm-pcache/Makefile                      |   3 +
 drivers/md/dm-pcache/backing_dev.c                 | 374 +++++++++
 drivers/md/dm-pcache/backing_dev.h                 | 127 +++
 drivers/md/dm-pcache/cache.c                       | 445 +++++++++++
 drivers/md/dm-pcache/cache.h                       | 635 +++++++++++++++
 drivers/md/dm-pcache/cache_dev.c                   | 303 +++++++
 drivers/md/dm-pcache/cache_dev.h                   |  70 ++
 drivers/md/dm-pcache/cache_gc.c                    | 170 ++++
 drivers/md/dm-pcache/cache_key.c                   | 888 +++++++++++++++++++++
 drivers/md/dm-pcache/cache_req.c                   | 836 +++++++++++++++++++
 drivers/md/dm-pcache/cache_segment.c               | 305 +++++++
 drivers/md/dm-pcache/cache_writeback.c             | 261 ++++++
 drivers/md/dm-pcache/dm_pcache.c                   | 497 ++++++++++++
 drivers/md/dm-pcache/dm_pcache.h                   |  67 ++
 drivers/md/dm-pcache/pcache_internal.h             | 117 +++
 drivers/md/dm-pcache/segment.c                     |  61 ++
 drivers/md/dm-pcache/segment.h                     |  74 ++
 drivers/md/dm-raid.c                               |  13 +-
 drivers/md/dm-region-hash.c                        |   2 +-
 drivers/md/dm-switch.c                             |   4 +-
 drivers/md/dm-target.c                             |   3 +-
 drivers/md/dm-thin.c                               |   4 +-
 drivers/md/dm-vdo/data-vio.c                       |  17 +-
 drivers/md/dm-vdo/indexer/volume-index.c           |   4 +-
 drivers/md/dm.c                                    |  45 +-
 40 files changed, 5830 insertions(+), 182 deletions(-)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-pcache.rst
 create mode 100644 drivers/md/dm-pcache/Kconfig
 create mode 100644 drivers/md/dm-pcache/Makefile
 create mode 100644 drivers/md/dm-pcache/backing_dev.c
 create mode 100644 drivers/md/dm-pcache/backing_dev.h
 create mode 100644 drivers/md/dm-pcache/cache.c
 create mode 100644 drivers/md/dm-pcache/cache.h
 create mode 100644 drivers/md/dm-pcache/cache_dev.c
 create mode 100644 drivers/md/dm-pcache/cache_dev.h
 create mode 100644 drivers/md/dm-pcache/cache_gc.c
 create mode 100644 drivers/md/dm-pcache/cache_key.c
 create mode 100644 drivers/md/dm-pcache/cache_req.c
 create mode 100644 drivers/md/dm-pcache/cache_segment.c
 create mode 100644 drivers/md/dm-pcache/cache_writeback.c
 create mode 100644 drivers/md/dm-pcache/dm_pcache.c
 create mode 100644 drivers/md/dm-pcache/dm_pcache.h
 create mode 100644 drivers/md/dm-pcache/pcache_internal.h
 create mode 100644 drivers/md/dm-pcache/segment.c
 create mode 100644 drivers/md/dm-pcache/segment.h


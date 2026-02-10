Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1861E3161BA
	for <dm-devel@lists.linux.dev>; Tue, 10 Feb 2026 12:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770726567; cv=none; b=YC2Ks7Odq/aAEjRFNki66xPwHYn8vd+3CN+w9bkfqC63zY3JwB+alUuhqXTM9nT8sooUAvbrSITH9tPCp071uUtz4pNg8CXht2Konvqgt/XR6UR1ssoEL9NPPBkLYGeK/b2Whk8C+wcLMvAbp3UEIBx2dGrBBpP2KUEvptyB+Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770726567; c=relaxed/simple;
	bh=RsyYNrHHPp8GYF/Ary6boMWMQhrgk7f69ocSLQAl+pM=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=IBQp+WxUpy5yu1q7pVce6qu8RYkDNPY2oBo+QFFy8KN2Xc/SNnQKF41MY76gowlDk2km7v4Qu3oz+dKDGeNIwFFszWkP9TA3eapTzBC8m6AoRh5I0p3HLU9lseOmH6rzT2FETtPFxtC+OsHZNnfpcNv1Ehm3RIfOexBVC2Wx4bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h2kAtSbI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h2kAtSbI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770726565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=sEMUHg7qUKeVJbxxnzL/14gnOnczs8wHnLt8MZj16Wc=;
	b=h2kAtSbIBIttnpBjoJCgEkUz+AD5juQimmQy3YjWat06IeYEhdVeSNcyol2wYL8GBiepqj
	qhq17jJmHsYIYku+1JXYvtijFtOOPeuCO/50exbSxiwKK6+lzB/EsXqtP3YuUOUvyTAW2t
	iLIMCE+SfmgtS9WxILq5TxMwot8uwsE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-QEXCQxsGOPyNQ7m8e4Knpg-1; Tue,
 10 Feb 2026 07:29:19 -0500
X-MC-Unique: QEXCQxsGOPyNQ7m8e4Knpg-1
X-Mimecast-MFC-AGG-ID: QEXCQxsGOPyNQ7m8e4Knpg_1770726557
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49A7E19560A5;
	Tue, 10 Feb 2026 12:29:16 +0000 (UTC)
Received: from [10.45.224.59] (unknown [10.45.224.59])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C743C30002D5;
	Tue, 10 Feb 2026 12:29:10 +0000 (UTC)
Date: Tue, 10 Feb 2026 13:29:05 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, Akiyoshi Kurita <weibu@redadmin.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Daniel Gomez <da.gomez@samsung.com>, Ding Hui <dinghui@sangfor.com.cn>, 
    Eric Biggers <ebiggers@kernel.org>, Christian Brauner <brauner@kernel.org>, 
    Julia Lawall <Julia.Lawall@inria.fr>, Li Chen <me@linux.beauty>, 
    Marco Crivellari <marco.crivellari@suse.com>, 
    Matthew Sakai <msakai@redhat.com>, 
    Matt Whitlock <kernel@mattwhitlock.name>, 
    Michael Liang <mliang@purestorage.com>, 
    Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [git pull] device mapper changes for 7.0
Message-ID: <30b93671-3771-b7ce-2553-e0bc1a4a17d2@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TzQSozWUtW8G9XiWRlJuAWF-yHnCY-8CIM0XKm3pMSw_1770726557
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da:

  Linux 6.19-rc3 (2025-12-28 13:24:26 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.0/dm-changes

for you to fetch changes up to 218b16992a37ea97b9e09b7659a25a864fb9976f:

  dm mpath: make pg_init_delay_msecs settable (2026-01-28 15:45:34 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- dm-verity: various optimizations and fixes related to forward error
  correction

- dm-verity: add a .dm-verity keyring

- dm-integrity: fix bugs with growing a device in bitmap mode

- dm-mpath: fix leaking fake timeout requests, a UAF bug caused by stale
  rq->bio and minor bugs in device creation

- dm-core: fix a bug related to blkg association, avoid unnecessary
  blk-crypto work on invalid keys

- dm-bufio: dm-bufio cleanup and optimization (reducing hash table
  lookups)

- various other minor fixes and cleanups
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaYsfghQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbcwnAP9Ny3YqC63GI5qH2cd8N42zRQ8P4sN+
k4cz1XtrstoA4wEA/357lutlowGgUoHUkVRKK03AcGnbcVJk0yMyRDo/0gs=
=wvTt
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Akiyoshi Kurita (1):
      dm-raid: fix typo in documentation

Benjamin Marzinski (3):
      dm mpath: Add missing dm_put_device when failing to get scsi dh name
      Revert "dm: fix a race condition in retrieve_deps"
      dm mpath: make pg_init_delay_msecs settable

Christian Brauner (2):
      dm-verity: add dm-verity keyring
      selftests: add dm-verity keyring selftests

Daniel Gomez (1):
      dm: replace -EEXIST with -EBUSY

Ding Hui (1):
      dm: remove fake timeout to avoid leak request

Eric Biggers (13):
      dm-verity: move dm_verity_fec_io to mempool
      dm-verity: make dm_verity_fec_io::bufs variable-length
      dm-verity: remove unnecessary condition for verity_fec_finish_io()
      dm-verity: remove unnecessary ifdef around verity_fec_decode()
      dm-verity: make verity_fec_is_enabled() an inline function
      dm-verity: correctly handle dm_bufio_client_create() failure
      dm-verity: allow REED_SOLOMON to be 'm' if DM_VERITY is 'm'
      dm-verity: consolidate the BH and normal work structs
      dm-verity: switch to bio_advance_iter_single()
      dm-verity: fix up various workqueue-related comments
      dm-bufio: merge cache_put() into cache_put_and_wake()
      dm-bufio: avoid redundant buffer_tree lookups
      dm: fix excessive blk-crypto operations for invalid keys

Julia Lawall (1):
      dm-vdo: adjust function name reference

Li Chen (2):
      dm cache: drop redundant origin size check
      dm clone: drop redundant size checks

Marco Crivellari (1):
      dm: add WQ_PERCPU to alloc_workqueue users

Matt Whitlock (1):
      dm-unstripe: fix mapping bug when there are multiple targets in a table

Matthew Sakai (1):
      dm vdo encodings: clean up header and version functions

Michael Liang (1):
      dm: clear cloned request bio pointer when last clone bio completes

Mikulas Patocka (6):
      dm: fix unlocked test for dm_suspended_md
      dm: use READ_ONCE in dm_blk_report_zones
      dm-integrity: fix a typo in the code for write/discard race
      dm-integrity: fix recalculation in bitmap mode
      dm-verity: fix section mismatch error
      dm: use bio_clone_blkg_association

Yongpeng Yang (1):
      dm-stripe: adjust max_hw_discard_sectors to avoid unnecessary discard bio splitting

 .../admin-guide/device-mapper/dm-raid.rst          |   2 +-
 Documentation/admin-guide/kernel-parameters.txt    |   7 +
 drivers/md/Kconfig                                 |   4 +-
 drivers/md/dm-bufio.c                              | 173 ++--
 drivers/md/dm-cache-target.c                       |  10 +-
 drivers/md/dm-clone-target.c                       |  19 +-
 drivers/md/dm-core.h                               |   1 -
 drivers/md/dm-crypt.c                              |   6 +-
 drivers/md/dm-delay.c                              |   4 +-
 drivers/md/dm-exception-store.c                    |   2 +-
 drivers/md/dm-integrity.c                          |  30 +-
 drivers/md/dm-ioctl.c                              |   7 +-
 drivers/md/dm-kcopyd.c                             |   3 +-
 drivers/md/dm-log-userspace-base.c                 |   3 +-
 drivers/md/dm-log.c                                |   2 +-
 drivers/md/dm-mpath.c                              |  27 +-
 drivers/md/dm-path-selector.c                      |   2 +-
 drivers/md/dm-raid1.c                              |   5 +-
 drivers/md/dm-rq.c                                 |  16 +-
 drivers/md/dm-snap-persistent.c                    |   3 +-
 drivers/md/dm-stripe.c                             |  12 +-
 drivers/md/dm-table.c                              |  44 +-
 drivers/md/dm-target.c                             |   2 +-
 drivers/md/dm-unstripe.c                           |   2 +-
 drivers/md/dm-vdo/data-vio.h                       |   4 +-
 drivers/md/dm-vdo/encodings.c                      |  11 +-
 drivers/md/dm-vdo/encodings.h                      |  25 -
 drivers/md/dm-verity-fec.c                         | 134 ++--
 drivers/md/dm-verity-fec.h                         |  35 +-
 drivers/md/dm-verity-target.c                      |  65 +-
 drivers/md/dm-verity-verify-sig.c                  |  45 ++
 drivers/md/dm-verity-verify-sig.h                  |  12 +
 drivers/md/dm-verity.h                             |   5 +-
 drivers/md/dm-writecache.c                         |   3 +-
 drivers/md/dm-zone.c                               |  11 +-
 drivers/md/dm.c                                    |   5 +-
 drivers/md/md.c                                    |   4 +-
 tools/testing/selftests/dm-verity/Makefile         |   5 +
 tools/testing/selftests/dm-verity/config           |  10 +
 .../selftests/dm-verity/test-dm-verity-keyring.sh  | 873 +++++++++++++++++++++
 40 files changed, 1300 insertions(+), 333 deletions(-)
 create mode 100644 tools/testing/selftests/dm-verity/Makefile
 create mode 100644 tools/testing/selftests/dm-verity/config
 create mode 100755 tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh


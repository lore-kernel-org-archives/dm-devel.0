Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E253B8D75
	for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 19:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765394302; cv=none; b=RwUyliit+xBGZLUvJynSswCe6I0jwVXff49NK54+HzBnXyNF/s0T10j90EyvkDAMygH/buxpgliMYjtzXNo7Z2dYLZ3TVehVrZZPewKs5Vq8rxM9PfM6rMDCP95rTLsQr6xeZmhVSocfwIhvrnSU+97rUT60YBW72YyN8P4iMj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765394302; c=relaxed/simple;
	bh=/L0FoJRiOYdwAMQ+BmIlQu7Tz8fB9gCxOOvh45a7xg8=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=iYr13ypNupTPMfhPa3ItGNSeyBTrAWH2ErssMPzJZrrtbhdU6lZwSZWzlwAs+ssyTFfy5ZnaWHmPScTU2oU2kVwpxXLWW5wy4iGUZ6YmMIcIcuRDkw4Izr/UaePhQFri5d1UwD6/zQF/rtpdlmRs0t7xwSowK1QfpvlQHVD42i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M8uNsJvE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M8uNsJvE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765394299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=bkNPsdVpu4fUhyrHE6hblgU0SnJbmMs/AsS+mWymFFI=;
	b=M8uNsJvEsbnZMWZYXNTn9hjylli17OJx2hEuf0GTZyf59ygjWJ4R8foAZfidzhVfv4BOE6
	DSKrEfQu4Fw3pJbLlyv3OxOWW8/udoO/Eu48MQbE1SQ46fKRCTJHMdOyPhKwOaBpG7+NFW
	rCmyWv8p88IgPqbuzYmdRtXkxC2mUl0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-4ppHsv1BNQuJiy6YVFvYDQ-1; Wed,
 10 Dec 2025 14:18:16 -0500
X-MC-Unique: 4ppHsv1BNQuJiy6YVFvYDQ-1
X-Mimecast-MFC-AGG-ID: 4ppHsv1BNQuJiy6YVFvYDQ_1765394294
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 483F01956089;
	Wed, 10 Dec 2025 19:18:13 +0000 (UTC)
Received: from [10.44.32.23] (unknown [10.44.32.23])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F3191956095;
	Wed, 10 Dec 2025 19:18:06 +0000 (UTC)
Date: Wed, 10 Dec 2025 20:18:03 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, Alexey Simakov <bigalex934@gmail.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Dongsheng Yang <dongsheng.yang@linux.dev>, 
    Eric Biggers <ebiggers@kernel.org>, Haotian Zhang <vulab@iscas.ac.cn>, 
    Heinz Mauelshagen <heinzm@redhat.com>, 
    Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, 
    John Garry <john.g.garry@oracle.com>, Jon Hunter <jonathanh@nvidia.com>, 
    Li Chen <chenl311@chinatelecom.cn>, Matthew Sakai <msakai@redhat.com>, 
    Mikulas Patocka <mpatocka@redhat.com>, 
    Pedro Demarchi Gomes <pedrodemargomes@gmail.com>, 
    Shubhankar Mishra <shubhankarm@google.com>, 
    Uladzislau Rezki <urezki@gmail.com>, 
    Vivek BalachandharTN <vivek.balachandhar@gmail.com>
Subject: [git pull] device mapper changes for 6.19
Message-ID: <2b7fa07e-cf1c-73a7-d1eb-5d6082e08b29@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ggA8444fmGoRo34qU6sP7qm_8BW3LkAydxL4PjWLZoc_1765394294
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.19/dm-changes

for you to fetch changes up to 13ea55ea20176736516b20b9ea2d8cf97dbe74f5:

  dm pcache: fix segment info indexing (2025-12-10 19:28:23 +0100)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
small dm code refactoring

fix deadlock when reloading a multipath table

don't warn if IMA_DISABLE_HTABLE is not enabled

test for REQ_ATOMIC in dm_accept_partial_bio()

ignore discard return value

MAINTAINERS: add Benjamin Marzinski as a device mapper maintainer

dm-bufio: align write boundary on physical block size

dm-crypt: use the MD5 library directly

dm-crypt: use folio_nr_pages() instead of shift operation

dm-crypt: enable DM_TARGET_ATOMIC_WRITES

dm-verity: remove log message with shash driver name

dm-verity: use the SHA-256 library directly

dm-verity: use 2-way interleaved SHA-256 hashing when supported

dm-verity: expose corrected block count via status

dm-verity: disable recursive forward error correction

dm-verity: remove useless mempool

dm-mpath: enable DM_TARGET_ATOMIC_WRITES

dm-mpath: simplify the setup_scsi_dh code

dm-ebs: mark full buffer dirty even on partial write

dm-vdo: fix kerneldoc warnings

dm-snapshot: fix 'scheduling while atomic' on real-time kernels

dm-raid: fix possible NULL dereference with undefined raid type

dm raid: add documentation for takeover/reshape raid1 -> raid5 table line examples

dm-log-writes: add missing set_freezable() for freezable kthread

dm-pcache: fixes in indexing code
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaTnD7BQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbS3NAQCfc83GS5i7D4NoOjYP7PNElendmc99
WxsetuFT4dQYKAD/UgistGLf6vQ5LGE8Kp9YWsQ6hb8BgjoKo0mSjwCHQgQ=
=C9Du
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Alexey Simakov (1):
      dm-raid: fix possible NULL dereference with undefined raid type

Benjamin Marzinski (3):
      dm: remove useless md->nr_zones variable
      dm: Fix deadlock when reloading a multipath table
      dm-mpath: Simplify the setup_scsi_dh code

Chaitanya Kulkarni (1):
      dm: ignore discard return value

Dongsheng Yang (1):
      dm-pcache: advance slot index before writing slot

Eric Biggers (5):
      dm-crypt: Use MD5 library instead of crypto_shash
      dm-verity: remove log message with shash driver name
      dm-verity: use SHA-256 library for SHA-256
      dm-verity: reduce scope of real and wanted digests
      dm-verity: use 2-way interleaved SHA-256 hashing when supported

Haotian Zhang (1):
      dm log-writes: Add missing set_freezable() for freezable kthread

Heinz Mauelshagen (1):
      dm raid: add documentation for takeover/reshape raid1 -> raid5 table line examples

John Garry (1):
      dm mpath: enable DM_TARGET_ATOMIC_WRITES

Jon Hunter (1):
      dm: Don't warn if IMA_DISABLE_HTABLE is not enabled

Li Chen (2):
      dm pcache: fix cache info indexing
      dm pcache: fix segment info indexing

Matthew Sakai (1):
      dm vdo: fix kerneldoc warnings

Mikulas Patocka (7):
      dm-verity: disable recursive forward error correction
      dm-verity: remove useless mempool
      dm: test for REQ_ATOMIC in dm_accept_partial_bio()
      dm-crypt: enable DM_TARGET_ATOMIC_WRITES
      dm-bufio: align write boundary on physical block size
      MAINTAINERS: add Benjamin Marzinski as a device mapper maintainer
      dm-snapshot: fix 'scheduling while atomic' on real-time kernels

Pedro Demarchi Gomes (1):
      dm-crypt: use folio_nr_pages() instead of shift operation

Shubhankar Mishra (1):
      dm verity fec: Expose corrected block count via status

Uladzislau Rezki (Sony) (1):
      dm-ebs: Mark full buffer dirty even on partial write

Vivek BalachandharTN (1):
      dm: sysfs: use sysfs_emit() in dm-sysfs.c

 .../admin-guide/device-mapper/dm-raid.rst          |  80 +++++++-
 Documentation/admin-guide/device-mapper/verity.rst |   6 +-
 MAINTAINERS                                        |   1 +
 drivers/md/Kconfig                                 |   2 +
 drivers/md/dm-bufio.c                              |  10 +-
 drivers/md/dm-core.h                               |   1 -
 drivers/md/dm-crypt.c                              | 117 +++++-------
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-exception-store.h                    |   2 +-
 drivers/md/dm-log-writes.c                         |   1 +
 drivers/md/dm-mpath.c                              |  63 +++----
 drivers/md/dm-pcache/cache.c                       |  13 +-
 drivers/md/dm-pcache/cache_segment.c               |  13 +-
 drivers/md/dm-raid.c                               |   2 +
 drivers/md/dm-snap.c                               |  73 ++++---
 drivers/md/dm-sysfs.c                              |   8 +-
 drivers/md/dm-table.c                              |   4 +
 drivers/md/dm-thin.c                               |  19 +-
 drivers/md/dm-vdo/action-manager.c                 |   2 +-
 drivers/md/dm-vdo/admin-state.c                    |  75 +++++---
 drivers/md/dm-vdo/block-map.c                      |  51 ++++-
 drivers/md/dm-vdo/completion.c                     |   5 +
 drivers/md/dm-vdo/data-vio.c                       |  34 +++-
 drivers/md/dm-vdo/dedupe.c                         |  42 ++---
 drivers/md/dm-vdo/dm-vdo-target.c                  |   5 +-
 drivers/md/dm-vdo/encodings.c                      |  26 ++-
 drivers/md/dm-vdo/flush.c                          |   6 +-
 drivers/md/dm-vdo/funnel-workqueue.c               |   7 +
 drivers/md/dm-vdo/io-submitter.c                   |  26 +--
 drivers/md/dm-vdo/logical-zone.c                   |  20 +-
 drivers/md/dm-vdo/packer.c                         |  15 +-
 drivers/md/dm-vdo/physical-zone.c                  |   5 +-
 drivers/md/dm-vdo/recovery-journal.c               |  30 +--
 drivers/md/dm-vdo/slab-depot.c                     |  96 ++++++----
 drivers/md/dm-vdo/vdo.c                            |   9 +-
 drivers/md/dm-vdo/vdo.h                            |   4 +-
 drivers/md/dm-vdo/vio.c                            |   3 +-
 drivers/md/dm-vdo/vio.h                            |   6 +-
 drivers/md/dm-verity-fec.c                         |  41 ++--
 drivers/md/dm-verity-fec.h                         |  10 +-
 drivers/md/dm-verity-target.c                      | 209 +++++++++++++++------
 drivers/md/dm-verity.h                             |  52 +++--
 drivers/md/dm-zone.c                               |   3 -
 drivers/md/dm.c                                    |  46 +++--
 44 files changed, 761 insertions(+), 484 deletions(-)


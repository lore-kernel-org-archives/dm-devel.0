Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5263275AFD
	for <dm-devel@lists.linux.dev>; Mon, 17 Aug 2026 20:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999321; cv=none; b=W4M3FysnwwsF2tOdphdTVpWNhoxLRBA7zqP+MaqkU7cTjgHTyS+WrLCLpwlx3mXzZWYJEe8gANg9mvJu825xBForQn6MnJNPrcB7kLYEDQekA+D78Ll3zStYi6BqIqiJfrjFgRKG9gZwA9KHfNgXUdCvZuH6hRSofNd7SqIupGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999321; c=relaxed/simple;
	bh=3N4D48g9+SNZbJMTEnTsldlpz6/F9gCiRzZ+aC7HeSE=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=nUI2bdu3RbzUiFwu6q/XrtpuJ1VvMJdIshLCP2Njq1iJJv9LuiSGFuAhSvYuEVWp0nmJZ7eW8pkwlL9lrrfvHZ3pDRwZaeVTO6dm94SY4UhgiwH1qmIXgzxI8IaBAPcmkst+daH/KiMVAxhjcmFI2Ft3Lpm3GJGYBtO+iUhchBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vaymx+Gy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vaymx+Gy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786999318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=m7wRiupfIp79ADfSVHUEryaevsZmHp8RUZ+chTpW/6g=;
	b=Vaymx+Gygdh8T/Y9ImRNgc0r65vFrTdxxcYyyG1HKSgplsO5B3vB3+1f9kh4V1tvLcs9m7
	2NSAnVdgtylQa5kd/y/Hu+AIpLGfB/feCzoRaRYnW0volRpPy9mwXI5Y4b2cYT8hlcjK28
	zVIpiRrFfJhvLFx6tz27mAM9SIZ2mxw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-WTuGLQZoMLiPIJ5ZEu8GNg-1; Mon,
 17 Aug 2026 16:41:55 -0400
X-MC-Unique: WTuGLQZoMLiPIJ5ZEu8GNg-1
X-Mimecast-MFC-AGG-ID: WTuGLQZoMLiPIJ5ZEu8GNg_1786999313
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E94219560AD;
	Mon, 17 Aug 2026 20:41:52 +0000 (UTC)
Received: from [10.44.48.124] (unknown [10.44.48.124])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70987180049F;
	Mon, 17 Aug 2026 20:41:45 +0000 (UTC)
Date: Mon, 17 Aug 2026 22:41:41 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
    Bryam Vargas <hexlabsecurity@proton.me>, 
    bui duc phuc <phucduc.bui@gmail.com>, corwin <corwincoburn@google.com>, 
    David Laight <david.laight.linux@gmail.com>, 
    Haotian Zhang <vulab@iscas.ac.cn>, Ilya Krutskih <devsec@tpz.ru>, 
    "Jiangong.Han" <jiangong.han@windriver.com>, 
    Jianyun Gao <jianyungao89@gmail.com>, Keith Busch <kbusch@kernel.org>, 
    liyouhong <liyouhong@kylinos.cn>, Matthew Sakai <msakai@redhat.com>, 
    Samuel Moelius <sam.moelius@trailofbits.com>, 
    "shaikh.kamal" <shaikhkamal2012@gmail.com>, 
    Shukai Ni <shukai.ni@kuleuven.be>
Subject: [git pull] device mapper changes for 7.3
Message-ID: <80e03616-ac55-cfcc-4fc7-f47bad3e0ac7@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dGCA-4XsWau3BvAw9S0CHzDcxv1WEQG4U8mO2lGSpzU_1786999313
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit a13c140cc289c0b7b3770bce5b3ad42ab35074aa:

  Linux 7.2-rc3 (2026-07-12 14:16:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.3/dm-changes

for you to fetch changes up to 39c5aa3bd8ec3912d2cd0b3fe092642b0d2b0713:

  dm-era: fix shadowed superblock leak on take-snap failure (2026-08-06 13:55:01 +0200)

Please, pull. Thanks.

Mikulas

----------------------------------------------------------------
- 6 minor cleanups found by Claude Opus 4.6

- small cleanups in dm core, dm-cache, dm-switch, dm-inlinecrypt, dm-vdo

- improve validation of metadata in dm-pcache

- dm: fix resume-vs-remove ioctl race condition

- dm: fix race condition when issuing table load ioctls concurrently

- fix dm-raid1 and dm-io, so that they work with unaligned bio vectors

- dm-integrity: use keyed markers as discard fillers

- improve metadata validation in dm-array

- fix dm-stats crash on memory allocation failure

- fix dm-dust, so that it works if it is not the first target in a table

- dm-era: fix superblock refcount leak on snapshot failure
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCaoNttBQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbThWAQCYDN/SclnydRYV7IKzV/yyd75esUOi
lWC3kMbiykSD0AEAmdQeMEqwxpX8i1njnPrcm67i4+LEKMK4X+ApLwV30gQ=
=SOAs
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Bryam Vargas (13):
      dm-pcache: validate seg_id fields from persistent memory
      dm-pcache: validate geometry fields from on-disk cache_info
      dm-pcache: validate kset key_num and intra-segment bounds
      dm-pcache: bound the persisted tail-position offset
      dm-pcache: reject a kset that overruns its segment
      dm-pcache: detect a cycle in the last-kset chain during replay
      dm-pcache: bound the logical key offset from persistent memory
      dm-pcache: clamp the tail kset read to the segment data region
      dm-pcache: validate on-media seg_num against the cache device size
      dm-pcache: validate the persisted dirty_tail chain at load
      dm-pcache: only hand out initialized cache segments
      dm array: validate array block headers on read
      dm array: reject an array block whose value size is not the caller's

David Laight (3):
      dm: __list_versions(): Only process targets once
      dm: list_devices(): Only process devices once
      dm: lookup_ioctl(): Use designated array initialers

Haotian Zhang (1):
      dm-switch: use WRITE_ONCE() in switch_region_table_write()

Ilya Krutskih (1):
      dm raid1: reserve space for NUL-terminator in build_constructor_string()

Jiangong.Han (1):
      dm: use `clear_and_wake_up_bit()` in device mapper

Jianyun Gao (6):
      dm-pcache: fix implicit u8 truncation of gc_percent in message handler
      dm-pcache: fix use-after-free and invalid seg operations in kset_replay()
      dm-pcache: replace tabs with spaces in comments to fix ASCII diagram alignment
      dm-pcache: remove unused 'allocated' variable in cache_data_alloc()
      dm-pcache: remove unused miss_read_end_work_fn declaration
      dm-pcache: remove unused 'cache' parameter from cache_key_gc()

Keith Busch (1):
      dm-io: clone the source bio instead of copying its biovec

Matthew Sakai (1):
      dm vdo: don't read repair field in loop condition

Mikulas Patocka (11):
      dm-integrity: fix error message
      dm-integrity: clean-up error handling
      dm-integrity: fix wrong fallthrough in integrity_bio_wait
      dm-ioctl: delete a useless condition
      dm-table: fix spelling
      dm-verity: remove pointless nested "bio" declaration
      dm-inlinecrypt: don't overwrite the error with -EINVAL
      dm: fix resume-vs-remove race
      dm: fix race when loading and unloading a table
      dm-io: report non-retryable errors separatedly
      dm-stats: fix a crash if allocation of per-cpu data fails

Samuel Moelius (2):
      dm cache: parse invalidate_cblocks with kstrtouint()
      dm dust: make badblock messages target-relative

Shukai Ni (1):
      dm-integrity: replace forgeable discard filler with a keyed sector marker

bui duc phuc (1):
      dm: drop redundant nonseekable_open() return check

corwin (2):
      dm vdo indexer: simplify sub-index parameter calculations
      dm vdo indexer: embed geometry in parent structures

liyouhong (1):
      dm-era: fix shadowed superblock leak on take-snap failure

shaikh.kamal (1):
      docs: device-mapper: dm-inlinecrypt: fix 'bellow' spelling

 Documentation/admin-guide/device-mapper/dm-ima.rst |   7 +-
 .../admin-guide/device-mapper/dm-inlinecrypt.rst   |   2 +-
 .../admin-guide/device-mapper/dm-integrity.rst     |  13 ++
 drivers/md/dm-bufio.c                              |  10 +-
 drivers/md/dm-cache-target.c                       |  56 +++---
 drivers/md/dm-dust.c                               |  16 +-
 drivers/md/dm-era-target.c                         |   5 +
 drivers/md/dm-inlinecrypt.c                        |   1 -
 drivers/md/dm-integrity.c                          | 175 +++++++++++++----
 drivers/md/dm-io.c                                 |  96 +++++----
 drivers/md/dm-ioctl.c                              | 216 +++++++++------------
 drivers/md/dm-kcopyd.c                             |  10 +-
 drivers/md/dm-log-userspace-base.c                 |   1 +
 drivers/md/dm-log.c                                |   4 +-
 drivers/md/dm-pcache/cache.c                       |  29 +++
 drivers/md/dm-pcache/cache.h                       |  43 +++-
 drivers/md/dm-pcache/cache_dev.c                   |  22 ++-
 drivers/md/dm-pcache/cache_gc.c                    |  36 +++-
 drivers/md/dm-pcache/cache_key.c                   | 128 ++++++++++--
 drivers/md/dm-pcache/cache_req.c                   |  19 +-
 drivers/md/dm-pcache/cache_segment.c               |  12 +-
 drivers/md/dm-pcache/cache_writeback.c             |  38 +++-
 drivers/md/dm-pcache/dm_pcache.c                   |   4 +-
 drivers/md/dm-raid1.c                              |  26 ++-
 drivers/md/dm-snap-persistent.c                    |   4 +-
 drivers/md/dm-snap.c                               |   4 +-
 drivers/md/dm-stats.c                              |   6 +-
 drivers/md/dm-switch.c                             |   2 +-
 drivers/md/dm-table.c                              |   2 +-
 drivers/md/dm-vdo/indexer/config.c                 |  34 ++--
 drivers/md/dm-vdo/indexer/config.h                 |   2 +-
 drivers/md/dm-vdo/indexer/geometry.c               |  92 ++++-----
 drivers/md/dm-vdo/indexer/geometry.h               |  13 +-
 drivers/md/dm-vdo/indexer/index-layout.c           |   2 +-
 drivers/md/dm-vdo/indexer/index.c                  |  30 +--
 drivers/md/dm-vdo/indexer/open-chapter.c           |   2 +-
 drivers/md/dm-vdo/indexer/open-chapter.h           |   2 +-
 drivers/md/dm-vdo/indexer/volume-index.c           | 190 +++++++++---------
 drivers/md/dm-vdo/indexer/volume.c                 |  74 ++++---
 drivers/md/dm-vdo/indexer/volume.h                 |   2 +-
 drivers/md/dm-vdo/repair.c                         |   6 +-
 drivers/md/dm-verity-target.c                      |   4 +-
 drivers/md/dm-writecache.c                         |  14 +-
 drivers/md/dm-zoned-metadata.c                     |   8 +-
 drivers/md/dm-zoned-reclaim.c                      |   4 +-
 drivers/md/dm.c                                    |  14 +-
 drivers/md/persistent-data/dm-array.c              |  53 ++++-
 include/linux/dm-io.h                              |   6 +-
 48 files changed, 928 insertions(+), 611 deletions(-)


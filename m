Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BCB1D61A3
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 22:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776204774; cv=none; b=m3te7Zi1MyQNm2IbdkCK8rMApvw2SMwJHudlaxcGBhI0Lrv1YzTcVrCRuFzTLYglW+3KzBscbuuBWSgDKFvy0uKYokzF1/57fBoAOweQKr2zj/n1bn2DFSBinNGdIVl+kXxddKLOoErTmde2nL4Vzul/YkUwTHr1ZEnfJ9z2inM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776204774; c=relaxed/simple;
	bh=Vlg9t92htYv5tjtSeHo6icx36NP0b1/S28RgAstf3gM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VObyhbhBGbwVWTEAQiqo+1C7ygkor3+MDrrMb2PGjGkFXzhzmrQtnUcftoLxXwRtQKZpHBC05r4GV8sdeNOAo2BTh/S0UeMoPjzjcVbScIm4z0PBIsik9CSpTIcRQZUIap3urNqZOzUVLGOAXrjpzouBuhKzCF2uItI9G2MBgPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RMHTXNqV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RMHTXNqV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776204771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=T2h3mTrGhUN37rqfw16kBjjUI6tkwkHXpd0cu7NoOGg=;
	b=RMHTXNqVOcUfnttOXumCWPIwCS4NwToRRGp6JBoCGph1C43WSbJ9mzJi+WdoOP0q0LsRKi
	EY2548zfPUZKhq02v1YsfTI9xub2Bs7Rsk90ByFdU8RKHajiwjThzlTqB6xZZ/qvIulU1y
	YHf1ZZXajKjA4jwYxR4zX3ltholPM1I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-zqP8vfI1NZKl04yaKCMxDQ-1; Tue,
 14 Apr 2026 18:12:46 -0400
X-MC-Unique: zqP8vfI1NZKl04yaKCMxDQ-1
X-Mimecast-MFC-AGG-ID: zqP8vfI1NZKl04yaKCMxDQ_1776204765
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 031101800365;
	Tue, 14 Apr 2026 22:12:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2C7B30001BE;
	Tue, 14 Apr 2026 22:12:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63EMCgIU1956137
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 18:12:42 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63EMCgdw1956136;
	Tue, 14 Apr 2026 18:12:42 -0400
Date: Tue, 14 Apr 2026 18:12:42 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev,
        Bruce Johnston <bjohnsto@redhat.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Guillaume Gonnet <ggonnet.linux@gmail.com>,
        Junrui Luo <moonafterrain@outlook.com>,
        Keith Busch <kbusch@kernel.org>, Ken Raeburn <raeburn@redhat.com>,
        Matthew Sakai <msakai@redhat.com>, Ming-Hung Tsai <mtsai@redhat.com>,
        Rosen Penev <rosenp@gmail.com>
Subject: [git pull] device mapper changes for 7.1
Message-ID: <ad672n9Rn9CFIYyA@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CtUvXKdDXsHwaCt6Q8jdPkOrryAF_jIHTn3X0JlzIOs_1776204765
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull the device mapper updates for 7.1. There are fixes for some
corner case crashes in dm-cache and dm-mirror, new setup functionality for
dm-vdo, and miscellaneous minor fixes and cleanups, especially to dm-verity.

The following changes since commit 11439c4635edd669ae435eec308f4ab8a0804808:

  Linux 7.0-rc2 (2026-03-01 15:39:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.1/dm-changes

for you to fetch changes up to 8c0ee19db81f0fa1ff25fd75b22b17c0cc2acde3:

  dm cache: fix missing return in invalidate_committed's error path (2026-04-10 15:16:06 +0200)

----------------------------------------------------------------
Device Mapper patches for 7.1

dm-vdo:
- Make dm-vdo able to format the device itself, like other dm targets,
  instead of needing a userspace formating program.
- Add some sanity checks and code cleanup.

dm-cache:
- Fix crashes and hangs when operating in passthrough mode (which have
  been around, unnoticed, since 4.12), as well as a late arriving fix for
  an error path bug in the passthrough fix.
- Fix a corner case memory leak.

dm-verity:
- Another set of minor bugfixes and code cleanups to the forward error
  correction code.

dm-mirror
- Fix minor initialization bug
- Fix overflow crash on a large devices with small region sizes

dm-crypt
- Reimplement elephant diffuser using AES library and minor cleanups

dm-core:
- Claude found a buffer overflow in /dev/mapper/contrl ioctl handling
- make dm_mod.wait_for correctly wait for partitions
- minor code fixes and cleanups

----------------------------------------------------------------
Benjamin Marzinski (1):
      dm-mpath: don't stop probing paths at presuspend

Bruce Johnston (9):
      dm vdo: add geometry block initialization to encodings.c
      dm vdo: add super block initialization to encodings.c
      dm vdo: add formatting parameters to table line
      dm vdo: add upfront validation for logical size
      dm vdo: add geometry block encoding
      dm vdo: add geometry block structure
      dm vdo: add synchronous metadata I/O submission helper
      dm vdo: add formatting logic and initialization
      dm vdo: save the formatted metadata to disk

Colin Ian King (1):
      dm vdo: Fix spelling mistake "postive" -> "positive"

Eric Biggers (27):
      dm-ima: use SHA-256 library
      dm-verity-fec: correctly reject too-small FEC devices
      dm-verity-fec: correctly reject too-small hash devices
      dm-verity-fec: fix corrected block count stat
      dm-verity-fec: fix the size of dm_verity_fec_io::erasures
      dm-verity-fec: fix reading parity bytes split across blocks (take 3)
      dm-verity: rename dm_verity::hash_blocks to dm_verity::hash_end
      dm-verity-fec: improve documentation for Forward Error Correction
      dm-verity-fec: replace {MAX,MIN}_RSN with {MIN,MAX}_ROOTS
      dm-verity-fec: use standard names for Reed-Solomon parameters
      dm-verity-fec: rename "RS block" to "RS codeword"
      dm-verity-fec: replace io_size with block_size
      dm-verity-fec: rename rounds to region_blocks
      dm-verity-fec: simplify computation of rsb
      dm-verity-fec: simplify computation of ileaved
      dm-verity-fec: simplify deinterleaving
      dm-verity-fec: rename block_offset to out_pos
      dm-verity-fec: move computation of offset and rsb down a level
      dm-verity-fec: compute target region directly
      dm-verity-fec: pass down index_in_region instead of rsb
      dm-verity-fec: make fec_decode_bufs() just return 0 or error
      dm-verity-fec: log target_block instead of index_in_region
      dm-verity-fec: improve comments for fec_read_bufs()
      dm-verity-fec: warn even when there were no errors
      dm-crypt: Reimplement elephant diffuser using AES library
      dm-crypt: Make crypt_iv_operations::wipe return void
      dm-crypt: Make crypt_iv_operations::post return void

Guillaume Gonnet (1):
      dm init: ensure device probing has finished in dm-mod.waitfor=

Junrui Luo (2):
      dm mirror: fix integer overflow in create_dirty_log()
      dm log: fix out-of-bounds write due to region_count overflow

Keith Busch (3):
      dm-integrity: fix mismatched queue limits
      dm-integrity: always set the io hints
      dm: provide helper to set stacked limits

Ken Raeburn (3):
      dm vdo: update vdo_allocate_extended to take a field name, no types
      dm vdo: remove redundant TYPE argument from vdo_allocate macro
      dm vdo: add __counted_by attribute to a number of structures

Matthew Sakai (2):
      dm vdo indexer: validate saved zone count
      dm vdo slab-depot: validate old zone count on load

Mikulas Patocka (3):
      dm: don't report warning when doing deferred remove
      dm: make "dmsetup remove_all" interruptible
      dm: fix a buffer overflow in ioctl processing

Ming-Hung Tsai (9):
      dm cache: fix null-deref with concurrent writes in passthrough mode
      dm cache: fix write path cache coherency in passthrough mode
      dm cache: fix write hang in passthrough mode
      dm cache policy smq: fix missing locks in invalidating cache blocks
      dm cache: fix concurrent write failure in passthrough mode
      dm cache: fix dirty mapping checking in passthrough mode switching
      dm cache: prevent entering passthrough mode after unclean shutdown
      dm cache metadata: fix memory leak on metadata abort retry
      dm cache: fix missing return in invalidate_committed's error path

Rosen Penev (1):
      dm-bufio: use kzalloc_flex

 Documentation/admin-guide/device-mapper/verity.rst | 122 +++++--
 drivers/md/Kconfig                                 |   2 +
 drivers/md/dm-bufio.c                              |   4 +-
 drivers/md/dm-cache-metadata.c                     |  33 +-
 drivers/md/dm-cache-metadata.h                     |  10 +-
 drivers/md/dm-cache-policy-smq.c                   |   4 +
 drivers/md/dm-cache-target.c                       |  92 +++--
 drivers/md/dm-crypt.c                              | 140 +++-----
 drivers/md/dm-ima.c                                |  54 +--
 drivers/md/dm-ima.h                                |   1 -
 drivers/md/dm-init.c                               |   4 +-
 drivers/md/dm-integrity.c                          |  10 +-
 drivers/md/dm-ioctl.c                              |  39 ++-
 drivers/md/dm-log.c                                |   6 +-
 drivers/md/dm-mpath.c                              |   9 +-
 drivers/md/dm-raid1.c                              |   6 +-
 drivers/md/dm-vdo/action-manager.c                 |   2 +-
 drivers/md/dm-vdo/block-map.c                      |  32 +-
 drivers/md/dm-vdo/block-map.h                      |   2 +-
 drivers/md/dm-vdo/constants.h                      |  13 +-
 drivers/md/dm-vdo/data-vio.c                       |   3 +-
 drivers/md/dm-vdo/dedupe.c                         |   8 +-
 drivers/md/dm-vdo/dm-vdo-target.c                  | 151 +++++++-
 drivers/md/dm-vdo/encodings.c                      | 221 +++++++++++-
 drivers/md/dm-vdo/encodings.h                      |  17 +
 drivers/md/dm-vdo/flush.c                          |   4 +-
 drivers/md/dm-vdo/funnel-queue.c                   |   2 +-
 drivers/md/dm-vdo/funnel-workqueue.c               |   8 +-
 drivers/md/dm-vdo/indexer/chapter-index.c          |   2 +-
 drivers/md/dm-vdo/indexer/config.c                 |   2 +-
 drivers/md/dm-vdo/indexer/delta-index.c            |  13 +-
 drivers/md/dm-vdo/indexer/funnel-requestqueue.c    |   2 +-
 drivers/md/dm-vdo/indexer/geometry.c               |   2 +-
 drivers/md/dm-vdo/indexer/index-layout.c           |  54 ++-
 drivers/md/dm-vdo/indexer/index-page-map.c         |   8 +-
 drivers/md/dm-vdo/indexer/index-session.c          |   2 +-
 drivers/md/dm-vdo/indexer/index.c                  |  14 +-
 drivers/md/dm-vdo/indexer/index.h                  |   2 +-
 drivers/md/dm-vdo/indexer/indexer.h                |   4 +
 drivers/md/dm-vdo/indexer/io-factory.c             |   6 +-
 drivers/md/dm-vdo/indexer/open-chapter.c           |   4 +-
 drivers/md/dm-vdo/indexer/open-chapter.h           |   2 +-
 drivers/md/dm-vdo/indexer/radix-sort.c             |   3 +-
 drivers/md/dm-vdo/indexer/sparse-cache.c           |  10 +-
 drivers/md/dm-vdo/indexer/volume-index.c           |  10 +-
 drivers/md/dm-vdo/indexer/volume.c                 |  22 +-
 drivers/md/dm-vdo/int-map.c                        |   5 +-
 drivers/md/dm-vdo/io-submitter.c                   |  30 +-
 drivers/md/dm-vdo/io-submitter.h                   |   4 +
 drivers/md/dm-vdo/logical-zone.c                   |   3 +-
 drivers/md/dm-vdo/logical-zone.h                   |   2 +-
 drivers/md/dm-vdo/memory-alloc.c                   |   8 +-
 drivers/md/dm-vdo/memory-alloc.h                   |  74 +---
 drivers/md/dm-vdo/message-stats.c                  |   2 +-
 drivers/md/dm-vdo/packer.c                         |   9 +-
 drivers/md/dm-vdo/physical-zone.c                  |   8 +-
 drivers/md/dm-vdo/priority-table.c                 |   3 +-
 drivers/md/dm-vdo/recovery-journal.c               |  23 +-
 drivers/md/dm-vdo/repair.c                         |  17 +-
 drivers/md/dm-vdo/slab-depot.c                     |  41 +--
 drivers/md/dm-vdo/slab-depot.h                     |   2 +-
 drivers/md/dm-vdo/status-codes.c                   |   2 +
 drivers/md/dm-vdo/thread-utils.c                   |   2 +-
 drivers/md/dm-vdo/types.h                          |   3 +
 drivers/md/dm-vdo/vdo.c                            | 333 ++++++++++++------
 drivers/md/dm-vdo/vdo.h                            |  19 ++
 drivers/md/dm-vdo/vio.c                            |  12 +-
 drivers/md/dm-verity-fec.c                         | 380 ++++++++++-----------
 drivers/md/dm-verity-fec.h                         |  28 +-
 drivers/md/dm-verity-target.c                      |  16 +-
 drivers/md/dm-verity.h                             |   4 +-
 drivers/md/dm-writecache.c                         |  10 +-
 include/linux/device-mapper.h                      |   7 +
 73 files changed, 1348 insertions(+), 860 deletions(-)


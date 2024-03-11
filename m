Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583C544369
	for <dm-devel@lists.linux.dev>; Mon, 11 Mar 2024 18:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710182633; cv=none; b=NqTRNuAUrvjgF7jTHwgpNTWNJ9Gpj+u/LG9qo8nLFjsC8gR20zs/M6hOrgS9F2QRcStqCJC5Od79ANjKJ5jqKqb4SLaCTCZaViay52k9u2yeDNRg2l/zNYe6IFh+W5aonug52TGdb1iJ81IW/RvU9o5NZoVP0sJxItBXaU7r6BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710182633; c=relaxed/simple;
	bh=GgYyPnDfUnKKfoP2NdfXslbVnAxrEFTGxQEXcqCBc+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=deSXdPpZfqGSU+2hgZmI+oFuuwyjVlsYKQzdXjIsZtgW5gGPxICttr38LKM3byU4xOQ9scqODN9JRWD7UPYl5BwHITZftM+ncalIWIVvMtdIqY5rg8P0BRrt7CrK1KxFKPMl7KuOqzlLbFd792cPaWIoxPLZNbcerlFo/+UWNzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-690db6edb2bso4424816d6.2
        for <dm-devel@lists.linux.dev>; Mon, 11 Mar 2024 11:43:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710182630; x=1710787430;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdiq3VBxHl40Ly0Z3vDZbLMSSDtu6pGuSN+Ji2LMVak=;
        b=RXzbkgAI3XQuvCNwlcPTUfNcel8Kh4YTWCPVUusF1K4ac8RSzR51TZSX6dmuKwX3ZE
         4DBnusmwwWaB6P5i5qkgssz9ZQmr1Zeoc7j4ShOhfFZ1YRMKUX29yntpFBlPxpjfHBaD
         sRH5BjZQCaRPpTxfVSTEWyc/ce5oanq5sFljLZR0CVObbd9O7wkS+pMsKXyG8PkRrwrD
         rfCrUi3PWtCfrTIERbzdfhEn9ImDfnKTxxWTHqJux1dksJb5WvjhtImrb9GnfOM2sHQ2
         KxrQRX/k1RyHFLFwDT7uLkmiXGpJOu0o7xlubRwJgVqiqvQTlKrqc43/OA97eatoE5Sz
         u7rQ==
X-Gm-Message-State: AOJu0YyKxM3Jj8TsUyamOdKRNN3tshGow/hzPlwH2XNHRQO0TebNnIYU
	YEAgD0xv72UGsJd1aPXhDg9LSeics1lImff9nf2VJudarRrwUBCpleS27wDlug==
X-Google-Smtp-Source: AGHT+IH4+bz11pyDrHUf33jwVvatkFPZ6X0w+aCdSnoeF4wMvlLETrriFgdruSWksJETqYr71owl3g==
X-Received: by 2002:a0c:9cc6:0:b0:690:8e5b:19c9 with SMTP id j6-20020a0c9cc6000000b006908e5b19c9mr8592384qvf.13.1710182630199;
        Mon, 11 Mar 2024 11:43:50 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id w20-20020a0562140b3400b00690d5ac7a9esm1007504qvj.50.2024.03.11.11.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 11:43:49 -0700 (PDT)
Date: Mon, 11 Mar 2024 14:43:48 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Bruce Johnston <bjohnsto@redhat.com>,
	Chung Chung <cchung@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Ken Raeburn <raeburn@redhat.com>, Matthew Sakai <msakai@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Susan LeGendre-McGhee <slegendr@redhat.com>,
	Yang Li <yang.lee@linux.alibaba.com>
Subject: [git pull] device mapper changes to add VDO target for 6.9
Message-ID: <Ze9Q5P10RERiflfL@redhat.com>
References: <Ze9OCmWb-9LX5t8W@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ze9OCmWb-9LX5t8W@redhat.com>

Hi Linus,

The following changes since commit 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478:

  Linux 6.8-rc3 (2024-02-04 12:20:36 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.9/dm-vdo

for you to fetch changes up to cb824724dccb3195d22cad96e7b65fe13621d0a6:

  dm vdo: document minimum metadata size requirements (2024-03-07 19:56:24 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Introduce the DM vdo target which provides block-level
  deduplication, compression, and thin provisioning. Please see both:
  Documentation/admin-guide/device-mapper/vdo.rst and
  Documentation/admin-guide/device-mapper/vdo-design.rst

- The DM vdo target handles its concurrency by pinning an IO, and
  subsequent stages of handling that IO, to a particular VDO thread.
  This aspect of VDO is "unique" but its overall implementation is
  very tightly coupled to its mostly lockless threading model.
  As such, VDO is not easily changed to use more traditional
  finer-grained locking and Linux workqueues. Please see the "Zones
  and Threading" section of vdo-design.rst

- The DM vdo target has been used in production for many years but has
  seen significant changes over the past ~6 years to prepare it for
  upstream inclusion. The codebase is still large but it is isolated
  to drivers/md/dm-vdo/ and has been made considerably more
  approachable and maintainable.

- Matt Sakai has been added to the MAINTAINERS file to reflect that he
  will send VDO changes upstream through the DM subsystem maintainers.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmXqYlEACgkQxSPxCi2d
A1oOAggAlPdoDfU2DWoFxJcCGR4sYrk6n8GOGXZIi5bZeJFaPUoH9EQZUVgsMiEo
TSpJugk6KddsXNsKHCuc3ctejNT4FAs3f5pcqWQ+VTR6xXD7xw67hN78arhu4VZH
OWzAyKu8fs4NUxjMThLdwMlt2+vOfcuOHAXxcil3kvG6SPcPw1FDde3Jbb5OmgcF
z1D9kkUuqH+d46P/dwOsNcr7cMIUviZW+plFnVMKsdJGH/SCyu6TCLYWrwBR1VXW
pNylxk4AcsffQdu2Oor6+0ALaH7Wq3kjymNLQlYWt0EibGbBakrVs1A/DIXUZDiX
gYfcemQpl74x1vifNtIsUWW9vO1XPg==
=2Oof
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Bruce Johnston (4):
      dm vdo dedupe: switch to using int-map instead of pointer-map
      dm vdo int-map: rename functions to use a common vdo_int_map preamble
      dm vdo int-map: remove unused parameter from vdo_int_map_create
      dm-vdo: change unnamed enums to defines

Chung Chung (1):
      dm vdo: clean up scnprintf usage

Dan Carpenter (1):
      dm vdo slab-depot: delete unnecessary check in allocate_components

Harshit Mogalapalli (1):
      dm vdo volume-index: fix an assert statement in start_restoring_volume_sub_index()

Jiapeng Chong (1):
      dm vdo: fix various function names referenced in comment blocks

Ken Raeburn (2):
      dm vdo message-stats: reformat to remove excessive newlines
      dm vdo: document log_level parameter

Matthew Sakai (53):
      dm: add documentation for dm-vdo target
      dm vdo: add the MurmurHash3 fast hashing algorithm
      dm vdo: add memory allocation utilities
      dm vdo: add basic logging and support utilities
      dm vdo: add vdo type declarations, constants, and simple data structures
      dm vdo: add thread and synchronization utilities
      dm vdo: add specialized request queueing functionality
      dm vdo: add basic hash map data structures
      dm vdo: add deduplication configuration structures
      dm vdo: add deduplication index storage interface
      dm vdo: implement the delta index
      dm vdo: implement the volume index
      dm vdo: implement the open chapter and chapter indexes
      dm vdo: implement the chapter volume store
      dm vdo: implement top-level deduplication index
      dm vdo: implement external deduplication index interface
      dm vdo: add administrative state and action manager
      dm vdo: add vio, the request object for vdo metadata
      dm vdo: add data_vio, the request object which services incoming bios
      dm vdo: add flush support
      dm vdo: add the vdo io_submitter
      dm vdo: add hash locks and hash zones
      dm vdo: add use of deduplication index in hash zones
      dm vdo: add the compressed block bin packer
      dm vdo: add slab structure, slab journal and reference counters
      dm vdo: add the slab summary
      dm vdo: add the block allocators and physical zones
      dm vdo: add the slab depot
      dm vdo: add the block map
      dm vdo: implement the block map page cache
      dm vdo: add the recovery journal
      dm vdo: add repair of damaged vdo volumes
      dm vdo: add the primary vdo structure
      dm vdo: add the on-disk formats and marshalling of vdo structures
      dm vdo: add statistics reporting
      dm vdo: add sysfs support for setting parameters and fetching stats
      dm vdo: add debugging support
      dm vdo: add the top-level DM target
      dm vdo: enable configuration and building of dm-vdo
      dm vdo: add MAINTAINERS file entry
      dm vdo: add vdo documentation to device-mapper index
      dm vdo: add vio life cycle details to design doc
      dm vdo: add documentation details on zones and locking
      dm vdo: remove unnecessary indexer.h includes
      dm vdo indexer delta-index: fix typos in comments
      dm vdo: update module comments
      dm vdo: remove outdated pointer_map reference
      dm vdo errors: remove unused error codes
      dm vdo indexer: update ASSERT and ASSERT_LOG_ONLY usage
      dm vdo indexer: fix use after free
      dm vdo: remove vdo_perform_once
      dm vdo: remove meaningless version number constant
      dm vdo: document minimum metadata size requirements

Mike Snitzer (76):
      dm vdo io-submitter: remove get_bio_sector
      dm vdo io-submitter: rename to vdo_submit_metadata_vio
      dm vdo io-submitter: rename to vdo_submit_flush_vio
      dm vdo io-submitter: rename to vdo_submit_data_vio
      dm vdo io-submitter: rename to vdo_submit_vio and submit_data_vio
      dm vdo wait-queue: add proper namespace to interface
      dm vdo wait-queue: remove unused debug function vdo_waitq_get_next_waiter
      dm vdo wait-queue: optimize vdo_waitq_dequeue_matching_waiters
      dm vdo block-map: optimize enter_zone_read_only_mode
      dm vdo wait-queue: rename to vdo_waitq_dequeue_waiter
      dm vdo: fix how dm_kcopyd_client_create() failure is checked
      dm vdo: use a proper Makefile for dm-vdo
      dm vdo block-map: fix a few small nits
      dm vdo block-map: use uds_log_ratelimit() rather than open code it
      dm vdo block-map: remove extra vdo arg from initialize_block_map_zone
      dm vdo block-map: avoid extra dereferences to access vdo object
      dm vdo block-map: rename struct cursors member to 'completion'
      dm vdo: slight cleanup of UDS error codes
      dm vdo: rename uds_map_to_system_error to uds_status_to_errno
      dm vdo: rename vdo_map_to_system_error to vdo_status_to_errno
      dm vdo data-vio: rename is_trim flag to is_discard
      dm vdo slab-depot: fix various small nits
      dm vdo dedupe: fix various small nits
      dm vdo index: fix various small nits
      dm vdo: rename struct geometry to index_geometry
      dm vdo: rename struct configuration to uds_configuration
      dm vdo: fix sparse warnings about missing statics
      dm vdo: fix sparse 'warning: Using plain integer as NULL pointer'
      dm vdo: fix various blk_opf_t sparse warnings
      dm vdo data-vio: silence sparse warnings about locking context imbalances
      dm vdo dedupe: silence sparse warnings about locking context imbalances
      dm vdo recovery-journal: fix sparse 'mixed bitwiseness' warning
      dm vdo: use #define for NO_CHAPTER and NO_CHAPTER_INDEX_ENTRY
      dm vdo string-utils: remove unnecessary includes
      dm vdo dedupe: fix various small nits
      dm vdo: cleanup style for comments in structs
      dm vdo chapter_index: fix a few small nits
      dm vdo delta-index: fix various small nits
      dm vdo: tweak wait_for_completion_interruptible callers
      dm vdo logger: switch UDS_LOG_NOTICE to be alias for UDS_LOG_INFO
      dm vdo logger: update logging to start with "device-mapper: vdo"
      dm vdo block-map: rename page state name from "UDS_FREE" to "FREE"
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
      dm vdo memory-alloc: simplify allocations_allowed()
      dm vdo flush: initialize return to NULL in allocate_flush
      dm vdo indexer-volume: fix missing mutex_lock in process_entry
      dm vdo: include <asm/current.h> to resolve current being undeclared
      dm vdo: move indexer files into sub-directory
      dm vdo memory-alloc: change from uds_ to vdo_ namespace
      dm vdo memory-alloc: rename vdo_do_allocation to __vdo_do_allocation
      dm vdo memory-alloc: return VDO_SUCCESS on success
      dm vdo: check for VDO_SUCCESS return value from memory-alloc functions
      dm vdo int-map: return VDO_SUCCESS on success
      dm vdo thread-utils: return VDO_SUCCESS on vdo_create_thread success
      dm-vdo funnel-workqueue: return VDO_SUCCESS from make_simple_work_queue
      dm vdo permassert: audit all of ASSERT to test for VDO_SUCCESS
      dm vdo encodings: update some stale comments
      dm vdo target: eliminate inappropriate uses of UDS_SUCCESS
      dm vdo: remove all sysfs interfaces
      dm vdo: add 'log_level' module parameter
      dm vdo logger: remove log level to string conversion code
      dm vdo funnel-queue: change from uds_ to vdo_ namespace
      dm vdo logger: change from uds_ to vdo_ namespace
      dm vdo string-utils: change from uds_ to vdo_ namespace

Susan LeGendre-McGhee (2):
      dm vdo: move encoding constants to encodings.c
      dm vdo: remove internal ticket references

Yang Li (1):
      dm vdo block-map: Remove stray semicolon

 Documentation/admin-guide/device-mapper/index.rst  |    2 +
 .../admin-guide/device-mapper/vdo-design.rst       |  633 +++
 Documentation/admin-guide/device-mapper/vdo.rst    |  406 ++
 MAINTAINERS                                        |    8 +
 drivers/md/Kconfig                                 |    2 +
 drivers/md/Makefile                                |    1 +
 drivers/md/dm-vdo/Kconfig                          |   17 +
 drivers/md/dm-vdo/Makefile                         |   57 +
 drivers/md/dm-vdo/action-manager.c                 |  388 ++
 drivers/md/dm-vdo/action-manager.h                 |  110 +
 drivers/md/dm-vdo/admin-state.c                    |  506 ++
 drivers/md/dm-vdo/admin-state.h                    |  178 +
 drivers/md/dm-vdo/block-map.c                      | 3318 +++++++++++++
 drivers/md/dm-vdo/block-map.h                      |  394 ++
 drivers/md/dm-vdo/completion.c                     |  140 +
 drivers/md/dm-vdo/completion.h                     |  152 +
 drivers/md/dm-vdo/constants.h                      |   96 +
 drivers/md/dm-vdo/cpu.h                            |   59 +
 drivers/md/dm-vdo/data-vio.c                       | 2063 ++++++++
 drivers/md/dm-vdo/data-vio.h                       |  670 +++
 drivers/md/dm-vdo/dedupe.c                         | 3003 ++++++++++++
 drivers/md/dm-vdo/dedupe.h                         |  120 +
 drivers/md/dm-vdo/dm-vdo-target.c                  | 2910 +++++++++++
 drivers/md/dm-vdo/dump.c                           |  275 ++
 drivers/md/dm-vdo/dump.h                           |   17 +
 drivers/md/dm-vdo/encodings.c                      | 1483 ++++++
 drivers/md/dm-vdo/encodings.h                      | 1298 +++++
 drivers/md/dm-vdo/errors.c                         |  307 ++
 drivers/md/dm-vdo/errors.h                         |   73 +
 drivers/md/dm-vdo/flush.c                          |  560 +++
 drivers/md/dm-vdo/flush.h                          |   44 +
 drivers/md/dm-vdo/funnel-queue.c                   |  170 +
 drivers/md/dm-vdo/funnel-queue.h                   |  110 +
 drivers/md/dm-vdo/funnel-workqueue.c               |  638 +++
 drivers/md/dm-vdo/funnel-workqueue.h               |   51 +
 drivers/md/dm-vdo/indexer/chapter-index.c          |  293 ++
 drivers/md/dm-vdo/indexer/chapter-index.h          |   61 +
 drivers/md/dm-vdo/indexer/config.c                 |  376 ++
 drivers/md/dm-vdo/indexer/config.h                 |  124 +
 drivers/md/dm-vdo/indexer/delta-index.c            | 1970 ++++++++
 drivers/md/dm-vdo/indexer/delta-index.h            |  279 ++
 drivers/md/dm-vdo/indexer/funnel-requestqueue.c    |  279 ++
 drivers/md/dm-vdo/indexer/funnel-requestqueue.h    |   31 +
 drivers/md/dm-vdo/indexer/geometry.c               |  201 +
 drivers/md/dm-vdo/indexer/geometry.h               |  140 +
 drivers/md/dm-vdo/indexer/hash-utils.h             |   66 +
 drivers/md/dm-vdo/indexer/index-layout.c           | 1765 +++++++
 drivers/md/dm-vdo/indexer/index-layout.h           |   43 +
 drivers/md/dm-vdo/indexer/index-page-map.c         |  173 +
 drivers/md/dm-vdo/indexer/index-page-map.h         |   50 +
 drivers/md/dm-vdo/indexer/index-session.c          |  739 +++
 drivers/md/dm-vdo/indexer/index-session.h          |   85 +
 drivers/md/dm-vdo/indexer/index.c                  | 1388 ++++++
 drivers/md/dm-vdo/indexer/index.h                  |   83 +
 drivers/md/dm-vdo/indexer/indexer.h                |  353 ++
 drivers/md/dm-vdo/indexer/io-factory.c             |  415 ++
 drivers/md/dm-vdo/indexer/io-factory.h             |   64 +
 drivers/md/dm-vdo/indexer/open-chapter.c           |  426 ++
 drivers/md/dm-vdo/indexer/open-chapter.h           |   79 +
 drivers/md/dm-vdo/indexer/radix-sort.c             |  330 ++
 drivers/md/dm-vdo/indexer/radix-sort.h             |   26 +
 drivers/md/dm-vdo/indexer/sparse-cache.c           |  624 +++
 drivers/md/dm-vdo/indexer/sparse-cache.h           |   46 +
 drivers/md/dm-vdo/indexer/volume-index.c           | 1283 +++++
 drivers/md/dm-vdo/indexer/volume-index.h           |  193 +
 drivers/md/dm-vdo/indexer/volume.c                 | 1693 +++++++
 drivers/md/dm-vdo/indexer/volume.h                 |  172 +
 drivers/md/dm-vdo/int-map.c                        |  707 +++
 drivers/md/dm-vdo/int-map.h                        |   39 +
 drivers/md/dm-vdo/io-submitter.c                   |  477 ++
 drivers/md/dm-vdo/io-submitter.h                   |   47 +
 drivers/md/dm-vdo/logger.c                         |  239 +
 drivers/md/dm-vdo/logger.h                         |  100 +
 drivers/md/dm-vdo/logical-zone.c                   |  373 ++
 drivers/md/dm-vdo/logical-zone.h                   |   89 +
 drivers/md/dm-vdo/memory-alloc.c                   |  438 ++
 drivers/md/dm-vdo/memory-alloc.h                   |  162 +
 drivers/md/dm-vdo/message-stats.c                  |  432 ++
 drivers/md/dm-vdo/message-stats.h                  |   13 +
 drivers/md/dm-vdo/murmurhash3.c                    |  175 +
 drivers/md/dm-vdo/murmurhash3.h                    |   15 +
 drivers/md/dm-vdo/numeric.h                        |   78 +
 drivers/md/dm-vdo/packer.c                         |  780 +++
 drivers/md/dm-vdo/packer.h                         |  122 +
 drivers/md/dm-vdo/permassert.c                     |   26 +
 drivers/md/dm-vdo/permassert.h                     |   45 +
 drivers/md/dm-vdo/physical-zone.c                  |  644 +++
 drivers/md/dm-vdo/physical-zone.h                  |  115 +
 drivers/md/dm-vdo/priority-table.c                 |  224 +
 drivers/md/dm-vdo/priority-table.h                 |   47 +
 drivers/md/dm-vdo/recovery-journal.c               | 1762 +++++++
 drivers/md/dm-vdo/recovery-journal.h               |  316 ++
 drivers/md/dm-vdo/repair.c                         | 1756 +++++++
 drivers/md/dm-vdo/repair.h                         |   14 +
 drivers/md/dm-vdo/slab-depot.c                     | 5101 ++++++++++++++++++++
 drivers/md/dm-vdo/slab-depot.h                     |  601 +++
 drivers/md/dm-vdo/statistics.h                     |  278 ++
 drivers/md/dm-vdo/status-codes.c                   |   94 +
 drivers/md/dm-vdo/status-codes.h                   |   86 +
 drivers/md/dm-vdo/string-utils.c                   |   22 +
 drivers/md/dm-vdo/string-utils.h                   |   23 +
 drivers/md/dm-vdo/thread-device.c                  |   34 +
 drivers/md/dm-vdo/thread-device.h                  |   20 +
 drivers/md/dm-vdo/thread-registry.c                |   93 +
 drivers/md/dm-vdo/thread-registry.h                |   32 +
 drivers/md/dm-vdo/thread-utils.c                   |  108 +
 drivers/md/dm-vdo/thread-utils.h                   |   20 +
 drivers/md/dm-vdo/time-utils.h                     |   28 +
 drivers/md/dm-vdo/types.h                          |  393 ++
 drivers/md/dm-vdo/vdo.c                            | 1730 +++++++
 drivers/md/dm-vdo/vdo.h                            |  362 ++
 drivers/md/dm-vdo/vio.c                            |  500 ++
 drivers/md/dm-vdo/vio.h                            |  199 +
 drivers/md/dm-vdo/wait-queue.c                     |  205 +
 drivers/md/dm-vdo/wait-queue.h                     |  138 +
 115 files changed, 53411 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/vdo-design.rst
 create mode 100644 Documentation/admin-guide/device-mapper/vdo.rst
 create mode 100644 drivers/md/dm-vdo/Kconfig
 create mode 100644 drivers/md/dm-vdo/Makefile
 create mode 100644 drivers/md/dm-vdo/action-manager.c
 create mode 100644 drivers/md/dm-vdo/action-manager.h
 create mode 100644 drivers/md/dm-vdo/admin-state.c
 create mode 100644 drivers/md/dm-vdo/admin-state.h
 create mode 100644 drivers/md/dm-vdo/block-map.c
 create mode 100644 drivers/md/dm-vdo/block-map.h
 create mode 100644 drivers/md/dm-vdo/completion.c
 create mode 100644 drivers/md/dm-vdo/completion.h
 create mode 100644 drivers/md/dm-vdo/constants.h
 create mode 100644 drivers/md/dm-vdo/cpu.h
 create mode 100644 drivers/md/dm-vdo/data-vio.c
 create mode 100644 drivers/md/dm-vdo/data-vio.h
 create mode 100644 drivers/md/dm-vdo/dedupe.c
 create mode 100644 drivers/md/dm-vdo/dedupe.h
 create mode 100644 drivers/md/dm-vdo/dm-vdo-target.c
 create mode 100644 drivers/md/dm-vdo/dump.c
 create mode 100644 drivers/md/dm-vdo/dump.h
 create mode 100644 drivers/md/dm-vdo/encodings.c
 create mode 100644 drivers/md/dm-vdo/encodings.h
 create mode 100644 drivers/md/dm-vdo/errors.c
 create mode 100644 drivers/md/dm-vdo/errors.h
 create mode 100644 drivers/md/dm-vdo/flush.c
 create mode 100644 drivers/md/dm-vdo/flush.h
 create mode 100644 drivers/md/dm-vdo/funnel-queue.c
 create mode 100644 drivers/md/dm-vdo/funnel-queue.h
 create mode 100644 drivers/md/dm-vdo/funnel-workqueue.c
 create mode 100644 drivers/md/dm-vdo/funnel-workqueue.h
 create mode 100644 drivers/md/dm-vdo/indexer/chapter-index.c
 create mode 100644 drivers/md/dm-vdo/indexer/chapter-index.h
 create mode 100644 drivers/md/dm-vdo/indexer/config.c
 create mode 100644 drivers/md/dm-vdo/indexer/config.h
 create mode 100644 drivers/md/dm-vdo/indexer/delta-index.c
 create mode 100644 drivers/md/dm-vdo/indexer/delta-index.h
 create mode 100644 drivers/md/dm-vdo/indexer/funnel-requestqueue.c
 create mode 100644 drivers/md/dm-vdo/indexer/funnel-requestqueue.h
 create mode 100644 drivers/md/dm-vdo/indexer/geometry.c
 create mode 100644 drivers/md/dm-vdo/indexer/geometry.h
 create mode 100644 drivers/md/dm-vdo/indexer/hash-utils.h
 create mode 100644 drivers/md/dm-vdo/indexer/index-layout.c
 create mode 100644 drivers/md/dm-vdo/indexer/index-layout.h
 create mode 100644 drivers/md/dm-vdo/indexer/index-page-map.c
 create mode 100644 drivers/md/dm-vdo/indexer/index-page-map.h
 create mode 100644 drivers/md/dm-vdo/indexer/index-session.c
 create mode 100644 drivers/md/dm-vdo/indexer/index-session.h
 create mode 100644 drivers/md/dm-vdo/indexer/index.c
 create mode 100644 drivers/md/dm-vdo/indexer/index.h
 create mode 100644 drivers/md/dm-vdo/indexer/indexer.h
 create mode 100644 drivers/md/dm-vdo/indexer/io-factory.c
 create mode 100644 drivers/md/dm-vdo/indexer/io-factory.h
 create mode 100644 drivers/md/dm-vdo/indexer/open-chapter.c
 create mode 100644 drivers/md/dm-vdo/indexer/open-chapter.h
 create mode 100644 drivers/md/dm-vdo/indexer/radix-sort.c
 create mode 100644 drivers/md/dm-vdo/indexer/radix-sort.h
 create mode 100644 drivers/md/dm-vdo/indexer/sparse-cache.c
 create mode 100644 drivers/md/dm-vdo/indexer/sparse-cache.h
 create mode 100644 drivers/md/dm-vdo/indexer/volume-index.c
 create mode 100644 drivers/md/dm-vdo/indexer/volume-index.h
 create mode 100644 drivers/md/dm-vdo/indexer/volume.c
 create mode 100644 drivers/md/dm-vdo/indexer/volume.h
 create mode 100644 drivers/md/dm-vdo/int-map.c
 create mode 100644 drivers/md/dm-vdo/int-map.h
 create mode 100644 drivers/md/dm-vdo/io-submitter.c
 create mode 100644 drivers/md/dm-vdo/io-submitter.h
 create mode 100644 drivers/md/dm-vdo/logger.c
 create mode 100644 drivers/md/dm-vdo/logger.h
 create mode 100644 drivers/md/dm-vdo/logical-zone.c
 create mode 100644 drivers/md/dm-vdo/logical-zone.h
 create mode 100644 drivers/md/dm-vdo/memory-alloc.c
 create mode 100644 drivers/md/dm-vdo/memory-alloc.h
 create mode 100644 drivers/md/dm-vdo/message-stats.c
 create mode 100644 drivers/md/dm-vdo/message-stats.h
 create mode 100644 drivers/md/dm-vdo/murmurhash3.c
 create mode 100644 drivers/md/dm-vdo/murmurhash3.h
 create mode 100644 drivers/md/dm-vdo/numeric.h
 create mode 100644 drivers/md/dm-vdo/packer.c
 create mode 100644 drivers/md/dm-vdo/packer.h
 create mode 100644 drivers/md/dm-vdo/permassert.c
 create mode 100644 drivers/md/dm-vdo/permassert.h
 create mode 100644 drivers/md/dm-vdo/physical-zone.c
 create mode 100644 drivers/md/dm-vdo/physical-zone.h
 create mode 100644 drivers/md/dm-vdo/priority-table.c
 create mode 100644 drivers/md/dm-vdo/priority-table.h
 create mode 100644 drivers/md/dm-vdo/recovery-journal.c
 create mode 100644 drivers/md/dm-vdo/recovery-journal.h
 create mode 100644 drivers/md/dm-vdo/repair.c
 create mode 100644 drivers/md/dm-vdo/repair.h
 create mode 100644 drivers/md/dm-vdo/slab-depot.c
 create mode 100644 drivers/md/dm-vdo/slab-depot.h
 create mode 100644 drivers/md/dm-vdo/statistics.h
 create mode 100644 drivers/md/dm-vdo/status-codes.c
 create mode 100644 drivers/md/dm-vdo/status-codes.h
 create mode 100644 drivers/md/dm-vdo/string-utils.c
 create mode 100644 drivers/md/dm-vdo/string-utils.h
 create mode 100644 drivers/md/dm-vdo/thread-device.c
 create mode 100644 drivers/md/dm-vdo/thread-device.h
 create mode 100644 drivers/md/dm-vdo/thread-registry.c
 create mode 100644 drivers/md/dm-vdo/thread-registry.h
 create mode 100644 drivers/md/dm-vdo/thread-utils.c
 create mode 100644 drivers/md/dm-vdo/thread-utils.h
 create mode 100644 drivers/md/dm-vdo/time-utils.h
 create mode 100644 drivers/md/dm-vdo/types.h
 create mode 100644 drivers/md/dm-vdo/vdo.c
 create mode 100644 drivers/md/dm-vdo/vdo.h
 create mode 100644 drivers/md/dm-vdo/vio.c
 create mode 100644 drivers/md/dm-vdo/vio.h
 create mode 100644 drivers/md/dm-vdo/wait-queue.c
 create mode 100644 drivers/md/dm-vdo/wait-queue.h

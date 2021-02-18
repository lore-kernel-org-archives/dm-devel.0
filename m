Return-Path: <SRS0=AlgS=HU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC432C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 18 Feb 2021 01:54:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2CEF064E45
	for <dm-devel@archiver.kernel.org>; Thu, 18 Feb 2021 01:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CEF064E45
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1613613261;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nUsQtDVUb7yrg1nu1ojR0RTdGOqUuwZGPEVS1ZGOEEM=;
	b=K3NKozIuatyEipZ1i+JQ0JWe8H7ayJkZKI+WEcXzitU81mopXYVbvLaLpHEJHY/hA2BloF
	kcyit9HRytFBgbvxmNVAHo9XKTYqvtBySXe9YvhbMrhMZbe2lZjH6UvX6DKUT8nue6itOq
	01Ubnx6JHT7AouhotXj8wdCqpWerHIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-kaDtAcFmPvyKs3Q6X3K4HA-1; Wed, 17 Feb 2021 20:54:18 -0500
X-MC-Unique: kaDtAcFmPvyKs3Q6X3K4HA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 860781005501;
	Thu, 18 Feb 2021 01:54:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDACD5D9D2;
	Thu, 18 Feb 2021 01:54:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 24DED4E58D;
	Thu, 18 Feb 2021 01:54:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11I1rjQp007179 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Feb 2021 20:53:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7255E10023BF; Thu, 18 Feb 2021 01:53:45 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A0FF10074FC;
	Thu, 18 Feb 2021 01:53:38 +0000 (UTC)
Date: Wed, 17 Feb 2021 20:53:37 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20210218015337.GA19999@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>, Mike Snitzer <snitzer@redhat.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Tom Rix <trix@redhat.com>, Satya Tangirala <satyat@google.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Jinoh Kang <jinoh.kang.kr@gmail.com>, Tian Tao <tiantao6@hisilicon.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Colin Ian King <colin.king@canonical.com>,
	Alasdair G Kergon <agk@redhat.com>, Nikos Tsironis <ntsironis@arrikto.com>
Subject: [dm-devel] [git pull] device mapper changes for 5.12
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

These DM changes happen to be based on linux-block from a few weeks ago
(but an expected DM dependency on block turned out to not be needed). 
And the few block/keyslot-manager changes are accompanied by Jens'
Acked-by.

The following changes since commit 8358c28a5d44bf0223a55a2334086c3707bb4185:

  block: fix memory leak of bvec (2021-02-02 08:57:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.12/dm-changes

for you to fetch changes up to a666e5c05e7c4aaabb2c5d58117b0946803d03d2:

  dm: fix deadlock when swapping to encrypted device (2021-02-11 09:45:28 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM integrity's HMAC support to provide enhanced security of
  internal_hash and journal_mac capabilities.

- Various DM writecache fixes to address performance, fix table output
  to match what was provided at table creation, fix writing beyond end
  of device when shrinking underlying data device, and a couple other
  small cleanups.

- Add DM crypt support for using trusted keys.

- Fix deadlock when swapping to DM crypt device by throttling number
  of in-flight REQ_SWAP bios. Implemented in DM core so that other
  bio-based targets can opt-in by setting ti->limit_swap_bios.

- Fix various inverted logic bugs in the .iterate_devices callout
  functions that are used to assess if specific feature or capability
  is supported across all devices being combined/stacked by DM.

- Fix DM era target bugs that exposed users to lost writes or memory
  leaks.

- Add DM core support for passing through inline crypto support of
  underlying devices. Includes block/keyslot-manager changes that
  enable extending this support to DM.

- Various small fixes and cleanups (spelling fixes, front padding
  calculation cleanup, cleanup conditional zoned support in targets,
  etc).

----------------------------------------------------------------
Ahmad Fatoum (2):
      dm crypt: replaced #if defined with IS_ENABLED
      dm crypt: support using trusted keys

Colin Ian King (1):
      dm integrity: fix spelling mistake "flusing" -> "flushing"

Geert Uytterhoeven (1):
      dm crypt: Spelling s/cihper/cipher/

Jeffle Xu (5):
      dm: cleanup of front padding calculation
      dm table: fix iterate_devices based device capability checks
      dm table: fix DAX iterate_devices based device capability checks
      dm table: fix zoned iterate_devices based device capability checks
      dm table: remove needless request_queue NULL pointer checks

Jinoh Kang (1):
      dm persistent data: fix return type of shadow_root()

Mike Snitzer (2):
      dm writecache: use bdev_nr_sectors() instead of open-coded equivalent
      dm: simplify target code conditional on CONFIG_BLK_DEV_ZONED

Mikulas Patocka (5):
      dm integrity: introduce the "fix_hmac" argument
      dm writecache: fix performance degradation in ssd mode
      dm writecache: return the exact table values that were set
      dm writecache: fix writing beyond end of underlying device when shrinking
      dm: fix deadlock when swapping to encrypted device

Nikos Tsironis (7):
      dm era: Recover committed writeset after crash
      dm era: Update in-core bitset after committing the metadata
      dm era: Reinitialize bitset cache before digesting a new writeset
      dm era: Verify the data block size hasn't changed
      dm era: Fix bitset memory leaks
      dm era: Use correct value size in equality function of writeset tree
      dm era: only resize metadata in preresume

Satya Tangirala (5):
      block/keyslot-manager: Introduce passthrough keyslot manager
      block/keyslot-manager: Introduce functions for device mapper support
      dm: add support for passing through inline crypto support
      dm: support key eviction from keyslot managers of underlying devices
      dm: set DM_TARGET_PASSES_CRYPTO feature for some targets

Tian Tao (1):
      dm writecache: fix unnecessary NULL check warnings

Tom Rix (1):
      dm dust: remove h from printk format specifier

 .../admin-guide/device-mapper/dm-crypt.rst         |   2 +-
 .../admin-guide/device-mapper/dm-integrity.rst     |  11 +
 block/blk-crypto.c                                 |   1 +
 block/keyslot-manager.c                            | 146 ++++++++
 drivers/md/Kconfig                                 |   1 +
 drivers/md/dm-core.h                               |   9 +
 drivers/md/dm-crypt.c                              |  39 +-
 drivers/md/dm-dust.c                               |   2 +-
 drivers/md/dm-era-target.c                         |  93 +++--
 drivers/md/dm-flakey.c                             |   6 +-
 drivers/md/dm-integrity.c                          | 140 +++++++-
 drivers/md/dm-linear.c                             |   8 +-
 drivers/md/dm-table.c                              | 399 +++++++++++++++------
 drivers/md/dm-writecache.c                         |  80 +++--
 drivers/md/dm.c                                    |  96 ++++-
 drivers/md/dm.h                                    |   2 +-
 drivers/md/persistent-data/dm-btree-internal.h     |   2 +-
 drivers/md/persistent-data/dm-btree-spine.c        |   2 +-
 include/linux/device-mapper.h                      |  32 +-
 include/linux/keyslot-manager.h                    |  11 +
 include/uapi/linux/dm-ioctl.h                      |   4 +-
 21 files changed, 868 insertions(+), 218 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


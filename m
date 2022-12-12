Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E550DC4332F
	for <dm-devel@archiver.kernel.org>; Mon, 12 Dec 2022 22:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670884588;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=O157tpRt8mD3MPNgjI23HE22y7SnNFiWz0a/sXMIGbI=;
	b=bwr9UsM3x/CR4nAzkZP4Hvau5tqh8Z0Il26UNIMo9mTTBOGW5eT4QM++xf9VU7m90gnULh
	h6GZ9WF+JhyD8Z5vWAKXkgA3Dmx59EXSzCOtukJ1XmiET/qOmQhyTi2q58TGp2YJkfKABH
	+0aSr4gltQkko5AK/z/ZQZ/9qlNzjls=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-AX0hAXE7OGS7jYjKtWpyLg-1; Mon, 12 Dec 2022 17:36:27 -0500
X-MC-Unique: AX0hAXE7OGS7jYjKtWpyLg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D0C13C1014B;
	Mon, 12 Dec 2022 22:36:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77124175A2;
	Mon, 12 Dec 2022 22:36:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 570341946588;
	Mon, 12 Dec 2022 22:36:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF9E21946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Dec 2022 22:36:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9DE172026D68; Mon, 12 Dec 2022 22:36:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 966C72026D4B
 for <dm-devel@redhat.com>; Mon, 12 Dec 2022 22:36:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 781103C025C8
 for <dm-devel@redhat.com>; Mon, 12 Dec 2022 22:36:19 +0000 (UTC)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com
 [209.85.217.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-180-Zxs8HSXzMqqlSmW5UbHa2A-1; Mon, 12 Dec 2022 17:36:15 -0500
X-MC-Unique: Zxs8HSXzMqqlSmW5UbHa2A-1
Received: by mail-vs1-f48.google.com with SMTP id h26so12878118vsr.5
 for <dm-devel@redhat.com>; Mon, 12 Dec 2022 14:36:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=nWhMF1CTesM4BHybNTgKV7lM/70y3OMyFAmvejIEjS4=;
 b=HzlL6TOOujOIMH2cfUirVQZONRi26vhTk9GGf378gOoJukl1Sx8Lp4r0F4AoWGEZym
 OrQiaVCA16zcv07Tl0MGgEwpODSxeltk/bbFvGfjWmtDn6aCNqJnGvSUBuotsgHbiwBG
 Y0flTf1WGl1hqFKlVPRYc6Kn8pQIKEVjaMHlxYBrVw1g7XQ8LR2VT6CAM/+34PzVsvEI
 PZy6bxA8fnTFqCktVmUs1fJdmAGteSNQHpjIjPQP4bPh6J0e/LT6/76vgZOileKvj89m
 yzFUDs4mCvCQ/mZdoyC03xv81iwQCC2bIx3WK0q5obNAFW4K5iut0IBZaQHUnMYS4bLH
 m7PQ==
X-Gm-Message-State: ANoB5pnvLrGyQu+VvTNYPZXWR6ba68fHI9JEP4Pxi/eZWb+pMiA5AXSx
 fJgn08HKYD1yi8gW4qGd+BTKsYg=
X-Google-Smtp-Source: AA0mqf7m4mzBWV2azX1Bll5cjClij3B+qoQDpbNtARWC+17pZx8HuSAsuUyrhipDelLAGzJyv19RVw==
X-Received: by 2002:a05:6102:22cf:b0:3b0:f33b:38a5 with SMTP id
 a15-20020a05610222cf00b003b0f33b38a5mr6450670vsh.13.1670884575404; 
 Mon, 12 Dec 2022 14:36:15 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 bn39-20020a05620a2ae700b006ce76811a07sm6504540qkb.75.2022.12.12.14.36.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 14:36:14 -0800 (PST)
Date: Mon, 12 Dec 2022 17:36:13 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Y5es3Sf0DU0QEHPP@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [git pull] device mapper changes for 6.2
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Peter Korsgaard <peter@korsgaard.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Luo Meng <luomeng12@huawei.com>, Zhihao Cheng <chengzhihao1@huawei.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit b7b275e60bcd5f89771e865a8239325f86d9927d:

  Linux 6.1-rc7 (2022-11-27 13:31:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.2/dm-changes

for you to fetch changes up to 7991dbff6849f67e823b7cc0c15e5a90b0549b9f:

  dm thin: Use last transaction's pmd->root when commit failed (2022-12-08 12:17:09 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix use-after-free races due to missing resource cleanup during DM
  target destruction in DM targets: thin-pool, cache, integrity and
  clone.

- Fix ABBA deadlocks in DM thin-pool and cache targets due to their
  use of a bufio client (that has a shrinker whose locking can cause
  the incorrect locking order).

- Fix DM cache target to set its needs_check flag after first aborting
  the metadata (whereby using reset persistent-data objects to update
  the superblock with, otherwise the superblock update could be
  dropped due to aborting metadata).  This was found with
  code-inspection when comparing with the equivalent in DM thinp
  code.

- Fix DM thin-pool's presume to continue resuming the device even if
  the pool in is fail mode -- otherwise bios may never be failed up
  the IO stack (which will prevent resetting the thin-pool target via
  table reload)

- Fix DM thin-pool's metadata to use proper btree root (from previous
  transaction) if metadata commit failed.

- Add 'waitfor' module param to DM module (dm_mod) to allow dm-init to
  wait for the specified device before continuing with its DM target
  initialization.

----------------------------------------------------------------
Luo Meng (5):
      dm thin: Fix UAF in run_timer_softirq()
      dm clone: Fix UAF in clone_dtr()
      dm cache: Fix UAF in destroy()
      dm integrity: Fix UAF in dm_integrity_dtr()
      dm thin: resume even if in FAIL mode

Mike Snitzer (2):
      dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort
      dm cache: set needs_check flag after aborting metadata

Mikulas Patocka (2):
      dm ioctl: a small code cleanup in list_version_get_info
      dm ioctl: fix a couple ioctl codes

Peter Korsgaard (1):
      dm init: add dm-mod.waitfor to wait for asynchronously probed block devices

Zhihao Cheng (2):
      dm thin: Fix ABBA deadlock between shrink_slab and dm_pool_abort_metadata
      dm thin: Use last transaction's pmd->root when commit failed

 .../admin-guide/device-mapper/dm-init.rst          |  8 +++
 drivers/md/dm-cache-metadata.c                     | 54 ++++++++++++++++---
 drivers/md/dm-cache-target.c                       | 11 ++--
 drivers/md/dm-clone-target.c                       |  1 +
 drivers/md/dm-init.c                               | 22 +++++++-
 drivers/md/dm-integrity.c                          |  2 +
 drivers/md/dm-ioctl.c                              |  6 +--
 drivers/md/dm-thin-metadata.c                      | 60 +++++++++++++++++++---
 drivers/md/dm-thin.c                               | 18 +++++--
 9 files changed, 154 insertions(+), 28 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


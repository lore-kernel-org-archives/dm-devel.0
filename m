Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD907C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 21:05:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 760CB22CE3
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 21:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 760CB22CE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607115939;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wlIBFeLpx+zk4t/z4rddkoyfZYJxwFyhL2RatxZi8IY=;
	b=ZS0otBA1hU+hPZ41+XcKxEYo63CWiI8UHExL497oBUAkuuOkN9sFO2jb0EcFVltnTcfS//
	psLVjVwWDMzZe/zi2Siivgn60ge7t4x0qVSiOVpi+s4fusgKUUGOWCYnj1yWPljf8hLzCe
	Ig2gESt3LTyCAK1CvduxzOcLxZvuF3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-LQ4Dps7xP0qQEraTXdxbtQ-1; Fri, 04 Dec 2020 16:05:36 -0500
X-MC-Unique: LQ4Dps7xP0qQEraTXdxbtQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 438C0192D786;
	Fri,  4 Dec 2020 21:05:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FEA51002391;
	Fri,  4 Dec 2020 21:05:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2DEF8180954D;
	Fri,  4 Dec 2020 21:05:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4L5P0l005345 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 16:05:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BF94D10002A6; Fri,  4 Dec 2020 21:05:25 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E2C81002391;
	Fri,  4 Dec 2020 21:05:22 +0000 (UTC)
Date: Fri, 4 Dec 2020 16:05:21 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20201204210521.GA3937@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, Nick Desaulniers <ndesaulniers@google.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, vgoyal@redhat.com,
	Sergei Shtepa <sergei.shtepa@veeam.com>,
	Thomas Gleixner <tglx@linutronix.de>, Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper fixes for 5.10-rc7
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 09162bc32c880a791c6c0668ce0745cf7958f576:

  Linux 5.10-rc4 (2020-11-15 16:44:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.10/dm-fixes

for you to fetch changes up to bde3808bc8c2741ad3d804f84720409aee0c2972:

  dm: remove invalid sparse __acquires and __releases annotations (2020-12-04 15:25:18 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix DM's bio splitting changes that were made during v5.9.
  Restores splitting in terms of varied per-target ti->max_io_len
  rather than use block core's single stacked 'chunk_sectors' limit.

- Like DM crypt, update DM integrity to not use crypto drivers that
  have CRYPTO_ALG_ALLOCATES_MEMORY set.

- Fix DM writecache target's argument parsing and status display.

- Remove needless BUG() from dm writecache's persistent_memory_claim()

- Remove old gcc workaround in DM cache target's block_div() for ARM
  link errors now that gcc >= 4.9 is required.

- Fix RCU locking in dm_blk_report_zones and dm_dax_zero_page_range.

- Remove old, and now frowned upon, BUG_ON(in_interrupt()) in
  dm_table_event().

- Remove invalid sparse annotations from dm_prepare_ioctl() and
  dm_unprepare_ioctl().

----------------------------------------------------------------
Mike Snitzer (4):
      dm writecache: remove BUG() and fail gracefully instead
      dm: fix IO splitting
      dm: fix double RCU unlock in dm_dax_zero_page_range() error path
      dm: remove invalid sparse __acquires and __releases annotations

Mikulas Patocka (3):
      dm integrity: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
      dm writecache: advance the number of arguments when reporting max_age
      dm writecache: fix the maximum number of arguments

Nick Desaulniers (1):
      Revert "dm cache: fix arm link errors with inline"

Sergei Shtepa (1):
      dm: fix bug with RCU locking in dm_blk_report_zones

Thomas Gleixner (1):
      dm table: Remove BUG_ON(in_interrupt())

 block/blk-merge.c            |  2 +-
 drivers/md/dm-cache-target.c |  4 ----
 drivers/md/dm-integrity.c    |  4 ++--
 drivers/md/dm-table.c        | 11 -----------
 drivers/md/dm-writecache.c   |  6 ++++--
 drivers/md/dm.c              | 29 +++++++++++++++--------------
 include/linux/blkdev.h       | 11 ++++++-----
 7 files changed, 28 insertions(+), 39 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


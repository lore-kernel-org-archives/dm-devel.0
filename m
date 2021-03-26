Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541A3C433C1
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 19:20:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D461B619C7
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 19:20:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D461B619C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616786408;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wGYIfq+KNGBYcG7xZvqZzUhHokBYhtqd3omsZk3X7rU=;
	b=DzOsa58Y0R+U4GQs7tjpJs9U6HoLDMRqcfl8pwV8luQw5WL3Yla8mz4O6Vx8CBh0tbyFDU
	w/tE4SrWH3ng7pctjpkprF9jzOGwNDAF7m8iXP0SAYO0/uOezPI7viB0Q6uc0pIz+a4QAk
	qziWyvaoNMp5mYC31/JhbPvqtJ5PMjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-hbo3bTumMbW-SM-cJKrj6g-1; Fri, 26 Mar 2021 15:20:06 -0400
X-MC-Unique: hbo3bTumMbW-SM-cJKrj6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE9D087A83E;
	Fri, 26 Mar 2021 19:20:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AC9D5D6DC;
	Fri, 26 Mar 2021 19:20:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49C9F1809C83;
	Fri, 26 Mar 2021 19:19:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QJJuF8020625 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 15:19:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1570B2B9FA; Fri, 26 Mar 2021 19:19:56 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC2ED6062F;
	Fri, 26 Mar 2021 19:19:52 +0000 (UTC)
Date: Fri, 26 Mar 2021 15:19:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20210326191949.GA24195@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: JeongHyeon Lee <jhs2.lee@samsung.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper fixes for 5.12-rc5
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 0d02ec6b3136c73c09e7859f0d0e4e2c4c07b49b:

  Linux 5.12-rc4 (2021-03-21 14:56:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.12/dm-fixes-2

for you to fetch changes up to 4edbe1d7bcffcd6269f3b5eb63f710393ff2ec7a:

  dm ioctl: fix out of bounds array access when no devices (2021-03-26 14:51:50 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM verity target's optional argument processing.

- Fix DM core's zoned model and zone sectors checks.

- Fix spurious "detected capacity change" pr_info() when creating new
  DM device.

- Fix DM ioctl out of bounds array access in handling of
  DM_LIST_DEVICES_CMD when no devices exist.

----------------------------------------------------------------
JeongHyeon Lee (1):
      dm verity: fix DM_VERITY_OPTS_MAX value

Mikulas Patocka (2):
      dm: don't report "detected capacity change" on device creation
      dm ioctl: fix out of bounds array access when no devices

Shin'ichiro Kawasaki (1):
      dm table: Fix zoned model check and zone sectors check

 drivers/md/dm-ioctl.c         |  2 +-
 drivers/md/dm-table.c         | 33 +++++++++++++++++++++++++--------
 drivers/md/dm-verity-target.c |  2 +-
 drivers/md/dm-zoned-target.c  |  2 +-
 drivers/md/dm.c               |  5 ++++-
 include/linux/device-mapper.h | 15 ++++++++++++++-
 6 files changed, 46 insertions(+), 13 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


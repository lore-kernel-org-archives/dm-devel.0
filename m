Return-Path: <SRS0=qgMK=F2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C71C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 22 Dec 2020 15:18:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EF08122B2B
	for <dm-devel@archiver.kernel.org>; Tue, 22 Dec 2020 15:18:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF08122B2B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608650319;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZDfh0zB33JyAy/UP5Lmb+hukrbMzOpEb7U9c0HzTJTM=;
	b=Om08s5V1/ZITEGnO2+4KAW/b3x86uoAPRHQSPs0Bt61IRbVa++cpdrTeD5jib4rSZqar4h
	5skERs9YAmYkuAicQfHFlJz2ow0/aA5MwtEWpVczdIRq3ojwSSqVvLcrgbRW3VKtBcyuO+
	cRu4oz9END2h59fnj7H5fipl76MBW9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-hZYw2W8gOw2gpY0ll6EPZw-1; Tue, 22 Dec 2020 10:18:36 -0500
X-MC-Unique: hZYw2W8gOw2gpY0ll6EPZw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8FD410054FF;
	Tue, 22 Dec 2020 15:18:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A26D60BD9;
	Tue, 22 Dec 2020 15:18:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 90F5A180954D;
	Tue, 22 Dec 2020 15:18:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BMFIQ8j024695 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Dec 2020 10:18:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F2B145D71F; Tue, 22 Dec 2020 15:18:25 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7C285D6A8;
	Tue, 22 Dec 2020 15:18:24 +0000 (UTC)
Date: Tue, 22 Dec 2020 10:18:24 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20201222151823.GA17999@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Rikard Falkeborn <rikard.falkeborn@gmail.com>,
	Antonio Quartulli <a@unstable.cc>, Qinglang Miao <miaoqinglang@huawei.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
	linux-block@vger.kernel.org,
	Zheng Yongjun <zhengyongjun3@huawei.com>, dm-devel@redhat.com,
	Mike Christie <michael.christie@oracle.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Hyeongseok Kim <hyeongseok@gmail.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper changes for 5.11
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 65f33b35722952fa076811d5686bfd8a611a80fa=
:

  block: fix incorrect branching in blk_max_size_offset() (2020-12-04 17:27=
:42 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git =
tags/for-5.11/dm-changes

for you to fetch changes up to b77709237e72d6467fb27bfbad163f7221ecd648:

  dm cache: simplify the return expression of load_mapping() (2020-12-22 09=
:54:48 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Add DM verity support for signature verification with 2nd keyring.

- Fix DM verity to skip verity work if IO completes with error while
  system is shutting down.

- Add new DM multipath "IO affinity" path selector that maps IO
  destined to a given path to a specific CPU based on user provided
  mapping.

- Rename DM multipath path selector source files to have "dm-ps"
  prefix.

- Add REQ_NOWAIT support to some other simple DM targets that don't
  block in more elaborate ways waiting for IO.

- Export DM crypt's kcryptd workqueue via sysfs (WQ_SYSFS).

- Fix error return code in DM's target_message() if empty message is
  received.

- A handful of other small cleanups.

----------------------------------------------------------------
Antonio Quartulli (1):
      dm ebs: avoid double unlikely() notation when using IS_ERR()

Hyeongseok Kim (1):
      dm verity: skip verity work if I/O error when system is shutting down

Jeffle Xu (3):
      dm: remove unnecessary current->bio_list check when submitting split =
bio
      dm: add support for REQ_NOWAIT to various targets
      dm crypt: export sysfs of kcryptd workqueue

Micka=EBl Sala=FCn (1):
      dm verity: Add support for signature verification with 2nd keyring

Mike Christie (1):
      dm mpath: add IO affinity path selector

Mike Snitzer (1):
      dm: rename multipath path selector source files to have "dm-ps" prefi=
x

Qinglang Miao (1):
      dm ioctl: fix error return code in target_message

Rikard Falkeborn (1):
      dm crypt: Constify static crypt_iv_operations

Zheng Yongjun (1):
      dm cache: simplify the return expression of load_mapping()

 Documentation/admin-guide/device-mapper/verity.rst |   7 +-
 drivers/md/Kconfig                                 |  22 +-
 drivers/md/Makefile                                |  20 +-
 drivers/md/dm-cache-target.c                       |   7 +-
 drivers/md/dm-crypt.c                              |  13 +-
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-ioctl.c                              |   1 +
 ...vice-time.c =3D> dm-ps-historical-service-time.c} |   0
 drivers/md/dm-ps-io-affinity.c                     | 272 +++++++++++++++++=
++++
 .../md/{dm-queue-length.c =3D> dm-ps-queue-length.c} |   0
 .../md/{dm-round-robin.c =3D> dm-ps-round-robin.c}   |   0
 .../md/{dm-service-time.c =3D> dm-ps-service-time.c} |   0
 drivers/md/dm-stripe.c                             |   2 +-
 drivers/md/dm-switch.c                             |   1 +
 drivers/md/dm-unstripe.c                           |   1 +
 drivers/md/dm-verity-target.c                      |  12 +-
 drivers/md/dm-verity-verify-sig.c                  |   9 +-
 drivers/md/dm-zero.c                               |   1 +
 drivers/md/dm.c                                    |   2 +-
 19 files changed, 345 insertions(+), 27 deletions(-)
 rename drivers/md/{dm-historical-service-time.c =3D> dm-ps-historical-serv=
ice-time.c} (100%)
 create mode 100644 drivers/md/dm-ps-io-affinity.c
 rename drivers/md/{dm-queue-length.c =3D> dm-ps-queue-length.c} (100%)
 rename drivers/md/{dm-round-robin.c =3D> dm-ps-round-robin.c} (100%)
 rename drivers/md/{dm-service-time.c =3D> dm-ps-service-time.c} (100%)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


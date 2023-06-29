Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E99EB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jun 2023 20:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688071952;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eo6YAY53k7fmxEwq+Q34ECfln3x2OWey4Zf9hOOgClU=;
	b=Zog7Ta2UMIG62js5TaxGFBR/Pth4sOnK7E8LsbEEAyHkjNKqqhOmP7GeAyz2/jQTiOziYu
	MqH6+ave2ZNDUWY1f9JcwIp25B0VeOBQ05m7gYjbor3I8Il5EdcDM+dyP75gNWisoP3XVw
	fzmVNwdu77WY086RN0yDFaCk4YIki4A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-a0pkpz0NNnSiFTGvAchinA-1; Thu, 29 Jun 2023 16:52:29 -0400
X-MC-Unique: a0pkpz0NNnSiFTGvAchinA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B3C41C0E0C4;
	Thu, 29 Jun 2023 20:52:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 279EAC00049;
	Thu, 29 Jun 2023 20:52:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CCB451946A41;
	Thu, 29 Jun 2023 20:52:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1B06C19465B6
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Jun 2023 20:52:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E87AA4CD0C1; Thu, 29 Jun 2023 20:52:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1345492C13
 for <dm-devel@redhat.com>; Thu, 29 Jun 2023 20:52:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C37331C0E0C0
 for <dm-devel@redhat.com>; Thu, 29 Jun 2023 20:52:23 +0000 (UTC)
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com
 [209.85.222.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-VEf4nnVrOdGcX0IptKblZg-1; Thu, 29 Jun 2023 16:52:22 -0400
X-MC-Unique: VEf4nnVrOdGcX0IptKblZg-1
Received: by mail-qk1-f176.google.com with SMTP id
 af79cd13be357-765a7768f1dso106428185a.0
 for <dm-devel@redhat.com>; Thu, 29 Jun 2023 13:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688071941; x=1690663941;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=7d9FeE6aTXB8fD9aXlVOD/C2mJ6jYgFumLfL05JyPP0=;
 b=G4k3Ss+1fZYEQ6dN4S5kUUnTRnpCRHrq0Qfc20dnPAdMnV9bAGeE76NeY8vyoec6Fv
 vrXWwuo46YQNKnKy8VW1Etv4JHkEs1949qLL8fLPHJWroY6DkOsWIkY9ALUUDoCJc4bO
 f/fp9ISSySk4wGnsy3RE5CybrFZOLS43mjjHwHZrTwgKMVZ4hauxGzZ3w3w0OdTDFp8N
 XQCph1j4Gh8I+ZEBv8Ts8CubB6cwU2dGnhHiaL8KlyhsoHDRwpQqoEglUYdAtw65OnH/
 Uzdl2L10yoP1JsoCvcdCTw1B2IuKFPMXZEHMncXtE6zeY6saOSm8a2uMHtdRSJCtiB/m
 u2Hw==
X-Gm-Message-State: ABy/qLZfZptSh3CLVzKCnSytYwfyvnKBphfpLHJtVQDd5wGUdXLqFNFG
 MqZoMVp4bcVN7/70d3r+2bXPKfc=
X-Google-Smtp-Source: APBJJlG0rEu2m/z+yAI2XZTQcS505crnEykvGdraPZcoAo7WoA1gxmfc8Yftx51iNuoQsE7uh/NqAA==
X-Received: by 2002:a05:620a:294b:b0:765:6584:b033 with SMTP id
 n11-20020a05620a294b00b007656584b033mr449955qkp.50.1688071941611; 
 Thu, 29 Jun 2023 13:52:21 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 h22-20020a05620a13f600b00766f9df4a95sm4119085qkl.112.2023.06.29.13.52.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Jun 2023 13:52:21 -0700 (PDT)
Date: Thu, 29 Jun 2023 16:52:20 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <ZJ3vBCypvTQ7w9pN@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [git pull] device mapper changes for 6.5
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
Cc: Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Li Nan <linan122@huawei.com>, Russell Harmon <eatnumber1@gmail.com>,
 Demi Marie Obenour <demi@invisiblethingslab.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Li Lingfeng <lilingfeng3@huawei.com>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

This pull is based on an earlier subset of changes that you already
pulled in for 6.5 via the block tree.

The following changes since commit 245165658e1c9f95c0fecfe02b9b1ebd30a1198a:

  blk-mq: fix NULL dereference on q->elevator in blk_mq_elv_switch_none (2023-06-16 10:12:25 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.5/dm-changes

for you to fetch changes up to e2c789cab60a493a72b42cb53eb5fbf96d5f1ae3:

  dm: get rid of GFP_NOIO workarounds for __vmalloc and kvmalloc (2023-06-27 16:06:54 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Update DM crypt to allocate compound pages if possible.

- Fix DM crypt target's crypt_ctr_cipher_new return value on invalid
  AEAD cipher.

- Fix DM flakey testing target's write bio corruption feature to
  corrupt the data of a cloned bio instead of the original.

- Add random_read_corrupt and random_write_corrupt features to DM
  flakey target.

- Fix ABBA deadlock in DM thin metadata by resetting associated bufio
  client rather than destroying and recreating it.

- A couple other small DM thinp cleanups.

- Update DM core to support disabling block core IO stats accounting
  and optimize away code that isn't needed if stats are disabled.

- Other small DM core cleanups.

- Improve DM integrity target to not require so much memory on 32 bit
  systems. Also only allocate the recalculate buffer as needed (and
  increasingly reduce its size on allocation failure).

- Update DM integrity to use %*ph for printing hexdump of a small
  buffer. Also update DM integrity documentation.

- Various DM core ioctl interface hardening.  Now more careful about
  alignment of structures and processing of input passed to the kernel
  from userspace. Also disallow the creation of DM devices named
  "control", "." or ".."

- Eliminate GFP_NOIO workarounds for __vmalloc and kvmalloc in DM
  core's ioctl and bufio code.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmScyjAACgkQxSPxCi2d
A1pilwgAucNIAB6uN4ke4WZrMVxSFntUkqDTkCs2Ycw+W4Tf1Mtrj/4WeBzFdJaA
oZMK04LUGaFFXn+halsCDzB354yT9C7V/KfXW8pCM1c9BRz4e8272i2HSN4WwD5n
BU4gVaOV5BwxynfF3Z5siRraad1AwmdoRGGsqzVRESAKaObXU//1tnO42UhxRVhn
nzFqhIm0xRcLAd8xIBlMsZQGIloicdDP9wZdWzTEDspQiwR2dFRmH9bUF8OmsS+h
KwhtDty7aZO+4gJ1ccBImijzQCmbAo7dmFhDfoLXaA5Jt6UwTXMeBHm4aUPMnvQe
NVXoRZJodDemwM642Q/Tx1SpsX6QmA==
=4R7u
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Andy Shevchenko (1):
      dm integrity: Use %*ph for printing hexdump of a small buffer

Christophe JAILLET (1):
      dm zone: Use the bitmap API to allocate bitmaps

Demi Marie Obenour (6):
      dm ioctl: Check dm_target_spec is sufficiently aligned
      dm ioctl: Avoid pointer arithmetic overflow
      dm ioctl: structs and parameter strings must not overlap
      dm ioctl: Avoid double-fetch of version
      dm ioctl: Refuse to create device named "control"
      dm ioctl: Refuse to create device named "." or ".."

Li Lingfeng (1):
      dm thin metadata: Fix ABBA deadlock by resetting dm_bufio_client

Li Nan (1):
      dm: support turning off block-core's io stats accounting

Mike Snitzer (6):
      dm thin: remove return code variable in pool_map
      dm thin: update .io_hints methods to not require handling discards last
      dm: avoid needless dm_io access if all IO accounting is disabled
      dm: skip dm-stats work in alloc_io() unless needed
      dm: remove stale/redundant dm_internal_{suspend,resume} prototypes in dm.h
      dm thin: disable discards for thin-pool if no_discard_passdown

Mikulas Patocka (8):
      dm crypt: allocate compound pages if possible
      dm flakey: clone pages on write bio before corrupting them
      dm flakey: introduce random_read_corrupt and random_write_corrupt options
      dm crypt: fix crypt_ctr_cipher_new return value on invalid AEAD cipher
      dm integrity: reduce vmalloc space footprint on 32-bit architectures
      dm integrity: only allocate recalculate buffer when needed
      dm integrity: scale down the recalculate buffer if memory allocation fails
      dm: get rid of GFP_NOIO workarounds for __vmalloc and kvmalloc

Russell Harmon (4):
      Documentation: dm-integrity: Fix minor grammatical error.
      Documentation: dm-integrity: Document the meaning of "buffer".
      Documentation: dm-integrity: Document default values.
      Documentation: dm-integrity: Document an example of how the tunables relate.

 .../admin-guide/device-mapper/dm-flakey.rst        |  10 +
 .../admin-guide/device-mapper/dm-integrity.rst     |  43 +++--
 drivers/md/dm-bufio.c                              |  24 +--
 drivers/md/dm-core.h                               |   3 +-
 drivers/md/dm-crypt.c                              |  51 +++--
 drivers/md/dm-flakey.c                             | 210 ++++++++++++++++++---
 drivers/md/dm-integrity.c                          |  85 ++++-----
 drivers/md/dm-ioctl.c                              |  98 +++++++---
 drivers/md/dm-thin-metadata.c                      |  58 +++---
 drivers/md/dm-thin.c                               |  41 ++--
 drivers/md/dm-zone.c                               |  15 +-
 drivers/md/dm.c                                    |  58 +++---
 drivers/md/dm.h                                    |   3 -
 drivers/md/persistent-data/dm-block-manager.c      |   6 +
 drivers/md/persistent-data/dm-block-manager.h      |   1 +
 drivers/md/persistent-data/dm-space-map.h          |   3 +-
 .../md/persistent-data/dm-transaction-manager.c    |   3 +
 include/linux/dm-bufio.h                           |   2 +
 18 files changed, 478 insertions(+), 236 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C03C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 21:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666129078;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XzZN1HUBHlRcUZb7rI71/8bLv/PT2/fIjL4fqU2CV0Q=;
	b=WcLODboamCI+9E0+hE7DQ+Yg229U5Hei63kYjpqNBTrgcCdJlcOt8o5WPBU9d5T6z8XPN4
	1KglLdnQKWvdFyEA7ChoXN2IZdgnprDqxFiONAzYujR5zhJhe2074zPqBQNR4ef43i1FAw
	bPdqgKRk1/iXpkhs8AJE3Mw/eKp2fJE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-GH0pjeHdNfqIIRH_b8fl8Q-1; Tue, 18 Oct 2022 17:37:55 -0400
X-MC-Unique: GH0pjeHdNfqIIRH_b8fl8Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5263638012CB;
	Tue, 18 Oct 2022 21:37:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4DD2A14588B5;
	Tue, 18 Oct 2022 21:37:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0EC011946594;
	Tue, 18 Oct 2022 21:37:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 868F4194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 21:37:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7A49A53AA; Tue, 18 Oct 2022 21:37:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72D19FD48
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 21:37:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 519C685A583
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 21:37:26 +0000 (UTC)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com
 [209.85.222.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-152-YEcOVLteMUmh-wzdtKScrQ-1; Tue, 18 Oct 2022 17:37:24 -0400
X-MC-Unique: YEcOVLteMUmh-wzdtKScrQ-1
Received: by mail-qk1-f178.google.com with SMTP id z30so9550607qkz.13
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 14:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=qucTfioTfkNWPiEspTo39qx+nKJrutlIOcYMZym3P+I=;
 b=h/GZ4f2iliI+PmIDnjd+4LY3wxSSMrq/J/TbQrjxvJSoCuW6Z3+280qr87Y+8z2ke3
 ctHTr1yrlLOLr5n7ITu7PEomUyKFhYnre5bCVa437FuDBC6tVmp7o4akwlYaOCqnQi/o
 J/PXDD1WRtNQHitwhqg2KwTaet75xWourkqyfbfiAH3NJXq+MoAAw5xD04oA2y19LtXU
 wDwpzw55Eh8PoBELq9Dy4k74d4mG4unlBuaBoPt2bXmTjRuY46CAmKMCyFaH83ygMo/7
 kHEi8wsbLFcu3Q6tpcO5Hqi/kq+WsClzEG0T35HCZAekhiSlFIn57qBhoxTI0Ykm094t
 bmGw==
X-Gm-Message-State: ACrzQf17C8dgqVsKMDRq8KsHnV92H4EKSXg3RLZrbnn8f6U73SCUKQeq
 fmkhJVioWXrUy1NZHRkSORk7QME=
X-Google-Smtp-Source: AMsMyM4At/fG60tC2mMfxvZET8ME+iGLCQzyZE1N0TiB9lYPVFAtWa9SVDXQrmEBtekB1mkTzcgOOA==
X-Received: by 2002:a37:ae87:0:b0:6d1:debe:4cf4 with SMTP id
 x129-20020a37ae87000000b006d1debe4cf4mr3458565qke.655.1666129044312; 
 Tue, 18 Oct 2022 14:37:24 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 bm30-20020a05620a199e00b006e42a8e9f9bsm3285240qkb.121.2022.10.18.14.37.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Oct 2022 14:37:23 -0700 (PDT)
Date: Tue, 18 Oct 2022 17:37:22 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Y08ckqIVOmGVVX5e@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [git pull v2] device mapper changes for 6.1
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
Cc: Jilin Yuan <yuanjilin@cdjrlc.com>, Nikos Tsironis <ntsironis@arrikto.com>,
 Shaomin Deng <dengshaomin@cdjrlc.com>, Nathan Huckleberry <nhuck@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Genjian Zhang <zhanggenjian@kylinos.cn>,
 Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
 Jiangshan Yi <yijiangshan@kylinos.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

I dropped the DM ioctl changes to allow returning an error string to
userspace.  I rebased the unrelated earlier DM changes (from tag
for-6.1/dm-changes) ontop of the 'for-6.1/dm-fix' tag... and arrived
this single new tag (for-6.1/dm-changes-v2) for you to pull.

The following changes since commit bb1a1146467ad812bb65440696df0782e2bc63c8:

  Merge tag 'cgroup-for-6.1-rc1-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup (2022-10-17 18:52:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.1/dm-changes-v2

for you to fetch changes up to 5434ee8d28575b2e784bd5b4dbfc912e5da90759:

  dm clone: Fix typo in block_device format specifier (2022-10-18 17:17:48 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix dm-bufio to use test_bit_acquire to properly test_bit on arches
  with weaker memory ordering.

- DM core replace DMWARN with DMERR or DMCRIT for fatal errors.

- Enable WQ_HIGHPRI on DM verity target's verify_wq.

- Add documentation for DM verity's try_verify_in_tasklet option.

- Various typo and redundant word fixes in code and/or comments.

----------------------------------------------------------------
Genjian Zhang (1):
      dm: remove unnecessary assignment statement in alloc_dev()

Jiangshan Yi (1):
      dm raid: fix typo in analyse_superblocks code comment

Jilin Yuan (1):
      dm raid: delete the redundant word 'that' in comment

Mikulas Patocka (2):
      dm bufio: use the acquire memory barrier when testing for B_READING
      dm: change from DMWARN to DMERR or DMCRIT for fatal errors

Milan Broz (1):
      dm verity: Add documentation for try_verify_in_tasklet option

Nathan Huckleberry (1):
      dm verity: enable WQ_HIGHPRI on verify_wq

Nikos Tsironis (1):
      dm clone: Fix typo in block_device format specifier

Shaomin Deng (1):
      dm cache: delete the redundant word 'each' in comment

 Documentation/admin-guide/device-mapper/verity.rst |  4 ++
 drivers/md/dm-bufio.c                              | 13 ++--
 drivers/md/dm-cache-policy.h                       |  2 +-
 drivers/md/dm-clone-target.c                       |  2 +-
 drivers/md/dm-ioctl.c                              | 78 +++++++++++-----------
 drivers/md/dm-raid.c                               |  4 +-
 drivers/md/dm-rq.c                                 |  4 +-
 drivers/md/dm-stats.c                              |  2 +-
 drivers/md/dm-table.c                              | 78 +++++++++++-----------
 drivers/md/dm-verity-target.c                      | 18 ++---
 drivers/md/dm.c                                    |  9 ++-
 11 files changed, 110 insertions(+), 104 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


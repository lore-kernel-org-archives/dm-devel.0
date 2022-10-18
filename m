Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE2CC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666110069;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NHXAaRq4zLNIH7s3J/jCNoQ+KScVzPbSy8LFKtRPsHs=;
	b=UzatcoTHxV3ooWpZhj9C3hC58b/X9+i8nDqf+1uhd5rVb5FKczV0G3/ccifCnYPMg/P5KU
	vTVPzow6cTiwX8KvQrCuNgBJo7ApggJJPT1pQBTeoCfmVu/oF9TK9OrMLMoWaOQveVr8FR
	TJosxIANZbHz5gPQBqC+s/EIn0mGvwY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-qezsPoCUOtCQvacxJ-piZw-1; Tue, 18 Oct 2022 12:21:05 -0400
X-MC-Unique: qezsPoCUOtCQvacxJ-piZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A56F811E67;
	Tue, 18 Oct 2022 16:21:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 51EB949AFD;
	Tue, 18 Oct 2022 16:20:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ED6F31946594;
	Tue, 18 Oct 2022 16:20:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C4EF7194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 16:20:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 80F802024CCA; Tue, 18 Oct 2022 16:20:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 79DB92024CBB
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 16:20:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C2EE101A52A
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 16:20:54 +0000 (UTC)
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com
 [209.85.219.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-110-GAU6YWXMNHmaa32n-rc1aw-1; Tue, 18 Oct 2022 12:20:52 -0400
X-MC-Unique: GAU6YWXMNHmaa32n-rc1aw-1
Received: by mail-qv1-f43.google.com with SMTP id mx8so9603116qvb.8
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 09:20:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=/mmgDfGKB2W6PRUEFzLxW7KICbLn+XjG+eqWRhrcmOU=;
 b=cUrR2el0fJ3lQms4raOlfp0MahkS/ud4Bnrl1g5CQBTxkeFTiZvoYwESDst5GI1lOM
 2zimpDCcvYhg7Apogn15wptevpoMoQOQSGgYjwT/YuOXYf/9f9oP+5dsIwSXf4RsGsWN
 OwewEqpVQvxeb1hFvaz0CcvIw3FtMBWij9+L5SCE6u0R2jHiFkJCQ4+LBUCPjifBfLSE
 OmAmjdYwNUXob1BB/hePFge3RyxtP376WJGw+JfQwyF+/MyLiZoz80bzHBfLEqMp+sUW
 hRTVgOSGKFSkpxotifbLVWo6/C1XbPPk4Wqly6+L9vNd/8PFUYaqaDxQPojCu6YiYC7R
 wL8A==
X-Gm-Message-State: ACrzQf3J6yEo6ENCMpUTdA336xvyBNhByMB2dNTRJSkH8DAQDNEdRU8W
 bwCzDuNvXsuWbWePkV+Wqd8MGbE=
X-Google-Smtp-Source: AMsMyM7Rw3L0Y2ai/yquews02o6/G5Xu6/dKPlVdzV9roJ4q+sFgTNEAJuIHNA0cHHqzubGFlnaMWA==
X-Received: by 2002:a05:6214:500d:b0:4af:8e3c:d254 with SMTP id
 jo13-20020a056214500d00b004af8e3cd254mr2935011qvb.36.1666110052039; 
 Tue, 18 Oct 2022 09:20:52 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 cb23-20020a05622a1f9700b0039cc22a2c49sm2173671qtb.47.2022.10.18.09.20.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Oct 2022 09:20:51 -0700 (PDT)
Date: Tue, 18 Oct 2022 12:20:50 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Y07SYs98z5VNxdZq@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [git pull] device mapper changes for 6.1
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

I missed sending the DM changes during the 6.1 merge window. Slipped my
mind largely due to there not being anything super urgent or more
elaborate this cycle.

But there is one additional stable@ fix from Mikulas that I'll send
separately since it requires the recently introduced test_bit_acquire().

The following changes since commit 1c23f9e627a7b412978b4e852793c5e3c3efc555:

  Linux 6.0-rc2 (2022-08-21 17:32:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.1/dm-changes

for you to fetch changes up to a871fb26aba8911ea313dc7bd28f3e788a80fdb4:

  dm clone: Fix typo in block_device format specifier (2022-10-04 19:00:22 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- DM core replace DMWARN with DMERR or DMCRIT for fatal errors.

- Enhance DM ioctl interface to allow returning an error string to
  userspace. Depends on exporting is_vmalloc_or_module_addr() to allow
  DM core to conditionally free memory allocated with kasprintf().

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

Mikulas Patocka (4):
      dm: change from DMWARN to DMERR or DMCRIT for fatal errors
      dm ioctl: add an option to return an error string to userspace
      mm: export is_vmalloc_or_module_addr
      dm: support allocating error strings to enhance errors returned to userspace

Milan Broz (1):
      dm verity: Add documentation for try_verify_in_tasklet option

Nathan Huckleberry (1):
      dm verity: enable WQ_HIGHPRI on verify_wq

Nikos Tsironis (1):
      dm clone: Fix typo in block_device format specifier

Shaomin Deng (1):
      dm cache: delete the redundant word 'each' in comment

 Documentation/admin-guide/device-mapper/verity.rst |   4 +
 drivers/md/dm-cache-policy.h                       |   2 +-
 drivers/md/dm-clone-target.c                       |   2 +-
 drivers/md/dm-ioctl.c                              | 125 +++++++++++-------
 drivers/md/dm-raid.c                               |   4 +-
 drivers/md/dm-rq.c                                 |   4 +-
 drivers/md/dm-stats.c                              |   2 +-
 drivers/md/dm-table.c                              | 139 +++++++++++----------
 drivers/md/dm-verity-target.c                      |  18 +--
 drivers/md/dm.c                                    |   9 +-
 include/linux/device-mapper.h                      |  18 ++-
 include/uapi/linux/dm-ioctl.h                      |  14 ++-
 mm/vmalloc.c                                       |   1 +
 13 files changed, 205 insertions(+), 137 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


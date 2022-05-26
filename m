Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19F3C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 26 May 2022 16:41:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-os3_SVgpNpGSV_qVQkiEMQ-1; Thu, 26 May 2022 12:41:24 -0400
X-MC-Unique: os3_SVgpNpGSV_qVQkiEMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E83B7801E6B;
	Thu, 26 May 2022 16:41:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B903112131B;
	Thu, 26 May 2022 16:41:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2BB4F1947052;
	Thu, 26 May 2022 16:41:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B462F1947051
 for <dm-devel@listman.corp.redhat.com>; Thu, 26 May 2022 16:41:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 94694400F3E8; Thu, 26 May 2022 16:41:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 902F340D282F
 for <dm-devel@redhat.com>; Thu, 26 May 2022 16:41:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78416294EDC2
 for <dm-devel@redhat.com>; Thu, 26 May 2022 16:41:18 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
 [209.85.160.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-QGQynRWIN8W7q9oP8q7WMg-1; Thu, 26 May 2022 12:41:16 -0400
X-MC-Unique: QGQynRWIN8W7q9oP8q7WMg-1
Received: by mail-qt1-f182.google.com with SMTP id s31so2276154qtc.3
 for <dm-devel@redhat.com>; Thu, 26 May 2022 09:41:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=z+vKLXdt60QDKO4b9wBgGIXuJw5ArCpTgFr2gphTDQc=;
 b=orKc2E5QWw7H447LVHZDApXn5d+KJYIlPkS7z9THM/rrWlFz8YbWhNqdKQKwQTfuxm
 2fmfngtPEJB2Z1Ej/dO+L10lYB3bx5ruSIxlj97GHxJCr5veOoRvXSpL7yhqiFukQpvr
 t9ILBFsOOLpzDznqh88BOcADhC3NsUKfdwTwWpzb9zajRmlZR6nPYfSE51jGQ1tFoW02
 216nksW9cbu7UBubpN5Z4M6Db8KCD77EiAGkfPEoo07AJ+vtIirK+mxA03LmRagSuaKe
 9Y5OOjCkI2uHGcQ3cn5XkgnzP3pQ/1Wi0gMbem+7AB+li0jiAj0SyPcc1CD/5XFqB+n2
 nFfQ==
X-Gm-Message-State: AOAM531irEHANVCokFKVLvxcGxRPVmMVDMLfCI7WZwEI2qqUSw1RJp30
 I7SBUbmz5Xs6rjz4DCaz6+61Xx8=
X-Google-Smtp-Source: ABdhPJy95jqT31JGjEPtVMwTjrkY/rfbXKIerIVzATOcXvkzK5HGQljn97qXkoV5na7XMf+Bsbf25g==
X-Received: by 2002:a05:6214:224f:b0:43f:d536:d014 with SMTP id
 c15-20020a056214224f00b0043fd536d014mr31290972qvc.50.1653583276042; 
 Thu, 26 May 2022 09:41:16 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 w21-20020a05620a445500b0069fc13ce209sm1638370qkp.58.2022.05.26.09.41.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 26 May 2022 09:41:15 -0700 (PDT)
Date: Thu, 26 May 2022 12:41:14 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Yo+tqngHo5JCZTJc@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [git pull] device mapper changes for 5.19
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
Cc: Guo Zhengkui <guozhengkui@vivo.com>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
 Gabriel Krisman Bertazi <krisman@collabora.com>,
 Dan Carpenter <dan.carpenter@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

These changes build on Jens' for-5.19 block tree because of various
block changes that impacted DM and/or prereqs for these DM changes.

The following changes since commit 069adbac2cd85ae00252da6c5576cbf9b9d9ba6e:

  block: improve the error message from bio_check_eod (2022-05-04 18:30:10 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.19/dm-changes

for you to fetch changes up to ca522482e3eafd005b8d4e8b1331c911505a58d5:

  dm: pass NULL bdev to bio_alloc_clone (2022-05-11 13:58:52 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Enable DM core bioset's per-cpu bio cache if QUEUE_FLAG_POLL
  set. This change improves DM's hipri bio polling (REQ_POLLED)
  performance by 7 - 20% depending on the system.

- Update DM core to use jump_labels to further reduce cost of unlikely
  branches for zoned block devices, dm-stats and swap_bios throttling.

- Various DM core changes to reduce bio-based DM overhead and simplify
  IO accounting.

- Fundamental DM core improvements to dm_io reference counting and the
  elimination of using bio_split()+bio_chain() -- instead DM's
  bio-based IO accounting is updated to account that a split occurred.

- Improve DM core's abnormal bio processing to do less work.

- Improve DM core's hipri polling support to use a single list rather
  than an hlist.

- Update DM core to pass NULL bdev to bio_alloc_clone() so that
  initialization that isn't useful for DM can be elided.

- Add cond_resched to DM stats' various loops that loop over all
  entries.

- Fix incorrect error code return from DM integrity's constructor.

- Make DM crypt's printing of the key constant-time.

- Update bio-based DM multipath to provide high-resolution timer to
  the Historical Service Time (HST) path selector.

----------------------------------------------------------------
Dan Carpenter (1):
      dm integrity: fix error code in dm_integrity_ctr()

Gabriel Krisman Bertazi (1):
      dm mpath: provide high-resolution timer to HST for bio-based

Guo Zhengkui (1):
      dm cache metadata: remove unnecessary variable in __dump_mapping

Mike Snitzer (14):
      dm: conditionally enable BIOSET_PERCPU_CACHE for dm_io bioset
      dm: factor out dm_io_set_error and __dm_io_dec_pending
      dm: simplify dm_io access in dm_split_and_process_bio
      dm: simplify dm_start_io_acct
      dm: mark various branches unlikely
      dm: add local variables to clone_endio and __map_bio
      dm: move hot dm_io members to same cacheline as dm_target_io
      dm: introduce dm_{get,put}_live_table_bio called from dm_submit_bio
      dm: conditionally enable branching for less used features
      dm: simplify basic targets
      dm: use bio_sectors in dm_aceept_partial_bio
      dm: simplify bio-based IO accounting further
      dm: improve abnormal bio processing
      dm: pass NULL bdev to bio_alloc_clone

Mikulas Patocka (2):
      dm stats: add cond_resched when looping over entries
      dm crypt: make printing of the key constant-time

Ming Lei (7):
      dm: don't pass bio to __dm_start_io_acct and dm_end_io_acct
      dm: pass dm_io instance to dm_io_acct directly
      dm: switch to bdev based IO accounting interfaces
      dm: improve bio splitting and associated IO accounting
      dm: don't grab target io reference in dm_zone_map_bio
      dm: improve dm_io reference counting
      dm: put all polled dm_io instances into a single list

 drivers/md/dm-cache-metadata.c             |   3 +-
 drivers/md/dm-core.h                       |  38 +-
 drivers/md/dm-crypt.c                      |  14 +-
 drivers/md/dm-delay.c                      |   3 +-
 drivers/md/dm-flakey.c                     |   4 +-
 drivers/md/dm-integrity.c                  |   2 -
 drivers/md/dm-linear.c                     |  11 +-
 drivers/md/dm-mpath.c                      |   8 +-
 drivers/md/dm-path-selector.h              |  15 +
 drivers/md/dm-ps-historical-service-time.c |   1 +
 drivers/md/dm-stats.c                      |  11 +
 drivers/md/dm-table.c                      |  16 +-
 drivers/md/dm-zone.c                       |  10 -
 drivers/md/dm.c                            | 556 +++++++++++++++++------------
 drivers/md/dm.h                            |   4 +-
 15 files changed, 409 insertions(+), 287 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


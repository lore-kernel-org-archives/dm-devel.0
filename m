Return-Path: <SRS0=ugf6=NW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E80C432BE
	for <dm-devel@archiver.kernel.org>; Tue, 31 Aug 2021 16:44:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4C1716109D
	for <dm-devel@archiver.kernel.org>; Tue, 31 Aug 2021 16:44:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4C1716109D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630428246;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vnUVWR/rDJhrGr97Bgn97qwS53B21vvE9KYaBmdXy0s=;
	b=IgIH80rouWOJ+dlH3rSrlrPoDRhWeMWjQowERVVP0JBjd90ZXrODDWPkSCd9f6potIWHVR
	Aq08dRn7PwPzFaCFDpmTYjpTnr0m3gxelfDP9RAEl96vK16cVZjtvEg5Ruac8TDOn8jDPH
	MV1XN4gQ/XuAHKlmAYfbXtPics+eTpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-ypHamwSkNU21ZGueP6-Jiw-1; Tue, 31 Aug 2021 12:44:03 -0400
X-MC-Unique: ypHamwSkNU21ZGueP6-Jiw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A0708CC78D;
	Tue, 31 Aug 2021 16:43:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E820810016F4;
	Tue, 31 Aug 2021 16:43:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD0ED4BB7C;
	Tue, 31 Aug 2021 16:43:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17VGZ0iT026205 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 31 Aug 2021 12:35:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 51C36D1EB7; Tue, 31 Aug 2021 16:35:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CFFBD1EB9
	for <dm-devel@redhat.com>; Tue, 31 Aug 2021 16:34:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1C8F886486
	for <dm-devel@redhat.com>; Tue, 31 Aug 2021 16:34:55 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-488-LKpgX2GuNiKm9B2zNQSq4g-1; Tue, 31 Aug 2021 12:34:54 -0400
X-MC-Unique: LKpgX2GuNiKm9B2zNQSq4g-1
Received: by mail-qt1-f197.google.com with SMTP id
	e6-20020ac84e46000000b0029baad9aaa0so1697690qtw.11
	for <dm-devel@redhat.com>; Tue, 31 Aug 2021 09:34:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
	:content-disposition;
	bh=4Nm2E5dDL0fqt1nXLGqz42Tw2VD6isEQXWzJaVAHvdA=;
	b=UpuTWYX1a06G8cwrAhQyQfzEjI9z6uGygOfSqRTyJNj+mN1xQ6ex35U2AQ7DwGqTNG
	4kmqt7jJ7eIssM5/QXdLBd4eDcPX4E49Ir9V3sbSCQpjwXmmy1scemUr1tVeNTKI0dpb
	QxIvvwXeUZf9RozqOBYSLHI9t2kgNgOw8w1MDWcJvbbYOj0bV/j2bLjtyPj9wxVLY3ke
	8NbDaoT0JGS2A2ZxfiTsWlREDUCDoijITyznkdTNhDu8uQUJfHWXKuTK9IHPnvq9GVCc
	GjSnSv5W5It+a89yBHt66miIcXF670g1iARaj8AybruyiLAyHsFb0cY98zguSRTJGGsR
	QAEQ==
X-Gm-Message-State: AOAM533OGlGGDrWF3iFHYgNNWv2SNOoGmCfMWtUqEN1E0BsnUKek0zvW
	mp4VchjLsUJnkGUthMKeMMpkBhY7goCmR+XS8q8yhDyl1UQJIna0bjzX8cZXV5ChqAEF7/gmiB9
	2DQX6HVKG+eIMVA==
X-Received: by 2002:ad4:4b61:: with SMTP id m1mr30323910qvx.32.1630427693830; 
	Tue, 31 Aug 2021 09:34:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9WRe9d9sxtAwb5w51gXgJZE9Z3oYHRGzs+W/AgNdM2lsO7m9vb7Uhv+/pRaD9jfA6bUTEyw==
X-Received: by 2002:ad4:4b61:: with SMTP id m1mr30323889qvx.32.1630427693650; 
	Tue, 31 Aug 2021 09:34:53 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	u7sm10573661qtc.75.2021.08.31.09.34.52
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 31 Aug 2021 09:34:53 -0700 (PDT)
Date: Tue, 31 Aug 2021 12:34:52 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YS5aLC4FSqL31PLI@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Arne Welzel <arne.welzel@corelight.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	Alasdair G Kergon <agk@redhat.com>, Changbin Du <changbin.du@gmail.com>
Subject: [dm-devel] [git pull] device mapper changes for 5.15
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 99d26de2f6d79badc80f55b54bd90d4cb9d1ad90:

  writeback: make the laptop_mode prototypes available unconditionally (2021-08-10 07:00:50 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.15/dm-changes

for you to fetch changes up to d3703ef331297b6daa97f5228cbe2a657d0cfd21:

  dm crypt: use in_hardirq() instead of deprecated in_irq() (2021-08-20 16:25:07 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Add DM infrastructure for IMA-based remote attestion. These changes
  are the basis for deploying DM-based storage in a "cloud" that must
  validate configurations end-users run to maintain trust. These DM
  changes allow supported DM targets' configurations to be measured
  via IMA. But the policy and enforcement (of which configurations are
  valid) is managed by something outside the kernel (e.g. Keylime).

- Fix DM crypt scalability regression on systems with many cpus due to
  percpu_counter spinlock contention in crypt_page_alloc().

- Use in_hardirq() instead of deprecated in_irq() in DM crypt.

- Add event counters to DM writecache to allow users to further assess
  how the writecache is performing.

- Various code cleanup in DM writecache's main IO mapping function.

----------------------------------------------------------------
Arne Welzel (1):
      dm crypt: Avoid percpu_counter spinlock contention in crypt_page_alloc()

Changbin Du (1):
      dm crypt: use in_hardirq() instead of deprecated in_irq()

Mike Snitzer (3):
      dm writecache: split up writecache_map() to improve code readability
      dm writecache: factor out writecache_map_remap_origin()
      dm writecache: further writecache_map() cleanup

Mikulas Patocka (2):
      dm writecache: report invalid return from writecache_map helpers
      dm writecache: add event counters

Tushar Sugandhi (13):
      dm ima: measure data on table load
      dm ima: measure data on device resume
      dm ima: measure data on device remove
      dm ima: measure data on table clear
      dm ima: measure data on device rename
      dm: update target status functions to support IMA measurement
      dm: add documentation for IMA measurement support
      dm ima: prefix dm table hashes in ima log with hash algorithm
      dm ima: add version info to dm related events in ima log
      dm ima: prefix ima event name related to device mapper with dm_
      dm ima: add a warning in dm_init if duplicate ima events are not measured
      dm ima: update dm target attributes for ima measurements
      dm ima: update dm documentation for ima measurement support

 Documentation/admin-guide/device-mapper/dm-ima.rst | 715 ++++++++++++++++++++
 Documentation/admin-guide/device-mapper/index.rst  |   1 +
 .../admin-guide/device-mapper/writecache.rst       |  16 +-
 drivers/md/Makefile                                |   4 +
 drivers/md/dm-cache-target.c                       |  24 +
 drivers/md/dm-clone-target.c                       |   5 +
 drivers/md/dm-core.h                               |   5 +
 drivers/md/dm-crypt.c                              |  38 +-
 drivers/md/dm-delay.c                              |   4 +
 drivers/md/dm-dust.c                               |   4 +
 drivers/md/dm-ebs-target.c                         |   3 +
 drivers/md/dm-era-target.c                         |   4 +
 drivers/md/dm-flakey.c                             |   4 +
 drivers/md/dm-ima.c                                | 750 +++++++++++++++++++++
 drivers/md/dm-ima.h                                |  78 +++
 drivers/md/dm-integrity.c                          |  24 +
 drivers/md/dm-ioctl.c                              |  24 +-
 drivers/md/dm-linear.c                             |  10 +-
 drivers/md/dm-log-userspace-base.c                 |   3 +
 drivers/md/dm-log-writes.c                         |   4 +
 drivers/md/dm-log.c                                |  10 +
 drivers/md/dm-mpath.c                              |  40 +-
 drivers/md/dm-ps-historical-service-time.c         |   3 +
 drivers/md/dm-ps-io-affinity.c                     |   3 +
 drivers/md/dm-ps-queue-length.c                    |   3 +
 drivers/md/dm-ps-round-robin.c                     |   4 +
 drivers/md/dm-ps-service-time.c                    |   3 +
 drivers/md/dm-raid.c                               |  39 ++
 drivers/md/dm-raid1.c                              |  17 +
 drivers/md/dm-snap-persistent.c                    |   4 +
 drivers/md/dm-snap-transient.c                     |   4 +
 drivers/md/dm-snap.c                               |  13 +
 drivers/md/dm-stripe.c                             |  15 +
 drivers/md/dm-switch.c                             |   4 +
 drivers/md/dm-thin.c                               |   8 +
 drivers/md/dm-unstripe.c                           |   4 +
 drivers/md/dm-verity-target.c                      |  43 ++
 drivers/md/dm-writecache.c                         | 467 ++++++++-----
 drivers/md/dm-zoned-target.c                       |   3 +
 drivers/md/dm.c                                    |  12 +-
 include/linux/device-mapper.h                      |   6 +-
 include/uapi/linux/dm-ioctl.h                      |   6 +
 security/integrity/ima/ima_main.c                  |   1 +
 43 files changed, 2235 insertions(+), 197 deletions(-)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-ima.rst
 create mode 100644 drivers/md/dm-ima.c
 create mode 100644 drivers/md/dm-ima.h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


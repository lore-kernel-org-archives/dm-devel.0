Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B662C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  4 Mar 2022 21:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646429204;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4iMxDAfwZ9xSVW8l0r1RRSEsZJA1WYqCsZV1qnPzXMY=;
	b=BcY/GzCuWDXsH5HLE0kOJHM9RU8pr6hoX2Jr3YEPGsqLbVsEKNKlSgn2AxA9qohDXocqtE
	qrzJ3HaBotRNanBXZoycQKF2shUSHCBxD2WHotspUszbwJaYFpPfFwJhUy4MU9Y1NmojLZ
	Y7jqHac9AdB2V/WqHRWjbmqEeHTOb+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-K5qxbE3dNUmf2yYDy7Fowg-1; Fri, 04 Mar 2022 16:26:40 -0500
X-MC-Unique: K5qxbE3dNUmf2yYDy7Fowg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F4488145F7;
	Fri,  4 Mar 2022 21:26:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 662981B18F;
	Fri,  4 Mar 2022 21:26:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1087B4A701;
	Fri,  4 Mar 2022 21:26:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 224LQUjI011321 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 16:26:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4455B1121315; Fri,  4 Mar 2022 21:26:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F42F1121314
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 21:26:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09522801E8D
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 21:26:27 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-657-5wln6r11P7-HdwP80Fza9g-1; Fri, 04 Mar 2022 16:26:25 -0500
X-MC-Unique: 5wln6r11P7-HdwP80Fza9g-1
Received: by mail-qt1-f197.google.com with SMTP id
	b3-20020ac84f03000000b002e038c19f71so7165892qte.2
	for <dm-devel@redhat.com>; Fri, 04 Mar 2022 13:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=VJCDl2e633LFK05nuE8gVcSj47NPxoXSEpLgb5WvFBw=;
	b=wtan8VqR2PAMtSqZ0JWXPTfJUXPpvDP9KLYXUWZsahXrsKdSS8hQhV7pGMvVSubcqr
	+6Pu/kDrXQ1JsHdNiQ1W3kyzzlb/KeMYc3N/2/lhPO7U3Du42YwHWEDXoILZx0dKyDeH
	X23V4Pes0xVIoL7/VXNDj/06pz2Cgymr/ob9cJDGROqR8IZqwmH1OnzzjSRG09W8sRuc
	zFMJJeVdQVOdPKFJ9OIPesqOgQxPQVrITNuvACMNGqvgKQFakOGKvAVUdzfWvgJfcgwM
	8tZI31mKkzs1OuPe7oznNo0AfO4rB0JbwrOe1WQPh+MK1B/zoqHu+hgdur2HLeLqc3fl
	jCDw==
X-Gm-Message-State: AOAM532/rFPECn7jIRSqgGcXnHEnbbB8oU2w1W1iV/TuM5vFTKDyXrS9
	LJirxBS67KgrDrtBHqkCjGrOSBzbiIO3M11X2+jKigHHm9hSZN8evFlhyyqc1Pb+Hx30Ovwc3j4
	RY3KeUcIvdxXASw==
X-Received: by 2002:ad4:5968:0:b0:435:17c2:8c8e with SMTP id
	eq8-20020ad45968000000b0043517c28c8emr433778qvb.120.1646429185287;
	Fri, 04 Mar 2022 13:26:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxHy6PROWMA8dQh7PKu/neB1y+0Iv/55SqrUWum+Nh77YYVw/FibH07+U/Lv/jzmhwTL3s+dA==
X-Received: by 2002:ad4:5968:0:b0:435:17c2:8c8e with SMTP id
	eq8-20020ad45968000000b0043517c28c8emr433764qvb.120.1646429185084;
	Fri, 04 Mar 2022 13:26:25 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	v129-20020a379387000000b0064936bab2fcsm2982228qkd.48.2022.03.04.13.26.24
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Mar 2022 13:26:24 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Fri,  4 Mar 2022 16:26:21 -0500
Message-Id: <20220304212623.34016-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
	ming.lei@redhat.com
Subject: [dm-devel] [PATCH v4 0/2] block/dm: support bio polling
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I've rebased Ming's latest [1] ontop of dm-5.18 [2] (which is based on
for-5.18/block). End result available in dm-5.18-biopoll branch [3]

These changes add bio polling support to DM.  Tested with linear and
striped DM targets.

IOPS improvement was ~5% on my baremetal system with a single Intel
Optane NVMe device (555K hipri=1 vs 525K hipri=0).

Ming has seen better improvement while testing within a VM:
 dm-linear: hipri=1 vs hipri=0 15~20% iops improvement
 dm-stripe: hipri=1 vs hipri=0 ~30% iops improvement

I'd like to merge these changes via the DM tree when the 5.18 merge
window opens.  The first block patch that adds ->poll_bio to
block_device_operations will need review so that I can take it
through the DM tree.  Reason for going through the DM tree is there
have been some fairly extensive changes queued in dm-5.18 that build
on for-5.18/block.  So I think it easiest to just add the block
depenency via DM tree since DM is first consumer of ->poll_bio

FYI, Ming does have another DM patch [4] that looks to avoid using
hlist but I only just saw it.  bio_split() _is_ involved (see
dm_split_and_process_bio) so I'm not exactly sure where he is going
with that change.  But that is DM-implementation detail that we'll
sort out. Big thing is we need approval for the first block patch to
go to Linus with the DM tree ;)

Thanks,
Mike

[1] https://github.com/ming1/linux/commits/my_v5.18-dm-bio-poll
[2] https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.18
[3] https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.18-biopoll
[4] https://github.com/ming1/linux/commit/c107c30e15041ac1ce672f56809961406e2a3e52

Ming Lei (2):
  block: add ->poll_bio to block_device_operations
  dm: support bio polling

 block/blk-core.c       |  12 +++-
 block/genhd.c          |   2 +
 drivers/md/dm-core.h   |   2 +
 drivers/md/dm-table.c  |  27 +++++++++
 drivers/md/dm.c        | 150 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h |   2 +
 6 files changed, 189 insertions(+), 6 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


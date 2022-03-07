Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA7FC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646679197;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8zlJ7Fw/CqPkpLaMCW324ab8+CrKr9jmc3n5JjkBJfM=;
	b=DTxNKjm6OKbeIdhbVMnceN3r+KrpRWOstT0ThruvJ+f2TPn2UYEsqJyHpK9NkW6BxI4KDb
	PzY91w9MJbaQN5675ur2wRDIy6ktQQQAKHnDdqiZ6qX/A6EVGynYcX5nvQBMul6NNKP11h
	7BDLbySE2htVFPNlhyS5vdOyqf07Fcs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-wJmnBWZyM6eB2AFyQseR-Q-1; Mon, 07 Mar 2022 13:53:13 -0500
X-MC-Unique: wJmnBWZyM6eB2AFyQseR-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8DEC80231F;
	Mon,  7 Mar 2022 18:53:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C18D6112132D;
	Mon,  7 Mar 2022 18:53:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5900A1966369;
	Mon,  7 Mar 2022 18:53:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2728E19305AC
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 18:53:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E0981C07F5D; Mon,  7 Mar 2022 18:53:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D6243C1D3AE
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 18:53:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A450108C185
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 18:53:06 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-lzbgqmXFMROWl4-ljRNY2g-1; Mon, 07 Mar 2022 13:53:05 -0500
X-MC-Unique: lzbgqmXFMROWl4-ljRNY2g-1
Received: by mail-qk1-f200.google.com with SMTP id
 207-20020a3703d8000000b0067b14f0844dso3717518qkd.22
 for <dm-devel@redhat.com>; Mon, 07 Mar 2022 10:53:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=PIrPGInHSFz6WNm2eA20N9PIF/z1AQDXcwiipcOk5RY=;
 b=pNQ5Ns4fl6rVQH1PMa2EjQGKgg8CW9HbrG0/PQ2oM5JCwP45mlrQQrEtoVmwDB8ntf
 gwQqqP2wz8vFJVwn0Yqaf9osvW4GcqPhI2OILuJm4fKfuGFVoD81nzEQnf5/1H+oePVp
 OgwmXmS1U3UV8j7jw4DfdWmHltWkna81UaVNqcGfjljW/gAehMYOkvZvfraTebpNpEtc
 2WHejY2Svkb2K1P0ubSihV0jU69CvYWTW0fH4egfP8aXOf4/wzYjPKF4v4Cd14UMJWH5
 cnzmYuo2Yffjxf/PEqOqtdhnBHag8wQIOLvsI3XzQUzKjIjDz1uveZD/lCHJfesrmCZZ
 EBow==
X-Gm-Message-State: AOAM531+sEai7zTDSbzPGKxm/kzTHBye1OY79QX3NB8vytsJs9yE/Qsc
 5nr63F8r5Hyr8ScfFotYmYQkfjRGTVSdGgWnCQ+R6MTu0zLxwQ6X/LUsH+MozyK9bhdkN87Cc7k
 47p4W8xq0lctsdw==
X-Received: by 2002:a05:6214:4013:b0:435:8b0f:a127 with SMTP id
 kd19-20020a056214401300b004358b0fa127mr5268772qvb.31.1646679184567; 
 Mon, 07 Mar 2022 10:53:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9csigrfNznVmFZq2Q9zzriqWpGxcyNHJVTL9cD9sj+DHv7P9mtBvYYX+RHoMj/pfPQRrZJw==
X-Received: by 2002:a05:6214:4013:b0:435:8b0f:a127 with SMTP id
 kd19-20020a056214401300b004358b0fa127mr5268757qvb.31.1646679184337; 
 Mon, 07 Mar 2022 10:53:04 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 s8-20020a05622a1a8800b002de08a30becsm9075790qtc.80.2022.03.07.10.53.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Mar 2022 10:53:04 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Mon,  7 Mar 2022 13:53:01 -0500
Message-Id: <20220307185303.71201-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v6 0/2] block/dm: support bio polling
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
Optane NVMe device (561K hipri=1 vs 530K hipri=0).

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

Thanks,
Mike

[1] https://github.com/ming1/linux/commits/my_v5.18-dm-bio-poll
[2] https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.18
[3] https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.18-biopoll
[4] https://github.com/ming1/linux/commit/c107c30e15041ac1ce672f56809961406e2a3e52

v6: Ming switched from reusing .bi_end_io to .bi_private and added a
    comment to comment-block above dm_get_bio_hlist_head as suggested
    by Jens.

v5: remove WARN_ONs in ->poll_bio interface patch. Fixed comment typo
    along the way (found while seeing how other
    block_device_operations are referenced in block's code comments).

Ming Lei (2):
  block: add ->poll_bio to block_device_operations
  dm: support bio polling

 block/blk-core.c       |  14 +++--
 block/genhd.c          |   4 ++
 drivers/md/dm-core.h   |   2 +
 drivers/md/dm-table.c  |  27 ++++++++++
 drivers/md/dm.c        | 143 +++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/blkdev.h |   2 +
 6 files changed, 184 insertions(+), 8 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


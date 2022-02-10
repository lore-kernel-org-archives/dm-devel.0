Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835B3C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532819;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=G85xol9ccgNMIpjmsnt4DAWSE2vba6VP1ofi3YcEctU=;
	b=HyggbQYbWHMquzHrDJOwxpJoOy+GQYfCZbkToL6KQQnSElBK7tvH/9ZkA95F/QO/5jk30p
	gCqw9jqyquz7eAUFGYA3rVbEHP689AC/TZ9V0vWM85IT1u6tQ8Oz6f6nZVq1MFzdmuyclk
	zaROyCF4P23tZ/CencKxOKrJpdSPofc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-N_7sfFDtMoali6Wt2N3HZA-1; Thu, 10 Feb 2022 17:40:15 -0500
X-MC-Unique: N_7sfFDtMoali6Wt2N3HZA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 410FA100D682;
	Thu, 10 Feb 2022 22:40:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB7094CEEE;
	Thu, 10 Feb 2022 22:40:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 057CC1809CB8;
	Thu, 10 Feb 2022 22:40:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcaEl014758 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 42093401E7F; Thu, 10 Feb 2022 22:38:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E74E401E7A
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 259531C05157
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:36 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
	[209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-528-8sTo4tq_OUqnHAIbvP7l5w-1; Thu, 10 Feb 2022 17:38:35 -0500
X-MC-Unique: 8sTo4tq_OUqnHAIbvP7l5w-1
Received: by mail-qv1-f71.google.com with SMTP id
	jn13-20020ad45ded000000b0042c3394cafaso3965092qvb.22
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=5zsO3Fp/ELwIYD28/txcroKMAxj9kdpSixyYpBN1Xrw=;
	b=vyBrIUR5Qe9zE7kkVvwDCdWLdSrLrpJw2HKLYnMxYhmNP8umFpl6jIb1tA4VlHtT6Z
	pRYMbZ7iK1LwWPZYX6Am3R67YrecqscHH8nustNSomdAwNipjLXV0OKvt3WTW5//Le+v
	SP/kGfRRjw6ybaxFD6+vxhxHAofBlQioNb/6dItnTvdtTZPEeo6fffBmEjCMFBu/77fl
	TKjClBN8DQGKSNHsbT5dycQ9NQvOHD01X8mpbUTJjCOiMDpJJlp1/kOYv4DU3pzdo42H
	XlEo8TRjk4Sf+wnzuFgKh1K4Yiq7haYBEJDIXLVm1xpM34FUo//eZN+9JZPhMMJ5XhOb
	KiXQ==
X-Gm-Message-State: AOAM533dj1XsXxP3Wrzu1jgmW77IjrG8egDMQK2sd+aY+lf9JToDkEBT
	8TFimaIz89AC7/9r01uHy1A6Bma4AKse5XtBWeMSwt+1JRuFmgHQ16y8yUYjyPPxykQaBAeuvOp
	DG34k2vQ5oljPC1yVJyZGzf+lEeIuE4PqdjUqOI6XRpVaghjHkaj6XU0AD3sT+Dj95A==
X-Received: by 2002:ad4:5b83:: with SMTP id 3mr6625813qvp.103.1644532714237;
	Thu, 10 Feb 2022 14:38:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZUXcOQHDRnivoNe930Kbl9CSrwP87HKASyNcGBndoZSfIJ5t7gykPiUrhOnJ90EtUlhGs5A==
X-Received: by 2002:ad4:5b83:: with SMTP id 3mr6625803qvp.103.1644532713898;
	Thu, 10 Feb 2022 14:38:33 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	b10sm11641506qtb.34.2022.02.10.14.38.33
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:33 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:18 -0500
Message-Id: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 00/14] dm: improve bio-based IO accounting
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

All the changes from this patchset are available here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.18

This work is based on Jens' for-5.18/block

For the linux-block crowd, I'm spamming you purely to seek review of
the last patch in this patchset (but welcome review of the entire set
if you're willing). Given all the DM changes that precede the last
block patch I'd appreciate review so it can be merged for 5.18 via
linux-dm.git.

DM is the only consumer of the recently added bio_start_io_acct_time
that the last patch enhances and renames to bio_start_io_acct_remapped

This patchset's primary purpose is to add the dm_submit_bio_remap()
interface to improve the bio-based IO accounting for DM targets that
take ownership of bios and use their own workqueues to process/remap
and later submit the bios.

Motivation is to fix the relatively useless nature of dm-crypt's
buffered IO stats.  DM core shouldn't immediately start IO accounting
for bios that dm-crypt goes on to queue in workqueues. The IO should
only have its IO started once submitted.  Otherwise the iostats for
dm-crypt just looks like an upfront flood of IO but then offer little
indication that anything is happening.  Given dm-crypt's cpu intensive
nature it takes time to complete IO but unless you look at the
underlying devices' iostats you wouldn't see it occurring.

Mike

Mike Snitzer (14):
  dm: rename split functions
  dm: fold __clone_and_map_data_bio into __split_and_process_bio
  dm: refactor dm_split_and_process_bio a bit
  dm: reduce code duplication in __map_bio
  dm: remove impossible BUG_ON in __send_empty_flush
  dm: remove unused mapped_device argument from free_tio
  dm: remove code only needed before submit_bio recursion
  dm: record old_sector in dm_target_io before calling map function
  dm: prep for following changes
  dm: add dm_submit_bio_remap interface
  dm crypt: use dm_submit_bio_remap
  dm delay: dm_submit_bio_remap
  dm: improve correctness and efficiency of bio-based IO accounting
  block: add bio_start_io_acct_remapped for the benefit of DM

 block/blk-core.c              |  24 ++---
 drivers/md/dm-core.h          |   4 +-
 drivers/md/dm-crypt.c         |   7 +-
 drivers/md/dm-delay.c         |   3 +-
 drivers/md/dm.c               | 224 ++++++++++++++++++++++--------------------
 include/linux/blkdev.h        |  16 ++-
 include/linux/device-mapper.h |   7 ++
 7 files changed, 156 insertions(+), 129 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


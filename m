Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 786F9C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644616026;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OdwLpwJevyhTZpxucMY+7b/tLxfqI54RF1ulCNyRXQU=;
	b=OBEq5VLvBqKpgibRkvy9NEc3yzLWi6NqZMuCOSzddafS8IsnFB6hczDUE/vc21iuMilZD5
	S+dq/Q5Nut2Co2h0BQQQRrQoVbAFg8DMWiyufubWzzywtl3eRUMAxj3iFKfepOdEk9DA1Y
	hb5zH3bjpn+oJ4A4+3suqmLl41jbGXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-XVsiLV8XNj22BH0_nvgt8Q-1; Fri, 11 Feb 2022 16:47:02 -0500
X-MC-Unique: XVsiLV8XNj22BH0_nvgt8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A49F410247A7;
	Fri, 11 Feb 2022 21:46:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 878C5F6C7;
	Fri, 11 Feb 2022 21:46:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 62151180B654;
	Fri, 11 Feb 2022 21:46:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLf9Z8024687 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C08E1C2E008; Fri, 11 Feb 2022 21:41:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCDD8C07F4B
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E6D083395A
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:06 +0000 (UTC)
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
	[209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-98-JZ5uYkTDPR-vYXKZJWmRwQ-1; Fri, 11 Feb 2022 16:41:04 -0500
X-MC-Unique: JZ5uYkTDPR-vYXKZJWmRwQ-1
Received: by mail-ot1-f70.google.com with SMTP id
	j2-20020a9d7d82000000b005a12a0fb4b0so6043545otn.5
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=8b2j/hRlmeRKgxQS01vdbuNTDBEr7G47snWX3xyMZr0=;
	b=SxrlalsZ4OqlYXqNr5+IBnl5wrrmGdU+r7KTbGtHS3aFZeCUltEAaKV8+pUdzzQjss
	0bUNd3rIRBrZKp99VNBJtJOwXvuz0PGl8Y1DezSbjRn8T0705EkDJmBFZBAHHd9w8v9t
	pbeeV2jGfeIv4BDK+4Jl4Sy8S6NK4ix+SBrfGnJKtEn77Rwms7wUXkEDgkLPbf6caH/v
	HB5DAJ5zaigkSyTjunUDJam2USfl3Wg9GS8VCDTxaQNudiw4mNsgskoQn2+bHuWJLkzj
	8pBsMD+IfY76iT+0LoeqgpIg06NKdVH7ldvA6Vxe+loHyGHFnZfG2aE/I+T9Od0A/N9T
	GoJA==
X-Gm-Message-State: AOAM533V9f2f+NcRSmbSlpkYrx1k54Mpp4sOKiV57OuakbCPN4wgKnLp
	hKU8cANfG6ZKmF9JGnq9Jx2dsEH2ZmaVFqw+cgRjuqwT4UoBZ+pE5/iqnbGv+aaB5K3IMLYwUdZ
	HrW30mkJ9QkKPD9fDWRL2p7+Bp9uOnUYf0vlSnhQsX35QndH4iOj6urSaoxhQNvq1UA==
X-Received: by 2002:a05:6808:ece:: with SMTP id
	q14mr1091263oiv.174.1644615663104; 
	Fri, 11 Feb 2022 13:41:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzi7P+hhoDWQ7F6Az0Vws24qOdd5k5JsOKRbyjvj6pMufn+nzx1zyZXbHL8fuSV48Uc3NRqJQ==
X-Received: by 2002:a05:6808:ece:: with SMTP id
	q14mr1091244oiv.174.1644615662391; 
	Fri, 11 Feb 2022 13:41:02 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id 1sm9444505oab.16.2022.02.11.13.41.01
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:02 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:43 -0500
Message-Id: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 00/14] dm: improve bio-based IO accounting
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

Please see v1's 0th header for context on motivation behind this patchset:
https://listman.redhat.com/archives/dm-devel/2022-February/msg00193.html

Christoph, I addressed all your feedback from v1 and added the
Reviewed-by:s you provided. Thanks for your review.

Patch 10 now isolates the block changes like you asked.

All further review of this v2 patchset is welcomed.

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
  dm: move kicking of suspend queue to dm_io_dec_pending
  block: add bio_start_io_acct_remapped for the benefit of DM
  dm: add dm_submit_bio_remap interface
  dm crypt: use dm_submit_bio_remap
  dm delay: use dm_submit_bio_remap
  dm: move duplicate code in callers of alloc_tio into alloc_tio

 block/blk-core.c              |  24 ++---
 drivers/md/dm-core.h          |   2 +
 drivers/md/dm-crypt.c         |   9 +-
 drivers/md/dm-delay.c         |   5 +-
 drivers/md/dm.c               | 234 ++++++++++++++++++++++--------------------
 include/linux/blkdev.h        |  16 ++-
 include/linux/device-mapper.h |   7 ++
 include/uapi/linux/dm-ioctl.h |   4 +-
 8 files changed, 164 insertions(+), 137 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


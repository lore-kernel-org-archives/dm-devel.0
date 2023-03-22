Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77900C76195
	for <dm-devel@archiver.kernel.org>; Wed, 22 Mar 2023 18:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679509181;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hHN87MBX5fxv5tAOmSSNkehj5XlpSGXOYPC2nb8+DJc=;
	b=cIHjC5YOuHMAqaC2CJtmCAMls+fKTPKpTZBWNkRewS5cJPWF2iRAGs33JnnJwAPElZHX1/
	B2nrTT3i5Y7rWFLitbJanQDpwuFpisdoDZ/R0Ll+Lt47PZVPO4Lhaw1rWiarb8OU8cY6V4
	e4uBgquJJ4SgP5Qkr4uyLU53E6m6Lso=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-9EUIIIcePpS5fFUoTC-R5w-1; Wed, 22 Mar 2023 14:19:38 -0400
X-MC-Unique: 9EUIIIcePpS5fFUoTC-R5w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE3CA38123D4;
	Wed, 22 Mar 2023 18:19:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE87D140EBF4;
	Wed, 22 Mar 2023 18:19:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9EF041946589;
	Wed, 22 Mar 2023 18:19:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A11DC1946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Mar 2023 18:19:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 723C2C15BAD; Wed, 22 Mar 2023 18:19:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ABDAC15BA0
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E48F85A588
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:24 +0000 (UTC)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com
 [209.85.160.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-aRkMZw8mPRqAdai55nKnxw-1; Wed, 22 Mar 2023 14:19:22 -0400
X-MC-Unique: aRkMZw8mPRqAdai55nKnxw-1
Received: by mail-qt1-f171.google.com with SMTP id c10so12598157qtj.10
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 11:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679509162;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=GxX1DbkSPMmy5XvUXbn11CfWANSB/DylDpLKxqpt8B0=;
 b=rLhW/Tc0MUB9Gd3ofxKrF4UYW0kLJZ8VuZ0R2UBka+fMiKddd/CVstFKhPqK02nE97
 MjUUWnW1esZnRc9QqLxXBzFUcWyvmG+g1Ja2PjEufsMfcvUKc+K/YO1yYBC7OKn/ld9k
 Nv8ZN8+BN7GxvOHoBVG9icQJ7VUApMWUon8InOHInbZIetsHp3DWwTMoV1VoLQpUQv0/
 7BG0/U5HdN9tVPkzRl1IT1op9QQOzLaQRZu5cxX3U2/PNYtbUH0KkMViOfdrL3EIyrVi
 n/ORiMG8PK10uv0bksFYtfovnwvjmG7+EwwdxrCOIbihQ++/6pPJHl9SwkPFueVoZqkB
 IG/w==
X-Gm-Message-State: AO0yUKUQiUlX9nKTohu48KXtAipS2c5UAMl6r0xZeu9QE8yd4xSPm8I6
 AOxGHBQrBaRUR6ZyRdeVzYxRLBl1An3zvYsbRsSz8HrYKPBFGSe+GkbyB/o59NeULbCevXyWYsH
 IVQMGroFgaeFXi/J88GFPYwgr8/1Vko7oLj8oBgmqE4S6Ci79tLGQ40GXZZbkpLz065Z6C/28AX
 g=
X-Google-Smtp-Source: AK7set+ykFo6eRPgJx3uuXumPI9Fnv6xNlMEqb+KzXjKxvEsZNZqgt1hGQfWHJpMf2s2GqoORIXlPQ==
X-Received: by 2002:a05:622a:242:b0:3bf:da83:f8d6 with SMTP id
 c2-20020a05622a024200b003bfda83f8d6mr7550384qtx.28.1679509161811; 
 Wed, 22 Mar 2023 11:19:21 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 j9-20020a05620a288900b0070648cf78bdsm11666072qkp.54.2023.03.22.11.19.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Mar 2023 11:19:21 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Wed, 22 Mar 2023 14:18:37 -0400
Message-Id: <20230322181845.29848-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [dm-6.4 PATCH 0/8] dm bufio,
 thin: improve concurrent IO performance
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
Cc: keescook@chromium.org, heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 nhuck@google.com, ebiggers@kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This patchset has been staged in linux-next for the 6.4 merge
window. As detailed in the "Testing" section of the header for patch
5: these changes have been extensively tested in terms of dm-thin (and
dm-cache as much as device-mapper-test-suite provides).

But further testing from other more exotic DM bufio consumers is
needed (e.g. dm-verity and dm-integrity developers/consumers who are
Cc'd).

Please use whatever tests you have to put pressure on bufio.
In particular: focused testing of bufio's shrinker, verify
DM_BUFIO_CLIENT_NO_SLEEP (via dm-verity's tasklets), etc.

There is still time to add fixes for 6.4 should any issues turn
up.

All review is welcome (I'll rebase to include Reviewed-by or Acked-by
tags). Also, positive reports in the form of Tested-by replies (to
patch 5) are also welcome!

Thanks,
Mike

Joe Thornber (4):
  dm bio prison v1: improve concurrent IO performance
  dm bufio: remove unused dm_bufio_release_move interface
  dm bufio: improve concurrent IO performance
  dm thin: speed up cell_defer_no_holder()

Mike Snitzer (4):
  dm: split discards further if target sets max_discard_granularity
  dm bufio: move dm_buffer struct
  dm bufio: move dm_bufio_client members to avoid spanning cachelines
  dm bufio: rename buffer_cache struct to dm_buffer_cache

 drivers/md/dm-bio-prison-v1.c |   87 +-
 drivers/md/dm-bio-prison-v1.h |   10 +
 drivers/md/dm-bufio.c         | 1939 +++++++++++++++++++++++----------
 drivers/md/dm-thin.c          |   23 +-
 drivers/md/dm.c               |   54 +-
 include/linux/device-mapper.h |    6 +
 include/linux/dm-bufio.h      |    6 -
 include/uapi/linux/dm-ioctl.h |    4 +-
 8 files changed, 1458 insertions(+), 671 deletions(-)

-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


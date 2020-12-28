Return-Path: <SRS0=GVWR=GA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAD0C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 28 Dec 2020 21:28:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AB9612073C
	for <dm-devel@archiver.kernel.org>; Mon, 28 Dec 2020 21:28:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB9612073C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609190892;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SLUgO+fLSWP8C4LiZmdz37BcosSl38uGIJgcg529h2s=;
	b=NaWCttP6xE8qiYD+bOQJWyRY6tFb8r8NYfylTLlX1SZZFmCCBEOObusUfvKFGP3UB22o1q
	gNeadi+RO/cLqiANoHoVwUItB/c08SsxCHK5jhh2998XPLw+dvJDunLhJDEKPO4e5PnLJe
	IlADJPktXD7DP/CvX9zHdCIV5KwliYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-hCsp0iFHM4qcT2WCSXcmdQ-1; Mon, 28 Dec 2020 16:28:10 -0500
X-MC-Unique: hCsp0iFHM4qcT2WCSXcmdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CECE11005513;
	Mon, 28 Dec 2020 21:28:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D12319744;
	Mon, 28 Dec 2020 21:28:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 357CB180954D;
	Mon, 28 Dec 2020 21:28:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BSLS2tB012315 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Dec 2020 16:28:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2283E60C17; Mon, 28 Dec 2020 21:28:02 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B24A360BE5;
	Mon, 28 Dec 2020 21:27:58 +0000 (UTC)
Date: Mon, 28 Dec 2020 16:27:58 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20201228212757.GA26267@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Ignat Korchagin <ignat@cloudflare.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Milan Broz <gmazyland@gmail.com>,
	Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper fix for 5.11-rc2
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit b77709237e72d6467fb27bfbad163f7221ecd648:

  dm cache: simplify the return expression of load_mapping() (2020-12-22 09:54:48 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.11/dm-fix

for you to fetch changes up to 48b0777cd93dbd800d3966b6f5c34714aad5c203:

  Revert "dm crypt: export sysfs of kcryptd workqueue" (2020-12-28 16:13:52 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
Revert WQ_SYSFS change that broke reencryption (and all other
functionality that requires reloading a dm-crypt DM table).

----------------------------------------------------------------
Mike Snitzer (1):
      Revert "dm crypt: export sysfs of kcryptd workqueue"

 drivers/md/dm-crypt.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


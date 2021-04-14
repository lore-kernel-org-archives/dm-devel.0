Return-Path: <SRS0=OBV6=JL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E571C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 14 Apr 2021 18:40:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E503961153
	for <dm-devel@archiver.kernel.org>; Wed, 14 Apr 2021 18:40:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E503961153
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618425640;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n9JJy+hJ2vZy3F3LEThZ+Iu3RTPt4JIekmYNYkFgeQw=;
	b=ZIGbjasO4SeAf0iEm4pvCDzbLsX/+bWHmQDNa8JRURA2cboLoSii5NhBmVoJvhF/m0NlH0
	DkgrS79l+EluguOOZJruJa4mgqjptYGj2Z9M2l1JhdEZYnkdsUhh4+c0FM6Y+woxeH9FG9
	Ib8fFiWXJFfW8p3G7e9zcvg14xl2loQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-ypaCcDABPl-NWTRyssWUyg-1; Wed, 14 Apr 2021 14:40:38 -0400
X-MC-Unique: ypaCcDABPl-NWTRyssWUyg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D19AB814256;
	Wed, 14 Apr 2021 18:40:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1103318A77;
	Wed, 14 Apr 2021 18:40:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 82DCC44A5B;
	Wed, 14 Apr 2021 18:40:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13EIe8du004125 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 14 Apr 2021 14:40:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4DE0C5DEAD; Wed, 14 Apr 2021 18:40:08 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F3415D9DE;
	Wed, 14 Apr 2021 18:40:08 +0000 (UTC)
Date: Wed, 14 Apr 2021 14:40:07 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20210414184007.GA8824@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jaegeuk Kim <jaegeuk@google.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper fix for 5.12 final
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit d434405aaab7d0ebc516b68a8fc4100922d7f5ef:

  Linux 5.12-rc7 (2021-04-11 15:16:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.12/dm-fixes-3

for you to fetch changes up to 8ca7cab82bda4eb0b8064befeeeaa38106cac637:

  dm verity fec: fix misaligned RS roots IO (2021-04-14 14:28:29 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Fix DM verity target FEC support's RS roots IO to always be
aligned. This fixes a previous stable@ fix that overcorrected for a
different configuration that also resulted in misaligned roots IO.

----------------------------------------------------------------
Jaegeuk Kim (1):
      dm verity fec: fix misaligned RS roots IO

 drivers/md/dm-verity-fec.c | 11 ++++++++---
 drivers/md/dm-verity-fec.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


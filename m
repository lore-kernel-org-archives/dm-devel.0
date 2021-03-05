Return-Path: <SRS0=vJVk=ID=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24284C433DB
	for <dm-devel@archiver.kernel.org>; Fri,  5 Mar 2021 19:27:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A42B165074
	for <dm-devel@archiver.kernel.org>; Fri,  5 Mar 2021 19:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A42B165074
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614972419;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QTFIkoxfe8IXfW06Xt9FmNwtAhzdBjQo/eIRtNknuIc=;
	b=EAAiOxbVq2UeWJhanFFEWCun4wes/O1Fkv1B/pzNaRPm/esUgEU/5wYUJvBNp5ndWN5+sT
	J9EWFcH4bK9ngBlfPWV2INJcLNozIN1SW+qBLWeF5smT0qbyfSpp7o6Z9OxZvJFUUGNpRa
	lxKPbVah1XIeti4hQdrZ0KeyciuY2kU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-mq5npGhWPAGsiXMVp5atLA-1; Fri, 05 Mar 2021 14:26:57 -0500
X-MC-Unique: mq5npGhWPAGsiXMVp5atLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75FA4800D53;
	Fri,  5 Mar 2021 19:26:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4FB15D6DC;
	Fri,  5 Mar 2021 19:26:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A27C81809C86;
	Fri,  5 Mar 2021 19:26:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 125JQkoQ003540 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Mar 2021 14:26:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 67DAB18AD6; Fri,  5 Mar 2021 19:26:46 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C89D1349A;
	Fri,  5 Mar 2021 19:26:43 +0000 (UTC)
Date: Fri, 5 Mar 2021 14:26:42 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20210305192641.GA21876@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>,
	Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper fixes for 5.12-rc2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit a666e5c05e7c4aaabb2c5d58117b0946803d03d2:

  dm: fix deadlock when swapping to encrypted device (2021-02-11 09:45:28 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.12/dm-fixes

for you to fetch changes up to df7b59ba9245c4a3115ebaa905e3e5719a3810da:

  dm verity: fix FEC for RS roots unaligned to block size (2021-03-04 15:08:18 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
Fix DM verity target's optional Forward Error Correction (FEC) for
Reed-Solomon roots that are unaligned to block size.

----------------------------------------------------------------
Mikulas Patocka (1):
      dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size

Milan Broz (1):
      dm verity: fix FEC for RS roots unaligned to block size

 drivers/md/dm-bufio.c      |  4 ++++
 drivers/md/dm-verity-fec.c | 23 ++++++++++++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


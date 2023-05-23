Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E52C7EE26
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 08:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684832393;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0VNYVG/hAKNR14C44+rF7eDUYtomNKwMWD7hPlKGIWQ=;
	b=f0N79RnsG0fi+aeuot++dwOr3dZceFFCuqctqUoc5IAFZKiiE1CX2dPL8xmDM6yIabmbeQ
	g8Ib4WNBXPl4kFv2u0kexMEeZIpWOdpxFMR0dDw59yW7WJ+WEMd0WY00kDvrThHP2HyVpr
	ummKKKBgUa5ipzvYZAu/f52fiIJQptE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-X7cljiJSOOyxVzc21wAIkA-1; Tue, 23 May 2023 04:59:50 -0400
X-MC-Unique: X7cljiJSOOyxVzc21wAIkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 147803802607;
	Tue, 23 May 2023 08:59:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0367E7AF5;
	Tue, 23 May 2023 08:59:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BDC7C19465A0;
	Tue, 23 May 2023 08:59:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D0B971946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 08:59:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AE9D02166B26; Tue, 23 May 2023 08:59:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5E872166B25
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:59:47 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89287811E7C
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:59:47 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-kfxsoY1FN_W9CVhvpc8UOA-1; Tue, 23 May 2023 04:59:46 -0400
X-MC-Unique: kfxsoY1FN_W9CVhvpc8UOA-1
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q1Mi9-009GTZ-27; Tue, 23 May 2023 07:45:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 May 2023 09:45:11 +0200
Message-Id: <20230523074535.249802-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] fix the name_to_dev_t mess
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

this series tries to sort out accumulated mess around the name_to_dev_t
function.  This function is intended to allow looking up the dev_t of a
block device based on a name string before the root file systems is
mounted and thus the normal path based lookup is available.

Unfortunately a few years ago it managed to get exported and used in
non-init contexts, leading to the something looking like a path name
also beeing lookuped up by a different and potential dangerous
algorithm.

This series does a fair amount of refactoring and finally ends up with
the renamed and improved name_to_dev_t only beeing available for the
early init code again.

The series is against Jens' for-6.5/block tree but probably applies
against current mainline just fine as well.

A git tree is also available here:

    git://git.infradead.org/users/hch/block.git blk-init-cleanup

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/blk-init-cleanup

Diffstat:
 Documentation/admin-guide/kernel-parameters.txt |    2 
 arch/alpha/kernel/setup.c                       |    2 
 arch/ia64/kernel/setup.c                        |    2 
 arch/powerpc/platforms/powermac/setup.c         |    3 
 block/Makefile                                  |    2 
 block/early-lookup.c                            |  315 ++++++++++++++++++
 block/genhd.c                                   |   92 -----
 drivers/base/dd.c                               |    6 
 drivers/md/dm-init.c                            |    4 
 drivers/md/dm-snap.c                            |   14 
 drivers/md/dm-table.c                           |   26 -
 drivers/md/md-autodetect.c                      |    3 
 drivers/mtd/devices/block2mtd.c                 |   62 ++-
 fs/pstore/blk.c                                 |    4 
 include/linux/blkdev.h                          |    6 
 include/linux/device-mapper.h                   |    2 
 include/linux/device/driver.h                   |    2 
 include/linux/mount.h                           |    1 
 include/linux/root_dev.h                        |    9 
 init/do_mounts.c                                |  416 ++++++------------------
 init/do_mounts.h                                |   14 
 init/do_mounts_initrd.c                         |   11 
 kernel/power/hibernate.c                        |  167 +++++----
 kernel/power/power.h                            |    3 
 kernel/power/swap.c                             |    2 
 25 files changed, 603 insertions(+), 567 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


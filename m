Return-Path: <SRS0=Ey+N=GS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9E4C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 23:44:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0B82E23A6C
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 23:44:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B82E23A6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610754245;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ESkjsP//OqAc6AUHoMcJodnY4g8CelZIkZYUkqZnISA=;
	b=aOAVUzshaOnAG6kCSbdZkeGr5O6pPd+mQxmLXxLQ7XaZRdusA00ltkloD2EHld8n1WxP7R
	QsstrOcKx0OjPQwchHsIcKLvgPEFVL/qERnCt+qjzKtfYel4KDbaSaWnMoU/XsoOFBmiIN
	Tf4ER/8SXMbRAtfmGRwEYTWLXXLB98k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-PkDQN8u_MGmQ9bSBlMfotg-1; Fri, 15 Jan 2021 18:44:03 -0500
X-MC-Unique: PkDQN8u_MGmQ9bSBlMfotg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01013107ACF8;
	Fri, 15 Jan 2021 23:43:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDEC910016FE;
	Fri, 15 Jan 2021 23:43:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F2F2A4BB7B;
	Fri, 15 Jan 2021 23:43:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10FNhp6X012734 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Jan 2021 18:43:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B32F660C6F; Fri, 15 Jan 2021 23:43:51 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 794DF60BF3;
	Fri, 15 Jan 2021 23:43:48 +0000 (UTC)
Date: Fri, 15 Jan 2021 18:43:47 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20210115234347.GA1931@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Arnd Bergmann <arnd@arndb.de>, Anthony Iliopoulos <ailiop@suse.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Akilesh Kailash <akailash@google.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper fixes for 5.11-rc4
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit e71ba9452f0b5b2e8dc8aa5445198cd9214a6a62:

  Linux 5.11-rc2 (2021-01-03 15:55:30 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.11/dm-fixes-1

for you to fetch changes up to c87a95dc28b1431c7e77e2c0c983cf37698089d2:

  dm crypt: defer decryption to a tasklet if interrupts disabled
  (2021-01-14 09:54:37 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM-raid's raid1 discard limits so discards work.

- Select missing Kconfig dependencies for DM integrity and zoned
  targets.

- 4 fixes for DM crypt target's support to optionally bypass
  kcryptd workqueues.

- Fix DM snapshot merge supports missing data flushes before
  committing metadata.

- Fix DM integrity data device flushing when external metadata is
  used.

- Fix DM integrity's maximum number of supported constructor arguments
  that user can request when creating an integrity device.

- Eliminate DM core ioctl logging noise when an ioctl is issued
  without required CAP_SYS_RAWIO permission.

----------------------------------------------------------------
Akilesh Kailash (1):
      dm snapshot: flush merged data before committing metadata

Anthony Iliopoulos (1):
      dm integrity: select CRYPTO_SKCIPHER

Arnd Bergmann (1):
      dm zoned: select CONFIG_CRC32

Ignat Korchagin (4):
      dm crypt: do not wait for backlogged crypto request completion in softirq
      dm crypt: use GFP_ATOMIC when allocating crypto requests from softirq
      dm crypt: do not call bio_endio() from the dm-crypt tasklet
      dm crypt: defer decryption to a tasklet if interrupts disabled

Mike Snitzer (2):
      dm raid: fix discard limits for raid1
      dm: eliminate potential source of excessive kernel log noise

Mikulas Patocka (2):
      dm integrity: fix flush with external metadata device
      dm integrity: fix the maximum number of arguments

 drivers/md/Kconfig        |   2 +
 drivers/md/dm-bufio.c     |   6 ++
 drivers/md/dm-crypt.c     | 170 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/dm-integrity.c |  62 +++++++++++++----
 drivers/md/dm-raid.c      |   6 +-
 drivers/md/dm-snap.c      |  24 +++++++
 drivers/md/dm.c           |   2 +-
 include/linux/dm-bufio.h  |   1 +
 8 files changed, 239 insertions(+), 34 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


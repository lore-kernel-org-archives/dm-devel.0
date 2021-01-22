Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073B0C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 22:25:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9203223A5C
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 22:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9203223A5C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611354306;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6bZcyCka9444o2B0IiF/oeYwmsFrouAn+FMmdm22fWI=;
	b=clvWUGn8jG3XqxKvKKVyQDB8BzasPsnM/cfn0c+gxfSeCZOzGFcYkmr5tRlcJtt1bCano+
	eRNF+UIgmT6jxNi+sLxPNlabIxcqFrsGc1bqbXI0bcijNNXmfghz6U7/LdvcoAVEwV0ZZ6
	l13jhHZ4lmiXrkTfkbIbpsiyQk5MlwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-P2hu6D6tP5Otw3TCK2E8DQ-1; Fri, 22 Jan 2021 17:25:01 -0500
X-MC-Unique: P2hu6D6tP5Otw3TCK2E8DQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FA5E180A095;
	Fri, 22 Jan 2021 22:24:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED4E85DA30;
	Fri, 22 Jan 2021 22:24:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 69651180954D;
	Fri, 22 Jan 2021 22:24:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10MMOnhD014532 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 17:24:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 529F81992D; Fri, 22 Jan 2021 22:24:49 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 486A719C71;
	Fri, 22 Jan 2021 22:24:46 +0000 (UTC)
Date: Fri, 22 Jan 2021 17:24:45 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20210122222445.GA14822@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper fixes for 5.11-rc5
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 19c329f6808995b142b3966301f217c831e7cf31:

  Linux 5.11-rc4 (2021-01-17 16:37:05 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.11/dm-fixes-2

for you to fetch changes up to 809b1e4945774c9ec5619a8f4e2189b7b3833c0c:

  dm: avoid filesystem lookup in dm_get_dev_t() (2021-01-21 15:06:45 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM integrity crash if "recalculate" used without "internal_hash"

- Fix DM integrity "recalculate" support to prevent recalculating
  checksums if we use internal_hash or journal_hash with a key
  (e.g. HMAC). Use of crypto as a means to prevent malicious
  corruption requires further changes and was never a design goal for
  dm-integrity's primary usecase of detecting accidental corruption.

- Fix a benign dm-crypt copy-and-paste bug introduced as part of a
  fix that was merged for 5.11-rc4.

- Fix DM core's dm_get_device() to avoid filesystem lookup to get
  block device (if possible).

----------------------------------------------------------------
Hannes Reinecke (1):
      dm: avoid filesystem lookup in dm_get_dev_t()

Ignat Korchagin (1):
      dm crypt: fix copy and paste bug in crypt_alloc_req_aead

Mikulas Patocka (2):
      dm integrity: fix a crash if "recalculate" used without "internal_hash"
      dm integrity: conditionally disable "recalculate" feature

 .../admin-guide/device-mapper/dm-integrity.rst     | 12 ++++++--
 drivers/md/dm-crypt.c                              |  6 ++--
 drivers/md/dm-integrity.c                          | 32 ++++++++++++++++++++--
 drivers/md/dm-table.c                              | 15 ++++++++--
 4 files changed, 54 insertions(+), 11 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


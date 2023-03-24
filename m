Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD70CC6FD1C
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 17:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679678514;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=O1Hm+bW+xgy+9fQUzM43avxc3Ygyw01P0LcRvsLQ2dI=;
	b=E7YHMrIExDhZ9jTAS2qrkGZaTZQ58CekXLhKnjxzkdmdvc/7IOuKZ7l9lAnQ/v/nb1YUUv
	Ac9bB0HZrf/seiSfGnH+tPGWfqpbRFk65HAkmOqxcEaKYFcXbdl0+AY9F97HrH7snsaQW4
	FiUad4zbdaMHfbhnQaQPfxQC54GKP+c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-mA7vqHcSMxuXqq4gvpnZ1Q-1; Fri, 24 Mar 2023 13:21:51 -0400
X-MC-Unique: mA7vqHcSMxuXqq4gvpnZ1Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7ADF32812958;
	Fri, 24 Mar 2023 17:21:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1BC2C40C6E67;
	Fri, 24 Mar 2023 17:21:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC7C81946A5E;
	Fri, 24 Mar 2023 17:21:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 922DF1946A5A
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 17:21:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 347D02166B2B; Fri, 24 Mar 2023 17:21:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D1D42166B29
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:21:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E673101A551
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:21:46 +0000 (UTC)
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com
 [209.85.219.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-Afo3oxfiMcidFbZQ_tAIiA-1; Fri, 24 Mar 2023 13:21:44 -0400
X-MC-Unique: Afo3oxfiMcidFbZQ_tAIiA-1
Received: by mail-qv1-f43.google.com with SMTP id q88so1976943qvq.13
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 10:21:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679678504;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Kwnm6koRyZsuVSW+Az3H6XqTn7kU9JKm0T+d6j/RM48=;
 b=m3lMjfOJusuMxjKkb0vqPOiY/8F4vkPnE4m/UcqH9bNkp9uJ7re32cvu95wmV9YRPb
 ZSddSnnTMhUe3gSQEvzh547r6hNGKCSZ8VQuu9YDeWkCoaKx6tobb3SASxYOQhybp93l
 fAf5XM2EqJSc3zE1fNfkz219TEnqhkcizxY0egNRXvicbIsmKtjlAI4Y43tCxybtYA1O
 q0y0cggrmQ9fl6ZAMzVNVIeGiBF8QRNsLGJ0xlGAQAZAZAe6mm32ampNDlKc7bTOpfim
 LFyd6bFl5f8Q7OMgSl5eONveBwA1BZHVZtVbm3QXjnwWbocJb57Hr2GOtBRtIlr4WJwK
 PWOw==
X-Gm-Message-State: AAQBX9dUiJE1zbo8b+LNjkJbYTWOsahbuJeSvA537l6biaEn3mhoOGSO
 h/ethDramFJml2jA+oJsrhJUWCw=
X-Google-Smtp-Source: AKy350ZPBR6gKJIpdo1yhww1E6SmBvJu6FU7dEkIGsTFs9iPPnfWzl1le1BYrU4Non3FKStr6ndGwA==
X-Received: by 2002:a05:6214:2622:b0:5a9:129:c704 with SMTP id
 gv2-20020a056214262200b005a90129c704mr6090931qvb.9.1679678503837; 
 Fri, 24 Mar 2023 10:21:43 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 g11-20020ad457ab000000b005dd8b9345c2sm833945qvx.90.2023.03.24.10.21.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 10:21:43 -0700 (PDT)
Date: Fri, 24 Mar 2023 13:21:42 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <ZB3cJuV78aKnnWrO@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [git pull] device mapper fixes for 6.3-rc4
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
Cc: Jiasheng Jiang <jiasheng@iscas.ac.cn>, Mike Snitzer <snitzer@kernel.org>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit d695e44157c8da8d298295d1905428fb2495bc8b:

  dm: remove unnecessary (void*) conversion in event_callback() (2023-02-20 11:52:49 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.3/dm-fixes

for you to fetch changes up to d3aa3e060c4a80827eb801fc448debc9daa7c46b:

  dm stats: check for and propagate alloc_percpu failure (2023-03-16 13:37:06 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM thin to work as a swap device by using 'limit_swap_bios' DM
  target flag (initially added to allow swap to dm-crypt) to throttle
  the amount of outstanding swap bios.

- Fix DM crypt soft lockup warnings by calling cond_resched() from the
  cpu intensive loop in dmcrypt_write().

- Fix DM crypt to not access an uninitialized tasklet. This fix allows
  for consistent handling of IO completion, by _not_ needlessly punting
  to a workqueue when tasklets are not needed.

- Fix DM core's alloc_dev() initialization for DM stats to check for
  and propagate alloc_percpu() failure.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmQd2p0ACgkQxSPxCi2d
A1qvXAf/WCMNXRbFhO35QqukBqS7sUOMfWl1hIEdABRu+3Ul1KHBWzXVYWuWgebw
kr79V3LZG63cLvhreCy64X/0tXLZa0c0AGWZI6rJ/QAozSCs9R8BqOrJnB5GT1o9
/lvmOL31MloMnIKArWseIQViNM97gEHmFpuj0saqitcvNTjjipzxq/wOyhmDQwnE
8rxJpKSHBJXs9X/VyM9FTWxtijTQw3c8wxJJo7eV6TTuLyrErm46tyI1cBQ4vDoa
ogMVWVrf51uTsqL6DqGenDc+kO7CH5lipIJij1bTtKgs3aBNlaiZQC1nPkMST9Ue
hpH61ixAg+bsWi4/xLFafCl6QAGMlA==
=71ya
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Coly Li (1):
      dm thin: fix deadlock when swapping to thin device

Jiasheng Jiang (1):
      dm stats: check for and propagate alloc_percpu failure

Mike Snitzer (1):
      dm crypt: avoid accessing uninitialized tasklet

Mikulas Patocka (1):
      dm crypt: add cond_resched() to dmcrypt_write()

 drivers/md/dm-crypt.c | 16 ++++++++++------
 drivers/md/dm-stats.c |  7 ++++++-
 drivers/md/dm-stats.h |  2 +-
 drivers/md/dm-thin.c  |  2 ++
 drivers/md/dm.c       |  4 +++-
 5 files changed, 22 insertions(+), 9 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


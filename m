Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8BFC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 20:54:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 81CCC60EB2
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 20:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 81CCC60EB2
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1634331276;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=80XYFPMh3WbLR6AnCjWIyreUNIhdqfcI6RjOHsm4cAU=;
	b=Bn0rUKbiLCGPvXaToJ1D4mo+iJY52IfsEe/0eDHGx5anHDoXyMZQHcWmZCa+tzY5ZS28nx
	4WTG0irWpzqX8ueEs5dZUtcrF1eNZyF9MdFMGKTBDYt/eYB8EwhQ4cPm+IGyjwsJu/J4q5
	BpyFFm7RAh40s/wtNqaNgFoWJ3SPx2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-h7k7WSa0NXCt6BFgFKw5ug-1; Fri, 15 Oct 2021 16:54:33 -0400
X-MC-Unique: h7k7WSa0NXCt6BFgFKw5ug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C5FD80363C;
	Fri, 15 Oct 2021 20:54:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB3246060F;
	Fri, 15 Oct 2021 20:54:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 27D254A704;
	Fri, 15 Oct 2021 20:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FKowwv000909 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 16:50:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E952B40CFD11; Fri, 15 Oct 2021 20:50:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E49EE40CFD0D
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 20:50:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB2298007B1
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 20:50:57 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-264-yKoi9sAKM0qxIF3VX5SwHQ-1; Fri, 15 Oct 2021 16:50:56 -0400
X-MC-Unique: yKoi9sAKM0qxIF3VX5SwHQ-1
Received: by mail-qt1-f197.google.com with SMTP id
	q2-20020a05622a030200b002a7adb98bbfso2107681qtw.14
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 13:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
	:content-disposition;
	bh=Y+K55f8Q7QWzfWU0hxK25q9E+I8hW/Nq+N/9r8pMH98=;
	b=HbM4UnN9wnJ8xy3IvnStcltsnbfpHuQ7wldD6eyw0vc0nTFPwY+ufz9yl2g+oa6ijd
	eYTSD2sxwoKxohlDkqBaLRLpYF9xM81xzO+yDq+We2f3Asyu+oFWsupEwEVSurvlRJu6
	thdk9wqzdDzpSGMuQlZpUtI8sFQs6ZGBeB5GZ6ca+PlUJ2iwgRKzP0iRYs/piufEHnfP
	b8OuQzwRlFHJG7hKpD0us9vr8xVwd3sVRDJUq8D8fSaeSMGDbg6/KuaQSfUqryfhVvH6
	UHLUvgPVvnBEOCwa8rlc+JxS0UN8yOWnHReDR9xOzmKwadINIJ+JcjuL93TpMEda115x
	OrjA==
X-Gm-Message-State: AOAM533NSM6JeJw/CmwBkTndiAl06JCI6hHOfeBhlKo1Lscev1qiFRnW
	pG6x/Fs9OPaOlHr4vba0iWGEFNsKyRKxpmiq3SYgZW8HjY28hlI80sCJ6JCWhgQ76a8ZrQBQZc0
	tsEkQEEXjQro9lw==
X-Received: by 2002:a37:bec4:: with SMTP id
	o187mr11966128qkf.383.1634331055938; 
	Fri, 15 Oct 2021 13:50:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJdkD9RTr5OEPVNgYJkkIUrpO2zmJv8r1bXuHIYIFeuCPnq4PDQ0OKIgZ7UZewuuu8PQjGcA==
X-Received: by 2002:a37:bec4:: with SMTP id
	o187mr11966116qkf.383.1634331055746; 
	Fri, 15 Oct 2021 13:50:55 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	m14sm3111893qtq.74.2021.10.15.13.50.55
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 13:50:55 -0700 (PDT)
Date: Fri, 15 Oct 2021 16:50:54 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YWnprivVeSQHkRxN@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Colin Ian King <colin.king@canonical.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jiazi Li <jqqlijiazi@gmail.com>,
	Akilesh Kailash <akailash@google.com>, Ming Lei <ming.lei@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper fixes for 5.15-rc6
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 64570fbc14f8d7cb3fe3995f20e26bc25ce4b2cc:

  Linux 5.15-rc5 (2021-10-10 17:01:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.15/dm-fixes

for you to fetch changes up to d208b89401e073de986dc891037c5a668f5d5d95:

  dm: fix mempool NULL pointer race when completing IO (2021-10-12 13:54:10 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM verity target to skip redundant processing on I/O errors.

- Fix request-based DM so that it doesn't queue request to blk-mq
  when DM device is suspended.

- Fix DM core mempool NULL pointer race when completing IO.

- Make DM clone target's 'descs' array static.

----------------------------------------------------------------
Akilesh Kailash (1):
      dm verity: skip redundant verity_handle_err() on I/O errors

Colin Ian King (1):
      dm clone: make array 'descs' static

Jiazi Li (1):
      dm: fix mempool NULL pointer race when completing IO

Ming Lei (1):
      dm rq: don't queue request to blk-mq during DM suspend

 drivers/md/dm-clone-target.c  |  2 +-
 drivers/md/dm-rq.c            |  8 ++++++++
 drivers/md/dm-verity-target.c | 15 ++++++++++++---
 drivers/md/dm.c               | 17 ++++++++++-------
 4 files changed, 31 insertions(+), 11 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


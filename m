Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98511C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 24 Jun 2022 03:22:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-ST_TuVifPzuNEdUBsNflkg-1; Thu, 23 Jun 2022 23:22:25 -0400
X-MC-Unique: ST_TuVifPzuNEdUBsNflkg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D35393C0CD57;
	Fri, 24 Jun 2022 03:22:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1C09815B;
	Fri, 24 Jun 2022 03:22:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5AC58194B95E;
	Fri, 24 Jun 2022 03:22:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 196221947065
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Jun 2022 03:22:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DF9A240E80E0; Fri, 24 Jun 2022 03:22:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DB4D640E80E1
 for <dm-devel@redhat.com>; Fri, 24 Jun 2022 03:22:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0B11811E80
 for <dm-devel@redhat.com>; Fri, 24 Jun 2022 03:22:21 +0000 (UTC)
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com
 [209.85.219.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-1KJqko7DPnis8mCBslVLTQ-1; Thu, 23 Jun 2022 23:22:17 -0400
X-MC-Unique: 1KJqko7DPnis8mCBslVLTQ-1
Received: by mail-qv1-f52.google.com with SMTP id i17so2835929qvo.13
 for <dm-devel@redhat.com>; Thu, 23 Jun 2022 20:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=nog/N1Tt1ilQPRIuhQxXtOK39ivjIhmHL+Bl4v+3mIQ=;
 b=ONA0dTAR/anaJQz2P6sX7/SQDHToGPnDNc7Y1EkeOW/ZaBvM9NYLuimiqDi/7WT1oK
 PLXm9uiRv4r7MKufHxijwhDd83MiY6uLPl/43kuftbbJGklZcf1UenpYSR6UYpcKiDW0
 mMDF++lG6xEuGcmKD3dFRgnv2hqCkA8DwQ/l8bjxdywHx0T1dveoAL9OJEFdmitaju4O
 PglWcOx/b7+0pOK1luhfawEtrVpMNd4FDTX1XyfOOPnSA/9SM8Oy8ZHIEfiJdKSJuVZE
 1yv159gFTEKpTUQEnOWpsnKMBvWg/N6111Ct06PSaMK4UVVwENT1XpUQ10t0bUA+QZcc
 zMWg==
X-Gm-Message-State: AJIora+L3QbaAboPcB4CgV77myLcwbJKVEv5Flq0jxGKgYxEoY1blgK3
 KnAnUVK7tmbuq3Hk6M5X/NoIYfU=
X-Google-Smtp-Source: AGRyM1tkHW0wE62UC0PoNkwESXmY+aMzJTLD+4A2/3Rw4gPzEspCelrkZGeZgcpali0vKtyT22BTrw==
X-Received: by 2002:a05:622a:118b:b0:305:bc2:c7c9 with SMTP id
 m11-20020a05622a118b00b003050bc2c7c9mr11356378qtk.61.1656040937303; 
 Thu, 23 Jun 2022 20:22:17 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 z16-20020ac84550000000b003052599371fsm678363qtn.12.2022.06.23.20.22.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Jun 2022 20:22:16 -0700 (PDT)
Date: Thu, 23 Jun 2022 23:22:16 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <CAH6w=awrSaC5zmPEwR95mr02wtU5ti4qjXa-DiwpVe6XmzzcLQ@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [git pull] device mapper fixes for 5.19-rc4
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
Cc: Nikos Tsironis <ntsironis@arrikto.com>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit a111daf0c53ae91e71fd2bfe7497862d14132e3e:

  Linux 5.19-rc3 (2022-06-19 15:06:47 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.19/dm-fixes-4

for you to fetch changes up to 90736eb3232d208ee048493f371075e4272e0944:

  dm mirror log: clear log bits up to BITS_PER_LONG boundary (2022-06-23 14:55:43 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM era to commit metadata during suspend using drain_workqueue
  instead of flush_workqueue.

- Fix DM core's dm_io_complete to not return early if io error is
  BLK_STS_AGAIN but bio polling is not in use.

- Fix DM core's dm_io_complete BLK_STS_DM_REQUEUE handling when dm_io
  represents a split bio.

- Fix recent DM mirror log regression by clearing bits up to
  BITS_PER_LONG boundary.

----------------------------------------------------------------
Mike Snitzer (1):
      dm: do not return early from dm_io_complete if BLK_STS_AGAIN without polling

Mikulas Patocka (1):
      dm mirror log: clear log bits up to BITS_PER_LONG boundary

Ming Lei (1):
      dm: fix BLK_STS_DM_REQUEUE handling when dm_io represents split bio

Nikos Tsironis (1):
      dm era: commit metadata in postsuspend after worker stops

 drivers/md/dm-core.h       |  1 +
 drivers/md/dm-era-target.c |  8 +++++++-
 drivers/md/dm-log.c        |  2 +-
 drivers/md/dm.c            | 15 ++++++++++-----
 4 files changed, 19 insertions(+), 7 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15091C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Apr 2022 20:44:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-ViWXPb-NNxuUUbuqUMJ16w-1; Fri, 15 Apr 2022 16:44:46 -0400
X-MC-Unique: ViWXPb-NNxuUUbuqUMJ16w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48FBD185A79C;
	Fri, 15 Apr 2022 20:44:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6ED63111E3E9;
	Fri, 15 Apr 2022 20:44:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 16DF119451F0;
	Fri, 15 Apr 2022 20:44:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 39CFB19451EF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 20:44:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 284DC2024CB8; Fri, 15 Apr 2022 20:44:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 242112024CC6
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 20:43:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AB9F1C05EA6
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 20:43:55 +0000 (UTC)
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com
 [209.85.219.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-_PwgNOZUNRaJ2VJ1TZaXYg-1; Fri, 15 Apr 2022 16:43:54 -0400
X-MC-Unique: _PwgNOZUNRaJ2VJ1TZaXYg-1
Received: by mail-qv1-f42.google.com with SMTP id e22so7128599qvf.9
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 13:43:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=dskBOhb9QspscL9XWUhdQTNZeNyaY8giFcfTVpvjXl0=;
 b=ml5mjh1rLCS6vsEX4WRfXdVsgBeYC52kZRd4jEf81yeAFqljyrQm09tXcE3V3L2RLS
 /Wr+IQXTHoKeHT/NxMilKxmzLe0iLt6kcOaxm6kOQKhwXPOuXPc25s7GwPLT2xdTCEGZ
 bBgN5H4CoFOqHWNOLsPbyY79aegCii1Xws+G6P986Uvp2/Xa7ypfhFBY1pPfjRAxFvmd
 Fndnv+hjjd0Nqcqz1f5HZhFEykomfxRGFzv/cgM/EhTnLMyFlJAHLsmzTYoCrMQMMRQl
 t1CcPuzctuUjMYHtV+bo8MVknGa9Qa13iDaOltKCKKMr2d1NfB/u5S9gD1Wi+5bVRM5A
 vJZg==
X-Gm-Message-State: AOAM532FhU/4wOFhJSm0tI0SOqNCBQ+umPspTpvAqZxwDNpzIJGe/H1U
 fHr4VnS6sHU5+j5tfroTaRHOQq8=
X-Google-Smtp-Source: ABdhPJx2mZgf+C5WY/ENtFTxQGhP2UyjJL9VrfeBaCTo88B1PevALPYO/NvrKfZRsRCQ8h9kR2d62g==
X-Received: by 2002:a05:6214:1bce:b0:441:2d37:1fd1 with SMTP id
 m14-20020a0562141bce00b004412d371fd1mr548106qvc.10.1650055433456; 
 Fri, 15 Apr 2022 13:43:53 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 k2-20020a37ba02000000b0067dc1b0104asm2850502qkf.124.2022.04.15.13.43.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Apr 2022 13:43:53 -0700 (PDT)
Date: Fri, 15 Apr 2022 16:43:52 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YlnZCHVZNRobAvPZ@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [git pull] device mapper fixes for 5.18-rc3
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
Cc: Khazhismel Kumykov <khazhy@google.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e:

  Linux 5.18-rc2 (2022-04-10 14:21:36 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.18/dm-fixes-2

for you to fetch changes up to 92b914e29af3e99589f2d2876616c0b534892ed4:

  dm: fix bio length of empty flush (2022-04-15 16:16:09 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix memory corruption in DM integrity target when tag_size is less
  than digest size.

- Fix DM multipath's historical-service-time path selector to not use
  sched_clock() and ktime_get_ns(); only use ktime_get_ns().

- Fix dm_io->orig_bio NULL pointer dereference in dm_zone_map_bio()
  due to 5.18 changes that overlooked DM zone's use of ->orig_bio

- Fix for regression that broke the use of dm_accept_partial_bio() for
  "abnormal" IO (e.g. WRITE ZEROES) that does not need duplicate bios

- Fix DM's issuing of empty flush bio so that it's size is 0.

----------------------------------------------------------------
Khazhismel Kumykov (1):
      dm mpath: only use ktime_get_ns() in historical selector

Mike Snitzer (2):
      dm zone: fix NULL pointer dereference in dm_zone_map_bio
      dm: allow dm_accept_partial_bio() for dm_io without duplicate bios

Mikulas Patocka (1):
      dm integrity: fix memory corruption when tag_size is less than digest size

Shin'ichiro Kawasaki (1):
      dm: fix bio length of empty flush

 drivers/md/dm-integrity.c                  |  7 +++--
 drivers/md/dm-ps-historical-service-time.c | 11 +++----
 drivers/md/dm-zone.c                       | 49 +++++++++++++++++-------------
 drivers/md/dm.c                            | 18 +++++------
 4 files changed, 45 insertions(+), 40 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B482C43334
	for <dm-devel@archiver.kernel.org>; Fri, 10 Jun 2022 23:02:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-ftIZaYqHMB2eOG6aHdV_rA-1; Fri, 10 Jun 2022 19:02:23 -0400
X-MC-Unique: ftIZaYqHMB2eOG6aHdV_rA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAFA394AF44;
	Fri, 10 Jun 2022 23:02:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79F2440D2827;
	Fri, 10 Jun 2022 23:02:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F6691947058;
	Fri, 10 Jun 2022 23:02:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 64B2B1947054
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Jun 2022 23:02:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D6D640CFD0A; Fri, 10 Jun 2022 23:02:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4981340CF8EF
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 23:02:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30B391C04B79
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 23:02:18 +0000 (UTC)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com
 [209.85.222.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-ZrzKL032OheDUIMQqyNTcw-1; Fri, 10 Jun 2022 19:02:16 -0400
X-MC-Unique: ZrzKL032OheDUIMQqyNTcw-1
Received: by mail-qk1-f171.google.com with SMTP id o73so273143qke.7
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 16:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=9LGrN71hGYmCGD2rOU7fZmr62+xJ1Vp6jjk3/W+3clI=;
 b=ZgjxCcqS/DRRWsdZDzqofO3wsYuQfKD4wRtDKmmFGw2Ik3Dn318XHmyLEHEWtP8IA9
 loSpuUrE5xOX+lQyLNvLeMW/067l0T4s6NgLmpNUXMIa0tT3z9zXJNobUyW2HaoElHje
 PpWswcFLotLDS24TfMIHlddNUIlhax4InMviF8gcUBmTA8xt2MdwYvutTcvYbvs2tX8b
 Kj6/cVre1tr6LUplmT8wwdiu+rPeJrMMWwR9ySxAJuMhmqVA+mY8yVBcsF56+N6oD0gC
 bQjfEd2Fqo/jssjQUsPyu5ivr679Ypus13TuV5MBVSzdqONkXjUVh2l5xPh4c1nBUn9l
 Jaeg==
X-Gm-Message-State: AOAM531fkkZDohnsDo+/wJHMBR7aiz7z/kesS3xuDED43AkVgfPj3+a1
 yiC4Y4fWn+jp62+Rm4PMi5w4zes=
X-Google-Smtp-Source: ABdhPJy9eMmKIo9FfcxP4rXP3miTML9aPzFtMs1wjmo4pmTYde2sojL+C8P77Bnn0rwBp9BsZbBlKA==
X-Received: by 2002:a05:620a:1a1b:b0:6a7:aa:d474 with SMTP id
 bk27-20020a05620a1a1b00b006a700aad474mr11216024qkb.680.1654902136194; 
 Fri, 10 Jun 2022 16:02:16 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 q12-20020a05622a030c00b00304dd83a9b1sm296245qtw.82.2022.06.10.16.02.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 10 Jun 2022 16:02:15 -0700 (PDT)
Date: Fri, 10 Jun 2022 19:02:15 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YqPNd1xK0MIqRnev@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [git pull] device mapper fixes for 5.19-rc2
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit f2906aa863381afb0015a9eb7fefad885d4e5a56:

  Linux 5.19-rc1 (2022-06-05 17:18:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.19/dm-fixes-2

for you to fetch changes up to dddf30564054796696bcd4c462b232a5beacf72c:

  dm: fix zoned locking imbalance due to needless check in clone_endio (2022-06-10 15:23:54 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM core's bioset initialization so that blk integrity pool is
  properly setup. Remove now unused bioset_init_from_src.

- Fix DM zoned hang from locking imbalance due to needless check in
  clone_endio().

----------------------------------------------------------------
Christoph Hellwig (2):
      dm: fix bio_set allocation
      block: remove bioset_init_from_src

Mike Snitzer (1):
      dm: fix zoned locking imbalance due to needless check in clone_endio

 block/bio.c           |  20 ---------
 drivers/md/dm-core.h  |  11 ++++-
 drivers/md/dm-rq.c    |   2 +-
 drivers/md/dm-table.c |  11 -----
 drivers/md/dm.c       | 110 +++++++++++++++++---------------------------------
 drivers/md/dm.h       |   2 -
 include/linux/bio.h   |   1 -
 7 files changed, 46 insertions(+), 111 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


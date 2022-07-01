Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB11C43334
	for <dm-devel@archiver.kernel.org>; Fri,  1 Jul 2022 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656692763;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=04QDD96HzVL0mLaN/yr3luDda31SNSg+NAj3+SrGEJI=;
	b=gA4YH8LgU/3CKgyyyj6rdtGaYM5ZP7HH5Lvjjd2X0QlhiVMJy7jZJvNDCbGqYW5Nm6wzCq
	g+7o5leJng3Nklo+5GkrH5nILTmLE57N2XFTo7EVB8oxkiChoOhwhkOJuvowxmt45z3Ac8
	ggoXd9lpmZUuJJJy2JvaS/Kh1Pk1Yg0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-PgwC2CsWNyWTfR02NCEjbA-1; Fri, 01 Jul 2022 12:26:02 -0400
X-MC-Unique: PgwC2CsWNyWTfR02NCEjbA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31B5B811E7A;
	Fri,  1 Jul 2022 16:26:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3364D14152FF;
	Fri,  1 Jul 2022 16:25:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E95821947070;
	Fri,  1 Jul 2022 16:25:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E001D19451EF
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Jul 2022 16:25:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64CDFC15D5C; Fri,  1 Jul 2022 16:25:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 60C2CC15D70
 for <dm-devel@redhat.com>; Fri,  1 Jul 2022 16:25:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 484BE299E771
 for <dm-devel@redhat.com>; Fri,  1 Jul 2022 16:25:45 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-pttyBsiIMra7yjFeNWRchw-1; Fri, 01 Jul 2022 12:25:43 -0400
X-MC-Unique: pttyBsiIMra7yjFeNWRchw-1
Received: by mail-qt1-f175.google.com with SMTP id he28so778862qtb.13
 for <dm-devel@redhat.com>; Fri, 01 Jul 2022 09:25:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=CqLS9/VnMCYBuMzbL3e0tU8Vk7oa/JV3t+gC5Xn/h/k=;
 b=O4r/WrnoeIo//hT/99+gzDwHvdpGJ3qUhw4bD/35lMil/tVX3paCbG4MmL4/4Nnynu
 K2U6sZRKQmwzGUm3m02B0WgsItyMNr/+bGf6/fDC2C2iNPfUC5FZgWVXAngujhbvvC9X
 jORzJiy3eY9vFMYHLVHpHUabQUShMwfyUcFqW8vZOu4J946R274uGUt6VEzXCqnkANt8
 p4BlxMXuc1/0FiemTgmQjkf0zIm2OZlcVwAYA9BEF9cWLZMqv8SsLGJqN0ddbbOCOLdJ
 yifyz42WIJqrEETz0cNsNpyBb0S9yhZWpTSiwHzwAwienqeDQNaTfmumpq0aNrJ/DB2N
 LrCQ==
X-Gm-Message-State: AJIora9x6uBUZEnfCc8mfni4DzFdGvAVjsPQ4mFXyymlciUfEAIHo1WS
 FqdjWds+nNei/aHPzqvTqK1IeS2rDBFUX0Q=
X-Google-Smtp-Source: AGRyM1tzR5+oekiebA2Cl4ZcA8vDGKaik3m8+xoET3D9HB7EA7KAOUlWMkJMC/Ms3M1Oy/CjZO9H4Q==
X-Received: by 2002:ac8:570f:0:b0:31d:3692:36e0 with SMTP id
 15-20020ac8570f000000b0031d369236e0mr4051034qtw.343.1656692743249; 
 Fri, 01 Jul 2022 09:25:43 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 k201-20020a37a1d2000000b006a716fed4d6sm17007710qke.50.2022.07.01.09.25.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Jul 2022 09:25:42 -0700 (PDT)
Date: Fri, 1 Jul 2022 12:25:41 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Yr8gBVNDik5el/n/@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [git pull] device mapper fixes for 5.19-rc5
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
Cc: linux-raid@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 90736eb3232d208ee048493f371075e4272e0944:

  dm mirror log: clear log bits up to BITS_PER_LONG boundary (2022-06-23 14:55:43 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.19/dm-fixes-5

for you to fetch changes up to 617b365872a247480e9dcd50a32c8d1806b21861:

  dm raid: fix KASAN warning in raid5_add_disks (2022-06-29 19:48:04 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- 3 fixes for invalid memory accesses discovered by using KASAN while
  running the lvm2 testsuite's dm-raid tests. Includes changes to MD's
  raid5.c given the dependency dm-raid has on the MD code.

----------------------------------------------------------------
Heinz Mauelshagen (1):
      dm raid: fix accesses beyond end of raid member array

Mikulas Patocka (2):
      dm raid: fix KASAN warning in raid5_remove_disk
      dm raid: fix KASAN warning in raid5_add_disks

 drivers/md/dm-raid.c | 34 ++++++++++++++++++----------------
 drivers/md/raid5.c   |  6 +++++-
 2 files changed, 23 insertions(+), 17 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


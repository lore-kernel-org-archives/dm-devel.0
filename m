Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75191C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 18 Nov 2022 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668791497;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RT84Ju+8k8JwMAu2cYmdhb7TttxXrL2Xkc08WDvP2X4=;
	b=UElM6gQ+FO3usSs2GFGK6wmprVVzQmTduPA50H/WsEa8bCwJjIkZgLCbhxS2JX7KrXe/WZ
	rSjaJHA6zdTlMTj+vXD3JftIr2cZeeBI7M6GejHhOGca5zScRmIPILU6ETdP+Japhzprig
	fAPZYAukUFBokcS/cK5/K8aVz9/vfss=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-zO3GK7nhMDqVY3QltHqFhw-1; Fri, 18 Nov 2022 12:11:34 -0500
X-MC-Unique: zO3GK7nhMDqVY3QltHqFhw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F135E1C051A8;
	Fri, 18 Nov 2022 17:11:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7D6722027063;
	Fri, 18 Nov 2022 17:11:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 48D4C19465B1;
	Fri, 18 Nov 2022 17:11:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 22A291946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Nov 2022 17:11:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 046201415119; Fri, 18 Nov 2022 17:11:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F04EE140EBF3
 for <dm-devel@redhat.com>; Fri, 18 Nov 2022 17:11:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D59E838041C7
 for <dm-devel@redhat.com>; Fri, 18 Nov 2022 17:11:18 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-508-nG69h9h5MoaQ3mGWpxqa0g-1; Fri, 18 Nov 2022 12:11:17 -0500
X-MC-Unique: nG69h9h5MoaQ3mGWpxqa0g-1
Received: by mail-qt1-f180.google.com with SMTP id h24so3509050qta.9
 for <dm-devel@redhat.com>; Fri, 18 Nov 2022 09:11:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=A7+2TgRGIdW1STbzllen0rzoQfGY94f4zA/Ot6KcCYY=;
 b=NbvZanI30VhLapbh/A+eDyrq2NcDqk3c57+xGjd+tY912aA7ltfFYh7zmVub/9jHau
 zZjwsqjIoShOk5Md5KgQJN63HJAJwr0+4N1VbzKsJ2TyUTJd8UFWrIm1tzJvL2/0U+nD
 xGNjWPohhc3InValjOw+pp4EgLda4xKYAwLtuzs9b13jVvsDQk5u5LdnxjPDd5BRRcLw
 6vsp1V+tvALi6e2YTRw2mMCAb84L1V9kczeLTwoYBIdyNAds01WR166p+V3I/vnNCBDd
 UvzqlHj5paK/fCddeSn5U63EfL1TtkRM3VjBKbO3r7DmyPvC3Dsvxq0p4Gp9STmpMtOH
 /Ebg==
X-Gm-Message-State: ANoB5pn288OnTjFvWjuU11DVWGQnqLSHEVpKF4IrzxTTMzkoFgQ4TfAP
 adKzTWqc04/lJsLRMXCEYintgtQ=
X-Google-Smtp-Source: AA0mqf40Cb/Q2ArDuq4Sb1wFuRuW0OH54uAPKDI2SSl5r/UBqaSQPi2UcMm7IezJNpSi1Sng79SwDw==
X-Received: by 2002:ac8:5ed5:0:b0:3a4:f479:e147 with SMTP id
 s21-20020ac85ed5000000b003a4f479e147mr7564332qtx.243.1668791476800; 
 Fri, 18 Nov 2022 09:11:16 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 bx15-20020a05622a090f00b003a4f22c6507sm2307568qtb.48.2022.11.18.09.11.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Nov 2022 09:11:06 -0800 (PST)
Date: Fri, 18 Nov 2022 12:10:54 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Y3e8nulXd803OoEn@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [git pull] device mapper fixes for 6.1-rc6
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
Cc: linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@redhat.com, Zhihao Cheng <chengzhihao1@huawei.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 094226ad94f471a9f19e8f8e7140a09c2625abaa:

  Linux 6.1-rc5 (2022-11-13 13:12:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.1/dm-fixes-2

for you to fetch changes up to 984bf2cc531e778e49298fdf6730e0396166aa21:

  dm integrity: clear the journal on suspend (2022-11-18 11:05:09 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix misbehavior if list_versions DM ioctl races with module
  loading.

- Fix missing decrement of no_sleep_enabled if dm_bufio_client_create
  failed.

- Allow DM integrity devices to be activated in read-only mode.

----------------------------------------------------------------
Mikulas Patocka (3):
      dm ioctl: fix misbehavior if list_versions races with module loading
      dm integrity: flush the journal on suspend
      dm integrity: clear the journal on suspend

Zhihao Cheng (1):
      dm bufio: Fix missing decrement of no_sleep_enabled if dm_bufio_client_create failed

 drivers/md/dm-bufio.c     |  2 ++
 drivers/md/dm-integrity.c | 20 ++++++++++++++------
 drivers/md/dm-ioctl.c     |  4 ++--
 3 files changed, 18 insertions(+), 8 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


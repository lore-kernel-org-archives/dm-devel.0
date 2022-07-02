Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94224C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119815;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MnhruY8bO1JA37C7pAR8zGsHnlhItITTnnJm8xfwm8E=;
	b=Y0YrKUZH9i37LS8kR6p5t5FNMUoa16kudwBoeis5c1usmS1Qzw7fbQ9HVTMfgx7D1EboPM
	Fwi+20qzTmYzvDmAn8RjOedMWi0WaMq0/II9UjpJLipbZdh2PrHMACcEoMUl82K5Unvm5T
	XWrLp3wVTqgPPwRb19y4+YxWTcXUxpk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-odBkpLXgO72I2dpKcqC_ig-1; Wed, 06 Jul 2022 11:03:27 -0400
X-MC-Unique: odBkpLXgO72I2dpKcqC_ig-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05A2E101E165;
	Wed,  6 Jul 2022 15:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E725140E80E0;
	Wed,  6 Jul 2022 15:03:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5DE661947072;
	Wed,  6 Jul 2022 15:03:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C3FC41947042
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 11:14:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B445D1415307; Sat,  2 Jul 2022 11:14:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AFEC714152F9
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 11:14:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 966381C05B15
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 11:14:20 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-onYBO7EqOMqS5Cdzof8sNA-1; Sat, 02 Jul 2022 07:14:19 -0400
X-MC-Unique: onYBO7EqOMqS5Cdzof8sNA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DC0E560DCC;
 Sat,  2 Jul 2022 11:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E09AC341D9;
 Sat,  2 Jul 2022 11:07:48 +0000 (UTC)
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
 (envelope-from <mchehab@kernel.org>) id 1o7ayX-007gro-J8;
 Sat, 02 Jul 2022 12:07:45 +0100
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Date: Sat,  2 Jul 2022 12:07:32 +0100
Message-Id: <cover.1656759988.git.mchehab@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: [dm-devel] [PATCH 00/12] Fix several documentation build warnings
 with Sphinx 2.4.4
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
Cc: =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
 alsa-devel@alsa-project.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
 Brendan Higgins <brendanhiggins@google.com>, Jaroslav Kysela <perex@perex.cz>,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 linux-kselftest@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
 Takashi Iwai <tiwai@suse.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-tegra@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
 kunit-dev@googlegroups.com, linux-ext4@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, Eric Dumazet <edumazet@google.com>,
 Dipen Patel <dipenp@nvidia.com>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Johannes Berg <johannes@sipsolutions.net>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This series is against next-20220701. It fixes several warnings
that are currently produced while building html docs.

Each patch in this series is independent from the others, as
each one touches a different file.

Mauro Carvalho Chehab (12):
  docs: ext4: blockmap.rst: fix a broken table
  docs: tegra194-hte.rst: don't include gpiolib.c twice
  docs: device-mapper: add a blank line at writecache.rst
  docs: PCI: pci-vntb-function.rst: Properly include ascii artwork
  docs: PCI: pci-vntb-howto.rst: fix a title markup
  docs: virt: kvm: fix a title markup at api.rst
  docs: ABI: sysfs-bus-nvdimm
  kunit: test.h: fix a kernel-doc markup
  net: mac80211: fix a kernel-doc markup
  docs: alsa: alsa-driver-api.rst: remove a kernel-doc file
  docs: arm: index.rst: add google/chromebook-boot-flow
  docs: leds: index.rst: add leds-qcom-lpg to it

 Documentation/ABI/testing/sysfs-bus-nvdimm             | 2 ++
 Documentation/PCI/endpoint/pci-vntb-function.rst       | 2 +-
 Documentation/PCI/endpoint/pci-vntb-howto.rst          | 2 +-
 Documentation/admin-guide/device-mapper/writecache.rst | 1 +
 Documentation/arm/index.rst                            | 2 ++
 Documentation/driver-api/hte/tegra194-hte.rst          | 3 +--
 Documentation/filesystems/ext4/blockmap.rst            | 2 +-
 Documentation/leds/index.rst                           | 1 +
 Documentation/sound/kernel-api/alsa-driver-api.rst     | 1 -
 Documentation/virt/kvm/api.rst                         | 6 +++---
 include/kunit/test.h                                   | 2 +-
 include/net/mac80211.h                                 | 2 +-
 12 files changed, 15 insertions(+), 11 deletions(-)

-- 
2.36.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


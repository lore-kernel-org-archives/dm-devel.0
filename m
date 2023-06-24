Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40580EB64DD
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jun 2023 00:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687565360;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jC2cNy3P8bZ+3r3GSpudrtCRwsb7RFONipAsPc1FijI=;
	b=YTLJ0Y9GOKwTPGuqTYKTEi4MHHS6bjKtwbuqcZ1N0kK8Y7QLIAdzOBCT7agHxwp/vbULVG
	Uj/3wOEoBwETDhYVdChWYOeJRScJEprBBkHpxKFiDoIoLYbQsDzPANUVOn5VIfYahpBW/F
	hSLqG5lVB1qNlvrbqw3utn3vSgBPB1o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-c67ADWRuPISFyiWYx-lPrQ-1; Fri, 23 Jun 2023 20:09:18 -0400
X-MC-Unique: c67ADWRuPISFyiWYx-lPrQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B438690ED27;
	Sat, 24 Jun 2023 00:09:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4D5A492C13;
	Sat, 24 Jun 2023 00:09:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 955111946588;
	Sat, 24 Jun 2023 00:09:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8BEB71946587
 for <dm-devel@listman.corp.redhat.com>; Sat, 24 Jun 2023 00:09:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4F93C14682F7; Sat, 24 Jun 2023 00:09:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 470DD140EBB8
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 00:09:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17C363C02521
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 00:09:07 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-epon7k0YO4StYoHW0_XXVQ-1; Fri, 23 Jun 2023 20:09:04 -0400
X-MC-Unique: epon7k0YO4StYoHW0_XXVQ-1
Received: by mail-pf1-f176.google.com with SMTP id
 d2e1a72fcca58-666fb8b1bc8so1022716b3a.1
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 17:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687565342; x=1690157342;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=wbJYrnA9pnU+meP6XQ4kPeEwf/5w1AM0kN7wumRTQPk=;
 b=BRxcZ6ubzWYHqqtk3nsIA6bQi/++hG4YbPAQG495xr5FZkvBSaOHlJcETbMCZceBnU
 3eYeBBGMCziPmQiKs72JSFzOgT6ijKyeZV17dNlKZj4w6kX8Iv1CKLS6bXXoNxlv3kBn
 VJ1KwvPVays84gekpmsLhSRZZg/IS2xMuoDN31mGDQN2VJZKS6myNzy6iVEMO/iH2q6r
 ovBkrkG0zlbFu/+gTvRMmcWal2pvJl87YjgUZDmxEfEx0feJa3aeuo6oSDUoxZGDkbXv
 Zm3hFyQKDBCiprYmeqvrTq5qtODYQkC5QkG3Ws4DRG7Kj+VjlURx29Hp5zwsTaS5KGI2
 gV3A==
X-Gm-Message-State: AC+VfDxW1W6rViOOQturrvurM05mpxAyx251qGv1ok62/A9QSc/zPhX6
 YHkgYcKgig+1RoRjkTsMbk0=
X-Google-Smtp-Source: ACHHUZ5UWmNb3hGeP/QCkeICkX9qJKsrvt0uGbMg739NNzwe0eHF70/k0NEUj6d2y5jm6EUom87PcA==
X-Received: by 2002:a05:6a20:7f99:b0:10b:4539:fa0a with SMTP id
 d25-20020a056a207f9900b0010b4539fa0amr28469987pzj.1.1687565342232; 
 Fri, 23 Jun 2023 17:09:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 o5-20020a656145000000b0052858b41008sm165159pgv.87.2023.06.23.17.09.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Jun 2023 17:09:01 -0700 (PDT)
Date: Fri, 23 Jun 2023 17:08:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <c1391658-d785-4b2f-ba7e-01e4668685d7@roeck-us.net>
References: <20230531125535.676098-1-hch@lst.de>
 <20230531125535.676098-9-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230531125535.676098-9-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 08/24] init: pass root_device_name explicitly
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
Cc: Jens Axboe <axboe@kernel.dk>, Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Joern Engel <joern@lazybastard.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: roeck-us.net
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

On Wed, May 31, 2023 at 02:55:19PM +0200, Christoph Hellwig wrote:
> Instead of declaring root_device_name as a global variable pass it as an
> argument to the functions using it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This patch results in the following build error when trying to build
xtensa:tinyconfig.

WARNING: modpost: vmlinux: section mismatch in reference: strcpy.isra.0+0x14 (section: .text.unlikely) -> initcall_level_names (section: .init.data)
ERROR: modpost: Section mismatches detected.

Unfortunately, reverting it is not possible due to conflicts,
so I can not confirm the bisect results.

Bisect log attached.

Guenter

---
# bad: [8d2be868b42c08290509c60515865f4de24ea704] Add linux-next specific files for 20230623
# good: [45a3e24f65e90a047bef86f927ebdc4c710edaa1] Linux 6.4-rc7
git bisect start 'HEAD' 'v6.4-rc7'
# good: [a5838c78db6a3a02e8d221e588c948f792e7f256] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
git bisect good a5838c78db6a3a02e8d221e588c948f792e7f256
# bad: [cca41cc0b5485a0ec20707316c1a00082c01a2af] Merge branch 'for-next' of git://git.kernel.dk/linux-block.git
git bisect bad cca41cc0b5485a0ec20707316c1a00082c01a2af
# good: [901bdf5ea1a836400ee69aa32b04e9c209271ec7] Merge tag 'amd-drm-next-6.5-2023-06-09' of https://gitlab.freedesktop.org/agd5f/linux into drm-next
git bisect good 901bdf5ea1a836400ee69aa32b04e9c209271ec7
# good: [b4666c320b8113d94b3f4624054562e7add57e4a] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git
git bisect good b4666c320b8113d94b3f4624054562e7add57e4a
# good: [b2c28785b125acb28a681462510297410cbbabd7] ASoC: dt-bindings: microchip,sama7g5-pdmc: Simplify "microchip,mic-pos" constraints
git bisect good b2c28785b125acb28a681462510297410cbbabd7
# bad: [9d217fb0e778d69b2e3988efbc441976c0fb29b5] nvme: reorder fields in 'struct nvme_ctrl'
git bisect bad 9d217fb0e778d69b2e3988efbc441976c0fb29b5
# good: [20d099756b98fa6b5b838448b1ffbce46f4f3283] block: Replace all non-returning strlcpy with strscpy
git bisect good 20d099756b98fa6b5b838448b1ffbce46f4f3283
# bad: [93c8f6f38be67e30adf8d8eb5e7e9ccb89326119] pktcdvd: Drop redundant castings for sector_t
git bisect bad 93c8f6f38be67e30adf8d8eb5e7e9ccb89326119
# bad: [c8643c72bc42781fc169c6498a3902bec447099e] init: pass root_device_name explicitly
git bisect bad c8643c72bc42781fc169c6498a3902bec447099e
# good: [87efb39075be6a288cd7f23858f15bd01c83028a] fs: add a method to shut down the file system
git bisect good 87efb39075be6a288cd7f23858f15bd01c83028a
# good: [aa5f6ed8c21ec1aa5fd688118d8d5cd87c5ffc1d] driver core: return bool from driver_probe_done
git bisect good aa5f6ed8c21ec1aa5fd688118d8d5cd87c5ffc1d
# good: [cc89c63e2fe37d476357c82390dfb12edcd41cdd] PM: hibernate: move finding the resume device out of software_resume
git bisect good cc89c63e2fe37d476357c82390dfb12edcd41cdd
# good: [e3102722ffe77094ba9e7e46380792b3dd8a7abd] init: rename mount_block_root to mount_root_generic
git bisect good e3102722ffe77094ba9e7e46380792b3dd8a7abd
# good: [a6a41d39c2d91ff2543d31b6cc6070f3957e3aea] init: refactor mount_root
git bisect good a6a41d39c2d91ff2543d31b6cc6070f3957e3aea
# first bad commit: [c8643c72bc42781fc169c6498a3902bec447099e] init: pass root_device_name explicitly

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


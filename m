Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9094DEB64D8
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 04:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687408178;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DNq5WjhIhVQe0kREqGQP1TdPAcs6ZrPHw2F6LyM9aD4=;
	b=bucWw+UApuqLC6hqWxYNSMCsDjmP7lscKHsHdeGZEUvdcAqF7oS3Z0BC5exaiyQcX8ZG7g
	bx5ZXCGtPVLw1ljfkw+HYIvzBliBIDHq1PuwVRlwGYvtFgP1TkKYZSaFwyekzhguyWeAFY
	eCmJxvfWXD6KD7bh0esvFRl8atQv8Vs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-2ELaVzNlMP2x8yHJ4ZNXDw-1; Thu, 22 Jun 2023 00:29:35 -0400
X-MC-Unique: 2ELaVzNlMP2x8yHJ4ZNXDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EA9B88D1A2;
	Thu, 22 Jun 2023 04:29:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79505200BA8B;
	Thu, 22 Jun 2023 04:29:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4E34B1946587;
	Thu, 22 Jun 2023 04:29:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7C25E1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 04:29:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 63C0AC1ED98; Thu, 22 Jun 2023 04:29:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BB09C1ED96
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 04:29:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C7231C0754B
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 04:29:02 +0000 (UTC)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-dH6mX8_ROE6YunSjjzA6TA-1; Thu, 22 Jun 2023 00:28:59 -0400
X-MC-Unique: dH6mX8_ROE6YunSjjzA6TA-1
Received: by mail-pg1-f176.google.com with SMTP id
 41be03b00d2f7-53fbf2c42bfso5323897a12.3
 for <dm-devel@redhat.com>; Wed, 21 Jun 2023 21:28:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687408138; x=1690000138;
 h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
 :content-language:user-agent:mime-version:date:message-id:sender
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=OK+CXuyFLwF44/27I2as5mqeWxwcMg3WlGZonvd6nV8=;
 b=ZmUh7BDssa53cB4KBB7+wB8NpTgLXTu6bcp2KguLX6H71w9CU5KcIkcFfWZlj+Ng0I
 bmQm418JQb6+Naqchat5nMkIVUhgkKS4k2OpKJQIcTuAxuw/Qwvg51nAq4dkMeQ6rOrV
 mRMPS5LzrzpIRd0doAs0YU3xxY4imr78RN38DhUiXuuyLMjB1MABkctxAdkwOccD70LA
 R8LbK1ejVRuiJgq0DdPcJlbRhPtojKeKi7hBwOP186I7PTGU4H46N2P1yf0+C9+uWwe6
 Hk0Sh5i2li/o5phr80Wzh1a1c04ZG1kEsAU7fYzc2P+rhUbjCQG3DGh6g29w+BVprdAY
 VRKg==
X-Gm-Message-State: AC+VfDxrf0xlKcjhiwEqshMWlcefucVy2WgGJSBVK6MPJ6sZkOwhc4TH
 TdHqsr80GvJKyDY/8veCPAk=
X-Google-Smtp-Source: ACHHUZ4+ZMoJr7SnY11jKCs2czSTRYO57d2qFyw6J6x2UuheAlVyskFDDBj2KxGUrXVcomI0QhCtBA==
X-Received: by 2002:a05:6a20:3d92:b0:11d:38ea:7586 with SMTP id
 s18-20020a056a203d9200b0011d38ea7586mr22888787pzi.9.1687408138593; 
 Wed, 21 Jun 2023 21:28:58 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c?
 ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 a17-20020aa780d1000000b00666e2dac482sm3605318pfn.124.2023.06.21.21.28.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 21 Jun 2023 21:28:57 -0700 (PDT)
Message-ID: <2205ef1e-9bb6-fb1e-9ca3-367c1afe12ac@roeck-us.net>
Date: Wed, 21 Jun 2023 21:28:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Christoph Hellwig <hch@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-15-hch@lst.de>
 <8c1992bc-110a-4dad-8643-766c14bf6fd4@roeck-us.net>
 <20230622035149.GA4667@lst.de>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230622035149.GA4667@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 14/24] init: clear root_wait on all invalid
 root= strings
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
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Joern Engel <joern@lazybastard.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: roeck-us.net
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/21/23 20:51, Christoph Hellwig wrote:
> On Wed, Jun 21, 2023 at 02:07:13PM -0700, Guenter Roeck wrote:
>> On Tue, May 23, 2023 at 09:45:25AM +0200, Christoph Hellwig wrote:
>>> Instead of only clearing root_wait in devt_from_partuuid when the UUID
>>> format was invalid, do that in parse_root_device for all strings that
>>> failed to parse.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> In linux-next, almost all of my boot tests from usb drives as well
>> as a few others fail with "Disabling rootwait; root= is invalid."
>> in the log. Bisect points to this patch.
> 
> Can you send such a log, and the command line you've used?
> 


There are lots of logs at https://kerneltests.org/builders, in the 'next'
column of qemu tests. One example is
https://kerneltests.org/builders/qemu-arm-v7-next/builds/511/steps/qemubuildcommand/logs/stdio

Sample command line:

qemu-system-arm -M mcimx7d-sabre \
      -kernel arch/arm/boot/zImage -no-reboot -snapshot \
      -usb -device usb-storage,drive=d0,bus=usb-bus.1 \
      -drive file=rootfs-armv7a.ext2,if=none,id=d0,format=raw \
      -m 256 -nic user -display none \
      --append "root=/dev/sda rootwait earlycon=ec_imx6q,mmio,0x30860000,115200n8 console=ttymxc0,115200" \
      -dtb arch/arm/boot/dts/imx7d-sdb.dtb \
      -nographic -monitor null -serial stdio

This is with a modified imx_v6_v7_defconfig and root file system from
https://github.com/groeck/linux-build-test/blob/master/rootfs/arm-v7/rootfs-armv7a.ext2.gz

The -EINVAL return value is from

	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')

in devt_from_devname().

Guenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


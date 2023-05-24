Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08654C7EE2E
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 07:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684998757;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FyoZ1e7F+yleNaiYPaMfmiALElY+DnrvMqCSHyDS5Ko=;
	b=RekPPaAEMIWN19z+nBd0sqrFdNrdCJUqnASGiOdbYwQe5g/1dYa43A0MWh2se2KAl7O8oQ
	gER+I2jpIwa52y0A9I8Z347tXo0T12o58uSHPUPmygOstmyUyz+cKXQf4edquj2toI0MBx
	XN4GahXAVpWfYIJuCTtO3YcjJ1IdL4M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-TTX3hH8wP7yVQ6PmXRNavg-1; Thu, 25 May 2023 03:12:33 -0400
X-MC-Unique: TTX3hH8wP7yVQ6PmXRNavg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E29191C05ECE;
	Thu, 25 May 2023 07:12:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CFEBC492B0A;
	Thu, 25 May 2023 07:12:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B598B19465A4;
	Thu, 25 May 2023 07:12:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DB73C19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 06:59:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 883852166B25; Wed, 24 May 2023 06:59:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80A102166B26
 for <dm-devel@redhat.com>; Wed, 24 May 2023 06:59:50 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F67A185A78B
 for <dm-devel@redhat.com>; Wed, 24 May 2023 06:59:50 +0000 (UTC)
Received: from out30-101.freemail.mail.aliyun.com
 (out30-101.freemail.mail.aliyun.com [115.124.30.101]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-350-ILnEtkPfMMqTYJbifeD2Ug-1; Wed, 24 May 2023 02:59:47 -0400
X-MC-Unique: ILnEtkPfMMqTYJbifeD2Ug-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R571e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=durui@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VjMytmC_1684911581
Received: from 30.240.109.115(mailfrom:durui@linux.alibaba.com
 fp:SMTPD_---0VjMytmC_1684911581) by smtp.aliyun-inc.com;
 Wed, 24 May 2023 14:59:42 +0800
Message-ID: <ff5a72a3-3977-68f1-c5c6-41c90b7229b2@linux.alibaba.com>
Date: Wed, 24 May 2023 14:59:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
To: Mike Snitzer <snitzer@kernel.org>
References: <9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com>
 <ZGz32yw7ecKhW+lj@redhat.com>
From: Du Rui <durui@linux.alibaba.com>
In-Reply-To: <ZGz32yw7ecKhW+lj@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Thu, 25 May 2023 07:12:27 +0000
Subject: Re: [dm-devel] dm overlaybd: targets mapping OverlayBD image
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
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, dm-devel@redhat.com,
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Alexander Larsson <alexl@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.alibaba.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Mike,

On 5/24/23 1:28 AM, Mike Snitzer wrote:
> On Fri, May 19 2023 at  6:27P -0400,
> Du Rui <durui@linux.alibaba.com> wrote:
> 
>> OverlayBD is a novel layering block-level image format, which is design
>> for container, secure container and applicable to virtual machine,
>> published in USENIX ATC '20
>> https://www.usenix.org/system/files/atc20-li-huiba.pdf
>>
>> OverlayBD already has a ContainerD non-core sub-project implementation
>> in userspace, as an accelerated container image service
>> https://github.com/containerd/accelerated-container-image
>>
>> It could be much more efficient when do decompressing and mapping works
>> in the kernel with the framework of device-mapper, in many circumstances,
>> such as secure container runtime, mobile-devices, etc.
>>
>> This patch contains a module, dm-overlaybd, provides two kinds of targets
>> dm-zfile and dm-lsmt, to expose a group of block-devices contains
>> OverlayBD image as a overlaid read-only block-device.
>>
>> Signed-off-by: Du Rui <durui@linux.alibaba.com>
> 
> <snip, original patch here: [1] >
> 
> I appreciate that this work is being done with an eye toward
> containerd "community" and standardization but based on my limited
> research it appears that this format of OCI image storage/use is only
> used by Alibaba? (but I could be wrong...)
> 
> But you'd do well to explain why the userspace solution isn't
> acceptable. Are there security issues that moving the implementation
> to kernel addresses?
> 
> I also have doubts that this solution is _actually_ more performant
> than a proper filesystem based solution that allows page cache sharing
> of container image data across multiple containers.
> 
> There is an active discussion about, and active development effort
> for, using overlayfs + erofs for container images.  I'm reluctant to
> merge this DM based container image approach without wider consensus
> from other container stakeholders.
> 
> But short of reaching wider consensus on the need for these DM
> targets: there is nothing preventing you from carrying these changes
> in your alibaba kernel.
> 
> Mike
> 
> [1]: https://patchwork.kernel.org/project/dm-devel/patch/9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com/

OverlayBD is a generic solution for overlayable and random accessable 
read-only block device, it is a part of container image solution, but 
not only designed for container images. Actually our team also use it in 
VM and other data images.

Container images in format of OverlayBD is not only used in Alibaba, as 
a open-source solution of containerd, it has already have users in 
community. The project also have contributors from community.

I do like erofs, and also looking forward to widely used container image 
solutions via filesystem. But any filesystem container image soultion 
has no conflict with a generic block device image.

All filesystems that access data via block-devices are possible to 
create OverlayBD image, including those widely used filesystems. With 
dm-snapshot or dm-thin providing writable layer for a read-only block 
device, block images can be mounted as full featured filesystem, with 
100% compatibility to those filesystems on normal block devices.

By my tests, erofs, btrfs, squashfs, and other filesystems on OverlayBD 
performs very well, in some certain circumstances, even better that 
those on raw block devices.

Considering sharing page cache, lots of filesystem supports DAX for PMEM 
devices, that might be a way to work around I think. Currently those 
related implementation is not a part of this module.

Thanks for the replying.

Du Rui

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


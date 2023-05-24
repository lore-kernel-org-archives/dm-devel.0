Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F6FC7EE33
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 04:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684903841;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bNuCVTPWJGaER6mHKgnnSAw/zbuhyMHDv4yzorA4i24=;
	b=A5A8VHxdKFfNBalt/YNj4NTsnsi5DhhnE6nMOF2j4SV43zHSf7wzte4yFU+6u5ZtUTewUs
	Oe4UHlnzX/1BX0dsQMXiNWhiAM4I303rykmtT80jDFJnyUEu34TvUC/k5tqtXgypHdjuAF
	qQxkWBPTvJFEHGGFs6ZCPHchGHy7Ynk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-ZlpcuoTuO1qBmbFAHGd51A-1; Wed, 24 May 2023 00:50:37 -0400
X-MC-Unique: ZlpcuoTuO1qBmbFAHGd51A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1B09299E76D;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF8E9492B00;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6EDD819465BD;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A893919465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 01:01:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57E39400F17; Wed, 24 May 2023 01:01:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 50817492B00
 for <dm-devel@redhat.com>; Wed, 24 May 2023 01:01:28 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 352A3811E98
 for <dm-devel@redhat.com>; Wed, 24 May 2023 01:01:28 +0000 (UTC)
Received: from out30-101.freemail.mail.aliyun.com
 (out30-101.freemail.mail.aliyun.com [115.124.30.101]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-336-R1fipe2oP9Cvkp8H14sHWQ-1; Tue, 23 May 2023 21:01:26 -0400
X-MC-Unique: R1fipe2oP9Cvkp8H14sHWQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
 TI=SMTPD_---0VjLvOod_1684889773
Received: from 192.168.3.7(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0VjLvOod_1684889773) by smtp.aliyun-inc.com;
 Wed, 24 May 2023 08:56:14 +0800
Message-ID: <17c39e1d-2376-c90f-5e87-ed1982a7cff9@linux.alibaba.com>
Date: Wed, 24 May 2023 08:56:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
To: Mike Snitzer <snitzer@kernel.org>, Du Rui <durui@linux.alibaba.com>
References: <9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com>
 <ZGz32yw7ecKhW+lj@redhat.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ZGz32yw7ecKhW+lj@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Wed, 24 May 2023 04:50:30 +0000
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
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, linux-kernel@vger.kernel.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>, dm-devel@redhat.com,
 Alexander Larsson <alexl@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.alibaba.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Mike,

On 2023/5/24 10:28, Mike Snitzer wrote:
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

Not necessarily Alibaba, actually OverlayBD solution is open-source to
containerd, at least I think it's an opensource project and I saw some
Microsoft Azure guys are also working on this.

> 
> But you'd do well to explain why the userspace solution isn't
> acceptable. Are there security issues that moving the implementation
> to kernel addresses?

OverlayBD user-space solution was actually the original Alibaba solution
widely used in Alibaba internally, and Nydus might be the another one
(used but limited, Ant group and Bytedance use Nydus more widely.) Since
Alibaba group is a big company, it's pretty normal to have two similiar
competing solutions together.

After I joined Alibaba, personally, I persuaded OverlayBD guys switching
from their stacked storage solution to a simple fs solution, because:

  - It allows a simple on-disk format rather than a long storage stack
    with a random fs, it increases the overall attack vector: which I
    think this year LSF/MM already discuss about that;

  - Different random fses cannot share page cache across images. IOWs,
    many in-kernel fses actually doesn't suit for container image use
    cases;

Also consider this one:
  - Apart from the detailed on-disk design, this attempt is just a
    read-only solution without  1) on-demand load;  2) write support;

  - Very similar to the exist approaches:
    dm-qcow2  https://lore.kernel.org/r/164846619932.251310.3668540533992131988.stgit@pro/
    dm-vdo   https://lore.kernel.org/r/20230523214539.226387-1-corwin@redhat.com/

I also persuaded Nydus guys from their own format to erofs format, but
I failed to persuaded Overlaybd guys.

> 
> I also have doubts that this solution is _actually_ more performant
> than a proper filesystem based solution that allows page cache sharing
> of container image data across multiple containers.

Agreed.

> 
> There is an active discussion about, and active development effort
> for, using overlayfs + erofs for container images.  I'm reluctant to
> merge this DM based container image approach without wider consensus
> from other container stakeholders.

I'm too tired about these different container image solutions.  I will
go on improve EROFS, and hopefully it will finally useful to everyone.

Thanks,
Gao Xiang

> 
> But short of reaching wider consensus on the need for these DM
> targets: there is nothing preventing you from carrying these changes
> in your alibaba kernel.
> 
> Mike
> 
> [1]: https://patchwork.kernel.org/project/dm-devel/patch/9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com/
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


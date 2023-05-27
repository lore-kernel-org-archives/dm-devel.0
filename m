Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BF2C7EE32
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 04:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685335921;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VS4Cwzc/dobWsuqxFrxjlp2vViVvX8yHNwNgrsih9VM=;
	b=DA+jIpypiFT15ClLh0g7rtEIt4W5AdNQrImZKG61j5O0GuRmSdHolByA3yNjUX3sYDQVdK
	d8q5ybVLcGFYbjqqbHPpz5kMr69fM2OdIl0kFAeHIRT51HbnYv4Xz1b/fWIqAGqCBmdYXo
	Xu197xpWDjAvVYVJnA3ArWId187JZA8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-ygijgFO6NUiJ4gQx0dxHnQ-1; Mon, 29 May 2023 00:51:57 -0400
X-MC-Unique: ygijgFO6NUiJ4gQx0dxHnQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EFB6384CC4F;
	Mon, 29 May 2023 04:51:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77B2B40CFD45;
	Mon, 29 May 2023 04:51:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DAC361946A44;
	Mon, 29 May 2023 04:51:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7273E19465A0
 for <dm-devel@listman.corp.redhat.com>; Sat, 27 May 2023 04:12:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 166C440CFD01; Sat, 27 May 2023 04:12:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EB2240CFD00
 for <dm-devel@redhat.com>; Sat, 27 May 2023 04:12:40 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6A5A85A5A8
 for <dm-devel@redhat.com>; Sat, 27 May 2023 04:12:39 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
 (out30-132.freemail.mail.aliyun.com [115.124.30.132]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-182-naTs755jOYS-9Noid-ELHw-1; Sat, 27 May 2023 00:12:33 -0400
X-MC-Unique: naTs755jOYS-9Noid-ELHw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R721e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046051;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
 TI=SMTPD_---0VjYkMWT_1685160745
Received: from 30.0.159.48(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0VjYkMWT_1685160745) by smtp.aliyun-inc.com;
 Sat, 27 May 2023 12:12:28 +0800
Message-ID: <11c1e59f-d05e-5479-fa6b-36d9a793c16e@linux.alibaba.com>
Date: Sat, 27 May 2023 12:12:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
To: Du Rui <durui@linux.alibaba.com>
References: <ac8519fd-85f4-e778-0c6c-b2e893a37628@linux.alibaba.com>
 <20230527031319.92200-1-durui@linux.alibaba.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20230527031319.92200-1-durui@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 29 May 2023 04:51:50 +0000
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
Cc: gscrivan@redhat.com, snitzer@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, alexl@redhat.com, Gao Xiang <xiang@kernel.org>,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.alibaba.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2023/5/27 11:13, Du Rui wrote:
>> Block drivers has nothing to do on filesystem page cache stuffs, also
>> currently your approach has nothing to do with pmem stuffs (If you must
>> mention "DAX" to proposal your "page cache sharing", please _here_
>> write down your detailed design first and explain how it could work to
>> ours if you really want to do.)
> 
> We have already done experiments (by virtio pmem), to make virtual PMEM
> device in QEMU, make guest vm sharing only one memory mapping on host,
> with filesystem that supports DAX. In guest vm, fs keeps no page cache,
> maybe "sharing pagecache" is not such accurate description, but sharing
> memory pages on host can do prevent making duplicated pagecache pages in
> VMs.

First, does virtio-pmem have some relationship with this kernel
claim "dm / lvm" proposal" of yours?  Does your virtio-pmem work
on bare matel or cloud server or runC (I mean without some host
adaption)?

Secondly, does your virtio-pmem have any relationship with this
kernel approach? If not, why not directly using your userspace
work on your specific use case? How does this kernel DM approach
have any help to your "sharing pagecache"?

Do you know how kernel FSDAX work and what type of memory of
pmem is?  Could you give me your detailed kernel design to do
in-kernel DM+pmem dax mapping?

> 
> Please make sure that you have already understood that dm-overlaybd are
> for GENERIC purpose. It is NOT a special design for container, and have
> nothing related to filesystem implementations.
Previous dm-qcow2 is more generic (on-disk format friendly for
read-write as well as qcow2 format with two-level l1/l2 indexes
takes less runtime memory persistent footprint than your on-disk
format which needs to load and parse your hardly-seekable on-disk
lsmt+zfile layer indexes to some new in-memory represention which
can be used for random accesses before any real I/Os and these
in-memory indexes _cannot_ be _partially reclaimed_ from memory)
and qcow2 has more wider ecosystem compared to your approach, but
could you see the community tendency of this?

ublk-qcow2: ublk-qcow2 is available:
https://lore.kernel.org/r/Yza1u1KfKa7ycQm0@T590

Second, I have to mention here your previous attempt including
read (maybe later write) your DADI file stuffs in your
in-kernel block driver, which I think that was really
dangerous:

see vfsfile.c of your previous codebase
https://github.com/data-accelerator/dadi-kernel-mod/commit/ff12687f2c567ddf51a28df88b25dd2d0e3737a2

static struct file *file_open(const char *path, int flags, int rights)
{
..
	fp = filp_open(path, O_RDONLY, 0);
..
}

static ssize_t file_read(struct file *file, void *buf, size_t count, loff_t pos)
{
..
	vfs_fadvise(file, pos, count, POSIX_FADV_SEQUENTIAL);
..
		ret = kernel_read(file, buf, count, &lpos);
..
}

In your current proposed patch, you still call it as "struct
vfile" but use raw block device stuffs instead.

But this raw block device use cases are limited (almost useless)
for containers since as Alex said, almost all container users
switch to filesystem-based approach (I don't want to repeat why).
And your kernel approach is almost useless for virtual machine
use cases (see how qcow2 works for VMs).

In the end, Assume that if you *end up with* later upstreaming
reading backing filesystem files directly under the block layer
(for example, as your second step), that is really a not-go.

Anyway, all the above is on behalf myself.

Thanks,
Gao Xiang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


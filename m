Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E81C43334
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 08:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658823394;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Rx6I7+6reQcQIIgizx4qhNU3Z35MdYgOZQHIuzzI260=;
	b=TR6Fiqr8mRaP9XVwtLmC/bYDEZYEMuEssAhTRCl6ndsK5pLwbTL3F40jlU/bdMR4pN0frS
	dVtTeNjSDVrBP1ij1hMxhIAVD+RM9RqydMk+9EOGeM28+k7ZTv2mVKiu7lLMmMrfzjNBSr
	nJjeGEVnFT/884oEo9Y3SKhSm8S5ffA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-RU7ObfGiNLuvAe8w-covjA-1; Tue, 26 Jul 2022 04:16:31 -0400
X-MC-Unique: RU7ObfGiNLuvAe8w-covjA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55A0329AB3EC;
	Tue, 26 Jul 2022 08:16:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26168909FF;
	Tue, 26 Jul 2022 08:16:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE6541945D97;
	Tue, 26 Jul 2022 08:16:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2CA671945D88
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Jul 2022 21:20:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0C1DF2166B2A; Mon, 25 Jul 2022 21:20:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07F842166B26
 for <dm-devel@redhat.com>; Mon, 25 Jul 2022 21:20:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E04268526FA
 for <dm-devel@redhat.com>; Mon, 25 Jul 2022 21:20:32 +0000 (UTC)
Received: from forward101o.mail.yandex.net (forward101o.mail.yandex.net
 [37.140.190.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-Lp_RDwe5M_WTDybarphkRQ-1; Mon, 25 Jul 2022 17:20:28 -0400
X-MC-Unique: Lp_RDwe5M_WTDybarphkRQ-1
Received: from iva1-dcde80888020.qloud-c.yandex.net
 (iva1-dcde80888020.qloud-c.yandex.net
 [IPv6:2a02:6b8:c0c:7695:0:640:dcde:8088])
 by forward101o.mail.yandex.net (Yandex) with ESMTP id 2ECB3369B50D;
 Tue, 26 Jul 2022 00:15:15 +0300 (MSK)
Received: by iva1-dcde80888020.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA
 id ZXho2Z3dGu-FCh4KT0f; Tue, 26 Jul 2022 00:15:14 +0300
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
 (Client certificate not present)
X-Yandex-Fwd: 1
To: Stefan Hajnoczi <stefanha@redhat.com>,
 Kirill Tkhai <kirill.tkhai@openvz.org>
References: <YoSSkOQaGL0sBNOI@stefanha-x1.localdomain>
From: Kirill Tkhai <tkhai@ya.ru>
Message-ID: <d4aafde8-1686-4423-e9b1-c1cc825236e6@ya.ru>
Date: Tue, 26 Jul 2022 00:15:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YoSSkOQaGL0sBNOI@stefanha-x1.localdomain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Tue, 26 Jul 2022 08:16:26 +0000
Subject: Re: [dm-devel] Attaching qcow2 images to containers
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
Cc: Kevin Wolf <kwolf@redhat.com>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, qemu-devel@nongnu.org,
 Xie Yongji <xieyongji@bytedance.com>, hreitz@redhat.com, tkhai@ya.ru,
 sgarzare@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, Stefan,

sorry for the late reply. I missed your message since I don't use that email address anymore.
Sent a patch to fix the stale address in .mailmap.

On 18.05.2022 09:30, Stefan Hajnoczi wrote:
> Hi Kirill,
> I saw your "[PATCH 0/4] dm: Introduce dm-qcow2 driver to attach QCOW2
> files as block device" patch series:
> https://lore.kernel.org/linux-kernel/YkME5ZS2CpXuNmN6@infradead.org/T/
> 
> There has been recent work in vDPA (VIRTIO Data Path Acceleration) to
> achieve similar functionality. The qemu-storage-daemon VDUSE export
> attaches a virtio-blk device to the host kernel and QEMU's qcow2
> implementation can be used:
> https://patchew.org/QEMU/20220504074051.90-1-xieyongji@bytedance.com/
> 
> A container can then access this virtio-blk device (/dev/vda). Note that
> the virtio-blk device is implemented in software using vDPA/VDUSE, there
> is no virtio-pci device.
> 
> As a quick comparison with a dm-qcow2 target, this approach keeps the
> qcow2 code in QEMU userspace and can take advantage of QEMU block layer
> features (storage migration/mirroring/backup, snapshots, etc). On the
> other hand, it's likely to be more heavyweight because bounce buffers
> are required in VDUSE for security reasons, there is a separate
> userspace process involved, and there's the virtio_blk.ko driver and an
> emulated virtio-blk device involved.

The main idea is to reach the best performance and density. This is possible only,
if driver's hot path is implemented in kernel. Comparing to NBD the driver shows
much better results in these criteria.

This has a continuation, and I mean DAX here. IO handling with any userspace-based
implementation will be slower, than DAX in case of kernel-based implementation. So,
in my driver IO handling is done in kernel, while DAX support is a subject of
the future development.

And this driver and advantages of QEMU block layer are not mutually exclusive.
This driver *does not implement* snapshot or backup support, here is only hot-path
doing IO handling.
 
> Another similar feature that was recently added to QEMU is the
> qemu-storage-daemon FUSE export:
> 
>   $ qemu-storage-daemon \
>         --blockdev file,filename=test.img,node-name=drive0 \
> 	--export fuse,node-name=drive0,id=fuse0,mountpoint=/tmp/foo
>   $ ls -alF /tmp/foo
>   -r--------. 1 me me 10737418240 May 18 07:22 /tmp/foo
> 
> This exports a disk image as a file via FUSE. Programs can access it
> like a regular file and qemu-storage-daemon will do the qcow2 I/O on the
> underlying file.
> 
> I wanted to mention these options for exposing qcow2 disk images to
> processes/containers on the host. Depending on your use cases they might
> be interesting. Performance comparisons against VDUSE and FUSE exports
> would be interesting since these new approaches seem to be replacing
> qemu-nbd.
> 
> Can you share more about your use cases for the dm-qcow2 target? It
> could be useful for everyone I've CCed to be aware of various efforts in
> this area.

The use case is containers, and they are the requestor for high density.
The userspace-based implementation overhead will be noticeable on nodes
running a lot of containers (just because of any overhead is noticeable
there :)). Also, it's very useful to use the same disk image for VMs and
containers giving people to choose what they want in the moment.

Best wishes,
Kirill

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A6EC7EE26
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 17:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684862952;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B9jWXq484Y9chv68bUfgui5fGzNhJAc0n41nPCDZcR0=;
	b=f+COrKvq91j8AdpvpXajxS6q20GX3Nonwff15/S7PH8/dR9YHZTWq9n2zZWzL6VGx+J5+N
	G8b59a636F6fpD3xFssff5OttXQ2ThvCLIdQZq4Mmsix7H6F2VSOK5SPr8Yi9YaE48Gc1m
	a5MpiYhALyi9XT5ENnFoo4PXCeATwoo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-GFvrxnxrM7mr-pi2abBuRg-1; Tue, 23 May 2023 13:29:11 -0400
X-MC-Unique: GFvrxnxrM7mr-pi2abBuRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BCAA1019C87;
	Tue, 23 May 2023 17:29:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A1C5B140E95D;
	Tue, 23 May 2023 17:29:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6730619465A8;
	Tue, 23 May 2023 17:29:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 401EF19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 17:29:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C0B2D140E961; Tue, 23 May 2023 17:29:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B8AB7140E95D
 for <dm-devel@redhat.com>; Tue, 23 May 2023 17:29:06 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 959742A59574
 for <dm-devel@redhat.com>; Tue, 23 May 2023 17:29:06 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
 [209.85.219.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-nbTHQMHNNAGksGIusee6gQ-1; Tue, 23 May 2023 13:29:01 -0400
X-MC-Unique: nbTHQMHNNAGksGIusee6gQ-1
Received: by mail-qv1-f44.google.com with SMTP id
 6a1803df08f44-62596e46d30so5199516d6.1
 for <dm-devel@redhat.com>; Tue, 23 May 2023 10:29:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684862941; x=1687454941;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=88ji2ehp7Y51Xu9y1iJArVPSJqfYf526w71azZN8Kpg=;
 b=VeV6BwNwZ3wsiuaIzDRm5KFc6WG6pQ578TEWroqmHibTe5dyTLrycpZ8e5aDo1EsK6
 WePHcrm23jx1NZ2BKOGaVuQCZc4LkBjIbyIljyWLVN0DLgIcKB6fQTqzrv1F5UpsR2A0
 47A0AW3kbWF1/P9xuq1oW1KdUX0nI4wliabkkrVWKJKWZqzSCWlXI5KzElhpfy33KVHi
 cJ3MYfjDnYnlDmy6mNu/CNJ993q5XJQ5F6tjVbhwtb3CEGFgUm3mxUXDtV5K/zlw2jAV
 fGF9sPcW5kIxCBb11xedZ8Z2jiUfqAfsWULeVK/dKfu7DaB5ekeIPXIFlRKshCi+QKYO
 S3sQ==
X-Gm-Message-State: AC+VfDwdi6o2B6aFYWbpxxIUzueIhKXMiJzVZ249+iGcfFCYIgdf+10C
 Pr7lmRD6vYlVs/Azj9ZreMKwR5s=
X-Google-Smtp-Source: ACHHUZ6ppaovW6MrAx8+WrlMFkTJ9U/3siFa5SZn2V1/hKufKCBU2/85YLyX7aa4/3GEKAaK2QRmNQ==
X-Received: by 2002:a05:6214:ac8:b0:5ef:6142:cb05 with SMTP id
 g8-20020a0562140ac800b005ef6142cb05mr28205100qvi.20.1684862940865; 
 Tue, 23 May 2023 10:29:00 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 mx13-20020a0562142e0d00b0061a2094694fsm2919225qvb.24.2023.05.23.10.29.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 10:29:00 -0700 (PDT)
Date: Tue, 23 May 2023 13:28:59 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Du Rui <durui@linux.alibaba.com>
Message-ID: <ZGz32yw7ecKhW+lj@redhat.com>
References: <9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 19 2023 at  6:27P -0400,
Du Rui <durui@linux.alibaba.com> wrote:

> OverlayBD is a novel layering block-level image format, which is design
> for container, secure container and applicable to virtual machine,
> published in USENIX ATC '20
> https://www.usenix.org/system/files/atc20-li-huiba.pdf
> 
> OverlayBD already has a ContainerD non-core sub-project implementation
> in userspace, as an accelerated container image service
> https://github.com/containerd/accelerated-container-image
> 
> It could be much more efficient when do decompressing and mapping works
> in the kernel with the framework of device-mapper, in many circumstances,
> such as secure container runtime, mobile-devices, etc.
> 
> This patch contains a module, dm-overlaybd, provides two kinds of targets
> dm-zfile and dm-lsmt, to expose a group of block-devices contains
> OverlayBD image as a overlaid read-only block-device.
> 
> Signed-off-by: Du Rui <durui@linux.alibaba.com>

<snip, original patch here: [1] >

I appreciate that this work is being done with an eye toward
containerd "community" and standardization but based on my limited
research it appears that this format of OCI image storage/use is only
used by Alibaba? (but I could be wrong...)

But you'd do well to explain why the userspace solution isn't
acceptable. Are there security issues that moving the implementation
to kernel addresses?

I also have doubts that this solution is _actually_ more performant
than a proper filesystem based solution that allows page cache sharing
of container image data across multiple containers.

There is an active discussion about, and active development effort
for, using overlayfs + erofs for container images.  I'm reluctant to
merge this DM based container image approach without wider consensus
from other container stakeholders.

But short of reaching wider consensus on the need for these DM
targets: there is nothing preventing you from carrying these changes
in your alibaba kernel.

Mike

[1]: https://patchwork.kernel.org/project/dm-devel/patch/9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


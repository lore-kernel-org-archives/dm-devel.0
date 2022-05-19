Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4054FC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 07:02:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-CM1E26w8N0eSgXeC6ySBqA-1; Fri, 20 May 2022 03:02:00 -0400
X-MC-Unique: CM1E26w8N0eSgXeC6ySBqA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5555A8041A1;
	Fri, 20 May 2022 07:01:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3EF6E112131B;
	Fri, 20 May 2022 07:01:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 09DF3194EBB7;
	Fri, 20 May 2022 07:01:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 819E21947B8F
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 08:41:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 74B062026D2F; Thu, 19 May 2022 08:41:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7001D2026D6A
 for <dm-devel@redhat.com>; Thu, 19 May 2022 08:41:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5332385A5A8
 for <dm-devel@redhat.com>; Thu, 19 May 2022 08:41:30 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-Vj4c0KGyO82SnkvYImu-7g-1; Thu, 19 May 2022 04:41:28 -0400
X-MC-Unique: Vj4c0KGyO82SnkvYImu-7g-1
Received: by mail-wr1-f47.google.com with SMTP id h5so4952268wrb.11
 for <dm-devel@redhat.com>; Thu, 19 May 2022 01:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:date:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Zu6Jc6vPHdx+DLxnR1TmqxY9QoEaPYsoi3ifcQsAFPk=;
 b=aDb/LRvWYqx+i6kHurEKxK37lPSs7G5moMMuhG+I01PRtZvxQpqn7cWciv4o6HiMDB
 N/FYcV0dXX3U8P4vLDPQ156E3/VTfpaWfVcnxRDuAV4n/zpgbNzOcqk5dGCT9tU48dTK
 hNgKz89In19Q/AMJFIOoME7UhCeLWIQ2oTIN8JopxzSYm/kRussY/UThcoMUatWCsFrp
 P+XXbbY73UC9XP70/F70OcLHCDat2nj1Zr4VDeobyIFYuO1NciSJdgtudWOCZJMqKhBV
 vUv6Qq7TtFmek/zySlHQWuzqeV7auRDz8RBH2xKLWny4v+NhVsse93iF4HQWwJqhG0Pq
 b8Dg==
X-Gm-Message-State: AOAM532DmZdPyoz1Ib1P1l5HdZZEXYpGQGkk4qFKK9FTD0PmY4jS5sjN
 5utU1TtwF0iGwUPqCtOCPgvYJw==
X-Google-Smtp-Source: ABdhPJzrgO0iDfpb9JSw3ooLZNe9BU6AWm/lFzSbPVM+AVlG0fAnS2+rHXjUPDoqv9BQp5C+QWdrtQ==
X-Received: by 2002:adf:a459:0:b0:20d:3c9:44a1 with SMTP id
 e25-20020adfa459000000b0020d03c944a1mr2865603wra.560.1652949687055; 
 Thu, 19 May 2022 01:41:27 -0700 (PDT)
Received: from localhost ([46.69.19.220]) by smtp.gmail.com with ESMTPSA id
 i29-20020adfaadd000000b0020c5253d8casm4599719wrc.22.2022.05.19.01.41.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 19 May 2022 01:41:26 -0700 (PDT)
From: Fam Zheng <fam.zheng@bytedance.com>
X-Google-Original-From: Fam Zheng <fam@euphon.net>
Date: Thu, 19 May 2022 09:41:21 +0100
To: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20220519084121.GA6658@fam-dell>
References: <YoSSkOQaGL0sBNOI@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <YoSSkOQaGL0sBNOI@stefanha-x1.localdomain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Fri, 20 May 2022 07:01:49 +0000
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
Cc: Kevin Wolf <kwolf@redhat.com>, Kirill Tkhai <kirill.tkhai@openvz.org>,
 linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
 Xie Yongji <xieyongji@bytedance.com>, dm-devel@redhat.com, hreitz@redhat.com,
 sgarzare@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-05-18 07:30, Stefan Hajnoczi wrote:
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
> 
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

In addition, there was also qemu-tcmu, (more PoC compared to other options):

https://lists.gnu.org/archive/html/qemu-devel/2016-10/msg04408.html

Fam

> 
> Can you share more about your use cases for the dm-qcow2 target? It
> could be useful for everyone I've CCed to be aware of various efforts in
> this area.
> 
> Thanks,
> Stefan


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


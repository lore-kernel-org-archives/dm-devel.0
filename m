Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968D9EE14D3
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 06:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694068057;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qkJcAC47wGP+4ZBaYIkcYNyQEKWKGJx+gicuycVG7bM=;
	b=eeB3CqxCsqKlP3o0DUWJWtbqMf1ZUf1YCylWM4YLK6qhjegidZAIldfeIBpgjIzo90Xnzx
	VUiDRyxP7IHfCXffnOz+YDiQ9/WJIheJwQrl1TEpdIowok9cc4W+GiqKwqubswkzAMdiwx
	oZEJ1Gr2pBNAFulFrcUoSj/klweKqWQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-dsA6txdBMVevVXswIPWEgA-1; Thu, 07 Sep 2023 02:27:35 -0400
X-MC-Unique: dsA6txdBMVevVXswIPWEgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30D791C07595;
	Thu,  7 Sep 2023 06:27:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 200871460FF2;
	Thu,  7 Sep 2023 06:27:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F2D619465B5;
	Thu,  7 Sep 2023 06:27:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3CB71194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 16:19:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2540740C105A; Wed,  6 Sep 2023 16:19:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DD07400F26A
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 16:19:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F34C192BB67
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 16:19:10 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-43oDozaIPC6Qyj-kyl7lyw-1; Wed, 06 Sep 2023 12:19:07 -0400
X-MC-Unique: 43oDozaIPC6Qyj-kyl7lyw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id BF98561152;
 Wed,  6 Sep 2023 16:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C8EC433C8;
 Wed,  6 Sep 2023 16:19:04 +0000 (UTC)
Date: Wed, 6 Sep 2023 18:19:01 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
References: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
 <20230906-launenhaft-kinder-118ea59706c8@brauner>
 <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
 <20230906-aufheben-hagel-9925501b7822@brauner>
 <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
MIME-Version: 1.0
In-Reply-To: <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 07 Sep 2023 06:27:31 +0000
Subject: Re: [dm-devel] [PATCH] fix writing to the filesystem after unmount
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
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Alexander Viro <viro@zeniv.linux.org.uk>, Zdenek Kabelac <zkabelac@redhat.com>,
 linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 06, 2023 at 06:01:06PM +0200, Mikulas Patocka wrote:
> 
> 
> On Wed, 6 Sep 2023, Christian Brauner wrote:
> 
> > > > IOW, you'd also hang on any umount of a bind-mount. IOW, every
> > > > single container making use of this filesystems via bind-mounts would
> > > > hang on umount and shutdown.
> > > 
> > > bind-mount doesn't modify "s->s_writers.frozen", so the patch does nothing 
> > > in this case. I tried unmounting bind-mounts and there was no deadlock.
> > 
> > With your patch what happens if you do the following?
> > 
> > #!/bin/sh -ex
> > modprobe brd rd_size=4194304
> > vgcreate vg /dev/ram0
> > lvcreate -L 16M -n lv vg
> > mkfs.ext4 /dev/vg/lv
> > 
> > mount -t ext4 /dev/vg/lv /mnt/test
> > mount --bind /mnt/test /opt
> > mount --make-private /opt
> > 
> > dmsetup suspend /dev/vg/lv
> > (sleep 1; dmsetup resume /dev/vg/lv) &
> > 
> > umount /opt # I'd expect this to hang
> > 
> > md5sum /dev/vg/lv
> > md5sum /dev/vg/lv
> > dmsetup remove_all
> > rmmod brd
> 
> "umount /opt" doesn't hang. It waits one second (until dmsetup resume is 
> called) and then proceeds.

So unless I'm really misreading the code - entirely possible - the
umount of the bind-mount now waits until the filesystem is resumed with
your patch. And if that's the case that's a bug.

If at all, then only the last umount, the one that destroys the
superblock, should wait for the filesystem to become unfrozen.

A bind-mount shouldn't as there are still active mounts of the
filesystem (e.g., /mnt/test).

So you should see this with (unless I really misread things):

#!/bin/sh -ex
modprobe brd rd_size=4194304
vgcreate vg /dev/ram0
lvcreate -L 16M -n lv vg
mkfs.ext4 /dev/vg/lv

mount -t ext4 /dev/vg/lv /mnt/test
mount --bind /mnt/test /opt
mount --make-private /opt

dmsetup suspend /dev/vg/lv

umount /opt # This will hang with your patch?

> 
> Then, it fails with "rmmod: ERROR: Module brd is in use" because the 
> script didn't unmount /mnt/test.
> 
> > > BTW. what do you think that unmount of a frozen filesystem should properly 
> > > do? Fail with -EBUSY? Or, unfreeze the filesystem and unmount it? Or 
> > > something else?
> > 
> > In my opinion we should refuse to unmount frozen filesystems and log an
> > error that the filesystem is frozen. Waiting forever isn't a good idea
> > in my opinion.
> 
> But lvm may freeze filesystems anytime - so we'd get randomly returned 
> errors then.

So? Or you might hang at anytime.

> 
> > But this is a significant uapi change afaict so this would need to be
> > hidden behind a config option, a sysctl, or it would have to be a new
> > flag to umount2() MNT_UNFROZEN which would allow an administrator to use
> > this flag to not unmount a frozen filesystems.
> 
> The kernel currently distinguishes between kernel-initiated freeze (that 
> is used by the XFS scrub) and userspace-initiated freeze (that is used by 
> the FIFREEZE ioctl and by device-mapper initiated freeze through 
> freeze_bdev).

Yes, I'm aware.

> 
> Perhaps we could distinguish between FIFREEZE-initiated freezes and 
> device-mapper initiated freezes as well. And we could change the logic to 
> return -EBUSY if the freeze was initiated by FIFREEZE and to wait for 
> unfreeze if it was initiated by the device-mapper.

For device mapper initiated freezes you can unfreeze independent of any
filesystem mountpoint via dm ioctls.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


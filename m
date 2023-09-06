Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F10EE14A3
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 15:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694012627;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fNrw9hga1m/rgq7S914A6+V3Kpm409IIvkZWe8BB9Ws=;
	b=DZc0VVTHLcgP0mu3DolOyx2DZSqrS26UjraRbnGJRLrvx35RScALKqVyDQto9fnfr64u0j
	9RwosRmy3VY64iXkqhcpGgnMAqFg4N3NxNWjohUGYz4L8Pax/g73HxnZT1sgVbdpcaCjqG
	OaPQ2QTJ/QIYnc0RMNqR4d5riva4Vzo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-pyHBLkWGP-WkXlevmUzGPQ-1; Wed, 06 Sep 2023 11:03:45 -0400
X-MC-Unique: pyHBLkWGP-WkXlevmUzGPQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86E2E10487A4;
	Wed,  6 Sep 2023 15:03:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C4801121314;
	Wed,  6 Sep 2023 15:03:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 371CC194658D;
	Wed,  6 Sep 2023 15:03:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 637DD194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 15:03:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3097740411F; Wed,  6 Sep 2023 15:03:35 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E82AD404119;
 Wed,  6 Sep 2023 15:03:34 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id CE98630C1C07; Wed,  6 Sep 2023 15:03:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 C9EEF3FD6A; Wed,  6 Sep 2023 17:03:34 +0200 (CEST)
Date: Wed, 6 Sep 2023 17:03:34 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christian Brauner <brauner@kernel.org>
In-Reply-To: <20230906-launenhaft-kinder-118ea59706c8@brauner>
Message-ID: <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
References: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
 <20230906-launenhaft-kinder-118ea59706c8@brauner>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 6 Sep 2023, Christian Brauner wrote:

> > What happens:
> > * dmsetup suspend calls freeze_bdev, that goes to freeze_super and it
> >   increments sb->s_active
> > * then we unmount the filesystem, we go to cleanup_mnt, cleanup_mnt calls
> >   deactivate_super, deactivate_super sees that sb->s_active is 2, so it
> >   decreases it to 1 and does nothing - the umount syscall returns
> >   successfully
> > * now we have a mounted filesystem despite the fact that umount returned
> 
> That can happen for any number of reasons. Other codepaths might very
> well still hold active references to the superblock. The same thing can
> happen when you have your filesystem pinned in another mount namespace.
> 
> If you really want to be absolutely sure that the superblock is
> destroyed you must use a mechanism like fanotify which allows you to get
> notified on superblock destruction.

If the administrator runs a script that performs unmount and then back-up 
of the underlying block device, it may read corrupted data. I think that 
this is a problem.

> > @@ -1251,7 +1251,7 @@ static void cleanup_mnt(struct mount *mn
> >  	}
> >  	fsnotify_vfsmount_delete(&mnt->mnt);
> >  	dput(mnt->mnt.mnt_root);
> > -	deactivate_super(mnt->mnt.mnt_sb);
> > +	wait_and_deactivate_super(mnt->mnt.mnt_sb);
> 
> Your patch means that we hang on any umount when the filesystem is
> frozen.

Currently, if we freeze a filesystem with "fsfreeze" and unmount it, the 
mount point is removed, but the filesystem stays active and it is leaked. 
You can't unfreeze it with "fsfreeze --unfreeze" because the mount point 
is gone. (the only way how to recover it is "echo j>/proc/sysrq-trigger").

> IOW, you'd also hang on any umount of a bind-mount. IOW, every
> single container making use of this filesystems via bind-mounts would
> hang on umount and shutdown.

bind-mount doesn't modify "s->s_writers.frozen", so the patch does nothing 
in this case. I tried unmounting bind-mounts and there was no deadlock.

> You'd effectively build a deadlock trap for userspace when the
> filesystem is frozen. And nothing can make progress until that thing is
> thawed. Umount can't block if the block device is frozen.

unmounting a filesystem frozen with "fsfreeze" doesn't work in the current 
kernel. We can say that the administrator shouldn't do it. But reading the 
block device after umount finishes is something that the administrator may 
do.

BTW. what do you think that unmount of a frozen filesystem should properly 
do? Fail with -EBUSY? Or, unfreeze the filesystem and unmount it? Or 
something else?

> That msleep(1) alone is a pretty nasty hack. We should definitely not
> spin in code like this. That superblock could stay frozen for a long
> time without s_umount held. So this is spinning.
> 
> Even if we wanted to do this it would need to use a similar wait
> mechanism for the filesystem to be thawed like we do in
> thaw_super_locked().

Yes, it may be possible to rework it using a wait queue.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


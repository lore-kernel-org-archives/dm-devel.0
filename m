Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37F1EE14A0
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694016079;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HEaX6n3OdLAy+SN0RAz4Q/0EL4fs38CiQEddeRe0OXk=;
	b=BE2EqzkQGvSMriQVPQfNMxmzAnztDNmBoos/I8ahsBC19rAWMsmLV8u0o5GuRVeUJg67nC
	kqjAUEjCzeVeEK4zKAUddishMsrDgwlDxcywrf+i3Y5OMq4AXST405HgjaPWr97QdO4pM8
	Ae7rZbYkuEMYCe7WQAw+T1n+uMtJu3g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-_kBPCuKCM-inC6S5CZxi7w-1; Wed, 06 Sep 2023 12:01:16 -0400
X-MC-Unique: _kBPCuKCM-inC6S5CZxi7w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 653A992BB69;
	Wed,  6 Sep 2023 16:01:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 90D8440C2070;
	Wed,  6 Sep 2023 16:01:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4802E194658D;
	Wed,  6 Sep 2023 16:01:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4264C194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 16:01:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 33BF647FC73; Wed,  6 Sep 2023 16:01:07 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 03C07493112;
 Wed,  6 Sep 2023 16:01:07 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id E3E1330C1C07; Wed,  6 Sep 2023 16:01:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 DFDA23FD6A; Wed,  6 Sep 2023 18:01:06 +0200 (CEST)
Date: Wed, 6 Sep 2023 18:01:06 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christian Brauner <brauner@kernel.org>
In-Reply-To: <20230906-aufheben-hagel-9925501b7822@brauner>
Message-ID: <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
References: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
 <20230906-launenhaft-kinder-118ea59706c8@brauner>
 <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
 <20230906-aufheben-hagel-9925501b7822@brauner>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 6 Sep 2023, Christian Brauner wrote:

> > > IOW, you'd also hang on any umount of a bind-mount. IOW, every
> > > single container making use of this filesystems via bind-mounts would
> > > hang on umount and shutdown.
> > 
> > bind-mount doesn't modify "s->s_writers.frozen", so the patch does nothing 
> > in this case. I tried unmounting bind-mounts and there was no deadlock.
> 
> With your patch what happens if you do the following?
> 
> #!/bin/sh -ex
> modprobe brd rd_size=4194304
> vgcreate vg /dev/ram0
> lvcreate -L 16M -n lv vg
> mkfs.ext4 /dev/vg/lv
> 
> mount -t ext4 /dev/vg/lv /mnt/test
> mount --bind /mnt/test /opt
> mount --make-private /opt
> 
> dmsetup suspend /dev/vg/lv
> (sleep 1; dmsetup resume /dev/vg/lv) &
> 
> umount /opt # I'd expect this to hang
> 
> md5sum /dev/vg/lv
> md5sum /dev/vg/lv
> dmsetup remove_all
> rmmod brd

"umount /opt" doesn't hang. It waits one second (until dmsetup resume is 
called) and then proceeds.

Then, it fails with "rmmod: ERROR: Module brd is in use" because the 
script didn't unmount /mnt/test.

> > BTW. what do you think that unmount of a frozen filesystem should properly 
> > do? Fail with -EBUSY? Or, unfreeze the filesystem and unmount it? Or 
> > something else?
> 
> In my opinion we should refuse to unmount frozen filesystems and log an
> error that the filesystem is frozen. Waiting forever isn't a good idea
> in my opinion.

But lvm may freeze filesystems anytime - so we'd get randomly returned 
errors then.

> But this is a significant uapi change afaict so this would need to be
> hidden behind a config option, a sysctl, or it would have to be a new
> flag to umount2() MNT_UNFROZEN which would allow an administrator to use
> this flag to not unmount a frozen filesystems.

The kernel currently distinguishes between kernel-initiated freeze (that 
is used by the XFS scrub) and userspace-initiated freeze (that is used by 
the FIFREEZE ioctl and by device-mapper initiated freeze through 
freeze_bdev).

Perhaps we could distinguish between FIFREEZE-initiated freezes and 
device-mapper initiated freezes as well. And we could change the logic to 
return -EBUSY if the freeze was initiated by FIFREEZE and to wait for 
unfreeze if it was initiated by the device-mapper.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


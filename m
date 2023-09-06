Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1D0EE14D9
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 06:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694068058;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jz+omWdrtTJp42/CCrB85/CLUhKP+jH0Y+wxD53JOD8=;
	b=gzS+BCzWxL7nGMUQ2i5uZKI4keqYtZ26DoAgZp+kocxArIgXNB/JGqM428E+5Xll5lOANJ
	kiKPP6EdKCpWZXuFD7ol7lTxAsDBACG7fjRr6n/Y20wbslKVSXxq9GxVGa09m1IK+kqJix
	8R9OBGe1hP3mxMucwXDdfO9gfIIFX84=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-l8pHJVQANkSuaDXB0Xy-vQ-1; Thu, 07 Sep 2023 02:27:35 -0400
X-MC-Unique: l8pHJVQANkSuaDXB0Xy-vQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 859E81817934;
	Thu,  7 Sep 2023 06:27:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 751451460FE7;
	Thu,  7 Sep 2023 06:27:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 157301946A43;
	Thu,  7 Sep 2023 06:27:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E6BD2194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 14:33:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D031A140E963; Wed,  6 Sep 2023 14:33:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C9121140E950
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 14:33:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2A99877286
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 14:33:45 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-Ms6PbyfQOuenaoC6cKbSJg-1; Wed,
 06 Sep 2023 10:33:42 -0400
X-MC-Unique: Ms6PbyfQOuenaoC6cKbSJg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D9E0DB81A0D;
 Wed,  6 Sep 2023 14:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30F3C433C8;
 Wed,  6 Sep 2023 14:27:31 +0000 (UTC)
Date: Wed, 6 Sep 2023 16:27:28 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20230906-launenhaft-kinder-118ea59706c8@brauner>
References: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
MIME-Version: 1.0
In-Reply-To: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

On Wed, Sep 06, 2023 at 03:26:21PM +0200, Mikulas Patocka wrote:
> lvm may suspend any logical volume anytime. If lvm suspend races with
> unmount, it may be possible that the kernel writes to the filesystem after
> unmount successfully returned. The problem can be demonstrated with this
> script:
> 
> #!/bin/sh -ex
> modprobe brd rd_size=4194304
> vgcreate vg /dev/ram0
> lvcreate -L 16M -n lv vg
> mkfs.ext4 /dev/vg/lv
> mount -t ext4 /dev/vg/lv /mnt/test
> dmsetup suspend /dev/vg/lv
> (sleep 1; dmsetup resume /dev/vg/lv) &
> umount /mnt/test
> md5sum /dev/vg/lv
> md5sum /dev/vg/lv
> dmsetup remove_all
> rmmod brd
> 
> The script unmounts the filesystem and runs md5sum twice, the result is
> that these two invocations return different hash.
> 
> What happens:
> * dmsetup suspend calls freeze_bdev, that goes to freeze_super and it
>   increments sb->s_active
> * then we unmount the filesystem, we go to cleanup_mnt, cleanup_mnt calls
>   deactivate_super, deactivate_super sees that sb->s_active is 2, so it
>   decreases it to 1 and does nothing - the umount syscall returns
>   successfully
> * now we have a mounted filesystem despite the fact that umount returned

That can happen for any number of reasons. Other codepaths might very
well still hold active references to the superblock. The same thing can
happen when you have your filesystem pinned in another mount namespace.

If you really want to be absolutely sure that the superblock is
destroyed you must use a mechanism like fanotify which allows you to get
notified on superblock destruction.

> @@ -1251,7 +1251,7 @@ static void cleanup_mnt(struct mount *mn
>  	}
>  	fsnotify_vfsmount_delete(&mnt->mnt);
>  	dput(mnt->mnt.mnt_root);
> -	deactivate_super(mnt->mnt.mnt_sb);
> +	wait_and_deactivate_super(mnt->mnt.mnt_sb);

Your patch means that we hang on any umount when the filesystem is
frozen. IOW, you'd also hang on any umount of a bind-mount. IOW, every
single container making use of this filesystems via bind-mounts would
hang on umount and shutdown.

You'd effectively build a deadlock trap for userspace when the
filesystem is frozen. And nothing can make progress until that thing is
thawed. Umount can't block if the block device is frozen.

>  	mnt_free_id(mnt);
>  	call_rcu(&mnt->mnt_rcu, delayed_free_vfsmnt);
>  }
> Index: linux-2.6/fs/super.c
> ===================================================================
> --- linux-2.6.orig/fs/super.c	2023-09-05 21:09:16.000000000 +0200
> +++ linux-2.6/fs/super.c	2023-09-06 09:52:20.000000000 +0200
> @@ -36,6 +36,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/user_namespace.h>
>  #include <linux/fs_context.h>
> +#include <linux/delay.h>
>  #include <uapi/linux/mount.h>
>  #include "internal.h"
>  
> @@ -365,6 +366,25 @@ void deactivate_super(struct super_block
>  EXPORT_SYMBOL(deactivate_super);
>  
>  /**
> + *	wait_and_deactivate_super	-	wait for unfreeze and drop a reference
> + *	@s: superblock to deactivate
> + *
> + *	Variant of deactivate_super(), except that we wait if the filesystem is
> + *	frozen. This is required on unmount, to make sure that the filesystem is
> + *	really unmounted when this function returns.
> + */
> +void wait_and_deactivate_super(struct super_block *s)
> +{
> +	down_write(&s->s_umount);
> +	while (s->s_writers.frozen != SB_UNFROZEN) {
> +		up_write(&s->s_umount);
> +		msleep(1);
> +		down_write(&s->s_umount);
> +	}
> +	deactivate_locked_super(s);

That msleep(1) alone is a pretty nasty hack. We should definitely not
spin in code like this. That superblock could stay frozen for a long
time without s_umount held. So this is spinning.

Even if we wanted to do this it would need to use a similar wait
mechanism for the filesystem to be thawed like we do in
thaw_super_locked().

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


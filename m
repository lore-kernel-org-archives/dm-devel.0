Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB4BAEE14A0
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694014217;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vi7aMf1r1U6cDpi2nhY8Si7AGhAN3l3LJZLDWN6pYyE=;
	b=dEYJtKoMUKq+L5BcLK70ftXrLNkyDKRwYVyJurneMf00zgG5kYoimqgdfhk3i2WuQGs6UN
	iTlo93tNHd1t30uU3yiDH/eUt1FjMibbGjmfHb4pN2D81mTvVRi1iY21wl8vVXoU2SD9Cq
	ocAP0yIg/qPli/C3os2i5lBeeDGWmv4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-rT91TU00OPe368sZ1NajxA-1; Wed, 06 Sep 2023 11:30:15 -0400
X-MC-Unique: rT91TU00OPe368sZ1NajxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F4DD3813F3C;
	Wed,  6 Sep 2023 15:30:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2D91C140E950;
	Wed,  6 Sep 2023 15:30:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B908A194658D;
	Wed,  6 Sep 2023 15:30:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 75010194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 15:30:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2FA2C20BAE37; Wed,  6 Sep 2023 15:30:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 27F7021D4F3F
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 15:30:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 096B9182EAF2
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 15:30:06 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-NcioXWotOkCh2TKchfx98Q-1; Wed,
 06 Sep 2023 11:30:04 -0400
X-MC-Unique: NcioXWotOkCh2TKchfx98Q-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 1102ACE16E4;
 Wed,  6 Sep 2023 15:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C0EC433C8;
 Wed,  6 Sep 2023 15:22:46 +0000 (UTC)
Date: Wed, 6 Sep 2023 08:22:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20230906152245.GD28160@frogsfrogsfrogs>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Cc: Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>,
 Zdenek Kabelac <zkabelac@redhat.com>, linux-fsdevel@vger.kernel.org
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
> * we call md5sum, this waits for the block device being unblocked
> * dmsetup resume unblocks the block device and calls thaw_bdev, that calls
>   thaw_super and thaw_super_locked
> * thaw_super_locked calls deactivate_locked_super, this actually drops the
>   refcount and performs the unmount. The unmount races with md5sum. md5sum
>   wins the race and it returns the hash of the filesystem before it was
>   unmounted
> * the second md5sum returns the hash after the filesystem was unmounted
> 
> In order to fix this bug, this patch introduces a new function
> wait_and_deactivate_super that will wait if the filesystem is frozen and
> perform deactivate_locked_super only after that.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  fs/namespace.c     |    2 +-
>  fs/super.c         |   20 ++++++++++++++++++++
>  include/linux/fs.h |    1 +
>  3 files changed, 22 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/fs/namespace.c
> ===================================================================
> --- linux-2.6.orig/fs/namespace.c	2023-09-06 09:45:54.000000000 +0200
> +++ linux-2.6/fs/namespace.c	2023-09-06 09:47:15.000000000 +0200
> @@ -1251,7 +1251,7 @@ static void cleanup_mnt(struct mount *mn
>  	}
>  	fsnotify_vfsmount_delete(&mnt->mnt);
>  	dput(mnt->mnt.mnt_root);
> -	deactivate_super(mnt->mnt.mnt_sb);
> +	wait_and_deactivate_super(mnt->mnt.mnt_sb);
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

Instead of msleep, could you use wait_var_event_killable like
wait_for_partially_frozen() does?

--D

> +	deactivate_locked_super(s);
> +}
> +
> +/**
>   *	grab_super - acquire an active reference
>   *	@s: reference we are trying to make active
>   *
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h	2023-09-05 21:09:16.000000000 +0200
> +++ linux-2.6/include/linux/fs.h	2023-09-06 09:46:56.000000000 +0200
> @@ -2262,6 +2262,7 @@ void kill_anon_super(struct super_block
>  void kill_litter_super(struct super_block *sb);
>  void deactivate_super(struct super_block *sb);
>  void deactivate_locked_super(struct super_block *sb);
> +void wait_and_deactivate_super(struct super_block *sb);
>  int set_anon_super(struct super_block *s, void *data);
>  int set_anon_super_fc(struct super_block *s, struct fs_context *fc);
>  int get_anon_bdev(dev_t *);
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


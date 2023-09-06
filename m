Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF3FEE14D7
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 06:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694068057;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6LGwTSuBDD0+OOeMoPtRjV4FCjLNX0smbBhT1+dZLes=;
	b=AyqY6xy5YlfDlzn+q4OYlOraVf1YKMENic9cvkLUa3KQotYrZ6asToMA1MJpHpSemyX7vy
	VjzuVDaoMBYZV+Xf5bxdwEp54kXy7ChlcU2kx7A03GE5X3T8mfOeECa6WF+vfZtGnFqb/o
	z8lg7qcuTXaEbsI1rYSUni7YIihDlZg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-ZWQ008xmMEqULJ9vWHqxIw-1; Thu, 07 Sep 2023 02:27:34 -0400
X-MC-Unique: ZWQ008xmMEqULJ9vWHqxIw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7297A823D5E;
	Thu,  7 Sep 2023 06:27:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0FE5A412F2D0;
	Thu,  7 Sep 2023 06:27:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0AE4194658F;
	Thu,  7 Sep 2023 06:27:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD710194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 15:33:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 78CC3C03295; Wed,  6 Sep 2023 15:33:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 700E8C15BB8
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 15:33:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37F4293F181
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 15:33:39 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-ypGeiB0yOHqRYx8QCioCWA-1; Wed,
 06 Sep 2023 11:33:35 -0400
X-MC-Unique: ypGeiB0yOHqRYx8QCioCWA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E69D6B81897;
 Wed,  6 Sep 2023 15:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6559C433C8;
 Wed,  6 Sep 2023 15:33:30 +0000 (UTC)
Date: Wed, 6 Sep 2023 17:33:27 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20230906-aufheben-hagel-9925501b7822@brauner>
References: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
 <20230906-launenhaft-kinder-118ea59706c8@brauner>
 <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
MIME-Version: 1.0
In-Reply-To: <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Currently, if we freeze a filesystem with "fsfreeze" and unmount it, the 
> mount point is removed, but the filesystem stays active and it is leaked. 
> You can't unfreeze it with "fsfreeze --unfreeze" because the mount point 
> is gone. (the only way how to recover it is "echo j>/proc/sysrq-trigger").

You can of course always remount and unfreeze it.

> > IOW, you'd also hang on any umount of a bind-mount. IOW, every
> > single container making use of this filesystems via bind-mounts would
> > hang on umount and shutdown.
> 
> bind-mount doesn't modify "s->s_writers.frozen", so the patch does nothing 
> in this case. I tried unmounting bind-mounts and there was no deadlock.

With your patch what happens if you do the following?

#!/bin/sh -ex
modprobe brd rd_size=4194304
vgcreate vg /dev/ram0
lvcreate -L 16M -n lv vg
mkfs.ext4 /dev/vg/lv

mount -t ext4 /dev/vg/lv /mnt/test
mount --bind /mnt/test /opt
mount --make-private /opt

dmsetup suspend /dev/vg/lv
(sleep 1; dmsetup resume /dev/vg/lv) &

umount /opt # I'd expect this to hang

md5sum /dev/vg/lv
md5sum /dev/vg/lv
dmsetup remove_all
rmmod brd

> BTW. what do you think that unmount of a frozen filesystem should properly 
> do? Fail with -EBUSY? Or, unfreeze the filesystem and unmount it? Or 
> something else?

In my opinion we should refuse to unmount frozen filesystems and log an
error that the filesystem is frozen. Waiting forever isn't a good idea
in my opinion.

But this is a significant uapi change afaict so this would need to be
hidden behind a config option, a sysctl, or it would have to be a new
flag to umount2() MNT_UNFROZEN which would allow an administrator to use
this flag to not unmount a frozen filesystems.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


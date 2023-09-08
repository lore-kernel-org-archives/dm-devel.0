Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB11EE8015
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 16:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694192369;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b0HCGjr3y2EsYqskQo5e064+NpvFbGwLQY19P/CWKI4=;
	b=dl3OTy92V/sFgb+1PQZO3GrFyPyMMQvVeP/ofZUcxYBIElNdAexBjHAm7yf2FBZUnCFo54
	XHP2YD3k359uiWS8yCvlDBZ3Q33jqCkMH67APWHj3ywdLyIFgFFHxI4YtHRHnbNbb4Kq4o
	PM8MzXD/IxnLdmIhpMz8lrDsOWrfyuc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-BzQLm6ebPsm9Em3sZudRGA-1; Fri, 08 Sep 2023 12:59:25 -0400
X-MC-Unique: BzQLm6ebPsm9Em3sZudRGA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7F8F3C1ACDC;
	Fri,  8 Sep 2023 16:59:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 55017140E967;
	Fri,  8 Sep 2023 16:59:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 035DD194658C;
	Fri,  8 Sep 2023 16:59:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0BF1F1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 16:59:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC502493112; Fri,  8 Sep 2023 16:59:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4B89493110
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 16:59:20 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C52851C29784
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 16:59:20 +0000 (UTC)
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-_2V9gLfVODmF0_Am_PHbJg-1; Fri,
 08 Sep 2023 12:59:19 -0400
X-MC-Unique: _2V9gLfVODmF0_Am_PHbJg-1
Received: from quad.stoffel.org (097-095-183-072.res.spectrum.com
 [97.95.183.72])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mail.stoffel.org (Postfix) with ESMTPSA id 1BBD61E4FA;
 Fri,  8 Sep 2023 12:49:08 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
 id B999DA8915; Fri,  8 Sep 2023 12:49:07 -0400 (EDT)
MIME-Version: 1.0
Message-ID: <25851.20611.732252.455034@quad.stoffel.home>
Date: Fri, 8 Sep 2023 12:49:07 -0400
From: "John Stoffel" <john@stoffel.org>
To: Christian Brauner <brauner@kernel.org>
In-Reply-To: <20230908-verflachen-neudefinition-4da649d673a9@brauner>
References: <20230906-aufheben-hagel-9925501b7822@brauner>
 <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
 <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
 <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
 <20230907094457.vcvmixi23dk3pzqe@quack3>
 <20230907-abgrenzen-achtung-b17e9a1ad136@brauner>
 <513f337e-d254-2454-6197-82df564ed5fc@redhat.com>
 <20230908073244.wyriwwxahd3im2rw@quack3>
 <86235d7a-a7ea-49da-968e-c5810cbf4a7b@redhat.com>
 <20230908102014.xgtcf5wth2l2cwup@quack3>
 <20230908-verflachen-neudefinition-4da649d673a9@brauner>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Zdenek Kabelac <zkabelac@redhat.com>,
 linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: stoffel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>>>>> "Christian" == Christian Brauner <brauner@kernel.org> writes:

>> Well, currently you click some "Eject / safely remove / whatever" button
>> and then you get a "wait" dialog until everything is done after which
>> you're told the stick is safe to remove. What I imagine is that the "wait"
>> dialog needs to be there while there are any (or exclusive at minimum) openers
>> of the device. Not until umount(2) syscall has returned. And yes, the

> Agreed. umount(2) doesn't give guarantees about a filesystem being
> really gone once it has returned. And it really shouldn't. There's
> too many cases where that doesn't work and it's not a commitment we
> should make.

So how the heck is someone supposed to know, from userspace, that a
filesystem is unmounted?  Just wearing my SysAdmin hat, this strikes
me as really potentially painful and annoying.  But then again, so are
bind mounts from alot of views too.  

Don't people remember how bad it can be when you are trying to
shutdown and system and it hangs because a remote NFS server is down
and not responding?  And your client system hangs completely?  

> And there are ways to wait until superblock shutdown that I've
> mentioned before in other places where it somehow really
> matters. inotify's IN_UMOUNT will notify about superblock
> shutdown. IOW, when it really hits generic_shutdown_super() which
> can only be hit after unfreezing as that requires active references.

Can we maybe invert this discussion and think about it from the
userspace side of things?  How does the user(space) mount/unmount
devices cleanly and reliably?  

> So this really can be used to wait for a filesystem to go away across
> all namespaces, and across filesytem freezing and it's available to
> unprivileged users. Simple example:

> # shell 1
> sudo mount -t xfs /dev/sda /mnt
> sudo mount --bind /mnt /opt
> inotifywait -e unmount /mnt

> #shell 2
> sudo umount /opt # nothing happens in shell 1
> sudo umount /mnt # shell 1 gets woken

So what makes this *useful* to anyone?  Why doesn't the bind mount
A) lock /mnt into place, but B) give you some way of seeing that
there's a bindmount in place?  

>> corner-cases. So does the current behavior, I agree, but improving
>> situation for one usecase while breaking another usecase isn't really a way
>> forward...

> Agreed.

>> Well, the filesystem (struct superblock to be exact) is invisible
>> in /proc/mounts (or whatever), that is true. But it is still very
>> much associated with that block device and if you do 'mount
>> <device> <mntpoint>', you'll get it back. But yes, the filesystem
>> will not go away

Then should it be unmountable in the first place?  I mean yes, we
always need a way to force an unmount no matter what, even if that
breaks some other process on the system, but for regular use,
shouldn't it just give back an error like:

	  /mnt in use by bind mount /opt

or something like that?  Give the poor sysadmin some information on
what's going on here. 

> And now we at least have an api to detect that case and refuse to reuse
> the superblock.

>> until all references to it are dropped and you cannot easily find
>> who holds those references and how to get rid of them.

ding ding ding!!!!  I don't want to have to run 'lsof' or something
like that.

> Namespaces make this even messier. You have no easy way of knowing
> whether the filesystem isn't pinned somewhere else through an
> explicit bind-mount or when it was copied during mount namespace
> creation.

This is the biggest downside of namespaces and bind mounts in my
mind.  The lack of traceability back to the source.  

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


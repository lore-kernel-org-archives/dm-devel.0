Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E089EE8014
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694185592;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E++ZzpHQr5kQU6CiS0SS1gJG7mhvq7yOUQ+NxZr90zA=;
	b=ItkQgy0DniL+LkERAJmJLpeQLybl85Y9pJuKYdcRyrP+icEMjrTshjZWpSH7gkkwe47+9b
	YpctSJXwllLiZhs52dmeuRETahwY1L7/wwKutq/6LHOoNeEzUnFvgN8ihY9zvny8fCrBbq
	Ce2CIZucptg72b3OHU1rqAL/f6RLkaY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-qibPvnlZMqq0iLX8xKobBA-1; Fri, 08 Sep 2023 11:06:30 -0400
X-MC-Unique: qibPvnlZMqq0iLX8xKobBA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5388F89CB11;
	Fri,  8 Sep 2023 15:06:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9C89021EE566;
	Fri,  8 Sep 2023 15:06:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6DF2219466DF;
	Fri,  8 Sep 2023 15:06:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8AA94194658F
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 12:02:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79BB540411F; Fri,  8 Sep 2023 12:02:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 71F54403171
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 12:02:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FAC680D75F
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 12:02:51 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-519-qI_ivfTOOpCgqqfviFeDuQ-1; Fri,
 08 Sep 2023 08:02:49 -0400
X-MC-Unique: qI_ivfTOOpCgqqfviFeDuQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 85D8ECE0221;
 Fri,  8 Sep 2023 12:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7C7C433C7;
 Fri,  8 Sep 2023 12:02:41 +0000 (UTC)
Date: Fri, 8 Sep 2023 14:02:38 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Message-ID: <20230908-verflachen-neudefinition-4da649d673a9@brauner>
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
MIME-Version: 1.0
In-Reply-To: <20230908102014.xgtcf5wth2l2cwup@quack3>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Fri, 08 Sep 2023 15:06:24 +0000
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
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Zdenek Kabelac <zkabelac@redhat.com>,
 linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Well, currently you click some "Eject / safely remove / whatever" button
> and then you get a "wait" dialog until everything is done after which
> you're told the stick is safe to remove. What I imagine is that the "wait"
> dialog needs to be there while there are any (or exclusive at minimum) openers
> of the device. Not until umount(2) syscall has returned. And yes, the

Agreed. umount(2) doesn't give guarantees about a filesystem being
really gone once it has returned. And it really shouldn't. There's too
many cases where that doesn't work and it's not a commitment we should
make.

And there are ways to wait until superblock shutdown that I've mentioned
before in other places where it somehow really matters. inotify's
IN_UMOUNT will notify about superblock shutdown. IOW, when it really
hits generic_shutdown_super() which can only be hit after unfreezing as
that requires active references.

So this really can be used to wait for a filesystem to go away across
all namespaces, and across filesytem freezing and it's available to
unprivileged users. Simple example:

# shell 1
sudo mount -t xfs /dev/sda /mnt
sudo mount --bind /mnt /opt
inotifywait -e unmount /mnt

#shell 2
sudo umount /opt # nothing happens in shell 1
sudo umount /mnt # shell 1 gets woken

> corner-cases. So does the current behavior, I agree, but improving
> situation for one usecase while breaking another usecase isn't really a way
> forward...

Agreed.

> Well, the filesystem (struct superblock to be exact) is invisible in
> /proc/mounts (or whatever), that is true. But it is still very much
> associated with that block device and if you do 'mount <device>
> <mntpoint>', you'll get it back. But yes, the filesystem will not go away

And now we at least have an api to detect that case and refuse to reuse
the superblock.

> until all references to it are dropped and you cannot easily find who holds
> those references and how to get rid of them.

Namespaces make this even messier. You have no easy way of knowing
whether the filesystem isn't pinned somewhere else through an explicit
bind-mount or when it was copied during mount namespace creation.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

